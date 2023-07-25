﻿use master
go
if DB_ID('QLGV') is not NULL
	drop database QLGV
go

create database QLGV
go

use QLGV
go

create table GIAOVIEN
(
	MAGV CHAR(3),
	HOTEN NVARCHAR(50),
	LUONG INT,
	PHAI NVARCHAR(10),
	NGSINH DATE,
	DIACHI NVARCHAR(50),
	GVQLCM CHAR(3),
	MABM VARCHAR(10)

	CONSTRAINT PK_GV
	PRIMARY KEY (MAGV)
)

create table BOMON
(
	MABM VARCHAR(10),
	TENBM NVARCHAR(50),
	PHONG CHAR(3),
	DIENTHOAI VARCHAR(10),
	TRUONGBM CHAR(3),
	MAKHOA VARCHAR(10),
	NGAYNHANCHUC DATE

	CONSTRAINT PK_BM
	PRIMARY KEY (MABM)
)

create table KHOA
(
	MAKHOA VARCHAR(10),
	TENKHOA NVARCHAR(50),
	NAMTL INT,
	PHONG CHAR(3),
	DIENTHOAI CHAR(10),
	TRUONGKHOA CHAR(3),
	NGAYNHANCHUC DATE

	CONSTRAINT PK_KHOA
	PRIMARY KEY (MAKHOA)
)

create table GV_DT
(
	MAGV CHAR(3),
	DIENTHOAI CHAR(10)

	CONSTRAINT PK_GVDT
	PRIMARY KEY (MAGV, DIENTHOAI)
)

create table NGUOITHAN
(
	MAGV CHAR(3),
	TEN NVARCHAR(50),
	NGSINH DATE,
	PHAI NVARCHAR(10),
	QUANHE NVARCHAR(15)

	CONSTRAINT PK_NGUOITHAN
	PRIMARY KEY (MAGV, TEN)
)

create table THAMGIADT
(
	MAGV CHAR(3),
	MADT CHAR(3),
	STT INT,
	PHUCAP FLOAT,
	KETQUA NVARCHAR(30)

	CONSTRAINT PK_THAMGIADT
	PRIMARY KEY (MAGV, MADT, STT)
)

create table CONGVIEC
(
	MADT CHAR(3),
	STT INT,
	TENCV NVARCHAR(50),
	NGAYBD DATE,
	NGAYKT DATE,

	CONSTRAINT PK_CONGVIEC
	PRIMARY KEY (MADT, STT)
)

create table DETAI
(
	MADT CHAR(3),
	TENDT NVARCHAR(50),
	CAPQL NVARCHAR(50),
	KINHPHI INT,
	NGAYBD DATE,
	NGAYKT DATE,
	MACD VARCHAR(10),
	GVCNDT CHAR(3)

	CONSTRAINT PK_DETAI
	PRIMARY KEY (MADT)
)

create table CHUDE
(
	MACD VARCHAR(10),
	TENCD NVARCHAR(50)

	CONSTRAINT PK_CHUDE
	PRIMARY KEY (MACD)
)

alter table GIAOVIEN
add
	CONSTRAINT FK_GV_BM
	FOREIGN KEY (MABM)
	REFERENCES BOMON,

	CONSTRAINT FK_GV_GVQLCM
	FOREIGN KEY (GVQLCM)
	REFERENCES GIAOVIEN

alter table BOMON
add
	CONSTRAINT FK_BM_K
	FOREIGN KEY (MAKHOA)
	REFERENCES KHOA,

	CONSTRAINT FK_BM_GV
	FOREIGN KEY (TRUONGBM)
	REFERENCES GIAOVIEN

alter table KHOA
add 
	CONSTRAINT FK_K_GV
	FOREIGN KEY (TRUONGKHOA)
	REFERENCES GIAOVIEN

alter table GV_DT
add
	CONSTRAINT FK_GVDT_GV
	FOREIGN KEY (MAGV)
	REFERENCES GIAOVIEN

alter table NGUOITHAN
add
	CONSTRAINT FK_NT_GV
	FOREIGN KEY (MAGV)
	REFERENCES GIAOVIEN

