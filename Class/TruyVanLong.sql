﻿use master
go
if DB_ID('QLGV_TGDT') is not null
	drop database QLGV_TGDT
go

create database QLGV_TGDT
go

use QLGV_TGDT
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

-- Nhap lieu: BOMON --> GIAOVIEN --> KHOA
INSERT BOMON
VALUES
	('CNTT', N'Công nghệ tri thức', 'B15','0838126126', null, null, null ),
	('HHC', N'Hóa huữ cơ', 'B44','838222222', null, null, null ),
	('HL', N'Hóa lý', 'B42','0838878787', null, null, null ),
	('HPT', N'Hóa phân tích', 'B43','0838777777', null, null, '10-15-2007' ),
	('HTTT', N'Hệ thống thông tin', 'B13','0838125125', null, null, '9-20-2004'),
	('MMT', N'Mạng máy tính', 'B16','0838676767', null, null, '5-15-2005'),
	('SH', N'Sinh hóa', 'B33','0838898989', null, null, null),
	('VLĐT', N'Vật lý điện tử', 'B23','0838234234', null, null, null),
	('VLƯD', N'Vật lý ứng dụng', 'B24','0838454545', null, null, '2-18-2006'),
	('VS', N'Vi sinh', 'B32','0838909090', null, null, '1-1-2007')

INSERT GIAOVIEN
VALUES
	('001', N'Nguyễn Hoài An', 2000, 'Nam', '2-15-1973', N'25/3 Lạc Long Quân, Q.10, TP HCM', null, 'MMT'),
	('002', N'Trần Trà Hương', 2500, N'Nữ', '6-20-1960', N'125 Trần Hưng Đạo, Q.1, TP HCM', null, 'HTTT'),
	('003', N'Nguyễn Ngọc Ánh', 2200, N'Nữ', '5-11-1975', N'12/21 Võ Văn Ngân Thủ Đức, TP HCM', '002', 'HTTT'),
	('004', N'Trương Nam Sơn', 2300, 'Nam', '6-20-1959', N'215 Lạc Long Quân, TP Biên Hòa', null, 'VS'),
	('005', N'Lý Hoàng Hà', 2500, 'Nam', '10-23-1954', N'22/5 Nguyễn Xí, Q.Bình Thạnh, TP HCM', null, 'VLĐT'),
	('006', N'Trần Bạch Tuyết', 1500, N'Nữ', '5-20-1980', N'127 Hùng Vương, TP Mỹ Tho', '004', 'VS'),
	('007', N'Nguyễn An Trung', 2100, 'Nam', '6-5-1976', N'234 3/2, TP Biên Hòa', null, 'HPT'),
	('008', N'Trần Trung Hiếu', 1800, 'Nam', '11-22-1977', N'22/11 Lý Thường Kiệt, TP Mỹ Tho', '007', 'HPT'),
	('009', N'Trần Hoàng Nam', 2000, 'Nam', '11-22-1975', N'234 Trần Não, An Phú, TP HCM', '001', 'MMT'),
	('010', N'Phạm Nam Thanh', 1500, 'Nam', '12-12-1980', N'221 Hùng Vương, Q.5, TP HCM', '007', 'HPT')

INSERT KHOA
VALUES
	('CNTT', N'Công nghệ thông tin', 1995, 'B11', '0838123456', '002','02-20-2005'),
	('HH', N'Hóa học', 1980, 'B41', '0838456456', '007','10-15-2001'),
	('SH', N'Sinh học', 1980, 'B31', '0838454545', '004','10-11-2000'),
	('VL', N'Vật lý', 1976, 'B21', '0838223223', '005','09-18-2003')

