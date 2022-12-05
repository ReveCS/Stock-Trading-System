DROP DATABASE Stonksmaster;
CREATE DATABASE Stonksmaster;
USE Stonksmaster;


DELIMITER $$
CREATE PROCEDURE create_all_tables ()
BEGIN

CREATE TABLE Location (
	ZipCode MEDIUMINT,
	City VARCHAR(20) NOT NULL,
	State VARCHAR(20) NOT NULL,
	PRIMARY KEY (ZipCode) );

CREATE TABLE Person (
	SSN VARCHAR(20),
	LastName VARCHAR(20) NOT NULL,
	FirstName VARCHAR(20) NOT NULL,
	Email VARCHAR(32) UNIQUE,
	Address VARCHAR(20),
	ZipCode MEDIUMINT,
	Telephone VARCHAR(20),
	PRIMARY KEY (SSN),
	FOREIGN KEY (ZipCode) REFERENCES Location (ZipCode)
	ON DELETE NO ACTION
	ON UPDATE CASCADE );
    
CREATE TABLE LoginInfo(
	Email VARCHAR(32),
    UserPass VARCHAR(255),
    UserRole SMALLINT -- 0 for customer, 1 for empolyee, 2 for manager.
    );

CREATE TABLE Employee (
	EmpId VARCHAR(20),
	StartDate DATE,
	HourlyRate INTEGER,
	EmpRole INT NOT NUll DEFAULT 0,
	PRIMARY KEY (EmpId),
	FOREIGN KEY (EmpId) REFERENCES Person (SSN)
	ON DELETE NO ACTION
	ON UPDATE CASCADE );

CREATE TABLE Clients (
	ClientId VARCHAR(20),
	CreditCardNumber VARCHAR(32),
	Rating INTEGER,
	PRIMARY KEY (ClientId),
	FOREIGN KEY (ClientId) REFERENCES Person (SSN)
	ON UPDATE CASCADE );

CREATE TABLE Stock (
	StockSymbol VARCHAR(20) NOT NULL,
	CompanyName VARCHAR(20) NOT NULL,
	Type VARCHAR(20) NOT NULL,
	PricePerShare DOUBLE,
	NumShares INT NOT NULL DEFAULT 1,
	PRIMARY KEY (StockSymbol) );

CREATE TABLE PriceHistory (
	StockSymbol VARCHAR(20) NOT NULL,
	Date DATE,
	PricePerShare DOUBLE,
	CompanyName VARCHAR(20) NOT NULL,
	StockType VARCHAR(20) NOT NULL,
	NumShares INT NOT NULL DEFAULT 1,
	PRIMARY KEY (StockSymbol, Date, PricePerShare, CompanyName, StockType, NumShares),
	FOREIGN KEY (StockSymbol) REFERENCES Stock (StockSymbol) );

CREATE TABLE Account (
	ClientId VARCHAR(20),
	AccNum INTEGER,	
	DateOpened DATE,
	PRIMARY KEY (ClientId, AccNum),
	FOREIGN KEY (ClientId) REFERENCES Clients (ClientId)
	ON DELETE NO ACTION
	ON UPDATE CASCADE );

CREATE TABLE StockPortfolio (
	ClientId VARCHAR(20),
	AccNum INTEGER,
	Stock VARCHAR(20) NOT NULL,
	NumShares INT NOT NULL DEFAULT 1,
	PRIMARY KEY (Stock),
	FOREIGN KEY (Stock)  REFERENCES Stock(StockSymbol),
	FOREIGN KEY (ClientId, AccNum) REFERENCES Account(ClientId, AccNum) );

CREATE TABLE Transactions (
	TxnId INTEGER NOT NULL AUTO_INCREMENT,
	Fee DECIMAL(13,2),
	Date DATE,
	PricePerShare DOUBLE,
	PRIMARY KEY (TxnId) );

