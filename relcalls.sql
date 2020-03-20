-- phpMyAdmin SQL Dump
-- version 4.9.1
-- https://www.phpmyadmin.net/
--
-- Host: 10.0.1.10
-- Generation Time: Mar 20, 2020 at 04:41 PM
-- Server version: 5.7.27-0ubuntu0.18.04.1
-- PHP Version: 7.2.10-0ubuntu0.18.04.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `vip`
--

-- --------------------------------------------------------

--
-- Table structure for table `relcalls`
--

CREATE TABLE `relcalls` (
  `id` int(11) NOT NULL,
  `calldate` datetime NOT NULL,
  `src` varchar(80) CHARACTER SET latin1 NOT NULL,
  `srcfinal` varchar(80) COLLATE utf8_unicode_ci NOT NULL,
  `dstfinal` varchar(80) CHARACTER SET latin1 NOT NULL,
  `disposition` varchar(45) CHARACTER SET latin1 NOT NULL,
  `duration` int(11) NOT NULL,
  `billsec` int(11) NOT NULL,
  `accountcode` varchar(20) CHARACTER SET latin1 DEFAULT '0',
  `uniqueid` varchar(45) CHARACTER SET latin1 NOT NULL,
  `channel` varchar(80) CHARACTER SET latin1 DEFAULT NULL,
  `trunk_id` int(11) DEFAULT NULL,
  `price` float(10,2) DEFAULT '0.00',
  `userfield` varchar(45) CHARACTER SET latin1 NOT NULL,
  `hide` enum('0','1') CHARACTER SET latin1 NOT NULL DEFAULT '0',
  `cidade` varchar(70) COLLATE utf8_unicode_ci DEFAULT NULL,
  `estado` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `company_id` int(11) DEFAULT NULL,
  `servidor_id` varchar(3) COLLATE utf8_unicode_ci NOT NULL DEFAULT '023'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Triggers `relcalls`
--
DELIMITER $$
CREATE TRIGGER `prePagoInsert` AFTER INSERT ON `relcalls` FOR EACH ROW BEGIN   declare _status char(3);
  select status into _status from prepaid where company_id=new.company_id;
  if _status = 'yes' then
    update prepaid set value=(value-new.price) where company_id=new.company_id;
  end if;
end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `prePagoUpdate` AFTER UPDATE ON `relcalls` FOR EACH ROW BEGIN   declare _status char(3);
  select status into _status from prepaid where company_id=old.company_id;
  if _status = 'yes' then
    update prepaid set value=((value+old.price)-new.price) where company_id=old.company_id;
  end if;
end
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `relcalls`
--
ALTER TABLE `relcalls`
  ADD PRIMARY KEY (`id`),
  ADD KEY `accountcode` (`accountcode`),
  ADD KEY `disposition` (`disposition`),
  ADD KEY `company_id` (`company_id`),
  ADD KEY `calldate` (`calldate`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `relcalls`
--
ALTER TABLE `relcalls`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