-- Cập nhật dữ liệu 
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
WHERE MABM = 'VLƯD'
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
	('001', '002', 1, 0.0, null),
	('001', '002', 2, 2.0, null),
	('002', '001', 4, 2.0, N'Đạt'),
	('003', '001', 1, 1.0, N'Đạt'),
	('003', '001', 2, 0.0, N'Đạt'),
	('003', '001', 4, 1.0, N'Đạt'),
	('003', '002', 2, 0.0, null),
	('004', '006', 1, 0.0, N'Đạt'),
	('004', '006', 2, 1.0, N'Đạt'),
	('006', '006', 2, 1.5, N'Đạt'),
	('009', '002', 3, 0.5, null),
	('009', '002', 4, 1.5, null)

--BÀI TẬP TRUY VẤN
--1. CHO BIẾT HOTEN, LƯƠNG CỦA GIÁO VIÊN LỚN TUỔI HƠN TRƯỞNG BỘ MÔN CỦA MÌNH
SELECT GV.HOTEN, GV.LUONG
FROM GIAOVIEN GV
JOIN GIAOVIEN TBM ON GV.MABM=TBM.MABM
JOIN BOMON BM ON BM.TRUONGBM=TBM.MAGV
WHERE YEAR(GV.NGSINH)<YEAR(TBM.NGSINH)
--2. CHO BIẾT MAGV, HỌ TÊN, SỐ NGƯỜI THÂN, SỐ CON (THÊM THUỘC TÍNH QUAN HỆ 
--VÀO BẢNG NGƯỜI THÂN), SỐ ĐỀ TÀI CHỦ NHIỆM TRONG NĂM 2000

SELECT DISTINCT GV.MAGV, GV.HOTEN, SNT.SONT,SC.SOCON, DT.SODT
FROM GIAOVIEN GV, (SELECT MAGV, COUNT(MAGV) AS SONT
							FROM NGUOITHAN NT
							GROUP BY MAGV
							) SNT,
							(SELECT MAGV, COUNT(TEN) SOCON
							FROM NGUOITHAN NT
							WHERE NT.QUANHE='CON'
							GROUP BY MAGV
							) SC,
							(SELECT GVCNDT, COUNT(GVCNDT) SODT
							FROM DETAI DT
							WHERE DT.NGAYBD LIKE '%2000%'
							GROUP BY GVCNDT) DT
WHERE GV.MAGV=SNT.MAGV AND GV.MAGV=SC.MAGV

--LỒNG Ở SELECT
SELECT GV.MAGV, GV.HOTEN,
  (SELECT COUNT(MAGV) FROM NGUOITHAN WHERE MAGV = GV.MAGV) AS SONT,
  (SELECT COUNT(TEN) FROM NGUOITHAN WHERE MAGV = GV.MAGV AND QUANHE = 'CON') AS SOCON,
  (SELECT COUNT(GVCNDT) FROM DETAI WHERE GVCNDT = GV.MAGV AND NGAYBD LIKE '%2000%') AS SODT
FROM GIAOVIEN GV;
--LỒNG Ở WHERE
SELECT GV.MAGV, GV.HOTEN, SNT.SONT, SC.SOCON, DT.SODT
FROM GIAOVIEN GV
LEFT JOIN (
    SELECT MAGV, COUNT(MAGV) AS SONT
    FROM NGUOITHAN
    GROUP BY MAGV
) SNT ON GV.MAGV = SNT.MAGV
LEFT JOIN (
    SELECT MAGV, COUNT(TEN) AS SOCON
    FROM NGUOITHAN
    WHERE QUANHE = 'CON'
    GROUP BY MAGV
) SC ON GV.MAGV = SC.MAGV
LEFT JOIN (
    SELECT GVCNDT, COUNT(GVCNDT) AS SODT
    FROM DETAI
    WHERE NGAYBD LIKE '%2000%'
    GROUP BY GVCNDT
) DT ON GV.MAGV = DT.GVCNDT;

--3. CHO BIẾT MADT, SỐ GV THAM GIA, SỐ CÔNG VIỆC CHƯA ĐẠT

