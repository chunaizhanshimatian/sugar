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

 Date: 03/01/2025 09:04:33
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
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of authors
-- ----------------------------
INSERT INTO `authors` VALUES (1, '作者1');
INSERT INTO `authors` VALUES (2, '作者1，作者2');
INSERT INTO `authors` VALUES (3, '作者3');

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
INSERT INTO `book_authors` VALUES (2, 1);
INSERT INTO `book_authors` VALUES (3, 2);
INSERT INTO `book_authors` VALUES (4, 3);

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
INSERT INTO `book_suppliers` VALUES (2, 1);
INSERT INTO `book_suppliers` VALUES (3, 1);
INSERT INTO `book_suppliers` VALUES (4, 1);

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
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of books
-- ----------------------------
INSERT INTO `books` VALUES (2, '书1', 1, 10.00, '1', NULL, NULL, 99, NULL, NULL);
INSERT INTO `books` VALUES (3, '书2', 2, 20.00, '1,2', NULL, NULL, 200, NULL, NULL);
INSERT INTO `books` VALUES (4, '书3', 2, 50.00, '3', NULL, NULL, 1, NULL, NULL);

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
INSERT INTO `customers` VALUES ('hyn', 'scrypt:32768:8:1$RxfMvi9K6ob4ONEh$a3d8487459eecb4e32df8efe0acad814631105ac71de322d18e022cc95a3158d83c4a0b44bc118d0a3847c4584fd0de41c705c81ce3ea8f8d249570ee02f19d4', 'hyn', 'hust', 00010000.00, 0000000001);

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
INSERT INTO `missingbooks` VALUES (4, '书3', '2', '1', 1, '2025-01-03 09:00:36');

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
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of orderdetails
-- ----------------------------
INSERT INTO `orderdetails` VALUES (1, NULL, 2, 1, 10.00);
INSERT INTO `orderdetails` VALUES (2, NULL, 4, 2, 50.00);
INSERT INTO `orderdetails` VALUES (5, NULL, 4, 3, 50.00);
INSERT INTO `orderdetails` VALUES (6, NULL, 4, 2, 50.00);

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
  PRIMARY KEY (`OrderID` DESC) USING BTREE,
  INDEX `CustomerID`(`CustomerID` ASC) USING BTREE,
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`CustomerID`) REFERENCES `customers` (`CustomerID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of orders
-- ----------------------------
INSERT INTO `orders` VALUES (10, '2025-01-03', 'hyn', 'hust', 100.00, '已发货');
INSERT INTO `orders` VALUES (9, '2025-01-03', 'hyn', 'hust', 150.00, '已发货');
INSERT INTO `orders` VALUES (8, '2025-01-03', 'hyn', 'hust', 100.00, '已发货');
INSERT INTO `orders` VALUES (7, '2025-01-03', 'hyn', 'hust', 10.00, '已发货');
INSERT INTO `orders` VALUES (6, '2025-01-03', 'hyn', 'hust', 30.00, '已发货');
INSERT INTO `orders` VALUES (5, '2025-01-03', 'hyn', 'hust', 10.00, '已发货');
INSERT INTO `orders` VALUES (4, '2025-01-03', 'hyn', 'hust', 60.00, '已发货');
INSERT INTO `orders` VALUES (1, '2025-01-03', 'hyn', 'hust', 20.00, '已发货');

-- ----------------------------
-- Table structure for publishers
-- ----------------------------
DROP TABLE IF EXISTS `publishers`;
CREATE TABLE `publishers`  (
  `PublisherID` int NOT NULL AUTO_INCREMENT,
  `PublisherName` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`PublisherID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of publishers
-- ----------------------------
INSERT INTO `publishers` VALUES (1, '出版社1');
INSERT INTO `publishers` VALUES (2, '出版社2');

-- ----------------------------
-- Table structure for suppliers
-- ----------------------------
DROP TABLE IF EXISTS `suppliers`;
CREATE TABLE `suppliers`  (
  `SupplierID` int NOT NULL AUTO_INCREMENT,
  `SupplierName` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `SupplierInfo` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  PRIMARY KEY (`SupplierID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of suppliers
-- ----------------------------
INSERT INTO `suppliers` VALUES (1, '供书商1', NULL);

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
-- Triggers structure for table books
-- ----------------------------
DROP TRIGGER IF EXISTS `AfterBookUpdate`;
delimiter ;;
CREATE TRIGGER `AfterBookUpdate` AFTER UPDATE ON `books` FOR EACH ROW BEGIN
    IF OLD.StockQuantity >= 0 AND NEW.StockQuantity < 0 THEN
        -- 插入一条新记录到missingbooks表，记录库存变为负数的书籍和缺少的数量
        INSERT INTO missingbooks (ISBN, Title, PublisherID, SupplierID, Quantity, Register_Date)
        VALUES (
            NEW.ISBN, -- 使用更新后的新ISBN
            NEW.Title, -- 假设books表中包含Title字段
            NEW.PublisherID, -- 使用更新后的新PublisherID
            (SELECT SupplierID FROM book_suppliers WHERE BookISBN = NEW.ISBN LIMIT 1), -- 假设只有一个供应商
            -NEW.StockQuantity, -- 缺少的数量，即更新前的数量减去更新后的数量
            NOW() -- 注册日期
        );
    END IF;
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

-- ----------------------------
-- Triggers structure for table orderdetails
-- ----------------------------
DROP TRIGGER IF EXISTS `AfterOrderDetailInsertion`;
delimiter ;;
CREATE TRIGGER `AfterOrderDetailInsertion` AFTER INSERT ON `orderdetails` FOR EACH ROW BEGIN
    DECLARE v_isbn INT;
    DECLARE v_quantity INT;

    -- 获取书籍ISBN和订单数量
    SET v_isbn = NEW.ISBN;
    SET v_quantity = NEW.Quantity;

    -- 更新书籍库存
    UPDATE books
    SET StockQuantity = StockQuantity - v_quantity
    WHERE ISBN = v_isbn;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table orders
-- ----------------------------
DROP TRIGGER IF EXISTS `AfterOrderCreation`;
delimiter ;;
CREATE TRIGGER `AfterOrderCreation` AFTER INSERT ON `orders` FOR EACH ROW BEGIN
    DECLARE v_customer_id VARCHAR(50);
    DECLARE v_total_amount DECIMAL(10, 2);

    -- 获取订单的客户ID和总金额
    SET v_customer_id = NEW.CustomerID;
    SET v_total_amount = NEW.TotalAmount;

    -- 更新用户余额
    UPDATE customers
    SET AccountBalance = AccountBalance - v_total_amount
    WHERE CustomerID = v_customer_id;
END
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
