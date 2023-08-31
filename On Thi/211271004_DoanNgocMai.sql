CREATE 
--ALTER
PROC PHANCONGCV
	@Magv char(5),
	@MaDT char(5),
	@STT int
as begin
	if not exists (select 1 from GIAOVIEN where MAGV = @Magv)
	begin
		raiserror(N'Mã giáo viên không tồn tại', 15, 1)
		return
	end
	if not exists (select 1 from CONGVIEC where MADT = @MaDT and STT = @STT)
	begin
		raiserror(N'Công việc không tồn tại', 15, 1)
		return
	end
	if exists (select 1 from THAMGIADT
				where MAGV = @Magv and MADT = @MaDT and STT = @STT)
	begin
		raiserror(N'Đã phân công', 15, 1)
		return
	end

	declare @count int
	select @count = count(TG.STT)
	from THAMGIADT TG
	where TG.MAGV = @Magv and TG.MADT = @MaDT

	if (@count > 3)
	begin
		raiserror(N'Tối đa 3 công việc', 15, 1)
		return
	end
	
	insert THAMGIADT(MAGV, MADT, STT)
	values (@Magv, @MaDT, @STT)

end
go
---test
exec PHANCONGCV '001','006', 2
		
CREATE 
--ALTER
PROC NGKT @NGKT DATE,
			@MADT VARCHAR(5)
AS
BEGIN
	IF NOT EXISTS (SELECT 1 FROM DETAI WHERE @MADT=MADT)
		RAISERROR(N'ĐỀ TÀI KHÔNG TỒN TẠI', 15, 1)
	DECLARE @CAP NVARCHAR(15),
					@NGBD DATE

	SELECT @CAP= DT.CAPQL, @NGBD=DT.NGAYBD
	FROM DETAI DT
	WHERE @MADT=DT.MADT

	IF (@CAP = N'TRƯỜNG')
	BEGIN
		IF (DATEDIFF(MONTH, @NGBD, @NGKT) < 3 OR DATEDIFF(MONTH, @NGBD, @NGKT) > 6)
			RAISERROR(N'Thời gian thực hiện đề tài cấp trường phải từ 3 tháng đến 6 tháng', 15, 1)
		ELSE
			UPDATE DETAI
			SET NGAYKT = @NGKT
			WHERE MADT = @MADT

	END

	ELSE IF (@CAP='ĐHQG')
	BEGIN
		IF(DATEDIFF(MONTH,@NGBD,@NGKT)<6 OR DATEDIFF(MONTH,@NGBD, @NGKT) > 9)
			RAISERROR(N'Thời gian thực hiện đề tài cấp ĐHQG phải từ 6 tháng đến 9 tháng', 15, 1)
		ELSE
			UPDATE DETAI
			SET NGAYKT = @NGKT
			WHERE MADT = @MADT
	END

	ELSE IF (@CAP='NHÀ NƯỚC')
	BEGIN
		IF(DATEDIFF(MONTH,@NGBD,@NGKT)<12 OR DATEDIFF(MONTH,@NGBD,@NGKT)>24)
			RAISERROR(N'Thời gian thực hiện đề tài cấp nhà nước phải từ 12 tháng đến 24 tháng', 15, 1)
		ELSE
			UPDATE DETAI
			SET NGAYKT = @NGKT
			WHERE MADT = @MADT
	END
	ELSE
		RAISERROR(N'Cấp đề tài không hợp lệ', 15, 1)
END
GO

exec NGKT '08/08/2003','001'

CREATE
--ALTER
PROCEDURE UD_GVQLCM @MAGV_QL VARCHAR(5), @MAGV VARCHAR(5)
AS
BEGIN

	IF NOT EXISTS (SELECT 1 FROM GIAOVIEN WHERE @MAGV=MAGV)
		RAISERROR(N'GIÁO VIÊN KHÔNG TỒN TẠI',15,1)
	
	DECLARE @BM_QL NVARCHAR(30),
			@BM_GV NVARCHAR(30)

	SELECT @BM_QL=GV.MABM
	FROM GIAOVIEN GV
	WHERE @MAGV_QL=GV.MAGV

	SELECT @BM_GV=GV.MABM
	FROM GIAOVIEN GV
	WHERE @MAGV=GV.MAGV

	IF (@BM_QL<>@BM_GV)
		RAISERROR(N'GVQLBM KHÁC BỘ MÔN VỚI GV', 15, 1)
	ELSE
		UPDATE GIAOVIEN
		SET GVQLCM=@MAGV_QL
		WHERE MAGV = @MAGV

END
GO

EXEC UD_GVQLCM '003', '002'

