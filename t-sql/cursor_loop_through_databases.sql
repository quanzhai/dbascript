DECLARE @DBName VARCHAR(255)
DECLARE @SQL NVARCHAR(255)

DECLARE FULLRECOVERY CURSOR FOR   
SELECT name  
FROM sys.databases where database_id > 5 

OPEN FULLRECOVERY 
FETCH NEXT FROM FULLRECOVERY INTO @DBName 
WHILE @@FETCH_STATUS = 0 
BEGIN
    --SET @SQL = 'BACKUP DATABASE ' + @DBName  + ' TO  DISK = N''NUL'' WITH NOFORMAT, NOINIT,  NAME = N''NULL'', SKIP, NOREWIND, NOUNLOAD,  STATS = 10' 
	--SET @SQL = 'BACKUP DATABASE ' + @DBName  + ' TO  DISK = N''G:\Data\Backup\' + @DBName  +'.bak'' WITH COPY_ONLY, NOFORMAT, NOINIT,  NAME = N''' + @DBName  +' full backup'', SKIP, NOREWIND, NOUNLOAD,  STATS = 10' 
	--SET @SQL = 'ALTER DATABASE [' + @DBName + '] SET RECOVERY FULL' 
	--SET @SQL = 'USE '+@DBName+'; CREATE USER [SCB\scb.secure.sql.COMMON.Exstream_all.Read] FOR LOGIN [SCB\scb.secure.sql.COMMON.Exstream_all.Read];'
	--SET @SQL = 'USE '+@DBName+'; ALTER ROLE [db_datareader] ADD MEMBER [SCB\scb.secure.sql.COMMON.Exstream_all.Read];'
	SET @SQL = 'USE '+@DBName+'; ALTER USER [SCB\scb.secure.sql.COMMON.Exstream_all.Read] WITH DEFAULT_SCHEMA=[dbo];'
	PRINT @SQL 
    --EXECUTE sp_executesql @sql 
    FETCH next FROM FULLRECOVERY INTO @DBName 

END 

CLOSE FULLRECOVERY 
DEALLOCATE FULLRECOVERY 