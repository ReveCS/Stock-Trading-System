CREATE TABLE Location (
ZipCode MEDIUMINT,
City VARCHAR(20) NOT NULL,
State VARCHAR(20) NOT NULL,
PRIMARY KEY (ZipCode) );

CREATE TABLE Person (
SSN INTEGER CHECK (SSN > 0 AND SSN < 1000000000),
LastName VARCHAR(20) NOT NULL,
FirstName VARCHAR(20) NOT NULL,
Address VARCHAR(20),
ZipCode MEDIUMINT,
Telephone BIGINT,
PRIMARY KEY (SSN),
FOREIGN KEY (ZipCode) REFERENCES Location (ZipCode)
ON DELETE NO ACTION
ON UPDATE CASCADE );

CREATE TABLE Employee (
EmpId INTEGER,
StartDate DATE,
HourlyRate INTEGER,
PRIMARY KEY (EmpId),
FOREIGN KEY (EmpId) REFERENCES Person (SSN)
ON DELETE NO ACTION
ON UPDATE CASCADE );

CREATE TABLE Clients (
ClientId INTEGER,
Email VARCHAR(32),
CreditCardNumber BIGINT,
Rating INTEGER,
PRIMARY KEY (ClientId),
FOREIGN KEY (ClientId) REFERENCES Person (SSN)
ON DELETE NO ACTION
ON UPDATE CASCADE );

CREATE TABLE Stock (
StockSymbol VARCHAR(20) NOT NULL,
CompanyName VARCHAR(20) NOT NULL,
Type VARCHAR(20) NOT NULL,
PricePerShare DECIMAL(13,2),
NumShares INT NOT NULL DEFAULT 1,
PRIMARY KEY (StockSymbol) );

CREATE TABLE PriceHistory (
StockSymbol VARCHAR(20) NOT NULL,
DateTime DATETIME,
PricePerShare DECIMAL(13,2),
PRIMARY KEY (StockSymbol, DateTime, PricePerShare),
FOREIGN KEY (StockSymbol) REFERENCES Stock (StockSymbol) );

CREATE TABLE Account (
ClientId INTEGER,
AccNum INTEGER,	
DateOpened DATE,
PRIMARY KEY (ClientId, AccNum),
FOREIGN KEY (ClientId) REFERENCES Clients (ClientId)
ON DELETE NO ACTION
ON UPDATE CASCADE );

CREATE TABLE StockPortfolio (
ClientId INTEGER,
AccNum INTEGER,
Stock VARCHAR(20) NOT NULL,
NumShares INT NOT NULL DEFAULT 1,
PRIMARY KEY (Stock),
FOREIGN KEY (Stock)  REFERENCES Stock(StockSymbol),
FOREIGN KEY (ClientId, AccNum) REFERENCES Account(ClientId, AccNum)
);

CREATE TABLE Transactions (
TxnId INTEGER NOT NULL AUTO_INCREMENT,
Fee DECIMAL(13,2),
DateTime DATETIME,
PricePerShare DECIMAL(13,2),
PRIMARY KEY (TxnId) );

CREATE TABLE Orders (
OrderId INTEGER NOT NULL AUTO_INCREMENT,
NumShares INTEGER,
PricePerShare DECIMAL(13,2),
DateTime DATETIME,
Percentage DECIMAL(5,3),
PriceType VARCHAR(13) CHECK ( PriceType IN ('Market', 'MarketOnClose', 'TrailingStop', 'HiddenStop') ),
OrderType VARCHAR(4) CHECK ( OrderType IN ('Buy', 'Sell') ),
PRIMARY KEY (OrderId) );

