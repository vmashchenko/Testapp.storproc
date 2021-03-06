CREATE PROCEDURE [dbo].[BulkImportFile]

@Configuration as nvarchar(50),
@FileName as nvarchar(max)

-- exec [dbo].BulkImportFile 'Sales', 'C:\Work\DataBulk\test1.csv'

AS
BEGIN

if not exists (select * from sysobjects where name='Tmp' and xtype='U')
create table Tmp ([Value] nvarchar(max))
delete from Tmp; 

declare @TableName nvarchar(50);
declare @CustomTableName nvarchar(50);
declare @ConfigId int;

select
	@ConfigId=Id,
	@TableName=TableName
from dbo.[Config] 
where ConfigName=@Configuration

set @CustomTableName=replace(replace(@TableName,']',''),'[','');

declare @TableDef nvarchar(max)='';
declare @FieldsDef nvarchar(max)='';
declare @FieldValuesDef nvarchar(max)='';
declare @sql nvarchar(max)='';

declare @Position int;
declare @FieldName nvarchar(50);
declare @FieldType nvarchar(50);

declare fields_cursor cursor for
	select _fields.Position, _fields.FieldName, _fields.FieldType
	from dbo.ConfigFields _fields
	where _fields.ConfigId=@ConfigId
        ORDER BY _fields.Position

declare @row int=1;
open fields_cursor;
fetch next from fields_cursor into @Position, @FieldName, @FieldType;
while (@@FETCH_STATUS <> -1)  
BEGIN;  
	if @row > 1 begin 
		set @FieldsDef += ', '; 
		set @TableDef  += ', ';
		set @FieldValuesDef += ', ';
	end;
    
	set @FieldsDef+=@FieldName;
    set @TableDef+=@FieldName+' '+@FieldType;
	if (charindex('decimal',@FieldType)>0 or charindex('int',@FieldType)>0) begin
		set @FieldValuesDef+='cast(dbo.GetColumnValue(_tmp.[Value], '','', '+cast(@Position as varchar)+') as '+@FieldType+') as '+@FieldName;
	end else begin
		set @FieldValuesDef+='dbo.GetColumnValue(_tmp.[Value], '','', '+cast(@Position as varchar)+') as '+@FieldName;
	end;
	set @row+=1;
    fetch next from fields_cursor into @Position, @FieldName, @FieldType;
END;  
CLOSE fields_cursor;  
DEALLOCATE fields_cursor;  

set @TableDef=' create table '+@TableName+'('+ @TableDef+') ';

if not exists (select * from sysobjects where name=@CustomTableName and xtype='U') exec (@TableDef);

set @sql='BULK INSERT Tmp from '''+@FileName+''' with (FIRSTROW=2)';
exec (@sql);

set @sql='insert into '+@TableName+'('+@FieldsDef+') select ';
set @sql+=@FieldValuesDef;
set @sql+=' from Tmp _tmp ';

exec (@sql);

print 'Import completed.'

END























