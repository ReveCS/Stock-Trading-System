-- MySQL dump 10.13  Distrib 8.0.31, for Linux (x86_64)
--
-- Host: localhost    Database: stonksmaster
-- ------------------------------------------------------
-- Server version	8.0.31

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Account`
--

DROP TABLE IF EXISTS `Account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Account` (
  `ClientId` int NOT NULL,
  `AccNum` int NOT NULL,
  `DateOpened` date DEFAULT NULL,
  PRIMARY KEY (`ClientId`,`AccNum`),
  CONSTRAINT `Account_ibfk_1` FOREIGN KEY (`ClientId`) REFERENCES `Clients` (`ClientId`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Account`
--

LOCK TABLES `Account` WRITE;
/*!40000 ALTER TABLE `Account` DISABLE KEYS */;
INSERT INTO `Account` VALUES (222222222,1,'2006-10-15'),(444444444,1,'2006-10-01');
/*!40000 ALTER TABLE `Account` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Clients`
--

DROP TABLE IF EXISTS `Clients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Clients` (
  `ClientId` int NOT NULL,
  `Email` varchar(32) DEFAULT NULL,
  `CreditCardNumber` bigint DEFAULT NULL,
  `Rating` int DEFAULT NULL,
  PRIMARY KEY (`ClientId`),
  CONSTRAINT `Clients_ibfk_1` FOREIGN KEY (`ClientId`) REFERENCES `Person` (`SSN`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Clients`
--

LOCK TABLES `Clients` WRITE;
/*!40000 ALTER TABLE `Clients` DISABLE KEYS */;
INSERT INTO `Clients` VALUES (111111111,'syang@cs.sunysb.edu',1234567812345678,1),(222222222,'vicdu@cs.sunysb.edu',5678123456781234,1),(333333333,'jsmith@ic.sunysb.edu',2345678923456789,1),(444444444,'pml@cs.sunysb.edu',6789234567892345,1);
/*!40000 ALTER TABLE `Clients` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Employee`
--

DROP TABLE IF EXISTS `Employee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Employee` (
  `EmpId` int NOT NULL,
  `StartDate` date DEFAULT NULL,
  `HourlyRate` int DEFAULT NULL,
  PRIMARY KEY (`EmpId`),
  CONSTRAINT `Employee_ibfk_1` FOREIGN KEY (`EmpId`) REFERENCES `Person` (`SSN`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Employee`
--

LOCK TABLES `Employee` WRITE;
/*!40000 ALTER TABLE `Employee` DISABLE KEYS */;
INSERT INTO `Employee` VALUES (123456789,'2005-11-01',60),(789123456,'2005-11-01',50);
/*!40000 ALTER TABLE `Employee` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Location`
--

DROP TABLE IF EXISTS `Location`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Location` (
  `ZipCode` mediumint NOT NULL,
  `City` varchar(20) NOT NULL,
  `State` varchar(20) NOT NULL,
  PRIMARY KEY (`ZipCode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Location`
--

LOCK TABLES `Location` WRITE;
/*!40000 ALTER TABLE `Location` DISABLE KEYS */;
INSERT INTO `Location` VALUES (11790,'Stony Brook','NY'),(11794,'Stony Brook','NY'),(93536,'Los Angeles','CA');
/*!40000 ALTER TABLE `Location` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Orders`
--

DROP TABLE IF EXISTS `Orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Orders` (
  `OrderId` int NOT NULL AUTO_INCREMENT,
  `NumShares` int DEFAULT NULL,
  `PricePerShare` decimal(13,2) DEFAULT NULL,
  `DateTime` datetime DEFAULT NULL,
  `Percentage` decimal(5,3) DEFAULT NULL,
  `PriceType` varchar(13) DEFAULT NULL,
  `OrderType` varchar(4) DEFAULT NULL,
  PRIMARY KEY (`OrderId`),
  CONSTRAINT `Orders_chk_1` CHECK ((`PriceType` in (_utf8mb3'Market',_utf8mb3'MarketOnClose',_utf8mb3'TrailingStop',_utf8mb3'HiddenStop'))),
  CONSTRAINT `Orders_chk_2` CHECK ((`OrderType` in (_utf8mb3'Buy',_utf8mb3'Sell')))
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Orders`
--

LOCK TABLES `Orders` WRITE;
/*!40000 ALTER TABLE `Orders` DISABLE KEYS */;
INSERT INTO `Orders` VALUES (1,75,25.51,'2022-11-07 00:00:00',NULL,'Market','Buy'),(2,10,105.61,'2022-11-07 00:00:00',5.000,'TrailingStop','Sell');
/*!40000 ALTER TABLE `Orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Person`
--

DROP TABLE IF EXISTS `Person`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Person` (
  `SSN` int NOT NULL,
  `LastName` varchar(20) NOT NULL,
  `FirstName` varchar(20) NOT NULL,
  `Address` varchar(20) DEFAULT NULL,
  `ZipCode` mediumint DEFAULT NULL,
  `Telephone` bigint DEFAULT NULL,
  PRIMARY KEY (`SSN`),
  KEY `ZipCode` (`ZipCode`),
  CONSTRAINT `Person_ibfk_1` FOREIGN KEY (`ZipCode`) REFERENCES `Location` (`ZipCode`) ON UPDATE CASCADE,
  CONSTRAINT `Person_chk_1` CHECK (((`SSN` > 0) and (`SSN` < 1000000000)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Person`
--

LOCK TABLES `Person` WRITE;
/*!40000 ALTER TABLE `Person` DISABLE KEYS */;
INSERT INTO `Person` VALUES (111111111,'Yang','Shang','123 Success Street',11790,5166328959),(123456789,'Smith','David','123 College road',11790,5162152345),(222222222,'Du','Victor','456 Fortune Road',11790,5166324360),(333333333,'Smith','John','789 Peace Blvd',93536,3154434321),(444444444,'Philip','Lewis','135 Knowledge Lane',11794,5166668888),(789123456,'Warren','David','456 Sunken Street',11790,5162152345);
/*!40000 ALTER TABLE `Person` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Stock`
--

DROP TABLE IF EXISTS `Stock`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Stock` (
  `StockSymbol` varchar(20) NOT NULL,
  `CompanyName` varchar(20) NOT NULL,
  `Type` varchar(20) NOT NULL,
  `PricePerShare` decimal(13,2) DEFAULT NULL,
  `NumShares` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`StockSymbol`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Stock`
--

LOCK TABLES `Stock` WRITE;
/*!40000 ALTER TABLE `Stock` DISABLE KEYS */;
INSERT INTO `Stock` VALUES ('F','Ford','automotive',9.00,750),('GM','General Motors','automotive',34.23,1000),('IBM','IBM','computer',91.41,500);
/*!40000 ALTER TABLE `Stock` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `StockPortfolio`
--

DROP TABLE IF EXISTS `StockPortfolio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `StockPortfolio` (
  `ClientId` int DEFAULT NULL,
  `AccNum` int DEFAULT NULL,
  `Stock` varchar(20) NOT NULL,
  `NumShares` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`Stock`),
  KEY `ClientId` (`ClientId`,`AccNum`),
  CONSTRAINT `StockPortfolio_ibfk_1` FOREIGN KEY (`Stock`) REFERENCES `Stock` (`StockSymbol`),
  CONSTRAINT `StockPortfolio_ibfk_2` FOREIGN KEY (`ClientId`, `AccNum`) REFERENCES `Account` (`ClientId`, `AccNum`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `StockPortfolio`
--

LOCK TABLES `StockPortfolio` WRITE;
/*!40000 ALTER TABLE `StockPortfolio` DISABLE KEYS */;
INSERT INTO `StockPortfolio` VALUES (444444444,1,'F',100),(444444444,1,'GM',250),(222222222,1,'IBM',50);
/*!40000 ALTER TABLE `StockPortfolio` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Trade`
--

DROP TABLE IF EXISTS `Trade`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Trade` (
  `AccountId` int NOT NULL,
  `ClientId` int NOT NULL,
  `BrokerId` int NOT NULL,
  `TransactionId` int NOT NULL,
  `OrderId` int NOT NULL,
  `StockId` varchar(20) NOT NULL,
  PRIMARY KEY (`AccountId`,`ClientId`,`BrokerId`,`TransactionId`,`OrderId`,`StockId`),
  KEY `ClientId` (`ClientId`,`AccountId`),
  KEY `BrokerId` (`BrokerId`),
  KEY `TransactionId` (`TransactionId`),
  KEY `OrderId` (`OrderId`),
  KEY `StockId` (`StockId`),
  CONSTRAINT `Trade_ibfk_1` FOREIGN KEY (`ClientId`, `AccountId`) REFERENCES `Account` (`ClientId`, `AccNum`) ON UPDATE CASCADE,
  CONSTRAINT `Trade_ibfk_2` FOREIGN KEY (`BrokerId`) REFERENCES `Employee` (`EmpId`) ON UPDATE CASCADE,
  CONSTRAINT `Trade_ibfk_3` FOREIGN KEY (`TransactionId`) REFERENCES `Transactions` (`TxnId`) ON UPDATE CASCADE,
  CONSTRAINT `Trade_ibfk_4` FOREIGN KEY (`OrderId`) REFERENCES `Orders` (`OrderId`) ON UPDATE CASCADE,
  CONSTRAINT `Trade_ibfk_5` FOREIGN KEY (`StockId`) REFERENCES `Stock` (`StockSymbol`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Trade`
--

LOCK TABLES `Trade` WRITE;
/*!40000 ALTER TABLE `Trade` DISABLE KEYS */;
INSERT INTO `Trade` VALUES (1,222222222,123456789,2,2,'IBM'),(1,444444444,123456789,1,1,'GM');
/*!40000 ALTER TABLE `Trade` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Transactions`
--

DROP TABLE IF EXISTS `Transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Transactions` (
  `TxnId` int NOT NULL AUTO_INCREMENT,
  `Fee` decimal(13,2) DEFAULT NULL,
  `DateTime` datetime DEFAULT NULL,
  `PricePerShare` decimal(13,2) DEFAULT NULL,
  PRIMARY KEY (`TxnId`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Transactions`
--

LOCK TABLES `Transactions` WRITE;
/*!40000 ALTER TABLE `Transactions` DISABLE KEYS */;
INSERT INTO `Transactions` VALUES (1,95.66,'2022-11-07 00:00:00',25.51),(2,45.00,'2022-11-07 00:00:00',90.00);
/*!40000 ALTER TABLE `Transactions` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-11-30 17:59:16
