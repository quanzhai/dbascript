/*Capture depracted features in use*/
DECLARE @sql					NVARCHAR(MAX);
DECLARE @OutputPath				NVARCHAR(4000);
DECLARE @SessionName			NVARCHAR(4000);
DECLARE @SessionTargetPath		NVARCHAR(4000);
DECLARE @SessionMetaDataPath	NVARCHAR(4000);
DECLARE @MaxFileSizeMb			INT;
DECLARE @FileNumber				INT;
DECLARE @StartUpState			CHAR(3);

--Config==================================================================================

SET @SessionName		= 'BF_DeprecatedFeatures';
SET @MaxFileSizeMb		= 100;
SET @FileNumber			= 3;
SET @StartUpState		= 'ON';

--========================================================================================
SELECT @OutputPath = [path] FROM sys.dm_os_server_diagnostics_log_configurations;
SET @SessionTargetPath = @OutputPath + @SessionName + '.xel' ;
SET @SessionMetaDataPath = @OutputPath + @SessionName + '.xem' ;


SET @sql ='
	CREATE EVENT SESSION [' + @SessionName + '] ON SERVER 
	ADD EVENT sqlserver.deprecation_announcement(
            ACTION(package0.collect_system_time,sqlserver.database_name,sqlserver.sql_text,sqlserver.transaction_id,sqlserver.username)),
	ADD EVENT sqlserver.deprecation_final_support(
            ACTION(package0.collect_system_time,sqlserver.database_name,sqlserver.sql_text,sqlserver.transaction_id,sqlserver.username))
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
	TRACK_CAUSALITY=ON,
	STARTUP_STATE=' + @StartUpState + ')'

--SELECT @sql
EXEC sp_executesql @sql

/*Select from extended event file with a group by:
CREATE TABLE #sql (idx bigint Primary Key IDENTITY(1,1), feature nvarchar(max), message nvarchar(max), event xml )
SELECT event_data = CONVERT(XML, event_data) 
 INTO #t
  FROM sys.fn_xe_file_target_read_file(N'F:\Install\MSSQL14.INTRA\MSSQL\Log\BF_DeprecatedFeatures*.xel', NULL, NULL, NULL);

  --select * from #t

INSERT INTO #sql
SELECT	event_data.value(N'(event/data[@name="feature"]/value)[1]', N'nvarchar(max)') AS [feature]
		,event_data.value(N'(event/data[@name="message"]/value)[1]', N'nvarchar(max)') AS [message]
		, event_data
FROM	#t

select feature, message from #sql
group by feature, message
--where DatabaseName not in ('msdb','CustomerConnectionDatabase')
--order by Duration desc

DROP TABLE #t
DROP TABLE #sql
*/