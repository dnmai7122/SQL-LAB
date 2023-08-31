--MSSV: 21127104
--Họ tên: Đoàn Ngọc Mai
--Lớp: 21CLC05
--Ca 2
--Đề: 2


--1. Cho danh sách (mã đọc giả, họ tên) đã mượn sách thuộc tất cả thể loại
SELECT DG.madg, DG.hoten
FROM DocGia DG
JOIN PhieuMuon PM ON PM.madg=DG.madg
JOIN CT_PhieuMuon CTM ON CTM.mapm=PM.mapm
JOIN DauSach DS ON DS.isbn=CTM.isbn
GROUP BY DG.madg, DG.HOTEN
--ĐẾM TẤT CẢ THỂ LOẠI ĐẦU SÁCH
HAVING COUNT(DISTINCT DS.theloai) = (SELECT COUNT(DISTINCT DS.theloai)
						FROM DauSach DS)

SELECT DG.madg, DG.hoten
FROM DocGia DG
WHERE NOT EXISTS (SELECT DS.theloai
					FROM DauSach DS
					EXCEPT 
					SELECT CS.
					FROM PhieuMuon PM
					JOIN CT_PhieuMuon CTM ON CTM.mapm=PM.mapm
					JOIN PhieuTra PT ON PT.mapm= PM.mapm
					JOIN CuonSach CS ON CS.isbn
					)


--2. Cho danh sách (mã nhân viên, họ tên, số năm công tác) còn làm việc và có số năm
--công tác lâu nhất tính đến hiện tại
SELECT NV.MaNV, NV.HoTenNV, DATEDIFF(YEAR, NV.NgayVaoLam, GETDATE()) AS N'SỐ NĂM CÔNG TÁC'
FROM NhanVien_TV NV, (SELECT MAX(DATEDIFF(YEAR, NV.NgayVaoLam, GETDATE())) AS NLV
					FROM NhanVien_TV NV
					) NL,
					(SELECT NV.MaNV, DATEDIFF(YEAR, NV.NgayVaoLam, GETDATE()) AS NLV1
											FROM NhanVien_TV NV
											) SONAM
WHERE NV.NgayNghiViec IS NULL AND NL.NLV = SONAM.NLV1 AND NV.MaNV=SONAM.MaNV

--3. Viết stored procedure, function thêm một phiếu mượn sách sao cho thoả các quy
--định sau:
--- Input: mã phiếu mượn, mã đọc giả, mã nhân viên lập phiếu
--- Kiểm tra dữ liệu đầu vào tồn tại hợp lệ
--- Kiểm tra không trùng khoá chính
--- Ngày mượn là ngày hiện tại
--- Chỉ được lập phiếu mượn khi đã trả hết sách của những lần mượn trước đó
--(không còn sách chưa trả)
--- Nếu thoả các điều kiện trên, thực hiện thêm phiếu mượn. Thông báo thành
--công
--- Ngược lại, báo lỗi và thoát

CREATE --ALTER
PROC DATRA @MAPM VARCHAR(10)
AS BEGIN
	DECLARE @FLAG INT
	IF EXISTS(SELECT 1
				FROM PhieuTra PT
				WHERE PT.mapm=@MAPM)
			SET @FLAG = 1
	ELSE SET @FLAG = 0

	RETURN @FLAG
END
GO

DECLARE @RES INT
EXEC @RES = DATRA 'PM003'
PRINT @RES


--ĐẾM SỐ SÁCH TRẢ TỪ PHIẾU TRAR
CREATE --ALTER
PROC SACHTRA @MAPM VARCHAR(10)
AS BEGIN
	DECLARE @NUM INT
	SELECT @NUM=COUNT(CTT.masach)
	FROM PhieuTra PT
	JOIN CT_PhieuTra CTT ON CTT.mapt=PT.mapt
	WHERE PT.mapm=@MAPM

	RETURN @NUM
END
GO

CREATE
--ALTER
PROCEDURE THEM_PM @MAPM VARCHAR(10), @MADG VARCHAR(10), @MANV_L VARCHAR(5)
AS 
BEGIN
	--CHECK PRIMARY KEY
	IF EXISTS (SELECT 1 FROM PhieuMuon WHERE @MAPM=mapm)
		RAISERROR(N'PHIẾU MƯỢN ĐÃ TỒN TẠI', 15, 1)
	
	--CHECK INPUT
	IF EXISTS (SELECT 1 FROM PhieuMuon PM 
				join DocGia DG ON PM.madg=DG.madg
				JOIN NhanVien_TV NV ON PM.NVienLapPM= NV.MaNV
				WHERE @MANV_L=NV.MaNV AND @MADG=DG.madg AND PM.mapm=@MAPM)
	BEGIN
		RAISERROR(N'ĐÃ LẬP PHIẾU', 15, 1)
		RETURN
	END
	IF NOT EXISTS (SELECT 1 FROM DocGia WHERE @MADG = madg)
	BEGIN
		RAISERROR(N'ĐỘC GIẢ KHÔNG TỒN TẠI', 15, 1)
		RETURN
	END
	IF NOT EXISTS (SELECT 1 FROM NhanVien_TV WHERE @MANV_L=MaNV)
	BEGIN
		RAISERROR(N'NHÂN VIÊN KHÔNG TỒN TẠI', 15, 1)
		RETURN
	END
	
	--NGAY MUON LA NGAY HTAI
	DECLARE @NGAYMUON DATE
	SET @NGAYMUON = GETDATE()

	--DÃ TRẢ HẾT MỚI CÓ PHIẾU TRẢ => KTRA PHIẾU TRẢ TỒN TẠI HAY KHÔNG
	DECLARE @DATRA INT
	EXEC @DATRA = DATRA @MAPM

	--ĐẾM SỐ SÁCH TỪ PHIẾU TRẢ (THEO MAPM) =>BANG SACH TRONG PHIEU MUON HAY KHONG
	--


	IF (@DATRA=1)
	BEGIN
		INSERT PhieuMuon(mapm, madg, ngaymuon, NVienLapPM)
		VALUES (@MAPM, @MADG, @NGAYMUON, @MANV_L)

		PRINT 'ĐÃ THÊM THÀNH CÔNG'
	END
	ELSE 
	BEGIN
		RAISERROR(N'CHƯA TRẢ HẾT SÁCH', 15, 1)
		RETURN
	END
END
GO

EXEC THEM_PM 'PM001', 'DG02', '001'
