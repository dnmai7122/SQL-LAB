---BÀI TẬP TRÊN LỚP---

-- a 
CREATE PROCEDURE HELLO 
AS 
	print 'Hello World !!!'

Exec HELLO

-- b
CREATE PROCEDURE sp_Tong @so1 int, @so2 int
AS
	print @so1 + @so2

Exec sp_Tong 3, 7

-- c
create procedure tinhTong @so1 int, @so2 int, @tong int out
as
	set @tong = @so1 + @so2;

declare @Tong int
exec tinhTong 10, -1, @Tong out
print @Tong

-- d
create procedure tong_3so @so1 int , @so2 int, @so3 int
as
	begin
	declare @tong2so int
	exec tinhTong @so1, @so2, @tong2so out
	print @tong2so + @so3
	end
go

exec tong_3so 10, 2, -3

-- e
create procedure tong_m_den_n @m int, @n int 
as
	begin
	declare @tong int
	declare @i int
	set @tong = 0
	set @i = @m 
	while (@i < @n)
		begin
		set @tong = @tong + @i
		set @i = @i + 1 
		end

	end
	print @tong
go

exec tong_m_den_n 1, 10

-- f
create 
--ALTER
procedure KT_SNT @n int
as
begin
	declare @i int
	declare @souoc int
	set @i = 1
	set @souoc = 0
	while (@i < @n)
	begin
		if (@n % @i = 0)
			set @souoc = @souoc + 1
		set @i = @i + 1
	end

	if(@n = 1)
		set @souoc = 2

	if (@souoc > 1)
		print N'Không là SNT'
	else
		print N'Là SNT'
end
go

exec KT_SNT 13


-- ham kiem tra SNT tra ve bien 0 hoac 1
create procedure kiemtra_SNT @n int, @kq int out
as
begin
	declare @i int
	declare @souoc int
	set @i = 1
	set @souoc = 0
	while (@i < @n)
	begin
		if (@n % @i = 0)
			set @souoc = @souoc + 1
		set @i = @i + 1
	end

	if(@n = 1)
		set @souoc = 2

	if (@souoc > 1)
		set @kq = 0
	else
		set @kq = 1
end
go

declare @kq int
exec kiemtra_SNT 5, @kq out
print @kq

-- g. In ra tổng các số nguyên từ m đến n
create procedure tong_M_N @m int, @n int, @kq int out
as
begin
	declare @tong int
	declare @i int

	set @tong = 0
	set @i= @m

	while(@i <= @n)
	begin
		set @tong=@tong+@i
		set @i=@i+1
	end

	set @kq=@tong
end
go

declare @kq int
exec tong_M_N 5, 8, @kq out
print @kq

--h. Tính ước chung lớn nhất của 2 số nguyên.
create procedure sp_UCLN @a int, @b int
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

--i. Tính bội chung nhỏ nhất của 2 số nguyên.
create procedure sp_BCNN @a int, @b int
as begin
	declare @UCLN int
	exec @UCLN = sp_UCLN @a, @b
	return @a * @b / @UCLN
end
go

declare @BCNN int
exec @BCNN = sp_BCNN 12, 18
print 'Uoc chung lon nhat cua 2 so la: ' + cast(@BCNN as varchar)

--j. Xuất ra toàn bộ danh sách giáo viên.
create procedure sp_listGV
as begin
	select * from GIAOVIEN
end
go

exec sp_listGV

--k. Tính số lượng đề tài mà một giáo viên đang thực hiện.
create procedure sp_SLDT @MaGV char(5)
as begin
	select GV.MAGV, COUNT(distinct TG.MADT) as SL_DeTai
	from GIAOVIEN GV join THAMGIADT TG on GV.MAGV = TG.MAGV
	where GV.MAGV = @MaGV
	group by GV.MAGV
end 
go

exec sp_SLDT '005'

