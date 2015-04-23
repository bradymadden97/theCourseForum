-- MySQL dump 10.13  Distrib 5.5.37, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: thecourseforum_development
-- ------------------------------------------------------
-- Server version	5.5.37-0ubuntu0.13.10.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `book_requirements`
--

DROP TABLE IF EXISTS `book_requirements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `book_requirements` (
  `section_id` int(11) DEFAULT NULL,
  `book_id` int(11) DEFAULT NULL,
  `requirement_status` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `book_requirements`
--

LOCK TABLES `book_requirements` WRITE;
/*!40000 ALTER TABLE `book_requirements` DISABLE KEYS */;
/*!40000 ALTER TABLE `book_requirements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `books`
--

DROP TABLE IF EXISTS `books`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `books` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` text,
  `author` text,
  `ISBN` bigint(20) DEFAULT NULL,
  `binding` text,
  `new_availability` tinyint(1) DEFAULT NULL,
  `used_availability` tinyint(1) DEFAULT NULL,
  `rental_availability` tinyint(1) DEFAULT NULL,
  `new_price` text,
  `new_rental_price` text,
  `used_price` text,
  `used_rental_price` text,
  `signed_request` text,
  `ASIN` text,
  `details_page` text,
  `small_image_URL` text,
  `medium_image_URL` text,
  `amazon_new_price` int(11) DEFAULT NULL,
  `affiliate_link` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `books`
--

LOCK TABLES `books` WRITE;
/*!40000 ALTER TABLE `books` DISABLE KEYS */;
/*!40000 ALTER TABLE `books` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bugs`
--

DROP TABLE IF EXISTS `bugs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bugs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bugs`
--