----TRUY VẤN LÔNG SELECT
--TỰ VIẾT -
-----THIẾU DISTINCT, ĐẶT TRÙNG ALIAS
SELECT TG.MADT, (SELECT COUNT(DISTINCT TG.MAGV)
				FROM THAMGIADT TG
				WHERE MADT=TG.MADT) AS SOGVTG,
				(SELECT COUNT(TG1.MADT)
				FROM THAMGIADT TG1
				LEFT JOIN CONGVIEC CV ON CV.MADT=TG1.MADT
				WHERE TG1.KETQUA IS NULL) AS SOCV
FROM THAMGIADT TG

--CHATGPT
SELECT DISTINCT TG.MADT,
    (SELECT COUNT(DISTINCT TG1.MAGV)
     FROM THAMGIADT TG1
     WHERE TG.MADT = TG1.MADT) AS SOGVTG,
    (SELECT COUNT(TG2.MADT)
     FROM THAMGIADT TG2
     LEFT JOIN CONGVIEC CV ON CV.MADT = TG2.MADT
     WHERE TG2.KETQUA IS NULL AND TG2.MADT = TG.MADT) AS SOCV
FROM THAMGIADT TG;

-----TRUY VẤN LỒNG FROM (TỰ VIẾT)
SELECT DISTINCT TG.MADT, SOGV.SOGV, SCV.SCV
FROM THAMGIADT TG
LEFT JOIN (
SELECT MADT, COUNT(DISTINCT MAGV) AS SOGV
FROM THAMGIADT 
GROUP BY MADT
) SOGV ON TG.MADT=SOGV.MADT
LEFT JOIN (
SELECT MADT, COUNT(MADT) AS SCV
FROM THAMGIADT 
WHERE KETQUA IS NULL
GROUP BY MADT
) SCV ON SCV.MADT=TG.MADT


SELECT TG.MADT,
       (SELECT COUNT(DISTINCT TG1.MAGV)
        FROM THAMGIADT TG1
        WHERE TG.MADT = TG1.MADT) AS SOGVTG,
       (SELECT COUNT(TG2.MADT)
        FROM THAMGIADT TG2
        LEFT JOIN CONGVIEC CV ON CV.MADT = TG2.MADT
        WHERE TG2.MADT = TG.MADT AND TG2.KETQUA IS NULL) AS SOCV
FROM THAMGIADT TG;


--4. CHO BIẾT ĐỀ TÀI CÓ NHIỀU CÔNG VIỆC CHƯA ĐẠT NHẤT
--CACH 1
SELECT DT.MADT
FROM DETAI DT
LEFT JOIN THAMGIADT TG ON TG.MADT=DT.MADT
WHERE TG.KETQUA IS NULL
GROUP BY DT.MADT
HAVING COUNT (DT.MADT)>=ALL(
	SELECT COUNT(TG.MADT)
	FROM THAMGIADT TG
	WHERE TG.KETQUA IS NULL
)
--CACH 2
SELECT DT.MADT
FROM DETAI DT
WHERE DT.MADT IN (
    SELECT TG.MADT
    FROM THAMGIADT TG
    WHERE TG.KETQUA IS NULL
    GROUP BY TG.MADT
    HAVING COUNT(TG.MADT) >= ALL (
        SELECT COUNT(TG.MADT)
        FROM THAMGIADT
        WHERE KETQUA IS NULL
        GROUP BY MADT
    )
)

--5. CHO BIẾT GIÁO VIÊN CHỦ NHIỆM NHIỀU ĐỀ TÀI CÓ CÔNG VIỆC KHÔNG ĐẠT NHẤT