alter table THAMGIADT
add
	CONSTRAINT FK_TGDT_GV
	FOREIGN KEY (MAGV)
	REFERENCES GIAOVIEN,

	CONSTRAINT FK_TGDT_CV
	FOREIGN KEY (MADT, STT)
	REFERENCES CONGVIEC

alter table CONGVIEC
add 
	CONSTRAINT FK_CV_DT
	FOREIGN KEY (MADT)
	REFERENCES DETAI

alter table DETAI
add
	CONSTRAINT FK_DT_GV
	FOREIGN KEY (GVCNDT)
	REFERENCES GIAOVIEN,

	CONSTRAINT FK_DT_CD
	FOREIGN KEY (MACD)
	REFERENCES CHUDE

-- INSERT ORDER: BOMON --> GIAOVIEN --> KHOA
INSERT BOMON
VALUES
	('CNTT', N'Công nghệ tri thức', 'B15','0838126126', NULL, NULL, NULL ),
	('HHC', N'Hóa huữ cơ', 'B44','838222222', NULL, NULL, NULL ),
	('HL', N'Hóa lý', 'B42','0838878787', NULL, NULL, NULL ),
	('HPT', N'Hóa phân tích', 'B43','0838777777', NULL, NULL, '10-15-2007' ),
	('HTTT', N'Hệ thống thông tin', 'B13','0838125125', NULL, NULL, '9-20-2004'),
	('MMT', N'Mạng máy tính', 'B16','0838676767', NULL, NULL, '5-15-2005'),
	('SH', N'Sinh hóa', 'B33','0838898989', NULL, NULL, NULL),
	('VLĐT', N'Vật lý điện tử', 'B23','0838234234', NULL, NULL, NULL),
	('VLƯD', N'Vật lý ứng dụng', 'B24','0838454545', NULL, NULL, '2-18-2006'),
	('VS', N'Vi sinh', 'B32','0838909090', NULL, NULL, '1-1-2007')

INSERT GIAOVIEN
VALUES
	('001', N'Nguyễn Hoài An', 2000, 'Nam', '2-15-1973', N'25/3 Lạc Long Quân, Q.10, TP HCM', NULL, 'MMT'),
	('002', N'Trần Trà Hương', 2500, N'Nữ', '6-20-1960', N'125 Trần Hưng Đạo, Q.1, TP HCM', NULL, 'HTTT'),
	('003', N'Nguyễn Ngọc Ánh', 2200, N'Nữ', '5-11-1975', N'12/21 Võ Văn Ngân Thủ Đức, TP HCM', '002', 'HTTT'),
	('004', N'Trương Nam Sơn', 2300, 'Nam', '6-20-1959', N'215 Lạc Long Quân, TP Biên Hòa', NULL, 'VS'),
	('005', N'Lý Hoàng Hà', 2500, 'Nam', '10-23-1954', N'22/5 Nguyễn Xí, Q.Bình Thạnh, TP HCM', NULL, 'VLĐT'),
	('006', N'Trần Bạch Tuyết', 1500, N'Nữ', '5-20-1980', N'127 Hùng Vương, TP Mỹ Tho', '004', 'VS'),
	('007', N'Nguyễn An Trung', 2100, 'Nam', '6-5-1976', N'234 3/2, TP Biên Hòa', NULL, 'HPT'),
	('008', N'Trần Trung Hiếu', 1800, 'Nam', '11-22-1977', N'22/11 Lý Thường Kiệt, TP Mỹ Tho', '007', 'HPT'),
	('009', N'Trần Hoàng Nam', 2000, 'Nam', '11-22-1975', N'234 Trần Não, An Phú, TP HCM', '001', 'MMT'),
	('010', N'Phạm Nam Thanh', 1500, 'Nam', '12-12-1980', N'221 Hùng Vương, Q.5, TP HCM', '007', 'HPT')

INSERT KHOA
VALUES
	('CNTT', N'Công nghệ thông tin', 1995, 'B11', '0838123456', '002','02-20-2005'),
	('HH', N'Hóa học', 1980, 'B41', '0838456456', '007','10-15-2001'),
	('SH', N'Sinh học', 1980, 'B31', '0838454545', '004','10-11-2000'),
	('VL', N'Vật lý', 1976, 'B21', '0838223223', '005','09-18-2003')