--l. In thông tin chi tiết của một giáo viên(sử dụng lệnh print): Thông tin cá nhân, Số lượng đề tài tham gia, Số lượng thân nhân của giáo viên đó.
create procedure sp_TT_ChiTiet @MaGV char(5)
as begin
	if not exists (select MAGV from GIAOVIEN where MAGV = @MaGV)
	begin
		print N'Mã giáo viên không tồn tại'
		return
	end
	declare @hoten nchar(50)
	declare @SLDT int
	declare @SLTN int
	set @SLDT = 0
	set @SLTN = 0

	select @hoten = HOTEN from GIAOVIEN where @MaGV = MAGV

	select @SLDT = count(distinct TG.MADT) 
					from GIAOVIEN GV JOIN THAMGIADT TG ON GV.MAGV = TG.MAGV 
					WHERE GV.MAGV = @MaGV
					GROUP BY GV.MAGV

	select @SLTN = count(*) 
					from GIAOVIEN GV JOIN NGUOITHAN TN ON GV.MAGV = TN.MAGV
					WHERE GV.MAGV = @MaGV
					GROUP BY GV.MAGV

	print N'Mã giáo viên: ' + @MaGV
	print N'Họ tên giáo viên: ' + @hoten
	print N'Số lượng đề tài tham gia: ' + cast(@SLDT as nvarchar)
	print N'Số lượng thân nhân: ' + cast(@SLTN as nvarchar)

end
go

exec sp_TT_ChiTiet '005'

--m. Kiểm tra xem một giáo viên có tồn tại hay không (dựa vào MAGV).
create procedure sp_KT_TonTai @MaGV char(5)
as begin
	if (exists (select * from GIAOVIEN where MAGV = @MaGV))
		print N'giáo viên có tồn tại'
	else
		print N'giáo viên không có tồn tại'
end
go

--exec sp_KT_TonTai '001'
exec sp_KT_TonTai '011'

--n. Kiểm tra quy định của một giáo viên: Chỉ được thực hiện các đề tài mà bộ môn của giáo viên đó làm chủ nhiệm.
create procedure sp_KT_QuyDinh 
	@MaGV char(5),
	@MaDT char(5)
as begin
	IF EXISTS 
		(SELECT 1
		FROM GIAOVIEN GV, GIAOVIEN TBM, BOMON BM, DETAI DT
		WHERE GV.MAGV = @MaGV AND GV.MABM = BM.MABM AND TBM.MABM = BM.MABM
			AND TBM.MAGV = BM.TRUONGBM AND DT.MADT = @MaDT AND DT.GVCNDT = TBM.MAGV)
	BEGIN
		PRINT N'Đúng quy định'
	END
	
	ELSE
		PRINT N'Sai quy định'
end
go

EXEC sp_KT_QuyDinh '002', '003'

--o. Thực hiện thêm một phân công cho giáo viên thực hiện một công việc của
--đề tài:
	--o Kiểm tra thông tin đầu vào hợp lệ: giáo viên phải tồn tại, công việc
	--phải tồn tại, thời gian tham gia phải >0
	--o Kiểm tra quy định ở câu n.

create procedure sp_PhanCongCV @MaGV char(5), @MaDT char(5), @STT int
as
begin
	if not exists (select 1 from GIAOVIEN where @MaGV=MAGV)
	begin
		raiserror(N'GIÁO VIÊN KHÔNG TỒN TẠI', 15,1)
		RETURN
	END
	if not exists (select 1 from CONGVIEC where @MaDT=MADT and @STT=STT)
	begin
		raiserror(N'CÔNG VIỆC KHÔNG TỒN TẠI', 15,1)
		RETURN
	END
	IF NOT EXISTS (SELECT 1 FROM THAMGIADT WHERE @MaGV=MAGV AND @MaDT=MADT AND @STT=STT)
	BEGIN
		RAISERROR(N'ĐÃ ĐƯỢC PHÂN CÔNG', 15, 1)
		RETURN
	END

	DECLARE @MABM_GV CHAR(5),
			@MABM_CNDT CHAR(5)

	SELECT @MABM_GV=MABM
	FROM GIAOVIEN
	WHERE @MaGV=MAGV

	SELECT @MABM_CNDT=GV.MABM
	FROM DETAI DT
	JOIN GIAOVIEN GV ON GV.MAGV=DT.GVCNDT
	WHERE @MaDT=MADT

	IF(@MABM_GV=@MABM_CNDT)
		INSERT THAMGIADT(MAGV,MADT,STT)
		VALUES (@MaGV, @MaDT, @STT)
	ELSE RAISERROR(N'KHÔNG HỢP LỆ', 15,1)
end
GO

EXEC sp_PhanCongCV '002', '002', '2'

--p
create procedure sp_XoaGiaoVien 
	@MaGV char(10)
