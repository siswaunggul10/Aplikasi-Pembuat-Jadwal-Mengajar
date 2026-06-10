-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 04, 2025 at 02:57 PM
-- Server version: 10.4.25-MariaDB
-- PHP Version: 7.4.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_penjadwalan`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbl_guru`
--

CREATE TABLE `tbl_guru` (
  `id_guru` int(11) NOT NULL,
  `nama_guru` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tbl_guru`
--

INSERT INTO `tbl_guru` (`id_guru`, `nama_guru`) VALUES
(4, 'Asep'),
(6, 'Jaenudin'),
(7, 'Rafandra');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_guru_mapel`
--

CREATE TABLE `tbl_guru_mapel` (
  `id_guru_mapel` int(11) NOT NULL,
  `id_guru` int(11) NOT NULL,
  `id_mapel` int(11) NOT NULL,
  `jam_per_minggu` int(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tbl_guru_mapel`
--

INSERT INTO `tbl_guru_mapel` (`id_guru_mapel`, `id_guru`, `id_mapel`, `jam_per_minggu`) VALUES
(4, 4, 1, 24),
(5, 4, 2, 12),
(6, 6, 3, 28),
(7, 7, 7, 24);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_jadwal`
--

CREATE TABLE `tbl_jadwal` (
  `id_jadwal` int(11) NOT NULL,
  `id_waktu` int(11) NOT NULL,
  `id_kelas` int(11) NOT NULL,
  `id_guru_mapel` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Triggers `tbl_jadwal`
--
DELIMITER $$
CREATE TRIGGER `trg_cek_bentrok_guru_insert` BEFORE INSERT ON `tbl_jadwal` FOR EACH ROW BEGIN
    DECLARE guru_id_baru INT;
    DECLARE guru_bentrok INT;
    SELECT id_guru INTO guru_id_baru FROM tbl_guru_mapel WHERE id_guru_mapel = NEW.id_guru_mapel;
    SELECT COUNT(*) INTO guru_bentrok
    FROM tbl_jadwal j
    JOIN tbl_guru_mapel gm ON j.id_guru_mapel = gm.id_guru_mapel
    WHERE j.id_waktu = NEW.id_waktu AND gm.id_guru = guru_id_baru;
    IF guru_bentrok > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Bentrok: Guru ini sudah mengajar di kelas lain pada waktu yang sama.';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_jadwal_wajib`
--

CREATE TABLE `tbl_jadwal_wajib` (
  `id_wajib` int(11) NOT NULL,
  `id_waktu` int(11) NOT NULL,
  `id_kelas` int(11) NOT NULL,
  `id_guru_mapel` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_kelas`
--

CREATE TABLE `tbl_kelas` (
  `id_kelas` int(11) NOT NULL,
  `nama_kelas` varchar(50) NOT NULL,
  `jumlah_jam_per_hari` int(2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tbl_kelas`
--

INSERT INTO `tbl_kelas` (`id_kelas`, `nama_kelas`, `jumlah_jam_per_hari`) VALUES
(1, '7A', 8),
(2, '7B', 9),
(3, '7C', 8);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_mata_pelajaran`
--

CREATE TABLE `tbl_mata_pelajaran` (
  `id_mapel` int(11) NOT NULL,
  `nama_mapel` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tbl_mata_pelajaran`
--

INSERT INTO `tbl_mata_pelajaran` (`id_mapel`, `nama_mapel`) VALUES
(3, 'Bahasa Indonesia'),
(1, 'bahasa Inggris'),
(7, 'IPA'),
(2, 'matematika');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_waktu_pelajaran`
--

CREATE TABLE `tbl_waktu_pelajaran` (
  `id_waktu` int(11) NOT NULL,
  `hari` varchar(20) NOT NULL,
  `jam_ke` int(2) NOT NULL,
  `range_waktu` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tbl_waktu_pelajaran`
--

INSERT INTO `tbl_waktu_pelajaran` (`id_waktu`, `hari`, `jam_ke`, `range_waktu`) VALUES
(1, 'Senin', 1, '07.00 - 07.40'),
(2, 'Senin', 2, '07.40 - 08.20'),
(3, 'Selasa', 1, '07.00 - 07.40'),
(4, 'Selasa', 2, '07.40 - 08.20'),
(5, 'Rabu', 1, '07.00 - 07.40'),
(6, 'Rabu', 2, '07.40 - 08.20');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_guru`
--
ALTER TABLE `tbl_guru`
  ADD PRIMARY KEY (`id_guru`),
  ADD UNIQUE KEY `nama_guru` (`nama_guru`);

--
-- Indexes for table `tbl_guru_mapel`
--
ALTER TABLE `tbl_guru_mapel`
  ADD PRIMARY KEY (`id_guru_mapel`),
  ADD UNIQUE KEY `guru_mapel_unik` (`id_guru`,`id_mapel`),
  ADD KEY `fk_gm_mapel` (`id_mapel`);

--
-- Indexes for table `tbl_jadwal`
--
ALTER TABLE `tbl_jadwal`
  ADD PRIMARY KEY (`id_jadwal`),
  ADD UNIQUE KEY `slot_kelas_unik` (`id_waktu`,`id_kelas`),
  ADD KEY `fk_jadwal_gm` (`id_guru_mapel`);

--
-- Indexes for table `tbl_jadwal_wajib`
--
ALTER TABLE `tbl_jadwal_wajib`
  ADD PRIMARY KEY (`id_wajib`),
  ADD UNIQUE KEY `slot_wajib_unik` (`id_waktu`,`id_kelas`),
  ADD KEY `fk_wajib_gm` (`id_guru_mapel`);

--
-- Indexes for table `tbl_kelas`
--
ALTER TABLE `tbl_kelas`
  ADD PRIMARY KEY (`id_kelas`),
  ADD UNIQUE KEY `nama_kelas` (`nama_kelas`);

--
-- Indexes for table `tbl_mata_pelajaran`
--
ALTER TABLE `tbl_mata_pelajaran`
  ADD PRIMARY KEY (`id_mapel`),
  ADD UNIQUE KEY `nama_mapel` (`nama_mapel`);

--
-- Indexes for table `tbl_waktu_pelajaran`
--
ALTER TABLE `tbl_waktu_pelajaran`
  ADD PRIMARY KEY (`id_waktu`),
  ADD UNIQUE KEY `hari_jam` (`hari`,`jam_ke`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_guru`
--
ALTER TABLE `tbl_guru`
  MODIFY `id_guru` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `tbl_guru_mapel`
--
ALTER TABLE `tbl_guru_mapel`
  MODIFY `id_guru_mapel` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `tbl_jadwal`
--
ALTER TABLE `tbl_jadwal`
  MODIFY `id_jadwal` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_jadwal_wajib`
--
ALTER TABLE `tbl_jadwal_wajib`
  MODIFY `id_wajib` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_kelas`
--
ALTER TABLE `tbl_kelas`
  MODIFY `id_kelas` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `tbl_mata_pelajaran`
--
ALTER TABLE `tbl_mata_pelajaran`
  MODIFY `id_mapel` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `tbl_waktu_pelajaran`
--
ALTER TABLE `tbl_waktu_pelajaran`
  MODIFY `id_waktu` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `tbl_guru_mapel`
--
ALTER TABLE `tbl_guru_mapel`
  ADD CONSTRAINT `fk_gm_guru` FOREIGN KEY (`id_guru`) REFERENCES `tbl_guru` (`id_guru`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_gm_mapel` FOREIGN KEY (`id_mapel`) REFERENCES `tbl_mata_pelajaran` (`id_mapel`) ON DELETE CASCADE;

--
-- Constraints for table `tbl_jadwal`
--
ALTER TABLE `tbl_jadwal`
  ADD CONSTRAINT `fk_jadwal_gm` FOREIGN KEY (`id_guru_mapel`) REFERENCES `tbl_guru_mapel` (`id_guru_mapel`) ON DELETE CASCADE;

--
-- Constraints for table `tbl_jadwal_wajib`
--
ALTER TABLE `tbl_jadwal_wajib`
  ADD CONSTRAINT `fk_wajib_gm` FOREIGN KEY (`id_guru_mapel`) REFERENCES `tbl_guru_mapel` (`id_guru_mapel`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
