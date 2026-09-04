CREATE DATABASE  IF NOT EXISTS `pj3` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `pj3`;
-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: localhost    Database: pj3
-- ------------------------------------------------------
-- Server version	8.0.43

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `__efmigrationshistory`
--

DROP TABLE IF EXISTS `__efmigrationshistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `__efmigrationshistory` (
  `MigrationId` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `ProductVersion` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`MigrationId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `__efmigrationshistory`
--

LOCK TABLES `__efmigrationshistory` WRITE;
/*!40000 ALTER TABLE `__efmigrationshistory` DISABLE KEYS */;
INSERT INTO `__efmigrationshistory` VALUES ('20260811100148_InitialBaseline','9.0.12'),('20260904102553_AddTransportOrderFacilities','9.0.12'),('20260904150624_AddManifestItemWeight','9.0.12'),('20260904172950_AddManifestItemToPackageScan','9.0.12');
/*!40000 ALTER TABLE `__efmigrationshistory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `audit_logs`
--

DROP TABLE IF EXISTS `audit_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `audit_logs` (
  `id` char(36) NOT NULL DEFAULT (uuid()),
  `user_id` char(36) NOT NULL,
  `action` varchar(100) NOT NULL,
  `table_name` varchar(100) NOT NULL,
  `record_id` char(36) NOT NULL,
  `old_data` json DEFAULT NULL,
  `new_data` json DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_audit_logs_user` (`user_id`),
  KEY `idx_audit_logs_record` (`record_id`),
  KEY `idx_audit_logs_table` (`table_name`),
  KEY `idx_audit_logs_created_at` (`created_at`),
  CONSTRAINT `fk_audit_logs_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit_logs`
--

LOCK TABLES `audit_logs` WRITE;
/*!40000 ALTER TABLE `audit_logs` DISABLE KEYS */;
INSERT INTO `audit_logs` VALUES ('a10b7afd-a5ed-11f1-92a0-a0ad9f192341','a0f338e8-a5ed-11f1-92a0-a0ad9f192341','CREATE','facilities','a0f6af92-a5ed-11f1-92a0-a0ad9f192341',NULL,'{\"code\": \"BOM-001\", \"name\": \"Mumbai Branch\"}','192.168.1.1','Mozilla/5.0','Facility created','2026-09-01 10:12:25'),('a10d34ef-a5ed-11f1-92a0-a0ad9f192341','a0f338e8-a5ed-11f1-92a0-a0ad9f192341','CREATE','facilities','a0f6b317-a5ed-11f1-92a0-a0ad9f192341',NULL,'{\"code\": \"BOM-DC\", \"name\": \"Mumbai Distribution Center\"}','192.168.1.1','Mozilla/5.0','Facility created','2026-09-01 10:12:25'),('a10d3980-a5ed-11f1-92a0-a0ad9f192341','a0f338e8-a5ed-11f1-92a0-a0ad9f192341','UPDATE','facilities','a0f6b3d5-a5ed-11f1-92a0-a0ad9f192341','{\"capacity\": 4000}','{\"capacity\": 4500}','192.168.1.1','Mozilla/5.0','Capacity updated','2026-09-01 10:12:25'),('a10d3b12-a5ed-11f1-92a0-a0ad9f192341','a0f33fb5-a5ed-11f1-92a0-a0ad9f192341','CREATE','shipments','a102f87e-a5ed-11f1-92a0-a0ad9f192341',NULL,'{\"tracking\": \"TRK-001-2024\"}','192.168.1.2','Mozilla/5.0','Shipment created','2026-09-01 10:12:25');
/*!40000 ALTER TABLE `audit_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer_addresses`
--

DROP TABLE IF EXISTS `customer_addresses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer_addresses` (
  `id` char(36) NOT NULL DEFAULT (uuid()),
  `customer_id` char(36) NOT NULL,
  `address_type` varchar(50) NOT NULL,
  `recipient_name` varchar(200) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `address_line1` varchar(255) NOT NULL,
  `address_line2` varchar(255) DEFAULT NULL,
  `city` varchar(100) NOT NULL,
  `state` varchar(100) DEFAULT NULL,
  `pincode` varchar(20) NOT NULL,
  `country` varchar(100) DEFAULT 'India',
  `landmark` varchar(255) DEFAULT NULL,
  `is_default` tinyint(1) DEFAULT '0',
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_customer_addresses_customer` (`customer_id`),
  CONSTRAINT `fk_customer_addresses_customer` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_addresses`
--

LOCK TABLES `customer_addresses` WRITE;
/*!40000 ALTER TABLE `customer_addresses` DISABLE KEYS */;
INSERT INTO `customer_addresses` VALUES ('0b7375c2-25cc-4699-a998-2ee785bff606','a3021835-cca6-496a-a64a-13fbfffebb43','','','1231241213','faaffa',NULL,'fsafsfas','1123','131135123','Vietnam',NULL,1,1,'2026-09-03 21:36:53','2026-09-04 04:36:52'),('189a71e1-24d1-49bc-93e0-5c2fbbd67a8d','a3021835-cca6-496a-a64a-13fbfffebb43','','','153513531531','asdqwfsasdqwe',NULL,'qwerewqet','qwdqdas','153153315','Vietnam',NULL,0,1,'2026-09-03 21:34:04','2026-09-04 04:36:21'),('20ea071c-a604-11f1-92a0-a0ad9f192341','a0fb5651-a5ed-11f1-92a0-a0ad9f192341','home','Demo Customer','0987654321','123 Nguyen Trai','Thanh Xuan','Hanoi','Hanoi','100000','Vietnam','Near Royal City',1,1,'2026-09-01 12:53:28','2026-09-01 12:53:28'),('20ea1563-a604-11f1-92a0-a0ad9f192341','a0fb5651-a5ed-11f1-92a0-a0ad9f192341','office','Demo Receiver','0987654322','456 Le Loi','District 1','Ho Chi Minh City','Ho Chi Minh','700000','Vietnam','Near Ben Thanh Market',0,1,'2026-09-01 12:53:28','2026-09-01 12:53:28'),('6fb52e1d-96b7-433d-b453-be167ac6c9e5','a710bd70-3861-4d24-8663-e47fe4d198cb','','','513531153253','ewq','ewq','ewq','ewq','1661414','Vietnam',NULL,0,1,'2026-09-03 20:33:14','2026-09-04 03:33:13'),('78844ae3-8c01-4da4-9fbc-d4311fe3598f','a710bd70-3861-4d24-8663-e47fe4d198cb','','','153513513','fqfq','fqfqfq','fqqg','geqgeq','315531','Vietnam',NULL,1,1,'2026-09-03 20:37:01','2026-09-04 03:37:01'),('a0fee87e-a5ed-11f1-92a0-a0ad9f192341','a0fb5651-a5ed-11f1-92a0-a0ad9f192341','office','ELMS Corporate','9876543210','123 Corporate Tower','BKC','Mumbai','Maharashtra','400051','India','Near BKC Junction',1,1,'2026-09-01 10:12:25','2026-09-01 10:12:25'),('a0feedfb-a5ed-11f1-92a0-a0ad9f192341','a0fb5ac0-a5ed-11f1-92a0-a0ad9f192341','office','Tech Solutions Ltd','9876543211','456 Tech Park','Electronic City','Bangalore','Karnataka','560100','India','Opposite Intel',1,1,'2026-09-01 10:12:25','2026-09-01 10:12:25'),('a0feef40-a5ed-11f1-92a0-a0ad9f192341','a0fb5ac0-a5ed-11f1-92a0-a0ad9f192341','warehouse','Tech Solutions Warehouse','9876543212','789 Logistics Park','Peenya','Bangalore','Karnataka','560058','India','Near Peenya Industrial',0,1,'2026-09-01 10:12:25','2026-09-01 10:12:25'),('a0fef00f-a5ed-11f1-92a0-a0ad9f192341','a0fb5c46-a5ed-11f1-92a0-a0ad9f192341','office','Global Logistics Inc','9876543213','321 Trade Center','Vashi','Navi Mumbai','Maharashtra','400703','India','Near Vashi Station',1,1,'2026-09-01 10:12:25','2026-09-01 10:12:25'),('a0fef0c8-a5ed-11f1-92a0-a0ad9f192341','a0fb5d3d-a5ed-11f1-92a0-a0ad9f192341','office','Fast Delivery Services','9876543214','654 Speed Complex','Andheri East','Mumbai','Maharashtra','400093','India','Near Airport',1,1,'2026-09-01 10:12:25','2026-09-01 10:12:25'),('fbcbdf27-d6e4-42f6-aee8-fd52aac987c7','a710bd70-3861-4d24-8663-e47fe4d198cb','','','1231243523','qwe','qwe','qwe','qwe','124513153','Vietnam',NULL,0,1,'2026-09-03 20:32:34','2026-09-04 03:32:33');
/*!40000 ALTER TABLE `customer_addresses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customers` (
  `id` char(36) NOT NULL DEFAULT (uuid()),
  `user_id` char(36) NOT NULL,
  `company_name` varchar(200) DEFAULT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `tax_id` varchar(50) DEFAULT NULL,
  `account_number` varchar(50) DEFAULT NULL,
  `credit_limit` decimal(15,2) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  UNIQUE KEY `account_number` (`account_number`),
  KEY `idx_customers_user_id` (`user_id`),
  KEY `idx_customers_account_number` (`account_number`),
  CONSTRAINT `fk_customers_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customers`
--

LOCK TABLES `customers` WRITE;
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
INSERT INTO `customers` VALUES ('a0fb5651-a5ed-11f1-92a0-a0ad9f192341','a0f34105-a5ed-11f1-92a0-a0ad9f192341','ELMS Corporate','Customer','One','TAX-001','ACC-001',100000.00,1,'2026-09-01 10:12:25','2026-09-01 10:12:25'),('a0fb5ac0-a5ed-11f1-92a0-a0ad9f192341','a0f3428e-a5ed-11f1-92a0-a0ad9f192341','Tech Solutions Ltd','John','Doe','TAX-002','ACC-002',50000.00,1,'2026-09-01 10:12:25','2026-09-01 10:12:25'),('a0fb5c46-a5ed-11f1-92a0-a0ad9f192341','a0f3438d-a5ed-11f1-92a0-a0ad9f192341','Global Logistics Inc','Jane','Smith','TAX-003','ACC-003',75000.00,1,'2026-09-01 10:12:25','2026-09-01 10:12:25'),('a0fb5d3d-a5ed-11f1-92a0-a0ad9f192341','a0f34448-a5ed-11f1-92a0-a0ad9f192341','Fast Delivery Services','Mike','Wilson','TAX-004','ACC-004',25000.00,1,'2026-09-01 10:12:25','2026-09-01 10:12:25'),('a3021835-cca6-496a-a64a-13fbfffebb43','3e761529-e20f-4184-8612-69c4e6cbf749',NULL,'Thăng','Viết',NULL,NULL,NULL,1,'2026-09-03 21:31:46','2026-09-04 04:31:45'),('a710bd70-3861-4d24-8663-e47fe4d198cb','517b40e8-0346-40f2-b96d-085dbe61ff69',NULL,'Thăng','Viết',NULL,NULL,NULL,1,'2026-09-03 20:24:07','2026-09-04 03:24:06');
/*!40000 ALTER TABLE `customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `delivery_assignments`
--

DROP TABLE IF EXISTS `delivery_assignments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `delivery_assignments` (
  `id` char(36) NOT NULL DEFAULT (uuid()),
  `assignment_number` varchar(50) NOT NULL,
  `manifest_id` char(36) NOT NULL,
  `driver_id` char(36) NOT NULL,
  `vehicle_id` char(36) NOT NULL,
  `route_stop_id` char(36) NOT NULL,
  `assigned_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `started_at` timestamp NULL DEFAULT NULL,
  `completed_at` timestamp NULL DEFAULT NULL,
  `status` varchar(50) DEFAULT 'Assigned',
  `sequence_number` int DEFAULT NULL,
  `estimated_delivery_time` timestamp NULL DEFAULT NULL,
  `actual_delivery_time` timestamp NULL DEFAULT NULL,
  `notes` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `assignment_number` (`assignment_number`),
  KEY `fk_delivery_assignments_vehicle` (`vehicle_id`),
  KEY `idx_delivery_assignments_manifest` (`manifest_id`),
  KEY `idx_delivery_assignments_driver` (`driver_id`),
  KEY `idx_delivery_assignments_route_stop` (`route_stop_id`),
  KEY `idx_delivery_assignments_status` (`status`),
  CONSTRAINT `fk_delivery_assignments_driver` FOREIGN KEY (`driver_id`) REFERENCES `employees` (`id`),
  CONSTRAINT `fk_delivery_assignments_manifest` FOREIGN KEY (`manifest_id`) REFERENCES `shipment_manifests` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_delivery_assignments_route_stop` FOREIGN KEY (`route_stop_id`) REFERENCES `route_stops` (`id`),
  CONSTRAINT `fk_delivery_assignments_vehicle` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `delivery_assignments`
--

LOCK TABLES `delivery_assignments` WRITE;
/*!40000 ALTER TABLE `delivery_assignments` DISABLE KEYS */;
INSERT INTO `delivery_assignments` VALUES ('2109e1e5-38b5-49f9-9d5b-037a98164d5b','ASN-20260903-61265EAD','b68681ba-c646-4423-8250-aca7c3812290','a0f79736-a5ed-11f1-92a0-a0ad9f192341','a101feaa-a5ed-11f1-92a0-a0ad9f192341','25377f6c-a77b-11f1-92a0-a0ad9f192341','2026-09-03 03:42:30',NULL,NULL,'Assigned',NULL,'2026-09-03 10:33:00',NULL,'bis','2026-09-03 03:42:30','2026-09-03 11:05:02'),('ea50fae5-befa-43c8-b08d-d3e597076ffc','ASN-20260903-5D55E1CB','b68681ba-c646-4423-8250-aca7c3812290','a0f7913f-a5ed-11f1-92a0-a0ad9f192341','a101feaa-a5ed-11f1-92a0-a0ad9f192341','25377f6c-a77b-11f1-92a0-a0ad9f192341','2026-09-03 02:39:26',NULL,NULL,'Assigned',1,'2026-09-03 09:14:00',NULL,'qwe','2026-09-03 02:39:26','2026-09-03 09:39:25');
/*!40000 ALTER TABLE `delivery_assignments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `delivery_attempts`
--

DROP TABLE IF EXISTS `delivery_attempts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `delivery_attempts` (
  `id` char(36) NOT NULL DEFAULT (uuid()),
  `shipment_id` char(36) NOT NULL,
  `delivery_assignment_id` char(36) NOT NULL,
  `attempt_number` int NOT NULL,
  `attempt_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `status` enum('attempted','delivered','failed') NOT NULL,
  `reason` varchar(255) DEFAULT NULL,
  `notes` text,
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  `is_delivered` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_delivery_attempts_shipment` (`shipment_id`),
  KEY `idx_delivery_attempts_assignment` (`delivery_assignment_id`),
  CONSTRAINT `fk_delivery_attempts_assignment` FOREIGN KEY (`delivery_assignment_id`) REFERENCES `delivery_assignments` (`id`),
  CONSTRAINT `fk_delivery_attempts_shipment` FOREIGN KEY (`shipment_id`) REFERENCES `shipments` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `delivery_attempts`
--

LOCK TABLES `delivery_attempts` WRITE;
/*!40000 ALTER TABLE `delivery_attempts` DISABLE KEYS */;
/*!40000 ALTER TABLE `delivery_attempts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `departments`
--

DROP TABLE IF EXISTS `departments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `departments` (
  `id` char(36) NOT NULL DEFAULT (uuid()),
  `name` varchar(100) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `departments`
--

LOCK TABLES `departments` WRITE;
/*!40000 ALTER TABLE `departments` DISABLE KEYS */;
INSERT INTO `departments` VALUES ('a0f3dcc2-a5ed-11f1-92a0-a0ad9f192341','Warehouse Operations','Manages all warehouse activities',1,'2026-09-01 10:12:25'),('a0f3dfa3-a5ed-11f1-92a0-a0ad9f192341','Transportation','Manages fleet and delivery operations',1,'2026-09-01 10:12:25'),('a0f3e057-a5ed-11f1-92a0-a0ad9f192341','Customer Service','Handles customer inquiries and support',1,'2026-09-01 10:12:25'),('a0f3e0b0-a5ed-11f1-92a0-a0ad9f192341','Finance','Manages billing, payments, and accounting',1,'2026-09-01 10:12:25'),('a0f3e0fc-a5ed-11f1-92a0-a0ad9f192341','Human Resources','Manages employee relations and hiring',1,'2026-09-01 10:12:25'),('a0f3e145-a5ed-11f1-92a0-a0ad9f192341','IT Department','Manages technology infrastructure',1,'2026-09-01 10:12:25');
/*!40000 ALTER TABLE `departments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employee_profile_requests`
--

DROP TABLE IF EXISTS `employee_profile_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee_profile_requests` (
  `id` char(36) NOT NULL DEFAULT (uuid()),
  `employee_id` char(36) NOT NULL,
  `requested_by` char(36) NOT NULL,
  `field_name` varchar(100) NOT NULL,
  `old_value` text,
  `new_value` text NOT NULL,
  `reason` text,
  `status` varchar(50) DEFAULT 'Pending',
  `approved_by` char(36) DEFAULT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `rejection_reason` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_employee_profile_requests_requested_by` (`requested_by`),
  KEY `fk_employee_profile_requests_approved_by` (`approved_by`),
  KEY `idx_employee_profile_requests_employee` (`employee_id`),
  KEY `idx_employee_profile_requests_status` (`status`),
  CONSTRAINT `fk_employee_profile_requests_approved_by` FOREIGN KEY (`approved_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_employee_profile_requests_employee` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_employee_profile_requests_requested_by` FOREIGN KEY (`requested_by`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee_profile_requests`
--

LOCK TABLES `employee_profile_requests` WRITE;
/*!40000 ALTER TABLE `employee_profile_requests` DISABLE KEYS */;
INSERT INTO `employee_profile_requests` VALUES ('a10e8b42-a5ed-11f1-92a0-a0ad9f192341','a0f79c04-a5ed-11f1-92a0-a0ad9f192341','a0f33fb5-a5ed-11f1-92a0-a0ad9f192341','phone',NULL,'9876543219','New phone number','Pending',NULL,NULL,NULL,'2026-09-01 10:12:25','2026-09-01 10:12:25'),('a10e8fef-a5ed-11f1-92a0-a0ad9f192341','a0f79e99-a5ed-11f1-92a0-a0ad9f192341','a0f33fb5-a5ed-11f1-92a0-a0ad9f192341','position','Driver','Senior Driver','Promotion request','Approved','a0f338e8-a5ed-11f1-92a0-a0ad9f192341','2026-09-01 10:12:25',NULL,'2026-09-01 10:12:25','2026-09-01 10:12:25'),('a10e91e7-a5ed-11f1-92a0-a0ad9f192341','a0f7a0c2-a5ed-11f1-92a0-a0ad9f192341','a0f33fb5-a5ed-11f1-92a0-a0ad9f192341','department','Warehouse Operations','Customer Service','Department transfer','Rejected','a0f338e8-a5ed-11f1-92a0-a0ad9f192341','2026-09-01 10:12:25','Position not available','2026-09-01 10:12:25','2026-09-01 10:12:25'),('a10e9387-a5ed-11f1-92a0-a0ad9f192341','a0f7a321-a5ed-11f1-92a0-a0ad9f192341','a0f338e8-a5ed-11f1-92a0-a0ad9f192341','salary','50000','60000','Annual increment','Pending',NULL,NULL,NULL,'2026-09-01 10:12:25','2026-09-01 10:12:25');
/*!40000 ALTER TABLE `employee_profile_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employees`
--

DROP TABLE IF EXISTS `employees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employees` (
  `id` char(36) NOT NULL DEFAULT (uuid()),
  `user_id` char(36) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `department_id` char(36) DEFAULT NULL,
  `position_id` char(36) DEFAULT NULL,
  `branch_id` char(36) DEFAULT NULL,
  `hire_date` date DEFAULT NULL,
  `employee_code` varchar(50) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  UNIQUE KEY `employee_code` (`employee_code`),
  KEY `fk_employees_department` (`department_id`),
  KEY `fk_employees_position` (`position_id`),
  KEY `idx_employees_branch` (`branch_id`),
  KEY `idx_employees_user_id` (`user_id`),
  CONSTRAINT `fk_employees_branch` FOREIGN KEY (`branch_id`) REFERENCES `facilities` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_employees_department` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_employees_position` FOREIGN KEY (`position_id`) REFERENCES `positions` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_employees_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employees`
--

LOCK TABLES `employees` WRITE;
/*!40000 ALTER TABLE `employees` DISABLE KEYS */;
INSERT INTO `employees` VALUES ('a0f7913f-a5ed-11f1-92a0-a0ad9f192341','a0f338e8-a5ed-11f1-92a0-a0ad9f192341','System','Admin','a0f3e145-a5ed-11f1-92a0-a0ad9f192341','a0f47eab-a5ed-11f1-92a0-a0ad9f192341',NULL,'2024-01-01','EMP-001',1,'2026-09-01 10:12:25','2026-09-01 10:12:25'),('a0f79736-a5ed-11f1-92a0-a0ad9f192341','a0f33fb5-a5ed-11f1-92a0-a0ad9f192341','John','Doe','a0f3dcc2-a5ed-11f1-92a0-a0ad9f192341','a0f479ed-a5ed-11f1-92a0-a0ad9f192341','a0f6af92-a5ed-11f1-92a0-a0ad9f192341','2024-01-15','EMP-002',1,'2026-09-01 10:12:25','2026-09-01 10:12:25'),('a0f799fc-a5ed-11f1-92a0-a0ad9f192341','a0f3428e-a5ed-11f1-92a0-a0ad9f192341','John','Doe','a0f3dcc2-a5ed-11f1-92a0-a0ad9f192341','a0f479ed-a5ed-11f1-92a0-a0ad9f192341','a0f6af92-a5ed-11f1-92a0-a0ad9f192341','2024-01-15','EMP-003',1,'2026-09-01 10:12:25','2026-09-01 10:12:25'),('a0f79c04-a5ed-11f1-92a0-a0ad9f192341','a0f3438d-a5ed-11f1-92a0-a0ad9f192341','Jane','Smith','a0f3e057-a5ed-11f1-92a0-a0ad9f192341','a0f47da7-a5ed-11f1-92a0-a0ad9f192341','a0f6af92-a5ed-11f1-92a0-a0ad9f192341','2024-02-01','EMP-004',1,'2026-09-01 10:12:25','2026-09-01 10:12:25'),('a0f79e99-a5ed-11f1-92a0-a0ad9f192341','a0f34448-a5ed-11f1-92a0-a0ad9f192341','Mike','Wilson','a0f3dfa3-a5ed-11f1-92a0-a0ad9f192341','a0f47ef5-a5ed-11f1-92a0-a0ad9f192341','a0f6b317-a5ed-11f1-92a0-a0ad9f192341','2024-02-15','EMP-005',1,'2026-09-01 10:12:25','2026-09-01 10:12:25'),('a0f7a0c2-a5ed-11f1-92a0-a0ad9f192341','a0f345e8-a5ed-11f1-92a0-a0ad9f192341','Sarah','Parker','a0f3dcc2-a5ed-11f1-92a0-a0ad9f192341','a0f47f3d-a5ed-11f1-92a0-a0ad9f192341','a0f6b317-a5ed-11f1-92a0-a0ad9f192341','2024-03-01','EMP-006',1,'2026-09-01 10:12:25','2026-09-01 10:12:25'),('a0f7a321-a5ed-11f1-92a0-a0ad9f192341','a0f346ce-a5ed-11f1-92a0-a0ad9f192341','Robert','Taylor','a0f3dcc2-a5ed-11f1-92a0-a0ad9f192341','a0f47f88-a5ed-11f1-92a0-a0ad9f192341','a0f6b3d5-a5ed-11f1-92a0-a0ad9f192341','2024-01-15','EMP-007',1,'2026-09-01 10:12:25','2026-09-01 10:12:25');
/*!40000 ALTER TABLE `employees` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `expenses`
--

DROP TABLE IF EXISTS `expenses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `expenses` (
  `id` char(36) NOT NULL DEFAULT (uuid()),
  `expense_number` varchar(50) NOT NULL,
  `expense_type` varchar(50) NOT NULL,
  `facility_id` char(36) DEFAULT NULL,
  `vehicle_id` char(36) DEFAULT NULL,
  `employee_id` char(36) DEFAULT NULL,
  `amount` decimal(15,2) NOT NULL,
  `expense_date` date NOT NULL,
  `description` text,
  `invoice_number` varchar(100) DEFAULT NULL,
  `approved_by` char(36) DEFAULT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `status` enum('pending','approved','rejected','paid') DEFAULT 'pending',
  `payment_status` varchar(50) DEFAULT 'Unpaid',
  `payment_date` date DEFAULT NULL,
  `notes` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `expense_number` (`expense_number`),
  KEY `fk_expenses_approved_by` (`approved_by`),
  KEY `idx_expenses_facility` (`facility_id`),
  KEY `idx_expenses_vehicle` (`vehicle_id`),
  KEY `idx_expenses_employee` (`employee_id`),
  KEY `idx_expenses_status` (`status`),
  KEY `idx_expenses_expense_date` (`expense_date`),
  CONSTRAINT `fk_expenses_approved_by` FOREIGN KEY (`approved_by`) REFERENCES `employees` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_expenses_employee` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_expenses_facility` FOREIGN KEY (`facility_id`) REFERENCES `facilities` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_expenses_vehicle` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `expenses`
--

LOCK TABLES `expenses` WRITE;
/*!40000 ALTER TABLE `expenses` DISABLE KEYS */;
INSERT INTO `expenses` VALUES ('a10a78f4-a5ed-11f1-92a0-a0ad9f192341','EXP-001-2024','Fuel','a0f6af92-a5ed-11f1-92a0-a0ad9f192341','a101f8d7-a5ed-11f1-92a0-a0ad9f192341',NULL,2500.00,'2026-09-01','Monthly fuel expense','FUEL-001',NULL,NULL,'pending','Unpaid',NULL,'Regular fuel charge','2026-09-01 10:12:25','2026-09-01 10:12:25'),('a10a7e00-a5ed-11f1-92a0-a0ad9f192341','EXP-002-2024','Maintenance','a0f6b317-a5ed-11f1-92a0-a0ad9f192341','a101fc21-a5ed-11f1-92a0-a0ad9f192341',NULL,15000.00,'2026-09-01','Vehicle maintenance - oil change and service','MAINT-001',NULL,NULL,'pending','Unpaid',NULL,'Scheduled maintenance','2026-09-01 10:12:25','2026-09-01 10:12:25'),('a10a7fe8-a5ed-11f1-92a0-a0ad9f192341','EXP-003-2024','Rent','a0f6b3d5-a5ed-11f1-92a0-a0ad9f192341',NULL,NULL,50000.00,'2026-09-01','Monthly branch rent','RENT-001','a0f799fc-a5ed-11f1-92a0-a0ad9f192341','2026-09-01 10:12:25','approved','Unpaid',NULL,'Branch rent payment','2026-09-01 10:12:25','2026-09-01 10:12:25');
/*!40000 ALTER TABLE `expenses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `facilities`
--

DROP TABLE IF EXISTS `facilities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `facilities` (
  `id` char(36) NOT NULL DEFAULT (uuid()),
  `code` varchar(50) NOT NULL,
  `name` varchar(200) NOT NULL,
  `facility_type` enum('Branch','DistributionCenter') NOT NULL,
  `address_line1` varchar(255) NOT NULL,
  `address_line2` varchar(255) DEFAULT NULL,
  `city` varchar(100) NOT NULL,
  `state` varchar(100) DEFAULT NULL,
  `pincode` varchar(20) NOT NULL,
  `country` varchar(100) DEFAULT 'India',
  `phone` varchar(20) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `branch_manager_id` char(36) DEFAULT NULL,
  `capacity` decimal(15,2) DEFAULT NULL,
  `current_occupancy` decimal(15,2) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `fk_facilities_branch_manager` (`branch_manager_id`),
  CONSTRAINT `fk_facilities_branch_manager` FOREIGN KEY (`branch_manager_id`) REFERENCES `employees` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `facilities`
--

LOCK TABLES `facilities` WRITE;
/*!40000 ALTER TABLE `facilities` DISABLE KEYS */;
INSERT INTO `facilities` VALUES ('29742da6-a5f7-11f1-92a0-a0ad9f192341','HN-HUB','Hanoi Distribution Hub','DistributionCenter','123 Cau Giay',NULL,'Hanoi','Hanoi','100000','Vietnam','0241111111','hanoi.hub@example.com',NULL,10000.00,1200.00,1,'2026-09-01 04:20:39','2026-09-01 04:20:39'),('297466af-a5f7-11f1-92a0-a0ad9f192341','BN-DC','Bac Ninh Distribution Center','DistributionCenter','456 Tu Son',NULL,'Bac Ninh','Bac Ninh','160000','Vietnam','0242222222','bacninh.dc@example.com',NULL,7000.00,800.00,1,'2026-09-01 04:20:39','2026-09-01 04:20:39'),('29746bcc-a5f7-11f1-92a0-a0ad9f192341','HD-DC','Hai Duong Distribution Center','DistributionCenter','789 Hai Duong',NULL,'Hai Duong','Hai Duong','170000','Vietnam','0223333333','haiduong.dc@example.com',NULL,6000.00,500.00,1,'2026-09-01 04:20:39','2026-09-01 04:20:39'),('29746d66-a5f7-11f1-92a0-a0ad9f192341','HP-BR','Hai Phong Branch','Branch','321 Le Chan',NULL,'Hai Phong','Hai Phong','180000','Vietnam','0224444444','haiphong.branch@example.com',NULL,5000.00,300.00,1,'2026-09-01 04:20:39','2026-09-01 04:20:39'),('a0f6af92-a5ed-11f1-92a0-a0ad9f192341','BOM-001','Mumbai Branch','Branch','123 Marine Drive','Opposite Gateway','Mumbai','Maharashtra','400001','India','022-1234567','mumbai@elms.com','a0f799fc-a5ed-11f1-92a0-a0ad9f192341',5000.00,2500.00,1,'2026-09-01 10:12:25','2026-09-01 10:12:25'),('a0f6b317-a5ed-11f1-92a0-a0ad9f192341','BOM-DC','Mumbai Distribution Center','DistributionCenter','456 Warehouse Road','Near Andheri','Mumbai','Maharashtra','400053','India','022-7654321','mumbai.dc@elms.com','a0f799fc-a5ed-11f1-92a0-a0ad9f192341',10000.00,6500.00,1,'2026-09-01 10:12:25','2026-09-01 10:12:25'),('a0f6b3d5-a5ed-11f1-92a0-a0ad9f192341','DEL-001','Delhi Branch','Branch','789 Connaught Place','Near Metro Station','Delhi','Delhi','110001','India','011-1234567','delhi@elms.com','a0f7a321-a5ed-11f1-92a0-a0ad9f192341',4500.00,2000.00,1,'2026-09-01 10:12:25','2026-09-01 10:12:25'),('a0f6b456-a5ed-11f1-92a0-a0ad9f192341','CHE-001','Chennai Branch','Branch','456 Anna Salai','Near Egmore','Chennai','Tamil Nadu','600001','India','044-1234567','chennai@elms.com','a0f7a321-a5ed-11f1-92a0-a0ad9f192341',4000.00,1500.00,1,'2026-09-01 10:12:25','2026-09-01 10:12:25'),('a0f6b4d0-a5ed-11f1-92a0-a0ad9f192341','HYD-001','Hyderabad Branch','Branch','789 Banjara Hills','Road No 1','Hyderabad','Telangana','500034','India','040-1234567','hyderabad@elms.com','a0f7a321-a5ed-11f1-92a0-a0ad9f192341',3500.00,1200.00,1,'2026-09-01 10:12:25','2026-09-01 10:12:25'),('a0f6b541-a5ed-11f1-92a0-a0ad9f192341','KOL-001','Kolkata Branch','Branch','321 Park Street','Near Park Hotel','Kolkata','West Bengal','700016','India','033-1234567','kolkata@elms.com','a0f7a321-a5ed-11f1-92a0-a0ad9f192341',3800.00,1400.00,1,'2026-09-01 10:12:25','2026-09-01 10:12:25');
/*!40000 ALTER TABLE `facilities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `insurance_plans`
--

DROP TABLE IF EXISTS `insurance_plans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `insurance_plans` (
  `id` char(36) NOT NULL DEFAULT (uuid()),
  `name` varchar(100) NOT NULL,
  `description` text,
  `min_cover` decimal(15,2) NOT NULL,
  `max_cover` decimal(15,2) NOT NULL,
  `rate_percentage` decimal(5,2) NOT NULL,
  `fixed_charge` decimal(15,2) DEFAULT '0.00',
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `insurance_plans`
--

LOCK TABLES `insurance_plans` WRITE;
/*!40000 ALTER TABLE `insurance_plans` DISABLE KEYS */;
INSERT INTO `insurance_plans` VALUES ('a1014855-a5ed-11f1-92a0-a0ad9f192341','Basic Cover','Basic insurance coverage up to 10,000',1000.00,10000.00,2.50,50.00,1,'2026-09-01 10:12:25','2026-09-01 10:12:25'),('a1014b28-a5ed-11f1-92a0-a0ad9f192341','Standard Cover','Standard insurance coverage up to 50,000',10000.00,50000.00,2.00,100.00,1,'2026-09-01 10:12:25','2026-09-01 10:12:25'),('a1014bbc-a5ed-11f1-92a0-a0ad9f192341','Premium Cover','Premium insurance coverage up to 200,000',50000.00,200000.00,1.50,200.00,1,'2026-09-01 10:12:25','2026-09-01 10:12:25'),('a1014c04-a5ed-11f1-92a0-a0ad9f192341','Comprehensive Cover','Comprehensive coverage up to 500,000',200000.00,500000.00,1.00,500.00,1,'2026-09-01 10:12:25','2026-09-01 10:12:25');
/*!40000 ALTER TABLE `insurance_plans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invoices`
--

DROP TABLE IF EXISTS `invoices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `invoices` (
  `id` char(36) NOT NULL DEFAULT (uuid()),
  `invoice_number` varchar(50) NOT NULL,
  `shipment_id` char(36) NOT NULL,
  `invoice_date` date NOT NULL,
  `due_date` date DEFAULT NULL,
  `total_amount` decimal(15,2) NOT NULL,
  `discount_amount` decimal(15,2) DEFAULT '0.00',
  `net_amount` decimal(15,2) NOT NULL,
  `status` enum('draft','issued','paid','partially_paid','overdue','cancelled') DEFAULT 'draft',
  `notes` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `invoice_number` (`invoice_number`),
  KEY `idx_invoices_shipment` (`shipment_id`),
  KEY `idx_invoices_status` (`status`),
  KEY `idx_invoices_invoice_date` (`invoice_date`),
  CONSTRAINT `fk_invoices_shipment` FOREIGN KEY (`shipment_id`) REFERENCES `shipments` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invoices`
--

LOCK TABLES `invoices` WRITE;
/*!40000 ALTER TABLE `invoices` DISABLE KEYS */;
INSERT INTO `invoices` VALUES ('a106ff72-a5ed-11f1-92a0-a0ad9f192341','INV-202609-001','a102f87e-a5ed-11f1-92a0-a0ad9f192341','2026-09-01','2026-09-16',750.00,0.00,750.00,'issued','Standard invoice','2026-09-01 10:12:25','2026-09-01 10:12:25'),('a1078abd-a5ed-11f1-92a0-a0ad9f192341','INV-202609-002','a10313b0-a5ed-11f1-92a0-a0ad9f192341','2026-09-01','2026-09-16',1200.00,100.00,1100.00,'paid','Paid invoice','2026-09-01 10:12:25','2026-09-01 10:12:25'),('a10805f6-a5ed-11f1-92a0-a0ad9f192341','INV-202609-003','a1031bb7-a5ed-11f1-92a0-a0ad9f192341','2026-09-01','2026-09-16',2500.00,200.00,2300.00,'overdue','Overdue invoice','2026-09-01 10:12:25','2026-09-01 10:12:25');
/*!40000 ALTER TABLE `invoices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `login_history`
--

DROP TABLE IF EXISTS `login_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `login_history` (
  `id` char(36) NOT NULL DEFAULT (uuid()),
  `user_id` char(36) NOT NULL,
  `login_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `logout_time` timestamp NULL DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text,
  `login_status` varchar(50) NOT NULL,
  `failure_reason` text,
  `session_id` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_login_history_user` (`user_id`),
  KEY `idx_login_history_login_time` (`login_time`),
  CONSTRAINT `fk_login_history_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login_history`
--

LOCK TABLES `login_history` WRITE;
/*!40000 ALTER TABLE `login_history` DISABLE KEYS */;
INSERT INTO `login_history` VALUES ('a10de292-a5ed-11f1-92a0-a0ad9f192341','a0f338e8-a5ed-11f1-92a0-a0ad9f192341','2026-08-31 10:12:25','2026-08-31 18:12:25','192.168.1.1','Mozilla/5.0','success',NULL,'SESS-001','2026-09-01 10:12:25'),('a10de7b9-a5ed-11f1-92a0-a0ad9f192341','a0f33fb5-a5ed-11f1-92a0-a0ad9f192341','2026-08-31 10:12:25','2026-08-31 16:12:25','192.168.1.2','Mozilla/5.0','success',NULL,'SESS-002','2026-09-01 10:12:25'),('a10de94a-a5ed-11f1-92a0-a0ad9f192341','a0f34105-a5ed-11f1-92a0-a0ad9f192341','2026-08-31 10:12:25','2026-08-31 17:12:25','192.168.1.3','Mozilla/5.0','success',NULL,'SESS-003','2026-09-01 10:12:25'),('a10dea26-a5ed-11f1-92a0-a0ad9f192341','a0f338e8-a5ed-11f1-92a0-a0ad9f192341','2026-09-01 08:12:25',NULL,'192.168.1.4','Mozilla/5.0','success',NULL,'SESS-004','2026-09-01 10:12:25');
/*!40000 ALTER TABLE `login_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `manifest_items`
--

DROP TABLE IF EXISTS `manifest_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `manifest_items` (
  `id` char(36) NOT NULL DEFAULT (uuid()),
  `manifest_id` char(36) NOT NULL,
  `transport_order_id` char(36) NOT NULL,
  `loading_sequence` int DEFAULT NULL,
  `status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'planned',
  `loaded_at` timestamp NULL DEFAULT NULL,
  `unloaded_at` timestamp NULL DEFAULT NULL,
  `unloaded_facility_id` char(36) DEFAULT NULL,
  `notes` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `weight` decimal(15,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_manifest_transport_order` (`manifest_id`,`transport_order_id`),
  KEY `fk_manifest_items_unloaded_facility` (`unloaded_facility_id`),
  KEY `idx_manifest_items_manifest` (`manifest_id`),
  KEY `idx_manifest_items_transport_order` (`transport_order_id`),
  KEY `idx_manifest_items_status` (`status`),
  CONSTRAINT `fk_manifest_items_manifest` FOREIGN KEY (`manifest_id`) REFERENCES `shipment_manifests` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_manifest_items_transport_order` FOREIGN KEY (`transport_order_id`) REFERENCES `transport_orders` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_manifest_items_unloaded_facility` FOREIGN KEY (`unloaded_facility_id`) REFERENCES `facilities` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `manifest_items`
--

LOCK TABLES `manifest_items` WRITE;
/*!40000 ALTER TABLE `manifest_items` DISABLE KEYS */;
INSERT INTO `manifest_items` VALUES ('0255e016-6833-4b51-8396-93f6106e1135','6861bd2b-e4e6-4e88-8427-000a61c4c1c4','dcb757ae-32e7-454b-accf-e118d49c40c7',1,'unloaded','2026-09-04 14:21:04','2026-09-04 14:37:17','297466af-a5f7-11f1-92a0-a0ad9f192341',NULL,'2026-09-04 13:17:18','2026-09-04 21:37:16',5.00),('08df09a1-f457-4316-8867-f5ca63a736ad','b68681ba-c646-4423-8250-aca7c3812290','07ba93cd-c10e-435e-bc6e-42d1dcf88c49',5,'unloaded','2026-09-04 10:53:13','2026-09-04 11:01:31','297466af-a5f7-11f1-92a0-a0ad9f192341',NULL,'2026-09-03 09:58:50','2026-09-04 18:01:30',2.50),('08df0a4b-c5f5-4b28-8c3f-41d2328584df','9cba39c9-9410-40d2-a46e-9fd87f73f3fd','07ba93cd-c10e-435e-bc6e-42d1dcf88c49',1,'Loaded',NULL,NULL,NULL,NULL,'2026-09-04 06:14:27','2026-09-04 06:14:27',0.00),('08df0a55-ccf9-4768-8e09-c3922c18deb1','9cba39c9-9410-40d2-a46e-9fd87f73f3fd','ab6b6827-2d40-4097-9c7f-b71e354dfdb8',1,'Loaded',NULL,NULL,NULL,'Shipment assigned to trip','2026-09-04 07:26:13','2026-09-04 07:26:13',0.00),('08df0a80-25c9-4777-8b3c-c5a3606b08eb','9cba39c9-9410-40d2-a46e-9fd87f73f3fd','5e2f0e1f-f045-4674-9d57-2f267a1ca12a',3,'Loaded',NULL,NULL,NULL,'Shipment assigned to trip','2026-09-04 12:29:21','2026-09-04 12:29:21',0.00),('08df0a80-39c5-4aa2-8585-85f73502469b','9cba39c9-9410-40d2-a46e-9fd87f73f3fd','50a2aab5-f12f-4829-ad1b-a76250f0f835',1,'Loaded',NULL,NULL,NULL,'Shipment assigned to trip','2026-09-04 12:29:55','2026-09-04 12:29:55',0.00),('08df0a80-41f7-4f06-8f88-61cb63454e39','9cba39c9-9410-40d2-a46e-9fd87f73f3fd','6d83f047-6166-4a53-9b02-e25288cf7ca7',1,'Loaded',NULL,NULL,NULL,'Shipment assigned to trip','2026-09-04 12:30:08','2026-09-04 12:30:08',0.00),('08df0a80-5a7f-4fc0-8b42-034731068b36','b68681ba-c646-4423-8250-aca7c3812290','1c753a3f-4616-43cd-975d-0aebd00449fd',1,'Loaded',NULL,NULL,NULL,'Shipment assigned to trip','2026-09-04 12:30:50','2026-09-04 12:30:50',0.00),('08df0a9c-ae0a-49e8-8527-181e4f2fbee0','9cba39c9-9410-40d2-a46e-9fd87f73f3fd','1c753a3f-4616-43cd-975d-0aebd00449fd',3,'planned',NULL,NULL,NULL,NULL,'2026-09-04 15:53:36','2026-09-04 15:53:36',3.00),('08df0a9d-ba04-48c0-8f5c-f96564c63fcf','9cba39c9-9410-40d2-a46e-9fd87f73f3fd','79ee802b-6f85-4f4d-a3b2-6f15e1e0cff6',1,'planned',NULL,NULL,NULL,NULL,'2026-09-04 16:01:05','2026-09-04 16:01:05',11.00),('930fe643-f20d-4c5b-8090-4c7cc97e2245','9cba39c9-9410-40d2-a46e-9fd87f73f3fd','2d024916-482e-46a9-96f2-78b4f9f93cf0',1,'planned',NULL,NULL,NULL,NULL,'2026-09-04 09:34:15','2026-09-04 16:34:15',20.00);
/*!40000 ALTER TABLE `manifest_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notifications` (
  `id` char(36) NOT NULL DEFAULT (uuid()),
  `tracking_event_id` char(36) NOT NULL,
  `customer_id` char(36) NOT NULL,
  `notification_type` varchar(50) NOT NULL,
  `subject` varchar(255) DEFAULT NULL,
  `content` text NOT NULL,
  `recipient` varchar(255) NOT NULL,
  `status` enum('pending','sent','failed','read') DEFAULT 'pending',
  `sent_at` timestamp NULL DEFAULT NULL,
  `read_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_notifications_tracking_event` (`tracking_event_id`),
  KEY `idx_notifications_customer` (`customer_id`),
  KEY `idx_notifications_status` (`status`),
  CONSTRAINT `fk_notifications_customer` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_notifications_tracking_event` FOREIGN KEY (`tracking_event_id`) REFERENCES `tracking_events` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `package_scans`
--

DROP TABLE IF EXISTS `package_scans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `package_scans` (
  `id` char(36) NOT NULL DEFAULT (uuid()),
  `scan_number` varchar(50) NOT NULL,
  `shipment_id` char(36) NOT NULL,
  `employee_id` char(36) NOT NULL,
  `facility_id` char(36) DEFAULT NULL,
  `vehicle_id` char(36) DEFAULT NULL,
  `location_type` enum('branch','distribution_center','vehicle') NOT NULL,
  `scan_type` varchar(50) NOT NULL,
  `scan_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `notes` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `manifest_item_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `scan_number` (`scan_number`),
  KEY `fk_package_scans_vehicle` (`vehicle_id`),
  KEY `idx_package_scans_shipment` (`shipment_id`),
  KEY `idx_package_scans_employee` (`employee_id`),
  KEY `idx_package_scans_facility` (`facility_id`),
  KEY `idx_package_scans_scan_time` (`scan_time`),
  KEY `IX_package_scans_manifest_item_id` (`manifest_item_id`),
  CONSTRAINT `fk_package_scans_employee` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`),
  CONSTRAINT `fk_package_scans_facility` FOREIGN KEY (`facility_id`) REFERENCES `facilities` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_package_scans_manifest_item` FOREIGN KEY (`manifest_item_id`) REFERENCES `manifest_items` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_package_scans_shipment` FOREIGN KEY (`shipment_id`) REFERENCES `shipments` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_package_scans_vehicle` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `package_scans`
--

LOCK TABLES `package_scans` WRITE;
/*!40000 ALTER TABLE `package_scans` DISABLE KEYS */;
INSERT INTO `package_scans` VALUES ('056b5faf-4b8f-48ef-80dd-7f5882d30e9c','SCN-20260904055831-BA86','83500430-9554-4cd2-b3aa-dbf7a7cafc21','a0f79736-a5ed-11f1-92a0-a0ad9f192341','29742da6-a5f7-11f1-92a0-a0ad9f192341',NULL,'distribution_center','pickup','2026-09-03 22:58:32',NULL,NULL,NULL,'Step 2 pickup test','2026-09-03 22:58:32',NULL),('066f058d-8202-40b8-8465-7137df003eed','SCN-20260904212743-0B70','5bda8f75-181b-4f6b-b477-74d909612b36','a0f79736-a5ed-11f1-92a0-a0ad9f192341','29742da6-a5f7-11f1-92a0-a0ad9f192341','a101f8d7-a5ed-11f1-92a0-a0ad9f192341','vehicle','depart','2026-09-04 14:27:44',NULL,NULL,NULL,NULL,'2026-09-04 14:27:44','0255e016-6833-4b51-8396-93f6106e1135'),('0f4f0384-9edc-4b8e-ae90-c0a5cdd21d86','SCN-20260904175824-61BE','83500430-9554-4cd2-b3aa-dbf7a7cafc21','a0f7913f-a5ed-11f1-92a0-a0ad9f192341','29742da6-a5f7-11f1-92a0-a0ad9f192341','a101feaa-a5ed-11f1-92a0-a0ad9f192341','vehicle','depart','2026-09-04 10:58:24',NULL,NULL,NULL,'Step 4 depart test','2026-09-04 10:58:24','08df09a1-f457-4316-8867-f5ca63a736ad'),('18b9aed3-016e-447f-9b8b-80d821a50a19','SCN-20260904180038-5F15','83500430-9554-4cd2-b3aa-dbf7a7cafc21','a0f7913f-a5ed-11f1-92a0-a0ad9f192341','297466af-a5f7-11f1-92a0-a0ad9f192341','a101feaa-a5ed-11f1-92a0-a0ad9f192341','distribution_center','arrive','2026-09-04 11:00:38',NULL,NULL,NULL,'Step 5 arrive test','2026-09-04 11:00:38','08df09a1-f457-4316-8867-f5ca63a736ad'),('2c268e05-ce60-49b5-8f7a-00341156056d','SCN-20260904180734-E50F','66ccf164-50e2-4581-afc2-2642ef7eb001','a0f7913f-a5ed-11f1-92a0-a0ad9f192341','29742da6-a5f7-11f1-92a0-a0ad9f192341',NULL,'branch','pickup','2026-09-04 11:07:34',NULL,NULL,NULL,NULL,'2026-09-04 11:07:34',NULL),('30d4b98d-3486-4d76-81ef-5e1f5ffb9231','SCN-20260904212813-F809','5bda8f75-181b-4f6b-b477-74d909612b36','a0f79736-a5ed-11f1-92a0-a0ad9f192341','297466af-a5f7-11f1-92a0-a0ad9f192341','a101f8d7-a5ed-11f1-92a0-a0ad9f192341','distribution_center','arrive','2026-09-04 14:28:13',NULL,NULL,NULL,NULL,'2026-09-04 14:28:13','0255e016-6833-4b51-8396-93f6106e1135'),('31f8820d-ee3d-45e7-a39e-31bfe4dae536','SCN-20260904181521-3933','a102f87e-a5ed-11f1-92a0-a0ad9f192341','a0f79736-a5ed-11f1-92a0-a0ad9f192341','29742da6-a5f7-11f1-92a0-a0ad9f192341',NULL,'branch','pickup','2026-09-04 11:15:22',NULL,NULL,NULL,NULL,'2026-09-04 11:15:22',NULL),('32a653be-ea7c-409d-98d7-3e6b6e490810','SCN-20260904180130-E2DC','83500430-9554-4cd2-b3aa-dbf7a7cafc21','a0f7913f-a5ed-11f1-92a0-a0ad9f192341','297466af-a5f7-11f1-92a0-a0ad9f192341','a101feaa-a5ed-11f1-92a0-a0ad9f192341','distribution_center','unload','2026-09-04 11:01:31',NULL,NULL,NULL,'Step 6 unload test','2026-09-04 11:01:31','08df09a1-f457-4316-8867-f5ca63a736ad'),('51a44e14-90a7-4f53-96fa-89fa34468271','SCN-20260904060415-4EF0','66ccf164-50e2-4581-afc2-2642ef7eb001','a0f79736-a5ed-11f1-92a0-a0ad9f192341','29742da6-a5f7-11f1-92a0-a0ad9f192341',NULL,'branch','pickup','2026-09-03 23:04:15',NULL,NULL,NULL,NULL,'2026-09-03 23:04:15',NULL),('6de4faec-8814-42be-8df4-811f7daa5c6b','SCN-20260904213728-8723','5bda8f75-181b-4f6b-b477-74d909612b36','a0f79736-a5ed-11f1-92a0-a0ad9f192341','297466af-a5f7-11f1-92a0-a0ad9f192341',NULL,'branch','out_for_delivery','2026-09-04 14:37:28',NULL,NULL,NULL,NULL,'2026-09-04 14:37:28',NULL),('844a0903-eed7-4eea-a9d7-999ffad042ff','SCN-20260904175312-5037','83500430-9554-4cd2-b3aa-dbf7a7cafc21','a0f79736-a5ed-11f1-92a0-a0ad9f192341','29742da6-a5f7-11f1-92a0-a0ad9f192341','a101feaa-a5ed-11f1-92a0-a0ad9f192341','distribution_center','load','2026-09-04 10:53:13',NULL,NULL,NULL,'Step 3 load test','2026-09-04 10:53:13','08df09a1-f457-4316-8867-f5ca63a736ad'),('84eaf42a-2256-4ae9-93da-cc6fbc04d6d6','SCN-20260904060606-3154','2b01a589-3226-402a-8e32-136b6d560f5a','a0f79736-a5ed-11f1-92a0-a0ad9f192341','29742da6-a5f7-11f1-92a0-a0ad9f192341',NULL,'branch','pickup','2026-09-03 23:06:07',NULL,NULL,NULL,'asd','2026-09-03 23:06:07',NULL),('911f7bd8-e191-4755-a076-f2cc98e2dc3d','SCN-20260904212103-0D67','5bda8f75-181b-4f6b-b477-74d909612b36','a0f79736-a5ed-11f1-92a0-a0ad9f192341','29742da6-a5f7-11f1-92a0-a0ad9f192341','a101f8d7-a5ed-11f1-92a0-a0ad9f192341','distribution_center','load','2026-09-04 14:21:04',NULL,NULL,NULL,NULL,'2026-09-04 14:21:04','0255e016-6833-4b51-8396-93f6106e1135'),('a01f8905-2db9-4752-ba49-9701d2f2ebc6','SCN-20260904195356-51DF','b767a521-1b8f-493d-9d61-7eac9a8ca424','a0f79736-a5ed-11f1-92a0-a0ad9f192341','29742da6-a5f7-11f1-92a0-a0ad9f192341',NULL,'branch','pickup','2026-09-04 12:53:57',NULL,NULL,NULL,NULL,'2026-09-04 12:53:57',NULL),('d01ae165-9caa-4f0d-a5af-067992b66ba2','SCN-20260904180716-C1F1','2b01a589-3226-402a-8e32-136b6d560f5a','a0f7913f-a5ed-11f1-92a0-a0ad9f192341','29742da6-a5f7-11f1-92a0-a0ad9f192341',NULL,'branch','pickup','2026-09-04 11:07:16',NULL,NULL,NULL,NULL,'2026-09-04 11:07:16',NULL),('dc7b52ca-629d-42e1-8cb4-c0c014f29397','SCN-20260904190359-3157','4265da9f-6e27-4ca1-8121-253bfac77344','a0f79736-a5ed-11f1-92a0-a0ad9f192341','29742da6-a5f7-11f1-92a0-a0ad9f192341',NULL,'branch','pickup','2026-09-04 12:04:00',NULL,NULL,NULL,NULL,'2026-09-04 12:04:00',NULL),('ea00b2e0-6515-4bd8-97cf-bc72f132d950','SCN-20260904201110-C949','5bda8f75-181b-4f6b-b477-74d909612b36','a0f79736-a5ed-11f1-92a0-a0ad9f192341','29742da6-a5f7-11f1-92a0-a0ad9f192341',NULL,'branch','pickup','2026-09-04 13:11:11',NULL,NULL,NULL,NULL,'2026-09-04 13:11:11',NULL),('eacff97a-bdd2-49e6-842b-bcc040ade827','SCN-20260904213733-A8C9','5bda8f75-181b-4f6b-b477-74d909612b36','a0f79736-a5ed-11f1-92a0-a0ad9f192341',NULL,NULL,'branch','delivered','2026-09-04 14:37:34',NULL,NULL,NULL,NULL,'2026-09-04 14:37:34',NULL),('f4cfd65e-bc50-4264-a9a1-19ab168c6eec','SCN-20260904213716-384F','5bda8f75-181b-4f6b-b477-74d909612b36','a0f79736-a5ed-11f1-92a0-a0ad9f192341','297466af-a5f7-11f1-92a0-a0ad9f192341','a101f8d7-a5ed-11f1-92a0-a0ad9f192341','distribution_center','unload','2026-09-04 14:37:17',NULL,NULL,NULL,NULL,'2026-09-04 14:37:17','0255e016-6833-4b51-8396-93f6106e1135');
/*!40000 ALTER TABLE `package_scans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payments` (
  `id` char(36) NOT NULL DEFAULT (uuid()),
  `payment_number` varchar(50) NOT NULL,
  `invoice_id` char(36) NOT NULL,
  `customer_id` char(36) NOT NULL,
  `amount` decimal(15,2) NOT NULL,
  `payment_method` enum('cash','card','online','vpp') NOT NULL,
  `payment_status` enum('pending','completed','failed','refunded') DEFAULT 'pending',
  `transaction_id` varchar(100) DEFAULT NULL,
  `payment_date` timestamp NULL DEFAULT NULL,
  `reference_number` varchar(100) DEFAULT NULL,
  `notes` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `payment_number` (`payment_number`),
  KEY `idx_payments_invoice` (`invoice_id`),
  KEY `idx_payments_customer` (`customer_id`),
  KEY `idx_payments_status` (`payment_status`),
  CONSTRAINT `fk_payments_customer` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`),
  CONSTRAINT `fk_payments_invoice` FOREIGN KEY (`invoice_id`) REFERENCES `invoices` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payments`
--

LOCK TABLES `payments` WRITE;
/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
INSERT INTO `payments` VALUES ('a109d522-a5ed-11f1-92a0-a0ad9f192341','PAY-202609-001','a1078abd-a5ed-11f1-92a0-a0ad9f192341','a0fb5c46-a5ed-11f1-92a0-a0ad9f192341',1100.00,'online','completed','TXN-001','2026-09-01 10:12:25','REF-001',NULL,'2026-09-01 10:12:25','2026-09-01 10:12:25');
/*!40000 ALTER TABLE `payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permissions`
--

DROP TABLE IF EXISTS `permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `permissions` (
  `id` char(36) NOT NULL DEFAULT (uuid()),
  `name` varchar(100) NOT NULL,
  `resource` varchar(100) NOT NULL,
  `action` varchar(50) NOT NULL,
  `scope` varchar(20) NOT NULL DEFAULT 'all',
  `description` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permissions`
--

LOCK TABLES `permissions` WRITE;
/*!40000 ALTER TABLE `permissions` DISABLE KEYS */;
INSERT INTO `permissions` VALUES ('e1c22c6c-a6eb-11f1-92a0-a0ad9f192341','users.delete.own','users','delete','all','DELETE permission for users (own)','2026-09-02 16:32:26'),('e1c231eb-a6eb-11f1-92a0-a0ad9f192341','users.delete.all','users','delete','all','DELETE permission for users (all)','2026-09-02 16:32:26'),('e1c23350-a6eb-11f1-92a0-a0ad9f192341','users.update.own','users','update','all','UPDATE permission for users (own)','2026-09-02 16:32:26'),('e1c233bc-a6eb-11f1-92a0-a0ad9f192341','users.update.all','users','update','all','UPDATE permission for users (all)','2026-09-02 16:32:26'),('e1c23500-a6eb-11f1-92a0-a0ad9f192341','users.read.own','users','read','all','READ permission for users (own)','2026-09-02 16:32:26'),('e1c23568-a6eb-11f1-92a0-a0ad9f192341','users.read.all','users','read','all','READ permission for users (all)','2026-09-02 16:32:26'),('e1c235c1-a6eb-11f1-92a0-a0ad9f192341','users.create.own','users','create','all','CREATE permission for users (own)','2026-09-02 16:32:26'),('e1c23661-a6eb-11f1-92a0-a0ad9f192341','users.create.all','users','create','all','CREATE permission for users (all)','2026-09-02 16:32:26'),('e1c236bc-a6eb-11f1-92a0-a0ad9f192341','roles.delete.own','roles','delete','all','DELETE permission for roles (own)','2026-09-02 16:32:26'),('e1c23711-a6eb-11f1-92a0-a0ad9f192341','roles.delete.all','roles','delete','all','DELETE permission for roles (all)','2026-09-02 16:32:26'),('e1c23879-a6eb-11f1-92a0-a0ad9f192341','roles.update.own','roles','update','all','UPDATE permission for roles (own)','2026-09-02 16:32:26'),('e1c2394e-a6eb-11f1-92a0-a0ad9f192341','roles.update.all','roles','update','all','UPDATE permission for roles (all)','2026-09-02 16:32:26'),('e1c239ae-a6eb-11f1-92a0-a0ad9f192341','roles.read.own','roles','read','all','READ permission for roles (own)','2026-09-02 16:32:26'),('e1c23a03-a6eb-11f1-92a0-a0ad9f192341','roles.read.all','roles','read','all','READ permission for roles (all)','2026-09-02 16:32:26'),('e1c23a59-a6eb-11f1-92a0-a0ad9f192341','roles.create.own','roles','create','all','CREATE permission for roles (own)','2026-09-02 16:32:26'),('e1c23ab4-a6eb-11f1-92a0-a0ad9f192341','roles.create.all','roles','create','all','CREATE permission for roles (all)','2026-09-02 16:32:26'),('e1c23b08-a6eb-11f1-92a0-a0ad9f192341','permissions.delete.own','permissions','delete','all','DELETE permission for permissions (own)','2026-09-02 16:32:26'),('e1c23b69-a6eb-11f1-92a0-a0ad9f192341','permissions.delete.all','permissions','delete','all','DELETE permission for permissions (all)','2026-09-02 16:32:26'),('e1c23bba-a6eb-11f1-92a0-a0ad9f192341','permissions.update.own','permissions','update','all','UPDATE permission for permissions (own)','2026-09-02 16:32:26'),('e1c23c23-a6eb-11f1-92a0-a0ad9f192341','permissions.update.all','permissions','update','all','UPDATE permission for permissions (all)','2026-09-02 16:32:26'),('e1c23c87-a6eb-11f1-92a0-a0ad9f192341','permissions.read.own','permissions','read','all','READ permission for permissions (own)','2026-09-02 16:32:26'),('e1c23cdd-a6eb-11f1-92a0-a0ad9f192341','permissions.read.all','permissions','read','all','READ permission for permissions (all)','2026-09-02 16:32:26'),('e1c23d33-a6eb-11f1-92a0-a0ad9f192341','permissions.create.own','permissions','create','all','CREATE permission for permissions (own)','2026-09-02 16:32:26'),('e1c23d9a-a6eb-11f1-92a0-a0ad9f192341','permissions.create.all','permissions','create','all','CREATE permission for permissions (all)','2026-09-02 16:32:26'),('e1c23ded-a6eb-11f1-92a0-a0ad9f192341','user_roles.delete.own','user_roles','delete','all','DELETE permission for user_roles (own)','2026-09-02 16:32:26'),('e1c23e41-a6eb-11f1-92a0-a0ad9f192341','user_roles.delete.all','user_roles','delete','all','DELETE permission for user_roles (all)','2026-09-02 16:32:26'),('e1c23eb4-a6eb-11f1-92a0-a0ad9f192341','user_roles.update.own','user_roles','update','all','UPDATE permission for user_roles (own)','2026-09-02 16:32:26'),('e1c23f08-a6eb-11f1-92a0-a0ad9f192341','user_roles.update.all','user_roles','update','all','UPDATE permission for user_roles (all)','2026-09-02 16:32:26'),('e1c23f5c-a6eb-11f1-92a0-a0ad9f192341','user_roles.read.own','user_roles','read','all','READ permission for user_roles (own)','2026-09-02 16:32:26'),('e1c23fbb-a6eb-11f1-92a0-a0ad9f192341','user_roles.read.all','user_roles','read','all','READ permission for user_roles (all)','2026-09-02 16:32:26'),('e1c2400e-a6eb-11f1-92a0-a0ad9f192341','user_roles.create.own','user_roles','create','all','CREATE permission for user_roles (own)','2026-09-02 16:32:26'),('e1c24061-a6eb-11f1-92a0-a0ad9f192341','user_roles.create.all','user_roles','create','all','CREATE permission for user_roles (all)','2026-09-02 16:32:26'),('e1c240c3-a6eb-11f1-92a0-a0ad9f192341','role_permissions.delete.own','role_permissions','delete','all','DELETE permission for role_permissions (own)','2026-09-02 16:32:26'),('e1c2412e-a6eb-11f1-92a0-a0ad9f192341','role_permissions.delete.all','role_permissions','delete','all','DELETE permission for role_permissions (all)','2026-09-02 16:32:26'),('e1c24195-a6eb-11f1-92a0-a0ad9f192341','role_permissions.update.own','role_permissions','update','all','UPDATE permission for role_permissions (own)','2026-09-02 16:32:26'),('e1c241ef-a6eb-11f1-92a0-a0ad9f192341','role_permissions.update.all','role_permissions','update','all','UPDATE permission for role_permissions (all)','2026-09-02 16:32:26'),('e1c24249-a6eb-11f1-92a0-a0ad9f192341','role_permissions.read.own','role_permissions','read','all','READ permission for role_permissions (own)','2026-09-02 16:32:26'),('e1c2429f-a6eb-11f1-92a0-a0ad9f192341','role_permissions.read.all','role_permissions','read','all','READ permission for role_permissions (all)','2026-09-02 16:32:26'),('e1c242f3-a6eb-11f1-92a0-a0ad9f192341','role_permissions.create.own','role_permissions','create','all','CREATE permission for role_permissions (own)','2026-09-02 16:32:26'),('e1c24347-a6eb-11f1-92a0-a0ad9f192341','role_permissions.create.all','role_permissions','create','all','CREATE permission for role_permissions (all)','2026-09-02 16:32:26'),('e1c2439d-a6eb-11f1-92a0-a0ad9f192341','employees.delete.own','employees','delete','all','DELETE permission for employees (own)','2026-09-02 16:32:26'),('e1c243ee-a6eb-11f1-92a0-a0ad9f192341','employees.delete.all','employees','delete','all','DELETE permission for employees (all)','2026-09-02 16:32:26'),('e1c24449-a6eb-11f1-92a0-a0ad9f192341','employees.update.own','employees','update','all','UPDATE permission for employees (own)','2026-09-02 16:32:26'),('e1c2449c-a6eb-11f1-92a0-a0ad9f192341','employees.update.all','employees','update','all','UPDATE permission for employees (all)','2026-09-02 16:32:26'),('e1c244ef-a6eb-11f1-92a0-a0ad9f192341','employees.read.own','employees','read','all','READ permission for employees (own)','2026-09-02 16:32:26'),('e1c24544-a6eb-11f1-92a0-a0ad9f192341','employees.read.all','employees','read','all','READ permission for employees (all)','2026-09-02 16:32:26'),('e1c24599-a6eb-11f1-92a0-a0ad9f192341','employees.create.own','employees','create','all','CREATE permission for employees (own)','2026-09-02 16:32:26'),('e1c245ea-a6eb-11f1-92a0-a0ad9f192341','employees.create.all','employees','create','all','CREATE permission for employees (all)','2026-09-02 16:32:26'),('e1c2463c-a6eb-11f1-92a0-a0ad9f192341','departments.delete.own','departments','delete','all','DELETE permission for departments (own)','2026-09-02 16:32:26'),('e1c2468c-a6eb-11f1-92a0-a0ad9f192341','departments.delete.all','departments','delete','all','DELETE permission for departments (all)','2026-09-02 16:32:26'),('e1c2477e-a6eb-11f1-92a0-a0ad9f192341','departments.update.own','departments','update','all','UPDATE permission for departments (own)','2026-09-02 16:32:26'),('e1c247e9-a6eb-11f1-92a0-a0ad9f192341','departments.update.all','departments','update','all','UPDATE permission for departments (all)','2026-09-02 16:32:26'),('e1c24840-a6eb-11f1-92a0-a0ad9f192341','departments.read.own','departments','read','all','READ permission for departments (own)','2026-09-02 16:32:26'),('e1c24893-a6eb-11f1-92a0-a0ad9f192341','departments.read.all','departments','read','all','READ permission for departments (all)','2026-09-02 16:32:26'),('e1c248e7-a6eb-11f1-92a0-a0ad9f192341','departments.create.own','departments','create','all','CREATE permission for departments (own)','2026-09-02 16:32:26'),('e1c24938-a6eb-11f1-92a0-a0ad9f192341','departments.create.all','departments','create','all','CREATE permission for departments (all)','2026-09-02 16:32:26'),('e1c6a9da-a6eb-11f1-92a0-a0ad9f192341','positions.delete.own','positions','delete','all','DELETE permission for positions (own)','2026-09-02 16:32:26'),('e1c6aaf0-a6eb-11f1-92a0-a0ad9f192341','positions.delete.all','positions','delete','all','DELETE permission for positions (all)','2026-09-02 16:32:26'),('e1c6ab61-a6eb-11f1-92a0-a0ad9f192341','positions.update.own','positions','update','all','UPDATE permission for positions (own)','2026-09-02 16:32:26'),('e1c6abd7-a6eb-11f1-92a0-a0ad9f192341','positions.update.all','positions','update','all','UPDATE permission for positions (all)','2026-09-02 16:32:26'),('e1c6ac35-a6eb-11f1-92a0-a0ad9f192341','positions.read.own','positions','read','all','READ permission for positions (own)','2026-09-02 16:32:26'),('e1c6ac9b-a6eb-11f1-92a0-a0ad9f192341','positions.read.all','positions','read','all','READ permission for positions (all)','2026-09-02 16:32:26'),('e1c6acf0-a6eb-11f1-92a0-a0ad9f192341','positions.create.own','positions','create','all','CREATE permission for positions (own)','2026-09-02 16:32:26'),('e1c6ad47-a6eb-11f1-92a0-a0ad9f192341','positions.create.all','positions','create','all','CREATE permission for positions (all)','2026-09-02 16:32:26'),('e1c6ada9-a6eb-11f1-92a0-a0ad9f192341','customers.delete.own','customers','delete','all','DELETE permission for customers (own)','2026-09-02 16:32:26'),('e1c6ae02-a6eb-11f1-92a0-a0ad9f192341','customers.delete.all','customers','delete','all','DELETE permission for customers (all)','2026-09-02 16:32:26'),('e1c6aff3-a6eb-11f1-92a0-a0ad9f192341','customers.update.own','customers','update','all','UPDATE permission for customers (own)','2026-09-02 16:32:26'),('e1c6b064-a6eb-11f1-92a0-a0ad9f192341','customers.update.all','customers','update','all','UPDATE permission for customers (all)','2026-09-02 16:32:26'),('e1c6b0c0-a6eb-11f1-92a0-a0ad9f192341','customers.read.own','customers','read','all','READ permission for customers (own)','2026-09-02 16:32:26'),('e1c6b1d3-a6eb-11f1-92a0-a0ad9f192341','customers.read.all','customers','read','all','READ permission for customers (all)','2026-09-02 16:32:26'),('e1c6b237-a6eb-11f1-92a0-a0ad9f192341','customers.create.own','customers','create','all','CREATE permission for customers (own)','2026-09-02 16:32:26'),('e1c6b289-a6eb-11f1-92a0-a0ad9f192341','customers.create.all','customers','create','all','CREATE permission for customers (all)','2026-09-02 16:32:26'),('e1c6b2df-a6eb-11f1-92a0-a0ad9f192341','customer_addresses.delete.own','customer_addresses','delete','all','DELETE permission for customer_addresses (own)','2026-09-02 16:32:26'),('e1c6b337-a6eb-11f1-92a0-a0ad9f192341','customer_addresses.delete.all','customer_addresses','delete','all','DELETE permission for customer_addresses (all)','2026-09-02 16:32:26'),('e1c6b39c-a6eb-11f1-92a0-a0ad9f192341','customer_addresses.update.own','customer_addresses','update','all','UPDATE permission for customer_addresses (own)','2026-09-02 16:32:26'),('e1c6b406-a6eb-11f1-92a0-a0ad9f192341','customer_addresses.update.all','customer_addresses','update','all','UPDATE permission for customer_addresses (all)','2026-09-02 16:32:26'),('e1c6b461-a6eb-11f1-92a0-a0ad9f192341','customer_addresses.read.own','customer_addresses','read','all','READ permission for customer_addresses (own)','2026-09-02 16:32:26'),('e1c6b4ba-a6eb-11f1-92a0-a0ad9f192341','customer_addresses.read.all','customer_addresses','read','all','READ permission for customer_addresses (all)','2026-09-02 16:32:26'),('e1c6b511-a6eb-11f1-92a0-a0ad9f192341','customer_addresses.create.own','customer_addresses','create','all','CREATE permission for customer_addresses (own)','2026-09-02 16:32:26'),('e1c6b564-a6eb-11f1-92a0-a0ad9f192341','customer_addresses.create.all','customer_addresses','create','all','CREATE permission for customer_addresses (all)','2026-09-02 16:32:26'),('e1c6b5c3-a6eb-11f1-92a0-a0ad9f192341','facilities.delete.own','facilities','delete','all','DELETE permission for facilities (own)','2026-09-02 16:32:26'),('e1c6b616-a6eb-11f1-92a0-a0ad9f192341','facilities.delete.all','facilities','delete','all','DELETE permission for facilities (all)','2026-09-02 16:32:26'),('e1c6b673-a6eb-11f1-92a0-a0ad9f192341','facilities.update.own','facilities','update','all','UPDATE permission for facilities (own)','2026-09-02 16:32:26'),('e1c6b6c7-a6eb-11f1-92a0-a0ad9f192341','facilities.update.all','facilities','update','all','UPDATE permission for facilities (all)','2026-09-02 16:32:26'),('e1c6b71c-a6eb-11f1-92a0-a0ad9f192341','facilities.read.own','facilities','read','all','READ permission for facilities (own)','2026-09-02 16:32:26'),('e1c6b785-a6eb-11f1-92a0-a0ad9f192341','facilities.read.all','facilities','read','all','READ permission for facilities (all)','2026-09-02 16:32:26'),('e1c6b7da-a6eb-11f1-92a0-a0ad9f192341','facilities.create.own','facilities','create','all','CREATE permission for facilities (own)','2026-09-02 16:32:26'),('e1c6b82c-a6eb-11f1-92a0-a0ad9f192341','facilities.create.all','facilities','create','all','CREATE permission for facilities (all)','2026-09-02 16:32:26'),('e1c6b893-a6eb-11f1-92a0-a0ad9f192341','pincodes.delete.own','pincodes','delete','all','DELETE permission for pincodes (own)','2026-09-02 16:32:26'),('e1c6b8f1-a6eb-11f1-92a0-a0ad9f192341','pincodes.delete.all','pincodes','delete','all','DELETE permission for pincodes (all)','2026-09-02 16:32:26'),('e1c6b945-a6eb-11f1-92a0-a0ad9f192341','pincodes.update.own','pincodes','update','all','UPDATE permission for pincodes (own)','2026-09-02 16:32:26'),('e1c6b99b-a6eb-11f1-92a0-a0ad9f192341','pincodes.update.all','pincodes','update','all','UPDATE permission for pincodes (all)','2026-09-02 16:32:26'),('e1c6b9ef-a6eb-11f1-92a0-a0ad9f192341','pincodes.read.own','pincodes','read','all','READ permission for pincodes (own)','2026-09-02 16:32:26'),('e1c6ba45-a6eb-11f1-92a0-a0ad9f192341','pincodes.read.all','pincodes','read','all','READ permission for pincodes (all)','2026-09-02 16:32:26'),('e1c6baa0-a6eb-11f1-92a0-a0ad9f192341','pincodes.create.own','pincodes','create','all','CREATE permission for pincodes (own)','2026-09-02 16:32:26'),('e1c6bb03-a6eb-11f1-92a0-a0ad9f192341','pincodes.create.all','pincodes','create','all','CREATE permission for pincodes (all)','2026-09-02 16:32:26'),('e1c6bb5a-a6eb-11f1-92a0-a0ad9f192341','storage_areas.delete.own','storage_areas','delete','all','DELETE permission for storage_areas (own)','2026-09-02 16:32:26'),('e1c6bbba-a6eb-11f1-92a0-a0ad9f192341','storage_areas.delete.all','storage_areas','delete','all','DELETE permission for storage_areas (all)','2026-09-02 16:32:26'),('e1c6bc0d-a6eb-11f1-92a0-a0ad9f192341','storage_areas.update.own','storage_areas','update','all','UPDATE permission for storage_areas (own)','2026-09-02 16:32:26'),('e1c6bc64-a6eb-11f1-92a0-a0ad9f192341','storage_areas.update.all','storage_areas','update','all','UPDATE permission for storage_areas (all)','2026-09-02 16:32:26'),('e1c6bcb8-a6eb-11f1-92a0-a0ad9f192341','storage_areas.read.own','storage_areas','read','all','READ permission for storage_areas (own)','2026-09-02 16:32:26'),('e1c6bd10-a6eb-11f1-92a0-a0ad9f192341','storage_areas.read.all','storage_areas','read','all','READ permission for storage_areas (all)','2026-09-02 16:32:26'),('e1c6bd65-a6eb-11f1-92a0-a0ad9f192341','storage_areas.create.own','storage_areas','create','all','CREATE permission for storage_areas (own)','2026-09-02 16:32:26'),('e1c6bdb8-a6eb-11f1-92a0-a0ad9f192341','storage_areas.create.all','storage_areas','create','all','CREATE permission for storage_areas (all)','2026-09-02 16:32:26'),('e1c6be0d-a6eb-11f1-92a0-a0ad9f192341','services.delete.own','services','delete','all','DELETE permission for services (own)','2026-09-02 16:32:26'),('e1c6be5f-a6eb-11f1-92a0-a0ad9f192341','services.delete.all','services','delete','all','DELETE permission for services (all)','2026-09-02 16:32:26'),('e1c6beaf-a6eb-11f1-92a0-a0ad9f192341','services.update.own','services','update','all','UPDATE permission for services (own)','2026-09-02 16:32:26'),('e1c6f102-a6eb-11f1-92a0-a0ad9f192341','services.update.all','services','update','all','UPDATE permission for services (all)','2026-09-02 16:32:26'),('e1c6f1e5-a6eb-11f1-92a0-a0ad9f192341','services.read.own','services','read','all','READ permission for services (own)','2026-09-02 16:32:26'),('e1c6f25f-a6eb-11f1-92a0-a0ad9f192341','services.read.all','services','read','all','READ permission for services (all)','2026-09-02 16:32:26'),('e1c6f2d9-a6eb-11f1-92a0-a0ad9f192341','services.create.own','services','create','all','CREATE permission for services (own)','2026-09-02 16:32:26'),('e1c6f33b-a6eb-11f1-92a0-a0ad9f192341','services.create.all','services','create','all','CREATE permission for services (all)','2026-09-02 16:32:26'),('e1c6f3a8-a6eb-11f1-92a0-a0ad9f192341','pricing_rules.delete.own','pricing_rules','delete','all','DELETE permission for pricing_rules (own)','2026-09-02 16:32:26'),('e1c6f425-a6eb-11f1-92a0-a0ad9f192341','pricing_rules.delete.all','pricing_rules','delete','all','DELETE permission for pricing_rules (all)','2026-09-02 16:32:26'),('e1c6f47e-a6eb-11f1-92a0-a0ad9f192341','pricing_rules.update.own','pricing_rules','update','all','UPDATE permission for pricing_rules (own)','2026-09-02 16:32:26'),('e1c6f4d9-a6eb-11f1-92a0-a0ad9f192341','pricing_rules.update.all','pricing_rules','update','all','UPDATE permission for pricing_rules (all)','2026-09-02 16:32:26'),('e1c6f544-a6eb-11f1-92a0-a0ad9f192341','pricing_rules.read.own','pricing_rules','read','all','READ permission for pricing_rules (own)','2026-09-02 16:32:26'),('e1c6f5a0-a6eb-11f1-92a0-a0ad9f192341','pricing_rules.read.all','pricing_rules','read','all','READ permission for pricing_rules (all)','2026-09-02 16:32:26'),('e1c6f5fb-a6eb-11f1-92a0-a0ad9f192341','pricing_rules.create.own','pricing_rules','create','all','CREATE permission for pricing_rules (own)','2026-09-02 16:32:26'),('e1c6f655-a6eb-11f1-92a0-a0ad9f192341','pricing_rules.create.all','pricing_rules','create','all','CREATE permission for pricing_rules (all)','2026-09-02 16:32:26'),('e1c6f6bc-a6eb-11f1-92a0-a0ad9f192341','insurance_plans.delete.own','insurance_plans','delete','all','DELETE permission for insurance_plans (own)','2026-09-02 16:32:26'),('e1c6f715-a6eb-11f1-92a0-a0ad9f192341','insurance_plans.delete.all','insurance_plans','delete','all','DELETE permission for insurance_plans (all)','2026-09-02 16:32:26'),('e1c6f76b-a6eb-11f1-92a0-a0ad9f192341','insurance_plans.update.own','insurance_plans','update','all','UPDATE permission for insurance_plans (own)','2026-09-02 16:32:26'),('e1c6f7c2-a6eb-11f1-92a0-a0ad9f192341','insurance_plans.update.all','insurance_plans','update','all','UPDATE permission for insurance_plans (all)','2026-09-02 16:32:26'),('e1c6f81f-a6eb-11f1-92a0-a0ad9f192341','insurance_plans.read.own','insurance_plans','read','all','READ permission for insurance_plans (own)','2026-09-02 16:32:26'),('e1c6f885-a6eb-11f1-92a0-a0ad9f192341','insurance_plans.read.all','insurance_plans','read','all','READ permission for insurance_plans (all)','2026-09-02 16:32:26'),('e1c6f8e5-a6eb-11f1-92a0-a0ad9f192341','insurance_plans.create.own','insurance_plans','create','all','CREATE permission for insurance_plans (own)','2026-09-02 16:32:26'),('e1c6f93a-a6eb-11f1-92a0-a0ad9f192341','insurance_plans.create.all','insurance_plans','create','all','CREATE permission for insurance_plans (all)','2026-09-02 16:32:26'),('e1c6f9ed-a6eb-11f1-92a0-a0ad9f192341','shipments.delete.own','shipments','delete','all','DELETE permission for shipments (own)','2026-09-02 16:32:26'),('e1c6fa4e-a6eb-11f1-92a0-a0ad9f192341','shipments.delete.all','shipments','delete','all','DELETE permission for shipments (all)','2026-09-02 16:32:26'),('e1c6faa5-a6eb-11f1-92a0-a0ad9f192341','shipments.update.own','shipments','update','all','UPDATE permission for shipments (own)','2026-09-02 16:32:26'),('e1c6fafb-a6eb-11f1-92a0-a0ad9f192341','shipments.update.all','shipments','update','all','UPDATE permission for shipments (all)','2026-09-02 16:32:26'),('e1c6fb54-a6eb-11f1-92a0-a0ad9f192341','shipments.read.own','shipments','read','all','READ permission for shipments (own)','2026-09-02 16:32:26'),('e1c6fbab-a6eb-11f1-92a0-a0ad9f192341','shipments.read.all','shipments','read','all','READ permission for shipments (all)','2026-09-02 16:32:26'),('e1c6fc00-a6eb-11f1-92a0-a0ad9f192341','shipments.create.own','shipments','create','all','CREATE permission for shipments (own)','2026-09-02 16:32:26'),('e1c6fc54-a6eb-11f1-92a0-a0ad9f192341','shipments.create.all','shipments','create','all','CREATE permission for shipments (all)','2026-09-02 16:32:26'),('e1c6fcaf-a6eb-11f1-92a0-a0ad9f192341','shipment_contacts.delete.own','shipment_contacts','delete','all','DELETE permission for shipment_contacts (own)','2026-09-02 16:32:26'),('e1c6fd08-a6eb-11f1-92a0-a0ad9f192341','shipment_contacts.delete.all','shipment_contacts','delete','all','DELETE permission for shipment_contacts (all)','2026-09-02 16:32:26'),('e1c6fd61-a6eb-11f1-92a0-a0ad9f192341','shipment_contacts.update.own','shipment_contacts','update','all','UPDATE permission for shipment_contacts (own)','2026-09-02 16:32:26'),('e1c6fdbb-a6eb-11f1-92a0-a0ad9f192341','shipment_contacts.update.all','shipment_contacts','update','all','UPDATE permission for shipment_contacts (all)','2026-09-02 16:32:26'),('e1c6fe13-a6eb-11f1-92a0-a0ad9f192341','shipment_contacts.read.own','shipment_contacts','read','all','READ permission for shipment_contacts (own)','2026-09-02 16:32:26'),('e1c6fe6b-a6eb-11f1-92a0-a0ad9f192341','shipment_contacts.read.all','shipment_contacts','read','all','READ permission for shipment_contacts (all)','2026-09-02 16:32:26'),('e1c6fecc-a6eb-11f1-92a0-a0ad9f192341','shipment_contacts.create.own','shipment_contacts','create','all','CREATE permission for shipment_contacts (own)','2026-09-02 16:32:26'),('e1c6ff39-a6eb-11f1-92a0-a0ad9f192341','shipment_contacts.create.all','shipment_contacts','create','all','CREATE permission for shipment_contacts (all)','2026-09-02 16:32:26'),('e1c6ff90-a6eb-11f1-92a0-a0ad9f192341','shipment_charges.delete.own','shipment_charges','delete','all','DELETE permission for shipment_charges (own)','2026-09-02 16:32:26'),('e1c6ffe7-a6eb-11f1-92a0-a0ad9f192341','shipment_charges.delete.all','shipment_charges','delete','all','DELETE permission for shipment_charges (all)','2026-09-02 16:32:26'),('e1c7003a-a6eb-11f1-92a0-a0ad9f192341','shipment_charges.update.own','shipment_charges','update','all','UPDATE permission for shipment_charges (own)','2026-09-02 16:32:26'),('e1c70093-a6eb-11f1-92a0-a0ad9f192341','shipment_charges.update.all','shipment_charges','update','all','UPDATE permission for shipment_charges (all)','2026-09-02 16:32:26'),('e1c700eb-a6eb-11f1-92a0-a0ad9f192341','shipment_charges.read.own','shipment_charges','read','all','READ permission for shipment_charges (own)','2026-09-02 16:32:26'),('e1c70144-a6eb-11f1-92a0-a0ad9f192341','shipment_charges.read.all','shipment_charges','read','all','READ permission for shipment_charges (all)','2026-09-02 16:32:26'),('e1c701aa-a6eb-11f1-92a0-a0ad9f192341','shipment_charges.create.own','shipment_charges','create','all','CREATE permission for shipment_charges (own)','2026-09-02 16:32:26'),('e1c70201-a6eb-11f1-92a0-a0ad9f192341','shipment_charges.create.all','shipment_charges','create','all','CREATE permission for shipment_charges (all)','2026-09-02 16:32:26'),('e1c70258-a6eb-11f1-92a0-a0ad9f192341','shipment_manifests.delete.own','shipment_manifests','delete','all','DELETE permission for shipment_manifests (own)','2026-09-02 16:32:26'),('e1c702b1-a6eb-11f1-92a0-a0ad9f192341','shipment_manifests.delete.all','shipment_manifests','delete','all','DELETE permission for shipment_manifests (all)','2026-09-02 16:32:26'),('e1c7030e-a6eb-11f1-92a0-a0ad9f192341','shipment_manifests.update.own','shipment_manifests','update','all','UPDATE permission for shipment_manifests (own)','2026-09-02 16:32:26'),('e1c70371-a6eb-11f1-92a0-a0ad9f192341','shipment_manifests.update.all','shipment_manifests','update','all','UPDATE permission for shipment_manifests (all)','2026-09-02 16:32:26'),('e1c72d7f-a6eb-11f1-92a0-a0ad9f192341','shipment_manifests.read.own','shipment_manifests','read','all','READ permission for shipment_manifests (own)','2026-09-02 16:32:26'),('e1c72e46-a6eb-11f1-92a0-a0ad9f192341','shipment_manifests.read.all','shipment_manifests','read','all','READ permission for shipment_manifests (all)','2026-09-02 16:32:26'),('e1c72eb0-a6eb-11f1-92a0-a0ad9f192341','shipment_manifests.create.own','shipment_manifests','create','all','CREATE permission for shipment_manifests (own)','2026-09-02 16:32:26'),('e1c72f15-a6eb-11f1-92a0-a0ad9f192341','shipment_manifests.create.all','shipment_manifests','create','all','CREATE permission for shipment_manifests (all)','2026-09-02 16:32:26'),('e1c72f81-a6eb-11f1-92a0-a0ad9f192341','shipment_requests.delete.own','shipment_requests','delete','all','DELETE permission for shipment_requests (own)','2026-09-02 16:32:26'),('e1c72fe0-a6eb-11f1-92a0-a0ad9f192341','shipment_requests.delete.all','shipment_requests','delete','all','DELETE permission for shipment_requests (all)','2026-09-02 16:32:26'),('e1c73040-a6eb-11f1-92a0-a0ad9f192341','shipment_requests.update.own','shipment_requests','update','all','UPDATE permission for shipment_requests (own)','2026-09-02 16:32:26'),('e1c730a1-a6eb-11f1-92a0-a0ad9f192341','shipment_requests.update.all','shipment_requests','update','all','UPDATE permission for shipment_requests (all)','2026-09-02 16:32:26'),('e1c73100-a6eb-11f1-92a0-a0ad9f192341','shipment_requests.read.own','shipment_requests','read','all','READ permission for shipment_requests (own)','2026-09-02 16:32:26'),('e1c7315b-a6eb-11f1-92a0-a0ad9f192341','shipment_requests.read.all','shipment_requests','read','all','READ permission for shipment_requests (all)','2026-09-02 16:32:26'),('e1c731c3-a6eb-11f1-92a0-a0ad9f192341','shipment_requests.create.own','shipment_requests','create','all','CREATE permission for shipment_requests (own)','2026-09-02 16:32:26'),('e1c7321a-a6eb-11f1-92a0-a0ad9f192341','shipment_requests.create.all','shipment_requests','create','all','CREATE permission for shipment_requests (all)','2026-09-02 16:32:26'),('e1c73276-a6eb-11f1-92a0-a0ad9f192341','shipment_status_history.delete.own','shipment_status_history','delete','all','DELETE permission for shipment_status_history (own)','2026-09-02 16:32:26'),('e1c732e2-a6eb-11f1-92a0-a0ad9f192341','shipment_status_history.delete.all','shipment_status_history','delete','all','DELETE permission for shipment_status_history (all)','2026-09-02 16:32:26'),('e1c7334a-a6eb-11f1-92a0-a0ad9f192341','shipment_status_history.update.own','shipment_status_history','update','all','UPDATE permission for shipment_status_history (own)','2026-09-02 16:32:26'),('e1c733a8-a6eb-11f1-92a0-a0ad9f192341','shipment_status_history.update.all','shipment_status_history','update','all','UPDATE permission for shipment_status_history (all)','2026-09-02 16:32:26'),('e1c73406-a6eb-11f1-92a0-a0ad9f192341','shipment_status_history.read.own','shipment_status_history','read','all','READ permission for shipment_status_history (own)','2026-09-02 16:32:26'),('e1c73460-a6eb-11f1-92a0-a0ad9f192341','shipment_status_history.read.all','shipment_status_history','read','all','READ permission for shipment_status_history (all)','2026-09-02 16:32:26'),('e1c734c3-a6eb-11f1-92a0-a0ad9f192341','shipment_status_history.create.own','shipment_status_history','create','all','CREATE permission for shipment_status_history (own)','2026-09-02 16:32:26'),('e1c73528-a6eb-11f1-92a0-a0ad9f192341','shipment_status_history.create.all','shipment_status_history','create','all','CREATE permission for shipment_status_history (all)','2026-09-02 16:32:26'),('e1c73584-a6eb-11f1-92a0-a0ad9f192341','tracking_events.delete.own','tracking_events','delete','all','DELETE permission for tracking_events (own)','2026-09-02 16:32:26'),('e1c735dd-a6eb-11f1-92a0-a0ad9f192341','tracking_events.delete.all','tracking_events','delete','all','DELETE permission for tracking_events (all)','2026-09-02 16:32:26'),('e1c7363e-a6eb-11f1-92a0-a0ad9f192341','tracking_events.update.own','tracking_events','update','all','UPDATE permission for tracking_events (own)','2026-09-02 16:32:26'),('e1c736a3-a6eb-11f1-92a0-a0ad9f192341','tracking_events.update.all','tracking_events','update','all','UPDATE permission for tracking_events (all)','2026-09-02 16:32:26'),('e1c736fe-a6eb-11f1-92a0-a0ad9f192341','tracking_events.read.own','tracking_events','read','all','READ permission for tracking_events (own)','2026-09-02 16:32:26'),('e1c73757-a6eb-11f1-92a0-a0ad9f192341','tracking_events.read.all','tracking_events','read','all','READ permission for tracking_events (all)','2026-09-02 16:32:26'),('e1c737af-a6eb-11f1-92a0-a0ad9f192341','tracking_events.create.own','tracking_events','create','all','CREATE permission for tracking_events (own)','2026-09-02 16:32:26'),('e1c7380a-a6eb-11f1-92a0-a0ad9f192341','tracking_events.create.all','tracking_events','create','all','CREATE permission for tracking_events (all)','2026-09-02 16:32:26'),('e1c738a2-a6eb-11f1-92a0-a0ad9f192341','tracking_status.delete.own','tracking_status','delete','all','DELETE permission for tracking_status (own)','2026-09-02 16:32:26'),('e1c738ff-a6eb-11f1-92a0-a0ad9f192341','tracking_status.delete.all','tracking_status','delete','all','DELETE permission for tracking_status (all)','2026-09-02 16:32:26'),('e1c73963-a6eb-11f1-92a0-a0ad9f192341','tracking_status.update.own','tracking_status','update','all','UPDATE permission for tracking_status (own)','2026-09-02 16:32:26'),('e1c739c4-a6eb-11f1-92a0-a0ad9f192341','tracking_status.update.all','tracking_status','update','all','UPDATE permission for tracking_status (all)','2026-09-02 16:32:26'),('e1c73a1e-a6eb-11f1-92a0-a0ad9f192341','tracking_status.read.own','tracking_status','read','all','READ permission for tracking_status (own)','2026-09-02 16:32:26'),('e1c73a78-a6eb-11f1-92a0-a0ad9f192341','tracking_status.read.all','tracking_status','read','all','READ permission for tracking_status (all)','2026-09-02 16:32:26'),('e1c73ad1-a6eb-11f1-92a0-a0ad9f192341','tracking_status.create.own','tracking_status','create','all','CREATE permission for tracking_status (own)','2026-09-02 16:32:26'),('e1c73eae-a6eb-11f1-92a0-a0ad9f192341','tracking_status.create.all','tracking_status','create','all','CREATE permission for tracking_status (all)','2026-09-02 16:32:26'),('e1c73f3a-a6eb-11f1-92a0-a0ad9f192341','routes.delete.own','routes','delete','all','DELETE permission for routes (own)','2026-09-02 16:32:26'),('e1c73f98-a6eb-11f1-92a0-a0ad9f192341','routes.delete.all','routes','delete','all','DELETE permission for routes (all)','2026-09-02 16:32:26'),('e1c73fef-a6eb-11f1-92a0-a0ad9f192341','routes.update.own','routes','update','all','UPDATE permission for routes (own)','2026-09-02 16:32:26'),('e1c7404b-a6eb-11f1-92a0-a0ad9f192341','routes.update.all','routes','update','all','UPDATE permission for routes (all)','2026-09-02 16:32:26'),('e1c740a4-a6eb-11f1-92a0-a0ad9f192341','routes.read.own','routes','read','all','READ permission for routes (own)','2026-09-02 16:32:26'),('e1c74102-a6eb-11f1-92a0-a0ad9f192341','routes.read.all','routes','read','all','READ permission for routes (all)','2026-09-02 16:32:26'),('e1c7415c-a6eb-11f1-92a0-a0ad9f192341','routes.create.own','routes','create','all','CREATE permission for routes (own)','2026-09-02 16:32:26'),('e1c741bf-a6eb-11f1-92a0-a0ad9f192341','routes.create.all','routes','create','all','CREATE permission for routes (all)','2026-09-02 16:32:26'),('e1c74216-a6eb-11f1-92a0-a0ad9f192341','route_stops.delete.own','route_stops','delete','all','DELETE permission for route_stops (own)','2026-09-02 16:32:26'),('e1c7426e-a6eb-11f1-92a0-a0ad9f192341','route_stops.delete.all','route_stops','delete','all','DELETE permission for route_stops (all)','2026-09-02 16:32:26'),('e1c742c8-a6eb-11f1-92a0-a0ad9f192341','route_stops.update.own','route_stops','update','all','UPDATE permission for route_stops (own)','2026-09-02 16:32:26'),('e1c74320-a6eb-11f1-92a0-a0ad9f192341','route_stops.update.all','route_stops','update','all','UPDATE permission for route_stops (all)','2026-09-02 16:32:26'),('e1c74378-a6eb-11f1-92a0-a0ad9f192341','route_stops.read.own','route_stops','read','all','READ permission for route_stops (own)','2026-09-02 16:32:26'),('e1c743d9-a6eb-11f1-92a0-a0ad9f192341','route_stops.read.all','route_stops','read','all','READ permission for route_stops (all)','2026-09-02 16:32:26'),('e1c74431-a6eb-11f1-92a0-a0ad9f192341','route_stops.create.own','route_stops','create','all','CREATE permission for route_stops (own)','2026-09-02 16:32:26'),('e1c74492-a6eb-11f1-92a0-a0ad9f192341','route_stops.create.all','route_stops','create','all','CREATE permission for route_stops (all)','2026-09-02 16:32:26'),('e1c744eb-a6eb-11f1-92a0-a0ad9f192341','delivery_assignments.delete.own','delivery_assignments','delete','all','DELETE permission for delivery_assignments (own)','2026-09-02 16:32:26'),('e1c74543-a6eb-11f1-92a0-a0ad9f192341','delivery_assignments.delete.all','delivery_assignments','delete','all','DELETE permission for delivery_assignments (all)','2026-09-02 16:32:26'),('e1c7459c-a6eb-11f1-92a0-a0ad9f192341','delivery_assignments.update.own','delivery_assignments','update','all','UPDATE permission for delivery_assignments (own)','2026-09-02 16:32:26'),('e1c7460b-a6eb-11f1-92a0-a0ad9f192341','delivery_assignments.update.all','delivery_assignments','update','all','UPDATE permission for delivery_assignments (all)','2026-09-02 16:32:26'),('e1c74668-a6eb-11f1-92a0-a0ad9f192341','delivery_assignments.read.own','delivery_assignments','read','all','READ permission for delivery_assignments (own)','2026-09-02 16:32:26'),('e1c746c4-a6eb-11f1-92a0-a0ad9f192341','delivery_assignments.read.all','delivery_assignments','read','all','READ permission for delivery_assignments (all)','2026-09-02 16:32:26'),('e1c74727-a6eb-11f1-92a0-a0ad9f192341','delivery_assignments.create.own','delivery_assignments','create','all','CREATE permission for delivery_assignments (own)','2026-09-02 16:32:26'),('e1c7477f-a6eb-11f1-92a0-a0ad9f192341','delivery_assignments.create.all','delivery_assignments','create','all','CREATE permission for delivery_assignments (all)','2026-09-02 16:32:26'),('e1c747e0-a6eb-11f1-92a0-a0ad9f192341','delivery_attempts.delete.own','delivery_attempts','delete','all','DELETE permission for delivery_attempts (own)','2026-09-02 16:32:26'),('e1c74841-a6eb-11f1-92a0-a0ad9f192341','delivery_attempts.delete.all','delivery_attempts','delete','all','DELETE permission for delivery_attempts (all)','2026-09-02 16:32:26'),('e1c748a2-a6eb-11f1-92a0-a0ad9f192341','delivery_attempts.update.own','delivery_attempts','update','all','UPDATE permission for delivery_attempts (own)','2026-09-02 16:32:26'),('e1c748fe-a6eb-11f1-92a0-a0ad9f192341','delivery_attempts.update.all','delivery_attempts','update','all','UPDATE permission for delivery_attempts (all)','2026-09-02 16:32:26'),('e1c7495d-a6eb-11f1-92a0-a0ad9f192341','delivery_attempts.read.own','delivery_attempts','read','all','READ permission for delivery_attempts (own)','2026-09-02 16:32:26'),('e1c749b7-a6eb-11f1-92a0-a0ad9f192341','delivery_attempts.read.all','delivery_attempts','read','all','READ permission for delivery_attempts (all)','2026-09-02 16:32:26'),('e1c74a10-a6eb-11f1-92a0-a0ad9f192341','delivery_attempts.create.own','delivery_attempts','create','all','CREATE permission for delivery_attempts (own)','2026-09-02 16:32:26'),('e1c74a66-a6eb-11f1-92a0-a0ad9f192341','delivery_attempts.create.all','delivery_attempts','create','all','CREATE permission for delivery_attempts (all)','2026-09-02 16:32:26'),('e1c74abe-a6eb-11f1-92a0-a0ad9f192341','vehicles.delete.own','vehicles','delete','all','DELETE permission for vehicles (own)','2026-09-02 16:32:26'),('e1c74b15-a6eb-11f1-92a0-a0ad9f192341','vehicles.delete.all','vehicles','delete','all','DELETE permission for vehicles (all)','2026-09-02 16:32:26'),('e1c74b6e-a6eb-11f1-92a0-a0ad9f192341','vehicles.update.own','vehicles','update','all','UPDATE permission for vehicles (own)','2026-09-02 16:32:26'),('e1c74bc7-a6eb-11f1-92a0-a0ad9f192341','vehicles.update.all','vehicles','update','all','UPDATE permission for vehicles (all)','2026-09-02 16:32:26'),('e1c74c26-a6eb-11f1-92a0-a0ad9f192341','vehicles.read.own','vehicles','read','all','READ permission for vehicles (own)','2026-09-02 16:32:26'),('e1c74c83-a6eb-11f1-92a0-a0ad9f192341','vehicles.read.all','vehicles','read','all','READ permission for vehicles (all)','2026-09-02 16:32:26'),('e1c74ce9-a6eb-11f1-92a0-a0ad9f192341','vehicles.create.own','vehicles','create','all','CREATE permission for vehicles (own)','2026-09-02 16:32:26'),('e1c74d44-a6eb-11f1-92a0-a0ad9f192341','vehicles.create.all','vehicles','create','all','CREATE permission for vehicles (all)','2026-09-02 16:32:26'),('e1c74d9a-a6eb-11f1-92a0-a0ad9f192341','vehicle_gps.delete.own','vehicle_gps','delete','all','DELETE permission for vehicle_gps (own)','2026-09-02 16:32:26'),('e1c74df3-a6eb-11f1-92a0-a0ad9f192341','vehicle_gps.delete.all','vehicle_gps','delete','all','DELETE permission for vehicle_gps (all)','2026-09-02 16:32:26'),('e1c74e49-a6eb-11f1-92a0-a0ad9f192341','vehicle_gps.update.own','vehicle_gps','update','all','UPDATE permission for vehicle_gps (own)','2026-09-02 16:32:26'),('e1c74ea1-a6eb-11f1-92a0-a0ad9f192341','vehicle_gps.update.all','vehicle_gps','update','all','UPDATE permission for vehicle_gps (all)','2026-09-02 16:32:26'),('e1c74efa-a6eb-11f1-92a0-a0ad9f192341','vehicle_gps.read.own','vehicle_gps','read','all','READ permission for vehicle_gps (own)','2026-09-02 16:32:26'),('e1c74f59-a6eb-11f1-92a0-a0ad9f192341','vehicle_gps.read.all','vehicle_gps','read','all','READ permission for vehicle_gps (all)','2026-09-02 16:32:26'),('e1c74fb1-a6eb-11f1-92a0-a0ad9f192341','vehicle_gps.create.own','vehicle_gps','create','all','CREATE permission for vehicle_gps (own)','2026-09-02 16:32:26'),('e1c7500e-a6eb-11f1-92a0-a0ad9f192341','vehicle_gps.create.all','vehicle_gps','create','all','CREATE permission for vehicle_gps (all)','2026-09-02 16:32:26'),('e1c75064-a6eb-11f1-92a0-a0ad9f192341','vehicle_maintenance.delete.own','vehicle_maintenance','delete','all','DELETE permission for vehicle_maintenance (own)','2026-09-02 16:32:26'),('e1c750bd-a6eb-11f1-92a0-a0ad9f192341','vehicle_maintenance.delete.all','vehicle_maintenance','delete','all','DELETE permission for vehicle_maintenance (all)','2026-09-02 16:32:26'),('e1c75117-a6eb-11f1-92a0-a0ad9f192341','vehicle_maintenance.update.own','vehicle_maintenance','update','all','UPDATE permission for vehicle_maintenance (own)','2026-09-02 16:32:26'),('e1c75172-a6eb-11f1-92a0-a0ad9f192341','vehicle_maintenance.update.all','vehicle_maintenance','update','all','UPDATE permission for vehicle_maintenance (all)','2026-09-02 16:32:26'),('e1c75eb4-a6eb-11f1-92a0-a0ad9f192341','vehicle_maintenance.read.own','vehicle_maintenance','read','all','READ permission for vehicle_maintenance (own)','2026-09-02 16:32:26'),('e1c83ceb-a6eb-11f1-92a0-a0ad9f192341','vehicle_maintenance.read.all','vehicle_maintenance','read','all','READ permission for vehicle_maintenance (all)','2026-09-02 16:32:26'),('e1c83dbd-a6eb-11f1-92a0-a0ad9f192341','vehicle_maintenance.create.own','vehicle_maintenance','create','all','CREATE permission for vehicle_maintenance (own)','2026-09-02 16:32:26'),('e1c83e2c-a6eb-11f1-92a0-a0ad9f192341','vehicle_maintenance.create.all','vehicle_maintenance','create','all','CREATE permission for vehicle_maintenance (all)','2026-09-02 16:32:26'),('e1c83e95-a6eb-11f1-92a0-a0ad9f192341','vehicle_fuel_logs.delete.own','vehicle_fuel_logs','delete','all','DELETE permission for vehicle_fuel_logs (own)','2026-09-02 16:32:26'),('e1c83ef1-a6eb-11f1-92a0-a0ad9f192341','vehicle_fuel_logs.delete.all','vehicle_fuel_logs','delete','all','DELETE permission for vehicle_fuel_logs (all)','2026-09-02 16:32:26'),('e1c83f51-a6eb-11f1-92a0-a0ad9f192341','vehicle_fuel_logs.update.own','vehicle_fuel_logs','update','all','UPDATE permission for vehicle_fuel_logs (own)','2026-09-02 16:32:26'),('e1c83fb8-a6eb-11f1-92a0-a0ad9f192341','vehicle_fuel_logs.update.all','vehicle_fuel_logs','update','all','UPDATE permission for vehicle_fuel_logs (all)','2026-09-02 16:32:26'),('e1c84014-a6eb-11f1-92a0-a0ad9f192341','vehicle_fuel_logs.read.own','vehicle_fuel_logs','read','all','READ permission for vehicle_fuel_logs (own)','2026-09-02 16:32:26'),('e1c86c60-a6eb-11f1-92a0-a0ad9f192341','vehicle_fuel_logs.read.all','vehicle_fuel_logs','read','all','READ permission for vehicle_fuel_logs (all)','2026-09-02 16:32:26'),('e1c86cce-a6eb-11f1-92a0-a0ad9f192341','vehicle_fuel_logs.create.own','vehicle_fuel_logs','create','all','CREATE permission for vehicle_fuel_logs (own)','2026-09-02 16:32:26'),('e1c86d2d-a6eb-11f1-92a0-a0ad9f192341','vehicle_fuel_logs.create.all','vehicle_fuel_logs','create','all','CREATE permission for vehicle_fuel_logs (all)','2026-09-02 16:32:26'),('e1c86d8e-a6eb-11f1-92a0-a0ad9f192341','transport_orders.delete.own','transport_orders','delete','all','DELETE permission for transport_orders (own)','2026-09-02 16:32:26'),('e1c86dff-a6eb-11f1-92a0-a0ad9f192341','transport_orders.delete.all','transport_orders','delete','all','DELETE permission for transport_orders (all)','2026-09-02 16:32:26'),('e1c86e5c-a6eb-11f1-92a0-a0ad9f192341','transport_orders.update.own','transport_orders','update','all','UPDATE permission for transport_orders (own)','2026-09-02 16:32:26'),('e1c86eca-a6eb-11f1-92a0-a0ad9f192341','transport_orders.update.all','transport_orders','update','all','UPDATE permission for transport_orders (all)','2026-09-02 16:32:26'),('e1c86f31-a6eb-11f1-92a0-a0ad9f192341','transport_orders.read.own','transport_orders','read','all','READ permission for transport_orders (own)','2026-09-02 16:32:26'),('e1c86f90-a6eb-11f1-92a0-a0ad9f192341','transport_orders.read.all','transport_orders','read','all','READ permission for transport_orders (all)','2026-09-02 16:32:26'),('e1c86fe9-a6eb-11f1-92a0-a0ad9f192341','transport_orders.create.own','transport_orders','create','all','CREATE permission for transport_orders (own)','2026-09-02 16:32:26'),('e1c8704e-a6eb-11f1-92a0-a0ad9f192341','transport_orders.create.all','transport_orders','create','all','CREATE permission for transport_orders (all)','2026-09-02 16:32:26'),('e1c870b6-a6eb-11f1-92a0-a0ad9f192341','manifest_items.delete.own','manifest_items','delete','all','DELETE permission for manifest_items (own)','2026-09-02 16:32:26'),('e1c87252-a6eb-11f1-92a0-a0ad9f192341','manifest_items.delete.all','manifest_items','delete','all','DELETE permission for manifest_items (all)','2026-09-02 16:32:26'),('e1c872b3-a6eb-11f1-92a0-a0ad9f192341','manifest_items.update.own','manifest_items','update','all','UPDATE permission for manifest_items (own)','2026-09-02 16:32:26'),('e1c8730e-a6eb-11f1-92a0-a0ad9f192341','manifest_items.update.all','manifest_items','update','all','UPDATE permission for manifest_items (all)','2026-09-02 16:32:26'),('e1c8736a-a6eb-11f1-92a0-a0ad9f192341','manifest_items.read.own','manifest_items','read','all','READ permission for manifest_items (own)','2026-09-02 16:32:26'),('e1c873c7-a6eb-11f1-92a0-a0ad9f192341','manifest_items.read.all','manifest_items','read','all','READ permission for manifest_items (all)','2026-09-02 16:32:26'),('e1c87422-a6eb-11f1-92a0-a0ad9f192341','manifest_items.create.own','manifest_items','create','all','CREATE permission for manifest_items (own)','2026-09-02 16:32:26'),('e1c8750d-a6eb-11f1-92a0-a0ad9f192341','manifest_items.create.all','manifest_items','create','all','CREATE permission for manifest_items (all)','2026-09-02 16:32:26'),('e1c87579-a6eb-11f1-92a0-a0ad9f192341','invoices.delete.own','invoices','delete','all','DELETE permission for invoices (own)','2026-09-02 16:32:26'),('e1c875d8-a6eb-11f1-92a0-a0ad9f192341','invoices.delete.all','invoices','delete','all','DELETE permission for invoices (all)','2026-09-02 16:32:26'),('e1c87634-a6eb-11f1-92a0-a0ad9f192341','invoices.update.own','invoices','update','all','UPDATE permission for invoices (own)','2026-09-02 16:32:26'),('e1c8769e-a6eb-11f1-92a0-a0ad9f192341','invoices.update.all','invoices','update','all','UPDATE permission for invoices (all)','2026-09-02 16:32:26'),('e1c876f7-a6eb-11f1-92a0-a0ad9f192341','invoices.read.own','invoices','read','all','READ permission for invoices (own)','2026-09-02 16:32:26'),('e1c8775b-a6eb-11f1-92a0-a0ad9f192341','invoices.read.all','invoices','read','all','READ permission for invoices (all)','2026-09-02 16:32:26'),('e1c877b4-a6eb-11f1-92a0-a0ad9f192341','invoices.create.own','invoices','create','all','CREATE permission for invoices (own)','2026-09-02 16:32:26'),('e1c8780b-a6eb-11f1-92a0-a0ad9f192341','invoices.create.all','invoices','create','all','CREATE permission for invoices (all)','2026-09-02 16:32:26'),('e1c87864-a6eb-11f1-92a0-a0ad9f192341','payments.delete.own','payments','delete','all','DELETE permission for payments (own)','2026-09-02 16:32:26'),('e1c878bb-a6eb-11f1-92a0-a0ad9f192341','payments.delete.all','payments','delete','all','DELETE permission for payments (all)','2026-09-02 16:32:26'),('e1c87916-a6eb-11f1-92a0-a0ad9f192341','payments.update.own','payments','update','all','UPDATE permission for payments (own)','2026-09-02 16:32:26'),('e1c8796e-a6eb-11f1-92a0-a0ad9f192341','payments.update.all','payments','update','all','UPDATE permission for payments (all)','2026-09-02 16:32:26'),('e1c879c7-a6eb-11f1-92a0-a0ad9f192341','payments.read.own','payments','read','all','READ permission for payments (own)','2026-09-02 16:32:26'),('e1c87a21-a6eb-11f1-92a0-a0ad9f192341','payments.read.all','payments','read','all','READ permission for payments (all)','2026-09-02 16:32:26'),('e1c87a7a-a6eb-11f1-92a0-a0ad9f192341','payments.create.own','payments','create','all','CREATE permission for payments (own)','2026-09-02 16:32:26'),('e1c87ad1-a6eb-11f1-92a0-a0ad9f192341','payments.create.all','payments','create','all','CREATE permission for payments (all)','2026-09-02 16:32:26'),('e1c87b2a-a6eb-11f1-92a0-a0ad9f192341','expenses.delete.own','expenses','delete','all','DELETE permission for expenses (own)','2026-09-02 16:32:26'),('e1c87b8f-a6eb-11f1-92a0-a0ad9f192341','expenses.delete.all','expenses','delete','all','DELETE permission for expenses (all)','2026-09-02 16:32:26'),('e1c87be8-a6eb-11f1-92a0-a0ad9f192341','expenses.update.own','expenses','update','all','UPDATE permission for expenses (own)','2026-09-02 16:32:26'),('e1c87c4f-a6eb-11f1-92a0-a0ad9f192341','expenses.update.all','expenses','update','all','UPDATE permission for expenses (all)','2026-09-02 16:32:26'),('e1c87ca8-a6eb-11f1-92a0-a0ad9f192341','expenses.read.own','expenses','read','all','READ permission for expenses (own)','2026-09-02 16:32:26'),('e1c87d02-a6eb-11f1-92a0-a0ad9f192341','expenses.read.all','expenses','read','all','READ permission for expenses (all)','2026-09-02 16:32:26'),('e1c87d5a-a6eb-11f1-92a0-a0ad9f192341','expenses.create.own','expenses','create','all','CREATE permission for expenses (own)','2026-09-02 16:32:26'),('e1c87db1-a6eb-11f1-92a0-a0ad9f192341','expenses.create.all','expenses','create','all','CREATE permission for expenses (all)','2026-09-02 16:32:26'),('e1c87e09-a6eb-11f1-92a0-a0ad9f192341','notifications.delete.own','notifications','delete','all','DELETE permission for notifications (own)','2026-09-02 16:32:26'),('e1c87e60-a6eb-11f1-92a0-a0ad9f192341','notifications.delete.all','notifications','delete','all','DELETE permission for notifications (all)','2026-09-02 16:32:26'),('e1c87eb8-a6eb-11f1-92a0-a0ad9f192341','notifications.update.own','notifications','update','all','UPDATE permission for notifications (own)','2026-09-02 16:32:26'),('e1c87f12-a6eb-11f1-92a0-a0ad9f192341','notifications.update.all','notifications','update','all','UPDATE permission for notifications (all)','2026-09-02 16:32:26'),('e1c87f6c-a6eb-11f1-92a0-a0ad9f192341','notifications.read.own','notifications','read','all','READ permission for notifications (own)','2026-09-02 16:32:26'),('e1c87fc8-a6eb-11f1-92a0-a0ad9f192341','notifications.read.all','notifications','read','all','READ permission for notifications (all)','2026-09-02 16:32:26'),('e1c88022-a6eb-11f1-92a0-a0ad9f192341','notifications.create.own','notifications','create','all','CREATE permission for notifications (own)','2026-09-02 16:32:26'),('e1c8807c-a6eb-11f1-92a0-a0ad9f192341','notifications.create.all','notifications','create','all','CREATE permission for notifications (all)','2026-09-02 16:32:26'),('e1c8811d-a6eb-11f1-92a0-a0ad9f192341','login_history.delete.own','login_history','delete','all','DELETE permission for login_history (own)','2026-09-02 16:32:26'),('e1c88179-a6eb-11f1-92a0-a0ad9f192341','login_history.delete.all','login_history','delete','all','DELETE permission for login_history (all)','2026-09-02 16:32:26'),('e1c881d1-a6eb-11f1-92a0-a0ad9f192341','login_history.update.own','login_history','update','all','UPDATE permission for login_history (own)','2026-09-02 16:32:26'),('e1c8822e-a6eb-11f1-92a0-a0ad9f192341','login_history.update.all','login_history','update','all','UPDATE permission for login_history (all)','2026-09-02 16:32:26'),('e1c88292-a6eb-11f1-92a0-a0ad9f192341','login_history.read.own','login_history','read','all','READ permission for login_history (own)','2026-09-02 16:32:26'),('e1c882ee-a6eb-11f1-92a0-a0ad9f192341','login_history.read.all','login_history','read','all','READ permission for login_history (all)','2026-09-02 16:32:26'),('e1c88347-a6eb-11f1-92a0-a0ad9f192341','login_history.create.own','login_history','create','all','CREATE permission for login_history (own)','2026-09-02 16:32:26'),('e1c883a9-a6eb-11f1-92a0-a0ad9f192341','login_history.create.all','login_history','create','all','CREATE permission for login_history (all)','2026-09-02 16:32:26'),('e1c88408-a6eb-11f1-92a0-a0ad9f192341','audit_logs.delete.own','audit_logs','delete','all','DELETE permission for audit_logs (own)','2026-09-02 16:32:26'),('e1c88460-a6eb-11f1-92a0-a0ad9f192341','audit_logs.delete.all','audit_logs','delete','all','DELETE permission for audit_logs (all)','2026-09-02 16:32:26'),('e1c884b8-a6eb-11f1-92a0-a0ad9f192341','audit_logs.update.own','audit_logs','update','all','UPDATE permission for audit_logs (own)','2026-09-02 16:32:26'),('e1c88511-a6eb-11f1-92a0-a0ad9f192341','audit_logs.update.all','audit_logs','update','all','UPDATE permission for audit_logs (all)','2026-09-02 16:32:26'),('e1c8856b-a6eb-11f1-92a0-a0ad9f192341','audit_logs.read.own','audit_logs','read','all','READ permission for audit_logs (own)','2026-09-02 16:32:26'),('e1c885c5-a6eb-11f1-92a0-a0ad9f192341','audit_logs.read.all','audit_logs','read','all','READ permission for audit_logs (all)','2026-09-02 16:32:26'),('e1c88627-a6eb-11f1-92a0-a0ad9f192341','audit_logs.create.own','audit_logs','create','all','CREATE permission for audit_logs (own)','2026-09-02 16:32:26'),('e1c88681-a6eb-11f1-92a0-a0ad9f192341','audit_logs.create.all','audit_logs','create','all','CREATE permission for audit_logs (all)','2026-09-02 16:32:26'),('e1c886db-a6eb-11f1-92a0-a0ad9f192341','proof_of_delivery.delete.own','proof_of_delivery','delete','all','DELETE permission for proof_of_delivery (own)','2026-09-02 16:32:26'),('e1c8873c-a6eb-11f1-92a0-a0ad9f192341','proof_of_delivery.delete.all','proof_of_delivery','delete','all','DELETE permission for proof_of_delivery (all)','2026-09-02 16:32:26'),('e1c88796-a6eb-11f1-92a0-a0ad9f192341','proof_of_delivery.update.own','proof_of_delivery','update','all','UPDATE permission for proof_of_delivery (own)','2026-09-02 16:32:26'),('e1c887f2-a6eb-11f1-92a0-a0ad9f192341','proof_of_delivery.update.all','proof_of_delivery','update','all','UPDATE permission for proof_of_delivery (all)','2026-09-02 16:32:26'),('e1c8884f-a6eb-11f1-92a0-a0ad9f192341','proof_of_delivery.read.own','proof_of_delivery','read','all','READ permission for proof_of_delivery (own)','2026-09-02 16:32:26'),('e1c888ab-a6eb-11f1-92a0-a0ad9f192341','proof_of_delivery.read.all','proof_of_delivery','read','all','READ permission for proof_of_delivery (all)','2026-09-02 16:32:26'),('e1c8890d-a6eb-11f1-92a0-a0ad9f192341','proof_of_delivery.create.own','proof_of_delivery','create','all','CREATE permission for proof_of_delivery (own)','2026-09-02 16:32:26'),('e1c889d0-a6eb-11f1-92a0-a0ad9f192341','proof_of_delivery.create.all','proof_of_delivery','create','all','CREATE permission for proof_of_delivery (all)','2026-09-02 16:32:26'),('e1c88a37-a6eb-11f1-92a0-a0ad9f192341','employee_profile_requests.delete.own','employee_profile_requests','delete','all','DELETE permission for employee_profile_requests (own)','2026-09-02 16:32:26'),('e1c88a93-a6eb-11f1-92a0-a0ad9f192341','employee_profile_requests.delete.all','employee_profile_requests','delete','all','DELETE permission for employee_profile_requests (all)','2026-09-02 16:32:26'),('e1c88dac-a6eb-11f1-92a0-a0ad9f192341','employee_profile_requests.update.own','employee_profile_requests','update','all','UPDATE permission for employee_profile_requests (own)','2026-09-02 16:32:26'),('e1c88e30-a6eb-11f1-92a0-a0ad9f192341','employee_profile_requests.update.all','employee_profile_requests','update','all','UPDATE permission for employee_profile_requests (all)','2026-09-02 16:32:26'),('e1c88ea9-a6eb-11f1-92a0-a0ad9f192341','employee_profile_requests.read.own','employee_profile_requests','read','all','READ permission for employee_profile_requests (own)','2026-09-02 16:32:26'),('e1c88f20-a6eb-11f1-92a0-a0ad9f192341','employee_profile_requests.read.all','employee_profile_requests','read','all','READ permission for employee_profile_requests (all)','2026-09-02 16:32:26'),('e1c88f81-a6eb-11f1-92a0-a0ad9f192341','employee_profile_requests.create.own','employee_profile_requests','create','all','CREATE permission for employee_profile_requests (own)','2026-09-02 16:32:26'),('e1c88fdc-a6eb-11f1-92a0-a0ad9f192341','employee_profile_requests.create.all','employee_profile_requests','create','all','CREATE permission for employee_profile_requests (all)','2026-09-02 16:32:26'),('e1c8903a-a6eb-11f1-92a0-a0ad9f192341','package_scans.delete.own','package_scans','delete','all','DELETE permission for package_scans (own)','2026-09-02 16:32:26'),('e1c89097-a6eb-11f1-92a0-a0ad9f192341','package_scans.delete.all','package_scans','delete','all','DELETE permission for package_scans (all)','2026-09-02 16:32:26'),('e1c890f2-a6eb-11f1-92a0-a0ad9f192341','package_scans.update.own','package_scans','update','all','UPDATE permission for package_scans (own)','2026-09-02 16:32:26'),('e1c8914e-a6eb-11f1-92a0-a0ad9f192341','package_scans.update.all','package_scans','update','all','UPDATE permission for package_scans (all)','2026-09-02 16:32:26'),('e1c891ba-a6eb-11f1-92a0-a0ad9f192341','package_scans.read.own','package_scans','read','all','READ permission for package_scans (own)','2026-09-02 16:32:26'),('e1c89216-a6eb-11f1-92a0-a0ad9f192341','package_scans.read.all','package_scans','read','all','READ permission for package_scans (all)','2026-09-02 16:32:26'),('e1c89270-a6eb-11f1-92a0-a0ad9f192341','package_scans.create.own','package_scans','create','all','CREATE permission for package_scans (own)','2026-09-02 16:32:26'),('e1c892d1-a6eb-11f1-92a0-a0ad9f192341','package_scans.create.all','package_scans','create','all','CREATE permission for package_scans (all)','2026-09-02 16:32:26');
/*!40000 ALTER TABLE `permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pincodes`
--

DROP TABLE IF EXISTS `pincodes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pincodes` (
  `id` char(36) NOT NULL DEFAULT (uuid()),
  `pincode` varchar(20) NOT NULL,
  `city` varchar(100) NOT NULL,
  `state` varchar(100) NOT NULL,
  `country` varchar(100) DEFAULT 'India',
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  `facility_id` char(36) DEFAULT NULL,
  `serviceable` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `pincode` (`pincode`),
  KEY `fk_pincodes_facility` (`facility_id`),
  CONSTRAINT `fk_pincodes_facility` FOREIGN KEY (`facility_id`) REFERENCES `facilities` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pincodes`
--

LOCK TABLES `pincodes` WRITE;
/*!40000 ALTER TABLE `pincodes` DISABLE KEYS */;
/*!40000 ALTER TABLE `pincodes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `positions`
--

DROP TABLE IF EXISTS `positions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `positions` (
  `id` char(36) NOT NULL DEFAULT (uuid()),
  `name` varchar(100) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `positions`
--

LOCK TABLES `positions` WRITE;
/*!40000 ALTER TABLE `positions` DISABLE KEYS */;
INSERT INTO `positions` VALUES ('a0f479ed-a5ed-11f1-92a0-a0ad9f192341','Warehouse Manager','Oversees warehouse operations',1,'2026-09-01 10:12:25'),('a0f47d0b-a5ed-11f1-92a0-a0ad9f192341','Operations Manager','Manages overall operations',1,'2026-09-01 10:12:25'),('a0f47da7-a5ed-11f1-92a0-a0ad9f192341','Customer Service Representative','Handles customer inquiries',1,'2026-09-01 10:12:25'),('a0f47dfb-a5ed-11f1-92a0-a0ad9f192341','Accountant','Manages financial records',1,'2026-09-01 10:12:25'),('a0f47e60-a5ed-11f1-92a0-a0ad9f192341','HR Manager','Oversees human resources',1,'2026-09-01 10:12:25'),('a0f47eab-a5ed-11f1-92a0-a0ad9f192341','Systems Administrator','Manages IT systems',1,'2026-09-01 10:12:25'),('a0f47ef5-a5ed-11f1-92a0-a0ad9f192341','Driver','Operates delivery vehicles',1,'2026-09-01 10:12:25'),('a0f47f3d-a5ed-11f1-92a0-a0ad9f192341','Warehouse Staff','Handles warehouse tasks',1,'2026-09-01 10:12:25'),('a0f47f88-a5ed-11f1-92a0-a0ad9f192341','Branch Manager','Manages branch operations',1,'2026-09-01 10:12:25');
/*!40000 ALTER TABLE `positions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pricing_rules`
--

DROP TABLE IF EXISTS `pricing_rules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pricing_rules` (
  `id` char(36) NOT NULL DEFAULT (uuid()),
  `service_id` char(36) NOT NULL,
  `name` varchar(100) NOT NULL,
  `rule_type` varchar(50) NOT NULL,
  `calculation_type` varchar(50) NOT NULL,
  `min_value` decimal(15,2) DEFAULT NULL,
  `max_value` decimal(15,2) DEFAULT NULL,
  `rate` decimal(15,4) NOT NULL,
  `condition_expression` text,
  `priority` int DEFAULT '0',
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_pricing_rules_service` (`service_id`),
  CONSTRAINT `fk_pricing_rules_service` FOREIGN KEY (`service_id`) REFERENCES `services` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pricing_rules`
--

LOCK TABLES `pricing_rules` WRITE;
/*!40000 ALTER TABLE `pricing_rules` DISABLE KEYS */;
INSERT INTO `pricing_rules` VALUES ('a10084be-a5ed-11f1-92a0-a0ad9f192341','a0ffb016-a5ed-11f1-92a0-a0ad9f192341','Express - Basic','weight','per_kg',0.00,10.00,150.0000,NULL,1,1,'2026-09-01 10:12:25','2026-09-01 10:12:25'),('a1008a35-a5ed-11f1-92a0-a0ad9f192341','a0ffb016-a5ed-11f1-92a0-a0ad9f192341','Express - Heavy','weight','per_kg',10.00,50.00,120.0000,NULL,2,1,'2026-09-01 10:12:25','2026-09-01 10:12:25'),('a1008b9c-a5ed-11f1-92a0-a0ad9f192341','a0ffb2ee-a5ed-11f1-92a0-a0ad9f192341','Standard - Basic','weight','per_kg',0.00,20.00,80.0000,NULL,1,1,'2026-09-01 10:12:25','2026-09-01 10:12:25'),('a1008cb4-a5ed-11f1-92a0-a0ad9f192341','a0ffb2ee-a5ed-11f1-92a0-a0ad9f192341','Standard - Heavy','weight','per_kg',20.00,100.00,60.0000,NULL,2,1,'2026-09-01 10:12:25','2026-09-01 10:12:25'),('a1008d98-a5ed-11f1-92a0-a0ad9f192341','a0ffb3b1-a5ed-11f1-92a0-a0ad9f192341','Economy - Basic','weight','per_kg',0.00,50.00,40.0000,NULL,1,1,'2026-09-01 10:12:25','2026-09-01 10:12:25');
/*!40000 ALTER TABLE `pricing_rules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `proof_of_delivery`
--

DROP TABLE IF EXISTS `proof_of_delivery`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proof_of_delivery` (
  `id` char(36) NOT NULL DEFAULT (uuid()),
  `shipment_id` char(36) NOT NULL,
  `delivery_attempt_id` char(36) NOT NULL,
  `receiver_name` varchar(200) NOT NULL,
  `receiver_signature` text,
  `receiver_relation` varchar(100) DEFAULT NULL,
  `delivery_photo` text,
  `delivery_time` timestamp NOT NULL,
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  `gps_accuracy` decimal(5,2) DEFAULT NULL,
  `notes` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `shipment_id` (`shipment_id`),
  KEY `fk_proof_of_delivery_attempt` (`delivery_attempt_id`),
  KEY `idx_proof_of_delivery_shipment` (`shipment_id`),
  CONSTRAINT `fk_proof_of_delivery_attempt` FOREIGN KEY (`delivery_attempt_id`) REFERENCES `delivery_attempts` (`id`),
  CONSTRAINT `fk_proof_of_delivery_shipment` FOREIGN KEY (`shipment_id`) REFERENCES `shipments` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `proof_of_delivery`
--

LOCK TABLES `proof_of_delivery` WRITE;
/*!40000 ALTER TABLE `proof_of_delivery` DISABLE KEYS */;
/*!40000 ALTER TABLE `proof_of_delivery` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role_permissions`
--

DROP TABLE IF EXISTS `role_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role_permissions` (
  `id` char(36) NOT NULL DEFAULT (uuid()),
  `role_id` char(36) NOT NULL,
  `permission_id` char(36) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_role_permission` (`role_id`,`permission_id`),
  KEY `fk_role_permissions_permission` (`permission_id`),
  CONSTRAINT `fk_role_permissions_permission` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_role_permissions_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role_permissions`
--

LOCK TABLES `role_permissions` WRITE;
/*!40000 ALTER TABLE `role_permissions` DISABLE KEYS */;
INSERT INTO `role_permissions` VALUES ('e1d02061-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c88681-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d155d7-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c88627-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d15775-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c88460-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d15828-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c88408-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d158cc-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c885c5-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d15970-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c8856b-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d15a0d-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c88511-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d15abe-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c884b8-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d15b69-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6b564-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d15c13-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6b511-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d15cae-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6b337-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d15d4f-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6b2df-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d15de7-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6b4ba-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d15e7f-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6b461-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d15f19-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6b406-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d15fb9-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6b39c-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d16051-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6b289-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d160e9-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6b237-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d16198-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6ae02-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d16231-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6ada9-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d162ca-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6b1d3-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d16363-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6b0c0-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d16404-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6b064-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d164a2-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6aff3-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d1653d-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c7477f-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d165db-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c74727-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d16679-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c74543-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d16729-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c744eb-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d167d0-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c746c4-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d1686c-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c74668-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d16905-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c7460b-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d1699f-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c7459c-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d16a43-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c74a66-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d16ae1-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c74a10-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d16b86-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c74841-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d16c21-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c747e0-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d16cce-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c749b7-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d16d69-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c7495d-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d16e05-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c748fe-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d16ea8-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c748a2-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d16f49-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c24938-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d16fee-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c248e7-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d17084-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c2468c-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d17121-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c2463c-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d171c2-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c24893-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d17271-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c24840-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d17311-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c247e9-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d173ae-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c2477e-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d17450-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c88fdc-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d174ff-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c88f81-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d175a9-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c88a93-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d17655-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c88a37-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d17700-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c88f20-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d177b3-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c88ea9-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d17858-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c88e30-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d178ff-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c88dac-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d179a7-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c245ea-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d17a44-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c24599-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d17ae0-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c243ee-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d17b82-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c2439d-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d17c22-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c24544-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d17cc0-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c244ef-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d17d5f-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c2449c-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d17dfc-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c24449-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d17e9a-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c87db1-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d17f41-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c87d5a-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d17fde-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c87b8f-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d1807a-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c87b2a-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d18116-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c87d02-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d181b1-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c87ca8-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d18255-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c87c4f-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d1831f-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c87be8-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d183be-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6b82c-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d1845b-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6b7da-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d184fd-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6b616-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d18595-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6b5c3-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d18630-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6b785-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d186cc-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6b71c-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d1876a-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6b6c7-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d1880e-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6b673-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d188b1-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6f93a-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d18957-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6f8e5-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d189f4-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6f715-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d18a91-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6f6bc-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d18b2f-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6f885-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d18be2-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6f81f-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d18c7e-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6f7c2-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d18d18-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6f76b-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d18db7-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c8780b-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d18e5d-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c877b4-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d18ef7-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c875d8-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d18f90-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c87579-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d19030-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c8775b-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d190cf-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c876f7-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d1916b-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c8769e-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d19210-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c87634-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d192af-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c883a9-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d19350-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c88347-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d193ec-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c88179-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d19491-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c8811d-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d1952f-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c882ee-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d195cc-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c88292-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d1966d-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c8822e-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d1972e-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c881d1-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d197fc-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c8750d-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d198d9-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c87422-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d199d0-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c87252-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d19b26-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c870b6-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d19c18-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c873c7-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d19d70-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c8736a-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d19e53-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c8730e-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d19f42-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c872b3-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d1a00e-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c8807c-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d1a0c6-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c88022-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d5fc42-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c87e60-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d5fdce-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c87e09-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d5fe95-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c87fc8-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d5ff48-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c87f6c-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d5fff7-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c87f12-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d600a0-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c87eb8-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d6014b-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c892d1-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d6020f-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c89270-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d602e1-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c89097-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d603d6-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c8903a-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d604e8-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c89216-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d605a0-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c891ba-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d60656-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c8914e-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d606f9-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c890f2-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d6079e-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c87ad1-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d60839-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c87a7a-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d608d2-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c878bb-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d60971-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c87864-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d60a16-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c87a21-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d60ab5-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c879c7-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d60b4b-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c8796e-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d60bdf-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c87916-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d60c85-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c23d9a-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d60d68-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c23d33-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d60e0e-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c23b69-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d60eb2-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c23b08-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d66293-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c23cdd-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d6642d-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c23c87-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d664eb-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c23c23-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d66594-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c23bba-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d66659-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6bb03-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d66786-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6baa0-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d66833-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6b8f1-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d668e3-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6b893-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d6697f-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6ba45-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d66a25-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6b9ef-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d66abd-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6b99b-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d66b55-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6b945-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d66bef-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6ad47-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d66c8a-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6acf0-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d66d24-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6aaf0-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d66dc8-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6a9da-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d66e65-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6ac9b-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d66f09-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6ac35-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d66fb0-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6abd7-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d6704a-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6ab61-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d670e4-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6f655-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d67184-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6f5fb-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d67227-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6f425-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d672c0-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6f3a8-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d6735d-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6f5a0-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d673fb-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6f544-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d6749d-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6f4d9-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d67545-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6f47e-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d675de-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c889d0-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d67681-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c8890d-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d6a962-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c8873c-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d6aa4d-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c886db-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d6aaf4-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c888ab-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d6ab9a-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c8884f-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d6ac3d-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c887f2-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d6ace6-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c88796-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d6adb2-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c24347-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d6ae72-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c242f3-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d6af17-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c2412e-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d6afc1-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c240c3-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d6b07f-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c2429f-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d6b122-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c24249-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d6b1c5-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c241ef-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d6b26c-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c24195-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d6b30e-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c23ab4-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d6b3b1-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c23a59-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d6b451-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c23711-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d6b500-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c236bc-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d6b59f-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c23a03-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d6b644-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c239ae-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d6b6e4-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c2394e-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d6b7a8-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c23879-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d6b84e-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c74492-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d6b96a-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c74431-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d6ba14-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c7426e-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d6bab7-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c74216-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d6bb53-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c743d9-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d6bbfa-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c74378-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d6bc98-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c74320-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d6bd30-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c742c8-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d6bdd1-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c741bf-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d6be6a-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c7415c-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d6bf33-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c73f98-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d6bfd4-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c73f3a-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d6c06d-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c74102-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d745ea-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c740a4-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d7470b-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c7404b-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d747b9-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c73fef-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d74861-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6f33b-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d74910-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6f2d9-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d749b4-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6be5f-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d74a9d-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6be0d-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d74b3c-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6f25f-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d74be1-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6f1e5-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d74c8c-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6f102-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d77653-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6beaf-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d77731-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c70201-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d777d6-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c701aa-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d7787d-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6ffe7-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d7792e-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6ff90-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d779de-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c70144-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d77a7e-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c700eb-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d77b23-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c70093-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d77bbc-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c7003a-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d77c5a-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6ff39-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d77cf6-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6fecc-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d77d91-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6fd08-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d77e35-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6fcaf-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d77ed8-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6fe6b-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d77f76-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6fe13-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d7800f-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6fdbb-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d780ab-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6fd61-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d78145-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c72f15-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d781ea-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c72eb0-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d78286-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c702b1-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d78324-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c70258-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d783c2-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c72e46-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d78473-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c72d7f-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d78523-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c70371-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d785bd-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c7030e-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d78657-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c7321a-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d786f7-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c731c3-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d78795-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c72fe0-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d78831-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c72f81-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d788d0-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c7315b-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d7896d-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c73100-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d78a1b-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c730a1-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d78ab4-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c73040-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d78b5a-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c73528-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d78c04-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c734c3-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d78ca0-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c732e2-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d78d3e-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c73276-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d78dda-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c73460-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d78e77-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c73406-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d78f0f-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c733a8-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d78fb0-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c7334a-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d79048-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6fc54-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d790ec-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6fc00-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d79189-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6fa4e-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d7922d-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6f9ed-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d792c7-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6fbab-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d7936a-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6fb54-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d79404-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6fafb-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d794a7-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6faa5-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d79541-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6bdb8-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d796ba-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6bd65-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d7975e-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6bbba-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d797fa-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6bb5a-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d79923-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6bd10-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d799cd-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6bcb8-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d79a72-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6bc64-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d79b0f-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c6bc0d-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d79baa-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c7380a-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d79c4b-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c737af-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d79ce8-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c735dd-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d79d84-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c73584-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d79e21-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c73757-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d79ec0-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c736fe-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d79f62-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c736a3-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d7a016-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c7363e-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d7a0b4-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c73eae-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d7a198-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c73ad1-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d7a236-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c738ff-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d7d04d-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c738a2-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d7d104-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c73a78-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d7d1a8-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c73a1e-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d7d247-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c739c4-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d7d2e3-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c73963-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d7d380-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c8704e-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d7d42c-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c86fe9-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d7d4cd-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c86dff-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d7d575-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c86d8e-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d7d612-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c86f90-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d7d6b8-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c86f31-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d7d756-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c86eca-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d7d7fa-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c86e5c-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d7d898-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c24061-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d7d93d-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c2400e-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d7d9e8-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c23e41-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d7da8d-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c23ded-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d7db36-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c23fbb-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d7dbd9-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c23f5c-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d7dc88-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c23f08-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d7dd2a-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c23eb4-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d7dde4-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c23661-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d7de8a-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c235c1-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d7df2d-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c231eb-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d7dfe1-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c22c6c-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1d7e096-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c23568-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1dce3f2-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c23500-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1dce64c-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c233bc-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1dce709-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c23350-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1dce7bf-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c86d2d-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1dce878-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c86cce-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1dce944-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c83ef1-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1dce9e9-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c83e95-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1dceac1-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c86c60-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1dceb71-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c84014-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1dcec0d-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c83fb8-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1dcecc0-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c83f51-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1dd18d9-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c7500e-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1dd19c7-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c74fb1-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1dd1a7c-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c74df3-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1dd1b26-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c74d9a-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1dd1bc9-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c74f59-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1dd1c70-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c74efa-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1dd1d22-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c74ea1-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1dd1dc4-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c74e49-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1dd1e60-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c83e2c-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1dd1f09-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c83dbd-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1dd1faa-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c750bd-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1dd2057-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c75064-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1dd20f4-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c83ceb-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1dd21af-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c75eb4-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1dd224f-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c75172-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1dd22ec-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c75117-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1dd2398-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c74d44-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1dd2466-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c74ce9-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1dd250f-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c74b15-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1dd25b7-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c74abe-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1dd4ff9-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c74c83-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1dd50c1-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c74c26-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1dd5164-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c74bc7-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1dd520a-a6eb-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','e1c74b6e-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ea5448-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c23350-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ea58ac-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c23500-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ea5b72-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c24544-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ea5c8d-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c24893-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ea5d94-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c6ac9b-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ea5e83-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c6ae02-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ea5f3e-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c6b064-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ea5ff7-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c6b1d3-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ea60aa-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c6b289-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ea616f-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c6b337-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ea6240-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c6b406-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ea62f7-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c6b4ba-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ea63aa-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c6b564-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ea6474-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c6b6c7-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ea6523-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c6b785-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ea65d4-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c6b82c-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ea66b4-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c6ba45-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ea67b4-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c6bd10-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ea68b8-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c6f25f-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ea69b4-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c6f5a0-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ea6aba-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c6f885-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ea6b92-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c6fa4e-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ea6c50-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c6fafb-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ea6d03-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c6fbab-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ea6db7-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c6fc54-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ea6e6f-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c6fd08-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ea6f36-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c6fdbb-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ea7008-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c6fe6b-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ea70c2-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c6ff39-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ea71ae-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c70144-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ea7284-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c702b1-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ea7346-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c70371-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ea7400-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c72e46-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ea74b7-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c72f15-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ea7573-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c72fe0-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ea762a-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c730a1-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ea76f1-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c7315b-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ea77af-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c7321a-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ea788c-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c733a8-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ea7942-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c73460-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ea79fe-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c73528-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ea7ac6-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c736a3-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ea7b76-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c73757-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ea7c28-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c7380a-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ea7d1f-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c73a78-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ea7dff-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c7404b-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ea7eb9-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c74102-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ea7f97-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c74320-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ea8057-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c743d9-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ea8139-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c7460b-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ea81fb-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c746c4-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ea82b1-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c7477f-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1eab174-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c748fe-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1eab29b-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c749b7-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1eab36c-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c74a66-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1eab444-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c74bc7-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1eab502-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c74c83-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1eab61c-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c74f59-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1eab6f6-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c750bd-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1eab7af-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c75172-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1eab877-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c83ceb-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1eab942-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c83ef1-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1eae400-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c83fb8-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1eae4f0-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c86c60-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1eae5de-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c86eca-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1eae69d-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c86f90-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1eae75d-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c8704e-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1eae818-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c87252-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1eae8df-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c8730e-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1eae9a0-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c873c7-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1eaea5b-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c8750d-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1eaeb76-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c8769e-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1eaec40-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c8775b-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1eaecf5-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c8780b-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1eaedc2-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c8796e-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1eaee76-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c87a21-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1eaef3f-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c87b8f-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1eaeff4-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c87c4f-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1eaf0aa-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c87d02-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1eaf175-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c87db1-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1eaf5f0-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c87e60-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1eaf6b9-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c87f12-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1eaf771-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c87fc8-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1eaf83f-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c8807c-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1eaf929-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c882ee-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1eafa2d-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c885c5-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1eafb0e-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c887f2-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1eafbc4-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c888ab-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1eafc92-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c889d0-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1eafd6a-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c88e30-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1eafe24-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c88f20-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1eafedf-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c88fdc-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1eaffb7-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c8914e-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1eb006f-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c89216-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1eb012e-a6eb-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','e1c892d1-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ee2483-a6eb-11f1-92a0-a0ad9f192341','a0fbe0c0-a5ed-11f1-92a0-a0ad9f192341','e1c6aff3-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ee2b1c-a6eb-11f1-92a0-a0ad9f192341','a0fbe0c0-a5ed-11f1-92a0-a0ad9f192341','e1c6b0c0-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ee2c5c-a6eb-11f1-92a0-a0ad9f192341','a0fbe0c0-a5ed-11f1-92a0-a0ad9f192341','e1c6b2df-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ee2d28-a6eb-11f1-92a0-a0ad9f192341','a0fbe0c0-a5ed-11f1-92a0-a0ad9f192341','e1c6b39c-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ee2df0-a6eb-11f1-92a0-a0ad9f192341','a0fbe0c0-a5ed-11f1-92a0-a0ad9f192341','e1c6b461-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ee2ec4-a6eb-11f1-92a0-a0ad9f192341','a0fbe0c0-a5ed-11f1-92a0-a0ad9f192341','e1c6b511-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ee2fce-a6eb-11f1-92a0-a0ad9f192341','a0fbe0c0-a5ed-11f1-92a0-a0ad9f192341','e1c6b785-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ee30f6-a6eb-11f1-92a0-a0ad9f192341','a0fbe0c0-a5ed-11f1-92a0-a0ad9f192341','e1c6ba45-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ee3232-a6eb-11f1-92a0-a0ad9f192341','a0fbe0c0-a5ed-11f1-92a0-a0ad9f192341','e1c6bd10-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ee3358-a6eb-11f1-92a0-a0ad9f192341','a0fbe0c0-a5ed-11f1-92a0-a0ad9f192341','e1c6f25f-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ee347e-a6eb-11f1-92a0-a0ad9f192341','a0fbe0c0-a5ed-11f1-92a0-a0ad9f192341','e1c6f5a0-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ee3593-a6eb-11f1-92a0-a0ad9f192341','a0fbe0c0-a5ed-11f1-92a0-a0ad9f192341','e1c6f885-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ee36a1-a6eb-11f1-92a0-a0ad9f192341','a0fbe0c0-a5ed-11f1-92a0-a0ad9f192341','e1c6fb54-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ee3771-a6eb-11f1-92a0-a0ad9f192341','a0fbe0c0-a5ed-11f1-92a0-a0ad9f192341','e1c6fc00-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ee384e-a6eb-11f1-92a0-a0ad9f192341','a0fbe0c0-a5ed-11f1-92a0-a0ad9f192341','e1c6fd61-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ee3909-a6eb-11f1-92a0-a0ad9f192341','a0fbe0c0-a5ed-11f1-92a0-a0ad9f192341','e1c6fe13-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ee39d2-a6eb-11f1-92a0-a0ad9f192341','a0fbe0c0-a5ed-11f1-92a0-a0ad9f192341','e1c6fecc-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ee3af1-a6eb-11f1-92a0-a0ad9f192341','a0fbe0c0-a5ed-11f1-92a0-a0ad9f192341','e1c70144-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ee3c4e-a6eb-11f1-92a0-a0ad9f192341','a0fbe0c0-a5ed-11f1-92a0-a0ad9f192341','e1c72e46-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ee3d1d-a6eb-11f1-92a0-a0ad9f192341','a0fbe0c0-a5ed-11f1-92a0-a0ad9f192341','e1c72f81-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ee3de8-a6eb-11f1-92a0-a0ad9f192341','a0fbe0c0-a5ed-11f1-92a0-a0ad9f192341','e1c73040-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ee3ea3-a6eb-11f1-92a0-a0ad9f192341','a0fbe0c0-a5ed-11f1-92a0-a0ad9f192341','e1c73100-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ee3f7d-a6eb-11f1-92a0-a0ad9f192341','a0fbe0c0-a5ed-11f1-92a0-a0ad9f192341','e1c731c3-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ee4091-a6eb-11f1-92a0-a0ad9f192341','a0fbe0c0-a5ed-11f1-92a0-a0ad9f192341','e1c73460-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ee41aa-a6eb-11f1-92a0-a0ad9f192341','a0fbe0c0-a5ed-11f1-92a0-a0ad9f192341','e1c73757-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ee42b8-a6eb-11f1-92a0-a0ad9f192341','a0fbe0c0-a5ed-11f1-92a0-a0ad9f192341','e1c73a78-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ee4835-a6eb-11f1-92a0-a0ad9f192341','a0fbe0c0-a5ed-11f1-92a0-a0ad9f192341','e1c876f7-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ee499a-a6eb-11f1-92a0-a0ad9f192341','a0fbe0c0-a5ed-11f1-92a0-a0ad9f192341','e1c879c7-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ee4a8b-a6eb-11f1-92a0-a0ad9f192341','a0fbe0c0-a5ed-11f1-92a0-a0ad9f192341','e1c87a7a-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ee4bfc-a6eb-11f1-92a0-a0ad9f192341','a0fbe0c0-a5ed-11f1-92a0-a0ad9f192341','e1c87f6c-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1ee5201-a6eb-11f1-92a0-a0ad9f192341','a0fbe0c0-a5ed-11f1-92a0-a0ad9f192341','e1c888ab-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f15783-a6eb-11f1-92a0-a0ad9f192341','a0fbe0c0-a5ed-11f1-92a0-a0ad9f192341','e1c89216-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f3e0bf-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c23568-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f3e9d3-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c243ee-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f3eae6-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c2449c-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f3ebc5-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c24544-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f3ec82-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c245ea-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f3ed36-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c2468c-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f3ede8-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c247e9-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f3eead-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c24893-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f3ef59-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c24938-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f3f01c-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c6aaf0-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f3f0dc-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c6abd7-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f3f197-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c6ac9b-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f3f249-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c6ad47-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f3f397-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c6b6c7-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f3f446-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c6b785-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f3f4fb-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c6b82c-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f3f5ca-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c6ba45-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f3f6a9-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c6bd10-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f3f79b-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c6f25f-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f3f8fc-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c6f5a0-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f3f9fa-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c6f885-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f3facb-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c6fa4e-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f3fb75-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c6fafb-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f3fc25-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c6fbab-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f3fcca-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c6fc54-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f3fd76-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c6fd08-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f3fe22-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c6fdbb-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f3fee4-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c6fe6b-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f3ff8a-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c6ff39-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f4005f-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c70144-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f4014f-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c70371-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f401fd-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c72e46-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f402ab-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c72f15-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f403c2-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c733a8-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f4046f-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c73460-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f40528-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c73528-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f405f5-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c736a3-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f406a0-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c73757-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f43334-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c7380a-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f43489-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c73a78-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f4357e-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c7404b-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f43632-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c74102-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f43714-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c74320-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f437c5-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c743d9-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f438a8-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c7460b-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f4395a-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c746c4-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f43a26-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c7477f-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f43ae4-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c748fe-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f43b95-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c749b7-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f43c50-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c74a66-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f43d12-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c74bc7-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f4682f-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c74c83-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f469d5-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c74f59-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f46adb-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c750bd-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f46b94-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c75172-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f46c46-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c83ceb-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f46d0a-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c83ef1-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f46dbf-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c83fb8-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f46e81-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c86c60-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f46f60-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c86eca-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f4700e-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c86f90-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f470b7-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c8704e-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f4717a-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c8730e-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f47221-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c873c7-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f472d3-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c8750d-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f473b7-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c8769e-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f47462-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c8775b-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f4750a-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c8780b-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f475cf-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c8796e-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f47678-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c87a21-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f4773a-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c87b8f-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f47839-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c87c4f-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f478e4-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c87d02-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f4799a-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c87db1-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f4a838-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c87e60-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f4a967-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c87f12-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f4aa2b-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c87fc8-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f4aae9-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c8807c-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f4abc6-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c882ee-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f4acbb-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c885c5-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f4ad9b-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c887f2-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f4ae56-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c888ab-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f4af03-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c889d0-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f4afca-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c88e30-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f4b07f-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c88f20-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f4b13f-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c88fdc-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f4b202-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c8914e-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f4b2ba-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c89216-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f4b36e-a6eb-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','e1c892d1-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f54b7d-a6eb-11f1-92a0-a0ad9f192341','a0fbe17a-a5ed-11f1-92a0-a0ad9f192341','e1c6fafb-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f55029-a6eb-11f1-92a0-a0ad9f192341','a0fbe17a-a5ed-11f1-92a0-a0ad9f192341','e1c6fbab-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f5513f-a6eb-11f1-92a0-a0ad9f192341','a0fbe17a-a5ed-11f1-92a0-a0ad9f192341','e1c6fe6b-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f5527a-a6eb-11f1-92a0-a0ad9f192341','a0fbe17a-a5ed-11f1-92a0-a0ad9f192341','e1c72e46-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f553dd-a6eb-11f1-92a0-a0ad9f192341','a0fbe17a-a5ed-11f1-92a0-a0ad9f192341','e1c7363e-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f554a5-a6eb-11f1-92a0-a0ad9f192341','a0fbe17a-a5ed-11f1-92a0-a0ad9f192341','e1c73757-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f55546-a6eb-11f1-92a0-a0ad9f192341','a0fbe17a-a5ed-11f1-92a0-a0ad9f192341','e1c737af-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f55615-a6eb-11f1-92a0-a0ad9f192341','a0fbe17a-a5ed-11f1-92a0-a0ad9f192341','e1c739c4-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f556cd-a6eb-11f1-92a0-a0ad9f192341','a0fbe17a-a5ed-11f1-92a0-a0ad9f192341','e1c73a78-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f557b9-a6eb-11f1-92a0-a0ad9f192341','a0fbe17a-a5ed-11f1-92a0-a0ad9f192341','e1c74102-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f558a3-a6eb-11f1-92a0-a0ad9f192341','a0fbe17a-a5ed-11f1-92a0-a0ad9f192341','e1c743d9-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f5597a-a6eb-11f1-92a0-a0ad9f192341','a0fbe17a-a5ed-11f1-92a0-a0ad9f192341','e1c7460b-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f55a29-a6eb-11f1-92a0-a0ad9f192341','a0fbe17a-a5ed-11f1-92a0-a0ad9f192341','e1c746c4-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f55af4-a6eb-11f1-92a0-a0ad9f192341','a0fbe17a-a5ed-11f1-92a0-a0ad9f192341','e1c748a2-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f55bba-a6eb-11f1-92a0-a0ad9f192341','a0fbe17a-a5ed-11f1-92a0-a0ad9f192341','e1c749b7-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f55c5d-a6eb-11f1-92a0-a0ad9f192341','a0fbe17a-a5ed-11f1-92a0-a0ad9f192341','e1c74a10-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f55d37-a6eb-11f1-92a0-a0ad9f192341','a0fbe17a-a5ed-11f1-92a0-a0ad9f192341','e1c74c83-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f55df8-a6eb-11f1-92a0-a0ad9f192341','a0fbe17a-a5ed-11f1-92a0-a0ad9f192341','e1c74e49-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f55ed6-a6eb-11f1-92a0-a0ad9f192341','a0fbe17a-a5ed-11f1-92a0-a0ad9f192341','e1c74f59-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f55f76-a6eb-11f1-92a0-a0ad9f192341','a0fbe17a-a5ed-11f1-92a0-a0ad9f192341','e1c74fb1-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f56127-a6eb-11f1-92a0-a0ad9f192341','a0fbe17a-a5ed-11f1-92a0-a0ad9f192341','e1c873c7-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f562cc-a6eb-11f1-92a0-a0ad9f192341','a0fbe17a-a5ed-11f1-92a0-a0ad9f192341','e1c87f6c-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f5642c-a6eb-11f1-92a0-a0ad9f192341','a0fbe17a-a5ed-11f1-92a0-a0ad9f192341','e1c88796-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f564e9-a6eb-11f1-92a0-a0ad9f192341','a0fbe17a-a5ed-11f1-92a0-a0ad9f192341','e1c888ab-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f56589-a6eb-11f1-92a0-a0ad9f192341','a0fbe17a-a5ed-11f1-92a0-a0ad9f192341','e1c8890d-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f566bd-a6eb-11f1-92a0-a0ad9f192341','a0fbe17a-a5ed-11f1-92a0-a0ad9f192341','e1c890f2-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f5677f-a6eb-11f1-92a0-a0ad9f192341','a0fbe17a-a5ed-11f1-92a0-a0ad9f192341','e1c89216-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26'),('e1f56843-a6eb-11f1-92a0-a0ad9f192341','a0fbe17a-a5ed-11f1-92a0-a0ad9f192341','e1c89270-a6eb-11f1-92a0-a0ad9f192341','2026-09-02 16:32:26');
/*!40000 ALTER TABLE `role_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id` char(36) NOT NULL DEFAULT (uuid()),
  `name` varchar(50) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `is_system` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `idx_unique_role_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES ('a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','Admin','Full system access - can manage everything',1,'2026-09-01 10:12:25','2026-09-01 10:12:25'),('a0fbe026-a5ed-11f1-92a0-a0ad9f192341','Employee','Can manage shipments, facilities, and operations',0,'2026-09-01 10:12:25','2026-09-01 10:12:25'),('a0fbe0c0-a5ed-11f1-92a0-a0ad9f192341','Customer','Can view their own shipments and create new ones',0,'2026-09-01 10:12:25','2026-09-01 10:12:25'),('a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','Branch Manager','Manages branch operations',0,'2026-09-01 10:12:25','2026-09-01 10:12:25'),('a0fbe17a-a5ed-11f1-92a0-a0ad9f192341','Driver','Delivery personnel',0,'2026-09-01 10:12:25','2026-09-01 10:12:25');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `route_stops`
--

DROP TABLE IF EXISTS `route_stops`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `route_stops` (
  `id` char(36) NOT NULL DEFAULT (uuid()),
  `route_id` char(36) NOT NULL,
  `stop_sequence` int NOT NULL,
  `facility_id` char(36) NOT NULL,
  `stop_name` varchar(200) NOT NULL,
  `pincode` varchar(20) DEFAULT NULL,
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  `estimated_arrival` int DEFAULT NULL,
  `estimated_departure` int DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_route_stops_route` (`route_id`),
  KEY `idx_route_stops_facility` (`facility_id`),
  CONSTRAINT `fk_route_stops_facility` FOREIGN KEY (`facility_id`) REFERENCES `facilities` (`id`),
  CONSTRAINT `fk_route_stops_route` FOREIGN KEY (`route_id`) REFERENCES `routes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `route_stops`
--

LOCK TABLES `route_stops` WRITE;
/*!40000 ALTER TABLE `route_stops` DISABLE KEYS */;
INSERT INTO `route_stops` VALUES ('25377f6c-a77b-11f1-92a0-a0ad9f192341','c27394a4-f0b2-45aa-962b-9b8f85900ba0',1,'297466af-a5f7-11f1-92a0-a0ad9f192341','Bac Ninh Distribution Center','160000',21.18610000,106.07630000,45,60,1,'2026-09-03 09:37:57','2026-09-03 09:37:57'),('2cb99791-6db1-4456-ad90-707026b41fd9','de9df009-e293-442c-a8aa-54eaa1e2709d',2,'29746bcc-a5f7-11f1-92a0-a0ad9f192341','Hai Duong Distribution Center','170000',20.93730000,106.31460000,105,120,1,'2026-09-01 04:31:01','2026-09-01 11:31:00'),('a105e3fd-a5ed-11f1-92a0-a0ad9f192341','a1053397-a5ed-11f1-92a0-a0ad9f192341',1,'a0f6af92-a5ed-11f1-92a0-a0ad9f192341','Mumbai Branch','400001',22.07600000,72.87770000,0,0,1,'2026-09-01 10:12:25','2026-09-01 10:13:46'),('a1066147-a5ed-11f1-92a0-a0ad9f192341','a1053397-a5ed-11f1-92a0-a0ad9f192341',2,'a0f6b3d5-a5ed-11f1-92a0-a0ad9f192341','Delhi Branch','110001',28.61390000,77.20900000,24,25,1,'2026-09-01 10:12:25','2026-09-01 10:12:25'),('a62eaab2-44fc-44e2-9e2c-cacae3561444','a1053397-a5ed-11f1-92a0-a0ad9f192341',3,'a0f6b3d5-a5ed-11f1-92a0-a0ad9f192341','ds','400005',4.00000000,5.00000000,7,3,1,'2026-09-01 03:16:17','2026-09-01 10:16:17'),('dfc5b519-eb61-4f5a-9150-b9a510539bb4','221efcc3-0314-491c-9153-80f37d229ccd',4,'29742da6-a5f7-11f1-92a0-a0ad9f192341','Hanoi Distribution Hub','100000',4.00000000,4.00000000,11,13,1,'2026-09-04 10:03:28','2026-09-04 17:03:28'),('e8ac39c8-1f5f-4d9b-af57-2c48f2979e8a','de9df009-e293-442c-a8aa-54eaa1e2709d',1,'297466af-a5f7-11f1-92a0-a0ad9f192341','Bac Ninh Distribution Center','160000',21.18610000,106.07630000,45,60,1,'2026-09-01 04:30:24','2026-09-01 11:30:23');
/*!40000 ALTER TABLE `route_stops` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `routes`
--

DROP TABLE IF EXISTS `routes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `routes` (
  `id` char(36) NOT NULL DEFAULT (uuid()),
  `route_code` varchar(50) NOT NULL,
  `name` varchar(200) NOT NULL,
  `origin_facility_id` char(36) NOT NULL,
  `destination_facility_id` char(36) NOT NULL,
  `distance` decimal(10,2) NOT NULL,
  `estimated_duration` int DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `route_code` (`route_code`),
  KEY `idx_routes_origin_facility` (`origin_facility_id`),
  KEY `idx_routes_destination_facility` (`destination_facility_id`),
  CONSTRAINT `fk_routes_destination_facility` FOREIGN KEY (`destination_facility_id`) REFERENCES `facilities` (`id`),
  CONSTRAINT `fk_routes_origin_facility` FOREIGN KEY (`origin_facility_id`) REFERENCES `facilities` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `routes`
--

LOCK TABLES `routes` WRITE;
/*!40000 ALTER TABLE `routes` DISABLE KEYS */;
INSERT INTO `routes` VALUES ('221efcc3-0314-491c-9153-80f37d229ccd','dsasda','qwewqe','a0f6b456-a5ed-11f1-92a0-a0ad9f192341','297466af-a5f7-11f1-92a0-a0ad9f192341',123.00,16,1,'2026-09-04 09:55:31','2026-09-04 16:55:30'),('a1053397-a5ed-11f1-92a0-a0ad9f192341','RTE-BOM-DEL','Mumbai to Delhi Route','a0f6af92-a5ed-11f1-92a0-a0ad9f192341','a0f6b3d5-a5ed-11f1-92a0-a0ad9f192341',1400.00,24,1,'2026-09-01 10:12:25','2026-09-01 10:12:25'),('a1053913-a5ed-11f1-92a0-a0ad9f192341','RTE-BOM-CHE','Mumbai to Chennai Route','a0f6b317-a5ed-11f1-92a0-a0ad9f192341','a0f6b456-a5ed-11f1-92a0-a0ad9f192341',1300.00,20,1,'2026-09-01 10:12:25','2026-09-01 10:12:25'),('a1053a95-a5ed-11f1-92a0-a0ad9f192341','RTE-DEL-HYD','Delhi to Hyderabad Route','a0f6b3d5-a5ed-11f1-92a0-a0ad9f192341','a0f6b4d0-a5ed-11f1-92a0-a0ad9f192341',1500.00,26,1,'2026-09-01 10:12:25','2026-09-01 10:12:25'),('a1053bcb-a5ed-11f1-92a0-a0ad9f192341','RTE-BOM-KOL','Mumbai to Kolkata Route','a0f6af92-a5ed-11f1-92a0-a0ad9f192341','a0f6b541-a5ed-11f1-92a0-a0ad9f192341',1800.00,30,1,'2026-09-01 10:12:25','2026-09-01 10:12:25'),('c27394a4-f0b2-45aa-962b-9b8f85900ba0','HN-BN-001','Hanoi - Bac Ninh Express Route','29742da6-a5f7-11f1-92a0-a0ad9f192341','297466af-a5f7-11f1-92a0-a0ad9f192341',48.20,80,1,'2026-09-01 05:23:59','2026-09-01 12:24:48'),('de9df009-e293-442c-a8aa-54eaa1e2709d','HN-HP-001','Hanoi - Hai Phong Main Route','29742da6-a5f7-11f1-92a0-a0ad9f192341','29746d66-a5f7-11f1-92a0-a0ad9f192341',120.50,180,1,'2026-09-01 04:29:34','2026-09-01 11:29:33');
/*!40000 ALTER TABLE `routes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `services`
--

DROP TABLE IF EXISTS `services`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `services` (
  `id` char(36) NOT NULL DEFAULT (uuid()),
  `code` varchar(50) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text,
  `service_type` varchar(50) NOT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `services`
--

LOCK TABLES `services` WRITE;
/*!40000 ALTER TABLE `services` DISABLE KEYS */;
INSERT INTO `services` VALUES ('a0ffb016-a5ed-11f1-92a0-a0ad9f192341','EXP-001','Express Delivery','Same day delivery service','Express',1,'2026-09-01 10:12:25','2026-09-01 10:12:25'),('a0ffb2ee-a5ed-11f1-92a0-a0ad9f192341','STD-001','Standard Delivery','Standard 2-3 day delivery','Standard',1,'2026-09-01 10:12:25','2026-09-01 10:12:25'),('a0ffb3b1-a5ed-11f1-92a0-a0ad9f192341','ECO-001','Economy Delivery','Cost effective delivery within 5-7 days','Economy',1,'2026-09-01 10:12:25','2026-09-01 10:12:25'),('a0ffb42c-a5ed-11f1-92a0-a0ad9f192341','FRG-001','Fragile Handling','Special handling for fragile items','Special',1,'2026-09-01 10:12:25','2026-09-01 10:12:25'),('a0ffb48f-a5ed-11f1-92a0-a0ad9f192341','LAR-001','Large Items','Special service for oversized items','Special',1,'2026-09-01 10:12:25','2026-09-01 10:12:25');
/*!40000 ALTER TABLE `services` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shipment_charges`
--

DROP TABLE IF EXISTS `shipment_charges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shipment_charges` (
  `id` char(36) NOT NULL DEFAULT (uuid()),
  `shipment_id` char(36) NOT NULL,
  `invoice_id` char(36) DEFAULT NULL,
  `charge_type` varchar(50) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `amount` decimal(15,2) NOT NULL,
  `calculation_reference` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_shipment_charges_shipment` (`shipment_id`),
  KEY `idx_shipment_charges_invoice` (`invoice_id`),
  CONSTRAINT `fk_shipment_charges_invoice` FOREIGN KEY (`invoice_id`) REFERENCES `invoices` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_shipment_charges_shipment` FOREIGN KEY (`shipment_id`) REFERENCES `shipments` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shipment_charges`
--

LOCK TABLES `shipment_charges` WRITE;
/*!40000 ALTER TABLE `shipment_charges` DISABLE KEYS */;
INSERT INTO `shipment_charges` VALUES ('a108a844-a5ed-11f1-92a0-a0ad9f192341','a102f87e-a5ed-11f1-92a0-a0ad9f192341','a106ff72-a5ed-11f1-92a0-a0ad9f192341','Base Freight','Standard shipping charge',500.00,'Weight: 5.5 kg','2026-09-01 10:12:25'),('a10936e1-a5ed-11f1-92a0-a0ad9f192341','a102f87e-a5ed-11f1-92a0-a0ad9f192341','a106ff72-a5ed-11f1-92a0-a0ad9f192341','Insurance','Basic Cover Insurance',125.00,'Coverage: 5000','2026-09-01 10:12:25');
/*!40000 ALTER TABLE `shipment_charges` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shipment_contacts`
--

DROP TABLE IF EXISTS `shipment_contacts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shipment_contacts` (
  `id` char(36) NOT NULL DEFAULT (uuid()),
  `shipment_id` char(36) NOT NULL,
  `contact_type` enum('sender','receiver') NOT NULL,
  `name` varchar(200) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `address_line1` varchar(255) NOT NULL,
  `address_line2` varchar(255) DEFAULT NULL,
  `city` varchar(100) NOT NULL,
  `state` varchar(100) DEFAULT NULL,
  `pincode` varchar(20) NOT NULL,
  `country` varchar(100) DEFAULT 'India',
  `landmark` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_shipment_contacts_shipment` (`shipment_id`),
  CONSTRAINT `fk_shipment_contacts_shipment` FOREIGN KEY (`shipment_id`) REFERENCES `shipments` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shipment_contacts`
--

LOCK TABLES `shipment_contacts` WRITE;
/*!40000 ALTER TABLE `shipment_contacts` DISABLE KEYS */;
INSERT INTO `shipment_contacts` VALUES ('a103e548-a5ed-11f1-92a0-a0ad9f192341','a1031bb7-a5ed-11f1-92a0-a0ad9f192341','sender','ELMS Corporate','9876543215','123 Corporate Tower','BKC','Mumbai','Maharashtra','400051','India','Near BKC Junction','2026-09-01 10:12:25'),('a103e954-a5ed-11f1-92a0-a0ad9f192341','a102f87e-a5ed-11f1-92a0-a0ad9f192341','sender','Tech Solutions Ltd','9876543215','456 Tech Park','Electronic City','Bangalore','Karnataka','560100','India','Opposite Intel','2026-09-01 10:12:25'),('a103ea64-a5ed-11f1-92a0-a0ad9f192341','a10313b0-a5ed-11f1-92a0-a0ad9f192341','sender','Global Logistics Inc','9876543215','321 Trade Center','Vashi','Navi Mumbai','Maharashtra','400703','India','Near Vashi Station','2026-09-01 10:12:25'),('a104844f-a5ed-11f1-92a0-a0ad9f192341','a102f87e-a5ed-11f1-92a0-a0ad9f192341','receiver','Global Logistics Inc','9876543216','321 Trade Center','Vashi','Navi Mumbai','Maharashtra','400703','India','Near Vashi Station','2026-09-01 10:12:25'),('a104877c-a5ed-11f1-92a0-a0ad9f192341','a10313b0-a5ed-11f1-92a0-a0ad9f192341','receiver','Fast Delivery Services','9876543217','654 Speed Complex','Andheri East','Mumbai','Maharashtra','400093','India','Near Airport','2026-09-01 10:12:25'),('a104884d-a5ed-11f1-92a0-a0ad9f192341','a1031bb7-a5ed-11f1-92a0-a0ad9f192341','receiver','Tech Solutions Ltd','9876543218','456 Tech Park','Electronic City','Bangalore','Karnataka','560100','India','Opposite Intel','2026-09-01 10:12:25');
/*!40000 ALTER TABLE `shipment_contacts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shipment_manifests`
--

DROP TABLE IF EXISTS `shipment_manifests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shipment_manifests` (
  `id` char(36) NOT NULL DEFAULT (uuid()),
  `manifest_number` varchar(50) NOT NULL,
  `vehicle_id` char(36) NOT NULL,
  `driver_id` char(36) NOT NULL,
  `route_id` char(36) NOT NULL,
  `departure_facility_id` char(36) NOT NULL,
  `departure_time` timestamp NOT NULL,
  `arrival_time` timestamp NULL DEFAULT NULL,
  `status` enum('planned','in_progress','completed','delayed','cancelled') DEFAULT 'planned',
  `total_packages` int DEFAULT '0',
  `total_weight` decimal(15,2) DEFAULT '0.00',
  `notes` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `manifest_number` (`manifest_number`),
  KEY `fk_shipment_manifests_departure_facility` (`departure_facility_id`),
  KEY `idx_shipment_manifests_vehicle` (`vehicle_id`),
  KEY `idx_shipment_manifests_driver` (`driver_id`),
  KEY `idx_shipment_manifests_route` (`route_id`),
  KEY `idx_shipment_manifests_status` (`status`),
  KEY `idx_shipment_manifests_departure` (`departure_time`),
  CONSTRAINT `fk_shipment_manifests_departure_facility` FOREIGN KEY (`departure_facility_id`) REFERENCES `facilities` (`id`),
  CONSTRAINT `fk_shipment_manifests_driver` FOREIGN KEY (`driver_id`) REFERENCES `employees` (`id`),
  CONSTRAINT `fk_shipment_manifests_route` FOREIGN KEY (`route_id`) REFERENCES `routes` (`id`),
  CONSTRAINT `fk_shipment_manifests_vehicle` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shipment_manifests`
--

LOCK TABLES `shipment_manifests` WRITE;
/*!40000 ALTER TABLE `shipment_manifests` DISABLE KEYS */;
INSERT INTO `shipment_manifests` VALUES ('6861bd2b-e4e6-4e88-8427-000a61c4c1c4','MAN-20260904201530-4F89','a101f8d7-a5ed-11f1-92a0-a0ad9f192341','a0f7913f-a5ed-11f1-92a0-a0ad9f192341','c27394a4-f0b2-45aa-962b-9b8f85900ba0','29742da6-a5f7-11f1-92a0-a0ad9f192341','2026-09-04 13:15:00','2026-09-04 14:28:13','completed',1,5.00,NULL,'2026-09-04 13:15:31','2026-09-04 21:37:16'),('9cba39c9-9410-40d2-a46e-9fd87f73f3fd','MAN-20260904061406-D759','a101fcee-a5ed-11f1-92a0-a0ad9f192341','a0f7913f-a5ed-11f1-92a0-a0ad9f192341','a1053397-a5ed-11f1-92a0-a0ad9f192341','a0f6af92-a5ed-11f1-92a0-a0ad9f192341','2026-09-04 06:14:00',NULL,'planned',8,34.00,NULL,'2026-09-03 23:14:07','2026-09-04 16:34:15'),('b68681ba-c646-4423-8250-aca7c3812290','MAN-20260902172729-1FCA','a101feaa-a5ed-11f1-92a0-a0ad9f192341','a0f7913f-a5ed-11f1-92a0-a0ad9f192341','c27394a4-f0b2-45aa-962b-9b8f85900ba0','29742da6-a5f7-11f1-92a0-a0ad9f192341','2026-09-18 08:04:00','2026-09-04 11:00:38','in_progress',1,2.50,NULL,'2026-09-02 10:27:30','2026-09-04 18:00:38'),('d3fb2457-d5cc-4a3c-8ccf-23822722f8e4','MAN-20260904191001-052B','a101f8d7-a5ed-11f1-92a0-a0ad9f192341','a0f79c04-a5ed-11f1-92a0-a0ad9f192341','c27394a4-f0b2-45aa-962b-9b8f85900ba0','29742da6-a5f7-11f1-92a0-a0ad9f192341','2026-09-04 12:09:00',NULL,'planned',0,0.00,NULL,'2026-09-04 12:10:02','2026-09-04 19:10:01');
/*!40000 ALTER TABLE `shipment_manifests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shipment_requests`
--

DROP TABLE IF EXISTS `shipment_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shipment_requests` (
  `id` char(36) NOT NULL DEFAULT (uuid()),
  `request_number` varchar(50) NOT NULL,
  `customer_id` char(36) NOT NULL,
  `sender_address_id` char(36) NOT NULL,
  `receiver_address_id` char(36) NOT NULL,
  `service_id` char(36) DEFAULT NULL,
  `package_type` varchar(50) NOT NULL,
  `weight` decimal(10,3) NOT NULL,
  `length` decimal(10,2) DEFAULT NULL,
  `width` decimal(10,2) DEFAULT NULL,
  `height` decimal(10,2) DEFAULT NULL,
  `declared_value` decimal(15,2) DEFAULT NULL,
  `insurance_plan_id` char(36) DEFAULT NULL,
  `special_instructions` text,
  `is_fragile` tinyint(1) DEFAULT '0',
  `is_large` tinyint(1) DEFAULT '0',
  `status` enum('pending','approved','rejected') DEFAULT 'pending',
  `estimated_cost` decimal(15,2) DEFAULT NULL,
  `approved_by` char(36) DEFAULT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `rejection_reason` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `request_number` (`request_number`),
  KEY `fk_shipment_requests_sender_address` (`sender_address_id`),
  KEY `fk_shipment_requests_receiver_address` (`receiver_address_id`),
  KEY `fk_shipment_requests_service` (`service_id`),
  KEY `fk_shipment_requests_insurance` (`insurance_plan_id`),
  KEY `fk_shipment_requests_approved_by` (`approved_by`),
  KEY `idx_shipment_requests_customer` (`customer_id`),
  KEY `idx_shipment_requests_status` (`status`),
  KEY `idx_shipment_requests_created_at` (`created_at`),
  CONSTRAINT `fk_shipment_requests_approved_by` FOREIGN KEY (`approved_by`) REFERENCES `employees` (`id`),
  CONSTRAINT `fk_shipment_requests_customer` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_shipment_requests_insurance` FOREIGN KEY (`insurance_plan_id`) REFERENCES `insurance_plans` (`id`),
  CONSTRAINT `fk_shipment_requests_receiver_address` FOREIGN KEY (`receiver_address_id`) REFERENCES `customer_addresses` (`id`),
  CONSTRAINT `fk_shipment_requests_sender_address` FOREIGN KEY (`sender_address_id`) REFERENCES `customer_addresses` (`id`),
  CONSTRAINT `fk_shipment_requests_service` FOREIGN KEY (`service_id`) REFERENCES `services` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shipment_requests`
--

LOCK TABLES `shipment_requests` WRITE;
/*!40000 ALTER TABLE `shipment_requests` DISABLE KEYS */;
INSERT INTO `shipment_requests` VALUES ('558a962d-e87b-4023-a8f0-759d7cc7c7ea','REQ-20260904043721-9D3A','a3021835-cca6-496a-a64a-13fbfffebb43','0b7375c2-25cc-4699-a998-2ee785bff606','189a71e1-24d1-49bc-93e0-5c2fbbd67a8d','a0ffb016-a5ed-11f1-92a0-a0ad9f192341','BOX',5.000,8.00,6.00,7.00,209.00,NULL,NULL,1,0,'approved',NULL,'a0f79736-a5ed-11f1-92a0-a0ad9f192341','2026-09-03 22:04:37',NULL,'2026-09-03 21:37:21','2026-09-04 05:04:37'),('8ffb61c5-ed62-41ee-a124-abd768872790','REQ-20260901131827-12CB','a0fb5651-a5ed-11f1-92a0-a0ad9f192341','20ea071c-a604-11f1-92a0-a0ad9f192341','20ea1563-a604-11f1-92a0-a0ad9f192341','a0ffb016-a5ed-11f1-92a0-a0ad9f192341','Box',2.500,30.00,20.00,15.00,500000.00,NULL,'Please handle with care.',1,0,'approved',NULL,'a0f79736-a5ed-11f1-92a0-a0ad9f192341','2026-09-01 06:37:01',NULL,'2026-09-01 06:18:27','2026-09-01 13:37:00'),('928bd80a-4fc7-4b24-aa38-94ad35a8564b','REQ-20260904035643-67D0','a710bd70-3861-4d24-8663-e47fe4d198cb','6fb52e1d-96b7-433d-b453-be167ac6c9e5','fbcbdf27-d6e4-42f6-aee8-fd52aac987c7','a0ffb2ee-a5ed-11f1-92a0-a0ad9f192341','box',12.000,32.00,41.00,42.00,124315234.00,'a1014855-a5ed-11f1-92a0-a0ad9f192341',NULL,1,0,'approved',NULL,'a0f79736-a5ed-11f1-92a0-a0ad9f192341','2026-09-03 22:04:48',NULL,'2026-09-03 20:56:44','2026-09-04 05:04:47'),('bc613994-e2b2-4828-a002-9c30059e34c0','REQ-20260901133419-4DDC','a0fb5651-a5ed-11f1-92a0-a0ad9f192341','20ea071c-a604-11f1-92a0-a0ad9f192341','20ea071c-a604-11f1-92a0-a0ad9f192341','a0ffb016-a5ed-11f1-92a0-a0ad9f192341','BOX',12.000,12.00,12.00,11.00,7500000.00,'a1014b28-a5ed-11f1-92a0-a0ad9f192341','quantrong',1,1,'approved',NULL,'a0f79736-a5ed-11f1-92a0-a0ad9f192341','2026-09-01 06:37:27',NULL,'2026-09-01 06:34:19','2026-09-01 13:37:26'),('c4bae0d5-92c8-4bd1-8c04-dd5428bdf663','REQ-20260904043803-FF55','a3021835-cca6-496a-a64a-13fbfffebb43','0b7375c2-25cc-4699-a998-2ee785bff606','189a71e1-24d1-49bc-93e0-5c2fbbd67a8d','a0ffb2ee-a5ed-11f1-92a0-a0ad9f192341','asd',8.000,7.00,7.00,6.00,1234.00,NULL,NULL,1,1,'approved',NULL,'a0f79736-a5ed-11f1-92a0-a0ad9f192341','2026-09-04 04:55:02',NULL,'2026-09-03 21:38:03','2026-09-04 11:55:01'),('fc973b87-fecb-4cc6-ae2e-02b4cbe97308','REQ-20260901131914-C229','a0fb5651-a5ed-11f1-92a0-a0ad9f192341','20ea071c-a604-11f1-92a0-a0ad9f192341','20ea1563-a604-11f1-92a0-a0ad9f192341','a0ffb016-a5ed-11f1-92a0-a0ad9f192341','Box',2.500,30.00,20.00,15.00,500000.00,NULL,'Please handle with care.',1,0,'approved',NULL,'a0f79736-a5ed-11f1-92a0-a0ad9f192341','2026-09-03 22:04:52',NULL,'2026-09-01 06:19:15','2026-09-04 05:04:52'),('fcce09d2-a5cf-4d0e-b62c-dccd55292b41','REQ-20260901132109-9D72','a0fb5651-a5ed-11f1-92a0-a0ad9f192341','20ea071c-a604-11f1-92a0-a0ad9f192341','20ea1563-a604-11f1-92a0-a0ad9f192341','a0ffb42c-a5ed-11f1-92a0-a0ad9f192341','Box',2.500,30.00,20.00,15.00,500000.00,NULL,'Please handle with care.',1,0,'approved',NULL,'a0f79736-a5ed-11f1-92a0-a0ad9f192341','2026-09-04 13:10:25',NULL,'2026-09-01 06:21:09','2026-09-04 20:10:25');
/*!40000 ALTER TABLE `shipment_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shipment_status_history`
--

DROP TABLE IF EXISTS `shipment_status_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shipment_status_history` (
  `id` char(36) NOT NULL DEFAULT (uuid()),
  `shipment_id` char(36) NOT NULL,
  `status` enum('created','pickup_scheduled','in_sorting','loaded','in_transit','out_for_delivery','delivered','exception','cancelled') NOT NULL,
  `changed_by` char(36) DEFAULT NULL,
  `changed_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `notes` text,
  PRIMARY KEY (`id`),
  KEY `fk_shipment_status_history_changed_by` (`changed_by`),
  KEY `idx_shipment_status_history_shipment` (`shipment_id`),
  KEY `idx_shipment_status_history_status` (`status`),
  KEY `idx_shipment_status_history_changed_at` (`changed_at`),
  CONSTRAINT `fk_shipment_status_history_changed_by` FOREIGN KEY (`changed_by`) REFERENCES `employees` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_shipment_status_history_shipment` FOREIGN KEY (`shipment_id`) REFERENCES `shipments` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shipment_status_history`
--

LOCK TABLES `shipment_status_history` WRITE;
/*!40000 ALTER TABLE `shipment_status_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `shipment_status_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shipments`
--

DROP TABLE IF EXISTS `shipments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shipments` (
  `id` char(36) NOT NULL DEFAULT (uuid()),
  `tracking_number` varchar(50) NOT NULL,
  `shipment_request_id` char(36) DEFAULT NULL,
  `service_id` char(36) NOT NULL,
  `customer_id` char(36) NOT NULL,
  `sender_address_id` char(36) NOT NULL,
  `receiver_address_id` char(36) NOT NULL,
  `weight` decimal(10,3) NOT NULL,
  `length` decimal(10,2) DEFAULT NULL,
  `width` decimal(10,2) DEFAULT NULL,
  `height` decimal(10,2) DEFAULT NULL,
  `declared_value` decimal(15,2) DEFAULT NULL,
  `insurance_plan_id` char(36) DEFAULT NULL,
  `insurance_amount` decimal(15,2) DEFAULT NULL,
  `package_type` varchar(50) NOT NULL,
  `special_instructions` text,
  `is_fragile` tinyint(1) DEFAULT '0',
  `is_large` tinyint(1) DEFAULT '0',
  `current_status` enum('created','pickup_scheduled','picked_up','in_sorting','loaded','in_transit','out_for_delivery','delivered','exception','cancelled') DEFAULT 'created',
  `estimated_delivery` date DEFAULT NULL,
  `actual_delivery` timestamp NULL DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `tracking_number` (`tracking_number`),
  KEY `fk_shipments_request` (`shipment_request_id`),
  KEY `fk_shipments_service` (`service_id`),
  KEY `fk_shipments_sender_address` (`sender_address_id`),
  KEY `fk_shipments_receiver_address` (`receiver_address_id`),
  KEY `fk_shipments_insurance` (`insurance_plan_id`),
  KEY `idx_shipments_tracking` (`tracking_number`),
  KEY `idx_shipments_customer` (`customer_id`),
  KEY `idx_shipments_status` (`current_status`),
  KEY `idx_shipments_estimated_delivery` (`estimated_delivery`),
  KEY `idx_shipments_created_at` (`created_at`),
  CONSTRAINT `fk_shipments_customer` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`),
  CONSTRAINT `fk_shipments_insurance` FOREIGN KEY (`insurance_plan_id`) REFERENCES `insurance_plans` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_shipments_receiver_address` FOREIGN KEY (`receiver_address_id`) REFERENCES `customer_addresses` (`id`),
  CONSTRAINT `fk_shipments_request` FOREIGN KEY (`shipment_request_id`) REFERENCES `shipment_requests` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_shipments_sender_address` FOREIGN KEY (`sender_address_id`) REFERENCES `customer_addresses` (`id`),
  CONSTRAINT `fk_shipments_service` FOREIGN KEY (`service_id`) REFERENCES `services` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shipments`
--

LOCK TABLES `shipments` WRITE;
/*!40000 ALTER TABLE `shipments` DISABLE KEYS */;
INSERT INTO `shipments` VALUES ('2b01a589-3226-402a-8e32-136b6d560f5a','TRK-20260901133726-7020','bc613994-e2b2-4828-a002-9c30059e34c0','a0ffb016-a5ed-11f1-92a0-a0ad9f192341','a0fb5651-a5ed-11f1-92a0-a0ad9f192341','20ea071c-a604-11f1-92a0-a0ad9f192341','20ea071c-a604-11f1-92a0-a0ad9f192341',12.000,12.00,12.00,11.00,7500000.00,'a1014b28-a5ed-11f1-92a0-a0ad9f192341',NULL,'BOX','quantrong',1,1,'in_sorting',NULL,NULL,1,'2026-09-01 06:37:27','2026-09-04 06:06:06'),('4265da9f-6e27-4ca1-8121-253bfac77344','TRK-20260904050447-56F6','928bd80a-4fc7-4b24-aa38-94ad35a8564b','a0ffb2ee-a5ed-11f1-92a0-a0ad9f192341','a710bd70-3861-4d24-8663-e47fe4d198cb','6fb52e1d-96b7-433d-b453-be167ac6c9e5','fbcbdf27-d6e4-42f6-aee8-fd52aac987c7',12.000,32.00,41.00,42.00,124315234.00,'a1014855-a5ed-11f1-92a0-a0ad9f192341',NULL,'box',NULL,1,0,'in_sorting',NULL,NULL,1,'2026-09-03 22:04:48','2026-09-04 20:51:42'),('5bda8f75-181b-4f6b-b477-74d909612b36','TRK-20260904201025-708A','fcce09d2-a5cf-4d0e-b62c-dccd55292b41','a0ffb42c-a5ed-11f1-92a0-a0ad9f192341','a0fb5651-a5ed-11f1-92a0-a0ad9f192341','20ea071c-a604-11f1-92a0-a0ad9f192341','20ea1563-a604-11f1-92a0-a0ad9f192341',2.500,30.00,20.00,15.00,500000.00,NULL,NULL,'Box','Please handle with care.',1,0,'delivered',NULL,'2026-09-04 14:37:34',1,'2026-09-04 13:10:25','2026-09-04 21:37:33'),('66ccf164-50e2-4581-afc2-2642ef7eb001','TRK-20260901133700-C232','8ffb61c5-ed62-41ee-a124-abd768872790','a0ffb016-a5ed-11f1-92a0-a0ad9f192341','a0fb5651-a5ed-11f1-92a0-a0ad9f192341','20ea071c-a604-11f1-92a0-a0ad9f192341','20ea1563-a604-11f1-92a0-a0ad9f192341',2.500,30.00,20.00,15.00,500000.00,NULL,NULL,'Box','Please handle with care.',1,0,'in_sorting',NULL,NULL,1,'2026-09-01 06:37:01','2026-09-04 06:04:15'),('83500430-9554-4cd2-b3aa-dbf7a7cafc21','TRK-20260904050452-CB9D','fc973b87-fecb-4cc6-ae2e-02b4cbe97308','a0ffb016-a5ed-11f1-92a0-a0ad9f192341','a0fb5651-a5ed-11f1-92a0-a0ad9f192341','20ea071c-a604-11f1-92a0-a0ad9f192341','20ea1563-a604-11f1-92a0-a0ad9f192341',2.500,30.00,20.00,15.00,500000.00,NULL,NULL,'Box','Please handle with care.',1,0,'in_sorting',NULL,NULL,1,'2026-09-03 22:04:52','2026-09-04 18:00:38'),('a102f87e-a5ed-11f1-92a0-a0ad9f192341','TRK-001-2024',NULL,'a0ffb016-a5ed-11f1-92a0-a0ad9f192341','a0fb5ac0-a5ed-11f1-92a0-a0ad9f192341','a0feedfb-a5ed-11f1-92a0-a0ad9f192341','a0fef00f-a5ed-11f1-92a0-a0ad9f192341',5.500,30.00,20.00,15.00,5000.00,'a1014855-a5ed-11f1-92a0-a0ad9f192341',125.00,'Box','Handle with care',0,0,'in_sorting','2026-09-02',NULL,1,'2026-09-01 10:12:25','2026-09-04 18:15:21'),('a10313b0-a5ed-11f1-92a0-a0ad9f192341','TRK-002-2024',NULL,'a0ffb2ee-a5ed-11f1-92a0-a0ad9f192341','a0fb5c46-a5ed-11f1-92a0-a0ad9f192341','a0fef00f-a5ed-11f1-92a0-a0ad9f192341','a0fef0c8-a5ed-11f1-92a0-a0ad9f192341',12.000,40.00,30.00,25.00,15000.00,'a1014b28-a5ed-11f1-92a0-a0ad9f192341',300.00,'Crate','Fragile items',1,0,'in_transit','2026-09-04',NULL,1,'2026-09-01 10:12:25','2026-09-01 10:12:25'),('a1031bb7-a5ed-11f1-92a0-a0ad9f192341','TRK-003-2024',NULL,'a0ffb3b1-a5ed-11f1-92a0-a0ad9f192341','a0fb5651-a5ed-11f1-92a0-a0ad9f192341','a0fee87e-a5ed-11f1-92a0-a0ad9f192341','a0feedfb-a5ed-11f1-92a0-a0ad9f192341',20.000,50.00,40.00,30.00,25000.00,'a1014bbc-a5ed-11f1-92a0-a0ad9f192341',375.00,'Pallet','Heavy items',0,1,'delivered','2026-08-30','2026-08-31 10:12:25',1,'2026-09-01 10:12:25','2026-09-01 10:12:25'),('b767a521-1b8f-493d-9d61-7eac9a8ca424','TRK-20260904115501-9AF0','c4bae0d5-92c8-4bd1-8c04-dd5428bdf663','a0ffb2ee-a5ed-11f1-92a0-a0ad9f192341','a3021835-cca6-496a-a64a-13fbfffebb43','0b7375c2-25cc-4699-a998-2ee785bff606','189a71e1-24d1-49bc-93e0-5c2fbbd67a8d',8.000,7.00,7.00,6.00,1234.00,NULL,NULL,'asd',NULL,1,1,'in_sorting',NULL,NULL,1,'2026-09-04 04:55:02','2026-09-04 20:51:42'),('bb884268-7b06-44e8-888d-9a56621c509c','TRK-20260904050436-8C5C','558a962d-e87b-4023-a8f0-759d7cc7c7ea','a0ffb016-a5ed-11f1-92a0-a0ad9f192341','a3021835-cca6-496a-a64a-13fbfffebb43','0b7375c2-25cc-4699-a998-2ee785bff606','189a71e1-24d1-49bc-93e0-5c2fbbd67a8d',5.000,8.00,6.00,7.00,209.00,NULL,NULL,'BOX',NULL,1,0,'created',NULL,NULL,1,'2026-09-03 22:04:37','2026-09-04 05:04:37');
/*!40000 ALTER TABLE `shipments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `storage_areas`
--

DROP TABLE IF EXISTS `storage_areas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `storage_areas` (
  `id` char(36) NOT NULL DEFAULT (uuid()),
  `facility_id` char(36) NOT NULL,
  `zone_code` varchar(50) NOT NULL,
  `shelf` varchar(50) DEFAULT NULL,
  `container` varchar(50) DEFAULT NULL,
  `capacity` decimal(15,2) DEFAULT NULL,
  `current_occupancy` decimal(15,2) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_storage_areas_facility` (`facility_id`),
  CONSTRAINT `fk_storage_areas_facility` FOREIGN KEY (`facility_id`) REFERENCES `facilities` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `storage_areas`
--

LOCK TABLES `storage_areas` WRITE;
/*!40000 ALTER TABLE `storage_areas` DISABLE KEYS */;
/*!40000 ALTER TABLE `storage_areas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tracking_events`
--

DROP TABLE IF EXISTS `tracking_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tracking_events` (
  `id` char(36) NOT NULL DEFAULT (uuid()),
  `shipment_id` char(36) NOT NULL,
  `package_scan_id` char(36) DEFAULT NULL,
  `tracking_status_id` char(36) NOT NULL,
  `event_location` varchar(255) DEFAULT NULL,
  `event_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `is_public` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_tracking_events_package_scan` (`package_scan_id`),
  KEY `idx_tracking_events_shipment` (`shipment_id`),
  KEY `idx_tracking_events_status` (`tracking_status_id`),
  KEY `idx_tracking_events_time` (`event_time`),
  CONSTRAINT `fk_tracking_events_package_scan` FOREIGN KEY (`package_scan_id`) REFERENCES `package_scans` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_tracking_events_shipment` FOREIGN KEY (`shipment_id`) REFERENCES `shipments` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_tracking_events_status` FOREIGN KEY (`tracking_status_id`) REFERENCES `tracking_status` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tracking_events`
--

LOCK TABLES `tracking_events` WRITE;
/*!40000 ALTER TABLE `tracking_events` DISABLE KEYS */;
INSERT INTO `tracking_events` VALUES ('077442a7-2b9f-483d-841a-1c7607ab30be','66ccf164-50e2-4581-afc2-2642ef7eb001',NULL,'2692e280-a1c7-444f-9557-b4eea5046d33','System','2026-09-01 06:37:01',1,'2026-09-01 06:37:01'),('0b8d6439-8a40-4682-9361-b9cfe11f796c','2b01a589-3226-402a-8e32-136b6d560f5a',NULL,'2692e280-a1c7-444f-9557-b4eea5046d33','System','2026-09-01 06:37:27',1,'2026-09-01 06:37:27'),('16bf5c57-bd8d-4c92-964d-e7dca61f4a2f','83500430-9554-4cd2-b3aa-dbf7a7cafc21','844a0903-eed7-4eea-a9d7-999ffad042ff','10816141-90d9-47e9-adfd-0cb6943d0d24','Hanoi Distribution Hub','2026-09-04 10:53:13',1,'2026-09-04 10:53:13'),('3eebd211-75a0-469c-ae7e-371edcd78f76','5bda8f75-181b-4f6b-b477-74d909612b36','eacff97a-bdd2-49e6-842b-bcc040ade827','a7a12a61-4e72-4a72-92f4-c942a19c3775','Unknown','2026-09-04 14:37:34',1,'2026-09-04 14:37:34'),('495f4b04-e7b9-47a9-89e8-4fec92de7c97','2b01a589-3226-402a-8e32-136b6d560f5a','84eaf42a-2256-4ae9-93da-cc6fbc04d6d6','f91bfce4-ba32-4dda-a4ae-5ea37205a992','Hanoi Distribution Hub','2026-09-03 23:06:07',1,'2026-09-03 23:06:07'),('49e43928-c52c-4472-8b2e-8388d4362f35','5bda8f75-181b-4f6b-b477-74d909612b36','30d4b98d-3486-4d76-81ef-5e1f5ffb9231','d1f62a9a-9bc5-48c3-9169-ed8825d313ec','Bac Ninh Distribution Center','2026-09-04 14:28:13',1,'2026-09-04 14:28:13'),('4e29d2aa-4ec2-4d58-a222-b834e6c93886','b767a521-1b8f-493d-9d61-7eac9a8ca424',NULL,'2692e280-a1c7-444f-9557-b4eea5046d33','System','2026-09-04 04:55:02',1,'2026-09-04 04:55:02'),('5afadada-ec74-46bc-a1d7-32a85dda130b','5bda8f75-181b-4f6b-b477-74d909612b36',NULL,'2692e280-a1c7-444f-9557-b4eea5046d33','System','2026-09-04 13:10:25',1,'2026-09-04 13:10:25'),('5c848fbe-5314-4dcc-ba8f-a36b539b92f5','83500430-9554-4cd2-b3aa-dbf7a7cafc21','0f4f0384-9edc-4b8e-ae90-c0a5cdd21d86','5ea252bf-dfda-4e04-834d-78625821b1b9','Hanoi Distribution Hub','2026-09-04 10:58:24',1,'2026-09-04 10:58:24'),('62fd4f33-5ed1-482f-b55e-f1827fcf6520','5bda8f75-181b-4f6b-b477-74d909612b36','6de4faec-8814-42be-8df4-811f7daa5c6b','13316091-e2fb-4114-9d49-8847eb3e8c7b','Bac Ninh Distribution Center','2026-09-04 14:37:28',1,'2026-09-04 14:37:28'),('71a0488b-0400-44d1-b805-a0d9910c1039','4265da9f-6e27-4ca1-8121-253bfac77344',NULL,'2692e280-a1c7-444f-9557-b4eea5046d33','System','2026-09-03 22:04:48',1,'2026-09-03 22:04:48'),('7c6f7ab8-7769-4d2f-9546-5a49f83e3edb','bb884268-7b06-44e8-888d-9a56621c509c',NULL,'2692e280-a1c7-444f-9557-b4eea5046d33','System','2026-09-03 22:04:37',1,'2026-09-03 22:04:37'),('809c2e86-4088-4602-94d0-9ef5e020e2a9','5bda8f75-181b-4f6b-b477-74d909612b36','ea00b2e0-6515-4bd8-97cf-bc72f132d950','f91bfce4-ba32-4dda-a4ae-5ea37205a992','Hanoi Distribution Hub','2026-09-04 13:11:11',1,'2026-09-04 13:11:11'),('817c9972-b8ce-41af-9382-b4ddf0597ac6','5bda8f75-181b-4f6b-b477-74d909612b36','911f7bd8-e191-4755-a076-f2cc98e2dc3d','10816141-90d9-47e9-adfd-0cb6943d0d24','Hanoi Distribution Hub','2026-09-04 14:21:04',1,'2026-09-04 14:21:04'),('a26b07cc-2a6d-4930-86d3-27817461841f','66ccf164-50e2-4581-afc2-2642ef7eb001','2c268e05-ce60-49b5-8f7a-00341156056d','f91bfce4-ba32-4dda-a4ae-5ea37205a992','Hanoi Distribution Hub','2026-09-04 11:07:34',1,'2026-09-04 11:07:34'),('aed8495b-af61-4d2d-8c8c-80d9eaca2cf7','b767a521-1b8f-493d-9d61-7eac9a8ca424','a01f8905-2db9-4752-ba49-9701d2f2ebc6','f91bfce4-ba32-4dda-a4ae-5ea37205a992','Hanoi Distribution Hub','2026-09-04 12:53:57',1,'2026-09-04 12:53:57'),('b80f16e1-06e1-4a15-9f01-22ff5242f900','83500430-9554-4cd2-b3aa-dbf7a7cafc21','056b5faf-4b8f-48ef-80dd-7f5882d30e9c','f91bfce4-ba32-4dda-a4ae-5ea37205a992','Hanoi Distribution Hub','2026-09-03 22:58:32',1,'2026-09-03 22:58:32'),('bc31ca6f-e5e8-4880-b529-23e09ea71668','a102f87e-a5ed-11f1-92a0-a0ad9f192341','31f8820d-ee3d-45e7-a39e-31bfe4dae536','f91bfce4-ba32-4dda-a4ae-5ea37205a992','Hanoi Distribution Hub','2026-09-04 11:15:22',1,'2026-09-04 11:15:22'),('c174bfd8-8321-4608-8f37-15f686639838','83500430-9554-4cd2-b3aa-dbf7a7cafc21','32a653be-ea7c-409d-98d7-3e6b6e490810','7b9a4866-3a54-4139-b303-8bfe22a12a88','Bac Ninh Distribution Center','2026-09-04 11:01:31',1,'2026-09-04 11:01:31'),('c453f228-d4ac-4371-928d-f0ee4ffe7100','4265da9f-6e27-4ca1-8121-253bfac77344','dc7b52ca-629d-42e1-8cb4-c0c014f29397','f91bfce4-ba32-4dda-a4ae-5ea37205a992','Hanoi Distribution Hub','2026-09-04 12:04:00',1,'2026-09-04 12:04:00'),('c4929ec7-61e4-4372-9b7c-7d0c69d3b4ef','83500430-9554-4cd2-b3aa-dbf7a7cafc21',NULL,'f91bfce4-ba32-4dda-a4ae-5ea37205a992','Hanoi Distribution Hub','2026-09-04 11:55:27',1,'2026-09-04 11:55:27'),('c8da9683-e59a-475b-a99d-be212fffe08b','83500430-9554-4cd2-b3aa-dbf7a7cafc21',NULL,'2692e280-a1c7-444f-9557-b4eea5046d33','System','2026-09-03 22:04:52',1,'2026-09-03 22:04:52'),('d86e85d1-e6b2-4292-beb5-deaad4c3b8b7','66ccf164-50e2-4581-afc2-2642ef7eb001','51a44e14-90a7-4f53-96fa-89fa34468271','f91bfce4-ba32-4dda-a4ae-5ea37205a992','Hanoi Distribution Hub','2026-09-03 23:04:15',1,'2026-09-03 23:04:15'),('d9906f8b-9781-42fb-854c-bc5c2f23b1a8','5bda8f75-181b-4f6b-b477-74d909612b36','f4cfd65e-bc50-4264-a9a1-19ab168c6eec','7b9a4866-3a54-4139-b303-8bfe22a12a88','Bac Ninh Distribution Center','2026-09-04 14:37:17',1,'2026-09-04 14:37:17'),('f0107997-facc-4376-b165-1282ee6401f7','83500430-9554-4cd2-b3aa-dbf7a7cafc21','18b9aed3-016e-447f-9b8b-80d821a50a19','d1f62a9a-9bc5-48c3-9169-ed8825d313ec','Bac Ninh Distribution Center','2026-09-04 11:00:38',1,'2026-09-04 11:00:38'),('f10e30f1-b4ae-421d-8eaa-92cc18c2e646','5bda8f75-181b-4f6b-b477-74d909612b36','066f058d-8202-40b8-8465-7137df003eed','5ea252bf-dfda-4e04-834d-78625821b1b9','Hanoi Distribution Hub','2026-09-04 14:27:44',1,'2026-09-04 14:27:44'),('f9de0f13-92c7-4ea7-8c45-c2a3f514bf9e','2b01a589-3226-402a-8e32-136b6d560f5a','d01ae165-9caa-4f0d-a5af-067992b66ba2','f91bfce4-ba32-4dda-a4ae-5ea37205a992','Hanoi Distribution Hub','2026-09-04 11:07:16',1,'2026-09-04 11:07:16');
/*!40000 ALTER TABLE `tracking_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tracking_status`
--

DROP TABLE IF EXISTS `tracking_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tracking_status` (
  `id` char(36) NOT NULL DEFAULT (uuid()),
  `code` varchar(50) NOT NULL,
  `description` text,
  `is_public` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tracking_status`
--

LOCK TABLES `tracking_status` WRITE;
/*!40000 ALTER TABLE `tracking_status` DISABLE KEYS */;
INSERT INTO `tracking_status` VALUES ('10816141-90d9-47e9-adfd-0cb6943d0d24','LOADED','LOADED',1,'2026-09-04 10:53:13'),('13316091-e2fb-4114-9d49-8847eb3e8c7b','OUT_FOR_DELIVERY','OUT FOR DELIVERY',1,'2026-09-04 14:37:28'),('2692e280-a1c7-444f-9557-b4eea5046d33','CREATED','Shipment Created',1,'2026-09-01 06:37:01'),('5ea252bf-dfda-4e04-834d-78625821b1b9','IN_TRANSIT','IN TRANSIT',1,'2026-09-04 10:58:24'),('7b9a4866-3a54-4139-b303-8bfe22a12a88','RECEIVED_AT_FACILITY','RECEIVED AT FACILITY',1,'2026-09-04 11:01:31'),('a7a12a61-4e72-4a72-92f4-c942a19c3775','DELIVERED','DELIVERED',1,'2026-09-04 14:37:34'),('d1f62a9a-9bc5-48c3-9169-ed8825d313ec','ARRIVED_AT_FACILITY','ARRIVED AT FACILITY',1,'2026-09-04 11:00:38'),('f91bfce4-ba32-4dda-a4ae-5ea37205a992','PICKED_UP','PICKED UP',1,'2026-09-03 22:58:32');
/*!40000 ALTER TABLE `tracking_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transport_orders`
--

DROP TABLE IF EXISTS `transport_orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transport_orders` (
  `id` char(36) NOT NULL DEFAULT (uuid()),
  `order_number` varchar(50) NOT NULL,
  `shipment_id` char(36) NOT NULL,
  `priority` int DEFAULT '5',
  `weight` decimal(10,3) NOT NULL,
  `volume` decimal(10,3) DEFAULT NULL,
  `special_instructions` text,
  `status` enum('created','planned','assigned','in_transit','delivered','cancelled') DEFAULT 'created',
  `created_by` char(36) DEFAULT NULL,
  `assigned_vehicle_id` char(36) DEFAULT NULL,
  `assigned_driver_id` char(36) DEFAULT NULL,
  `planned_departure` timestamp NULL DEFAULT NULL,
  `planned_arrival` timestamp NULL DEFAULT NULL,
  `actual_departure` timestamp NULL DEFAULT NULL,
  `actual_arrival` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `destination_facility_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `origin_facility_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `order_number` (`order_number`),
  KEY `fk_transport_orders_created_by` (`created_by`),
  KEY `idx_transport_orders_shipment` (`shipment_id`),
  KEY `idx_transport_orders_status` (`status`),
  KEY `idx_transport_orders_assigned_vehicle` (`assigned_vehicle_id`),
  KEY `idx_transport_orders_assigned_driver` (`assigned_driver_id`),
  KEY `idx_transport_orders_planned_departure` (`planned_departure`),
  KEY `IX_transport_orders_destination_facility_id` (`destination_facility_id`),
  KEY `IX_transport_orders_origin_facility_id` (`origin_facility_id`),
  CONSTRAINT `fk_transport_orders_assigned_driver` FOREIGN KEY (`assigned_driver_id`) REFERENCES `employees` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_transport_orders_assigned_vehicle` FOREIGN KEY (`assigned_vehicle_id`) REFERENCES `vehicles` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_transport_orders_created_by` FOREIGN KEY (`created_by`) REFERENCES `employees` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_transport_orders_destination_facility` FOREIGN KEY (`destination_facility_id`) REFERENCES `facilities` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_transport_orders_origin_facility` FOREIGN KEY (`origin_facility_id`) REFERENCES `facilities` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_transport_orders_shipment` FOREIGN KEY (`shipment_id`) REFERENCES `shipments` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transport_orders`
--

LOCK TABLES `transport_orders` WRITE;
/*!40000 ALTER TABLE `transport_orders` DISABLE KEYS */;
INSERT INTO `transport_orders` VALUES ('07ba93cd-c10e-435e-bc6e-42d1dcf88c49','TO-20260902155817-A231','83500430-9554-4cd2-b3aa-dbf7a7cafc21',5,2.500,0.009,'Handle with care','planned','a0f79736-a5ed-11f1-92a0-a0ad9f192341',NULL,NULL,'2026-09-03 01:00:00','2026-09-03 04:00:00',NULL,NULL,'2026-09-02 08:58:17','2026-09-04 11:37:44','297466af-a5f7-11f1-92a0-a0ad9f192341','a0f6b3d5-a5ed-11f1-92a0-a0ad9f192341'),('1c753a3f-4616-43cd-975d-0aebd00449fd','TO-20260904112131-300D','66ccf164-50e2-4581-afc2-2642ef7eb001',5,3.000,1.000,NULL,'planned','a0f79736-a5ed-11f1-92a0-a0ad9f192341',NULL,NULL,'2026-09-04 11:20:00','2026-09-04 11:20:00',NULL,NULL,'2026-09-04 04:21:31','2026-09-04 11:21:31','297466af-a5f7-11f1-92a0-a0ad9f192341','a0f6b3d5-a5ed-11f1-92a0-a0ad9f192341'),('2d024916-482e-46a9-96f2-78b4f9f93cf0','TO-20260904113157-44AF','bb884268-7b06-44e8-888d-9a56621c509c',5,41.000,21.000,NULL,'planned','a0f79736-a5ed-11f1-92a0-a0ad9f192341',NULL,NULL,NULL,NULL,NULL,NULL,'2026-09-04 04:31:58','2026-09-04 11:31:57','29746bcc-a5f7-11f1-92a0-a0ad9f192341','a0f6b3d5-a5ed-11f1-92a0-a0ad9f192341'),('50a2aab5-f12f-4829-ad1b-a76250f0f835','TO-20260904113125-44C3','a1031bb7-a5ed-11f1-92a0-a0ad9f192341',5,123.000,123.000,NULL,'planned','a0f79736-a5ed-11f1-92a0-a0ad9f192341',NULL,NULL,'2026-09-04 11:31:00','2026-09-04 11:31:00',NULL,NULL,'2026-09-04 04:31:25','2026-09-04 11:31:25','29742da6-a5f7-11f1-92a0-a0ad9f192341','a0f6b456-a5ed-11f1-92a0-a0ad9f192341'),('5e2f0e1f-f045-4674-9d57-2f267a1ca12a','TO-20260904101352-0CF4','4265da9f-6e27-4ca1-8121-253bfac77344',5,5.000,9.000,NULL,'planned','a0f79736-a5ed-11f1-92a0-a0ad9f192341',NULL,NULL,'2026-09-04 10:13:00','2026-09-04 10:13:00',NULL,NULL,'2026-09-04 03:13:53','2026-09-04 10:13:52',NULL,NULL),('6d83f047-6166-4a53-9b02-e25288cf7ca7','TO-20260904113402-E28D','a102f87e-a5ed-11f1-92a0-a0ad9f192341',5,123.000,42.000,NULL,'planned','a0f79736-a5ed-11f1-92a0-a0ad9f192341',NULL,NULL,'2026-09-04 11:33:00','2026-09-04 11:33:00',NULL,NULL,'2026-09-04 04:34:02','2026-09-04 11:34:02','29746bcc-a5f7-11f1-92a0-a0ad9f192341','297466af-a5f7-11f1-92a0-a0ad9f192341'),('79ee802b-6f85-4f4d-a3b2-6f15e1e0cff6','TO-20260904115551-26BC','b767a521-1b8f-493d-9d61-7eac9a8ca424',5,11.000,12.000,NULL,'planned','a0f79736-a5ed-11f1-92a0-a0ad9f192341',NULL,NULL,'2026-09-04 11:55:00','2026-09-04 11:55:00',NULL,NULL,'2026-09-04 04:55:52','2026-09-04 11:55:51','29742da6-a5f7-11f1-92a0-a0ad9f192341','297466af-a5f7-11f1-92a0-a0ad9f192341'),('9329f0de-eb8d-4d86-8264-a9e51860d2a4','TO-20260904112648-EACD','2b01a589-3226-402a-8e32-136b6d560f5a',5,6.000,12.000,'mkk','planned','a0f79736-a5ed-11f1-92a0-a0ad9f192341',NULL,NULL,'2026-09-04 11:26:00','2026-09-04 11:26:00',NULL,NULL,'2026-09-04 04:26:49','2026-09-04 11:26:48','29742da6-a5f7-11f1-92a0-a0ad9f192341','297466af-a5f7-11f1-92a0-a0ad9f192341'),('ab6b6827-2d40-4097-9c7f-b71e354dfdb8','TO-20260904062840-D190','a10313b0-a5ed-11f1-92a0-a0ad9f192341',5,9.000,NULL,NULL,'planned','a0f79736-a5ed-11f1-92a0-a0ad9f192341',NULL,NULL,NULL,NULL,NULL,NULL,'2026-09-03 23:28:41','2026-09-04 06:28:40',NULL,NULL),('dcb757ae-32e7-454b-accf-e118d49c40c7','TO-20260904201217-70CF','5bda8f75-181b-4f6b-b477-74d909612b36',1,5.000,12.000,NULL,'planned','a0f79736-a5ed-11f1-92a0-a0ad9f192341',NULL,NULL,'2026-09-04 20:12:00','2026-09-04 20:12:00',NULL,NULL,'2026-09-04 13:12:17','2026-09-04 20:13:29','29742da6-a5f7-11f1-92a0-a0ad9f192341','297466af-a5f7-11f1-92a0-a0ad9f192341');
/*!40000 ALTER TABLE `transport_orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_roles`
--

DROP TABLE IF EXISTS `user_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_roles` (
  `id` char(36) NOT NULL DEFAULT (uuid()),
  `user_id` char(36) NOT NULL,
  `role_id` char(36) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_user_role` (`user_id`,`role_id`),
  UNIQUE KEY `idx_unique_user_role` (`user_id`,`role_id`),
  KEY `fk_user_roles_role` (`role_id`),
  CONSTRAINT `fk_user_roles_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_user_roles_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_roles`
--

LOCK TABLES `user_roles` WRITE;
/*!40000 ALTER TABLE `user_roles` DISABLE KEYS */;
INSERT INTO `user_roles` VALUES ('0a92e82d-c2a9-4a00-8b6d-17d4611b2b19','517b40e8-0346-40f2-b96d-085dbe61ff69','a0fbe0c0-a5ed-11f1-92a0-a0ad9f192341','2026-09-03 20:24:07'),('a0fc8f69-a5ed-11f1-92a0-a0ad9f192341','a0f338e8-a5ed-11f1-92a0-a0ad9f192341','a0fbdd7f-a5ed-11f1-92a0-a0ad9f192341','2026-09-01 10:12:25'),('a0fc96d6-a5ed-11f1-92a0-a0ad9f192341','a0f33fb5-a5ed-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','2026-09-01 10:12:25'),('a0fc9927-a5ed-11f1-92a0-a0ad9f192341','a0f3428e-a5ed-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','2026-09-01 10:12:25'),('a0fc9aca-a5ed-11f1-92a0-a0ad9f192341','a0f3438d-a5ed-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','2026-09-01 10:12:25'),('a0fc9c16-a5ed-11f1-92a0-a0ad9f192341','a0f345e8-a5ed-11f1-92a0-a0ad9f192341','a0fbe026-a5ed-11f1-92a0-a0ad9f192341','2026-09-01 10:12:25'),('a0fc9d7d-a5ed-11f1-92a0-a0ad9f192341','a0f34105-a5ed-11f1-92a0-a0ad9f192341','a0fbe0c0-a5ed-11f1-92a0-a0ad9f192341','2026-09-01 10:12:25'),('a0fc9ec9-a5ed-11f1-92a0-a0ad9f192341','a0f34448-a5ed-11f1-92a0-a0ad9f192341','a0fbe17a-a5ed-11f1-92a0-a0ad9f192341','2026-09-01 10:12:25'),('a0fca0c3-a5ed-11f1-92a0-a0ad9f192341','a0f346ce-a5ed-11f1-92a0-a0ad9f192341','a0fbe11e-a5ed-11f1-92a0-a0ad9f192341','2026-09-01 10:12:25'),('da2084ef-3e94-456a-a5c2-1d5fd3a03f5e','3e761529-e20f-4184-8612-69c4e6cbf749','a0fbe0c0-a5ed-11f1-92a0-a0ad9f192341','2026-09-03 21:31:46');
/*!40000 ALTER TABLE `user_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` char(36) NOT NULL DEFAULT (uuid()),
  `username` varchar(50) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `password_hash` varchar(255) NOT NULL,
  `mfa_enabled` tinyint(1) DEFAULT '0',
  `mfa_secret` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `last_login` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `idx_unique_username` (`username`),
  KEY `idx_users_email` (`email`),
  KEY `idx_users_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES ('3e761529-e20f-4184-8612-69c4e6cbf749','long2003','ds@gmail.com','0987654321','$2a$11$RyCTmqidmB9n9BSkPjnpFOjIC5E9.cT1pYUAhZmcfsbMzCz47w.UO',0,NULL,1,'2026-09-03 21:31:54','2026-09-03 21:31:46','2026-09-04 04:31:54'),('517b40e8-0346-40f2-b96d-085dbe61ff69','long','long152003@gmail.com','0987654321','$2a$11$61KO7CLwIc8WM930uhPnDuAvIEsBu2XevSjBf45pm8YlQvUpJr1Aq',0,NULL,1,'2026-09-03 22:05:07','2026-09-03 20:24:07','2026-09-04 05:05:07'),('a0f338e8-a5ed-11f1-92a0-a0ad9f192341','admin','admin@elms.com','9876543210','$2a$11$EQPgCEs7kvisAluKlwcmOugU7NeUvxVrPwFvt0LOy7bceGdxMQa2S',0,NULL,1,'2026-09-04 10:58:10','2026-09-01 10:12:25','2026-09-04 17:58:10'),('a0f33fb5-a5ed-11f1-92a0-a0ad9f192341','employee','employee@elms.com','9876543211','$2a$11$u5OW/VulwjeIpV6x.yTb8ecxESrVLAIMyPyJ4IOeKpqsfsX5on6UC',0,NULL,1,'2026-09-04 14:19:52','2026-09-01 10:12:25','2026-09-04 21:19:51'),('a0f34105-a5ed-11f1-92a0-a0ad9f192341','customer','customer@elms.com','9876543212','$2a$11$HdcX.Tk1fvvV53J4tE2jsuxz4fYE/2807mjhHGz4TzIRYmpPaBXbm',0,NULL,1,'2026-09-04 13:09:37','2026-09-01 10:12:25','2026-09-04 20:09:37'),('a0f341c4-a5ed-11f1-92a0-a0ad9f192341','driver','driver@elms.com','9876543212','$2a$11$HdcX.Tk1fvvV53J4tE2jsuxz4fYE/2807mjhHGz4TzIRYmpPaBXbm',0,NULL,1,'2026-09-01 10:12:25','2026-09-01 10:12:25','2026-09-01 10:12:25'),('a0f3428e-a5ed-11f1-92a0-a0ad9f192341','john.doe','john.doe@elms.com','9876543213','$2a$11$K7x5nXxY7xZ8xW9xY6xZ8xW9xY6xZ8xW9xY6xZ8xW9xY6xZ8xW9xY6xZ8x',0,NULL,1,'2026-09-01 10:12:25','2026-09-01 10:12:25','2026-09-01 10:12:25'),('a0f3438d-a5ed-11f1-92a0-a0ad9f192341','jane.smith','jane.smith@elms.com','9876543214','$2a$11$K7x5nXxY7xZ8xW9xY6xZ8xW9xY6xZ8xW9xY6xZ8xW9xY6xZ8xW9xY6xZ8x',0,NULL,1,'2026-09-01 10:12:25','2026-09-01 10:12:25','2026-09-01 10:12:25'),('a0f34448-a5ed-11f1-92a0-a0ad9f192341','mike.wilson','mike.wilson@elms.com','9876543215','$2a$11$K7x5nXxY7xZ8xW9xY6xZ8xW9xY6xZ8xW9xY6xZ8xW9xY6xZ8xW9xY6xZ8x',0,NULL,1,'2026-09-01 10:12:25','2026-09-01 10:12:25','2026-09-01 10:12:25'),('a0f345e8-a5ed-11f1-92a0-a0ad9f192341','sarah.parker','sarah.parker@elms.com','9876543216','$2a$11$K7x5nXxY7xZ8xW9xY6xZ8xW9xY6xZ8xW9xY6xZ8xW9xY6xZ8xW9xY6xZ8x',0,NULL,1,'2026-09-01 10:12:25','2026-09-01 10:12:25','2026-09-01 10:12:25'),('a0f346ce-a5ed-11f1-92a0-a0ad9f192341','robert.taylor','robert.taylor@elms.com','9876543217','$2a$11$K7x5nXxY7xZ8xW9xY6xZ8xW9xY6xZ8xW9xY6xZ8xW9xY6xZ8xW9xY6xZ8x',0,NULL,1,'2026-09-01 10:12:25','2026-09-01 10:12:25','2026-09-01 10:12:25');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vehicle_fuel_logs`
--

DROP TABLE IF EXISTS `vehicle_fuel_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vehicle_fuel_logs` (
  `id` char(36) NOT NULL DEFAULT (uuid()),
  `vehicle_id` char(36) NOT NULL,
  `fuel_date` date NOT NULL,
  `fuel_type` varchar(50) DEFAULT NULL,
  `quantity` decimal(10,2) DEFAULT NULL,
  `cost` decimal(15,2) DEFAULT NULL,
  `odometer_reading` decimal(10,2) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_vehicle_fuel_logs_vehicle` (`vehicle_id`),
  CONSTRAINT `fk_vehicle_fuel_logs_vehicle` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vehicle_fuel_logs`
--

LOCK TABLES `vehicle_fuel_logs` WRITE;
/*!40000 ALTER TABLE `vehicle_fuel_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `vehicle_fuel_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vehicle_gps`
--

DROP TABLE IF EXISTS `vehicle_gps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vehicle_gps` (
  `id` char(36) NOT NULL DEFAULT (uuid()),
  `vehicle_id` char(36) NOT NULL,
  `recorded_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  `speed` decimal(8,2) DEFAULT NULL,
  `heading` decimal(5,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_vehicle_gps_vehicle` (`vehicle_id`),
  KEY `idx_vehicle_gps_recorded_at` (`recorded_at`),
  CONSTRAINT `fk_vehicle_gps_vehicle` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vehicle_gps`
--

LOCK TABLES `vehicle_gps` WRITE;
/*!40000 ALTER TABLE `vehicle_gps` DISABLE KEYS */;
/*!40000 ALTER TABLE `vehicle_gps` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vehicle_maintenance`
--

DROP TABLE IF EXISTS `vehicle_maintenance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vehicle_maintenance` (
  `id` char(36) NOT NULL DEFAULT (uuid()),
  `vehicle_id` char(36) NOT NULL,
  `maintenance_date` date NOT NULL,
  `description` text,
  `cost` decimal(15,2) DEFAULT NULL,
  `performed_by` char(36) DEFAULT NULL,
  `next_maintenance_date` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_vehicle_maintenance_vehicle` (`vehicle_id`),
  CONSTRAINT `fk_vehicle_maintenance_vehicle` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vehicle_maintenance`
--

LOCK TABLES `vehicle_maintenance` WRITE;
/*!40000 ALTER TABLE `vehicle_maintenance` DISABLE KEYS */;
/*!40000 ALTER TABLE `vehicle_maintenance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vehicles`
--

DROP TABLE IF EXISTS `vehicles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vehicles` (
  `id` char(36) NOT NULL DEFAULT (uuid()),
  `vehicle_number` varchar(50) NOT NULL,
  `vehicle_type` varchar(50) NOT NULL,
  `brand` varchar(50) DEFAULT NULL,
  `model` varchar(50) DEFAULT NULL,
  `year` int DEFAULT NULL,
  `capacity` decimal(15,2) NOT NULL,
  `status` varchar(50) DEFAULT 'Available',
  `registration_number` varchar(50) DEFAULT NULL,
  `insurance_expiry` date DEFAULT NULL,
  `maintenance_due` date DEFAULT NULL,
  `assigned_driver_id` char(36) DEFAULT NULL,
  `fuel_type` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `vehicle_number` (`vehicle_number`),
  UNIQUE KEY `registration_number` (`registration_number`),
  KEY `idx_vehicles_assigned_driver` (`assigned_driver_id`),
  KEY `idx_vehicles_status` (`status`),
  CONSTRAINT `fk_vehicles_assigned_driver` FOREIGN KEY (`assigned_driver_id`) REFERENCES `employees` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vehicles`
--

LOCK TABLES `vehicles` WRITE;
/*!40000 ALTER TABLE `vehicles` DISABLE KEYS */;
INSERT INTO `vehicles` VALUES ('a101f8d7-a5ed-11f1-92a0-a0ad9f192341','MH-01-AB-1234','Truck','Tata','Tata 407',2022,2500.00,'Available','MH01AB1234','2025-12-31','2024-12-31',NULL,'Diesel','2026-09-01 10:12:25','2026-09-01 10:12:25'),('a101fc21-a5ed-11f1-92a0-a0ad9f192341','MH-02-CD-5678','Van','Maruti Suzuki','Eeco',2023,800.00,'Available','MH02CD5678','2025-11-30','2024-11-30',NULL,'Petrol','2026-09-01 10:12:25','2026-09-01 10:12:25'),('a101fcee-a5ed-11f1-92a0-a0ad9f192341','DL-01-EF-9012','Truck','Ashok Leyland','Dost',2022,1200.00,'In Route','DL01EF9012','2025-10-31','2024-10-31',NULL,'Diesel','2026-09-01 10:12:25','2026-09-01 10:12:25'),('a101fd80-a5ed-11f1-92a0-a0ad9f192341','MH-03-GH-3456','Van','Ford','Transit',2023,1000.00,'Available','MH03GH3456','2025-09-30','2024-09-30',NULL,'Diesel','2026-09-01 10:12:25','2026-09-01 10:12:25'),('a101fe19-a5ed-11f1-92a0-a0ad9f192341','MH-04-IJ-7890','Truck','Eicher','Pro 3015',2022,3500.00,'Available','MH04IJ7890','2025-08-31','2024-08-31',NULL,'Diesel','2026-09-01 10:12:25','2026-09-01 10:12:25'),('a101feaa-a5ed-11f1-92a0-a0ad9f192341','DL-02-KL-1234','Van','Tata','Ace',2023,700.00,'Available','DL02KL1234','2025-07-31','2024-07-31',NULL,'Petrol','2026-09-01 10:12:25','2026-09-01 10:12:25');
/*!40000 ALTER TABLE `vehicles` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-09-05  4:48:23
