
DECLARE @username NVARCHAR(500)
DECLARE @privilege NVARCHAR(500) 
DECLARE @sql NVARCHAR(4000) 
DECLARE @fix_orphaned_user BIT 
DECLARE @cnt INT 
SET @fix_orphaned_user = 0  -- set this to 1 to also fix the orphaned user
DECLARE c1 CURSOR FOR 
SELECT dp.NAME 
FROM   sys.database_principals dp 
LEFT JOIN sys.server_principals sp ON dp.sid = sp.sid 
WHERE   (dp.type_desc = 'WINDOWS_USER' or dp.type_desc = 'WINDOWS_GROUP') 
AND dp.authentication_type_desc = 'WINDOWS'
AND dp.principal_id != 1 
AND sp.sid IS NULL 
OPEN c1 
FETCH c1 INTO @username 
WHILE @@FETCH_STATUS = 0 
BEGIN 
SET @cnt = Isnull(@cnt, 0) + 1 
SET @sql = 'CREATE LOGIN [' + @username + '] FROM WINDOWS WITH DEFAULT_DATABASE = [' + DB_NAME() + ']' 
            PRINT @sql 
FETCH c1 INTO @username 
END 
CLOSE c1 
DEALLOCATE c1 
IF @cnt IS NULL 
  RAISERROR('No orphaned windows users found',10,1)
