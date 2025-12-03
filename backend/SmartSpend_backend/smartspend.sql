CREATE DATABASE  IF NOT EXISTS `smartspend` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `smartspend`;
-- MySQL dump 10.13  Distrib 8.0.44, for Win64 (x86_64)
--
-- Host: localhost    Database: smartspend
-- ------------------------------------------------------
-- Server version	8.0.44

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
-- Table structure for table `accumulating`
--

DROP TABLE IF EXISTS `accumulating`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `accumulating` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `month_utc` date NOT NULL,
  `leftover_cents` bigint NOT NULL,
  `income_cents` bigint NOT NULL,
  `expense_cents` bigint NOT NULL,
  `note` varchar(200) DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  KEY `fk_accumulating_user` (`user_id`),
  CONSTRAINT `fk_acc_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_accumulating_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accumulating`
--

LOCK TABLES `accumulating` WRITE;
/*!40000 ALTER TABLE `accumulating` DISABLE KEYS */;
/*!40000 ALTER TABLE `accumulating` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `achievement`
--

DROP TABLE IF EXISTS `achievement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `achievement` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(64) NOT NULL,
  `name` varchar(120) NOT NULL,
  `description` text,
  `icon` varchar(80) DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `ux_achievement_code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `achievement`
--

LOCK TABLES `achievement` WRITE;
/*!40000 ALTER TABLE `achievement` DISABLE KEYS */;
INSERT INTO `achievement` VALUES (1,'FIRST_EXPENSE','First Expense Logged','Recorded your first expense.','sparkles','2025-11-11 09:32:31.284','2025-11-11 09:32:31.284'),(2,'SEVEN_DAYS_NO_GUILT','7 Guilt-Free Days','No “Guilt” spending for 7 days.','shield','2025-11-11 09:32:31.284','2025-11-11 09:32:31.284'),(3,'BILL_STREAK_3','On-Time Bills ×3','Paid 3 bills on time in a row.','calendar','2025-11-11 09:32:31.284','2025-11-11 09:32:31.284'),(4,'POWER_SAVE_ONCE','Power-Save Activated','Tried Power-Save mode once.','zap','2025-11-11 09:32:31.284','2025-11-11 09:32:31.284');
/*!40000 ALTER TABLE `achievement` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `audit_log`
--

DROP TABLE IF EXISTS `audit_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `audit_log` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `table_name` varchar(64) NOT NULL,
  `row_pk` varchar(64) NOT NULL,
  `action` enum('insert','update','delete') NOT NULL,
  `changed_fields` json DEFAULT NULL,
  `occurred_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `actor_user_id` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_audit_user` (`actor_user_id`),
  CONSTRAINT `fk_audit_user` FOREIGN KEY (`actor_user_id`) REFERENCES `user` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit_log`
--

LOCK TABLES `audit_log` WRITE;
/*!40000 ALTER TABLE `audit_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `audit_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bill`
--

DROP TABLE IF EXISTS `bill`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bill` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `name` varchar(120) NOT NULL,
  `amount_cents` bigint DEFAULT NULL,
  `recurrence_rule` enum('weekly','biweekly','monthly') NOT NULL,
  `status` enum('active','paused','ended') NOT NULL DEFAULT 'active',
  `next_due_date` date DEFAULT NULL,
  `paused_at` datetime(3) DEFAULT NULL,
  `resumed_at` datetime(3) DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  `deleted_at` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ix_bill_user` (`user_id`),
  KEY `ix_bill_paused_at` (`paused_at`),
  KEY `ix_bill_resumed_at` (`resumed_at`),
  CONSTRAINT `fk_bill_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bill`
--

LOCK TABLES `bill` WRITE;
/*!40000 ALTER TABLE `bill` DISABLE KEYS */;
INSERT INTO `bill` VALUES (1,1,'Rent',24900,'monthly','active','2026-01-05','2025-11-10 23:20:59.317','2025-11-10 23:21:40.069','2025-11-09 22:11:56.282','2025-11-10 18:21:56.587',NULL),(2,1,'spectrum',3000,'monthly','active','2026-01-10',NULL,NULL,'2025-11-10 15:46:55.237','2025-11-11 17:26:03.532',NULL),(3,1,'Ohio Eddison',13000,'monthly','active','2025-12-11',NULL,NULL,'2025-11-10 19:13:54.585','2025-11-10 19:13:54.585',NULL),(4,1,'Raid',4000,'monthly','active','2025-12-12','2025-11-11 23:22:31.474','2025-11-11 23:29:34.795','2025-11-11 18:15:28.976','2025-11-11 18:31:26.435',NULL),(5,1,'coffee',1000,'weekly','active','2025-11-26','2025-11-16 20:12:57.083','2025-11-16 20:13:15.004','2025-11-11 18:19:30.207','2025-11-18 15:13:04.057',NULL),(6,1,'Movie',3000,'biweekly','active','2025-11-26',NULL,NULL,'2025-11-11 18:21:38.270','2025-11-16 13:00:13.012',NULL),(8,1,'part',12300,'weekly','active','2025-11-27',NULL,NULL,'2025-11-11 18:55:20.435','2025-11-18 19:27:10.271',NULL),(9,2,'Rent',18000,'monthly','active','2025-12-01',NULL,NULL,'2025-11-16 17:34:19.008','2025-11-16 17:34:19.008',NULL),(10,3,'Rent',17000,'monthly','active','2025-12-01',NULL,NULL,'2025-11-17 12:21:39.450','2025-11-17 12:21:39.450',NULL),(11,4,'Rent',19500,'monthly','active','2025-12-01',NULL,NULL,'2025-11-17 16:06:04.430','2025-11-17 16:06:04.430',NULL),(12,4,'Phone',3000,'monthly','active','2025-12-01',NULL,NULL,'2025-11-17 16:06:04.433','2025-11-17 16:06:04.433',NULL),(13,4,'Internet',1400,'monthly','active','2025-12-07',NULL,NULL,'2025-11-17 16:06:04.435','2025-11-17 16:06:04.435',NULL),(14,5,'Rent',19500,'monthly','active','2025-12-01',NULL,NULL,'2025-11-17 16:36:36.117','2025-11-17 16:36:36.117',NULL),(15,6,'Rent',23000,'monthly','active','2025-12-01',NULL,NULL,'2025-11-17 16:47:01.134','2025-11-17 16:47:01.134',NULL),(16,6,'ohio edision',13000,'monthly','active','2025-11-20',NULL,NULL,'2025-11-17 21:18:07.148','2025-11-17 21:18:07.148',NULL),(17,1,'car insurance',15000,'monthly','active','2025-12-22','2025-11-20 03:25:30.116','2025-11-20 03:25:32.437','2025-11-18 19:26:35.593','2025-11-25 18:41:32.316',NULL),(18,7,'Rent',30000,'monthly','active','2025-12-05',NULL,NULL,'2025-11-19 22:31:55.291','2025-11-19 22:31:55.291',NULL),(19,7,'Phone',4000,'monthly','active','2025-12-03',NULL,NULL,'2025-11-19 22:31:55.296','2025-11-19 22:31:55.296',NULL),(20,7,'Internet',2000,'monthly','active','2025-12-02',NULL,NULL,'2025-11-19 22:31:55.300','2025-11-19 22:31:55.300',NULL),(21,7,'Uber',15000,'monthly','active','2025-12-10',NULL,NULL,'2025-11-19 22:31:55.303','2025-11-19 22:31:55.303',NULL),(22,9,'Rent',38000,'monthly','active','2025-12-01',NULL,NULL,'2025-11-25 18:39:41.341','2025-11-25 18:39:41.341',NULL),(23,9,'Phone',3000,'monthly','active','2025-12-07',NULL,NULL,'2025-11-25 18:39:41.352','2025-11-25 18:39:41.352',NULL);
/*!40000 ALTER TABLE `bill` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bill_occurrence`
--

DROP TABLE IF EXISTS `bill_occurrence`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bill_occurrence` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `bill_id` bigint unsigned NOT NULL,
  `due_date` date NOT NULL,
  `status` enum('due','paid','skipped') NOT NULL DEFAULT 'due',
  `paid_at` datetime(3) DEFAULT NULL,
  `auto_txn_id` bigint unsigned DEFAULT NULL,
  `bill_payment_id` bigint unsigned DEFAULT NULL,
  `generated_for_period_id` bigint unsigned DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  KEY `fk_bill_occurrence_bill` (`bill_id`),
  KEY `fk_bill_occurrence_auto_txn` (`auto_txn_id`),
  KEY `fk_bill_occurrence_generated_period` (`generated_for_period_id`),
  CONSTRAINT `fk_bill_occurrence_auto_txn` FOREIGN KEY (`auto_txn_id`) REFERENCES `transaction` (`id`),
  CONSTRAINT `fk_bill_occurrence_bill` FOREIGN KEY (`bill_id`) REFERENCES `bill` (`id`),
  CONSTRAINT `fk_bill_occurrence_generated_period` FOREIGN KEY (`generated_for_period_id`) REFERENCES `monthly_period` (`id`),
  CONSTRAINT `fk_bocc_bill` FOREIGN KEY (`bill_id`) REFERENCES `bill` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bill_occurrence`
--

LOCK TABLES `bill_occurrence` WRITE;
/*!40000 ALTER TABLE `bill_occurrence` DISABLE KEYS */;
INSERT INTO `bill_occurrence` VALUES (1,1,'2025-12-05','paid','2025-11-10 23:21:56.523',3,1,NULL,'2025-11-10 18:21:56.572'),(2,2,'2025-12-10','paid','2025-11-11 22:26:03.491',4,2,NULL,'2025-11-11 17:26:03.525'),(3,5,'2025-11-11','paid','2025-11-11 23:19:52.025',7,3,NULL,'2025-11-11 18:19:52.032'),(4,4,'2025-11-12','paid','2025-11-11 23:31:26.423',8,4,NULL,'2025-11-11 18:31:26.429'),(5,8,'2025-11-13','paid','2025-11-11 23:55:30.204',9,5,NULL,'2025-11-11 18:55:30.207'),(6,6,'2025-11-12','paid','2025-11-16 18:00:12.981',10,6,NULL,'2025-11-16 13:00:13.005'),(7,5,'2025-11-19','paid','2025-11-18 20:13:03.950',18,7,NULL,'2025-11-18 15:13:04.009'),(8,8,'2025-11-20','paid','2025-11-19 00:27:10.226',20,8,NULL,'2025-11-18 19:27:10.250'),(9,17,'2025-11-22','paid','2025-11-25 23:41:32.243',27,9,NULL,'2025-11-25 18:41:32.280');
/*!40000 ALTER TABLE `bill_occurrence` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bill_payment`
--

DROP TABLE IF EXISTS `bill_payment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bill_payment` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `bill_id` bigint unsigned NOT NULL,
  `bill_occurrence_id` bigint unsigned NOT NULL,
  `amount_cents` bigint NOT NULL,
  `paid_at` datetime(3) NOT NULL,
  `status` enum('partial','complete','refunded') NOT NULL DEFAULT 'complete',
  `transaction_id` bigint unsigned DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  KEY `fk_bill_payment_bill` (`bill_id`),
  KEY `fk_bill_payment_occurrence` (`bill_occurrence_id`),
  KEY `fk_bill_payment_transaction` (`transaction_id`),
  CONSTRAINT `fk_bill_payment_bill` FOREIGN KEY (`bill_id`) REFERENCES `bill` (`id`),
  CONSTRAINT `fk_bill_payment_occurrence` FOREIGN KEY (`bill_occurrence_id`) REFERENCES `bill_occurrence` (`id`),
  CONSTRAINT `fk_bill_payment_transaction` FOREIGN KEY (`transaction_id`) REFERENCES `transaction` (`id`),
  CONSTRAINT `fk_bpay_bill` FOREIGN KEY (`bill_id`) REFERENCES `bill` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_bpay_occ` FOREIGN KEY (`bill_occurrence_id`) REFERENCES `bill_occurrence` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bill_payment`
--

LOCK TABLES `bill_payment` WRITE;
/*!40000 ALTER TABLE `bill_payment` DISABLE KEYS */;
INSERT INTO `bill_payment` VALUES (1,1,1,24900,'2025-11-10 23:21:56.523','complete',3,'2025-11-10 18:21:56.581','2025-11-15 20:32:25.607'),(2,2,2,3000,'2025-11-11 22:26:03.491','complete',4,'2025-11-11 17:26:03.530','2025-11-15 20:32:25.607'),(3,5,3,1000,'2025-11-11 23:19:52.025','complete',7,'2025-11-11 18:19:52.035','2025-11-15 20:32:25.607'),(4,4,4,4000,'2025-11-11 23:31:26.423','complete',8,'2025-11-11 18:31:26.433','2025-11-15 20:32:25.607'),(5,8,5,12300,'2025-11-11 23:55:30.204','complete',9,'2025-11-11 18:55:30.209','2025-11-15 20:32:25.607'),(6,6,6,3000,'2025-11-16 18:00:12.981','complete',10,'2025-11-16 13:00:13.011','2025-11-16 13:23:37.286'),(7,5,7,1000,'2025-11-18 20:13:03.950','complete',18,'2025-11-18 15:13:04.038','2025-11-18 15:13:04.046'),(8,8,8,12300,'2025-11-19 00:27:10.226','complete',20,'2025-11-18 19:27:10.261','2025-11-18 19:27:10.265'),(9,17,9,15000,'2025-11-25 23:41:32.243','complete',27,'2025-11-25 18:41:32.294','2025-11-25 18:41:32.307');
/*!40000 ALTER TABLE `bill_payment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `budget_pref`
--

DROP TABLE IF EXISTS `budget_pref`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `budget_pref` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `pay_cadence` enum('weekly','biweekly','monthly') DEFAULT NULL,
  `pay_anchor_day_of_month` tinyint unsigned DEFAULT NULL,
  `pay_anchor_weekday` enum('sunday','monday','tuesday','wednesday','thursday','friday','saturday') DEFAULT NULL,
  `biweekly_anchor_date` date DEFAULT NULL,
  `expected_amount_cents` bigint DEFAULT NULL,
  `expected_amount_cadence` enum('weekly','biweekly','monthly') DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `ux_budget_pref_user` (`user_id`),
  CONSTRAINT `fk_budget_pref_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  CONSTRAINT `fk_budget_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `budget_pref`
--

LOCK TABLES `budget_pref` WRITE;
/*!40000 ALTER TABLE `budget_pref` DISABLE KEYS */;
INSERT INTO `budget_pref` VALUES (1,1,'weekly',NULL,'monday',NULL,1234500,'weekly','2025-11-09 22:11:41.115','2025-11-17 16:30:55.052'),(2,2,'weekly',NULL,'tuesday',NULL,50000,'weekly','2025-11-16 17:34:06.027','2025-11-17 16:30:55.052'),(3,3,'weekly',NULL,'monday',NULL,123400,'weekly','2025-11-17 12:21:27.140','2025-11-17 16:30:55.052'),(4,4,'biweekly',10,NULL,'2025-12-10',1234500,'biweekly','2025-11-17 16:05:29.001','2025-11-17 16:30:55.052'),(5,5,'weekly',NULL,'tuesday',NULL,1234500,'monthly','2025-11-17 16:36:24.276','2025-11-17 16:36:28.000'),(6,6,'biweekly',3,NULL,'2025-12-03',543200,'monthly','2025-11-17 16:46:45.910','2025-11-17 16:46:53.000'),(7,7,'monthly',5,NULL,NULL,700000,'monthly','2025-11-19 22:28:12.321','2025-11-19 22:28:41.000'),(8,9,'monthly',5,NULL,NULL,1200000,'monthly','2025-11-25 18:38:53.947','2025-11-25 18:39:04.000');
/*!40000 ALTER TABLE `budget_pref` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `category` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `name` varchar(80) NOT NULL,
  `parent_id` bigint unsigned DEFAULT NULL,
  `kind` enum('income','expense') NOT NULL,
  `is_default` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  `deleted_at` datetime(3) DEFAULT NULL,
  `created_by` bigint unsigned DEFAULT NULL,
  `updated_by` bigint unsigned DEFAULT NULL,
  `deleted_by` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ux_cat_user_name` (`user_id`,`name`),
  KEY `fk_category_parent` (`parent_id`),
  KEY `fk_category_created_by` (`created_by`),
  KEY `fk_category_updated_by` (`updated_by`),
  KEY `fk_category_deleted_by` (`deleted_by`),
  CONSTRAINT `fk_cat_parent` FOREIGN KEY (`parent_id`) REFERENCES `category` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_cat_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_category_created_by` FOREIGN KEY (`created_by`) REFERENCES `user` (`id`),
  CONSTRAINT `fk_category_deleted_by` FOREIGN KEY (`deleted_by`) REFERENCES `user` (`id`),
  CONSTRAINT `fk_category_parent` FOREIGN KEY (`parent_id`) REFERENCES `category` (`id`),
  CONSTRAINT `fk_category_updated_by` FOREIGN KEY (`updated_by`) REFERENCES `user` (`id`),
  CONSTRAINT `fk_category_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=89 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category`
--

LOCK TABLES `category` WRITE;
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
INSERT INTO `category` VALUES (1,1,'Salary',NULL,'income',1,'2025-11-09 22:12:03.838','2025-11-09 22:12:03.838',NULL,NULL,NULL,NULL),(2,1,'Bonus',NULL,'income',1,'2025-11-09 22:12:03.838','2025-11-09 22:12:03.838',NULL,NULL,NULL,NULL),(3,1,'Interest',NULL,'income',1,'2025-11-09 22:12:03.838','2025-11-09 22:12:03.838',NULL,NULL,NULL,NULL),(4,1,'Other Income',NULL,'income',1,'2025-11-09 22:12:03.838','2025-11-09 22:12:03.838',NULL,NULL,NULL,NULL),(5,1,'Misc',NULL,'expense',1,'2025-11-09 22:12:03.838','2025-11-09 22:12:03.838',NULL,NULL,NULL,NULL),(6,1,'Food',NULL,'expense',1,'2025-11-09 22:12:03.838','2025-11-09 22:12:03.838',NULL,NULL,NULL,NULL),(7,1,'Rent',NULL,'expense',1,'2025-11-09 22:12:03.838','2025-11-09 22:12:03.838',NULL,NULL,NULL,NULL),(8,1,'Transport',NULL,'expense',1,'2025-11-09 22:12:03.838','2025-11-09 22:12:03.838',NULL,NULL,NULL,NULL),(9,1,'Entertainment',NULL,'expense',1,'2025-11-09 22:12:03.838','2025-11-09 22:12:03.838',NULL,NULL,NULL,NULL),(10,1,'Bills',NULL,'expense',1,'2025-11-09 22:12:03.838','2025-11-09 22:12:03.838',NULL,NULL,NULL,NULL),(11,1,'Health',NULL,'expense',1,'2025-11-09 22:12:03.838','2025-11-09 22:12:03.838',NULL,NULL,NULL,NULL),(12,2,'Salary',NULL,'income',1,'2025-11-16 17:34:22.558','2025-11-16 17:34:22.558',NULL,NULL,NULL,NULL),(13,2,'Bonus',NULL,'income',1,'2025-11-16 17:34:22.558','2025-11-16 17:34:22.558',NULL,NULL,NULL,NULL),(14,2,'Interest',NULL,'income',1,'2025-11-16 17:34:22.558','2025-11-16 17:34:22.558',NULL,NULL,NULL,NULL),(15,2,'Other Income',NULL,'income',1,'2025-11-16 17:34:22.558','2025-11-16 17:34:22.558',NULL,NULL,NULL,NULL),(16,2,'Misc',NULL,'expense',1,'2025-11-16 17:34:22.558','2025-11-16 17:34:22.558',NULL,NULL,NULL,NULL),(17,2,'Food',NULL,'expense',1,'2025-11-16 17:34:22.558','2025-11-16 17:34:22.558',NULL,NULL,NULL,NULL),(18,2,'Rent',NULL,'expense',1,'2025-11-16 17:34:22.558','2025-11-16 17:34:22.558',NULL,NULL,NULL,NULL),(19,2,'Transport',NULL,'expense',1,'2025-11-16 17:34:22.558','2025-11-16 17:34:22.558',NULL,NULL,NULL,NULL),(20,2,'Entertainment',NULL,'expense',1,'2025-11-16 17:34:22.558','2025-11-16 17:34:22.558',NULL,NULL,NULL,NULL),(21,2,'Bills',NULL,'expense',1,'2025-11-16 17:34:22.558','2025-11-16 17:34:22.558',NULL,NULL,NULL,NULL),(22,2,'Health',NULL,'expense',1,'2025-11-16 17:34:22.558','2025-11-16 17:34:22.558',NULL,NULL,NULL,NULL),(23,3,'Salary',NULL,'income',1,'2025-11-17 12:21:45.279','2025-11-17 12:21:45.279',NULL,NULL,NULL,NULL),(24,3,'Bonus',NULL,'income',1,'2025-11-17 12:21:45.279','2025-11-17 12:21:45.279',NULL,NULL,NULL,NULL),(25,3,'Interest',NULL,'income',1,'2025-11-17 12:21:45.279','2025-11-17 12:21:45.279',NULL,NULL,NULL,NULL),(26,3,'Other Income',NULL,'income',1,'2025-11-17 12:21:45.279','2025-11-17 12:21:45.279',NULL,NULL,NULL,NULL),(27,3,'Misc',NULL,'expense',1,'2025-11-17 12:21:45.279','2025-11-17 12:21:45.279',NULL,NULL,NULL,NULL),(28,3,'Food',NULL,'expense',1,'2025-11-17 12:21:45.279','2025-11-17 12:21:45.279',NULL,NULL,NULL,NULL),(29,3,'Rent',NULL,'expense',1,'2025-11-17 12:21:45.279','2025-11-17 12:21:45.279',NULL,NULL,NULL,NULL),(30,3,'Transport',NULL,'expense',1,'2025-11-17 12:21:45.279','2025-11-17 12:21:45.279',NULL,NULL,NULL,NULL),(31,3,'Entertainment',NULL,'expense',1,'2025-11-17 12:21:45.279','2025-11-17 12:21:45.279',NULL,NULL,NULL,NULL),(32,3,'Bills',NULL,'expense',1,'2025-11-17 12:21:45.279','2025-11-17 12:21:45.279',NULL,NULL,NULL,NULL),(33,3,'Health',NULL,'expense',1,'2025-11-17 12:21:45.279','2025-11-17 12:21:45.279',NULL,NULL,NULL,NULL),(34,4,'Salary',NULL,'income',1,'2025-11-17 16:06:13.766','2025-11-17 16:06:13.766',NULL,NULL,NULL,NULL),(35,4,'Bonus',NULL,'income',1,'2025-11-17 16:06:13.766','2025-11-17 16:06:13.766',NULL,NULL,NULL,NULL),(36,4,'Interest',NULL,'income',1,'2025-11-17 16:06:13.766','2025-11-17 16:06:13.766',NULL,NULL,NULL,NULL),(37,4,'Other Income',NULL,'income',1,'2025-11-17 16:06:13.766','2025-11-17 16:06:13.766',NULL,NULL,NULL,NULL),(38,4,'Misc',NULL,'expense',1,'2025-11-17 16:06:13.766','2025-11-17 16:06:13.766',NULL,NULL,NULL,NULL),(39,4,'Food',NULL,'expense',1,'2025-11-17 16:06:13.766','2025-11-17 16:06:13.766',NULL,NULL,NULL,NULL),(40,4,'Rent',NULL,'expense',1,'2025-11-17 16:06:13.766','2025-11-17 16:06:13.766',NULL,NULL,NULL,NULL),(41,4,'Transport',NULL,'expense',1,'2025-11-17 16:06:13.766','2025-11-17 16:06:13.766',NULL,NULL,NULL,NULL),(42,4,'Entertainment',NULL,'expense',1,'2025-11-17 16:06:13.766','2025-11-17 16:06:13.766',NULL,NULL,NULL,NULL),(43,4,'Bills',NULL,'expense',1,'2025-11-17 16:06:13.766','2025-11-17 16:06:13.766',NULL,NULL,NULL,NULL),(44,4,'Health',NULL,'expense',1,'2025-11-17 16:06:13.766','2025-11-17 16:06:13.766',NULL,NULL,NULL,NULL),(45,5,'Salary',NULL,'income',1,'2025-11-17 16:36:39.388','2025-11-17 16:36:39.388',NULL,NULL,NULL,NULL),(46,5,'Bonus',NULL,'income',1,'2025-11-17 16:36:39.388','2025-11-17 16:36:39.388',NULL,NULL,NULL,NULL),(47,5,'Interest',NULL,'income',1,'2025-11-17 16:36:39.388','2025-11-17 16:36:39.388',NULL,NULL,NULL,NULL),(48,5,'Other Income',NULL,'income',1,'2025-11-17 16:36:39.388','2025-11-17 16:36:39.388',NULL,NULL,NULL,NULL),(49,5,'Misc',NULL,'expense',1,'2025-11-17 16:36:39.388','2025-11-17 16:36:39.388',NULL,NULL,NULL,NULL),(50,5,'Food',NULL,'expense',1,'2025-11-17 16:36:39.388','2025-11-17 16:36:39.388',NULL,NULL,NULL,NULL),(51,5,'Rent',NULL,'expense',1,'2025-11-17 16:36:39.388','2025-11-17 16:36:39.388',NULL,NULL,NULL,NULL),(52,5,'Transport',NULL,'expense',1,'2025-11-17 16:36:39.388','2025-11-17 16:36:39.388',NULL,NULL,NULL,NULL),(53,5,'Entertainment',NULL,'expense',1,'2025-11-17 16:36:39.388','2025-11-17 16:36:39.388',NULL,NULL,NULL,NULL),(54,5,'Bills',NULL,'expense',1,'2025-11-17 16:36:39.388','2025-11-17 16:36:39.388',NULL,NULL,NULL,NULL),(55,5,'Health',NULL,'expense',1,'2025-11-17 16:36:39.388','2025-11-17 16:36:39.388',NULL,NULL,NULL,NULL),(56,6,'Salary',NULL,'income',1,'2025-11-17 16:47:03.879','2025-11-17 16:47:03.879',NULL,NULL,NULL,NULL),(57,6,'Bonus',NULL,'income',1,'2025-11-17 16:47:03.879','2025-11-17 16:47:03.879',NULL,NULL,NULL,NULL),(58,6,'Interest',NULL,'income',1,'2025-11-17 16:47:03.879','2025-11-17 16:47:03.879',NULL,NULL,NULL,NULL),(59,6,'Other Income',NULL,'income',1,'2025-11-17 16:47:03.879','2025-11-17 16:47:03.879',NULL,NULL,NULL,NULL),(60,6,'Misc',NULL,'expense',1,'2025-11-17 16:47:03.879','2025-11-17 16:47:03.879',NULL,NULL,NULL,NULL),(61,6,'Food',NULL,'expense',1,'2025-11-17 16:47:03.879','2025-11-17 16:47:03.879',NULL,NULL,NULL,NULL),(62,6,'Rent',NULL,'expense',1,'2025-11-17 16:47:03.879','2025-11-17 16:47:03.879',NULL,NULL,NULL,NULL),(63,6,'Transport',NULL,'expense',1,'2025-11-17 16:47:03.879','2025-11-17 16:47:03.879',NULL,NULL,NULL,NULL),(64,6,'Entertainment',NULL,'expense',1,'2025-11-17 16:47:03.879','2025-11-17 16:47:03.879',NULL,NULL,NULL,NULL),(65,6,'Bills',NULL,'expense',1,'2025-11-17 16:47:03.879','2025-11-17 16:47:03.879',NULL,NULL,NULL,NULL),(66,6,'Health',NULL,'expense',1,'2025-11-17 16:47:03.879','2025-11-17 16:47:03.879',NULL,NULL,NULL,NULL),(67,7,'Salary',NULL,'income',1,'2025-11-19 22:33:04.401','2025-11-19 22:33:04.401',NULL,NULL,NULL,NULL),(68,7,'Bonus',NULL,'income',1,'2025-11-19 22:33:04.401','2025-11-19 22:33:04.401',NULL,NULL,NULL,NULL),(69,7,'Interest',NULL,'income',1,'2025-11-19 22:33:04.401','2025-11-19 22:33:04.401',NULL,NULL,NULL,NULL),(70,7,'Other Income',NULL,'income',1,'2025-11-19 22:33:04.401','2025-11-19 22:33:04.401',NULL,NULL,NULL,NULL),(71,7,'Misc',NULL,'expense',1,'2025-11-19 22:33:04.401','2025-11-19 22:33:04.401',NULL,NULL,NULL,NULL),(72,7,'Food',NULL,'expense',1,'2025-11-19 22:33:04.401','2025-11-19 22:33:04.401',NULL,NULL,NULL,NULL),(73,7,'Rent',NULL,'expense',1,'2025-11-19 22:33:04.401','2025-11-19 22:33:04.401',NULL,NULL,NULL,NULL),(74,7,'Transport',NULL,'expense',1,'2025-11-19 22:33:04.401','2025-11-19 22:33:04.401',NULL,NULL,NULL,NULL),(75,7,'Entertainment',NULL,'expense',1,'2025-11-19 22:33:04.401','2025-11-19 22:33:04.401',NULL,NULL,NULL,NULL),(76,7,'Bills',NULL,'expense',1,'2025-11-19 22:33:04.401','2025-11-19 22:33:04.401',NULL,NULL,NULL,NULL),(77,7,'Health',NULL,'expense',1,'2025-11-19 22:33:04.401','2025-11-19 22:33:04.401',NULL,NULL,NULL,NULL),(78,9,'Salary',NULL,'income',1,'2025-11-25 18:40:03.324','2025-11-25 18:40:03.324',NULL,NULL,NULL,NULL),(79,9,'Bonus',NULL,'income',1,'2025-11-25 18:40:03.324','2025-11-25 18:40:03.324',NULL,NULL,NULL,NULL),(80,9,'Interest',NULL,'income',1,'2025-11-25 18:40:03.324','2025-11-25 18:40:03.324',NULL,NULL,NULL,NULL),(81,9,'Other Income',NULL,'income',1,'2025-11-25 18:40:03.324','2025-11-25 18:40:03.324',NULL,NULL,NULL,NULL),(82,9,'Misc',NULL,'expense',1,'2025-11-25 18:40:03.324','2025-11-25 18:40:03.324',NULL,NULL,NULL,NULL),(83,9,'Food',NULL,'expense',1,'2025-11-25 18:40:03.324','2025-11-25 18:40:03.324',NULL,NULL,NULL,NULL),(84,9,'Rent',NULL,'expense',1,'2025-11-25 18:40:03.324','2025-11-25 18:40:03.324',NULL,NULL,NULL,NULL),(85,9,'Transport',NULL,'expense',1,'2025-11-25 18:40:03.324','2025-11-25 18:40:03.324',NULL,NULL,NULL,NULL),(86,9,'Entertainment',NULL,'expense',1,'2025-11-25 18:40:03.324','2025-11-25 18:40:03.324',NULL,NULL,NULL,NULL),(87,9,'Bills',NULL,'expense',1,'2025-11-25 18:40:03.324','2025-11-25 18:40:03.324',NULL,NULL,NULL,NULL),(88,9,'Health',NULL,'expense',1,'2025-11-25 18:40:03.324','2025-11-25 18:40:03.324',NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `daily_balance`
--

DROP TABLE IF EXISTS `daily_balance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `daily_balance` (
  `user_id` bigint unsigned NOT NULL,
  `day_local` date NOT NULL,
  `balance_cents` bigint NOT NULL,
  `net_change_cents` bigint NOT NULL,
  `computed_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`,`day_local`),
  KEY `ix_daily_balance_day_local` (`day_local`),
  CONSTRAINT `daily_balance_user_fk` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_daily_balance_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `daily_balance`
--

LOCK TABLES `daily_balance` WRITE;
/*!40000 ALTER TABLE `daily_balance` DISABLE KEYS */;
INSERT INTO `daily_balance` VALUES (1,'2025-11-08',0,0,'2025-11-10 00:05:01'),(1,'2025-11-09',1232500,1232500,'2025-11-11 01:38:12'),(1,'2025-11-30',1144500,0,'2025-12-01 05:03:25'),(2,'2025-11-30',50000,0,'2025-12-01 05:03:25'),(3,'2025-11-30',123400,0,'2025-12-01 05:03:25'),(4,'2025-11-30',1234500,0,'2025-12-01 05:03:25'),(5,'2025-11-30',1234500,0,'2025-12-01 05:03:25'),(6,'2025-11-30',541200,0,'2025-12-01 05:03:25'),(7,'2025-11-30',697000,0,'2025-12-01 05:03:25'),(9,'2025-11-30',1200000,0,'2025-12-01 05:03:25');
/*!40000 ALTER TABLE `daily_balance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `goal_runway`
--

DROP TABLE IF EXISTS `goal_runway`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `goal_runway` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `target_days` int NOT NULL,
  `effective_from` date NOT NULL,
  `effective_to` date DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  KEY `fk_goal_runway_user` (`user_id`),
  CONSTRAINT `fk_goal_runway_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  CONSTRAINT `fk_goal_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `goal_runway`
--

LOCK TABLES `goal_runway` WRITE;
/*!40000 ALTER TABLE `goal_runway` DISABLE KEYS */;
INSERT INTO `goal_runway` VALUES (1,1,17,'2025-11-23','2025-11-22','2025-11-23 16:56:36.977','2025-11-23 16:57:13.851'),(2,1,27,'2025-11-23',NULL,'2025-11-23 16:57:13.855','2025-11-23 16:57:13.855');
/*!40000 ALTER TABLE `goal_runway` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `insight_alert`
--

DROP TABLE IF EXISTS `insight_alert`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `insight_alert` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `period_id` bigint unsigned NOT NULL,
  `source` enum('ml','backend') NOT NULL,
  `code` varchar(40) NOT NULL,
  `title` varchar(120) NOT NULL,
  `message` varchar(400) NOT NULL,
  `severity` enum('info','warn','critical') NOT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `is_read` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `fk_insight_alert_user` (`user_id`),
  KEY `fk_insight_alert_period` (`period_id`),
  CONSTRAINT `fk_alert_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_insight_alert_period` FOREIGN KEY (`period_id`) REFERENCES `monthly_period` (`id`),
  CONSTRAINT `fk_insight_alert_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `insight_alert`
--

LOCK TABLES `insight_alert` WRITE;
/*!40000 ALTER TABLE `insight_alert` DISABLE KEYS */;
/*!40000 ALTER TABLE `insight_alert` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `insight_daily`
--

DROP TABLE IF EXISTS `insight_daily`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `insight_daily` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `period_id` bigint unsigned NOT NULL,
  `day` date NOT NULL,
  `spend_total_cents` bigint NOT NULL,
  `income_total_cents` bigint NOT NULL,
  `burn_rate_cents` bigint NOT NULL,
  `need_cents` bigint NOT NULL,
  `want_cents` bigint NOT NULL,
  `guilt_cents` bigint NOT NULL,
  `txn_count` int NOT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  KEY `fk_insight_daily_user` (`user_id`),
  KEY `fk_insight_daily_period` (`period_id`),
  CONSTRAINT `fk_insdaily_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_insight_daily_period` FOREIGN KEY (`period_id`) REFERENCES `monthly_period` (`id`),
  CONSTRAINT `fk_insight_daily_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `insight_daily`
--

LOCK TABLES `insight_daily` WRITE;
/*!40000 ALTER TABLE `insight_daily` DISABLE KEYS */;
/*!40000 ALTER TABLE `insight_daily` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `insight_segment`
--

DROP TABLE IF EXISTS `insight_segment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `insight_segment` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `period_id` bigint unsigned NOT NULL,
  `segment_type` enum('mood','day_part','nwg','weekday_weekend') NOT NULL,
  `segment_value` varchar(40) NOT NULL,
  `amount_cents` bigint NOT NULL,
  `txn_count` int NOT NULL,
  `avg_amount_cents` bigint DEFAULT NULL,
  `computed_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  KEY `fk_insight_segment_user` (`user_id`),
  KEY `fk_insight_segment_period` (`period_id`),
  CONSTRAINT `fk_insight_segment_period` FOREIGN KEY (`period_id`) REFERENCES `monthly_period` (`id`),
  CONSTRAINT `fk_insight_segment_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  CONSTRAINT `fk_insseg_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `insight_segment`
--

LOCK TABLES `insight_segment` WRITE;
/*!40000 ALTER TABLE `insight_segment` DISABLE KEYS */;
/*!40000 ALTER TABLE `insight_segment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `monthly_period`
--

DROP TABLE IF EXISTS `monthly_period`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `monthly_period` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `month_utc` date NOT NULL,
  `status` enum('active','closed') NOT NULL DEFAULT 'active',
  `opening_income_cents` bigint NOT NULL DEFAULT '0',
  `opening_weekly_cents` bigint GENERATED ALWAYS AS (round(((`opening_income_cents` * 12) / 52),0)) STORED,
  `opening_biweekly_cents` bigint GENERATED ALWAYS AS (round(((`opening_income_cents` * 12) / 26),0)) STORED,
  `note` varchar(200) DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `ux_period_user_month` (`user_id`,`month_utc`),
  KEY `ix_period_user` (`user_id`),
  CONSTRAINT `fk_monthly_period_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  CONSTRAINT `fk_period_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `monthly_period`
--

LOCK TABLES `monthly_period` WRITE;
/*!40000 ALTER TABLE `monthly_period` DISABLE KEYS */;
INSERT INTO `monthly_period` (`id`, `user_id`, `month_utc`, `status`, `opening_income_cents`, `note`, `created_at`, `updated_at`) VALUES (1,1,'2025-11-01','active',0,NULL,'2025-11-09 22:11:41.120','2025-11-09 22:11:41.120'),(2,2,'2025-11-01','active',0,NULL,'2025-11-16 17:34:06.038','2025-11-16 17:34:06.038'),(3,3,'2025-11-01','active',0,NULL,'2025-11-17 12:21:27.146','2025-11-17 12:21:27.146'),(4,4,'2025-11-01','active',0,NULL,'2025-11-17 16:05:29.012','2025-11-17 16:05:29.012'),(5,5,'2025-11-01','active',0,NULL,'2025-11-17 16:36:24.281','2025-11-17 16:36:24.281'),(6,6,'2025-11-01','active',0,NULL,'2025-11-17 16:46:45.916','2025-11-17 16:46:45.916'),(7,7,'2025-11-01','active',0,NULL,'2025-11-19 22:28:12.329','2025-11-19 22:28:12.329'),(8,9,'2025-11-01','active',0,NULL,'2025-11-25 18:38:53.962','2025-11-25 18:38:53.962');
/*!40000 ALTER TABLE `monthly_period` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_reset`
--

DROP TABLE IF EXISTS `password_reset`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_reset` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `token_hash` char(64) NOT NULL,
  `expires_at` datetime(3) NOT NULL,
  `used_at` datetime(3) DEFAULT NULL,
  `created_at` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ux_pwreset_token` (`token_hash`),
  KEY `ix_pwreset_user` (`user_id`),
  CONSTRAINT `fk_password_reset_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  CONSTRAINT `fk_pwreset_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_reset`
--

LOCK TABLES `password_reset` WRITE;
/*!40000 ALTER TABLE `password_reset` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_reset` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `power_saving_trigger`
--

DROP TABLE IF EXISTS `power_saving_trigger`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `power_saving_trigger` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `period_id` bigint unsigned NOT NULL,
  `triggered_at` datetime(3) NOT NULL,
  `goal_days` int DEFAULT NULL,
  `current_days_left` int NOT NULL,
  `threshold_ratio` decimal(4,2) NOT NULL DEFAULT '0.65',
  `suggested_daily_budget_cents` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_power_saving_trigger_user` (`user_id`),
  KEY `fk_power_saving_trigger_period` (`period_id`),
  CONSTRAINT `fk_power_saving_trigger_period` FOREIGN KEY (`period_id`) REFERENCES `monthly_period` (`id`),
  CONSTRAINT `fk_power_saving_trigger_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  CONSTRAINT `fk_pstrig_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `power_saving_trigger`
--

LOCK TABLES `power_saving_trigger` WRITE;
/*!40000 ALTER TABLE `power_saving_trigger` DISABLE KEYS */;
/*!40000 ALTER TABLE `power_saving_trigger` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `refresh_token`
--

DROP TABLE IF EXISTS `refresh_token`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `refresh_token` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `token_hash` char(64) NOT NULL,
  `rotation_parent_id` bigint unsigned DEFAULT NULL,
  `ip_last` varchar(45) DEFAULT NULL,
  `user_agent` varchar(200) DEFAULT NULL,
  `device_label` varchar(80) DEFAULT NULL,
  `created_at` datetime(3) NOT NULL,
  `expires_at` datetime(3) NOT NULL,
  `revoked_at` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ux_refresh_token_hash` (`token_hash`),
  KEY `ix_refresh_user` (`user_id`),
  KEY `fk_refresh_token_parent` (`rotation_parent_id`),
  CONSTRAINT `fk_refresh_token_parent` FOREIGN KEY (`rotation_parent_id`) REFERENCES `refresh_token` (`id`),
  CONSTRAINT `fk_refresh_token_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  CONSTRAINT `fk_refresh_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `refresh_token`
--

LOCK TABLES `refresh_token` WRITE;
/*!40000 ALTER TABLE `refresh_token` DISABLE KEYS */;
INSERT INTO `refresh_token` VALUES (1,1,'55622d4e2c2412f800aa10d44411eeeaa1c4b12a3d3b45128a23cea250d8d1fc',NULL,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36',NULL,'2025-11-10 18:36:31.898','2025-12-10 18:36:31.898',NULL),(2,1,'516c12ce86787be5f0f83aab33a30c62d61a8b3b4b7e64eeab5028ce85e6eceb',NULL,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36',NULL,'2025-11-10 20:46:15.992','2025-12-10 20:46:15.992',NULL),(3,1,'77607a85516618db529c17c42e273dfe75c6d529558895eee3ea42339500b402',NULL,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36',NULL,'2025-11-11 17:13:53.641','2025-12-11 17:13:53.641',NULL),(4,1,'373b31187584b33643b29fb9b4ae1918c47ff40080c0a25faeac2e7c0659e097',NULL,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36',NULL,'2025-11-11 22:51:52.613','2025-12-11 22:51:52.613',NULL),(5,1,'76cb996715d9d1367d086163db343c928fc1b08c5e1d20bfe293b6a7ddbe4423',NULL,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36',NULL,'2025-11-16 17:59:45.985','2025-12-16 17:59:45.985',NULL),(6,1,'d498f26cd1ae3304a9f6a15f8451a905844903ada2389ba24668739cd81590f9',NULL,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36',NULL,'2025-11-16 22:52:43.630','2025-12-16 22:52:43.630',NULL),(7,1,'6a486303756123c6837d4ba5b73db37b875c217a9c7e1418f98fba2348761782',NULL,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36',NULL,'2025-11-16 22:55:02.732','2025-12-16 22:55:02.732',NULL),(8,1,'662d5f12373de9427d77756eb18e98759956c3674746270067b231654334f0df',NULL,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36',NULL,'2025-11-18 19:27:11.594','2025-12-18 19:27:11.594',NULL),(9,1,'deb1f8101285c5907e578bd4273144937773a3ac25d883b6f56b5d56d6697198',NULL,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36',NULL,'2025-11-19 00:22:42.564','2025-12-19 00:22:42.564',NULL),(10,1,'f634c6141952c28aea94fd6db5adf933e934d4f9b118b037b286c08e2c5d9309',NULL,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36',NULL,'2025-11-23 21:34:26.886','2025-12-23 21:34:26.886',NULL),(11,1,'bc698a6ef77fb4efed2ea8065b1698f6c205e1245bcd9f443bea170afc4ce65e',NULL,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36',NULL,'2025-11-25 23:40:47.805','2025-12-25 23:40:47.805',NULL);
/*!40000 ALTER TABLE `refresh_token` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transaction`
--

DROP TABLE IF EXISTS `transaction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transaction` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `period_id` bigint unsigned NOT NULL,
  `type` enum('income','expense') NOT NULL,
  `amount_cents` bigint NOT NULL,
  `occurred_at` datetime(3) NOT NULL,
  `timezone` varchar(64) NOT NULL DEFAULT 'America/New_York',
  `txn_date` date GENERATED ALWAYS AS (cast(`occurred_at` as date)) STORED,
  `day_part` enum('morning','afternoon','evening','late_night') GENERATED ALWAYS AS ((case when (hour(`occurred_at`) between 4 and 11) then _utf8mb4'morning' when (hour(`occurred_at`) between 12 and 15) then _utf8mb4'afternoon' when (hour(`occurred_at`) between 16 and 21) then _utf8mb4'evening' else _utf8mb4'late_night' end)) STORED,
  `local_occurred_at` datetime(3) GENERATED ALWAYS AS (convert_tz(`occurred_at`,_utf8mb4'+00:00',`timezone`)) STORED,
  `txn_date_local` date GENERATED ALWAYS AS (cast(`local_occurred_at` as date)) STORED,
  `day_part_local` enum('morning','afternoon','evening','late_night') GENERATED ALWAYS AS ((case when (hour(`local_occurred_at`) between 4 and 11) then _utf8mb4'morning' when (hour(`local_occurred_at`) between 12 and 15) then _utf8mb4'afternoon' when (hour(`local_occurred_at`) between 16 and 21) then _utf8mb4'evening' else _utf8mb4'late_night' end)) STORED,
  `spend_class` enum('need','want','guilt') DEFAULT NULL,
  `category_id` bigint unsigned DEFAULT NULL,
  `merchant` varchar(160) DEFAULT NULL,
  `memo` varchar(300) DEFAULT NULL,
  `mood` enum('happy','neutral','stressed') DEFAULT NULL,
  `bill_payment_id` bigint unsigned DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  `deleted_at` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ix_txn_user_date` (`user_id`,`txn_date`),
  KEY `ix_txn_user_type_date` (`user_id`,`type`,`txn_date`),
  KEY `ix_txn_user_date_local` (`user_id`,`txn_date_local`),
  KEY `ix_txn_user_type_date_local` (`user_id`,`type`,`txn_date_local`),
  KEY `fk_tx_period` (`period_id`),
  KEY `fk_tx_category` (`category_id`),
  KEY `fk_tx_bill_payment` (`bill_payment_id`),
  CONSTRAINT `fk_tx_bill_payment` FOREIGN KEY (`bill_payment_id`) REFERENCES `bill_payment` (`id`),
  CONSTRAINT `fk_tx_category` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`),
  CONSTRAINT `fk_tx_period` FOREIGN KEY (`period_id`) REFERENCES `monthly_period` (`id`),
  CONSTRAINT `fk_tx_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  CONSTRAINT `fk_txn_cat` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_txn_period` FOREIGN KEY (`period_id`) REFERENCES `monthly_period` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_txn_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transaction`
--

LOCK TABLES `transaction` WRITE;
/*!40000 ALTER TABLE `transaction` DISABLE KEYS */;
INSERT INTO `transaction` (`id`, `user_id`, `period_id`, `type`, `amount_cents`, `occurred_at`, `timezone`, `spend_class`, `category_id`, `merchant`, `memo`, `mood`, `bill_payment_id`, `created_at`, `updated_at`, `deleted_at`) VALUES (1,1,1,'income',1234500,'2025-11-09 22:11:56.312','America/New_York',NULL,NULL,NULL,'Opening funds (onboarding)',NULL,NULL,'2025-11-09 22:11:56.313','2025-11-09 22:11:56.313',NULL),(2,1,1,'expense',2000,'2025-11-09 22:51:00.000','America/New_York','guilt',9,'Movie',NULL,'stressed',NULL,'2025-11-09 22:51:29.667','2025-11-09 22:51:29.667',NULL),(3,1,1,'expense',24900,'2025-11-10 23:21:56.523','America/New_York','need',5,'Rent','Bill paid',NULL,1,'2025-11-10 18:21:56.590','2025-11-10 18:21:56.590',NULL),(4,1,1,'expense',3000,'2025-11-11 22:26:03.491','America/New_York','need',5,'spectrum','Bill paid',NULL,2,'2025-11-11 17:26:03.533','2025-11-11 17:26:03.533',NULL),(7,1,1,'expense',1000,'2025-11-11 23:19:52.025','America/New_York','need',5,'coffe','Bill paid',NULL,3,'2025-11-11 18:19:52.037','2025-11-11 18:19:52.037',NULL),(8,1,1,'expense',4000,'2025-11-11 23:31:26.423','America/New_York','need',5,'Raid','Bill paid',NULL,4,'2025-11-11 18:31:26.436','2025-11-11 18:31:26.436',NULL),(9,1,1,'expense',12300,'2025-11-11 23:55:30.204','America/New_York','need',5,'part','Bill paid',NULL,5,'2025-11-11 18:55:30.211','2025-11-11 18:55:30.211',NULL),(10,1,1,'expense',3000,'2025-11-16 18:00:12.981','America/New_York','need',5,'Movie','Bill paid',NULL,6,'2025-11-16 13:00:13.013','2025-11-16 13:00:13.013',NULL),(11,2,2,'income',50000,'2025-11-16 22:34:19.104','America/New_York',NULL,NULL,NULL,'Opening funds (onboarding)',NULL,NULL,'2025-11-16 17:34:19.121','2025-11-16 17:34:19.121',NULL),(12,3,3,'income',123400,'2025-11-17 17:21:39.494','America/New_York',NULL,NULL,NULL,'Opening funds (onboarding)',NULL,NULL,'2025-11-17 12:21:39.502','2025-11-17 12:21:39.502',NULL),(13,4,4,'income',1234500,'2025-11-17 21:06:04.464','America/New_York',NULL,NULL,NULL,'Opening funds (onboarding)',NULL,NULL,'2025-11-17 16:06:04.467','2025-11-17 16:06:04.467',NULL),(14,5,5,'income',1234500,'2025-11-17 21:36:36.151','America/New_York',NULL,NULL,NULL,'Opening funds (onboarding)',NULL,NULL,'2025-11-17 16:36:36.152','2025-11-17 16:36:36.152',NULL),(15,6,6,'income',543200,'2025-11-17 21:47:01.165','America/New_York',NULL,NULL,NULL,'Opening funds (onboarding)',NULL,NULL,'2025-11-17 16:47:01.167','2025-11-17 16:47:01.167',NULL),(16,6,6,'expense',2000,'2025-11-17 18:20:00.000','America/New_York','guilt',64,'Movie',NULL,'stressed',NULL,'2025-11-17 18:21:12.174','2025-11-17 18:21:12.174',NULL),(17,1,1,'expense',2000,'2025-11-18 15:11:00.000','America/New_York','want',6,'starbucks',NULL,'happy',NULL,'2025-11-18 15:11:32.609','2025-11-18 15:11:32.609',NULL),(18,1,1,'expense',1000,'2025-11-18 20:13:03.950','America/New_York','need',5,'coffee','Bill paid',NULL,7,'2025-11-18 15:13:04.046','2025-11-18 15:13:04.046',NULL),(19,1,1,'expense',1000,'2025-11-18 16:45:00.000','America/New_York','want',9,'Movuie',NULL,'happy',NULL,'2025-11-18 19:24:18.157','2025-11-23 16:45:34.000',NULL),(20,1,1,'expense',12300,'2025-11-19 00:27:10.226','America/New_York','need',5,'part','Bill paid',NULL,8,'2025-11-18 19:27:10.265','2025-11-18 19:27:10.265',NULL),(21,1,1,'income',10000,'2025-11-18 19:28:00.000','America/New_York',NULL,1,'reward',NULL,'happy',NULL,'2025-11-18 19:29:29.713','2025-11-18 19:29:29.713',NULL),(22,7,7,'income',700000,'2025-11-20 03:31:55.342','America/New_York',NULL,NULL,NULL,'Opening funds (onboarding)',NULL,NULL,'2025-11-19 22:31:55.344','2025-11-19 22:31:55.344',NULL),(23,7,7,'expense',3000,'2025-11-19 22:33:00.000','America/New_York','want',72,'Starbucks',NULL,'happy',NULL,'2025-11-19 22:34:05.939','2025-11-19 22:34:05.939',NULL),(24,1,1,'expense',7500,'2025-11-23 16:37:00.000','America/New_York','want',5,'amazon',NULL,'happy',NULL,'2025-11-23 16:36:36.046','2025-11-23 16:37:43.000',NULL),(25,1,1,'expense',11000,'2025-11-23 17:00:00.000','America/New_York','want',10,'tution fee',NULL,'neutral',NULL,'2025-11-23 16:47:38.510','2025-11-23 17:00:20.000',NULL),(26,9,8,'income',1200000,'2025-11-25 23:39:41.430','America/New_York',NULL,NULL,NULL,'Opening funds (onboarding)',NULL,NULL,'2025-11-25 18:39:41.441','2025-11-25 18:39:41.441',NULL),(27,1,1,'expense',15000,'2025-11-25 23:41:32.243','America/New_York','need',5,'car insurance','Bill paid',NULL,9,'2025-11-25 18:41:32.307','2025-11-25 18:41:32.307',NULL);
/*!40000 ALTER TABLE `transaction` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_transaction_link_bill_payment` AFTER INSERT ON `transaction` FOR EACH ROW BEGIN
  IF NEW.bill_payment_id IS NOT NULL THEN
    UPDATE bill_payment
    SET transaction_id = NEW.id
    WHERE id = NEW.bill_payment_id
      AND (transaction_id IS NULL OR transaction_id = 0);
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(120) NOT NULL,
  `email` varchar(190) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `status` enum('pending_onboarding','active','locked','deleted') NOT NULL DEFAULT 'pending_onboarding',
  `timezone` varchar(64) NOT NULL DEFAULT 'America/New_York',
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `created_by` bigint unsigned DEFAULT NULL,
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  `updated_by` bigint unsigned DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `deleted_by` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `ux_user_email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'Sandeep Enamandala','sandeep.enamandala@gmail.com','$pbkdf2-sha256$29000$BEBozfmfs/be25tzLsWYUw$/rokcyuc4hJlBHaP0cjc/QUACWbjIraLZwi0ovfbzLY','active','America/New_York','2025-11-09 22:11:35.094',NULL,'2025-11-09 22:11:56.313',NULL,NULL,NULL),(2,'Meghamala','meghamala.samala@gmail.com','$pbkdf2-sha256$29000$k5LSOmcsRWhtjbF2zplzrg$t7o9aONhuMqBcor12MgM5lqMoS6rkQVfzFOCLEgArc4','active','America/New_York','2025-11-16 17:33:06.715',NULL,'2025-11-16 22:34:19.109',NULL,NULL,NULL),(3,'prajwal','prajwal.devaraj@gmail.com','$pbkdf2-sha256$29000$xPg/x5izlvI.p7T2njNGCA$BCviHsvYzHQVNmFlXWSVh4fHoRmbN/jbcFogTMwAOEY','active','America/New_York','2025-11-17 11:08:33.854',NULL,'2025-11-17 17:21:39.497',NULL,NULL,NULL),(4,'sarvesh','sarvesh.patil@gmail.com','$pbkdf2-sha256$29000$35uzdu4dg3COcQ5ByBnjPA$uE9mDn2Adh3tlsHq7pIVDkzzjKs7kVAEXCOmdX17D2w','active','America/New_York','2025-11-17 16:05:19.609',NULL,'2025-11-17 21:06:04.466',NULL,NULL,NULL),(5,'Manoj','manoj.kumar@gmail.com','$pbkdf2-sha256$29000$pBQCAADg/P9fC4FQSmmtNQ$Qt.1.kwk/XLJp2VwTdIGIfK.EfiQJMmuY0Qp15RaR5I','active','America/New_York','2025-11-17 16:35:57.679',NULL,'2025-11-17 21:36:36.152',NULL,NULL,NULL),(6,'Abhijeeth','abhijeeth.yalamachali@gmail.com','$pbkdf2-sha256$29000$CwHg/D8HAECodQ7hXAvhnA$jEW4oyODAFPEGwRPdZOS.oc1gc1hSXTYJUI2JgdS0k0','active','America/New_York','2025-11-17 16:46:39.473',NULL,'2025-11-17 21:47:01.166',NULL,NULL,NULL),(7,'Chandini Karrothu','chandini.karrothu@gmail.com','$pbkdf2-sha256$29000$uXeu9R7jfE9JyRnD2DsHoA$pxz8.9zHYYQlV0bcnO4rUv71oui7/EGdEcXCB1n4.qE','active','America/New_York','2025-11-19 22:27:24.458',NULL,'2025-11-20 03:31:55.343',NULL,NULL,NULL),(9,'sarvesh','sarvesh@gmail.com','$pbkdf2-sha256$29000$6t2bE8JYC2Hs/R.j9H5v7Q$V/mrrU/GXyCD0iiHR04jD1XaV/5fewWOqAx7SCcf6FY','active','America/New_York','2025-11-25 18:38:27.021',NULL,'2025-11-25 23:39:41.433',NULL,NULL,NULL);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_achievement`
--

DROP TABLE IF EXISTS `user_achievement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_achievement` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `achievement_id` bigint unsigned NOT NULL,
  `earned_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `ux_user_achievement` (`user_id`,`achievement_id`),
  KEY `ix_user_achievement_user` (`user_id`),
  KEY `ix_user_achievement_ach` (`achievement_id`),
  CONSTRAINT `fk_user_achievement_ach` FOREIGN KEY (`achievement_id`) REFERENCES `achievement` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_user_achievement_achievement` FOREIGN KEY (`achievement_id`) REFERENCES `achievement` (`id`),
  CONSTRAINT `fk_user_achievement_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_achievement`
--

LOCK TABLES `user_achievement` WRITE;
/*!40000 ALTER TABLE `user_achievement` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_achievement` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'smartspend'
--
/*!50106 SET @save_time_zone= @@TIME_ZONE */ ;
/*!50106 DROP EVENT IF EXISTS `ev_compute_daily_balance` */;
DELIMITER ;;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;;
/*!50003 SET character_set_client  = utf8mb4 */ ;;
/*!50003 SET character_set_results = utf8mb4 */ ;;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;;
/*!50003 SET @saved_time_zone      = @@time_zone */ ;;
/*!50003 SET time_zone             = 'SYSTEM' */ ;;
/*!50106 CREATE*/ /*!50117 DEFINER=`root`@`localhost`*/ /*!50106 EVENT `ev_compute_daily_balance` ON SCHEDULE EVERY 5 MINUTE STARTS '2025-11-11 10:23:25' ON COMPLETION NOT PRESERVE ENABLE DO INSERT INTO daily_balance (user_id, day_local, balance_cents, net_change_cents, computed_at)
  SELECT
    u.id,
    DATE(CONVERT_TZ(UTC_TIMESTAMP(), '+00:00', u.timezone)) - INTERVAL 1 DAY  AS day_local,

    /* Balance as of local 00:00:00 today (i.e., end of yesterday local) */
    COALESCE((
      SELECT SUM(CASE
                   WHEN tt.type='income'  THEN tt.amount_cents
                   WHEN tt.type='expense' THEN -tt.amount_cents
                 END)
      FROM `transaction` tt
      WHERE tt.user_id = u.id
        AND tt.occurred_at < CONVERT_TZ(
              CONCAT(DATE(CONVERT_TZ(UTC_TIMESTAMP(), '+00:00', u.timezone)),
                     ' 00:00:00'),
              u.timezone, '+00:00'
            )
    ), 0) AS balance_cents,

    /* Net change during yesterday local: [yesterday 00:00, today 00:00) */
    COALESCE((
      SELECT SUM(CASE
                   WHEN t2.type='income'  THEN t2.amount_cents
                   WHEN t2.type='expense' THEN -t2.amount_cents
                 END)
      FROM `transaction` t2
      WHERE t2.user_id = u.id
        AND t2.occurred_at >= CONVERT_TZ(
              CONCAT(DATE(CONVERT_TZ(UTC_TIMESTAMP(), '+00:00', u.timezone)) - INTERVAL 1 DAY,
                     ' 00:00:00'),
              u.timezone, '+00:00'
            )
        AND t2.occurred_at <  CONVERT_TZ(
              CONCAT(DATE(CONVERT_TZ(UTC_TIMESTAMP(), '+00:00', u.timezone)),
                     ' 00:00:00'),
              u.timezone, '+00:00'
            )
    ), 0) AS net_change_cents,

    UTC_TIMESTAMP() AS computed_at
  FROM `user` u
  /* Only users whose LOCAL time is in the first 10 minutes after midnight */
  WHERE TIME(CONVERT_TZ(UTC_TIMESTAMP(), '+00:00', u.timezone))
        BETWEEN '00:00:00' AND '00:09:59'
  /* Skip if we've already inserted for that local day */
  AND NOT EXISTS (
    SELECT 1
    FROM daily_balance db
    WHERE db.user_id   = u.id
      AND db.day_local = DATE(CONVERT_TZ(UTC_TIMESTAMP(), '+00:00', u.timezone)) - INTERVAL 1 DAY
  ) */ ;;
/*!50003 SET time_zone             = @saved_time_zone */ ;;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;;
/*!50003 SET character_set_client  = @saved_cs_client */ ;;
/*!50003 SET character_set_results = @saved_cs_results */ ;;
/*!50003 SET collation_connection  = @saved_col_connection */ ;;
DELIMITER ;
/*!50106 SET TIME_ZONE= @save_time_zone */ ;

--
-- Dumping routines for database 'smartspend'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-01 21:29:35
