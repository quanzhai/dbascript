
--This will lists the orphaned users:
DECLARE @temp
table (Username VARCHAR(MAX), SID varbinary(200))

DECLARE @orphan
table (DatabaseName VARCHAR(MAX), Username VARCHAR(MAX), SID varbinary(200))

DECLARE 
    @db_name VARCHAR(MAX),
	@sql_command varchar(max);
 
DECLARE cursor_dbname CURSOR
FOR SELECT name FROM  sys.databases
OPEN cursor_dbname;
 
FETCH NEXT FROM cursor_dbname INTO 
    @db_name;
	WHILE @@FETCH_STATUS = 0
		BEGIN
			delete from @temp
			set @sql_command = 'use [' + @db_name +'] ' + 'EXEC sp_change_users_login ''Report'' '
			INSERT INTO @temp exec(@sql_command)
			insert into @orphan select @db_name, * from @temp
			FETCH NEXT FROM cursor_dbname INTO 
				@db_name; 
		END;
CLOSE cursor_dbname;
DEALLOCATE cursor_dbname;
select * from @orphan