--4
CREATE
--ALTER
PROCEDURE UD_TK @TK VARCHAR(5), @MK VARCHAR(5)
AS
BEGIN
	DECLARE @TBM VARCHAR(5), @GVQL VARCHAR(5)

	IF NOT EXISTS (SELECT 1 FROM KHOA WHERE @MK=MAKHOA)
		RAISERROR(N'KHOA KHÔNG TỒN TẠI', 15, 1)

	SELECT @TBM = BM.TRUONGBM
	FROM BOMON BM 
	WHERE BM.TRUONGBM = @TK

	SELECT @GVQL=QL.MAGV
	FROM GIAOVIEN GV
	JOIN GIAOVIEN QL ON QL.MAGV=GV.GVQLCM
	WHERE @TK=GV.MAGV

	IF(@TK=@GVQL OR @TK=@TBM)
		RAISERROR(N'TRƯỞNG KHOA ĐÃ LÀ TRƯỞNG BỘ MÔN HOẶC LÀ GVQLCM', 15,1)
	ELSE 
		UPDATE KHOA
		SET TRUONGKHOA=@TK
		WHERE MAKHOA=@MK
END
GO

EXEC UD_TK '005', 'CNTT'

--5
CREATE
--ALTER
PROCEDURE PHANCONGNS @MAGV CHAR(5), @STT CHAR(5), @MADT CHAR(5)
AS
BEGIN
	IF NOT EXISTS (SELECT 1 FROM GIAOVIEN WHERE @MAGV=MAGV)
	BEGIN
		RAISERROR(N'GIÁO VIÊN KHÔNG TỒN TẠI', 15, 1)
		RETURN
	END

	IF NOT EXISTS (SELECT 1 FROM CONGVIEC WHERE @STT=STT AND @MADT=MADT)
	BEGIN
		RAISERROR(N'CÔNG VIỆC KHÔNG TỒN TẠI', 15, 1)
		RETURN
	END

	DECLARE @SOTG INT,
			@CAP NVARCHAR(15)

	SELECT @SOTG=COUNT(DISTINCT MAGV)
	FROM THAMGIADT TG
	WHERE MADT=@MADT AND @STT=STT
	GROUP BY MADT

	SELECT @CAP=DT.CAPQL
	FROM DETAI DT
	WHERE @MADT=DT.MADT

	IF (@CAP=N'TRƯỜNG')
	BEGIN
		IF(@SOTG>2)
			RAISERROR(N'SỐ LƯỢNG GV TG VƯỢT QUÁ 2', 15,1)
		ELSE 
			insert THAMGIADT(MAGV, MADT, STT)
			values (@Magv, @MaDT, @STT)
	END
	ELSE IF (@CAP=N'ĐHQG')
	BEGIN
		IF(@SOTG>4)
			RAISERROR(N'SỐ LƯỢNG GV TG VƯỢT QUÁ 4', 15,1)
		ELSE 
			insert THAMGIADT(MAGV, MADT, STT)
			values (@Magv, @MaDT, @STT)
	END
	ELSE IF (@CAP=N'NHÀ NƯỚC')
	BEGIN
		IF(@SOTG>5)
			RAISERROR(N'SỐ LƯỢNG GV TG VƯỢT QUÁ 5', 15,1)
		ELSE 
			insert THAMGIADT(MAGV, MADT, STT)
			values (@Magv, @MaDT, @STT)
	END
	ELSE RAISERROR(N'Cấp đề tài không hợp lệ', 15, 1)
END
GO

EXEC PHANCONGNS '002','1','002'

--6
CREATE 
--ALTER
FUNCTION F_SLGV_MADT(@MADT CHAR(5))
RETURNS INT
AS
BEGIN
    DECLARE @SLGV INT;

    SELECT @SLGV = COUNT(DISTINCT TG.MAGV)
    FROM THAMGIADT TG
    WHERE TG.MADT = @MADT;

    RETURN @SLGV;
END;
GO
--KIỂM TRA
DECLARE @SLGV INT;
SET @SLGV = dbo.F_SLGV_MADT('002');

PRINT N'Số lượng giảng viên là: ' + CAST(@SLGV AS NVARCHAR(MAX));

--7.	Viết function đếm số đề tài tham gia của 1 magv
CREATE 
--ALTER
FUNCTION F_SDT_GV(@MAGV CHAR(5))
RETURNS INT
AS
BEGIN
    DECLARE @SDT INT;

    SELECT @SDT = COUNT(DISTINCT TG.MADT)
    FROM THAMGIADT TG
    WHERE TG.MAGV = @MAGV;

    RETURN @SDT;
END;
GO

--KIỂM TRA
DECLARE @SDT INT;
SET @SDT = dbo.F_SDT_GV('002');

PRINT N'Số lượng đề tài là: ' + CAST(@SDT AS NVARCHAR(MAX));

--8.	Viết function đếm số công việc của 1 madt
CREATE 
--ALTER
FUNCTION F_SCV_DT(@MADT CHAR(5))
RETURNS INT
AS
BEGIN
    DECLARE @SCV INT;

    SELECT @SCV = COUNT(DISTINCT CV.STT)
    FROM CONGVIEC CV
    WHERE CV.MADT=@MADT;

    RETURN @SCV;
END;
GO

--KIỂM TRA
DECLARE @SCV INT;
SET @SCV = dbo.F_SCV_DT('002');

