-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 24, 2022 at 04:53 PM
-- Server version: 10.4.21-MariaDB
-- PHP Version: 7.4.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `two_square_game`
--

-- --------------------------------------------------------

--
-- Table structure for table `rooms_two_square_game`
--

CREATE TABLE `rooms_two_square_game` (
  `id` int(11) NOT NULL,
  `numOfPlayer` int(11) NOT NULL,
  `id_user1` int(11) NOT NULL DEFAULT 1,
  `id_user2` int(11) DEFAULT NULL,
  `id_user3` int(11) DEFAULT NULL,
  `id_user4` int(11) DEFAULT NULL,
  `started` tinyint(4) NOT NULL,
  `turn` int(11) NOT NULL DEFAULT 1,
  `board` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`board`)),
  `boardSize` int(11) NOT NULL,
  `totalGameNum` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `users_two_square_game`
--

CREATE TABLE `users_two_square_game` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `rooms_two_square_game`
--
ALTER TABLE `rooms_two_square_game`
  ADD UNIQUE KEY `id` (`id`);

--
-- Indexes for table `users_two_square_game`
--
ALTER TABLE `users_two_square_game`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `users_two_square_game`
--
ALTER TABLE `users_two_square_game`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