-- UPDATE DATA 
---- Set TRUONGBM và MAKHOA cho BOMON 
UPDATE BOMON
SET TRUONGBM = '007', MAKHOA = 'HH'
WHERE MABM = 'HPT'
UPDATE BOMON
SET TRUONGBM = '002', MAKHOA = 'CNTT'
WHERE MABM = 'HTTT'
UPDATE BOMON
SET TRUONGBM = '001', MAKHOA = 'CNTT'
WHERE MABM = 'MMT'
UPDATE BOMON
SET TRUONGBM = '005', MAKHOA = 'VL'
WHERE MABM = 'VLUD'
UPDATE BOMON
SET TRUONGBM = '004', MAKHOA = 'SH'
WHERE MABM = 'VS'

INSERT GV_DT
VALUES
	('001','0838912112'),
	('001','0903123123'),
	('002','0913454545'),
	('003','0838121212'),
	('003','0903656565'),
	('003','0937125125'),
	('006','0937888888'),
	('008','0653717171'),
	('008','0913232323')

INSERT NGUOITHAN
VALUES
	('001',N'Hùng','01-14-1990','Nam','Con'),
	('001',N'Thủy','12-8-1994',N'Nữ','Vợ'),
	('003',N'Hà','9-3-1998',N'Nữ','Con'),
	('003',N'Thu','9-3-1998',N'Nữ','Con'),
	('007',N'Mai','3-26-2003',N'Nữ','Con'),
	('007',N'Vy','2-14-2000',N'Nữ','Con'),
	('008',N'Nam','05-06-1991','Nam','Cháu'),
	('009',N'An','08-19-1996','Nam','Em'),
	('010',N'Nguyệt','1-14-2006',N'Nữ','Con')

INSERT CHUDE 
VALUES 
	('NCPT', N'Nghiên cứu phát triển'),
	('QLGD', N'Quản lý giáo dục'),
	('UDCN', N'Ứng dụng công nghệ')

INSERT DETAI 
VALUES 
	('001',N'HTTT quản lý các trường ĐH','ĐHQG',20,'10-20-2007','10-20-2008','QLGD','002'),
	('002',N'HTTT quản lý cho một khoa',N'Trường',20,'10-12-2000','10-12-2001','QLGD','002'),
	('003',N'Nghiên cứu chế tạo sợi Nanô Platin','ĐHQG',300,'5-15-2008','5-15-2010','NCPT','005'),
	('004',N'Tạo vật liệu sinh học bằng màng ối người',N'Nhà nước',100,'1-1-2007','12-31-2009','NCPT','004'),
	('005',N'Ứng dụng hóa học xanh',N'Trường',200,'10-10-2003','12-10-2004','UDCN','007'),
	('006',N'Nghiên cứu tế bào gốc',N'Nhà nước',4000,'10-20-2006','10-20-2009','NCPT','004'),
	('007',N'HTTT quản lý thư viện ở các trường ĐH',N'Trường',20,'5-10-2009','5-10-2010','QLGD','001')

INSERT CONGVIEC 
VALUES 
	('001', 1, N'Khởi tạo và Lập kế hoạch','10-20-2007', '12-20-2008'),
	('001', 2, N'Xác định yêu cầu','12-21-2008', '3-21-2008'),
	('001', 3, N'Phân tích hệ thống','3-22-2008', '5-22-2008'),
	('001', 4, N'Thiết kế hệ thống','5-23-2008', '6-23-2008'),
	('001', 5, N'Cài đặt thử nghiệm','6-24-2008', '10-20-2008'),
	('002', 1, N'Khởi tạo và Lập kế hoạch','5-10-2009', '7-10-2009'),
	('002', 2, N'Xác định yêu cầu','7-11-2009', '10-11-2009'),
	('002', 3, N'Phân tích hệ thống','10-12-2009', '12-20-2009'),
	('002', 4, N'Thiết kế hệ thống','12-21-2009', '3-22-2010'),
	('002', 5, N'Cài đặt thử nghiệm','3-23-2010', '5-10-2010'),
	('006', 1, N'Lấy mẫu','10-20-2006', '2-20-2007'),
	('006', 2, N'Nuôi cấy','2-21-2007', '8-21-2008')

