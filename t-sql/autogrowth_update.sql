DECLARE @name VARCHAR(50) -- database name  
DECLARE @cmd NVARCHAR(MAX)
DECLARE @growthsizeLog INT = 512 
DECLARE @growthsizeData INT = 1024 

CREATE TABLE ##space
(DatabaseName sysname, Name sysname, Type varchar(10), size int, Growth varchar(15), Commands nvarchar(MAX))

CREATE TABLE ##spacetemp
(DatabaseName sysname, Name sysname, Type int, size int, Growth numeric (18,0), PercentGrowth int) 

DECLARE db_cursor CURSOR READ_ONLY FOR  
SELECT name
FROM master.dbo.sysdatabases
OPEN db_cursor   
FETCH NEXT FROM db_cursor INTO @name
 
WHILE @@FETCH_STATUS = 0   
BEGIN
	
	SET @cmd = 'USE [' + @name + '] select ''' + @name + ''' as [database], name, type, size, growth, is_percent_growth from sys.database_files'
	INSERT INTO ##spacetemp
	EXECUTE sp_executesql @cmd

   FETCH NEXT FROM db_cursor INTO @name   
END   
 
CLOSE db_cursor   
DEALLOCATE db_cursor

insert into ##space
select	DatabaseName
		, Name
		, CASE Type
			WHEN 1 THEN 'Log'
			WHEN 0 THEN 'Data'
		END AS 'Type',
		 CONVERT(DECIMAL(10,2),size/128.0)
		, CASE 
			WHEN PercentGrowth = 0 THEN CAST(Growth/128 AS varchar(12)) + 'MB'
			WHEN PercentGrowth = 1 THEN CAST(Growth AS varchar(12)) + '%'
		END AS 'Growth'
		
		, CASE
			--Change commands for Log files 
			WHEN Type = 1 and ((PercentGrowth = 1) or (PercentGrowth = 0 and Growth/128 < @growthsizeLog)) THEN 'ALTER DATABASE [' + DatabaseName + '] MODIFY FILE ( NAME = N''' + name + ''', FILEGROWTH = ' + CAST(@growthsizeLog*1024 AS varchar(12)) + 'KB )'
			--Change commands for Data files
			WHEN Type = 0 and ((PercentGrowth = 1) or (PercentGrowth = 0 and Growth/128 < @growthsizeData)) THEN 'ALTER DATABASE [' + DatabaseName + '] MODIFY FILE ( NAME = N''' + name + ''', FILEGROWTH = ' + CAST(@growthsizeData*1024 AS varchar(12)) + 'KB )'
			ELSE NULL
		END as [Commands]

from	##spacetemp


select * from ##space where Commands is not null 
DROP TABLE ##space
DROP TABLE ##spacetemp