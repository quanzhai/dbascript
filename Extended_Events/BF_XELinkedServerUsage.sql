DECLARE @sql				NVARCHAR(MAX);
DECLARE @OutputPath			NVARCHAR(4000);
DECLARE @SessionName		NVARCHAR(4000);
DECLARE @SessionTargetPath	NVARCHAR(4000);
DECLARE @MaxFileSizeMb		INT;
DECLARE @FileNumber			INT;
DECLARE @StartUpState		CHAR(3);

--Config==================================================================================

SET @SessionName		= 'BF_XELinkedServerUsage';
SET @MaxFileSizeMb		= 100;
SET @FileNumber			= 3;
SET @StartUpState		= 'ON';

--========================================================================================
SELECT @OutputPath = [path] FROM sys.dm_os_server_diagnostics_log_configurations;
SET @SessionTargetPath = @OutputPath + @SessionName + '.xel' ;


SET @sql ='
	CREATE EVENT SESSION [' + @SessionName + '] ON SERVER 
	ADD EVENT sqlserver.oledb_call(
		ACTION(package0.last_error,sqlserver.client_app_name,sqlserver.client_hostname,sqlserver.database_name,sqlserver.nt_username,sqlserver.session_nt_username,sqlserver.sql_text)
		WHERE ([sqlserver].[equal_i_sql_unicode_string]([method_name],N''IGetDataSource::GetDataSource'') AND [opcode]=(0)))
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


/*Query the extended event files
select event_data = CONVERT(XML, event_data) 
INTO #t
FROM sys.fn_xe_file_target_read_file(N'BF_XELinkedServerUsage*.xel', NULL, NULL, NULL);


SELECT	max(timestamp) as timestamp
		, linked_server_name
		, database_name
		, client_hostname
		, server_principal_name
		, LEFT (sql_text, 200) + '.......' as sql_text
FROM (
	SELECT
		timestamp    = event_data.value(N'(event/@timestamp)[1]', N'datetime'),
		linked_server_name = event_data.value(N'(event/data[@name="linked_server_name"]/value)[1]', N'nvarchar(max)'),
		database_name = event_data.value(N'(event/action[@name="database_name"]/value)[1]', N'nvarchar(max)'),
		client_hostname = event_data.value(N'(event/action[@name="client_hostname"]/value)[1]', N'nvarchar(max)'),
		client_app_name = event_data.value(N'(event/action[@name="client_app_name"]/value)[1]', N'nvarchar(max)'),
		session_nt_username = event_data.value(N'(event/action[@name="session_nt_username"]/value)[1]', N'nvarchar(max)'),
		nt_username = event_data.value(N'(event/action[@name="nt_username"]/value)[1]', N'nvarchar(max)'),
		server_principal_name = event_data.value(N'(event/action[@name="server_principal_name"]/value)[1]', N'nvarchar(max)'),
		username = event_data.value(N'(event/action[@name="username"]/value)[1]', N'nvarchar(max)'),
		sql_text = event_data.value(N'(event/action[@name="sql_text"]/value)[1]', N'nvarchar(max)')
		--spid  = event_data.value(N'(event/action[@name="session_id"]/value)[1]', N'int'), *
	FROM #t
) AS xei
GROUP BY linked_server_name, database_name, client_hostname, server_principal_name, sql_text
ORDER BY timestamp desc

DROP TABLE #t
*/