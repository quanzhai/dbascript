-- Extended event that logs what SQL query that triggered growth of temdb files

DECLARE @sql					NVARCHAR(MAX);
DECLARE @OutputPath				NVARCHAR(4000);
DECLARE @SessionName			NVARCHAR(4000);
DECLARE @SessionTargetPath		NVARCHAR(4000);
DECLARE @SessionMetaDataPath	NVARCHAR(4000);
DECLARE @MaxFileSizeMb			INT;
DECLARE @FileNumber				INT;
DECLARE @StartUpState			CHAR(3);

--Config==================================================================================

SET @SessionName		= 'BF_Tempdb_Growth';
SET @MaxFileSizeMb		= 100;
SET @FileNumber			= 3;
SET @StartUpState		= 'ON';

--========================================================================================
SELECT @OutputPath = [path] FROM sys.dm_os_server_diagnostics_log_configurations;
SET @SessionTargetPath = @OutputPath + @SessionName + '.xel' ;
SET @SessionMetaDataPath = @OutputPath + @SessionName + '.xem' ;

SET @sql ='
CREATE EVENT SESSION [' + @SessionName + '] ON SERVER 
ADD EVENT sqlserver.database_file_size_change(
ACTION(sqlserver.client_hostname,sqlserver.database_id,sqlserver.session_id,sqlserver.sql_text)
WHERE ([database_id]=(2) AND [sqlserver].[session_id]>(50))),
ADD EVENT sqlserver.databases_log_file_size_changed(
ACTION(sqlserver.client_hostname,sqlserver.database_id,sqlserver.session_id,sqlserver.sql_text)) 
ADD TARGET package0.event_file(
	SET filename=N''' + @SessionTargetPath + ''',
	max_file_size=(' + CONVERT(VARCHAR(10),@MaxFileSizeMb) + '),
	max_rollover_files=(' + CONVERT(VARCHAR(10),@FileNumber) + '))
WITH (MAX_MEMORY=4096 KB,
EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,
MAX_DISPATCH_LATENCY=30 SECONDS,
MAX_EVENT_SIZE=0 KB,MEMORY_PARTITION_MODE=NONE,
TRACK_CAUSALITY=OFF,
STARTUP_STATE=' + @StartUpState + ')'

--SELECT @sql
EXEC sp_executesql @sql
