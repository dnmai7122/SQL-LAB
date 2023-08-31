create --alter
proc sp_tong @a int, @b int
as begin
	declare @res int	
	set @res = @a + @b
	print  @res

end
go


exec sp_tong 1, 2

create --alter
proc sp_tong_1 @a int, @b int, @kq int out
as begin
	set @kq = @a + @b
end

create --alter
proc sp_tong_ba @a int, @b int, @c int
as begin
	declare @res int

	exec sp_tong_1 @a, @b, @res out

	set @res = @res + @c
	print @res
end

exec sp_tong_ba 1, 2, 3

create --alter
proc sp_kt_SNT @a int
as begin
	declare @soUoc int
	declare @i int
	set @soUoc=0;
	set @i = 1
	while(@i <= @a) 
	begin
		if (@a % @i = 0)
			set @soUoc =@soUoc + 1;
		set @i = @i + 1
	end
	if (@soUoc > 2)
		print ' Khong la SNT'
	else print ' La SNT'
end
go

exec sp_kt_SNT 4


create --alter
proc sp_UCLN @a int, @b int, @kq int out
as begin
	declare @i int
	set @i=0

	while (@b !=0)
	begin
		set @i = @b
		set @b = @a % @b
		set @a = @i
	end

	set @kq = @a
end
go

declare @kq int 
exec sp_UCLN 1, 3, @kq out
print 'UCLN: ' + cast(@kq as varchar)

CREATE --alter 
PROCEDURE sp_BCNN
    @a INT,
    @b INT,
    @bcnn INT OUTPUT
AS
BEGIN
    DECLARE @ucln INT

    EXEC sp_UCLN @a, @b, @ucln out

    SET @bcnn = @a * @b / @ucln

END

DECLARE @r INT
EXEC sp_BCNN 2, 3, @r OUTPUT
PRINT 'BCNN: ' + CAST(@r AS VARCHAR)

create --alter
procedure sp_UCLN @a int, @b int
as begin
	while (@a != @b)
	begin
		if (@a > @b)
			set @a = @a - @b
		else 
			set @b -= @a
	end
	return @a
end
go

declare @UCLN int
exec @UCLN = sp_UCLN 12, 18
print 'UCLN cua 2 so la: ' + cast(@UCLN as varchar)


create --alter
procedure sp_BCNN @a int, @b int
as begin
	declare @UCLN int
	exec @UCLN = sp_UCLN @a, @b
	return @a * @b / @UCLN
end
go

declare @BCNN int
exec @BCNN = sp_BCNN 12, 18
print 'Uoc chung lon nhat cua 2 so la: ' + cast(@BCNN as varchar)

SELECT GV.MAGV
FROM GIAOVIEN GV
JOIN NGUOITHAN NT ON NT.MAGV= GV.MAGV
WHERE NT.QUANHE = 'CON'
GROUP BY GV.MAGV
HAVING 1 = COUNT(NT.TEN)
			

SELECT GV.MAGV
FROM GIAOVIEN GV
WHERE GV.MAGV IN (
    SELECT NT.MAGV
    FROM NGUOITHAN NT
    WHERE NT.QUANHE = 'CON'
    GROUP BY NT.MAGV
    HAVING COUNT(NT.MAGV) = 1
)


--CHO BIET MUC LUONG CAO NHAT CUA GIANG VEN
SELECT GV.MAGV
FROM GIAOVIEN GV, (SELECT MAX(GV.LUONG) AS L
					FROM GIAOVIEN GV) ML
WHERE GV.LUONG = ML.L

SELECT GV.MAGV
FROM GIAOVIEN GV
WHERE GV.LUONG = (SELECT MAX(GV.LUONG)
					FROM GIAOVIEN GV)

--TIM NHUNG GV CO LUONG  > ANY GV TRONG HTTT
SELECT GV.MAGV
FROM GIAOVIEN GV
WHERE GV.LUONG > ANY (SELECT GV1.LUONG
						FROM GIAOVIEN GV1
						WHERE GV1.MABM = 'HTTT')

--CHO BIẾT TÊN KHOA CÓ NHIỀU GV NHẤT


SELECT K.MAKHOA
FROM KHOA K
JOIN BOMON BM ON BM.MAKHOA = K.MAKHOA
JOIN GIAOVIEN GV ON GV.MABM = BM.MABM
GROUP BY K.MAKHOA
HAVING COUNT(GV.MAGV) = (
    SELECT TOP 1 COUNT(GV2.MAGV)
    FROM KHOA K2
    JOIN BOMON BM2 ON BM2.MAKHOA = K2.MAKHOA
    JOIN GIAOVIEN GV2 ON GV2.MABM = BM2.MABM
    GROUP BY K2.MAKHOA
    ORDER BY COUNT(GV2.MAGV) DESC
);

