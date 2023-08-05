DROP PROCEDURE sp_hello_world_new;

CREATE PROCEDURE sp_hello_world_new
AS
BEGIN
    PRINT 'Hello World!!!';
END;
GO

EXEC sp_hello_world_new;
GO

CREATE PROCEDURE SP_TONG @A INT, @B INT
AS
BEGIN
    DECLARE @TONG INT
    SET @TONG = @A + @B
    PRINT @TONG
END;
GO

EXEC SP_TONG 1, 2;
GO