as
begin
	if exists (
			select TN.MAGV
			from NGUOITHAN TN
			where TN.MAGV = @MaGV
			UNION
			select DT.GVCNDT
			from DETAI DT
			where DT.GVCNDT = @MaGV
			UNION 
			select TG.MAGV
			from THAMGIADT TG
			where TG.MAGV = @MaGV
			UNION
			select BM.TRUONGBM
			from BOMON BM
			where BM.TRUONGBM = @MaGV
			UNION
			select K.TRUONGKHOA
			from KHOA K
			where K.TRUONGKHOA = @MaGV
			)
			print N'Không thể xóa giáo viên vì có thông tin liên quan'
	else
	begin
		delete from GIAOVIEN where MAGV = @MaGV
		print N'Xóa giáo viên thành công'
	end
end
go

exec sp_XoaGiaoVien '011'


--q. 
create procedure sp_DSGV_PhongBan
	@mabm nchar(10)
as
begin
	select GV.MAGV, GV.HOTEN,
							(select count(distinct TG.MADT)
							from THAMGIADT TG
							where TG.MAGV = GV.MAGV) as SLDT,
							(select count(tn.TEN)
							from NGUOITHAN TN
							where TN.MAGV = GV.MAGV) as SoThanNhan,
							(select count(*)
							from GIAOVIEN GV2
							where GV2.GVQLCM = GV.MAGV) as SoGVQL
	from GIAOVIEN GV
	where GV.MABM = @mabm
end
go
exec sp_DSGV_PhongBan 'HTTT'

--r
CREATE PROCEDURE sp_KiemTraQuyDinhHaiGiaoVien
    @MAGV_A char(5),
    @MAGV_B char(5)
AS
BEGIN
    -- Kiểm tra 2 gv A và B có tồn tại hay không
    IF NOT EXISTS (SELECT 1 FROM GIAOVIEN WHERE MAGV = @MAGV_A) OR
       NOT EXISTS (SELECT 1 FROM GIAOVIEN WHERE MAGV = @MAGV_B)
    BEGIN
        PRINT N'Mã giáo viên không tồn tại'
        RETURN
    END

    -- Kiểm tra xem giáo viên A có là trưởng bộ môn không
    IF EXISTS (
        SELECT 1
        FROM GIAOVIEN A, GIAOVIEN B, BOMON C
        WHERE A.MAGV = @MAGV_A AND A.MABM = C.MABM AND A.MAGV = C.TRUONGBM
			AND B.MAGV = @MAGV_B AND B.MABM = C.MABM AND A.MAGV != B.MAGV
    )
    BEGIN
        DECLARE @Luong_A MONEY, @Luong_B MONEY
		SELECT @Luong_A = Luong FROM GIAOVIEN WHERE MAGV = @MAGV_A
		SELECT @Luong_B = Luong FROM GIAOVIEN WHERE MAGV = @MAGV_B

		IF @Luong_A <= @Luong_B
		BEGIN
			PRINT N'Lương của giáo viên A phải cao hơn lương của giáo viên B.'
			RETURN
		END
		ELSE
			PRINT N'Giáo viên A đáp ứng quy định: Là trưởng bộ môn của giáo viên B và lương cao hơn giáo viên B.'
    END

	ELSE
	BEGIN
		print N'Giáo viên A không phải là trưởng bộ môn của giáo viên B'
	END
END
go

EXEC sp_KiemTraQuyDinhHaiGiaoVien '002', '004'


--s
create procedure sp_ADD_GV 
	@MaGV char(3),
	@Hoten nvarchar(50),
	@Luong money,
	@Phai nvarchar(5),
	@Ngsinh date,
	@Diachi nvarchar(50),
	@GVQLCM char(3),
	@MaBM nvarchar(5)
as begin
	if exists (select MAGV from GIAOVIEN where MAGV = @MaGV)
	begin
		print N'Mã giáo viên đã tồn tại'
		return
	end
	if exists (select MAGV from GIAOVIEN where HOTEN = @Hoten)
	begin
		print N'Họ tên giáo viên đã tồn tại'
		return
	end
	if DATEDIFF(YY, @Ngsinh, GETDATE()) <= 18
	begin
		print N'Tuổi <= 18'
		return
	end
	if @Luong <= 0
	begin
		print N'Lương <= 0'
		return
	end
	
	insert into GIAOVIEN(MAGV,HOTEN,LUONG,PHAI,NGSINH,DIACHI,GVQLCM,MABM)
	values (@MaGV, @Hoten, @Luong, @Phai, @Ngsinh, @Diachi, @GVQLCM, @MaBM)
	print N'Thêm giáo viên thành công'
end
go

exec sp_ADD_GV '011', N'NGUYỄN A', 2300, 'Nam', '01/01/2001', N'TPHCM', NULL, 'HTTT'

