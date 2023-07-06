﻿-- MSSV
--HOTEN
--MALOP
--MADE
--B1: Tao CSDL, chay thi F5
	--kiem tra CSDL muon tao co chua ?
use master -- trong model de tao san cau truc, nen chon master la CSDL quan li 
go
if DB_ID('QLDOI') is not null
	drop database qldoi -- xoa CSDL
	--ket thuc khoi lenh
go
create database qldoi
go
-- để chuyển cơ sở DL hiện hành về qldoi
use qldoi
go
--B2: tao bang
create table DOI
(
	IDDOI INT,
	TENDOI NVARCHAR(30),
	DOITRUONG INT

	-- TAO KHOA CHINH
	CONSTRAINT PK_DOI  -- CÂU LỆNH ĐẶT TÊN CHO PK 
	PRIMARY KEY (IDDOI) -- CÓ BAO NHIÊU KHÓA THÌ BỎ VÀO 
)

CREATE TABLE BOTRI
(
	IDDOI INT,
	IDTHANHVIEN INT,
	DIACHI NVARCHAR(30),
	NHIEMVU NVARCHAR(30),
	QUANLI INT

	CONSTRAINT PK_BOTRI
	PRIMARY KEY (IDDOI, IDTHANHVIEN)
)

CREATE TABLE THANHVIEN
(
	IDTHANHVIEN INT,
	HOTEN NVARCHAR(30),
	SOCMND CHAR(9),
	DIACHI NVARCHAR(50),
	NGAYSINH DATE

	CONSTRAINT PK_THANHVIEN
	PRIMARY KEY (IDTHANHVIEN)

)

-- b3: TAO KHOA NGOAI
ALTER TABLE DOI  -- ALTER O CAI DUOI CUA MUI TEN
ADD
	CONSTRAINT FK_DOI_TV
	FOREIGN KEY (DOITRUONG)
	REFERENCES THANHVIEN

ALTER TABLE BOTRI
ADD 
	CONSTRAINT FK_BT_DOI
	FOREIGN KEY (IDDOI)
	REFERENCES DOI,
	CONSTRAINT FK_BT_TV
	FOREIGN KEY (IDTHANHVIEN)
	REFERENCES THANHVIEN,
	CONSTRAINT FK_BT_TV_QL
	FOREIGN KEY (QUANLI)
	REFERENCES THANHVIEN

-- B4: NHAP LIEU
-- NHAP BANG TV --> DOI --> BOTRI
INSERT THANHVIEN
VALUES 
	(1,N'NGUYỄN QUAN TÙNG', '240674018', 'TPHCM', '1/30/2000'),
	(2,N'LƯU PHI NAM', '240674027', N'QUẢNG NAM','3/12/2001'),
	(4, N'HÀ NGỌC THÚY', '240674564', 'TPHCM', '7/26/1998'),
	(5, N'TRƯƠNG THỊ MINH', '240674405', N'HÀ NỘI', NULL)
INSERT DOI 
VALUES 
	(2, N'ĐỘI TÂN PHÚ',1),
	(7, N'ĐỘI BÌNH PHÚ', 2)

INSERT BOTRI
VALUES 
	(2,2,N'123 VƯỜN LÀI TÂN PHÚ', N'TRỰC KHU VỰC VÒNG XOAY 1', 1),
	(7,4,N'2 BIS NGUYỄN VĂN CỪ Q5', NULL, 5)

-- TRUY VẤN 
-- TRUY VẤN ĐƠN GIẢN TRÊN 1 BẢNG
-- 6 SELECT: CHỨA THUỘC TÍNH CẦN XUẤT,HÀM XUẤT GIÁ TRỊ, *
-- 2 FROM: CHỨA BẢNG DL CẦN LẤY
-- 3 WHERE: ĐK ĐỂ LỌC DL TRƯỚC KHI XUẤT RA 
-- 4 GROUP BY: CHỨA THUỌC TÍNH CẦN GOM NHÓM 
-- 5 HAVING: ĐK LỌC TRÊN NHÓM TRÊN BẢNG TẠM 
-- 6 ORDER BY: SẮP XẾP --> CHỨA THUỘC TÍNH CẦN SẮP XẾP, ASC: TĂNG, DESC: GIẢM 
-- CHO BIẾT DANH SÁCH ĐỘI --> LẤY HẾT 
SELECT *
FROM DOI
-- CHO BIẾT HỌ TÊN VÀ TUỔI TV
SELECT TV.HOTEN, DATEDIFF(YY, TV.NGAYSINH, GETDATE()) TUOI 
FROM THANHVIEN TV
ORDER BY TUOI  DESC, HOTEN -- NẾU TRÙNG TUỔI THÌ TĂNG THEO HỌ TÊN 

