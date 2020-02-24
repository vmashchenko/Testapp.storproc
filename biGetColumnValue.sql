
CREATE FUNCTION [dbo].[GetColumnValue](
    @String VARCHAR(MAX),
    @Delimiter CHAR(1),
    @Column INT = 1
)
RETURNS VARCHAR(MAX)
AS
-- select [dbo].[GetColumnValue](' 11 | [UnitPrice] | decimal(18,2)','|',3)

BEGIN
DECLARE @idx INT
DECLARE @slice VARChar(MAX)     
SELECT @idx = 1     
    IF LEN(@String)<1 OR @String IS NULL
        RETURN NULL
DECLARE @ColCnt INT
    SET @ColCnt = 1
WHILE (@idx != 0)
BEGIN    
    SET @idx = CHARINDEX(@Delimiter,@String)     
    IF @idx!=0 
    BEGIN
        IF (@ColCnt = @Column) 
            RETURN LEFT(@String,@idx - 1);        
        SET @ColCnt = @ColCnt + 1;
    END ELSE BEGIN
        IF (@ColCnt = @Column) 
            RETURN @String;        
	END
    SET @String = RIGHT(@String,LEN(@String) - @idx)     
    IF LEN(@String) = 0 BREAK
END
RETURN @String  
END
GO


