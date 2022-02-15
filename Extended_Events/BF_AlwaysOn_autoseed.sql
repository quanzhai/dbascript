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

SET @SessionName		= 'BF_AlwaysOn_autoseed';
SET @MaxFileSizeMb		= 100;
SET @FileNumber			= 3;
SET @StartUpState		= 'ON';

--========================================================================================
SELECT @OutputPath = [path] FROM sys.dm_os_server_diagnostics_log_configurations;
SET @SessionTargetPath = @OutputPath + @SessionName + '.xel' ;
SET @SessionMetaDataPath = @OutputPath + @SessionName + '.xem' ;

SET @sql ='
CREATE EVENT SESSION [' + @SessionName + '] ON SERVER 
    ADD EVENT sqlserver.hadr_automatic_seeding_state_transition,
    ADD EVENT sqlserver.hadr_automatic_seeding_timeout,
    ADD EVENT sqlserver.hadr_db_manager_seeding_request_msg,
    ADD EVENT sqlserver.hadr_physical_seeding_backup_state_change,
    ADD EVENT sqlserver.hadr_physical_seeding_failure,
    ADD EVENT sqlserver.hadr_physical_seeding_forwarder_state_change,
    ADD EVENT sqlserver.hadr_physical_seeding_forwarder_target_state_change,
    ADD EVENT sqlserver.hadr_physical_seeding_progress,
    ADD EVENT sqlserver.hadr_physical_seeding_restore_state_change,
    ADD EVENT sqlserver.hadr_physical_seeding_submit_callback
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