INSERT THAMGIADT 
VALUES 
	('001', '002', 1, 0.0, NULL),
	('001', '002', 2, 2.0, NULL),
	('002', '001', 4, 2.0, N'Đạt'),
	('003', '001', 1, 1.0, N'Đạt'),
	('003', '001', 2, 0.0, N'Đạt'),
	('003', '001', 4, 1.0, N'Đạt'),
	('003', '002', 2, 0.0, NULL),
	('004', '006', 1, 0.0, N'Đạt'),
	('004', '006', 2, 1.0, N'Đạt'),
	('006', '006', 2, 1.5, N'Đạt'),
	('009', '002', 3, 0.5, NULL),
	('009', '002', 4, 1.5, NULL)

--Q58. Cho biết GV nào mà tham gia đầy đủ các đề tài
SELECT GV.*
FROM GIAOVIEN GV
WHERE NOT EXISTS (SELECT MADT
					FROM DETAI DT
					EXCEPT
					SELECT MADT
					FROM THAMGIADT TG
					WHERE TG.MAGV=GV.MAGV)
--Q59. Cho biết tên đề tài nào mà được tất cả các giáo viên của bộ môn HTTT tham gia. 
SELECT DT.*
FROM DETAI DT
WHERE NOT EXISTS (SELECT MAGV
					FROM GIAOVIEN GV
					WHERE GV.MABM='HTTT'
					EXCEPT
					SELECT MAGV
					FROM THAMGIADT TG
					WHERE TG.MADT=DT.MADT)
--Q60. Cho biết tên đề tài có tất cả giảng viên bộ môn “Hệ thống thông tin” tham gia
SELECT DT.TENDT
FROM DETAI DT
WHERE NOT EXISTS (SELECT MAGV
					FROM GIAOVIEN GV
					LEFT JOIN BOMON BM ON BM.MABM=GV.MABM
					WHERE BM.TENBM=N'HỆ THỐNG THÔNG TIN'  
					EXCEPT 
					SELECT MAGV
					FROM THAMGIADT TG
					WHERE TG.MADT=DT.MADT
				)
--Q61. Cho biết giáo viên nào đã tham gia tất cả các đề tài có mã chủ đề là QLGD.
SELECT TG.MAGV
FROM THAMGIADT TG
JOIN GIAOVIEN GV ON TG.MAGV = GV.MAGV
WHERE TG.MADT IN (SELECT DT.MADT FROM DETAI DT WHERE DT.MACD='QLGD')
GROUP BY TG.MAGV
HAVING COUNT(DISTINCT TG.MADT) = (SELECT COUNT(*) FROM DETAI DT WHERE DT.MACD='QLGD')

SELECT GV.*
FROM GIAOVIEN GV
WHERE NOT EXISTS (SELECT DT.MADT
					FROM DETAI DT
					WHERE DT.MACD='QLGD'
					EXCEPT
					SELECT TG.MADT
					FROM THAMGIADT TG
					WHERE TG.MAGV=GV.MAGV)

--Q62. Cho biết tên giáo viên nào tham gia tất cả các đề tài mà giáo viên Trần Trà Hương đã tham gia.
SELECT GV.HOTEN
FROM GIAOVIEN GV
WHERE NOT EXISTS (SELECT DT.MADT
				FROM DETAI DT
				JOIN THAMGIADT TG1 ON TG1.MADT=DT.MADT
				JOIN GIAOVIEN GV1 ON GV1.MAGV=TG1.MAGV
				WHERE GV1.HOTEN=N'TRẦN TRÀ HƯƠNG' 
				EXCEPT
				SELECT TG.MADT
				FROM THAMGIADT TG
				WHERE TG.MAGV=GV.MAGV)