PRINT N'Số lượng công việc là: ' + CAST(@SCV AS NVARCHAR(MAX));
--9.	Viết function đếm số đề tài của 1 makhoa
CREATE 
--ALTER
FUNCTION F_SDT_MK(@MAKHOA CHAR(5))
RETURNS INT
AS
BEGIN
    DECLARE @SDT INT;

    SELECT @SDT = COUNT(DISTINCT TG.MADT)
    FROM THAMGIADT TG
	JOIN GIAOVIEN GV ON GV.MAGV=GV.MAGV
	JOIN BOMON BM ON BM.MABM=GV.MABM
	JOIN KHOA K ON K.MAKHOA=BM.MAKHOA
    WHERE K.MAKHOA = @MAKHOA;

    RETURN @SDT;
END;
GO

--KIỂM TRA
DECLARE @SDT INT;
SET @SDT = dbo.F_SDT_MK('HH');

PRINT N'Số lượng đề tài của 1 khoa là: ' + CAST(@SDT AS NVARCHAR(MAX));
--10.	 Viết function đếm số đề tài chủ nhiệm của 1 magv
CREATE 
--ALTER
FUNCTION F_SDT_GVCN(@MAGV CHAR(5))
RETURNS INT
AS
BEGIN
    DECLARE @SDT INT;

    SELECT @SDT = COUNT(DISTINCT DT.MADT)
    FROM GIAOVIEN GV
	JOIN DETAI DT ON DT.GVCNDT=GV.MAGV
    WHERE GV.MAGV = @MAGV;

    RETURN @SDT;
END;
GO

--KIỂM TRA
DECLARE @SDT INT;
SET @SDT = dbo.F_SDT_GVCN('002');

PRINT N'Số lượng đề tài chủ nhiệm của 1 gv là: ' + CAST(@SDT AS NVARCHAR(MAX));
--11.	Viết stored xuất danh sách (magv, ho ten, ten bo mon) của các giảng viên tham gia trên 3 đề tài (sử dụng function câu 7)
CREATE 
--ALTER
PROCEDURE
SP_DSGV_3DT
AS
BEGIN
	SELECT gv.MAGV, GV.HOTEN, BM.TENBM
	FROM GIAOVIEN GV
	JOIN THAMGIADT TG ON GV.MAGV=TG.MAGV
	JOIN BOMON BM ON BM.MABM=GV.MABM
	WHERE dbo.F_SDT_GV(gv.MAGV)>3
END
GO

EXEC SP_DSGV_3DT;

--12.	Viết stored xuất danh sách (magv, họ tên, số đề tài tham gia) của mỗi 
--giảng viên (sử dụng câu 7)
CREATE 
--ALTER
PROCEDURE SP_DSGV
AS 
BEGIN
	SELECT GV.MAGV, GV.HOTEN, dbo.F_SDT_GV(gv.MAGV) AS N'SỐ ĐỀ TÀI THAM GIA'
	FROM GIAOVIEN GV
	
END
GO 

EXEC SP_DSGV
--13.	 Viết stored procedure cho biết mã khoa, tên khoa, số lượng đề tài đã nghiệm thu của các khoa trong năm 2022 (gọi lại function câu 9)
CREATE 
--ALTER
PROCEDURE
SP_SDT_K_2022
AS
BEGIN
	SELECT MAKHOA, TENKHOA, DBO.F_SDT_MK(MAKHOA) AS N'SỐ ĐỀ TÀI CỦA KHOA'
	FROM KHOA K
END

EXEC SP_SDT_K_2022
--14.	 Viết stored procedure cho biết khoa nào có số đề tài đã nghiệm thu nhiều nhất.
--TRƯỜNG HỢP CHỈ LẤY 1 KHOA CÓ ĐỀ TÀI NHIỀU NHẤT
CREATE--ALTER
PROCEDURE SP_K_DTNN
AS
BEGIN
	SELECT TOP 1 KHOA.TENKHOA, DBO.F_SDT_MK(KHOA.MAKHOA) AS SoDeTaiNghiemThu
    FROM KHOA
    ORDER BY SoDeTaiNghiemThu DESC;
END
GO

EXEC SP_K_DTNN

--TRONG TRƯỜNG HỢP CÓ NHIỀU KHOA CÓ CÙNG SỐ ĐỀ TÀI NHIỀU NHẤT
CREATE --ALTER
PROCEDURE SP_K_DTNN_OPT
AS
BEGIN
	--tìm số đề tài đã nghiệm thu nhiều nhất
    WITH MaxDeTaiCTE AS (
        SELECT TOP 1 DBO.F_SDT_MK(KHOA.MAKHOA) AS MaxDeTai
        FROM KHOA
        ORDER BY MaxDeTai DESC
    )

	--xét những KHOA có số đề tài = MAX
    SELECT KHOA.TENKHOA, DBO.F_SDT_MK(KHOA.MAKHOA) AS SoDeTaiNghiemThu
    FROM KHOA
	--số đề tài đã nghiệm thu trong bảng KHOA phải bằng số đề tài nhiều nhất đã tìm thấy từ CTE
    JOIN MaxDeTaiCTE ON DBO.F_SDT_MK(KHOA.MAKHOA) = MaxDeTaiCTE.MaxDeTai;
END;

EXEC SP_K_DTNN_OPT
