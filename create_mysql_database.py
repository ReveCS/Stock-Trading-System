import mysql.connector
import sys

if (len(sys.argv) < 3):
    print("Please enter a username and password for MySql Server")
    exit()

mydb = mysql.connector.connect(
  host="localhost",
  user=sys.argv[1],
  password=sys.argv[2]
)


mycursor = mydb.cursor()
mycursor.execute("SHOW DATABASES")

db_exist = False

for x in mycursor:
    if (x[0] == bytearray(b'stonksmaster')):
        db_exist = True

if (db_exist):
    mycursor.execute("DROP DATABASE stonksmaster")

mycursor.execute("CREATE DATABASE stonksmaster")

mycursor.execute("USE stonksmaster")

# Create table
create_table = [
			"CREATE TABLE Location (\
			ZipCode MEDIUMINT,\
			City VARCHAR(20) NOT NULL,\
			State VARCHAR(20) NOT NULL,\
			PRIMARY KEY (ZipCode) );",
			
			"CREATE TABLE Person (\
			SSN INTEGER CHECK (SSN > 0 AND SSN < 1000000000),\
			LastName VARCHAR(20) NOT NULL,\
			FirstName VARCHAR(20) NOT NULL,\
			Address VARCHAR(20),\
			ZipCode MEDIUMINT,\
			Telephone BIGINT,\
			PRIMARY KEY (SSN),\
			FOREIGN KEY (ZipCode) REFERENCES Location (ZipCode)\
			ON DELETE NO ACTION\
			ON UPDATE CASCADE );",
			
			"CREATE TABLE Employee (\
			EmpId INTEGER,\
			StartDate DATE,\
			HourlyRate INTEGER,\
			PRIMARY KEY (EmpId),\
			FOREIGN KEY (EmpId) REFERENCES Person (SSN)\
			ON DELETE NO ACTION\
			ON UPDATE CASCADE );",
			
			"CREATE TABLE Clients (\
			ClientId INTEGER,\
			Email VARCHAR(32),\
			CreditCardNumber BIGINT,\
			Rating INTEGER,\
			PRIMARY KEY (ClientId),\
			FOREIGN KEY (ClientId) REFERENCES Person (SSN)\
			ON DELETE NO ACTION\
			ON UPDATE CASCADE );",
			
			"CREATE TABLE Stock (\
			StockSymbol VARCHAR(20) NOT NULL,\
			CompanyName VARCHAR(20) NOT NULL,\
			Type VARCHAR(20) NOT NULL,\
			PricePerShare DECIMAL(13,2),\
			NumShares INT NOT NULL DEFAULT 1,\
			PRIMARY KEY (StockSymbol) );",
			
			"CREATE TABLE Account (\
			ClientId INTEGER,\
			AccNum INTEGER,\
			DateOpened DATE,\
			PRIMARY KEY (ClientId, AccNum),\
			FOREIGN KEY (ClientId) REFERENCES Clients (ClientId)\
			ON DELETE NO ACTION\
			ON UPDATE CASCADE );",
			
			"CREATE TABLE StockPortfolio (\
			ClientId INTEGER,\
			AccNum INTEGER,\
			Stock VARCHAR(20) NOT NULL,\
			NumShares INT NOT NULL DEFAULT 1,\
			PRIMARY KEY (Stock),\
			FOREIGN KEY (Stock)  REFERENCES Stock(StockSymbol),\
			FOREIGN KEY (ClientId, AccNum) REFERENCES Account(ClientId, AccNum) )",
			
			"CREATE TABLE Transactions (\
			TxnId INTEGER NOT NULL AUTO_INCREMENT,\
			Fee DECIMAL(13,2),\
			DateTime DATETIME,\
			PricePerShare DECIMAL(13,2),\
			PRIMARY KEY (TxnId) );",
			
			"CREATE TABLE Orders (\
			OrderId INTEGER NOT NULL AUTO_INCREMENT,\
			NumShares INTEGER,\
			PricePerShare DECIMAL(13,2),\
			DateTime DATETIME,\
			Percentage DECIMAL(5,3),\
			PriceType VARCHAR(13) CHECK ( PriceType IN ('Market', 'MarketOnClose', 'TrailingStop', 'HiddenStop') ),\
			OrderType VARCHAR(4) CHECK ( OrderType IN ('Buy', 'Sell') ),\
			PRIMARY KEY (OrderId) );",
			
			"CREATE TABLE Trade (\
			AccountId INTEGER,\
			ClientId INTEGER,\
			BrokerId INTEGER,\
			TransactionId INTEGER,\
			OrderId INTEGER,\
			StockId VARCHAR(20),\
			PRIMARY KEY (AccountId, ClientId, BrokerId, TransactionId, OrderId, StockId),\
			FOREIGN KEY (ClientId, AccountID) REFERENCES Account (ClientId, AccNum)\
			ON DELETE NO ACTION\
			ON UPDATE CASCADE,\
			FOREIGN KEY (BrokerId) REFERENCES Employee (EmpId)\
			ON DELETE NO ACTION\
			ON UPDATE CASCADE,\
			FOREIGN KEY (TransactionID) REFERENCES Transactions (TxnId)\
			ON DELETE NO ACTION\
			ON UPDATE CASCADE,\
			FOREIGN KEY (OrderId) REFERENCES Orders (OrderId)\
			ON DELETE NO ACTION\
			ON UPDATE CASCADE,\
			FOREIGN KEY (StockId) REFERENCES Stock (StockSymbol)\
			ON DELETE NO ACTION\
			ON UPDATE CASCADE );",
		]