SELECT GV.MAGV
FROM GIAOVIEN GV
LEFT JOIN DETAI DT ON DT.GVCNDT=GV.MAGV
LEFT JOIN THAMGIADT TG ON TG.MAGV=GV.MAGV
WHERE DT.MADT IN (
	SELECT TG1.MADT
	FROM THAMGIADT TG1
	WHERE TG1.KETQUA IS NULL
	GROUP BY TG1.MADT
	HAVING COUNT(TG1.MADT)>=(SELECT COUNT(TG2.MADT)
							FROM THAMGIADT TG2
							WHERE TG2.KETQUA IS NULL
							GROUP BY TG2.MADT
								)
)
--CACH 2:
SELECT GV.MAGV
FROM GIAOVIEN GV
LEFT JOIN DETAI DT ON DT.GVCNDT = GV.MAGV
LEFT JOIN THAMGIADT TG ON TG.MADT = DT.MADT
WHERE TG.KETQUA IS NULL
GROUP BY GV.MAGV
HAVING COUNT(DT.MADT) >= ALL (
    SELECT COUNT(DT.MADT)
    FROM DETAI DT
    LEFT JOIN THAMGIADT TG ON TG.MADT = DT.MADT
    WHERE TG.KETQUA IS NULL
    GROUP BY DT.GVCNDT
)


--6. CHO BIẾT GIÁO VIÊN CHỦ NHIỆM NHIỀU ĐỀ TÀI CÓ GIÁO VIÊN CÙNG BỘ MÔN VỚI MÌNH NHẤT



--7. CHO BIẾT GIÁO VIÊN CHƯA THAM GIA ĐỀ TÀI NÀO DO GIÁO VIÊN CÙNG BỘ MÔN CHỦ NHIỆM
SELECT GV.MAGV
FROM GIAOVIEN GV
LEFT JOIN GIAOVIEN GVCBM ON GV.MABM=GVCBM.MABM
LEFT JOIN DETAI DT ON GVCBM.MAGV=DT.GVCNDT
LEFT JOIN THAMGIADT TG ON TG.MADT=DT.MADT
WHERE GV.MAGV<>GVCBM.MAGV AND GV.MAGV NOT IN (SELECT TG.MAGV
						FROM GIAOVIEN GV
						LEFT JOIN THAMGIADT TG ON TG.MAGV=GV.MAGV
						GROUP BY TG.MAGV)

--BÀI SỬA--

SELECT GV.MAGV
FROM GIAOVIEN GV
LEFT JOIN GIAOVIEN GVCBM ON GV.MABM = GVCBM.MABM
WHERE GV.MAGV<>GVCBM.MAGV AND GV.MAGV NOT IN (
    SELECT TG.MAGV
    FROM THAMGIADT TG
    LEFT JOIN DETAI DT ON TG.MADT = DT.MADT
    WHERE DT.GVCNDT = GVCBM.MAGV
)
GROUP BY GV.MAGV;


--8. CHO BIẾT BỘ MÔN CÓ ÍT GIÁO VIÊN THAM ĐỀ TÀI NHẤT


SELECT TOP 1 BM.MABM, COUNT(TG.MAGV) AS SoLuongGiaoVien
FROM BOMON BM
LEFT JOIN GIAOVIEN GV ON GV.MABM = BM.MABM
LEFT JOIN THAMGIADT TG ON TG.MAGV = GV.MAGV
GROUP BY BM.MABM
ORDER BY SoLuongGiaoVien ASC;

SELECT BM.MABM, COUNT(TG.MAGV) AS SoLuongGiaoVien
FROM BOMON BM
LEFT JOIN GIAOVIEN GV ON GV.MABM = BM.MABM
LEFT JOIN THAMGIADT TG ON TG.MAGV = GV.MAGV
GROUP BY BM.MABM
HAVING COUNT(TG.MAGV) = (
    SELECT MIN(NumGiaoVien)
    FROM (
        SELECT COUNT(TG2.MAGV) AS NumGiaoVien
        FROM BOMON BM2
        LEFT JOIN GIAOVIEN GV2 ON GV2.MABM = BM2.MABM
        LEFT JOIN THAMGIADT TG2 ON TG2.MAGV = GV2.MAGV
        GROUP BY BM2.MABM
    ) AS SubQuery
)
ORDER BY BM.MABM ASC;


--9. CHO BIẾT GIÁO VIÊN CÙNG SỐ CON VÀ CÙNG GIỚI TÍNH VỚI GIÁO VIÊN KHÁC