CREATE TABLE Orders (
	OrderId INTEGER NOT NULL AUTO_INCREMENT,
	NumShares INTEGER,
	PricePerShare DOUBLE,	
	Date DATE,
	Percentage DECIMAL(5,3),
	PriceType VARCHAR(13) CHECK ( PriceType IN ('Market', 'MarketOnClose', 'TrailingStop', 'HiddenStop') ),
	OrderType VARCHAR(4) CHECK ( OrderType IN ('Buy', 'Sell') ),
	PRIMARY KEY (OrderId) );

CREATE TABLE Trade (
	AccountId INTEGER,
	ClientId VARCHAR(20),
	BrokerId VARCHAR(20),
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

END$$
DELIMITER ;
CALL create_all_tables;


DELIMITER $$
CREATE PROCEDURE insert_dummy_data ()
BEGIN
# INSERT DEMO DATA CODE 

INSERT INTO Location VALUES(0, "", "");
INSERT INTO Location VALUES (11790, 'Stony Brook', 'NY');
INSERT INTO Location VALUES (93536, 'Los Angeles', 'CA');
INSERT INTO Location VALUES (11794, 'Stony Brook', 'NY');

INSERT INTO Person VALUES ('0', "", "", "", "", 0, "");
INSERT INTO Person VALUES ('111111111', 'Yang', 'Shang', 'customer@email.com', '123 Success Street', 11790, '5166328959');
INSERT INTO Person VALUES ('222222222', 'Du', 'Victor', 'vicdu@cs.sunysb.edu', '456 Fortune Road', 11790, '5166324360');
INSERT INTO Person VALUES ('333333333', 'Smith', 'John', 'jsmith@ic.sunysb.edu', '789 Peace Blvd', 93536, '3154434321');
INSERT INTO Person VALUES ('444444444', 'Philip', 'Lewis', 'pml@cs.sunysb.edu', '135 Knowledge Lane', 11794, '5166668888');
INSERT INTO Person VALUES ('123456789', 'Smith', 'David', 'employee@email.com', '123 College road', 11790, '5162152345');
INSERT INTO Person VALUES ('789123456', 'Warren', 'David', 'manager@email.com', '456 Sunken Street', 11790, '5162152345');

INSERT INTO Employee VALUEs ('0', '2000-01-01', 0, 0);
INSERT INTO Employee VALUES ('123456789', '2005-11-01', 60, 0);
INSERT INTO Employee VALUES ('789123456', '2005-11-01', 50, 1);

INSERT INTO Stock VALUES ('GM',	'General Motors', 'automotive', 34.23, 1000);
INSERT INTO Stock VALUES ('IBM', 'IBM', 'computer', 91.41, 500);
INSERT INTO Stock VALUES ('F', 'Ford', 'automotive', 9.0, 750);

INSERT INTO Clients VALUES ('111111111', '1234567812345678', 1);
INSERT INTO Clients VALUES ('222222222', '5678123456781234', 1);
INSERT INTO Clients VALUES ('333333333', '2345678923456789', 1);
INSERT INTO Clients VALUES ('444444444', '6789234567892345', 1);

INSERT INTO Account VALUES ('444444444', 1, '2006-10-01');
INSERT INTO Account VALUES ('222222222', 1, '2006-10-15');
INSERT INTO Account VALUES ('111111111', 1, '2006-10-15');
INSERT INTO Account VALUES ('333333333', 1, '2006-10-15');

INSERT INTO StockPortfolio VALUES ('444444444', 1, 'F', 100);
INSERT INTO StockPortfolio VALUES ('222222222', 1, 'IBM', 50);
INSERT INTO StockPortfolio VALUES ('444444444', 1, 'GM', 250);

INSERT INTO Orders VALUES (1, 75, 25.51, '2022-11-07', NULL, 'Market', 'Buy');
INSERT INTO Orders VALUES (2, 10, 105.61, '2022-11-07', 5, 'TrailingStop', 'Sell');
INSERT INTO Orders VALUES (3, 50, 50, '2022-11-08', NULL, 'Market', 'Sell');
INSERT INTO Orders VALUES (4, 24, 90, '2022-11-11', NULL, 'HiddenStop', 'Sell');
INSERT INTO Orders VALUES (5, 5, 87.53, '2022-11-11', NULL, 'HiddenStop', 'Sell');
INSERT INTO Orders VALUES (6, 37, 79.57, '2022-11-12', NULL, 'HiddenStop', 'Sell');
INSERT INTO Orders VALUES (7, 71, 40.32, '2022-11-15', NULL, 'HiddenStop', 'Sell');
INSERT INTO Orders VALUES (8, 25, 70.89, '2022-12-01', NULL, 'MarketOnClose', 'Buy');
INSERT INTO Orders VALUES (9, 15, 81, '2022-12-02', NULL, 'Market', 'Sell');
INSERT INTO Orders VALUES (10, 200, 10.40, '2022-12-03', NULL, 'Market', 'Buy');
INSERT INTO Orders VALUES (11, 50, 19, '2022-12-04', NULL, 'Market', 'Sell');

INSERT INTO Transactions VALUES (1, 95.66, '2022-11-07', 25.51);
INSERT INTO Transactions VALUES (2, 45, '2022-11-07', 90);
INSERT INTO Transactions VALUES (3, 75, '2022-11-08', 50);
INSERT INTO Transactions VALUES (4, 80, '2022-12-01', 70.89);
INSERT INTO Transactions VALUES (5, 50, '2022-12-02', 81);
INSERT INTO Transactions VALUES (6, 100, '2022-12-03', 10.40);
INSERT INTO Transactions VALUES (7, 85, '2022-12-04', 19);

INSERT INTO Trade VALUES (1, '444444444', '123456789', 1, 1, 'GM');
INSERT INTO Trade VALUES (1, '222222222', '123456789', 2, 2, 'IBM');
INSERT INTO Trade VALUES (1, '444444444', '123456789', 3, 3, 'GM');
INSERT INTO Trade VALUES (1, '333333333', '789123456', 4, 8, 'F');
INSERT INTO Trade VALUES (1, '333333333', '789123456', 5, 9, 'F');
INSERT INTO Trade VALUES (1, '444444444', '789123456', 6, 10, 'IBM');
INSERT INTO Trade VALUES (1, '444444444', '789123456', 7, 11, 'IBM');

INSERT INTO PriceHistory VALUES ('F', '2022-09-15', 9.00, 'Ford', 'automotive', 750);
INSERT INTO PriceHistory VALUES ('GM', '2022-10-08', 34.23, 'General Motors', 'automotive', 1000);
INSERT INTO PriceHistory VALUES ('IBM', '2022-11-11', 90.23, 'IBM', 'computer', 500);
INSERT INTO PriceHistory VALUES ('GM', '2022-12-25', 35.01, 'General Motors', 'automotive', 1000);

INSERT INTO LoginInfo VALUES ('customer@email.com', '202cb962ac59075b964b07152d234b70', 0);
INSERT INTO LoginInfo VALUES ('employee@email.com', '202cb962ac59075b964b07152d234b70', 1);
INSERT INTO LoginInfo VALUES ('manager@email.com', '202cb962ac59075b964b07152d234b70', 2);

END$$
DELIMITER ;
CALL insert_dummy_data;


# MANAGER TRANSACTIONS 
# Set the share price of a stock (for simulating market fluctuations in a stocks share price)
DELIMITER $$
CREATE PROCEDURE SetSharePrice(Price DOUBLE, InputStock VARCHAR(20))
BEGIN
	DECLARE exit handler FOR SQLEXCEPTION, SQLWARNING
	BEGIN
		ROLLBACK;
		RESIGNAL;
	END;

	# Update SharePrice in SharePrice history table
    START TRANSACTION;
	INSERT INTO PriceHistory (StockSymbol, Date, PricePerShare, CompanyName, StockType, NumShares) VALUES
    ((SELECT StockSymbol FROM Stock WHERE StockSymbol = InputStock), 
    NOW(), 
    (SELECT PricePerShare FROM Stock WHERE StockSymbol = InputStock),
    (SELECT CompanyName FROM Stock WHERE StockSymbol = InputStock),
    (SELECT StockType FROM Stock WHERE StockSymbol = InputStock),
    (SELECT NumShares FROM Stock WHERE StockSymbol = InputStock)
    );
	
    UPDATE Stock 
	SET PricePerShare = Price
	WHERE StockSymbol = InputStock;
    COMMIT;
END$$
DELIMITER ;


# Add, Edit and Delete information for an employee
DELIMITER $$
CREATE PROCEDURE AddEmployee(
	IN nId VARCHAR(20),
	IN nStartDate Date,
	IN nHourlyRate INTEGER,
	IN nLastName VARCHAR(20),
	IN nFirstName VARCHAR(20),
	IN nEmail VARCHAR(32),
	IN nAddress VARCHAR(20),
	IN nZipCode INT,
	IN nCity VARCHAR(20),
	IN nState VARCHAR(20),
	IN nTelephone VARCHAR(20))
BEGIN
	DECLARE exit handler FOR SQLEXCEPTION, SQLWARNING
	BEGIN
		ROLLBACK;
		RESIGNAL;
	END;
   	 
	START TRANSACTION;
    INSERT INTO Location VALUES (nZipCode, nCity, nState);
	INSERT INTO Person VALUES (nId, nLastName, nFirstName, nEmail, nAddress, nZipCode, nTelephone);
    INSERT INTO Employee VALUES (nId, nStartDate, nHourlyRate, DEFAULT);
	COMMIT;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE UpdateEmployee(
	IN nId VARCHAR(20),
	IN nStartDate Date,
	IN nHourlyRate INTEGER,
	IN nRole VARCHAR(20),
	IN nLastName VARCHAR(20),
	IN nFirstName VARCHAR(20),
	IN nEmail VARCHAR(32),
	IN nAddress VARCHAR(20),
	IN nZipCode VARCHAR(20),
	IN nCity VARCHAR(20),
	IN nState VARCHAR(20),
	IN nTelephone VARCHAR(20))
BEGIN
	DECLARE exit handler FOR SQLEXCEPTION, SQLWARNING
	BEGIN
		ROLLBACK;
		RESIGNAL;
	END;
   	 
	START TRANSACTION;
    UPDATE Location SET
		City = nCity,
        State = nState
    WHERE ZipCode = nZipCode;
    
	UPDATE Person SET
		LastName=nLastName,
		FirstName=nFirstName,
        Email=nEmail,
		Address=nAddress,
		Telephone=nTelephone
	WHERE SSN = nId;
   	 
	UPDATE Employee SET
		StartDate = nStartDate,
		HourlyRate = nHourlyRate,
        EmpRole = nRole
	WHERE EmpId = nId;
	COMMIT;
END$$
DELIMITER ;


# Obtain a sales report for a particular month
DELIMITER $$
CREATE PROCEDURE SalesReport (InputMonth INT, InputYear INT)
BEGIN 
	START TRANSACTION;
		SELECT trans.Date, 
		st.StockSymbol,
		ord.NumShares,
		trans.PricePerShare,
        t.AccountId,
		trans.PricePerShare*ord.NumShares AS 'Total Sale'
		FROM Transactions AS trans
		INNER JOIN Trade AS t ON trans.TxnId = t.TransactionId
		INNER JOIN Stock AS st ON st.StockSymbol = t.StockId
        INNER JOIN Orders AS ord ON ord.OrderId = t.OrderId
		WHERE (SELECT MONTH(trans.Date)) = InputMonth AND (SELECT YEAR(trans.Date)) = InputYear;
   COMMIT;
END$$
DELIMITER ;

CALL SalesReport(11, 2022);

# Produce a comprehensive listing of all stocks
DELIMITER $$
CREATE PROCEDURE StockList ()
BEGIN 
	START TRANSACTION;
		SELECT * FROM Stock;
	COMMIT;
END$$
DELIMITER ;


# Produce a list of orders by stock symbol or by customer name
DELIMITER $$
CREATE PROCEDURE OrderListByStock () 
BEGIN
	START TRANSACTION;
		SELECT t.StockId, 
		ord.OrderId, 
		ord.Date, 
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


DELIMITER $$
CREATE PROCEDURE OrderListByCustomer () 
BEGIN
START TRANSACTION;
		SELECT t.StockId, 
		ord.OrderId, 
		p.LastName,
		p.FirstName,
		ord.Date, 
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


# Produce a summary listing of revenue generated by a particular stock, stock type, or customer
# Input: Stock name (i.e IBM)
DELIMITER $$
CREATE PROCEDURE StockRevenueSummary(Stock VARCHAR(20))
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


# Input Customer ID (i.e 444444444)	
DELIMITER $$
CREATE PROCEDURE CustomerRevenueSummary(Customer VARCHAR(20))
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


# Determine which customer representative generated most total revenue
DELIMITER $$
CREATE PROCEDURE CustomerRepMostRevenue()
BEGIN
	START TRANSACTION;
		SELECT *
        FROM Trade as t
        INNER JOIN Transactions AS trans ON trans.TxnId = t.TransactionId
        INNER JOIN Orders AS ord ON ord.OrderId = t.OrderId 
        INNER JOIN Employee e ON e.EmpId = t.BrokerId
        INNER JOIN Person p ON p.SSN = e.EmpId
        INNER JOIN Location l ON l.ZipCode = p.ZipCode
        ORDER BY 'REVENUE' DESC;
	COMMIT;
END$$
DELIMITER ;


# Determine which customer generated most total revenue
DELIMITER $$
CREATE PROCEDURE CustomerMostRevenue()
BEGIN
	START TRANSACTION;
		SELECT *
        FROM Trade as t
        INNER JOIN Transactions AS trans ON trans.TxnId = t.TransactionId
        INNER JOIN Orders AS ord ON ord.OrderId = t.OrderId 
        INNER JOIN Clients c ON c.ClientId = t.ClientId
		INNER JOIN Person p ON p.SSN = c.ClientId
        INNER JOIN Location l ON l.ZipCode = p.ZipCode
        ORDER BY 'REVENUE' DESC
        LIMIT 1;
	COMMIT;
END$$
DELIMITER ;


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



# CUSTOMER-REP TRANSACTIONS

# Record an order
DELIMITER $$
CREATE PROCEDURE RecordOrders(
	IN AccId INTEGER,
	IN ClientId INTEGER,
	IN BrokerId INTEGER,
	IN StockSym VARCHAR(20),
	IN NumShares INTEGER,
	IN PricePerShare DECIMAL(13,2),
	IN Percentage DECIMAL(5,2),
	IN PriceType VARCHAR(13),
	IN OrderType VARCHAR(4)
)
BEGIN
	DECLARE exit handler FOR SQLEXCEPTION, SQLWARNING
	BEGIN
		ROLLBACK;
		RESIGNAL;
	END;
   		 
	START TRANSACTION;

	IF PriceType='Market' THEN
		INSERT INTO Orders VALUES (
			NULL,
			NumShares,
			(SELECT PricePerShare FROM Stock WHERE StockSymbol=StockSym),
			NOW(),
			Percentage,
			PriceType,
			OrderType
			);
	ELSE
		INSERT INTO Orders VALUES (
			NULL,
			NumShares,
			PricePerShare,
			NOW(),
			Percentage,
			PriceType,
			OrderType
		);
	END IF;

	SET @order_id = (SELECT LAST_INSERT_ID());
	
	IF PriceType='Market' THEN
		INSERT INTO Transactions VALUES (
			NULL,
			(SELECT NumShares*PricePerShare*0.05 AS Fee FROM Orders WHERE OrderId=@order_id),
			NOW(),
			(SELECT PricePerShare FROM Orders WHERE OrderId=@order_id)
			);
	ELSE
		INSERT INTO Transaction VALUES (NULL,NULL,NULL,NULL);
	END IF;

	SET @transaction_id = (SELECT LAST_INSERT_ID());

	INSERT INTO Trade VALUES (
		AccId,	ClientId, BrokerId, @transaction_id, @order_id, StockSym
	);

	COMMIT;
END$$
DELIMITER ;


# Add, edit, and delete information from customer
DELIMITER $$
CREATE PROCEDURE AddCustomer(
	IN SSN VARCHAR(20),
	IN nCreditCardNumber VARCHAR(32),
	IN nRating INTEGER,
	IN nLastName VARCHAR(20),
	IN nFirstName VARCHAR(20),
	IN nEmail VARCHAR(32),
	IN nAddress VARCHAR(20),
	IN nZipCode INTEGER,
	IN nCity VARCHAR(20),
	IN nState VARCHAR(20),
	IN nTelephone VARCHAR(20))
BEGIN
	DECLARE exit handler FOR SQLEXCEPTION, SQLWARNING
	BEGIN
		ROLLBACK;
		RESIGNAL;
	END;
   	 
	START TRANSACTION;
    INSERT INTO Location VALUES (nZipCode, nCity, nState);
	INSERT INTO Person VALUES (SSN, nLastName, nFirstName, nEmail, nAddress, nZipCode, nTelephone);
    INSERT INTO Clients VALUES (SSN, nCreditCardNumber, nRating);
    
	INSERT INTO Account VALUES (SSN, (SELECT COUNT(*) FROM Account acc WHERE acc.ClientId = SSN) + 1, NOW());
	COMMIT;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE UpdateCustomer(
	IN nClientId VARCHAR(20),
	IN nCreditCardNumber VARCHAR(32),
	IN nRating INTEGER,
	IN nLastName VARCHAR(20),
	IN nFirstName VARCHAR(20),
	IN nEmail VARCHAR(32),
	IN nAddress VARCHAR(20),
	IN nZipCode INTEGER,
	IN nCity VARCHAR(20),
	IN nState VARCHAR(20),
	IN nTelephone VARCHAR(20)
    )
BEGIN
	DECLARE exit handler FOR SQLEXCEPTION, SQLWARNING
	BEGIN
		ROLLBACK;
		RESIGNAL;
	END;
   	 
	START TRANSACTION;
    UPDATE Location SET
		City = nCity,
        State = nState
    WHERE ZipCode = nZipCode;
    
	UPDATE Person SET
		LastName=nLastName,
		FirstName=nFirstName,
        Email=nEmail,
		Address=nAddress,
		Telephone=nTelephone
	WHERE SSN = nClientId;
   	 
	UPDATE Clients SET
		ClientId=nClientId,
		CreditCardNumber=nCreditCardNumber,
		Rating=nRating
	WHERE ClientId = nClientId;

	COMMIT;
END $$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE DeleteCustomer(IN nClientId VARCHAR(20))
BEGIN
	DECLARE exit handler FOR SQLEXCEPTION, SQLWARNING
	BEGIN
		ROLLBACK;
		RESIGNAL;
	END;
   	 
	START TRANSACTION;
	DELETE FROM Person p WHERE p.SSN LIKE nClientId;
	DELETE FROM Clients c WHERE c.ClientId LIKE nClientId;
	DELETE FROM Account acc WHERE acc.ClientId LIKE nClientId;
	COMMIT;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE CustomerMailingList (
	IN bId INTEGER
	)
BEGIN
	DECLARE exit handler FOR SQLEXCEPTION, SQLWARNING
	BEGIN
		ROLLBACK;
		RESIGNAL;
	END;
   	 
	START TRANSACTION;
   	 
	SELECT Email From Clients WHERE ClientId IN (SELECT ClientId FROM Trade WHERE BrokerId = bId);

	COMMIT;
END$$
DELIMITER ;


# CUSTOMER TRANSACTIONS

# Customer's current stock holdings
DELIMITER $$
CREATE PROCEDURE CustomerHolding(IN Id VARCHAR(20))
BEGIN
	SELECT sp.ClientId,
	sp.AccNum,
	s.CompanyName,
	sp.Stock,
	s.Type, 		
	sp.NumShares,
	s.PricePerShare
	FROM 
	StockPortfolio as sp
	INNER JOIN Stock as s ON sp.Stock = s.StockSymbol WHERE sp.ClientId = Id;
END $$
DELIMITER ;


# The share-price and trailing-stop history for a given conditional order
DELIMITER $$
CREATE PROCEDURE trailing_stop_History() # IN PriceType varchar
BEGIN
	SELECT o.OrderId,
    o.Date,
    o.NumShares,
	o.PricePerShare,
    o.PriceType,
    o.Percentage,
	o.OrderType
	FROM 
	Orders as o
    where O.PriceType = 'TrailingStop';
END $$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE hidden_stop_History() # IN PriceType varchar
BEGIN
	SELECT o.OrderId,
	o.Date,
	o.NumShares,
	o.PricePerShare,
	o.PriceType,
	o.Percentage,
	o.OrderType
	FROM 
	Orders as o
			where O.PriceType = 'HiddenStop';
END $$
DELIMITER ;


# A history of all current and past orders a customer has placed
DELIMITER $$
CREATE PROCEDURE all_History(IN Id VARCHAR(20)) 
# A history of all current and past orders a customer has placed
BEGIN
	SELECT t.ClientId,
    t.BrokerId, 
    t.TransactionId,   
    o.OrderId,
    t.StockId,
    o.Numshares,
    o.PricePerShare,
    o.Date,
    o.Percentage,
    o.PriceType,
    o.OrderType
    From Trade as t 
	INNER JOIN Orders as o ON t.OrderId = o.OrderId WHERE t.ClientId = Id;
END $$
DELIMITER ;


# Stocks available of a particular type and most-recent order info
DELIMITER $$
CREATE PROCEDURE searchByType(IN PriceType varchar(20)) 
BEGIN
	SELECT 
		o.PriceType,
		t.StockId,
		t.OrderId,
		t.TransactionId,
		t.ClientId,
		t.BrokerId,
		o.NumShares,
		o.PricePerShare,
		t2.Fee,
		o.Date, 
		o.Percentage,
		o.OrderType
	FROM trade as t
	INNER JOIN Orders as o On t.OrderId = o.OrderId 
	INNER JOIN Transactions as t2 On t.TransactionId = t2.TxnId 
	WHERE o.PriceTYpe = PriceType
		order by o.Date desc; 
END $$
DELIMITER ;


# Stocks available with a particular keyword or set of keywords in the stock name, and most-recent order info
DELIMITER $$
CREATE PROCEDURE available_keyword(IN keyword varchar(15)) 
BEGIN
	SELECT t.StockId,
		t.OrderId,
		t.TransactionId,
		t.ClientId,
		t.BrokerId,
		o.NumShares,
		o.PricePerShare,
		t2.Fee,
		o.Date,
		o.Percentage,
		o.PriceType,
		o.OrderType
		FROM trade as t
		INNER JOIN Orders as o ON t.OrderId = o.OrderId
		INNER JOIN Transactions as t2 On t.TransactionId = t2.TxnId 
		WHERE (t.StockId = keyword or t.ClientId = keyword) 
		or t.BrokerId = keyword 
		or o.OrderType = keyword
		or o.PriceTYpe = keyword        
		order by o.Date desc; 
END $$
DELIMITER ;


# Best-Seller list of stocks
DELIMITER $$
CREATE PROCEDURE Best_Seller()
BEGIN 
    SELECT StockSymbol,
    s.CompanyName,
    s.Type,
    s.PricePerShare,
    s.NumShares
    FROM Trade 
    INNER JOIN Stock s ON s.StockSymbol = StockId
    GROUP BY StockId ORDER BY COUNT(*) DESC;
END $$
DELIMITER ;

CALL Best_Seller();

DELIMITER $$
CREATE PROCEDURE Add_Login(
	IN UserEmail VARCHAR(255),
	IN UserPass VARCHAR(255),
    IN UserRole SMALLINT
    )
BEGIN
	DECLARE exit handler FOR SQLEXCEPTION, SQLWARNING
	BEGIN
		ROLLBACK;
		RESIGNAL;
	END;
	START TRANSACTION;
	INSERT INTO LoginInfo VALUES (UserEmail, UserPass, UserRole);
    COMMIT;
END $$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE GetAllStocks()
BEGIN
	SELECT * FROM Stock;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE SubmitOrder(
    IN NumShares INT,
    IN PricePerShare DOUBLE,
	IN Date Date,
    IN Percentage DECIMAL(5,3),
    IN PriceType VARCHAR(13),
    IN OrderType VARCHAR(4),
	IN AccountNum INT,
    IN ClientId VARCHAR(20),
	IN BrokerId VARCHAR(20),
    IN StockSymbol VARCHAR(20)
    )
BEGIN
	DECLARE exit handler FOR SQLEXCEPTION, SQLWARNING
	BEGIN
		ROLLBACK;
		RESIGNAL;
	END;
    
	START TRANSACTION;
    IF Percentage = 0 THEN
		INSERT INTO Orders VALUES (NULL, NumShares, PricePerShare, Date, NULL, PriceType, OrderType);
	ELSE
		INSERT INTO Orders VALUES (NULL, NumShares, PricePerShare, Date, Percentage, PriceType, OrderType);
	END IF;

	SET @order_id = (SELECT LAST_INSERT_ID());
    
    IF PriceType='Market' THEN
		INSERT INTO Transactions VALUES (
			NULL,
			(SELECT NumShares*PricePerShare*0.05 AS Fee FROM Orders o WHERE o.OrderId = @order_id),
			NOW(),
			(SELECT PricePerShare FROM Orders o WHERE o.OrderId = @order_id)
			);
	ELSE
		INSERT INTO Transaction VALUES (NULL,NULL,NULL,NULL);
	END IF;
    
	SET @transaction_id = (SELECT LAST_INSERT_ID());

	INSERT INTO Trade VALUES (AccountNum, ClientId, BrokerId, @transaction_id, @order_id, StockSymbol);
    
    COMMIT;
END $$
DELIMITER ;

SELECT * FROM Stock;
SELECT * FROM PriceHistory;
SELECT * FROM Clients;
SELECT * FROM Employee;
SELECT * FROM Person;
SELECT * FROM Trade;
SELECT * FROM LoginInfo;
SELECT c.*, acc.*, p.*, l.City, l.State FROM Clients c INNER JOIN Account acc ON acc.ClientId = c.ClientId INNER JOIN Person p ON p.SSN = c.ClientId JOIN Location l ON l.ZipCode = p.ZipCode;


DELIMITER $$
CREATE PROCEDURE SuggestStock (
	IN cId VARCHAR(20)
)
BEGIN
	SELECT * FROM Stock WHERE Type=(SELECT Type FROM Stock WHERE StockSymbol=(SELECT StockId FROM Trade WHERE ClientId=cId GROUP BY StockId ORDER BY COUNT(*) DESC LIMIT 1));
END$$
DELIMITER ;