-- CHO BIẾT HO TEN TV CÓ CUNG CẤP NGSINH
SELECT TV.HOTEN
FROM THANHVIEN TV
WHERE TV.NGAYSINH IS NOT NULL   -- KO ĐC DÙNG =, <, > KHÁC NULL

--LẤY TOP 2 THÀNH VIÊN TRONG DS
SELECT TOP 2 TV.*
FROM THANHVIEN TV

--LẤY THÀNH VIÊN LỚN TUỔI NHẤT
SELECT TOP 1 TV.*
FROM THANHVIEN TV
WHERE TV.NGAYSINH IS NOT NULL
ORDER BY TV.NGAYSINH

--CHO BIẾT THÀNH VIÊN HỌ NGUYỄN
SELECT TV.*
FROM THANHVIEN TV
WHERE TV.HOTEN LIKE N'NGUYỄN %' --> % YHAY THẾ CHUỖI KHÔNG BIẾT, _ THAY CHO 1 KÝ TỰ KHÔNG BIẾT
OR TV.HOTEN LIKE N'% __'

-- TRUY VẤN KẾT --> NỐI HAI BẢNG THÀNH 1 ĐỂ TRUY XUẤT DỮ LIỆU
---TÍCH DỀ CÁC
----CHO BIẾT THÔNG TIN ĐỘI TRƯỞNG VÀ TV LÀ ĐỘI TRƯỞNG
SELECT *
FROM THANHVIEN TV, DOI D
WHERE TV.IDTHANHVIEN = D.DOITRUONG
--CÁCH KHÁC: JOIN
SELECT *
FROM THANHVIEN TV JOIN DOI D ON TV.IDTHANHVIEN = D.DOITRUONG

--CHO BIẾT TÊN ĐỘI, TÊN ĐỘI TRƯỞNG CỦA CÁC THÀNH VIÊN THỰC HIỆN
---NHIỆM VỤ TÂN PHÚ
SELECT DISTINCT D.TENDOI, TV.HOTEN --DISTINCT LOẠI NHỮNG DỮ LIỆU TRÙNG
FROM DOI D JOIN THANHVIEN TV ON TV.IDTHANHVIEN = D.DOITRUONG
JOIN BOTRI BT ON BT.IDDOI = D.IDDOI
WHERE BT.DIACHI LIKE N'% TÂN PHÚ' AND BT.NHIEMVU IS NOT NULL

-- TRUY VẤN GOM 
--CHỈ DÙNG KHI CẦN: SUM(SỐ), AVG(SỐ), MIN(BẤT KỲ), MAX(BẤT KỲ)
---------COUNT(*): ĐẾM DÒNG; COUNT (THUỘC TÍNH): ĐẾM GIÁ TRỊ; COUNT (DISTINCT THUỘC TÍNH): ĐẾM GIÁ TRỊ PHÂN BIỆT

--CHO BIẾT TÊN ĐỘI VÀ SỐ THÀNH VIÊN TRONG ĐỘI

SELECT D.TENDOI, COUNT(*) SOTV, COUNT(NHIEMVU) SONV, COUNT(DISTINCT QUANLI) SOQL
FROM DOI D JOIN BOTRI BT ON BT.IDDOI=D.IDDOI
GROUP BY D.IDDOI, D.TENDOI --THUỘC TÍNH TRONG SELECT PHẢI CÓ TRONG GROUP BY
--CHO BIẾT TÊN ĐỘI VÀ TUỔI TB CỦA THÀNH VIÊN

SELECT D.TENDOI, AVG(DATEDIFF(YY,TV.NGAYSINH,GETDATE())) TBTUOI
FROM DOI D JOIN BOTRI BT ON BT.IDDOI=D.IDDOI
JOIN THANHVIEN TV ON TV.IDTHANHVIEN = BT.IDTHANHVIEN
GROUP BY D.IDDOI, D.TENDOI

--CHO BIẾT TV LỚN TUỔI NHẤT
SELECT DATEDIFF(YY,MIN(TV.NGAYSINH),GETDATE())--MIN(TV.NGAYSINH) --MAX(DATEDIFF(YY,TV.NGAYSINH,GETDATE()))
FROM THANHVIEN TV 