--t
create procedure sp_MAGV_TIEPTHEO
as 
begin
	declare @MaGV char(10) = '001'
	declare @idx int
	set @idx = 1
	while exists (select MAGV from GIAOVIEN where MAGV = @MaGV)
	begin
		set @idx += 1
		set @MaGV = REPLICATE('0', 3 - LEN(cast(@idx as varchar))) + cast(@idx as varchar) 
	end
	print 'Ma giao vien tiep theo la: ' + @MaGV
end
go

exec sp_MAGV_TIEPTHEO

---BÀI TẬP VỀ NHÀ---

use master
go
if DB_ID('QL_DatPhong') is not null
	drop database QL_DatPhong
go
create database QL_DatPhong
go
use QL_DatPhong
go

create table PHONG
(
	MaPhong char(10),
	TinhTrang nvarchar(10),
	Loai int,
	DonGia money

	constraint PK_PHONG
	primary key(MaPhong)
)

create table KHACH
(
	MaKH char(10),
	HoTen nvarchar(50),
	DiaChi nvarchar(50),
	SDT char(10),

	constraint PK_KHACH
	primary key(MaKH)
)

create table DATPHONG
(
	Ma int,
	MaKH char(10),
	MaPhong char(10),
	NgayDP date,
	NgayTra date,
	ThanhTien money

	constraint PK_DATPHONG
	primary key(Ma)
)

alter table DATPHONG
add 
	constraint FK_DATPHONG_PHONG
	foreign key(MaPhong)
	references PHONG,

	constraint FK_DATPHONG_KHACH
	foreign key (MaKH)
	references KHACH

insert PHONG
values
	('P001', N'Rảnh', 1, 100000),
	('P002', N'Bận', 2, 200000),
	('P003', N'Bận', 1, 100000)

insert KHACH
values
	('K001', N'Nguyễn A', N'Quận 10', '0123456789'),
	('K002', N'Lê B', N'Quận 1', '0123450011'),
	('K003', N'Trần C', N'Bình Chánh', '0123459988')


--1. Viết stored procedure
create 
--alter
procedure sp_DatPhong
	@makh char(5),
	@maphong char(5),
	@ngaydat date
as begin
	if not exists (select 1 from KHACH K where @makh = K.MaKH)
	begin
		print N'Khách hàng không tồn tại'
		return
	end
	if not exists (select 1 from PHONG P where @maphong = P.MaPhong)
	begin
		print N'Phòng không tồn tại'
		return
	end
	if exists (select 1 from PHONG P where @maphong = P.MaPhong and P.TinhTrang != N'Rảnh')
	begin
		print N'phòng không rảnh'
		return
	end

	declare @MaDP int
	set @MaDP = 1
	while exists (select Ma from DATPHONG where Ma = @MaDP)
	begin
		set @MaDP += 1
	end

	insert DATPHONG(Ma, MaKH, MaPhong, NgayDP, NgayTra, ThanhTien)
	values (@MaDP, @makh, @maphong, @ngaydat, NULL, NULL)
	print N'Đặt phòng thành công'

	UPDATE PHONG
		set TinhTrang = N'Bận'
		where MaPhong = @maphong

end
go

exec sp_DatPhong 'K001', 'P001', '01/01/2023'
--exec sp_DatPhong 'K002', 'P002', '01/02/2023'

--2. Viết stored procedure spTraPhong
create
--alter
procedure spTraPhong
	@madp int,
	@makh char(5)
as begin
	if exists (select 1 from DATPHONG where Ma = @madp and MaKH = @makh)
	begin
		declare @NgayTP date
		set @NgayTP = GETDATE()

		declare @NgayDP date
		select @NgayDP = NgayDP from DATPHONG where @madp = Ma

		declare @TienThanhToan money
		select @TienThanhToan = datediff(DD, @NgayDP, @NgayTP) * P.DonGia 
		from DATPHONG DP JOIN Phong P on DP.MaPhong = P.MaPhong
		where DP.Ma = @madp

		UPDATE DATPHONG
			set NgayTra = @NgayTP
			where Ma = @madp

		UPDATE DATPHONG
			set ThanhTien = @TienThanhToan
			where Ma = @madp

		UPDATE PHONG
			set TinhTrang = N'Rảnh'
			from DATPHONG DP JOIN PHONG P ON DP.MaPhong = P.MaPhong
			where DP.Ma = @madp
	end
	
	else
	begin
		print N'Mã đặt phòng và khách hàng không hợp lệ'
		return
	end
end
go

exec spTraPhong 1, 'K002'