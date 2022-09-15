-- Extended event that logs user logins

DECLARE @sql					NVARCHAR(MAX);
DECLARE @OutputPath				NVARCHAR(4000);
DECLARE @SessionName			NVARCHAR(4000);
DECLARE @SessionTargetPath		NVARCHAR(4000);
DECLARE @SessionMetaDataPath	NVARCHAR(4000);
DECLARE @MaxFileSizeMb			INT;
DECLARE @FileNumber				INT;
DECLARE @StartUpState			CHAR(3);

--Config==================================================================================

SET @SessionName		= 'BF_LoginTracking';
SET @MaxFileSizeMb		= 1024;
SET @FileNumber			= 3;
SET @StartUpState		= 'ON';

--========================================================================================
SELECT @OutputPath = [path] FROM sys.dm_os_server_diagnostics_log_configurations;
SET @SessionTargetPath = @OutputPath + @SessionName + '.xel' ;
SET @SessionMetaDataPath = @OutputPath + @SessionName + '.xem' ;

SET @sql ='
CREATE EVENT SESSION [' + @SessionName + '] ON SERVER 
ADD EVENT sqlserver.login(
ACTION(sqlserver.client_app_name,sqlserver.client_hostname,sqlserver.nt_username,sqlserver.username)) 
ADD TARGET package0.event_file(
	SET filename=N''' + @SessionTargetPath + ''',
	max_file_size=(' + CONVERT(VARCHAR(10),@MaxFileSizeMb) + '),
	max_rollover_files=(' + CONVERT(VARCHAR(10),@FileNumber) + '))
WITH (MAX_MEMORY=4096 KB,
EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,
MAX_DISPATCH_LATENCY=30 SECONDS,
MAX_EVENT_SIZE=0 KB,
MEMORY_PARTITION_MODE=NONE,
TRACK_CAUSALITY=OFF,
STARTUP_STATE=' + @StartUpState + ')'

--SELECT @sql
EXEC sp_executesql @sql
