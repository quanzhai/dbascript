/*
Script kills all SPIDs on a specified database (@MyDB)
*/

DECLARE @MyDB AS char(20)
-- Change DB here
SET @MyDB = 'ProcessControl'



-- Do not change below this line -----------------
-- Creates a temptable to keep track on what SPIDs that are gone

CREATE TABLE #KILLIST (
	MySPID INT,
	MyDate char(20))

DECLARE @MySPID varchar(50)
DECLARE MyKILL_Cursor CURSOR FOR
	SELECT [spid]
	FROM [master].[dbo].[sysprocesses]
	WHERE dbid IN(SELECT [dbid]
		FROM [master].[dbo].[sysdatabases]
		WHERE name = @MyDB )

OPEN MyKILL_Cursor

FETCH NEXT FROM MyKILL_Cursor
	INTO @MySPID
WHILE @@FETCH_STATUS = 0
BEGIN
	exec ('kill ' + @MySPID)
	insert INTO #KILLIST
		values (@MySPID, GETDATE())
		
    FETCH NEXT FROM MyKILL_Cursor
	INTO @MySPID

END

-- Close and Dealocate Cursor
CLOSE MyKILL_Cursor
DEALLOCATE MyKILL_Cursor

-- Skriv ut vilka vi kört kill på
SELECT MySPID AS SPID, MyDate AS Killed_TIME 
FROM #KILLIST

drop table #KILLIST



