DECLARE @sql				NVARCHAR(MAX);
DECLARE @OutputPath			NVARCHAR(4000);
DECLARE @SessionName		NVARCHAR(4000);
DECLARE @SessionTargetPath	NVARCHAR(4000);
DECLARE @MaxFileSizeMb		INT;
DECLARE @FileNumber			INT;
DECLARE @StartUpState		CHAR(3);

--Config==================================================================================

SET @SessionName		= 'BF_Long_running_queries';
SET @MaxFileSizeMb		= 100;
SET @FileNumber			= 3;
SET @StartUpState		= 'ON';

--========================================================================================
SELECT @OutputPath = [path] FROM sys.dm_os_server_diagnostics_log_configurations;
SET @SessionTargetPath = @OutputPath + @SessionName + '.xel' ;


SET @sql ='
	CREATE EVENT SESSION [' + @SessionName + '] ON SERVER 
	ADD EVENT sqlserver.rpc_completed(SET collect_statement=(1)
        ACTION(sqlserver.client_hostname,sqlserver.database_name,sqlserver.sql_text,sqlserver.username)
            WHERE ([package0].[greater_than_equal_uint64]([duration],(5000000)) AND [sqlserver].[is_system]=(0))),
    ADD EVENT sqlserver.sql_batch_completed(
        ACTION(sqlserver.client_hostname,sqlserver.database_name,sqlserver.sql_text,sqlserver.username)
            WHERE ([package0].[greater_than_equal_uint64]([duration],(5000000)) AND [sqlserver].[is_system]=(0)))
	ADD TARGET package0.event_file(
		SET filename=N''' + @SessionTargetPath + ''',
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