SELECT DISTINCT GV.MAGV, GVK.MAGV
FROM GIAOVIEN GV
JOIN GIAOVIEN GVK ON GV.PHAI = GVK.PHAI AND GV.MAGV <> GVK.MAGV
WHERE (
    SELECT COUNT(*)
    FROM NGUOITHAN NT1
    WHERE NT1.QUANHE = 'CON' AND NT1.MAGV = GV.MAGV
) = (
    SELECT COUNT(*)
    FROM NGUOITHAN NT2
    WHERE NT2.QUANHE = 'CON' AND NT2.MAGV = GVK.MAGV
)
GROUP BY GV.MAGV, GVK.MAGV

--10. CHO BIẾT GIÁO VIÊN THAM GIA TẤT CẢ ĐỀ TÀI DO NGUYỄN HOÀI AN CHỦ NHIỆM
--kq: xuất cái gì -> giaovien (magv)
--c:tất cả cái gì -> detai (madt)&GVCN='NGUYEN HOAI AN'
--bc: mối quan hệ giữa kq và c -> thamgiadt (magv,madt)
SELECT GV.MAGV
FROM THAMGIADT TG
JOIN GIAOVIEN GV ON GV.MAGV=TG.MAGV
WHERE TG.MADT IN (SELECT MADT
					FROM DETAI DT 
					LEFT JOIN GIAOVIEN GV1 ON GV1.MAGV=DT.GVCNDT
					WHERE GV1.HOTEN=N'NGUYỄN HOÀI AN')
GROUP BY GV.MAGV
HAVING COUNT(DISTINCT TG.MADT)=(SELECT COUNT(DT.GVCNDT)
								FROM DETAI DT 
								LEFT JOIN GIAOVIEN GV1 ON GV1.MAGV=DT.GVCNDT
								WHERE GV1.HOTEN=N'NGUYỄN HOÀI AN'
)

--BÀI SỬA--

SELECT GV.*
FROM GIAOVIEN GV
WHERE NOT EXISTS (SELECT DT.MADT
					FROM GIAOVIEN CN JOIN DETAI DT ON DT.GVCNDT=CN.MAGV
					WHERE CN.HOTEN=N'NGUYỄN HOÀI AN'
					EXCEPT
					SELECT TG.MADT
					FROM THAMGIADT TG
					WHERE TG.MAGV=GV.MAGV
					)
				

--11. CHO BIẾT GIÁO VIÊN CHỦ NHIỆM TẤT CẢ ĐỀ TÀI CÓ NGUYỄN HOÀI AN THAM GIA
--C: TAT CA DT NHA TG (TGDT)
--KQ: GVCN->DETAI(GVCNDT)
--BC:GIAOVIEN-> MAGV
SELECT GV.MAGV
FROM GIAOVIEN GV 
JOIN DETAI DT ON GV.MAGV=DT.GVCNDT
WHERE DT.MADT IN (SELECT DISTINCT TG.MADT
					FROM THAMGIADT TG
					JOIN GIAOVIEN GV1 ON GV1.MAGV=TG.MAGV
					WHERE GV1.HOTEN = N'NGUYỄN HOÀI AN'
					)
GROUP BY GV.MAGV
HAVING COUNT(DISTINCT DT.MADT)=(SELECT COUNT(DISTINCT TG.MADT)
					FROM THAMGIADT TG
					JOIN GIAOVIEN GV1 ON GV1.MAGV=TG.MAGV
					WHERE GV1.HOTEN = N'NGUYỄN HOÀI AN'
					)

--CHIA CÁCH 1--
SELECT GVCN.MAGV
FROM GIAOVIEN GVCN
WHERE NOT EXISTS (
					SELECT TG.MADT
					FROM GIAOVIEN GV
					JOIN THAMGIADT TG ON GV.MAGV=TG.MAGV
					JOIN DETAI DT ON DT.MADT=TG.MADT
					WHERE GV.HOTEN=N'NGUYỄN HOÀI AN'
					EXCEPT
					SELECT DT1.MADT
					FROM DETAI DT1
					WHERE DT1.GVCNDT=GVCN.MAGV
					)