LOCK TABLES `bugs` WRITE;
/*!40000 ALTER TABLE `bugs` DISABLE KEYS */;
/*!40000 ALTER TABLE `bugs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `courses`
--

DROP TABLE IF EXISTS `courses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `courses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `course_number` decimal(4,0) DEFAULT '0',
  `subdepartment_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `title_changed` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_courses_on_subdepartment_id` (`subdepartment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `courses`
--

LOCK TABLES `courses` WRITE;
/*!40000 ALTER TABLE `courses` DISABLE KEYS */;
/*!40000 ALTER TABLE `courses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `courses_users`
--

DROP TABLE IF EXISTS `courses_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `courses_users` (
  `course_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  UNIQUE KEY `index_courses_users_on_user_id_and_course_id` (`user_id`,`course_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `courses_users`
--

LOCK TABLES `courses_users` WRITE;
/*!40000 ALTER TABLE `courses_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `courses_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `day_times`
--

DROP TABLE IF EXISTS `day_times`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `day_times` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `day` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `start_time` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `end_time` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `day_times`
--

LOCK TABLES `day_times` WRITE;
/*!40000 ALTER TABLE `day_times` DISABLE KEYS */;
/*!40000 ALTER TABLE `day_times` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `day_times_sections`
--

DROP TABLE IF EXISTS `day_times_sections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `day_times_sections` (
  `day_time_id` int(11) DEFAULT NULL,
  `section_id` int(11) DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `day_times_sections`
--

LOCK TABLES `day_times_sections` WRITE;
/*!40000 ALTER TABLE `day_times_sections` DISABLE KEYS */;
/*!40000 ALTER TABLE `day_times_sections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `departments`
--

DROP TABLE IF EXISTS `departments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `departments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `school_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_departments_on_school_id` (`school_id`)
) ENGINE=InnoDB AUTO_INCREMENT=80 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `departments`
--

LOCK TABLES `departments` WRITE;
/*!40000 ALTER TABLE `departments` DISABLE KEYS */;
INSERT INTO `departments` VALUES (1,'Anthropology',1,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(2,'Art',1,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(3,'Astronomy',1,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(4,'Biology',1,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(5,'Chemistry',1,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(6,'Classics',1,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(7,'Drama',1,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(8,'East Asian Languages, Literatures & Cultures',1,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(9,'Economics',1,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(10,'English',1,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(11,'Environmental Sciences',1,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(12,'French Language & Literature',1,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(13,'German Languages & Literatures',1,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(14,'History',1,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(15,'Mathematics',1,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(16,'Media Studies',1,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(17,'Middle Eastern & South Asian Languages & Cultures',1,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(18,'Music',1,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(19,'Philosophy',1,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(20,'Physics',1,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(21,'Applied Mathematics',2,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(22,'Politics',1,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(23,'Public Health Sciences',1,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(24,'Psychology',1,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(25,'Religious Studies',1,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(26,'Biomedical Engineering',2,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(27,'Chemical Engineering',2,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(28,'Slavic Languages & Literatures',1,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(29,'Civil & Environmental Engineering',2,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(30,'Computer Science',1,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(31,'Sociology',1,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(32,'Spanish, Italian & Portuguese',1,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(33,'Statistics',1,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(34,'Electrical & Computer Engineering',2,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(35,'Materials Science & Engineering',2,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(36,'Mechanical & Aerospace Engineering',2,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(37,'Science, Technology & Society',2,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(38,'Systems & Information Engineering',2,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(39,'School of Architecture',3,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(40,'Interdisciplinary Studies',NULL,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(41,'Darden School of Business',7,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(42,'McIntire School of Commerce',5,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(45,'School of Law',8,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(46,'School of Medicine',11,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(47,'School of Nursing',6,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(48,'Batten School of Leadership and Public Policy',10,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(50,'American Sign Language',1,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(51,'African-American & African Studies',1,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(52,'American Studies',1,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(53,'Cognitive Science',1,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(54,'College Advising Seminars',1,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(55,'East Asian Studies',1,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(56,'Environmental Thought & Practice',1,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(58,'Global Development Studies',1,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(59,'Jewish Studies',1,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(60,'Latin American Studies',1,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(62,'Liberal Arts Seminars',1,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(63,'Linguistics',1,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(64,'Medieval Studies',1,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(65,'Middle Eastern Studies',1,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(66,'Neuroscience',1,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(67,'Political & Social Thought',1,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(68,'South Asian Studies',1,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(69,'Pavilion Seminars',1,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(71,'Women, Gender, and Sexuality',1,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(72,'Computer Science',2,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(73,'ROTC',NULL,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(74,'Curry School of Education',4,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(75,'School of Continuing and Professional Studies',9,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(76,'University Seminars',NULL,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(77,'General Engineering',2,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(78,'Political Philosophy, Policy, & Law',1,'2013-10-28 00:25:09','0000-00-00 00:00:00'),(79,'Semester at Sea',NULL,'2013-10-28 00:25:09','0000-00-00 00:00:00');
/*!40000 ALTER TABLE `departments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `departments_subdepartments`
--

DROP TABLE IF EXISTS `departments_subdepartments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `departments_subdepartments` (
  `department_id` int(11) DEFAULT NULL,
  `subdepartment_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `departments_subdepartments`
--

LOCK TABLES `departments_subdepartments` WRITE;
/*!40000 ALTER TABLE `departments_subdepartments` DISABLE KEYS */;
INSERT INTO `departments_subdepartments` VALUES (1,7),(2,10),(2,11),(2,14),(2,15),(3,17),(4,22),(4,79),(5,30),(6,33),(6,78),(6,111),(7,39),(7,40),(8,31),(8,32),(8,41),(8,104),(8,105),(8,107),(8,209),(8,196),(9,43),(10,37),(10,47),(10,48),(10,49),(10,50),(10,51),(10,210),(10,53),(10,54),(10,55),(10,56),(10,57),(10,58),(10,59),(10,60),(10,61),(11,65),(11,66),(11,67),(11,68),(11,69),(12,70),(12,213),(13,75),(13,76),(13,199),(14,82),(14,83),(14,84),(14,85),(14,86),(14,88),(14,89),(14,90),(15,116),(16,117),(17,9),(17,80),(17,87),(17,119),(17,203),(17,146),(17,147),(17,183),(17,185),(17,186),(17,197),(18,125),(18,126),(18,127),(19,149),(20,154),(22,156),(22,158),(22,159),(22,160),(22,161),(23,150),(24,172),(25,173),(25,174),(25,175),(25,176),(25,177),(25,178),(25,179),(25,180),(28,162),(28,181),(28,182),(28,187),(28,188),(28,189),(31,190),(32,102),(32,103),(32,163),(32,191),(33,192),(50,16),(51,1),(52,6),(53,34),(54,35),(30,38),(55,41),(56,64),(58,74),(59,106),(60,110),(62,109),(63,113),(63,114),(64,123),(65,203),(66,140),(67,170),(68,185),(69,211),(76,198),(71,214),(21,8),(26,24),(27,29),(29,27),(72,38),(34,42),(35,62),(35,122),(36,115),(37,193),(38,195),(39,4),(39,11),(39,12),(39,13),(39,108),(39,155),(39,157),(40,95),(40,96),(40,97),(40,98),(40,99),(40,100),(40,94),(40,93),(41,71),(42,36),(42,73),(74,44),(74,45),(74,46),(45,112),(46,19),(46,20),(46,23),(46,28),(46,118),(46,120),(46,148),(46,152),(47,72),(47,77),(47,141),(47,142),(47,143),(48,165),(73,3),(73,121),(73,128),(75,2),(75,25),(75,201),(75,91),(75,101),(75,137),(75,145),(75,166),(75,204),(75,167),(75,168),(75,212),(75,169),(75,171),(77,52),(18,124),(17,200),(68,18),(46,21),(2,215),(8,202),(10,63),(17,81),(75,129),(75,130),(75,131),(75,132),(75,133),(75,134),(75,135),(75,136),(75,138),(75,139),(46,144),(74,153),(78,164),(75,217),(39,184),(79,205),(71,194),(51,207),(36,5);
/*!40000 ALTER TABLE `departments_subdepartments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `grades`
--

DROP TABLE IF EXISTS `grades`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `grades` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `section_id` int(11) DEFAULT NULL,
  `semester_id` int(11) DEFAULT NULL,
  `gpa` decimal(4,3) DEFAULT '0.000',
  `count_a` int(11) DEFAULT NULL,
  `count_aminus` int(11) DEFAULT NULL,
  `count_bplus` int(11) DEFAULT NULL,
  `count_b` int(11) DEFAULT NULL,
  `count_bminus` int(11) DEFAULT NULL,
  `count_cplus` int(11) DEFAULT NULL,
  `count_c` int(11) DEFAULT NULL,
  `count_cminus` int(11) DEFAULT NULL,
  `count_dplus` int(11) DEFAULT NULL,
  `count_d` int(11) DEFAULT NULL,
  `count_dminus` int(11) DEFAULT NULL,
  `count_f` int(11) DEFAULT NULL,
  `count_drop` int(11) DEFAULT NULL,
  `count_withdraw` int(11) DEFAULT NULL,
  `count_other` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `count_aplus` int(11) DEFAULT NULL,
  `total` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_grades_on_CourseProfessor_id` (`section_id`),
  KEY `index_grades_on_semester_id` (`semester_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `grades`
--

LOCK TABLES `grades` WRITE;
/*!40000 ALTER TABLE `grades` DISABLE KEYS */;
/*!40000 ALTER TABLE `grades` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `locations`
--

DROP TABLE IF EXISTS `locations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `locations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `location` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `locations`
--

LOCK TABLES `locations` WRITE;
/*!40000 ALTER TABLE `locations` DISABLE KEYS */;
/*!40000 ALTER TABLE `locations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `majors`
--

DROP TABLE IF EXISTS `majors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `majors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `majors`
--

LOCK TABLES `majors` WRITE;
/*!40000 ALTER TABLE `majors` DISABLE KEYS */;
/*!40000 ALTER TABLE `majors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `professor_salary`
--

DROP TABLE IF EXISTS `professor_salary`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `professor_salary` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `staff_type` text,
  `assignment_organization` text,
  `annual_salary` int(11) DEFAULT NULL,
  `normal_hours` int(11) DEFAULT NULL,
  `working_title` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `professor_salary`
--

LOCK TABLES `professor_salary` WRITE;
/*!40000 ALTER TABLE `professor_salary` DISABLE KEYS */;
/*!40000 ALTER TABLE `professor_salary` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `professors`
--

DROP TABLE IF EXISTS `professors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `professors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `preferred_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email_alias` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `department_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `middle_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `classification` text COLLATE utf8_unicode_ci,
  `department` text COLLATE utf8_unicode_ci,
  `department_code` text COLLATE utf8_unicode_ci,
  `primary_email` text COLLATE utf8_unicode_ci,
  `office_phone` text COLLATE utf8_unicode_ci,
  `office_address` text COLLATE utf8_unicode_ci,
  `registered_email` text COLLATE utf8_unicode_ci,
  `fax_phone` text COLLATE utf8_unicode_ci,
  `title` text COLLATE utf8_unicode_ci,
  `home_phone` text COLLATE utf8_unicode_ci,
  `home_page` text COLLATE utf8_unicode_ci,
  `mobile_phone` text COLLATE utf8_unicode_ci,
  `professor_salary_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_professors_on_department_id` (`department_id`),
  KEY `index_professors_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `professors`
--

LOCK TABLES `professors` WRITE;
/*!40000 ALTER TABLE `professors` DISABLE KEYS */;
/*!40000 ALTER TABLE `professors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reviews`
--

DROP TABLE IF EXISTS `reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reviews` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `comment` text COLLATE utf8_unicode_ci,
  `course_professor_id` int(11) DEFAULT NULL,
  `student_id` int(11) DEFAULT NULL,
  `semester_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `professor_rating` decimal(11,2) DEFAULT '0.00',
  `enjoyability` int(11) DEFAULT '0',
  `difficulty` int(11) DEFAULT '0',
  `amount_reading` decimal(11,2) DEFAULT '0.00',
  `amount_writing` decimal(11,2) DEFAULT '0.00',
  `amount_group` decimal(11,2) DEFAULT '0.00',
  `amount_homework` decimal(11,2) DEFAULT '0.00',
  `only_tests` tinyint(1) DEFAULT '0',
  `recommend` int(11) DEFAULT '0',
  `ta_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `course_id` int(11) DEFAULT NULL,
  `professor_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_reviews_on_CourseProfessor_id` (`course_professor_id`),
  KEY `index_reviews_on_student_id` (`student_id`),
  KEY `index_reviews_on_semester_id` (`semester_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reviews`
--

LOCK TABLES `reviews` WRITE;
/*!40000 ALTER TABLE `reviews` DISABLE KEYS */;
/*!40000 ALTER TABLE `reviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schedules`
--

DROP TABLE IF EXISTS `schedules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schedules` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `flagged` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schedules`
--

LOCK TABLES `schedules` WRITE;
/*!40000 ALTER TABLE `schedules` DISABLE KEYS */;
/*!40000 ALTER TABLE `schedules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schedules_sections`
--

DROP TABLE IF EXISTS `schedules_sections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schedules_sections` (
  `schedule_id` int(11) NOT NULL,
  `section_id` int(11) NOT NULL,
  UNIQUE KEY `index_schedules_sections_on_schedule_id_and_section_id` (`schedule_id`,`section_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schedules_sections`
--

LOCK TABLES `schedules_sections` WRITE;
/*!40000 ALTER TABLE `schedules_sections` DISABLE KEYS */;
/*!40000 ALTER TABLE `schedules_sections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schema_migrations`
--

DROP TABLE IF EXISTS `schema_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schema_migrations`
--

LOCK TABLES `schema_migrations` WRITE;
/*!40000 ALTER TABLE `schema_migrations` DISABLE KEYS */;
INSERT INTO `schema_migrations` VALUES ('20130225062323'),('20130225062421'),('20130225062449'),('20130225062956'),('20130225063122'),('20130225063152'),('20130225063353'),('20130225063529'),('20130225063544'),('20130225063612'),('20130225064028'),('20130225064121'),('20130225064423'),('20130301004449'),('20130311044634'),('20130311045032'),('20130311045528'),('20130311050305'),('20130311052038'),('20130313074913'),('20130314064957'),('20130325050141'),('20130325050256'),('20130326042645'),('20130331235247'),('20130331235624'),('20130411025649'),('20130411030421'),('20130411031237'),('20130411032531'),('20130411033413'),('20130411040236'),('20130411040558'),('20130411040828'),('20130411041001'),('20130411041425'),('20130411042508'),('20130411042556'),('20130411043140'),('20130411043202'),('20130412001758'),('20130412011148'),('20130412051636'),('20130803234330'),('20130803234612'),('20130811001441'),('20130811014246'),('20130826205627'),('20131115203400'),('20131115211852'),('20131118235310'),('20131118235453'),('20131127210231'),('20140411235037'),('20140412203900'),('20140413050730'),('20140413053411'),('20140413070855'),('20140413070856'),('20140413071350'),('20140415170504'),('20140421021221'),('20140421041939'),('20141007045717'),('20141008012745'),('20141008160448'),('20141109022627'),('20150308033519'),('20150331031616'),('20150401202146');
/*!40000 ALTER TABLE `schema_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schools`
--

DROP TABLE IF EXISTS `schools`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schools` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `website` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schools`
--

LOCK TABLES `schools` WRITE;
/*!40000 ALTER TABLE `schools` DISABLE KEYS */;
INSERT INTO `schools` VALUES (1,'College of Arts & Sciences','2013-10-28 00:25:09','0000-00-00 00:00:00',''),(2,'School of Engineering & Applied Science','2013-10-28 00:25:09','0000-00-00 00:00:00',''),(3,'School of Architecture','2013-10-28 00:25:09','0000-00-00 00:00:00',''),(4,'Curry School of Education','2013-10-28 00:25:09','0000-00-00 00:00:00',''),(5,'McIntire School of Commerce','2013-10-28 00:25:09','0000-00-00 00:00:00',''),(6,'School of Nursing','2013-10-28 00:25:09','0000-00-00 00:00:00',''),(7,'Darden School of Business','2013-10-28 00:25:09','0000-00-00 00:00:00',''),(8,'School of Law','2013-10-28 00:25:09','0000-00-00 00:00:00',''),(9,'School of Continuing and Professional Studies','2013-10-28 00:25:09','0000-00-00 00:00:00',''),(10,'Batten School of Leadership and Public Policy','2013-10-28 00:25:09','0000-00-00 00:00:00',''),(11,'School of Medicine','2013-10-28 00:25:09','0000-00-00 00:00:00','');
/*!40000 ALTER TABLE `schools` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `section_professors`
--

DROP TABLE IF EXISTS `section_professors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `section_professors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `section_id` int(11) DEFAULT NULL,
  `professor_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_section_professors_on_section_id` (`section_id`),
  KEY `index_section_professors_on_professor_id` (`professor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `section_professors`
--

LOCK TABLES `section_professors` WRITE;
/*!40000 ALTER TABLE `section_professors` DISABLE KEYS */;
/*!40000 ALTER TABLE `section_professors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sections`
--

DROP TABLE IF EXISTS `sections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sections` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sis_class_number` int(11) DEFAULT NULL,
  `section_number` int(11) DEFAULT NULL,
  `topic` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `units` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `capacity` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `section_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `course_id` int(11) DEFAULT NULL,
  `semester_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sections`
--

LOCK TABLES `sections` WRITE;
/*!40000 ALTER TABLE `sections` DISABLE KEYS */;
/*!40000 ALTER TABLE `sections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `semesters`
--

DROP TABLE IF EXISTS `semesters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `semesters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `number` int(11) DEFAULT NULL,
  `season` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `year` decimal(4,0) DEFAULT '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `semesters`
--

LOCK TABLES `semesters` WRITE;
/*!40000 ALTER TABLE `semesters` DISABLE KEYS */;
/*!40000 ALTER TABLE `semesters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `settings`
--

DROP TABLE IF EXISTS `settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `var` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `value` text COLLATE utf8_unicode_ci,
  `target_id` int(11) NOT NULL,
  `target_type` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_settings_on_target_type_and_target_id_and_var` (`target_type`,`target_id`,`var`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `settings`
--

LOCK TABLES `settings` WRITE;
/*!40000 ALTER TABLE `settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_majors`
--

DROP TABLE IF EXISTS `student_majors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `student_majors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `student_id` int(11) DEFAULT NULL,
  `major_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_student_majors_on_student_id` (`student_id`),
  KEY `index_student_majors_on_major_id` (`major_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_majors`
--

LOCK TABLES `student_majors` WRITE;
/*!40000 ALTER TABLE `student_majors` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_majors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `students`
--

DROP TABLE IF EXISTS `students`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `students` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `grad_year` decimal(4,0) DEFAULT '0',
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `students`
--

LOCK TABLES `students` WRITE;
/*!40000 ALTER TABLE `students` DISABLE KEYS */;
/*!40000 ALTER TABLE `students` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subdepartments`
--

DROP TABLE IF EXISTS `subdepartments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `subdepartments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `mnemonic` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=230 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subdepartments`
--

LOCK TABLES `subdepartments` WRITE;
/*!40000 ALTER TABLE `subdepartments` DISABLE KEYS */;
INSERT INTO `subdepartments` VALUES (1,'African-American and African Studies','AAS','2013-10-28 00:25:09','0000-00-00 00:00:00'),(2,'Accounting','ACCT','2013-10-28 00:25:09','0000-00-00 00:00:00'),(3,'Air Science','AIRS','2013-10-28 00:25:09','0000-00-00 00:00:00'),(4,'Architecture and Landscape Architecture','ALAR','2013-10-28 00:25:09','0000-00-00 00:00:00'),(5,'Applied Mechanics','AM','2013-10-28 00:25:09','0000-00-00 00:00:00'),(6,'American Studies','AMST','2013-10-28 00:25:09','0000-00-00 00:00:00'),(7,'Anthropology','ANTH','2013-10-28 00:25:09','0000-00-00 00:00:00'),(8,'Applied Mathematics','APMA','2013-10-28 00:25:09','0000-00-00 00:00:00'),(9,'Arabic','ARAB','2013-10-28 00:25:09','0000-00-00 00:00:00'),(10,'Arts Administration','ARAD','2013-10-28 00:25:09','0000-00-00 00:00:00'),(11,'History of Art and Architecture','ARAH','2013-10-28 00:25:09','0000-00-00 00:00:00'),(12,'Architecture','ARCH','2013-10-28 00:25:09','0000-00-00 00:00:00'),(13,'Architectural History','ARH','2013-10-28 00:25:09','0000-00-00 00:00:00'),(14,'History of Art','ARTH','2013-10-28 00:25:09','0000-00-00 00:00:00'),(15,'Studio Art','ARTS','2013-10-28 00:25:09','0000-00-00 00:00:00'),(16,'American Sign Language','ASL','2013-10-28 00:25:09','0000-00-00 00:00:00'),(17,'Astronomy','ASTR','2013-10-28 00:25:09','0000-00-00 00:00:00'),(18,'Bengali','BENG','2013-10-28 00:25:09','0000-00-00 00:00:00'),(19,'Biomedical Sciences','BIMS','2013-10-28 00:25:09','0000-00-00 00:00:00'),(20,'Biochemistry','BIOC','2013-10-28 00:25:09','0000-00-00 00:00:00'),(21,'Bioethics','BIOE','2013-10-28 00:25:09','0000-00-00 00:00:00'),(22,'Biology','BIOL','2013-10-28 00:25:09','0000-00-00 00:00:00'),(23,'Biophysics','BIOP','2013-10-28 00:25:09','0000-00-00 00:00:00'),(24,'Biomedical Engineering','BME','2013-10-28 00:25:09','0000-00-00 00:00:00'),(25,'Business','BUS','2013-10-28 00:25:09','0000-00-00 00:00:00'),(26,'Common Course-Sciences','CCSC','2013-10-28 00:25:09','0000-00-00 00:00:00'),(27,'Civil Engineering','CE','2013-10-28 00:25:09','0000-00-00 00:00:00'),(28,'Cell Biology','CELL','2013-10-28 00:25:09','0000-00-00 00:00:00'),(29,'Chemical Engineering','CHE','2013-10-28 00:25:09','0000-00-00 00:00:00'),(30,'Chemistry','CHEM','2013-10-28 00:25:09','0000-00-00 00:00:00'),(31,'Chinese','CHIN','2013-10-28 00:25:09','0000-00-00 00:00:00'),(32,'Chinese in Translation','CHTR','2013-10-28 00:25:09','0000-00-00 00:00:00'),(33,'Classics','CLAS','2013-10-28 00:25:09','0000-00-00 00:00:00'),(34,'Cognitive Science','COGS','2013-10-28 00:25:09','0000-00-00 00:00:00'),(35,'College Advising Seminar','COLA','2013-10-28 00:25:09','0000-00-00 00:00:00'),(36,'Commerce','COMM','2013-10-28 00:25:09','0000-00-00 00:00:00'),(37,'Comparative Literature','CPLT','2013-10-28 00:25:09','0000-00-00 00:00:00'),(38,'Computer Science','CS','2013-10-28 00:25:09','0000-00-00 00:00:00'),(39,'Dance','DANC','2013-10-28 00:25:09','0000-00-00 00:00:00'),(40,'Drama','DRAM','2013-10-28 00:25:09','0000-00-00 00:00:00'),(41,'East Asian Studies','EAST','2013-10-28 00:25:09','0000-00-00 00:00:00'),(42,'Electrical and Computer Engineering','ECE','2013-10-28 00:25:09','0000-00-00 00:00:00'),(43,'Economics','ECON','2013-10-28 00:25:09','0000-00-00 00:00:00'),(44,'Education-Human Services','EDHS','2013-10-28 00:25:09','0000-00-00 00:00:00'),(45,'Education-Curriculum, Instruction, & Special Ed','EDIS','2013-10-28 00:25:09','0000-00-00 00:00:00'),(46,'Education-Leadership, Foundations, and Policy','EDLF','2013-10-28 00:25:09','0000-00-00 00:00:00'),(47,'English-American Literature to 1900','ENAM','2013-10-28 00:25:09','0000-00-00 00:00:00'),(48,'English-Criticism','ENCR','2013-10-28 00:25:09','0000-00-00 00:00:00'),(49,'English-Restoration and Eighteenth-Century Lit','ENEC','2013-10-28 00:25:09','0000-00-00 00:00:00'),(50,'English-Miscellaneous','ENGL','2013-10-28 00:25:09','0000-00-00 00:00:00'),(51,'English-Genre Studies','ENGN','2013-10-28 00:25:09','0000-00-00 00:00:00'),(52,'Engineering','ENGR','2013-10-28 00:25:09','0000-00-00 00:00:00'),(53,'English-Introductory Seminar in Literature','ENLT','2013-10-28 00:25:09','0000-00-00 00:00:00'),(54,'English-Modern & Contemporary Literature','ENMC','2013-10-28 00:25:09','0000-00-00 00:00:00'),(55,'English-Medieval Literature','ENMD','2013-10-28 00:25:09','0000-00-00 00:00:00'),(56,'English-Nineteenth-Century British Literature','ENNC','2013-10-28 00:25:09','0000-00-00 00:00:00'),(57,'English-Pedagogy','ENPG','2013-10-28 00:25:09','0000-00-00 00:00:00'),(58,'English-Poetry Writing','ENPW','2013-10-28 00:25:09','0000-00-00 00:00:00'),(59,'English-Renaissance Literature','ENRN','2013-10-28 00:25:09','0000-00-00 00:00:00'),(60,'English-Special Topics in Literature','ENSP','2013-10-28 00:25:09','0000-00-00 00:00:00'),(61,'English-Academic, Professional, & Creative Writing','ENWR','2013-10-28 00:25:09','0000-00-00 00:00:00'),(62,'Engineering Physics','EP','2013-10-28 00:25:09','0000-00-00 00:00:00'),(63,'English as a Second Language','ESL','2013-10-28 00:25:09','0000-00-00 00:00:00'),(64,'Enviromental Thought and Practice','ETP','2013-10-28 00:25:09','0000-00-00 00:00:00'),(65,'Environmental Sciences-Atmospheric Sciences','EVAT','2013-10-28 00:25:09','0000-00-00 00:00:00'),(66,'Environmental Sciences-Ecology','EVEC','2013-10-28 00:25:09','0000-00-00 00:00:00'),(67,'Environmental Sciences-Geosciences','EVGE','2013-10-28 00:25:09','0000-00-00 00:00:00'),(68,'Environmental Sciences-Hydrology','EVHY','2013-10-28 00:25:09','0000-00-00 00:00:00'),(69,'Environmental Sciences','EVSC','2013-10-28 00:25:09','0000-00-00 00:00:00'),(70,'French','FREN','2013-10-28 00:25:09','0000-00-00 00:00:00'),(71,'Graduate Business','GBUS','2013-10-28 00:25:09','0000-00-00 00:00:00'),(72,'Clinical Nurse Leader','GCNL','2013-10-28 00:25:09','0000-00-00 00:00:00'),(73,'Graduate Commerce','GCOM','2013-10-28 00:25:09','0000-00-00 00:00:00'),(74,'Global Development Studies','GDS','2013-10-28 00:25:09','0000-00-00 00:00:00'),(75,'German','GERM','2013-10-28 00:25:09','0000-00-00 00:00:00'),(76,'German in Translation','GETR','2013-10-28 00:25:09','0000-00-00 00:00:00'),(77,'Graduate Nursing','GNUR','2013-10-28 00:25:09','0000-00-00 00:00:00'),(78,'Greek','GREE','2013-10-28 00:25:09','0000-00-00 00:00:00'),(79,'Human Biology','HBIO','2013-10-28 00:25:09','0000-00-00 00:00:00'),(80,'Hebrew','HEBR','2013-10-28 00:25:09','0000-00-00 00:00:00'),(81,'Hebrew in Translation','HETR','2013-10-28 00:25:09','0000-00-00 00:00:00'),(82,'History-African History','HIAF','2013-10-28 00:25:09','0000-00-00 00:00:00'),(83,'History-East Asian History','HIEA','2013-10-28 00:25:09','0000-00-00 00:00:00'),(84,'History-European History','HIEU','2013-10-28 00:25:09','0000-00-00 00:00:00'),(85,'History-Latin American History','HILA','2013-10-28 00:25:09','0000-00-00 00:00:00'),(86,'History-Middle Eastern History','HIME','2013-10-28 00:25:09','0000-00-00 00:00:00'),(87,'Hindi','HIND','2013-10-28 00:25:09','0000-00-00 00:00:00'),(88,'History-South Asian History','HISA','2013-10-28 00:25:09','0000-00-00 00:00:00'),(89,'History-General History','HIST','2013-10-28 00:25:09','0000-00-00 00:00:00'),(90,'History-United States History','HIUS','2013-10-28 00:25:09','0000-00-00 00:00:00'),(91,'Human Resources','HR','2013-10-28 00:25:09','0000-00-00 00:00:00'),(92,'College Science Scholars Seminar','HSCI','2013-10-28 00:25:09','0000-00-00 00:00:00'),(93,'Interdisciplinary Thesis','IMP','2013-10-28 00:25:09','0000-00-00 00:00:00'),(94,'Interdisciplinary Studies','INST','2013-10-28 00:25:09','0000-00-00 00:00:00'),(95,'Interdisciplinary Studies-Business','ISBU','2013-10-28 00:25:09','0000-00-00 00:00:00'),(96,'Interdisciplinary Studies-Capstone Project','ISCP','2013-10-28 00:25:09','0000-00-00 00:00:00'),(97,'Interdisiplinary Studies-Humanities','ISHU','2013-10-28 00:25:09','0000-00-00 00:00:00'),(98,'Interdisciplinary Studies-Liberal Studies Seminar','ISLS','2013-10-28 00:25:09','0000-00-00 00:00:00'),(99,'Interdisciplinary Studies-Proseminar','ISPS','2013-10-28 00:25:09','0000-00-00 00:00:00'),(100,'Interdisciplinary Studies-Social Sciences','ISSS','2013-10-28 00:25:09','0000-00-00 00:00:00'),(101,'Informational Technology','IT','2013-10-28 00:25:09','0000-00-00 00:00:00'),(102,'Italian','ITAL','2013-10-28 00:25:09','0000-00-00 00:00:00'),(103,'Italian in Translation','ITTR','2013-10-28 00:25:09','0000-00-00 00:00:00'),(104,'Japanese','JAPN','2013-10-28 00:25:09','0000-00-00 00:00:00'),(105,'Japanese in Translation','JPTR','2013-10-28 00:25:09','0000-00-00 00:00:00'),(106,'Jewish Studies','JWST','2013-10-28 00:25:09','0000-00-00 00:00:00'),(107,'Korean','KOR','2013-10-28 00:25:09','0000-00-00 00:00:00'),(108,'Landscape Architecture','LAR','2013-10-28 00:25:09','0000-00-00 00:00:00'),(109,'Liberal Arts Seminar','LASE','2013-10-28 00:25:09','0000-00-00 00:00:00'),(110,'Latin American Studies','LAST','2013-10-28 00:25:09','0000-00-00 00:00:00'),(111,'Latin','LATI','2013-10-28 00:25:09','0000-00-00 00:00:00'),(112,'Law','LAW','2013-10-28 00:25:09','0000-00-00 00:00:00'),(113,'Linguistics','LING','2013-10-28 00:25:09','0000-00-00 00:00:00'),(114,'General Linguistics','LNGS','2013-10-28 00:25:09','0000-00-00 00:00:00'),(115,'Mechanical & Aerospace Engineering','MAE','2013-10-28 00:25:09','0000-00-00 00:00:00'),(116,'Mathematics','MATH','2013-10-28 00:25:09','0000-00-00 00:00:00'),(117,'Media Studies','MDST','2013-10-28 00:25:09','0000-00-00 00:00:00'),(118,'Medicine','MED','2013-10-28 00:25:09','0000-00-00 00:00:00'),(119,'Middle Eastern & South Asian Languages & Cultures','MESA','2013-10-28 00:25:09','0000-00-00 00:00:00'),(120,'Microbiology','MICR','2013-10-28 00:25:09','0000-00-00 00:00:00'),(121,'Military Science','MISC','2013-10-28 00:25:09','0000-00-00 00:00:00'),(122,'Materials Science and Engineering','MSE','2013-10-28 00:25:09','0000-00-00 00:00:00'),(123,'Medieval Studies','MSP','2013-10-28 00:25:09','0000-00-00 00:00:00'),(124,'Music-Marching Band','MUBD','2013-10-28 00:25:09','0000-00-00 00:00:00'),(125,'Music-Ensembles','MUEN','2013-10-28 00:25:09','0000-00-00 00:00:00'),(126,'Music-Private Performance Instruction','MUPF','2013-10-28 00:25:09','0000-00-00 00:00:00'),(127,'Music','MUSI','2013-10-28 00:25:09','0000-00-00 00:00:00'),(128,'Naval Science','NASC','2013-10-28 00:25:09','0000-00-00 00:00:00'),(129,'Non-Credit Architecture & Environment Design','NCAR','2013-10-28 00:25:09','0000-00-00 00:00:00'),(130,'Non-Credit Business and Management','NCBM','2013-10-28 00:25:09','0000-00-00 00:00:00'),(131,'Non-Credit Education','NCED','2013-10-28 00:25:09','0000-00-00 00:00:00'),(132,'Non-Credit Fine and Applied Arts','NCFA','2013-10-28 00:25:09','0000-00-00 00:00:00'),(133,'Non-Credit Foreign Language','NCFL','2013-10-28 00:25:09','0000-00-00 00:00:00'),(134,'Non-Credit Letters','NCLE','2013-10-28 00:25:09','0000-00-00 00:00:00'),(135,'Non-Credit Personal Development','NCPD','2013-10-28 00:25:09','0000-00-00 00:00:00'),(136,'Non-Credit Physical Sciences','NCPH','2013-10-28 00:25:09','0000-00-00 00:00:00'),(137,'Non-Credit Professional Review','NCPR','2013-10-28 00:25:09','0000-00-00 00:00:00'),(138,'Non-Credit Social Sciences','NCSS','2013-10-28 00:25:09','0000-00-00 00:00:00'),(139,'Non-Credit Theology','NCTH','2013-10-28 00:25:09','0000-00-00 00:00:00'),(140,'Neuroscience','NESC','2013-10-28 00:25:09','0000-00-00 00:00:00'),(141,'Nursing Core','NUCO','2013-10-28 00:25:09','0000-00-00 00:00:00'),(142,'Nursing Interprofessional','NUIP','2013-10-28 00:25:09','0000-00-00 00:00:00'),(143,'Nursing','NURS','2013-10-28 00:25:09','0000-00-00 00:00:00'),(144,'Pathology','PATH','2013-10-28 00:25:09','0000-00-00 00:00:00'),(145,'Procurement and Contracts Management','PC','2013-10-28 00:25:09','0000-00-00 00:00:00'),(146,'Persian','PERS','2013-10-28 00:25:09','0000-00-00 00:00:00'),(147,'Persian in Translation','PETR','2013-10-28 00:25:09','0000-00-00 00:00:00'),(148,'Pharmacology','PHAR','2013-10-28 00:25:09','0000-00-00 00:00:00'),(149,'Philosophy','PHIL','2013-10-28 00:25:09','0000-00-00 00:00:00'),(150,'Public Health Sciences','PHS','2013-10-28 00:25:09','0000-00-00 00:00:00'),(151,'Public Health Sciences Ethics','PHSE','2013-10-28 00:25:09','0000-00-00 00:00:00'),(152,'Physiology','PHY','2013-10-28 00:25:09','0000-00-00 00:00:00'),(153,'Physical Education','PHYE','2013-10-28 00:25:09','0000-00-00 00:00:00'),(154,'Physics','PHYS','2013-10-28 00:25:09','0000-00-00 00:00:00'),(155,'Planning Application','PLAC','2013-10-28 00:25:09','0000-00-00 00:00:00'),(156,'Politics-Departmental Seminar','PLAD','2013-10-28 00:25:09','0000-00-00 00:00:00'),(157,'Urban and Environmental Planning','PLAN','2013-10-28 00:25:09','0000-00-00 00:00:00'),(158,'Politics-American Politics','PLAP','2013-10-28 00:25:09','0000-00-00 00:00:00'),(159,'Politics-Comparative Politics','PLCP','2013-10-28 00:25:09','0000-00-00 00:00:00'),(160,'Politics-International Relations','PLIR','2013-10-28 00:25:09','0000-00-00 00:00:00'),(161,'Politics-Political Theory','PLPT','2013-10-28 00:25:09','0000-00-00 00:00:00'),(162,'Polish','POL','2013-10-28 00:25:09','0000-00-00 00:00:00'),(163,'Portuguese','PORT','2013-10-28 00:25:09','0000-00-00 00:00:00'),(164,'Political Philosophy, Policy, and Law','PPL','2013-10-28 00:25:09','0000-00-00 00:00:00'),(165,'Public Policy','PPOL','2013-10-28 00:25:09','0000-00-00 00:00:00'),(166,'Professional Studies-Education','PSED','2013-10-28 00:25:09','0000-00-00 00:00:00'),(167,'Professional Studies-MT','PSMT','2013-10-28 00:25:09','0000-00-00 00:00:00'),(168,'Professional Studies-Public Administration','PSPA','2013-10-28 00:25:09','0000-00-00 00:00:00'),(169,'Professional Studies-Project Management','PSPM','2013-10-28 00:25:09','0000-00-00 00:00:00'),(170,'Political and Social Thought','PST','2013-10-28 00:25:09','0000-00-00 00:00:00'),(171,'Professional Studies-Workforce Development','PSWD','2013-10-28 00:25:09','0000-00-00 00:00:00'),(172,'Psychology','PSYC','2013-10-28 00:25:09','0000-00-00 00:00:00'),(173,'Religion-African Religions','RELA','2013-10-28 00:25:09','0000-00-00 00:00:00'),(174,'Religion-Buddhism','RELB','2013-10-28 00:25:09','0000-00-00 00:00:00'),(175,'Religion-Christianity','RELC','2013-10-28 00:25:09','0000-00-00 00:00:00'),(176,'Religion-General Religion','RELG','2013-10-28 00:25:09','0000-00-00 00:00:00'),(177,'Religion-Hinduism','RELH','2013-10-28 00:25:09','0000-00-00 00:00:00'),(178,'Religion-Islam','RELI','2013-10-28 00:25:09','0000-00-00 00:00:00'),(179,'Religion-Judaism','RELJ','2013-10-28 00:25:09','0000-00-00 00:00:00'),(180,'Religion-Special Topic','RELS','2013-10-28 00:25:09','0000-00-00 00:00:00'),(181,'Russian','RUSS','2013-10-28 00:25:09','0000-00-00 00:00:00'),(182,'Russian in Translation','RUTR','2013-10-28 00:25:09','0000-00-00 00:00:00'),(183,'Sanskrit','SANS','2013-10-28 00:25:09','0000-00-00 00:00:00'),(184,'Architecture School','SARC','2013-10-28 00:25:09','0000-00-00 00:00:00'),(185,'South Asian Studies','SAST','2013-10-28 00:25:09','0000-00-00 00:00:00'),(186,'South Asian Literature in Translation','SATR','2013-10-28 00:25:09','0000-00-00 00:00:00'),(187,'Slavic','SLAV','2013-10-28 00:25:09','0000-00-00 00:00:00'),(188,'Slavic Folklore & Oral Literature','SLFK','2013-10-28 00:25:09','0000-00-00 00:00:00'),(189,'Slavic in Translation','SLTR','2013-10-28 00:25:09','0000-00-00 00:00:00'),(190,'Sociology','SOC','2013-10-28 00:25:09','0000-00-00 00:00:00'),(191,'Spanish','SPAN','2013-10-28 00:25:09','0000-00-00 00:00:00'),(192,'Statistics','STAT','2013-10-28 00:25:09','0000-00-00 00:00:00'),(193,'Science, Technology, and Society','STS','2013-10-28 00:25:09','0000-00-00 00:00:00'),(194,'Studies in Women and Gender','SWAG','2013-10-28 00:25:09','0000-00-00 00:00:00'),(195,'Systems & Information Engineering','SYS','2013-10-28 00:25:09','0000-00-00 00:00:00'),(196,'Tibetan','TBTN','2013-10-28 00:25:09','0000-00-00 00:00:00'),(197,'Urdu','URDU','2013-10-28 00:25:09','0000-00-00 00:00:00'),(198,'University Seminar','USEM','2013-10-28 00:25:09','0000-00-00 00:00:00'),(199,'Yiddish','YIDD','2013-10-28 00:25:09','0000-00-00 00:00:00'),(200,'Arabic in Translation','ARTR','2013-10-28 00:25:09','0000-00-00 00:00:00'),(201,'Criminal Justice','CJ','2013-10-28 00:25:09','0000-00-00 00:00:00'),(202,'East Asian Languages, Literatures, and Cultures','EALC','2013-10-28 00:25:09','0000-00-00 00:00:00'),(203,'Middle Eastern Studies','MEST','2013-10-28 00:25:09','0000-00-00 00:00:00'),(204,'Professional Studies-Education Web-Based','PSEW','2013-10-28 00:25:09','0000-00-00 00:00:00'),(205,'Semester at Sea','SEMS','2013-10-28 00:25:09','0000-00-00 00:00:00'),(206,'Undergraduate Non-Resident','NRES','2013-10-28 00:25:09','0000-00-00 00:00:00'),(207,'Swahili','SWAH','2013-10-28 00:25:09','0000-00-00 00:00:00'),(208,'Study Abroad','ZFOR','2013-10-28 00:25:09','0000-00-00 00:00:00'),(209,'Korean in Translation','KRTR','2013-10-28 00:25:09','0000-00-00 00:00:00'),(210,'English-Language Study','ENLS','2013-10-28 00:25:09','0000-00-00 00:00:00'),(211,'Pavilion Seminars','PAVS','2013-10-28 00:25:09','0000-00-00 00:00:00'),(212,'Professional Studies-Political Leadership','PSPL','2013-10-28 00:25:09','0000-00-00 00:00:00'),(213,'French in Translation','FRTR','2013-10-28 00:25:09','0000-00-00 00:00:00'),(214,'Women and Gender Studies','WGS','2013-10-28 00:25:09','0000-00-00 00:00:00'),(215,'College Art Scholars Seminar','CASS','2013-10-28 00:25:09','0000-00-00 00:00:00'),(216,'Humanities and Global Cultures','IHGC','2013-10-28 00:25:09','0000-00-00 00:00:00'),(217,'Professional Studies-Health Policy','PSHP','2013-10-28 00:25:09','0000-00-00 00:00:00'),(218,'Archaeology','ARCY','2013-10-28 00:25:09','0000-00-00 00:00:00'),(219,'University Studies','UNST','2013-10-28 00:25:09','0000-00-00 00:00:00'),(220,'Bengali in Translation','BETR','2014-07-04 08:59:22','0000-00-00 00:00:00'),(221,'Non-Credit Health Professions','NCHP','2014-07-04 09:19:15','0000-00-00 00:00:00'),(222,'Graduate Non-Resident','NRGA','2014-07-04 09:20:53','0000-00-00 00:00:00'),(223,'Portuguese in Translation','POTR','2014-07-04 10:09:54','0000-00-00 00:00:00'),(225,'Personal Skills','PLSK','2014-07-04 19:00:43','0000-00-00 00:00:00'),(226,'Interdisciplinary Studies-Individualized Other','ISIN','2014-07-04 20:16:01','0000-00-00 00:00:00'),(227,'Kinesiology','KINE','2014-07-04 20:17:17','0000-00-00 00:00:00'),(228,'Computer Engineering','CPE','2015-03-26 23:40:51','2015-03-29 18:29:14'),(229,'Spanish in Translation','SPTR','2015-03-26 23:44:31','2015-03-29 18:29:37');
/*!40000 ALTER TABLE `subdepartments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `old_password` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `student_id` int(11) DEFAULT NULL,
  `professor_id` int(11) DEFAULT NULL,
  `subscribed_to_email` tinyint(1) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `first_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `encrypted_password` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `reset_password_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `reset_password_sent_at` datetime DEFAULT NULL,
  `remember_created_at` datetime DEFAULT NULL,
  `sign_in_count` int(11) DEFAULT '0',
  `current_sign_in_at` datetime DEFAULT NULL,
  `last_sign_in_at` datetime DEFAULT NULL,
  `current_sign_in_ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_sign_in_ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `confirmation_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `confirmed_at` datetime DEFAULT NULL,
  `confirmation_sent_at` datetime DEFAULT NULL,
  `unconfirmed_email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_users_on_email` (`email`),
  UNIQUE KEY `index_users_on_reset_password_token` (`reset_password_token`),
  UNIQUE KEY `index_users_on_confirmation_token` (`confirmation_token`),
  KEY `index_users_on_student_id` (`student_id`),
  KEY `index_users_on_professor_id` (`professor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `votes`
--

DROP TABLE IF EXISTS `votes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `votes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `vote` tinyint(1) NOT NULL DEFAULT '0',
  `voteable_id` int(11) NOT NULL,
  `voteable_type` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `voter_id` int(11) DEFAULT NULL,
  `voter_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `fk_one_vote_per_user_per_entity` (`voter_id`,`voter_type`,`voteable_id`,`voteable_type`),
  KEY `index_votes_on_voter_id_and_voter_type` (`voter_id`,`voter_type`),
  KEY `index_votes_on_voteable_id_and_voteable_type` (`voteable_id`,`voteable_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `votes`
--

LOCK TABLES `votes` WRITE;
/*!40000 ALTER TABLE `votes` DISABLE KEYS */;
/*!40000 ALTER TABLE `votes` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2015-04-21  2:10:28
