DROP TABLE IF EXISTS `tbl_guru_kelas`;
CREATE TABLE `tbl_penugasan_kelas` (
  `id_penugasan_kelas` int(11) NOT NULL AUTO_INCREMENT,
  `id_guru_mapel` int(11) NOT NULL,
  `id_kelas` int(11) NOT NULL,
  PRIMARY KEY (`id_penugasan_kelas`),
  UNIQUE KEY `penugasan_kelas_unique` (`id_guru_mapel`,`id_kelas`),
  FOREIGN KEY (`id_guru_mapel`) REFERENCES `tbl_guru_mapel` (`id_guru_mapel`) ON DELETE CASCADE,
  FOREIGN KEY (`id_kelas`) REFERENCES `tbl_kelas` (`id_kelas`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;