CREATE TABLE Trade (
AccountId INTEGER,
ClientId INTEGER,
BrokerId INTEGER,
TransactionId INTEGER,
OrderId INTEGER,
StockId VARCHAR(20),
PRIMARY KEY (AccountId, ClientId, BrokerId, TransactionId, OrderId, StockId),
FOREIGN KEY (ClientId, AccountID) REFERENCES Account (ClientId, AccNum)
ON DELETE NO ACTION
ON UPDATE CASCADE,
FOREIGN KEY (BrokerId) REFERENCES Employee (EmpId)
ON DELETE NO ACTION
ON UPDATE CASCADE,
FOREIGN KEY (TransactionID) REFERENCES Transactions (TxnId)
ON DELETE NO ACTION
ON UPDATE CASCADE,
FOREIGN KEY (OrderId) REFERENCES Orders (OrderId)
ON DELETE NO ACTION
ON UPDATE CASCADE,
FOREIGN KEY (StockId) REFERENCES Stock (StockSymbol)
ON DELETE NO ACTION
ON UPDATE CASCADE );

# Set the share price of a stock (for simulating market fluctuations in a stock's share price)
DELIMITER $$
CREATE PROCEDURE SetSharePrice(Price INT, InputStock VARCHAR(20))
BEGIN
	# Update SharePrice in SharePrice history table
	INSERT INTO PriceHistory (StockSymbol, DateTime, PricePerShare) VALUES
    ((SELECT StockSymbol FROM Stock WHERE StockSymbol = InputStock), 
    NOW(), 
    (SELECT PricePerShare FROM Stock WHERE StockSymbol = InputStock));
	
    UPDATE Stock 
	SET SharePrice = Price
	WHERE StockSymbol = InputStock;
END$$
DELIMITER ;

# Add, Edit and Delete information for an employee
GRANT SELECT, INSERT, UPDATE, DELETE
ON Employees
TO ;

START TRANSACTION;
INSERT INTO Employees VALUES (?);
COMMIT;

START TRANSACTION;
UPDATE Employees SET ?=?;
COMMIT;

START TRANSACTION;
DELETE FROM Employees WHERE ?=?;
COMMIT;

# Obtain a sales report for a particular month
DELIMITER $$
CREATE PROCEDURE SalesReport (InputMonth INT)
BEGIN 
	START TRANSACTION;
		SELECT trans.DateTime, 
		st.StockSymbol,
		trans.PricePerShare,
		ord.NumShares,
		trans.PricePerShare*ord.NumShares AS 'Total Sale'
		FROM Transactions AS trans
		INNER JOIN Trade AS t ON trans.TxnId = t.TransactionId
		INNER JOIN Stock AS st ON st.StockSymbol = t.StockId
        INNER JOIN Orders AS ord ON ord.OrderId = t.OrderId
		WHERE (SELECT MONTH(trans.DateTime)) = InputMonth;
   COMMIT;
END$$
DELIMITER ;

CALL SalesReport(11);

# Produce a comprehensive listing of all stocks
DELIMITER $$
CREATE PROCEDURE StockList ()
BEGIN 
	START TRANSACTION;
		SELECT * FROM Stock;
	COMMIT;
END$$
DELIMITER ;

CALL StockList();

# Produce a list of orders by stock symbol or by customer name
DELIMITER $$
CREATE PROCEDURE OrderListByStock () 
BEGIN
	START TRANSACTION;
		SELECT t.StockId, 
		ord.OrderId, 
		ord.DateTime, 
		ord.OrderType,
		ord.PriceType,
		ord.NumShares,	
		ord.PricePerShare
		FROM Orders as ord 
		INNER JOIN Trade as t ON ord.OrderId = t.OrderId
		ORDER BY StockId;
	COMMIT;
END$$
DELIMITER ;

CALL OrderListByStock();

DELIMITER $$
CREATE PROCEDURE OrderListByCustomer () 
BEGIN
START TRANSACTION;
		SELECT t.StockId, 
		ord.OrderId, 
       		p.LastName,
        		p.FirstName,
		ord.DateTime, 
		ord.OrderType,
		ord.PriceType,
		ord.NumShares,	
		ord.PricePerShare
		FROM Orders as ord 
		INNER JOIN Trade as t ON ord.OrderId = t.OrderId
        		INNER JOIN Person AS p ON p.SSN = t.ClientId
		ORDER BY LastName;
	COMMIT;
END$$
DELIMITER ;

CALL OrderListByCustomer();

# Produce a summary listing of revenue generated by a particular stock, stock type, or customer

