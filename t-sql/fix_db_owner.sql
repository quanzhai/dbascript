
/*check db owner on all databases*/
SELECT suser_sname( owner_sid ), * FROM sys.databases
 
--From <https://social.msdn.microsoft.com/Forums/sqlserver/en-US/3215905e-4a9f-4c5a-a335-8334a067aa98/how-to-get-the-database-owner-name-in-tsql-script> 
 
---------------------------------------------------------------------------------------------------
-- Check the databases that does not have sa account as the owner
SELECT name AS DBName, suser_sname(owner_sid) AS DBOwner 
FROM sys.databases
WHERE suser_sname(owner_sid) <> 'sa'
 
-- Generate the scripts to make sa account as owner for all the databases
SELECT 'ALTER AUTHORIZATION ON DATABASE::' + QUOTENAME(name) + ' TO [bf_dbowner];'
from sys.databases
where name not in ('master', 'model', 'tempdb', 'msdb')
AND suser_sname(owner_sid) <> 'sa'
 
--From <http://sqlserverzest.com/2015/05/05/sql-server-change-ownership-for-all-user-databases-to-sa-account/>
