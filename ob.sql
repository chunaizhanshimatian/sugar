/*
 Navicat Premium Data Transfer

 Source Server         : MySQL
 Source Server Type    : MySQL
 Source Server Version : 80040 (8.0.40)
 Source Host           : localhost:3306
 Source Schema         : ob

 Target Server Type    : MySQL
 Target Server Version : 80040 (8.0.40)
 File Encoding         : 65001

 Date: 26/12/2024 19:36:41
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for authors
-- ----------------------------
DROP TABLE IF EXISTS `authors`;
CREATE TABLE `authors`  (
  `AuthorID` int NOT NULL AUTO_INCREMENT,
  `AuthorName` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`AuthorID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of authors
-- ----------------------------
INSERT INTO `authors` VALUES (6, '1');
INSERT INTO `authors` VALUES (7, '1');

-- ----------------------------
-- Table structure for backorder
-- ----------------------------
DROP TABLE IF EXISTS `backorder`;
CREATE TABLE `backorder`  (
  `BackOrderID` int NOT NULL AUTO_INCREMENT,
  `ISBN` int NULL DEFAULT NULL,
  `BookTitle` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `PublisherID` int NULL DEFAULT NULL,
  `SupplierID` int NULL DEFAULT NULL,
  `Quantity` int NULL DEFAULT NULL,
  `RegistrationDate` date NULL DEFAULT NULL,
  PRIMARY KEY (`BackOrderID`) USING BTREE,
  INDEX `ISBN`(`ISBN` ASC) USING BTREE,
  INDEX `SupplierID`(`SupplierID` ASC) USING BTREE,
  CONSTRAINT `backorder_ibfk_2` FOREIGN KEY (`ISBN`) REFERENCES `books` (`ISBN`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 26 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of backorder
-- ----------------------------
INSERT INTO `backorder` VALUES (23, 1, '1', 1, 1, 12, '2024-12-25');

-- ----------------------------
-- Table structure for book_authors
-- ----------------------------
DROP TABLE IF EXISTS `book_authors`;
CREATE TABLE `book_authors`  (
  `BookISBN` int NOT NULL,
  `AuthorID` int NOT NULL,
  INDEX `book_authors_ibfk_1`(`BookISBN` ASC) USING BTREE,
  CONSTRAINT `book_authors_ibfk_1` FOREIGN KEY (`BookISBN`) REFERENCES `books` (`ISBN`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of book_authors
-- ----------------------------
INSERT INTO `book_authors` VALUES (7, 6);
INSERT INTO `book_authors` VALUES (8, 7);

-- ----------------------------
-- Table structure for book_suppliers
-- ----------------------------
DROP TABLE IF EXISTS `book_suppliers`;
CREATE TABLE `book_suppliers`  (
  `BookISBN` int NOT NULL,
  `SupplierID` int NOT NULL,
  INDEX `book_suppliers_ibfk_1`(`BookISBN` ASC) USING BTREE,
  CONSTRAINT `book_suppliers_ibfk_1` FOREIGN KEY (`BookISBN`) REFERENCES `books` (`ISBN`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of book_suppliers
-- ----------------------------
INSERT INTO `book_suppliers` VALUES (7, 2);
INSERT INTO `book_suppliers` VALUES (8, 2);

-- ----------------------------
-- Table structure for books
-- ----------------------------
DROP TABLE IF EXISTS `books`;
CREATE TABLE `books`  (
  `ISBN` int NOT NULL AUTO_INCREMENT,
  `Title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `PublisherID` int NULL DEFAULT NULL,
  `Price` decimal(10, 2) NOT NULL,
  `Keywords` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `Summary` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `CoverImage` blob NULL,
  `StockQuantity` int NULL DEFAULT NULL,
  `SeriesInfo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `Location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`ISBN`) USING BTREE,
  INDEX `PublisherID`(`PublisherID` ASC) USING BTREE,
  CONSTRAINT `books_ibfk_1` FOREIGN KEY (`PublisherID`) REFERENCES `publishers` (`PublisherID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of books
-- ----------------------------
INSERT INTO `books` VALUES (1, '1', NULL, 1.00, NULL, NULL, NULL, 1, NULL, NULL);
INSERT INTO `books` VALUES (2, '2', NULL, 2.00, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `books` VALUES (3, '11', NULL, 1.00, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `books` VALUES (4, '123', NULL, 111.00, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `books` VALUES (5, '11', NULL, 1.00, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `books` VALUES (6, '11', NULL, 11.00, '1', '', '', 1, NULL, NULL);
INSERT INTO `books` VALUES (7, '1', NULL, 1.00, '1', '1', NULL, 1, NULL, NULL);
INSERT INTO `books` VALUES (8, '1', NULL, 1.00, '1', '1', NULL, 1, NULL, NULL);

-- ----------------------------
-- Table structure for customers
-- ----------------------------
DROP TABLE IF EXISTS `customers`;
CREATE TABLE `customers`  (
  `CustomerID` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `Password` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `Name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `Address` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `AccountBalance` decimal(10, 2) UNSIGNED ZEROFILL NULL DEFAULT NULL,
  `CreditLevel` int(10) UNSIGNED ZEROFILL NULL DEFAULT NULL,
  PRIMARY KEY (`CustomerID`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of customers
-- ----------------------------
INSERT INTO `customers` VALUES ('1', 'scrypt:32768:8:1$EDASaXpFRA1Uh7bV$cf3e0e943e3fff93510ac34551b128bec96d04fbf303d89af1bd22eb35690c88116b69c81f999678618011698705c787978d843fd343fa320bf8f04ee9f90860', '1', '', NULL, NULL);
INSERT INTO `customers` VALUES ('11', 'scrypt:32768:8:1$mYIwW0Fg9huUj73L$7dbf4870fd156f23beb1413e3498253ede0caa7016fa41e20d28ea958c3070cadf6b93685b8f454dae4e4d9db9a4dd626554c70a9cdb4fe508f30fece309de47', '11', '', NULL, NULL);
INSERT INTO `customers` VALUES ('111', 'scrypt:32768:8:1$FZQiBY46XTqlxrbP$42739c93f0ea43fd67fac8837567dc5a9e0b792ff78e7d957fc2f6f2164de75fa0d005f46de3783b77e10760445c927f7d9aba5b6377b4f781557a1b99a21e6d', '111', '', NULL, NULL);
INSERT INTO `customers` VALUES ('1111', 'scrypt:32768:8:1$GWYsXgyXDYhkTEzb$aaf05160ef40adefb9e364e158478035ea2ed1ec30023658c42357fdd61f743a9248e82ef8a688e3e897455bdc7ab6edf26cf1337e830af9ceef32991aa93fb6', '1111', '', NULL, NULL);
INSERT INTO `customers` VALUES ('11111', 'scrypt:32768:8:1$5As42dECCAHS9PqZ$b9d4d164b49d8240942ba814e4f51e0fc789d152b6782a1d0646d608909f99f8f6fefe5a7ee0d00664e026a72cd359048eab82e83868c69843d9136feb5e4a5f', '11111', '', NULL, NULL);
INSERT INTO `customers` VALUES ('1111111111111', 'scrypt:32768:8:1$aBuufVhnlGb3mtCg$9979bfac8c711a1786116d2e154f01bf11a292ab5b43cff0afe8fa280dced14b7fbbb4536e78d9c0501ea1279d948342205549f6641a8dda232b0719af3bcd71', '1111111111111', '', NULL, NULL);
INSERT INTO `customers` VALUES ('2', 'scrypt:32768:8:1$PlDxhGVFbUloGeJ3$151a762190ec708cf1eeef56457d538961ea3e7f4f71d8724a8769eb517a1b3fbbc8ab27fa8564e2499e04456add26984e15ce3d50887a632863fc1ee32c6516', '2', '', NULL, NULL);
INSERT INTO `customers` VALUES ('3', 'scrypt:32768:8:1$9TbPBZWfYaEZuuQY$8968403563edb4678ad8fac05ffa7a0ce36e60d5018d4f7d72bf519e3b8843897c7df82145d28badb4ea6fd521327dcaccc42c7bf7898d3b83a0e6320af32d7b', '3', '', NULL, NULL);
INSERT INTO `customers` VALUES ('4', 'scrypt:32768:8:1$Oy1exssrKWqeg083$d12044c6cca7ac7c157abd3ffb6f8ffcacac0b27fcb02d6a8569cb1ba59293dc33f80af0120740ecb322e3c48f24bd51a0aa6376244d12c6db5e83a7a9652269', '4', '', NULL, NULL);

-- ----------------------------
-- Table structure for inventory
-- ----------------------------
DROP TABLE IF EXISTS `inventory`;
CREATE TABLE `inventory`  (
  `ISBN` int NOT NULL,
  `SupplierID` int NULL DEFAULT NULL,
  `StockQuantity` int NULL DEFAULT NULL,
  PRIMARY KEY (`ISBN`) USING BTREE,
  CONSTRAINT `inventory_ibfk_1` FOREIGN KEY (`ISBN`) REFERENCES `books` (`ISBN`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of inventory
-- ----------------------------

-- ----------------------------
-- Table structure for missingbooks
-- ----------------------------
DROP TABLE IF EXISTS `missingbooks`;
CREATE TABLE `missingbooks`  (
  `ISBN` int NOT NULL,
  `Title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `PublisherID` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `SupplierID` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `Quantity` int NOT NULL,
  `Register_Date` datetime NOT NULL,
  PRIMARY KEY (`ISBN`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of missingbooks
-- ----------------------------
INSERT INTO `missingbooks` VALUES (1, '1', '1', '1', 1, '2024-12-26 00:00:00');
INSERT INTO `missingbooks` VALUES (111, '1', '1', '1', 1, '2024-12-23 00:00:00');

-- ----------------------------
-- Table structure for orderdetail
-- ----------------------------
DROP TABLE IF EXISTS `orderdetail`;
CREATE TABLE `orderdetail`  (
  `OrderID` int NOT NULL,
  `ISBN` varchar(13) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `Quantity` int NOT NULL,
  PRIMARY KEY (`OrderID`) USING BTREE,
  CONSTRAINT `fk_orderID` FOREIGN KEY (`OrderID`) REFERENCES `orders` (`OrderID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of orderdetail
-- ----------------------------
INSERT INTO `orderdetail` VALUES (2, '123', 1);

-- ----------------------------
-- Table structure for orderdetails
-- ----------------------------
DROP TABLE IF EXISTS `orderdetails`;
CREATE TABLE `orderdetails`  (
  `OrderDetailID` int NOT NULL AUTO_INCREMENT,
  `OrderID` int NULL DEFAULT NULL,
  `ISBN` int NULL DEFAULT NULL,
  `Quantity` int NULL DEFAULT NULL,
  `PriceAtOrder` decimal(10, 2) NULL DEFAULT NULL,
  PRIMARY KEY (`OrderDetailID`) USING BTREE,
  INDEX `OrderID`(`OrderID` ASC) USING BTREE,
  INDEX `ISBN`(`ISBN` ASC) USING BTREE,
  CONSTRAINT `orderdetails_ibfk_1` FOREIGN KEY (`OrderID`) REFERENCES `orders` (`OrderID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `orderdetails_ibfk_2` FOREIGN KEY (`ISBN`) REFERENCES `books` (`ISBN`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of orderdetails
-- ----------------------------

-- ----------------------------
-- Table structure for orders
-- ----------------------------
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders`  (
  `OrderID` int NOT NULL AUTO_INCREMENT,
  `OrderDate` date NOT NULL,
  `CustomerID` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `ShippingAddress` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `TotalAmount` decimal(10, 2) NOT NULL,
  `ShippingStatus` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`OrderID`) USING BTREE,
  INDEX `CustomerID`(`CustomerID` ASC) USING BTREE,
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`CustomerID`) REFERENCES `customers` (`CustomerID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of orders
-- ----------------------------
INSERT INTO `orders` VALUES (1, '2024-12-26', '1', '1', 1.00, '未发货');

-- ----------------------------
-- Table structure for publishers
-- ----------------------------
DROP TABLE IF EXISTS `publishers`;
CREATE TABLE `publishers`  (
  `PublisherID` int NOT NULL AUTO_INCREMENT,
  `PublisherName` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`PublisherID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of publishers
-- ----------------------------
INSERT INTO `publishers` VALUES (1, '1');

-- ----------------------------
-- Table structure for suppliers
-- ----------------------------
DROP TABLE IF EXISTS `suppliers`;
CREATE TABLE `suppliers`  (
  `SupplierID` int NOT NULL AUTO_INCREMENT,
  `SupplierName` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `SupplierInfo` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  PRIMARY KEY (`SupplierID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of suppliers
-- ----------------------------
INSERT INTO `suppliers` VALUES (1, '激肽酶', '1');
INSERT INTO `suppliers` VALUES (2, '1', NULL);

-- ----------------------------
-- View structure for view_customer_info
-- ----------------------------
DROP VIEW IF EXISTS `view_customer_info`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `view_customer_info` AS select `customers`.`CustomerID` AS `id`,`customers`.`Password` AS `password`,`customers`.`Name` AS `name`,`customers`.`Address` AS `address`,`customers`.`AccountBalance` AS `accountbalance`,`customers`.`CreditLevel` AS `creditlevel` from `customers`;

-- ----------------------------
-- View structure for view_order_info
-- ----------------------------
DROP VIEW IF EXISTS `view_order_info`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `view_order_info` AS select `o`.`OrderID` AS `TicketID`,`o`.`TotalAmount` AS `Price`,`o`.`OrderDate` AS `Time`,`od`.`Quantity` AS `Quantity`,`o`.`CustomerID` AS `ReaderID`,`od`.`ISBN` AS `Description`,`o`.`ShippingAddress` AS `Address`,`o`.`ShippingStatus` AS `State` from (`orders` `o` join `orderdetails` `od` on((`o`.`OrderID` = `od`.`OrderID`)));

-- ----------------------------
-- View structure for viewcustomerorders
-- ----------------------------
DROP VIEW IF EXISTS `viewcustomerorders`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `viewcustomerorders` AS select `c`.`CustomerID` AS `CustomerID`,`c`.`Name` AS `Name`,`o`.`OrderID` AS `OrderID`,`o`.`OrderDate` AS `OrderDate` from (`customers` `c` join `orders` `o` on((`c`.`CustomerID` = `o`.`CustomerID`)));

-- ----------------------------
-- Procedure structure for AddNewBook
-- ----------------------------
DROP PROCEDURE IF EXISTS `AddNewBook`;
delimiter ;;
CREATE PROCEDURE `AddNewBook`(IN p_ISBN INT, IN p_Title VARCHAR(255), IN p_PublisherID INT, IN p_Price DECIMAL(10, 2))
BEGIN
    INSERT INTO Books (ISBN, Title, PublisherID, Price)
    VALUES (p_ISBN, p_Title, p_PublisherID, p_Price);
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for UpdateInventory
-- ----------------------------
DROP PROCEDURE IF EXISTS `UpdateInventory`;
delimiter ;;
CREATE PROCEDURE `UpdateInventory`(IN p_ISBN INT, IN p_Quantity INT)
BEGIN
    UPDATE Inventory
    SET StockQuantity = StockQuantity + p_Quantity
    WHERE ISBN = p_ISBN;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table orderdetails
-- ----------------------------
DROP TRIGGER IF EXISTS `AfterOrderPlacement`;
delimiter ;;
CREATE TRIGGER `AfterOrderPlacement` AFTER INSERT ON `orderdetails` FOR EACH ROW BEGIN
    UPDATE Inventory
    SET StockQuantity = StockQuantity - NEW.Quantity
    WHERE ISBN = NEW.ISBN;
END
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