--12. CHO BIẾT BỘ MÔN CÓ TẤT CẢ GIÁO VIÊN Ở TPHCM VÀ CHƯA CÓ CON
--kq: bomon (mabm)
--c:gv o tphcm va chua co con (GV + NT)
--bc: giaovien

SELECT BM.MABM
FROM BOMON BM
WHERE NOT EXISTS (SELECT GV.MAGV
					FROM GIAOVIEN GV 
					JOIN NGUOITHAN NT ON NT.MAGV=GV.MAGV
					WHERE GV.MABM=BM.MABM AND GV.DIACHI NOT LIKE '%TPHCM%' AND NT.QUANHE='CON'
					EXCEPT 
					SELECT GV1.MAGV
					FROM GIAOVIEN GV1
					WHERE GV1.MABM=BM.MABM)
SELECT BM.MABM
FROM BOMON BM
WHERE NOT EXISTS (
    SELECT GV.MAGV
    FROM GIAOVIEN GV 
    JOIN NGUOITHAN NT ON NT.MAGV=GV.MAGV
    WHERE GV.MABM=BM.MABM AND GV.DIACHI NOT LIKE '%TPHCM%' AND NT.QUANHE='CON'
    EXCEPT 
    SELECT GV1.MAGV
    FROM GIAOVIEN GV1
    WHERE GV1.MABM=BM.MABM
)

SELECT BM.MABM
FROM BOMON BM
WHERE NOT EXISTS (
    SELECT *
    FROM GIAOVIEN GV
    WHERE GV.MABM = BM.MABM
      AND GV.DIACHI NOT LIKE '%TPHCM%'
)
AND NOT EXISTS (
    SELECT *
    FROM GIAOVIEN GV
    JOIN NGUOITHAN NT ON NT.MAGV = GV.MAGV
    WHERE GV.MABM = BM.MABM
      AND NT.QUANHE = 'CON'
)


SELECT BM.MABM
FROM BOMON BM
WHERE NOT EXISTS (SELECT GV.MAGV
					FROM GIAOVIEN GV
					WHERE BM.MABM=GV.MABM AND GV.DIACHI NOT LIKE '%TPHCM' AND NOT EXISTS (SELECT NT.MAGV
																FROM NGUOITHAN NT 
																WHERE NT.QUANHE='CON' AND GV.MAGV=NT.MAGV --AND BM.MABM=GV.MABM
														)
)
SELECT BM.MABM
FROM BOMON BM
WHERE NOT EXISTS (
    SELECT GV.MAGV
    FROM GIAOVIEN GV
    LEFT JOIN NGUOITHAN NT ON NT.MAGV = GV.MAGV AND NT.QUANHE = 'CON'
    WHERE GV.MABM = BM.MABM AND GV.DIACHI NOT LIKE '%TPHCM%' AND NT.MAGV IS NOT NULL
)

--13. CHO BIẾT KHOA CÓ TRƯỞNG KHOA Ở TP HCM CHỦ NHIỆM ĐỀ TÀI KINH PHÍ LỚN NHẤT
SELECT K.TENKHOA
FROM KHOA K
JOIN GIAOVIEN GV ON GV.MAGV=K.TRUONGKHOA
JOIN DETAI DT ON DT.GVCNDT=K.TRUONGKHOA
WHERE GV.DIACHI LIKE '%TPHCM' 
AND DT.KINHPHI = (SELECT MAX(DT1.KINHPHI)
				FROM KHOA K1
				JOIN GIAOVIEN GV1 ON GV1.MAGV=K1.TRUONGKHOA
				JOIN DETAI DT1 ON DT1.GVCNDT=K1.TRUONGKHOA
				WHERE GV1.DIACHI LIKE '%TPHCM' 
				)

SELECT K.TENKHOA
FROM KHOA K
JOIN GIAOVIEN GV ON GV.MAGV = K.TRUONGKHOA
JOIN DETAI DT ON DT.GVCNDT = GV.MAGV
WHERE GV.DIACHI LIKE '%TPHCM'
  AND DT.KINHPHI = (
    SELECT MAX(KINHPHI)
    FROM DETAI
    WHERE GVCNDT = GV.MAGV
)