for create_table_query in create_table:
    mycursor.execute(create_table_query)


# Insert dummy data
insert_into = [
			"INSERT INTO Location VALUES (11790, 'Stony Brook', 'NY');",
			"INSERT INTO Location VALUES (93536, 'Los Angeles', 'CA');",
			"INSERT INTO Location VALUES (11794, 'Stony Brook', 'NY');",

			"INSERT INTO Person VALUES (111111111, 'Yang', 'Shang', '123 Success Street', 11790, 5166328959);",
			"INSERT INTO Person VALUES (222222222, 'Du', 'Victor', '456 Fortune Road', 11790, 5166324360);",
			"INSERT INTO Person VALUES (333333333, 'Smith', 'John', '789 Peace Blvd', 93536, 3154434321);",
			"INSERT INTO Person VALUES (444444444, 'Philip', 'Lewis', '135 Knowledge Lane', 11794, 5166668888);",
			"INSERT INTO Person VALUES (123456789, 'Smith', 'David', '123 College road', 11790, 5162152345);",
			"INSERT INTO Person VALUES (789123456, 'Warren', 'David', '456 Sunken Street', 11790, 5162152345);",

			"INSERT INTO Employee VALUES (123456789, '2005-11-01', 60 );",
			"INSERT INTO Employee VALUES (789123456, '2005-11-01', 50 );",

			"INSERT INTO Stock VALUES ('GM',    'General Motors', 'automotive', 34.23, 1000);",
			"INSERT INTO Stock VALUES ('IBM', 'IBM', 'computer', 91.41, 500);",
			"INSERT INTO Stock VALUES ('F', 'Ford', 'automotive', 9.0, 750);",

			"INSERT INTO Clients VALUES (111111111, 'syang@cs.sunysb.edu', 1234567812345678, 1);",
			"INSERT INTO Clients VALUES (222222222, 'vicdu@cs.sunysb.edu', 5678123456781234, 1);",
			"INSERT INTO Clients VALUES (333333333, 'jsmith@ic.sunysb.edu', 2345678923456789, 1);",
			"INSERT INTO Clients VALUES (444444444, 'pml@cs.sunysb.edu', 6789234567892345, 1);",

			"INSERT INTO Account VALUES (444444444, 1, '2006-10-01');",
			"INSERT INTO Account VALUES (222222222, 1, '2006-10-15');",

			"INSERT INTO StockPortfolio VALUES (444444444, 1, 'F', 100);",
			"INSERT INTO StockPortfolio VALUES (222222222, 1, 'IBM', 50);",
			"INSERT INTO StockPortfolio VALUES (444444444, 1, 'GM', 250);",

			"INSERT INTO Orders VALUES (1, 75, 25.51, '2022-11-07', NULL, 'Market', 'Buy');",
			"INSERT INTO Orders VALUES (2, 10, 105.61, '2022-11-07', 5, 'TrailingStop', 'Sell');",

			"INSERT INTO Transactions VALUES (1, 95.66, '2022-11-07', 25.51);",
			"INSERT INTO Transactions VALUES (2, 45, '2022-11-07', 90);",

			"INSERT INTO Trade VALUES (1, 444444444, 123456789, 1, 1, 'GM')",
			"INSERT INTO Trade VALUES (1, 222222222, 123456789, 2, 2, 'IBM')",
		]

for insert_dummy_query in insert_into:
    mycursor.execute(insert_dummy_query)

