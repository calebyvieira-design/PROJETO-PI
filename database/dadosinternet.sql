CREATE DATABASE  IF NOT EXISTS `dadosinternet` /*!40100 DEFAULT CHARACTER SET utf8mb3 */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `dadosinternet`;
-- MySQL dump 10.13  Distrib 8.0.44, for Win64 (x86_64)
--
-- Host: localhost    Database: dadosinternet
-- ------------------------------------------------------
-- Server version	26.7.0

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
SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;

--
-- GTID state at the beginning of the backup 
--

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ '65c1685d-96a6-11f1-b522-02505b025e04:1-244';

--
-- Table structure for table `clientes`
--

DROP TABLE IF EXISTS `clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clientes` (
  `idcliente` int NOT NULL AUTO_INCREMENT,
  `tipoPessoa` varchar(10) NOT NULL,
  `nomeCompleto` varchar(60) NOT NULL,
  `cpfCnpj` varchar(14) NOT NULL,
  `rg` varchar(9) DEFAULT NULL,
  `dataNascimento` date NOT NULL,
  `dataCadastro` date NOT NULL,
  `statusCliente` varchar(20) NOT NULL,
  `enderecos_idendereco` int NOT NULL,
  `contatos_idcontato` int NOT NULL,
  `contratosAssinaturas_idcontrato` int NOT NULL,
  PRIMARY KEY (`idcliente`),
  KEY `fk_clientes_enderecos_idx` (`enderecos_idendereco`),
  KEY `fk_clientes_contatos1_idx` (`contatos_idcontato`),
  KEY `fk_clientes_contratosAssinaturas1_idx` (`contratosAssinaturas_idcontrato`),
  CONSTRAINT `fk_clientes_contatos1` FOREIGN KEY (`contatos_idcontato`) REFERENCES `contatos` (`idcontato`),
  CONSTRAINT `fk_clientes_contratosAssinaturas1` FOREIGN KEY (`contratosAssinaturas_idcontrato`) REFERENCES `contratosassinaturas` (`idcontrato`),
  CONSTRAINT `fk_clientes_enderecos` FOREIGN KEY (`enderecos_idendereco`) REFERENCES `enderecos` (`idendereco`)
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clientes`
--

LOCK TABLES `clientes` WRITE;
/*!40000 ALTER TABLE `clientes` DISABLE KEYS */;
INSERT INTO `clientes` VALUES (1,'Física','Rafael Zonta','123.456.789-11','123456789','2007-12-12','2020-11-09','Ativo',1,1,1),(2,'JURIDICA','Nicolas Rewell Alves','83219','2983434','2007-10-22','2026-10-24','Ativo',3,3,3),(3,'FISICA','JOAO GABRIEL','4837932','012930','2005-04-11','2026-10-24','Ativo',4,4,4),(4,'FISICA','KAIO','3812931209','','2004-09-30','2026-10-25','Ativo',5,5,5),(52,'FISICA','NICOLAS','12345678912345','','2007-06-06','2026-10-26','Ativo',52,53,52),(54,'JURIDICA','LUCAS FARIAS','20026009','','2007-04-19','2026-10-30','Ativo',54,55,54),(55,'FISICA','DANIELO SANTOS','84238332','938102','1966-03-31','2026-10-30','Ativo',55,56,55),(56,'FISICA','ASIDJAI','21312','12321','2000-01-01','2026-10-30','Ativo',56,57,56);
/*!40000 ALTER TABLE `clientes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contatos`
--

DROP TABLE IF EXISTS `contatos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contatos` (
  `idcontato` int NOT NULL AUTO_INCREMENT,
  `telefonePrincipal` varchar(11) NOT NULL,
  `telefoneSecundario` varchar(11) DEFAULT NULL,
  `email` varchar(45) NOT NULL,
  `aceitaNotificacao` tinyint(1) NOT NULL,
  PRIMARY KEY (`idcontato`)
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contatos`
--

LOCK TABLES `contatos` WRITE;
/*!40000 ALTER TABLE `contatos` DISABLE KEYS */;
INSERT INTO `contatos` VALUES (1,'00123456789','22987654321','rafael.zontarzb@gmail.com',1),(3,'7773212',NULL,'NICOLAS.WINDOWS@ANDROID.COM',1),(4,'204398',NULL,'JOAO.GABRIEL@GEMINI.GE.COM',1),(5,'192831923',NULL,'kaio.kaiokaio@mysql.com',0),(53,'19991029999',NULL,'jao@gmail.com',1),(55,'309021220',NULL,'lucas.farias@tg.com',0),(56,'10912812',NULL,'danielosantos@ultrageografia.geo.santos',1),(57,'29108312',NULL,'asduai',1);
/*!40000 ALTER TABLE `contatos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contratosassinaturas`
--

DROP TABLE IF EXISTS `contratosassinaturas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contratosassinaturas` (
  `idcontrato` int NOT NULL AUTO_INCREMENT,
  `dataAdesao` date NOT NULL,
  `vencimentoFatura` date NOT NULL,
  PRIMARY KEY (`idcontrato`)
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contratosassinaturas`
--

LOCK TABLES `contratosassinaturas` WRITE;
/*!40000 ALTER TABLE `contratosassinaturas` DISABLE KEYS */;
INSERT INTO `contratosassinaturas` VALUES (1,'2020-11-10','2027-12-30'),(3,'2026-10-24','2026-11-24'),(4,'2026-10-24','2026-11-24'),(5,'2026-10-25','2026-11-25'),(52,'2026-10-26','2026-11-26'),(54,'2026-10-30','2026-11-30'),(55,'2026-10-30','2026-11-30'),(56,'2026-10-30','2026-11-30');
/*!40000 ALTER TABLE `contratosassinaturas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `enderecos`
--

DROP TABLE IF EXISTS `enderecos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `enderecos` (
  `idendereco` int NOT NULL AUTO_INCREMENT,
  `estado` varchar(2) NOT NULL,
  `tipoEndereco` varchar(20) NOT NULL,
  `cep` varchar(8) NOT NULL,
  `logradouro` varchar(45) NOT NULL,
  `numero` varchar(5) NOT NULL,
  `complemento` varchar(45) DEFAULT NULL,
  `bairro` varchar(45) NOT NULL,
  `cidade` varchar(45) NOT NULL,
  PRIMARY KEY (`idendereco`)
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `enderecos`
--

LOCK TABLES `enderecos` WRITE;
/*!40000 ALTER TABLE `enderecos` DISABLE KEYS */;
INSERT INTO `enderecos` VALUES (1,'SP','Casa','12345678','Rua Brasil','1994',NULL,'Jardim Paulista','São Paulo'),(3,'RS','PREDIO COMERCIAL','932891','AVENIDA CLAUDE','22',NULL,'JARDIM GEMINI','COPILOTVILLE'),(4,'GE','MANSAO','32190','RUA GEMINI','2022',NULL,'ULTRA GEMINI 2','GEMINI CITY'),(5,'MY','APARTAMENTO','90909090','RUA GRANDE','923',NULL,'BAIRRO DO MYSQL','MYSQL DO OESTE'),(52,'SP','CASA','12345678','JOAO 123 VALE GRAMA','45',NULL,'PEDRO07','MERINVAR'),(54,'SP','BATALHÃ£O','108000','AVENIDA MILITAR','222',NULL,'JONAS GABRIEL','MOCOCA'),(55,'AC','MANSÃ£O GEOGRAFIA','1230988','RUA ODAIR FERNANDES SANTOS','808',NULL,'GLAUBERSON NICOLAU MMXXVI','ANTA GORDA'),(56,'AA','AOIDJA','291201','ASDJASUDJ','3921',NULL,'SAJDASIDNASIDAIJ','DJWQO923I1EK');
/*!40000 ALTER TABLE `enderecos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `planos`
--

DROP TABLE IF EXISTS `planos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `planos` (
  `idplano` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(45) NOT NULL,
  `velocidade` int NOT NULL,
  `mensalidade` double NOT NULL,
  `contratosAssinaturas_idcontrato` int DEFAULT NULL,
  PRIMARY KEY (`idplano`),
  KEY `fk_planos_contratosAssinaturas` (`contratosAssinaturas_idcontrato`),
  CONSTRAINT `fk_planos_contratosAssinaturas` FOREIGN KEY (`contratosAssinaturas_idcontrato`) REFERENCES `contratosassinaturas` (`idcontrato`)
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `planos`
--

LOCK TABLES `planos` WRITE;
/*!40000 ALTER TABLE `planos` DISABLE KEYS */;
INSERT INTO `planos` VALUES (1,'Plano Diamante',700,159.9,1),(2,'Plano Empresarial',6000,799.9,3),(3,'Plano Fibra Turbo',1000,199.9,4),(4,'Plano Ouro',500,129.9,5),(52,'Plano Ouro',500,129.9,52),(54,'Plano Empresarial',6000,799.9,54),(55,'Plano Bronze',100,89.9,55),(56,'Plano Família',2000,289.9,56);
/*!40000 ALTER TABLE `planos` ENABLE KEYS */;
UNLOCK TABLES;
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-30 15:46:30