SELECT GV.HOTEN
FROM THAMGIADT TG
JOIN GIAOVIEN GV ON GV.MAGV=TG.MAGV
WHERE TG.MADT IN (SELECT DT.MADT
					FROM DETAI DT
					JOIN THAMGIADT TG ON TG.MADT=DT.MADT
					JOIN GIAOVIEN GV1 ON GV1.MAGV=TG.MAGV
					WHERE GV1.HOTEN=N'TRẦN TRÀ HƯƠNG')
GROUP BY GV.HOTEN, GV.MAGV, TG.MADT
HAVING COUNT(DISTINCT TG.MADT)=(SELECT DISTINCT DT.MADT
					FROM DETAI DT
					JOIN THAMGIADT TG ON TG.MADT=DT.MADT
					JOIN GIAOVIEN GV1 ON GV1.MAGV=TG.MAGV
					WHERE GV1.HOTEN=N'TRẦN TRÀ HƯƠNG'
					)

--Q63. Cho biết tên đề tài nào mà được tất cả các giáo viên của bộ môn Hóa Hữu Cơ tham gia. 
SELECT DT.TENDT
FROM DETAI DT
WHERE NOT EXISTS (SELECT GV.MAGV
					FROM GIAOVIEN GV
					JOIN BOMON BM ON BM.MABM=GV.MABM
					WHERE BM.TENBM=N'HÓA HỮU CƠ'
					EXCEPT
					SELECT TG.MAGV
					FROM THAMGIADT TG
					WHERE TG.MADT=DT.MADT
)

--Q64. Cho biết tên giáo viên nào mà tham gia tất cả các công việc của đề tài 006.
 SELECT GV.HOTEN
 FROM GIAOVIEN GV
 WHERE NOT EXISTS (SELECT CV.STT
					FROM CONGVIEC CV
					WHERE CV.MADT='006'
					EXCEPT
					SELECT TG.STT
					FROM THAMGIADT TG
					WHERE TG.MAGV=GV.MAGV AND TG.MADT='006')
--Q65. Cho biết giáo viên nào đã tham gia tất cả các đề tài của chủ đề Ứng dụng công nghệ.
SELECT GV.*
FROM GIAOVIEN GV
WHERE NOT EXISTS (SELECT DT.MADT
					FROM DETAI DT
					JOIN CHUDE CD ON CD.MACD=DT.MACD
					WHERE CD.TENCD=N'ỨNG DỤNG CÔNG NGHỆ'
					EXCEPT
					SELECT TG.MADT
					FROM THAMGIADT TG
					WHERE TG.MAGV=GV.MAGV
					)
--Q66. Cho biết tên giáo viên nào đã tham gia tất cả các đề tài của do Trần Trà Hương làm chủ
--nhiệm.
SELECT GV.HOTEN
FROM GIAOVIEN GV
WHERE NOT EXISTS (SELECT DT.MADT
					FROM GIAOVIEN GV1
					JOIN DETAI DT ON DT.GVCNDT=GV1.MAGV
					WHERE GV1.HOTEN=N'TRẦN TRÀ HƯƠNG'
					EXCEPT
					SELECT TG.MADT
					FROM THAMGIADT TG
					WHERE TG.MAGV=GV.MAGV)
--Q67. Cho biết tên đề tài nào mà được tất cả các giáo viên của khoa CNTT tham gia.
SELECT DT.TENDT
FROM DETAI DT
WHERE NOT EXISTS (SELECT GV.MAGV
					FROM GIAOVIEN GV
					JOIN BOMON BM ON BM.MABM=GV.MABM
					JOIN KHOA K ON K.MAKHOA=BM.MAKHOA
					WHERE K.MAKHOA='CNTT'
					EXCEPT
					SELECT TG.MAGV
					FROM THAMGIADT TG
					WHERE TG.MADT=DT.MADT)
