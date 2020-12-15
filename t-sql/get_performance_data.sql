-- First PASS
DECLARE @First INT
DECLARE @Second INT
SELECT @First = cntr_value
FROM sys.dm_os_performance_counters
WHERE OBJECT_NAME = 'MSSQL$MSSQL:Databases' -- Change name of your server
AND counter_name = 'Transactions/sec'
AND instance_name = 'hastus2015                                                                                                                      ';
-- Following is the delay
WAITFOR DELAY '00:00:01'
-- Second PASS
SELECT @Second = cntr_value
FROM sys.dm_os_performance_counters
WHERE OBJECT_NAME = 'MSSQL$MSSQL:Databases' -- Change name of your server
AND counter_name = 'Transactions/sec'
AND instance_name = 'hastus2015                                                                                                                      ';
SELECT (@Second - @First) 'TotalTransactions'
GO