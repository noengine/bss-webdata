-- phpMyAdmin SQL Dump
-- version 4.0.10.14
-- http://www.phpmyadmin.net
--
-- Host: localhost:3306
-- Generation Time: Nov 19, 2016 at 04:34 PM
-- Server version: 5.6.33
-- PHP Version: 5.6.20

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `beverle1_bssdata`
--

-- --------------------------------------------------------

--
-- Table structure for table `flight_log`
--

DROP TABLE IF EXISTS `flight_log`;
CREATE TABLE IF NOT EXISTS `flight_log` (
  `log_type` tinytext,
  `flight_date` date DEFAULT NULL,
  `flight_number` int(11) DEFAULT NULL,
  `glider_registration` tinytext,
  `pilot_in_command` int(11) DEFAULT NULL,
  `second_pilot` int(11) DEFAULT NULL,
  `flight_type` tinytext,
  `tug_registration` tinytext,
  `tug_pilot` int(11) DEFAULT NULL,
  `time_off` time DEFAULT NULL,
  `tug_down` time DEFAULT NULL,
  `glider_down` time DEFAULT NULL,
  `tow_height` tinytext,
  `retrieve_tug_time` int(11) DEFAULT NULL,
  `retrieve_glider_time` int(11) DEFAULT NULL,
  `processed` tinyint(1) DEFAULT NULL,
  `flight_cost` decimal(10,2) DEFAULT NULL,
  `member_code_1` int(11) DEFAULT NULL,
  `member_code_2` int(11) DEFAULT NULL,
  `peak_flag` tinyint(1) DEFAULT NULL,
  `comment` tinytext,
  `distance` int(11) DEFAULT NULL,
  `airfield` tinytext,
  KEY `flight_date` (`flight_date`),
  KEY `flight_number` (`flight_number`),
  KEY `glider_registration` (`glider_registration`(3)),
  KEY `pilot_in_command` (`pilot_in_command`),
  KEY `second_pilot` (`second_pilot`),
  KEY `tug_pilot` (`tug_pilot`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `gliders`
--

DROP TABLE IF EXISTS `gliders`;
CREATE TABLE IF NOT EXISTS `gliders` (
  `registration` text NOT NULL,
  `model` text,
  `seats` int(1) DEFAULT NULL,
  `year_of_manufacture` date DEFAULT NULL,
  `club_aircraft` tinyint(1) DEFAULT NULL,
  `form_2_date` date DEFAULT NULL,
  `form_2_minutes` int(11) DEFAULT NULL,
  `form_2_landings` int(11) DEFAULT NULL,
  PRIMARY KEY (`registration`(3))
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `members`
--

DROP TABLE IF EXISTS `members`;
CREATE TABLE IF NOT EXISTS `members` (
  `member_id` int(11) NOT NULL,
  `first_name` tinytext,
  `surname` tinytext,
  `initials` tinytext,
  `member_type` tinytext,
  `street_address` tinytext,
  `suburb` tinytext,
  `post_code` tinytext,
  `phone_number` tinytext,
  `fax_number` tinytext,
  `home_number` tinytext,
  `mobile_number` tinytext,
  `email_address` tinytext,
  `birth_date` datetime DEFAULT NULL,
  `partner_spouse_first_name` tinytext,
  `next_of_kin` tinytext,
  `next_of_kin_phone_no` tinytext,
  `occupation` tinytext,
  `di_ticket` tinyint(1) DEFAULT NULL,
  `duty_pilot` tinyint(1) DEFAULT NULL,
  `instructor` tinytext,
  `form2` tinytext,
  `towpilot` tinyint(1) DEFAULT NULL,
  `membership_expiry_date` date DEFAULT NULL,
  `gfa_expiry_date` date DEFAULT NULL,
  `caravan_expiry_date` date DEFAULT NULL,
  `caravanaircon` tinytext,
  `caravanshare` int(11) DEFAULT NULL,
  `caravannumber` int(11) DEFAULT NULL,
  `caravan_a_cond` tinyint(1) DEFAULT NULL,
  `monthly` tinyint(1) DEFAULT NULL,
  `post_soardid` tinyint(1) DEFAULT NULL,
  `done_check_flight` tinyint(1) DEFAULT NULL,
  `check_flight_due` date DEFAULT NULL,
  `gfa_number` tinytext,
  `solo` tinyint(1) DEFAULT NULL,
  `badge_a` tinyint(1) DEFAULT NULL,
  `badge_b` tinyint(1) DEFAULT NULL,
  `badge_c` tinyint(1) DEFAULT NULL,
  `badge_silver` tinyint(1) DEFAULT NULL,
  `badge_gold` tinyint(1) DEFAULT NULL,
  `badge_diamond` tinyint(1) DEFAULT NULL,
  `badge_distance` tinytext,
  `official_observer` tinyint(1) DEFAULT NULL,
  `notes` varchar(255) DEFAULT NULL,
  `diamond_goal` tinyint(1) DEFAULT NULL,
  `diamond_distance` tinyint(1) DEFAULT NULL,
  `diamond_height` tinyint(1) DEFAULT NULL,
  `gold_duration` tinyint(1) DEFAULT NULL,
  `gold_distance` tinyint(1) DEFAULT NULL,
  `gold_height` tinyint(1) DEFAULT NULL,
  `silver_duration` tinyint(1) DEFAULT NULL,
  `silver_distance` tinyint(1) DEFAULT NULL,
  `silver_height` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`member_id`),
  KEY `first_name` (`first_name`(10)),
  KEY `surname` (`surname`(10))
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `membership_types`
--

DROP TABLE IF EXISTS `membership_types`;
CREATE TABLE IF NOT EXISTS `membership_types` (
  `member_type` tinytext NOT NULL,
  `explanation` tinytext,
  `bss_fee` decimal(10,2) DEFAULT NULL,
  `gfa` decimal(10,2) DEFAULT NULL,
  `caravanfee` decimal(10,2) DEFAULT NULL,
  `airconfee` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`member_type`(2))
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `member_transactions`
--

DROP TABLE IF EXISTS `member_transactions`;
CREATE TABLE IF NOT EXISTS `member_transactions` (
  `member_id` int(11) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `type` tinytext,
  `sequence_number` int(11) NOT NULL,
  `transaction` tinytext,
  `ref_no` tinytext,
  `origin` tinytext,
  `amount` decimal(10,2) DEFAULT NULL,
  `comment` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`sequence_number`),
  KEY `member_id` (`member_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `tugs`
--

DROP TABLE IF EXISTS `tugs`;
CREATE TABLE IF NOT EXISTS `tugs` (
  `registration` text NOT NULL,
  `model` text,
  `seats` int(1) DEFAULT NULL,
  `rate` decimal(10,2) DEFAULT NULL,
  `last_service_date` date DEFAULT NULL,
  `last_service_minutes` int(11) DEFAULT NULL,
  `last_service_landings` int(11) DEFAULT NULL,
  PRIMARY KEY (`registration`(3))
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Stand-in structure for view `vfl`
--
DROP VIEW IF EXISTS `vfl`;
CREATE TABLE IF NOT EXISTS `vfl` (
`flight_date` date
,`flight_number` int(11)
,`glider_registration` tinytext
,`pilot_in_command` varchar(511)
,`second_pilot` varchar(511)
,`flight_type` tinytext
,`tug_registration` tinytext
,`tug_pilot` varchar(511)
,`time_off` varchar(10)
,`tug_down` varchar(10)
,`glider_down` varchar(10)
,`duration` varchar(10)
,`tow_height` tinytext
,`flight_cost` decimal(10,2)
);
-- --------------------------------------------------------

--
-- Structure for view `vfl`
--
DROP TABLE IF EXISTS `vfl`;

CREATE ALGORITHM=UNDEFINED DEFINER=`beverle1`@`localhost` SQL SECURITY DEFINER VIEW `vfl` AS select `f`.`flight_date` AS `flight_date`,`f`.`flight_number` AS `flight_number`,`f`.`glider_registration` AS `glider_registration`,concat(`p`.`first_name`,' ',`p`.`surname`) AS `pilot_in_command`,concat(`c`.`first_name`,' ',`c`.`surname`) AS `second_pilot`,`f`.`flight_type` AS `flight_type`,`f`.`tug_registration` AS `tug_registration`,concat(`t`.`first_name`,' ',`t`.`surname`) AS `tug_pilot`,time_format(`f`.`time_off`,'%H:%i') AS `time_off`,time_format(`f`.`tug_down`,'%H:%i') AS `tug_down`,time_format(`f`.`glider_down`,'%H:%i') AS `glider_down`,time_format(timediff(`f`.`glider_down`,`f`.`time_off`),'%H:%i') AS `duration`,`f`.`tow_height` AS `tow_height`,`f`.`flight_cost` AS `flight_cost` from (((`flight_log` `f` left join `members` `p` on((`f`.`pilot_in_command` = `p`.`member_id`))) left join `members` `c` on((`f`.`second_pilot` = `c`.`member_id`))) left join `members` `t` on((`f`.`tug_pilot` = `t`.`member_id`))) order by `f`.`flight_date` desc,`f`.`flight_number`;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
