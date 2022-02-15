DECLARE @sql				NVARCHAR(MAX);
DECLARE @OutputPath			NVARCHAR(4000);
DECLARE @SessionName		NVARCHAR(4000);
DECLARE @SessionTargetPath	NVARCHAR(4000);
DECLARE @SessionMetaDataPath	NVARCHAR(4000);
DECLARE @MaxFileSizeMb		INT;
DECLARE @FileNumber			INT;
DECLARE @StartUpState		CHAR(3);
DECLARE @BlockedThreshold	INT;

--Config==================================================================================

SET @SessionName		= 'BF_BlockedProcess';
SET @MaxFileSizeMb		= 100;
SET @FileNumber			= 5;
SET @StartUpState		= 'ON';
SET @BlockedThreshold	= 5; --Threshold in seconds

--========================================================================================
--Enable blocked process threshold
SET @sql = '
EXEC sp_configure ''show advanced options'', 1 ;
RECONFIGURE ;
EXEC sp_configure ''blocked process threshold'', ''' + CONVERT(VARCHAR(10),@BlockedThreshold) + ''';
RECONFIGURE
'
EXEC sp_executesql @sql

SELECT @OutputPath = [path] FROM sys.dm_os_server_diagnostics_log_configurations;
SET @SessionTargetPath = @OutputPath + @SessionName + '.xel' ;
SET @SessionMetaDataPath = @OutputPath + @SessionName + '.xem' ;

SET @sql ='
	CREATE EVENT SESSION [' + @SessionName + '] ON SERVER 
	ADD EVENT sqlserver.blocked_process_report(
		ACTION(sqlserver.client_app_name,sqlserver.client_hostname,sqlserver.database_name)) ,
	ADD EVENT sqlserver.xml_deadlock_report (
		ACTION(sqlserver.client_app_name,sqlserver.client_hostname,sqlserver.database_name))
	ADD TARGET package0.asynchronous_file_target(
		SET filename=N''' + @SessionTargetPath + ''',
		metadatafile=N''' + @SessionMetaDataPath + ''',
		max_file_size=(' + CONVERT(VARCHAR(10),@MaxFileSizeMb) + '),
		max_rollover_files=(' + CONVERT(VARCHAR(10),@FileNumber) + '))
	WITH (MAX_MEMORY=4096 KB,
	MAX_DISPATCH_LATENCY=5 SECONDS,
	STARTUP_STATE=' + @StartUpState + ')
	
	/* Start the Extended Events session */
	ALTER EVENT SESSION [' + @SessionName + '] ON SERVER
	STATE = START;
	'

--SELECT @sql
EXEC sp_executesql @sql