--14. CHO BIẾT BỘ MÔN THUỘC KHOA CNTT CÓ TẤT CẢ GIÁO VIÊN THAM GIA ĐỀ TÀI KÍNH PHÍ > 100

SELECT BM.TENBM
FROM BOMON BM
WHERE BM.MAKHOA='CNTT' AND NOT EXISTS (
					SELECT DT.MADT
					FROM DETAI DT 
					WHERE DT.KINHPHI > 100
					EXCEPT
					SELECT TG.MADT
					FROM THAMGIADT TG
					JOIN GIAOVIEN GV ON GV.MAGV=TG.MAGV 
					WHERE GV.MABM=BM.MABM
					)
SELECT BM.TENBM
FROM BOMON BM
WHERE NOT EXISTS (
    SELECT DT.MADT
    FROM DETAI DT 
    WHERE DT.KINHPHI > 100
    AND DT.MADT NOT IN (
        SELECT TG.MADT
        FROM THAMGIADT TG
        JOIN GIAOVIEN GV ON GV.MAGV = TG.MAGV 
        WHERE GV.MABM = BM.MABM
    )
)

--15. CHO BIẾT CHỦ ĐỀ ĐƯỢC TẤT CẢ GIÁO VIÊN THUỘC BỘ MÔN CNPM THAM GIA
--KQ: CHUDE ; C: GV, BM 'CNPM' BC: DETAI, THAMGIADT, GIAOVIEN
SELECT CD.TENCD
FROM CHUDE CD
WHERE NOT EXISTS (
					SELECT GV.MAGV
					FROM GIAOVIEN GV
					JOIN BOMON BM ON BM.MABM=GV.MABM
					WHERE BM.MABM<>'HTTT'
					EXCEPT
					SELECT TG.MAGV
					FROM DETAI DT
					JOIN THAMGIADT TG ON TG.MADT=DT.MADT
					JOIN GIAOVIEN GV1 ON GV1.MAGV=TG.MAGV
					WHERE DT.MACD=CD.MACD
					)
SELECT CD.MACD
FROM GIAOVIEN GV
JOIN THAMGIADT TG ON TG.MAGV=GV.MAGV
JOIN DETAI DT ON DT.MADT=TG.MADT
JOIN CHUDE CD ON CD.MACD=DT.MACD
WHERE GV.MABM='HTTT'
GROUP BY CD.MACD
HAVING COUNT(DISTINCT GV.MAGV) = ( 
									SELECT COUNT(DISTINCT GV.MAGV)
									FROM GIAOVIEN GV
									JOIN THAMGIADT TG ON TG.MAGV=GV.MAGV
									JOIN DETAI DT ON DT.MADT=TG.MADT
									JOIN CHUDE CD ON CD.MACD=DT.MACD
									WHERE GV.MABM='HTTT'
)

--16. CHO BIẾT GIÁO VIÊN CHỦ NHIỆM ĐỂ TÀI ĐƯỢC MỌI GIÁO VIÊN HỆ THỐNG THÔNG TIN THAM GIA
--KQ: GVCNDT (GV+DT); C: GV HTTT + TGDT; BC: TGDT
SELECT GV.MAGV
FROM GIAOVIEN GV
JOIN THAMGIADT TG ON TG.MAGV=GV.MAGV
JOIN DETAI DT ON DT.GVCNDT=GV.MAGV
WHERE GV.MAGV=DT.GVCNDT
GROUP BY GV.MAGV
HAVING COUNT(DT.MADT)=(
						SELECT COUNT(TG.MADT)
						FROM GIAOVIEN GV1
						JOIN THAMGIADT TG ON TG.MAGV=GV1.MAGV
						JOIN BOMON BM ON BM.MABM=GV1.MABM
						WHERE BM.TENBM=N'HỆ THỐNG THÔNG TIN'
						--GROUP BY TG.MADT
						)