--Q68. Cho biết tên giáo viên nào mà tham gia tất cả các công việc của đề tài Nghiên cứu tế bào gốc.
SELECT GV.HOTEN
FROM GIAOVIEN GV
WHERE NOT EXISTS (SELECT CV.MADT, CV.STT
					FROM CONGVIEC CV
					JOIN DETAI DT ON DT.MADT=CV.MADT
					WHERE DT.TENDT=N'NGHIÊN CỨU TẾ BÀO GỐC'
					EXCEPT
					SELECT TG.MADT, TG.STT
					FROM THAMGIADT TG
					WHERE TG.MAGV=GV.MAGV)
--Q69. Tìm tên các giáo viên được phân công làm tất cả các đề tài có kinh phí trên 100 triệu? 
SELECT GV.HOTEN
FROM GIAOVIEN GV
WHERE NOT EXISTS (SELECT DT.MADT
					FROM DETAI DT
					WHERE DT.KINHPHI>100
					EXCEPT
					SELECT TG.MADT
					FROM THAMGIADT TG
					WHERE TG.MAGV=GV.MAGV)
--Q70. Cho biết tên đề tài nào mà được tất cả các giáo viên của khoa Sinh Học tham gia. 
SELECT DT.TENDT
FROM DETAI DT
WHERE NOT EXISTS (SELECT GV.MAGV
					FROM GIAOVIEN GV
					JOIN BOMON BM ON BM.MABM=GV.MABM
					JOIN KHOA K ON K.MAKHOA=BM.MAKHOA
					WHERE K.TENKHOA=N'SINH HỌC'
					EXCEPT
					SELECT TG.MAGV
					FROM THAMGIADT TG
					WHERE TG.MADT=DT.MADT
					)
--Q71. Cho biết mã số, họ tên, ngày sinh của giáo viên tham gia tất cả các công việc của đề tài “Ứng dụng hóa học xanh”.
SELECT GV.MAGV, GV.HOTEN, GV.NGSINH
FROM GIAOVIEN GV
JOIN THAMGIADT TG ON GV.MAGV = TG.MAGV
JOIN DETAI DT ON DT.MADT = TG.MADT
WHERE DT.TENDT = N'ỨNG DỤNG HÓA HỌC XANH'
GROUP BY GV.MAGV, GV.HOTEN, GV.NGSINH
HAVING COUNT(DISTINCT DT.MADT) = (
    SELECT COUNT(DISTINCT MADT)
    FROM DETAI
    WHERE TENDT = N'ỨNG DỤNG HÓA HỌC XANH'
)
SELECT GV.MAGV, GV.HOTEN, GV.NGSINH
FROM GIAOVIEN GV
WHERE NOT EXISTS (
    SELECT DT.MADT
    FROM DETAI DT
    WHERE DT.TENDT = N'ỨNG DỤNG HÓA HỌC XANH'
    AND NOT EXISTS (
        SELECT TG.MAGV
        FROM THAMGIADT TG
        WHERE TG.MADT = DT.MADT AND TG.MAGV = GV.MAGV
    )
)
SELECT GV.MAGV, GV.HOTEN, GV.NGSINH
FROM GIAOVIEN GV
WHERE NOT EXISTS (SELECT DT.MADT
					FROM DETAI DT 
					WHERE DT.TENDT=N'ỨNG DỤNG HÓA HỌC XANH'
					EXCEPT
					SELECT TG.MADT
					FROM THAMGIADT TG
					WHERE TG.MAGV=GV.MAGV)
--Q72. Cho biết mã số, họ tên, tên bộ môn và tên  Quản lý chuyên môn của giáo viên
--tham gia tất cả các đề tài thuộc chủ đề “Nghiên cứu phát triển”.
SELECT GV.MAGV, GV.HOTEN, BM.TENBM, QL.HOTEN
FROM GIAOVIEN GV
JOIN GIAOVIEN QL ON QL.MAGV=GV.GVQLCM
JOIN BOMON BM ON BM.MABM=GV.MABM
WHERE NOT EXISTS (SELECT DT.MADT
					FROM DETAI DT
					JOIN CHUDE CD ON CD.MACD=DT.MACD
					WHERE CD.TENCD=N'NGHIÊN CỨU PHÁT TRIỂN'
					EXCEPT
					SELECT TG.MADT
					FROM THAMGIADT TG
					WHERE TG.MAGV=GV.MAGV)