/*
 Navicat Premium Data Transfer

 Source Server         : book
 Source Server Type    : MySQL
 Source Server Version : 80040 (8.0.40)
 Source Host           : localhost:3306
 Source Schema         : onlinebookstore

 Target Server Type    : MySQL
 Target Server Version : 80040 (8.0.40)
 File Encoding         : 65001

 Date: 23/12/2024 18:48:19
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for authors
-- ----------------------------
DROP TABLE IF EXISTS `authors`;
CREATE TABLE `authors`  (
  `AuthorID` int NOT NULL AUTO_INCREMENT,
  `ISBN` varchar(13) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `AuthorName` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`AuthorID`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of authors
-- ----------------------------

-- ----------------------------
-- Table structure for books
-- ----------------------------
DROP TABLE IF EXISTS `books`;
CREATE TABLE `books`  (
  `ISBN` varchar(13) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `Title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `Authors` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `SupplierID` int NOT NULL,
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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of books
-- ----------------------------

-- ----------------------------
-- Table structure for customers
-- ----------------------------
DROP TABLE IF EXISTS `customers`;
CREATE TABLE `customers`  (
  `CustomerID` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `Password` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `Name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `Address` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `AccountBalance` decimal(10, 2) NOT NULL,
  `CreditLevel` int NOT NULL,
  PRIMARY KEY (`CustomerID`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of customers
-- ----------------------------

-- ----------------------------
-- Table structure for inventory
-- ----------------------------
DROP TABLE IF EXISTS `inventory`;
CREATE TABLE `inventory`  (
  `InventoryID` int NOT NULL,
  `ISBN` varchar(13) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `StockQuantity` int NULL DEFAULT NULL,
  `Location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
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
  `ISBN` varchar(13) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `Title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `PublisherID` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `SupplierID` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `Quantity` int NOT NULL,
  `Register_Date` datetime NOT NULL,
  PRIMARY KEY (`ISBN`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of missingbooks
-- ----------------------------

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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of orderdetail
-- ----------------------------

-- ----------------------------
-- Table structure for orders
-- ----------------------------
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders`  (
  `OrderID` int NOT NULL AUTO_INCREMENT,
  `CustomerID` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `Date` datetime NULL DEFAULT NULL,
  `Address` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `TotalAmount` decimal(10, 2) NOT NULL,
  `Status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`OrderID`) USING BTREE,
  INDEX `CustomerID`(`CustomerID` ASC) USING BTREE,
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`CustomerID`) REFERENCES `customers` (`CustomerID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of orders
-- ----------------------------

-- ----------------------------
-- Table structure for publishers
-- ----------------------------
DROP TABLE IF EXISTS `publishers`;
CREATE TABLE `publishers`  (
  `PublisherID` int NOT NULL AUTO_INCREMENT,
  `PublisherName` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`PublisherID`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of publishers
-- ----------------------------

-- ----------------------------
-- Table structure for suppliers
-- ----------------------------
DROP TABLE IF EXISTS `suppliers`;
CREATE TABLE `suppliers`  (
  `SupplierID` int NOT NULL AUTO_INCREMENT,
  `SupplierName` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `SupplierInfo` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  PRIMARY KEY (`SupplierID`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of suppliers
-- ----------------------------

-- ----------------------------
-- View structure for view_book_info
-- ----------------------------
DROP VIEW IF EXISTS `view_book_info`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `view_book_info` AS select `books`.`ISBN` AS `id`,`books`.`Title` AS `title`,`books`.`Authors` AS `authors`,`books`.`Price` AS `price`,`books`.`PublisherID` AS `publisher`,`books`.`Keywords` AS `keywords`,`books`.`StockQuantity` AS `stock`,`books`.`SupplierID` AS `supplier`,`books`.`SeriesInfo` AS `seriesNumber` from `books`;

-- ----------------------------
-- View structure for view_customer_info
-- ----------------------------
DROP VIEW IF EXISTS `view_customer_info`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `view_customer_info` AS select `customers`.`CustomerID` AS `id`,`customers`.`Password` AS `password`,`customers`.`Name` AS `name`,`customers`.`Address` AS `address`,`customers`.`AccountBalance` AS `accountbalance`,`customers`.`CreditLevel` AS `creditlevel` from `customers`;

-- ----------------------------
-- View structure for view_order_info
-- ----------------------------
DROP VIEW IF EXISTS `view_order_info`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `view_order_info` AS select `o`.`OrderID` AS `TicketID`,`o`.`TotalAmount` AS `Price`,`o`.`Date` AS `Time`,`od`.`Quantity` AS `Quantity`,`o`.`CustomerID` AS `ReaderID`,`od`.`ISBN` AS `Description`,`o`.`Address` AS `Address`,`o`.`Status` AS `State` from (`orders` `o` join `orderdetail` `od` on((`o`.`OrderID` = `od`.`OrderID`)));

-- ----------------------------
-- Procedure structure for AddNewBook
-- ----------------------------
DROP PROCEDURE IF EXISTS `AddNewBook`;
delimiter ;;
CREATE PROCEDURE `AddNewBook`(IN p_ISBN VARCHAR(13), IN p_Title VARCHAR(255), IN p_PublisherID INT, IN p_Price DECIMAL(10, 2))
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
CREATE PROCEDURE `UpdateInventory`(IN p_ISBN VARCHAR(13), IN p_Quantity INT)
BEGIN
    UPDATE Inventory
    SET StockQuantity = StockQuantity + p_Quantity
    WHERE ISBN = p_ISBN;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table books
-- ----------------------------
DROP TRIGGER IF EXISTS `check_authors_limit_insert`;
delimiter ;;
CREATE TRIGGER `check_authors_limit_insert` BEFORE INSERT ON `books` FOR EACH ROW BEGIN
    -- 检查 Authors 字段中的作者数量
    IF (LENGTH(NEW.Authors) - LENGTH(REPLACE(NEW.Authors, ',', '')) + 1) > 4 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Authors limit exceeded (maximum 4 authors allowed)';
    END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table books
-- ----------------------------
DROP TRIGGER IF EXISTS `check_keyword_limit_update`;
delimiter ;;
CREATE TRIGGER `check_keyword_limit_update` BEFORE UPDATE ON `books` FOR EACH ROW BEGIN
    IF LENGTH(NEW.Keywords) - LENGTH(REPLACE(NEW.Keywords, '、', '')) >= 9 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Keywords limit exceeded';
    END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table books
-- ----------------------------
DROP TRIGGER IF EXISTS `create_book_shortage_record`;
delimiter ;;
CREATE TRIGGER `create_book_shortage_record` AFTER UPDATE ON `books` FOR EACH ROW BEGIN
    -- 检查 StockQuantity 是否小于等于 1
    IF NEW.StockQuantity <= 1 THEN
       
        INSERT INTO missingbooks (ISBN, Title, PublisherID, SupplierID, Quantity, Register_date)
        VALUES (NEW.ISBN, NEW.Title, NEW.PublisherID, NEW.SupplierID, 10, DATE_FORMAT(NOW(), '%Y-%m-%d'));
    END IF;
END
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