--CHO BIẾT TÊN GV CHỦ NHIỆM NHIỀU ĐỀ TÀI NHẤT
SELECT GV.HOTEN
FROM GIAOVIEN GV
JOIN THAMGIADT TG ON TG.MAGV=GV.MAGV
GROUP BY GV.MAGV, GV.HOTEN
HAVING COUNT(TG.MAGV) = (SELECT TOP 1 COUNT(TG.MAGV)
						FROM GIAOVIEN GV
						JOIN THAMGIADT TG ON TG.MAGV=GV.MAGV
						GROUP BY GV.MAGV
						ORDER BY COUNT(TG.MAGV) DESC
						)


SELECT GV.HOTEN
FROM GIAOVIEN GV
JOIN (
    SELECT TG.MAGV, COUNT(TG.MAGV) AS TGCount
    FROM THAMGIADT TG
    GROUP BY TG.MAGV
) TGCountSubquery ON TGCountSubquery.MAGV = GV.MAGV
WHERE TGCountSubquery.TGCount = (
    SELECT MAX(TGCount)
    FROM (
        SELECT COUNT(TG2.MAGV) AS TGCount
        FROM THAMGIADT TG2
        GROUP BY TG2.MAGV
    ) TGCounts
)


SELECT GV.HOTEN
FROM GIAOVIEN GV
JOIN (SELECT TG.MAGV, COUNT(TG.MAGV) AS SGV
	FROM THAMGIADT TG
	GROUP BY TG.MAGV
	) TG1 ON TG1.MAGV=GV.MAGV
WHERE TG1.SGV = (SELECT MAX(NUM.SGV)
				FROM (SELECT COUNT(TG.MAGV) AS SGV
						FROM THAMGIADT TG
						GROUP BY TG.MAGV) NUM)

--CHO BIET TBM CHU NHIEM NHIEU DT NHAT
SELECT BM.TRUONGBM
FROM BOMON BM 
JOIN DETAI DT ON DT.GVCNDT = BM.TRUONGBM
GROUP BY BM.TRUONGBM
HAVING COUNT(DT.GVCNDT) = (SELECT TOP 1 COUNT(DT.GVCNDT)
							FROM BOMON BM 
							JOIN DETAI DT ON DT.GVCNDT = BM.TRUONGBM
							GROUP BY DT.GVCNDT
							ORDER BY COUNT(DT.GVCNDT) DESC
							)

SELECT BM.TRUONGBM
FROM BOMON BM
JOIN (SELECT GVCNDT,COUNT(DT.GVCNDT) AS CN
		FROM DETAI DT 
		GROUP BY GVCNDT) CN ON GVCNDT= BM.TRUONGBM
WHERE CN.CN = (SELECT MAX(SL.CN)
				FROM (SELECT COUNT(DT.GVCNDT) AS CN
						FROM DETAI DT 
						GROUP BY DT.GVCNDT) SL
				)

--CHO BIẾT TÊN GV VÀ TÊN BM CỦA GV CÓ NHIỀU NT NHẤT
SELECT GV.HOTEN, BM.MABM
FROM GIAOVIEN GV 
JOIN BOMON BM ON BM.MABM=GV.MABM
JOIN NGUOITHAN NT ON NT.MAGV=GV.MAGV
GROUP BY GV.MAGV, GV.HOTEN, BM.MABM
HAVING COUNT(NT.MAGV) = (SELECT TOP 1 COUNT(NT.MAGV)
						FROM GIAOVIEN GV 
						JOIN BOMON BM ON BM.MABM=GV.MABM
						JOIN NGUOITHAN NT ON NT.MAGV=GV.MAGV
						GROUP BY NT.MAGV
						ORDER BY COUNT(NT.MAGV) DESC)

--CHO BIET GV THAM GIA TAT CA CV CUA DE TAI 002
SELECT GV.MAGV
FROM GIAOVIEN GV
WHERE NOT EXISTS (SELECT CV.MADT, CV.STT
					FROM CONGVIEC CV
					WHERE CV.MADT='006'
					EXCEPT
					SELECT TG.MADT, TG.STT
					FROM THAMGIADT TG
					WHERE TG.MAGV= GV.MAGV AND TG.MADT = '006')

SELECT GV.MAGV
FROM GIAOVIEN GV JOIN THAMGIADT TG ON TG.MAGV=GV.MAGV
WHERE TG.MADT = '006'
GROUP BY GV.MAGV
HAVING COUNT(DISTINCT TG.STT)=(SELECT COUNT(DISTINCT CV.STT)
								FROM CONGVIEC CV
								WHERE CV.MADT='006')


CREATE FUNCTION DEMDT (@MAGV VARCHAR(5))
RETURNS INT
AS
BEGIN
	DECLARE @SL INT

	SELECT @SL=COUNT(TG.MADT)
	FROM THAMGIADT TG
	JOIN DETAI DT ON DT.GVCNDT=TG.MAGV
	WHERE @MAGV=TG.MAGV

	RETURN @SL
END
GO

DECLARE @SL INT
SET @SL=DBO.DEMDT('001')
PRINT @SL

CREATE --alter
FUNCTION TINHTUOI()
RETURNS TABLE
AS 
	RETURN (SELECT GV.MAGV, DATEDIFF(YEAR, GV.NGSINH, GETDATE()) AS TUOI
			FROM GIAOVIEN GV)

GO

SELECT * FROM dbo.TINHTUOI();