SELECT DT.GVCNDT
FROM DETAI DT 
WHERE NOT EXISTS (
					SELECT GV1.MAGV
					FROM GIAOVIEN GV1
					JOIN BOMON BM ON BM.MABM=GV1.MABM
					WHERE BM.TENBM=N'HỆ THỐNG THÔNG TIN'
					EXCEPT
					SELECT TG.MAGV
					FROM THAMGIADT TG
					WHERE TG.MADT=DT.MADT
)
--KIEM TRA GV 001 CO PHAI GVQL HAY KHONG
SELECT GV.*
FROM GIAOVIEN GV
WHERE GV.MAGV='001' AND GV.MAGV IN (SELECT GV1.GVQLCM
									FROM GIAOVIEN GV1)

--XUAT RA GIAOVIEN THAM GIA NHIEU HON 1 DE TAI
SELECT GV.MAGV
FROM GIAOVIEN GV
JOIN THAMGIADT TG ON TG.MAGV=GV.MAGV
GROUP BY GV.MAGV
HAVING COUNT(TG.MADT)>1

--SELECT GV.MAGV
--FROM GIAOVIEN GV, (SELECT TG.MAGV, COUNT(TG.MADT)
--					FROM GIAOVIEN GV
--					JOIN THAMGIADT TG ON TG.MAGV=GV.MAGV
--					GROUP BY TG.MAGV) AS DTTG
--WHERE DTTG>1

SELECT GV.MAGV
FROM GIAOVIEN GV
WHERE 1< (SELECT COUNT(TG.MADT)
					FROM THAMGIADT TG 
					WHERE TG.MAGV=GV.MAGV)

--XUẤT RA THÔNG TIN CÓ 2 NGƯỜI THÂN
SELECT DISTINCT GV.MAGV
FROM GIAOVIEN GV
JOIN NGUOITHAN NT ON NT.MAGV=GV.MAGV
WHERE 2<(SELECT COUNT(GV1.MAGV)
		FROM GIAOVIEN GV1
		JOIN NGUOITHAN NT1 ON NT1.MAGV=GV1.MAGV
		WHERE GV.MAGV=GV1.MAGV)

--THÔNG TIN KHOA CÓ NHIỀU HƠN 2 GV
SELECT K.*
FROM KHOA K 
--JOIN BOMON BM ON BM.MAKHOA=K.MAKHOA
--JOIN GIAOVIEN GV ON GV.MABM=BM.MABM
WHERE 2<(SELECT COUNT(GV1.MAGV)
		FROM GIAOVIEN GV1
		JOIN BOMON BM ON BM.MABM=GV1.MABM
		WHERE K.MAKHOA=BM.MAKHOA)

--XUẤT RA GIÁO VIÊN LỚN TUỔI HƠN 50% GV TRONG TRƯỜNG
SELECT GV.MAGV
FROM GIAOVIEN GV, (SELECT GV.MAGV, DATEDIFF(YY,GV.NGSINH,GETDATE()) TUOI
					FROM GIAOVIEN GV
					GROUP BY GV.MAGV, GV.NGSINH
					) T
					--ORDER BY TUOI DESC
					--) T,
					--(SELECT COUNT(GV.MAGV) SLGV
					--FROM GIAOVIEN GV
					--) SLGV
GROUP BY GV.MAGV, GV.NGSINH
HAVING DATEDIFF(YY,GV.NGSINH,GETDATE())>AVG(T.TUOI)

SELECT GV.MAGV, AVG(T.TUOI)
FROM GIAOVIEN GV, (SELECT GV.MAGV, DATEDIFF(YY,GV.NGSINH,GETDATE()) TUOI
					FROM GIAOVIEN GV
					GROUP BY GV.MAGV, GV.NGSINH
					) T
					
					
GROUP BY GV.MAGV, GV.NGSINH
--HAVING DATEDIFF(YY,GV.NGSINH,GETDATE())>AVG(T.TUOI)