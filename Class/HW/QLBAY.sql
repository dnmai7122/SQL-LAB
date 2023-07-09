USE MASTER
GO

--GO
IF DB_ID('QLCB') IS NOT NULL
	DROP DATABASE QLCB
GO

CREATE DATABASE QLCB
GO

USE QLCB
GO 
CREATE TABLE KHACHHANG(
	MAKH CHAR(15),
	TEN NVARCHAR(15),
	DCHI NVARCHAR(50),
	DTHOAI CHAR(12)

	CONSTRAINT PK_KHACHHANG
	PRIMARY KEY (MAKH)
)
CREATE TABLE NHANVIEN(
	MANV CHAR(15),
	TEN NVARCHAR(15),
	DCHI NVARCHAR(50),
	DTHOAI CHAR(12),
	LUONG FLOAT,
	LOAINV BIT

	CONSTRAINT PK_NHANVIEN
	PRIMARY KEY (MANV)
)
CREATE TABLE LOAIMB
(
	MALOAI CHAR(15),
	HANGSX CHAR(15)

	CONSTRAINT PK_LOAIMB
	PRIMARY KEY (MALOAI)
)
CREATE TABLE MAYBAY
(
	SOHIEU INT,
	MALOAI CHAR(15)

	CONSTRAINT PK_MAYBAY
	PRIMARY KEY (SOHIEU, MALOAI)
)
CREATE TABLE CHUYENBAY
(
	MACB CHAR(4),
	SBDI CHAR(3),
	SBDEN CHAR(3),
	GIODI TIME,
	GIODEN TIME

	CONSTRAINT PK_CHUYENBAY
	PRIMARY KEY (MACB)
)
CREATE TABLE LICHBAY
(
	NGAYDI DATE,
	MACB CHAR(4),
	SOHIEU INT,
	MALOAI CHAR(15)

	CONSTRAINT PK_LICHBAY
	PRIMARY KEY (NGAYDI, MACB)
)
CREATE TABLE DATCHO
(
	MAKH CHAR(15),
	NGAYDI DATE,
	MACB CHAR(4)

	CONSTRAINT PK_DATCHO
	PRIMARY KEY (MAKH,NGAYDI,MACB)
)
CREATE TABLE KHANANG
(
	MANV CHAR(15),
	MALOAI CHAR(15)

	CONSTRAINT PK_KHANANG
	PRIMARY KEY (MANV, MALOAI)
)
CREATE TABLE PHANCONG
(
	MANV CHAR(15),
	NGAYDI DATE,
	MACB CHAR(4)

	CONSTRAINT PK_PHANCONG
	PRIMARY KEY (MANV, NGAYDI, MACB)
)

ALTER TABLE NHANVIEN
ADD
	CONSTRAINT CK_LOAINV CHECK (LOAINV IN (0,1))

ALTER TABLE MAYBAY
ADD
	CONSTRAINT FK_MAYBAY_LOAIMB
	FOREIGN KEY (MALOAI)
	REFERENCES LOAIMB(MALOAI)

ALTER TABLE LICHBAY
ADD 
	CONSTRAINT FK_LICHBAY_CHUYENBAY
	FOREIGN KEY (MACB)
	REFERENCES CHUYENBAY(MACB),

	CONSTRAINT FK_LICHBAY_MAYBAY
	FOREIGN KEY (SOHIEU,MALOAI)
	REFERENCES MAYBAY(SOHIEU,MALOAI)
	
ALTER TABLE DATCHO
ADD 
	CONSTRAINT FK_DATCHO_LICHBAY
	FOREIGN KEY (NGAYDI,MACB)
	REFERENCES LICHBAY(NGAYDI, MACB),

	CONSTRAINT FK_DATCHO_KHACHHANG
	FOREIGN KEY (MAKH)
	REFERENCES KHACHHANG(MAKH)

ALTER TABLE KHANANG
ADD
	CONSTRAINT FK_KHANANG_NHANVIEN
	FOREIGN KEY (MANV)
	REFERENCES NHANVIEN(MANV),

	CONSTRAINT FK_KHANANG_LOAIMB
	FOREIGN KEY (MALOAI)
	REFERENCES LOAIMB(MALOAI)

ALTER TABLE PHANCONG
ADD 
	CONSTRAINT FK_PHANCONG_NHANVIEN
	FOREIGN KEY (MANV)
	REFERENCES NHANVIEN(MANV),

	CONSTRAINT FK_PHANCONG_LICHBAY
	FOREIGN KEY (NGAYDI, MACB)
	REFERENCES LICHBAY(NGAYDI,MACB)

