/*
Taken from https://dbafromthecold.com/2017/06/07/identifying-failed-queries-with-extended-events/
What this is going to do is create an extended event that will automatically startup when the SQL instance starts and capture all errors recorded that have a severity level greater than 10.

Full documentation on severity levels can be found here: https://docs.microsoft.com/en-us/sql/relational-databases/errors-events/database-engine-error-severities?view=sql-server-ver15
but levels 1 through 10 are really just information and you don’t need to worry about them. 

*/


DECLARE @sql					NVARCHAR(MAX);
DECLARE @OutputPath				NVARCHAR(4000);
DECLARE @SessionName			NVARCHAR(4000);
DECLARE @SessionTargetPath		NVARCHAR(4000);
DECLARE @SessionMetaDataPath	NVARCHAR(4000);
DECLARE @MaxFileSizeMb			INT;
DECLARE @FileNumber				INT;
DECLARE @StartUpState			CHAR(3);

--Config==================================================================================

SET @SessionName		= 'BF_FailedQueries';
SET @MaxFileSizeMb		= 100;
SET @FileNumber			= 3;
SET @StartUpState		= 'ON';

--========================================================================================
SELECT @OutputPath = [path] FROM sys.dm_os_server_diagnostics_log_configurations;
SET @SessionTargetPath = @OutputPath + @SessionName + '.xel' ;
SET @SessionMetaDataPath = @OutputPath + @SessionName + '.xem' ;


SET @sql ='
	CREATE EVENT SESSION [' + @SessionName + '] ON SERVER 
	ADD EVENT sqlserver.error_reported(
        ACTION(sqlserver.client_app_name,sqlserver.client_hostname,sqlserver.database_name,sqlserver.sql_text,sqlserver.username)
            WHERE ([package0].[greater_than_int64]([severity],(10))))
	ADD TARGET package0.event_file(
		SET filename=N''' + @SessionTargetPath + ''',
        metadatafile=N''' + @SessionMetaDataPath + ''',
		max_file_size=(' + CONVERT(VARCHAR(10),@MaxFileSizeMb) + '),
		max_rollover_files=(' + CONVERT(VARCHAR(10),@FileNumber) + '))
	WITH (MAX_MEMORY=4096 KB,
	EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,
	MAX_DISPATCH_LATENCY=20 SECONDS,
	MAX_EVENT_SIZE=0 KB,
	MEMORY_PARTITION_MODE=NONE,
	TRACK_CAUSALITY=OFF,
	STARTUP_STATE=' + @StartUpState + ')'

--SELECT @sql
EXEC sp_executesql @sql