# Input: Stock name (i.e IBM)
DELIMITER $$
CREATE PROCEDURE StockRevenueSummary(Stock VARCHAR(20) )
BEGIN
	START TRANSACTION;
		SELECT t.StockId,
        ord.OrderType,
        ord.NumShares,
        trans.PricePerShare,
        (-1 * SUM((SELECT trans.PricePerShare*ord.NumShares
        WHERE ord.OrderType = 'Buy')) + SUM((SELECT trans.PricePerShare*ord.NumShares
        WHERE ord.OrderType = 'Sell'))) AS 'REVENUE'
        FROM Trade as t
        INNER JOIN Transactions AS trans ON trans.TxnId = t.TransactionId
        INNER JOIN Orders AS ord ON ord.OrderId = t.OrderId
        WHERE t.StockId = Stock;
	COMMIT;
END$$
DELIMITER ;

CALL StockRevenueSummary('GM');

# Input Stock type (i.e 'computer')
DELIMITER $$
CREATE PROCEDURE StockTypeRevenueSummary(StockType VARCHAR(20) )
BEGIN
	START TRANSACTION;
		SELECT st.Type,
        (-1 * SUM((SELECT trans.PricePerShare*ord.NumShares
        WHERE ord.OrderType = 'Buy')) + SUM((SELECT trans.PricePerShare*ord.NumShares
        WHERE ord.OrderType = 'Sell'))) AS 'REVENUE'
        FROM Trade as t
        INNER JOIN Transactions AS trans ON trans.TxnId = t.TransactionId
        INNER JOIN Orders AS ord ON ord.OrderId = t.OrderId
        INNER JOIN Stock AS st ON st.StockSymbol = t.StockId
        WHERE st.Type = StockType;
	COMMIT;
END$$
DELIMITER ;

CALL StockTypeRevenueSummary('automotive');

# Input Customer ID (i.e 444444444)	
DELIMITER $$
CREATE PROCEDURE CustomerRevenueSummary(Customer INTEGER)
BEGIN
	START TRANSACTION;
		SELECT t.ClientId,
        (-1 * SUM((SELECT trans.PricePerShare*ord.NumShares
        WHERE ord.OrderType = 'Buy')) + SUM((SELECT trans.PricePerShare*ord.NumShares
        WHERE ord.OrderType = 'Sell'))) AS 'REVENUE'
        FROM Trade as t
        INNER JOIN Transactions AS trans ON trans.TxnId = t.TransactionId
        INNER JOIN Orders AS ord ON ord.OrderId = t.OrderId
        WHERE t.ClientId = Customer;
	COMMIT;
END$$
DELIMITER ;

CALL CustomerRevenueSummary(444444444);

# Determine which customer representative generated most total revenue
DELIMITER $$
CREATE PROCEDURE CustomerRepMostRevenue()
BEGIN
	START TRANSACTION;
		SELECT t.BrokerId,
        (-1 * SUM((SELECT trans.PricePerShare*ord.NumShares
        WHERE ord.OrderType = 'Buy')) + SUM((SELECT trans.PricePerShare*ord.NumShares
        WHERE ord.OrderType = 'Sell'))) AS 'REVENUE'
        FROM Trade as t
        INNER JOIN Transactions AS trans ON trans.TxnId = t.TransactionId
        INNER JOIN Orders AS ord ON ord.OrderId = t.OrderId 
        ORDER BY 'REVENUE' DESC
        LIMIT 1;
	COMMIT;
END$$
DELIMITER ;

# Determine which customer generated most total revenue
DELIMITER $$
CREATE PROCEDURE CustomerMostRevenue()
BEGIN
	START TRANSACTION;
		SELECT t.ClientId,
        (-1 * SUM((SELECT trans.PricePerShare*ord.NumShares
        WHERE ord.OrderType = 'Buy')) + SUM((SELECT trans.PricePerShare*ord.NumShares
        WHERE ord.OrderType = 'Sell'))) AS 'REVENUE'
        FROM Trade as t
        INNER JOIN Transactions AS trans ON trans.TxnId = t.TransactionId
        INNER JOIN Orders AS ord ON ord.OrderId = t.OrderId 
        ORDER BY 'REVENUE' DESC
        LIMIT 1;
	COMMIT;