# Create procedures.
create_procedures = [
    "CREATE PROCEDURE RecordOrder( \
			IN AccId INTEGER, \
			IN ClientId INTEGER, \
			IN BrokerId INTEGER, \
			IN StockSym VARCHAR(20), \
			IN NumShares INTEGER, \
			IN PricePerShare DECIMAL(13,2), \
			IN Percentage DECIMAL(5,2), \
			IN PriceType VARCHAR(13), \
			IN OrderType VARCHAR(4) \
		) \
		BEGIN \
			DECLARE exit handler FOR SQLEXCEPTION, SQLWARNING \
			BEGIN \
				ROLLBACK; \
				RESIGNAL; \
			END; \
			\
			START TRANSACTION; \
			\
			IF PriceType='Market' THEN \
				INSERT INTO Orders VALUES ( \
					NULL, \
					NumShares, \
					(SELECT PricePerShare FROM Stock WHERE StockSymbol=StockSym), \
					NOW(), \
					Percentage, \
					PriceType, \
					OrderType \
				); \
			ELSE \
				INSERT INTO Orders VALUES ( \
					NULL, \
					NumShares, \
					PricePerShare, \
					NOW(), \
					Percentage, \
					PriceType, \
					OrderType \
				); \
			END IF; \
			\
			SET @order_id = (SELECT LAST_INSERT_ID()); \
			\
			\
			IF PriceType='Market' THEN \
        		INSERT INTO Transactions VALUES ( \
					NULL, \
            		(SELECT NumShares*PricePerShare*0.05 AS Fee FROM Orders WHERE OrderId=@order_id), \
            		NOW(), \
            		(SELECT PricePerShare FROM Orders WHERE OrderId=@order_id) \
				); \
    		ELSE \
        		INSERT INTO Transaction VALUES (NULL,NULL,NULL);\
    		END IF; \
			\
			SET @transaction_id = (SELECT LAST_INSERT_ID()); \
			\
			INSERT INTO Trade VALUES ( \
				AccId, ClientId, BrokerId, @transaction_id, @order_id, StockSym \
			); \
			\
			COMMIT; \
		END;\
		",


    "CREATE PROCEDURE UpdateCustomer( \
		IN uid INTEGER, \
		IN nEmail VARCHAR(32), \
		IN nCreditCardNumber BIGINT, \
		IN nRating INTEGER, \
		IN nLastName VARCHAR(20), \
		IN nFirstName VARCHAR(20), \
		IN nAddress VARCHAR(20), \
		IN nTelephone BIGINT \
	) \
	BEGIN \
		DECLARE exit handler FOR SQLEXCEPTION, SQLWARNING \
		BEGIN \
			ROLLBACK; \
			RESIGNAL; \
		END; \
		\
		START TRANSACTION; \
		\
		UPDATE Person SET \
			LastName=nLastName, \
			FirstName=nFirstName, \
			Address=nAddress, \
			Telephone=nTelephone \
		WHERE SSN = uid; \
		\
		UPDATE Clients SET \
			Email=nEmail, \
			CreditCardNumber=nCreditCardNumber, \
			Rating=nRating \
		WHERE ClientId = uid; \
	END; \
    ",


    "CREATE PROCEDURE CustomerMailingList ( \
		IN bId INTEGER \
	) \
	BEGIN \
		DECLARE exit handler FOR SQLEXCEPTION, SQLWARNING \
		BEGIN \
			ROLLBACK; \
			RESIGNAL; \
		END; \
		\
		START TRANSACTION; \
		\
		SELECT Email From Clients WHERE ClientId IN (SELECT ClientId FROM Trade WHERE BrokerId = bId); \
		\
		COMMIT; \
	END;\
	",


    "CREATE PROCEDURE SuggestStock ( \
		IN cId INTEGER \
	) \
	BEGIN \
		DECLARE exit handler FOR SQLEXCEPTION, SQLWARNING \
		BEGIN \
			ROLLBACK; \
			RESIGNAL; \
		END; \
		\
		START TRANSACTION; \
		\
		SELECT StockSymbol FROM Stock WHERE Type=(SELECT Type FROM Stock WHERE StockSymbol=(SELECT StockId FROM Trade WHERE ClientId=cId GROUP BY StockId ORDER BY COUNT(*) DESC LIMIT 1)); \
		\
		COMMIT; \
	END;\
	"
]

for create_procedures_query in create_procedures:
    mycursor.execute(create_procedures_query)

print("Successful")