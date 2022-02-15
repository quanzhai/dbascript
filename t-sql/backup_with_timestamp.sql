--https://stackoverflow.com/questions/2410674/add-date-to-sql-database-backup-filename/2410757
--https://www.mssqltips.com/sqlservertip/1145/date-and-time-conversions-using-sql-server/


DECLARE @MyFileName varchar(1000)

SELECT @MyFileName = (SELECT 'G:\Data\Backup\Infa_tdm_' + replace(convert(varchar, getdate(),23),'-','_') +'_'+ replace(convert(varchar, getdate(),108),':','_') + '.bak') 
BACKUP DATABASE Infa_tdm TO  DISK = @MyFileName WITH  COPY_ONLY, NOFORMAT, NOINIT,  NAME = N'Infa_tdm-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10

