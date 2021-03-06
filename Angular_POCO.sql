/****** Object:  StoredProcedure [dbo].[AngularDomainPOCO]    Script Date: 7/13/2018 4:12:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[AngularDomainPOCO]
    @table VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
 
DECLARE @TableName sysname = @table
DECLARE @ConstructorResult VARCHAR(MAX)
DECLARE @Result varchar(max) = ' export class ' + @TableName + ' {
	'

	select @Result = @Result + 	'
	   ' + LOWER(LEFT(ColumnName,1)) + RIGHT(ColumnName, LEN(ColumnName)-1) + ': '+ ColumnType +  ';' 
	from
	(
		select 
			replace(col.name, ' ', '_') ColumnName,
			column_id ColumnId,
			case typ.name 
				when 'bigint' then 'number'
				when 'binary' then 'byte[]'
				when 'bit' then 'boolean'
				when 'char' then 'string'
				when 'date' then 'Date'
				when 'datetime' then 'Date'
				when 'datetime2' then 'Date'
				when 'datetimeoffset' then 'Date'
				when 'decimal' then 'number'
				when 'float' then 'number'
				when 'image' then 'byte[]'
				when 'int' then 'number'
				when 'money' then 'number'
				when 'nchar' then 'string'
				when 'ntext' then 'string'
				when 'numeric' then 'number'
				when 'nvarchar' then 'string'
				when 'real' then 'number'
				when 'smalldatetime' then 'Date'
				when 'smallint' then 'number'
				when 'smallmoney' then 'number'
				when 'text' then 'string'
				when 'time' then 'Date'
				when 'timestamp' then 'Date'
				when 'tinyint' then 'number'
				when 'uniqueidentifier' then 'string'
				when 'varbinary' then 'byte[]'
				when 'varchar' then 'string'
				else 'UNKNOWN_' + typ.name
			end ColumnType
		from sys.columns col
			join sys.types typ on
				col.system_type_id = typ.system_type_id AND col.user_type_id = typ.user_type_id
		where object_id = object_id(@TableName)
	) t
	order by ColumnId
		set @Result = @Result  + '
		mode: FormMode;'+'
	'
	SELECT @ConstructorResult = ' constructor() {
	'

	select @ConstructorResult = @ConstructorResult + 	'
	   ' + 'this.'+ LOWER(LEFT(ColumnName,1)) + RIGHT(ColumnName, LEN(ColumnName)-1) + ' = '+ DefaultValue +  ';' 
	from
	(
		select 
			replace(col.name, ' ', '_') ColumnName,
			column_id ColumnId,
			case typ.name 
				when 'bigint' then '0'
				when 'binary' then 'null'
				when 'bit' then 'false'
				when 'char' then ''''''
				when 'date' then 'new Date()'
				when 'datetime' then 'new Date()'
				when 'datetime2' then 'new Date()'
				when 'datetimeoffset' then 'new Date()'
				when 'decimal' then '0'
				when 'float' then '0'
				when 'image' then 'null'
				when 'int' then '0'
				when 'money' then '0'
				when 'nchar' then ''''''
				when 'ntext' then ''''''
				when 'numeric' then ''''''
				when 'nvarchar' then ''''''
				when 'real' then '0'
				when 'smalldatetime' then 'new Date()'
				when 'smallint' then '0'
				when 'smallmoney' then '0'
				when 'text' then ''''''
				when 'time' then 'new Date()'
				when 'timestamp' then 'new Date()'
				when 'tinyint' then '0'
				when 'uniqueidentifier' then ''''''
				when 'varbinary' then 'null'
				when 'varchar' then ''''''
				else 'UNKNOWN_' + typ.name
			end DefaultValue
		from sys.columns col
			join sys.types typ on
				col.system_type_id = typ.system_type_id AND col.user_type_id = typ.user_type_id
		where object_id = object_id(@TableName)
	) t
	order by ColumnId
	set @ConstructorResult = @ConstructorResult  +'		
	this.mode = FormMode.Add;'+'
	'
	set @Result = @Result  + @ConstructorResult +'
	 	}'+'
	}'

SELECT @Result
END

EXEC dbo.AngularDomainPOCO @table = 'RidiesTask' -- varchar(100)