END$$
DELIMITER ;

CALL CustomerMostRevenue();

# Produce a list of most actively traded stocks
DELIMITER $$
CREATE PROCEDURE ActiveStockList() 
BEGIN
	START TRANSACTION;
		SELECT t.StockId AS 'Most Actively Traded Stocks', 
        COUNT(*) AS Trades
		FROM Trade AS t 
		GROUP BY StockId
		ORDER BY Trades DESC;
	COMMIT;
END$$
DELIMITER ;

CALL ActiveStockList();

DROP Table Customers;
DROP Table Orders;
DROP Table Shippings;

INSERT INTO Location VALUES (11790, 'Stony Brook', 'NY');
INSERT INTO Location VALUES (93536, 'Los Angeles', 'CA');
INSERT INTO Location VALUES (11794, 'Stony Brook', 'NY');

INSERT INTO Person VALUES (111111111, 'Yang', 'Shang', '123 Success Street', 11790, 5166328959);
INSERT INTO Person VALUES (222222222, 'Du', 'Victor', '456 Fortune Road', 11790, 5166324360);
INSERT INTO Person VALUES (333333333, 'Smith', 'John', '789 Peace Blvd', 93536, 3154434321);
INSERT INTO Person VALUES (444444444, 'Philip', 'Lewis', '135 Knowledge Lane', 11794, 5166668888);
INSERT INTO Person VALUES (123456789, 'Smith', 'David', '123 College road', 11790, 5162152345);
INSERT INTO Person VALUES (789123456, 'Warren', 'David', '456 Sunken Street', 11790, 5162152345);

INSERT INTO Employee VALUES (123456789, '2005-11-01', 60 );
INSERT INTO Employee VALUES (789123456, '2006-02-02', 50 );

INSERT INTO Stock VALUES ('GM',	'General Motors', 'automotive', 34.23, 1000);
INSERT INTO Stock VALUES ('IBM', 'IBM', 'computer', 91.41, 500);
INSERT INTO Stock VALUES ('F', 'Ford', 'automotive', 9.0, 750);

INSERT INTO Clients VALUES (111111111, 'syang@cs.sunysb.edu', 1234567812345678, 1);
INSERT INTO Clients VALUES (222222222, 'vicdu@cs.sunysb.edu', 5678123456781234, 1);
INSERT INTO Clients VALUES (333333333, 'jsmith@ic.sunysb.edu', 2345678923456789, 1);
INSERT INTO Clients VALUES (444444444, 'pml@cs.sunysb.edu', 6789234567892345, 1);

INSERT INTO Account VALUES (444444444, 1, '2006-10-01');
INSERT INTO Account VALUES (222222222, 1, '2006-10-15');

INSERT INTO StockPortfolio VALUES (444444444, 1, 'F', 100);
INSERT INTO StockPortfolio VALUES (222222222, 1, 'IBM', 50);
INSERT INTO StockPortfolio VALUES (444444444, 1, 'GM', 250);

INSERT INTO Orders VALUES (1, 75, 25.51, '2022-11-07', NULL, 'Market', 'Buy');
INSERT INTO Orders VALUES (2, 10, 105.61, '2022-11-07', 5, 'TrailingStop', 'Sell');
INSERT INTO Orders VALUES (3, 50, 50, '2022-11-08', NULL, 'Market', 'Sell');

INSERT INTO Transactions VALUES (1, 95.66, '2022-11-07', 25.51);
INSERT INTO Transactions VALUES (2, 45, '2022-11-07', 90);
INSERT INTO Transactions VALUES (3, 75, '2022-11-08', 50);

INSERT INTO Trade VALUES (1, 444444444, 123456789, 1, 1, 'GM');
INSERT INTO Trade VALUES (1, 222222222, 123456789, 2, 2, 'IBM');
INSERT INTO Trade VALUES (1, 444444444, 123456789, 3, 3, 'GM');