--CHO BIẾT TUỔI VÀ SỐ LƯỢNG THÀNH VIÊN CÓ TUỔI ĐÓ
SELECT DATEDIFF(YY,TV.NGAYSINH,GETDATE()) TUOI, COUNT(*) SOTV
FROM THANHVIEN TV
GROUP BY DATEDIFF(YY,TV.NGAYSINH,GETDATE())
HAVING DATEDIFF(YY,TV.NGAYSINH,GETDATE()) IS NOT NULL
--HAVING COUNT(*) > 1
--> NHỮNG ĐIỀU KIỆN KHÔNG LIÊN QUAN THÌ NÊN DÙNG WHERE THAY CHO HAVING ĐỂ HẠN CHẾ THỜI GIAN CHẠY CỦA HỆ QUẢN TRỊ

--XUẤT NHỮNG TUỔI MÀ CÓ NHIỀU HƠN 1 TV
-- TRUY VẤN TẬP HỢP --> KHẢ HỢP: TRỒNG CÁC BẢNG LÊN NÊN CÙNG BẬC VÀ THUỘC TÍNH CÙNG GIÁ TRỊ
---HỘI ~ OR
---CHO BIẾT TV HOẶC Ở TPHCM OR THAM GIA ĐỘI TÂN PHÚ
SELECT *
FROM THANHVIEN TV
WHERE TV.DIACHI = N'TPHCM'
-- GỘP 2 BẢNG -> KHẢ HỢP (TRÙNG KIỂU DỮ LIỆU)
UNION ALL --DÙNG ALL NHỮNG DÒNG TRÙNG SẼ HIỆN RA
SELECT TV.*
FROM THANHVIEN TV JOIN BOTRI BT ON BT.IDTHANHVIEN = TV.IDTHANHVIEN
JOIN DOI D ON D.IDDOI=BT.IDDOI --AND TENDOI LIKE N'%TÂN PHÚ%'
WHERE TENDOI LIKE N'%TÂN PHÚ%'
--GIAO ~ AND
---CHO BIẾT TV Ở TÂN PHÚ VÀ LÀ ĐỘI TRƯỞNG

SELECT TV.*
FROM THANHVIEN TV
WHERE TV.DIACHI = 'TPHCM'
INTERSECT 
SELECT TV.*
FROM THANHVIEN TV JOIN DOI D ON D.DOITRUONG = TV.IDTHANHVIEN
--> AND CHỈ CẦN CÓ MỘT DÒNG THỎA CŨNG SẼ LẤY

--TRỪ ~ NOT (THƯỜNG THẤY Ở ĐỀ BÀI YÊU CẦU "CHỈ")
---CHO BIẾT BIẾT ĐỘI CHỦ CHỨA TV Ở TÂN PHÚ
SELECT D.*
FROM DOI D JOIN BOTRI BT ON D.IDDOI=BT.IDDOI
JOIN THANHVIEN TV ON TV.IDTHANHVIEN=BT.IDTHANHVIEN
WHERE TV.DIACHI = 'TPHCM'-->Ở TPHCM
--EXCEPT
SELECT D.*
FROM DOI D JOIN BOTRI BT ON D.IDDOI=BT.IDDOI
JOIN THANHVIEN TV ON TV.IDTHANHVIEN=BT.IDTHANHVIEN
WHERE TV.DIACHI <> 'TPHCM'-->KHÔNG Ở TPHCM

SELECT D.*, TV.DIACHI
FROM DOI D JOIN BOTRI BT ON D.IDDOI=BT.IDDOI
JOIN THANHVIEN TV ON TV.IDTHANHVIEN=BT.IDTHANHVIEN

--5. CHO BIẾT TÊN QUẢN LÝ VÀ SỐ LƯỢNG TV
---CÓ CUNG CẤP NGÀY SINH DO NGƯỜI NÀY QUẢN LÝ
SELECT QL.HOTEN,COUNT(*) SOTV --BT.QUANLI, COUNT(*)
FROM BOTRI BT JOIN THANHVIEN QL ON QL.IDTHANHVIEN=BT.QUANLI
JOIN THANHVIEN TV ON TV.IDTHANHVIEN=BT.IDTHANHVIEN
WHERE TV.NGAYSINH IS NOT NULL
GROUP BY BT.QUANLI, QL.HOTEN