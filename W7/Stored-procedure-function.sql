-- a 
CREATE PROCEDURE cauchao 
AS 
	print 'Hello World !!!'
Exec cauchao

-- b
CREATE PROCEDURE sp_Tong @so1 int, @so2 int
AS
	print @so1 + @so2
Exec sp_Tong 5, 10

-- c
create procedure tinhTong @so1 int, @so2 int, @tong int out
as
	set @tong = @so1 + @so2;

declare @Tong int
exec tinhTong 9, -4, @Tong out
print @Tong

-- d
create procedure tong3so @so1 int , @so2 int, @so3 int
as
	begin
	declare @tong2so int
	exec tinhTong @so1, @so2, @tong2so out
	print @tong2so + @so3
	end
go
exec tong3so 10, -1, 5

-- e
create procedure tinh_tong_m_den_n @m int, @n int 
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
exec tinh_tong_m_den_n 1, 20

-- f
create procedure kt_snt_1 @n int
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

exec kt_snt_1 1


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

--h. Tìm UCLN cua 2 so nguyen
create procedure UCLN @a int, @b int, @res int out
as
begin
	declare @ucln int
	declare @i int

	set @ucln = 0
	set @i = 1

	while(@i<@a and @i<@b)
	begin
		if(@a%@i=0 and @b%@i=0)
			set @ucln=@i
		set @i=@i+1
	end

	set @res=@ucln
end

declare @res int
exec UCLN 3, 9, @res out
print @res


