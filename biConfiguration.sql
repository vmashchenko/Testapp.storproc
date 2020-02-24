if not exists (select * from sysobjects where name='Config' and xtype='U')
create table Config (
	Id int NOT NULL,
	ConfigName nvarchar(50) NOT NULL,
	TableName  nvarchar(50) NOT NULL
)

if not exists (select * from sysobjects where name='ConfigFields' and xtype='U')
create table ConfigFields (
	Id int IDENTITY(1,1) NOT NULL,
	ConfigId int not null,
	Position int not null,
	FieldName  nvarchar(50) NOT NULL,
	FieldType  nvarchar(50) NOT NULL
)

declare @ConfigName nvarchar(50);
declare @TableName nvarchar(50);
declare @ConfigId int;
-------------------------------------------------------
-- Config Definitions 
-------------------------------------------------------
set @ConfigId=1;
set @ConfigName='Sales';
set @TableName='Sales';

insert into dbo.Config (Id,ConfigName,TableName) values(@ConfigId,@ConfigName,@TableName);
insert into dbo.ConfigFields (ConfigId,Position,FieldName,FieldType) 
values(@ConfigId,  1,'Region','nvarchar(100)');
insert into dbo.ConfigFields (ConfigId,Position,FieldName,FieldType) 
values(@ConfigId,  3,'ItemType','nvarchar(100)');
insert into dbo.ConfigFields (ConfigId,Position,FieldName,FieldType) 
values(@ConfigId, 11,'UnitPrice','decimal(18,2)');
--------------------------------------------------------



































