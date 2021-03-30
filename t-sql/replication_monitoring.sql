/*
sp_replmonitorhelpsubscription
*/
exec sp_executesql N'-- Type of publication: 0 = Transactional, 1 = Snapshot, 2 = Merge
DECLARE @query NVARCHAR(MAX);

SET @query = N''
DECLARE @in_publisher NVARCHAR(4000) = '' + QUOTENAME(@publisher, N'''''''') + N'';'';

SELECT @query = @query + N''

USE '' + QUOTENAME([name]) + N'';

EXEC sys.sp_replmonitorhelpsubscription @publisher = @in_publisher, @publication_type = 2;
EXEC sys.sp_replmonitorhelpsubscription @publisher = @in_publisher, @publication_type = 1;
EXEC sys.sp_replmonitorhelpsubscription @publisher = @in_publisher, @publication_type = 0;''
FROM [master].sys.databases
WHERE is_distributor = 1;

EXEC (@query);',N'@publisher varchar(15)',@publisher='SCB-PP-DKDBN402'


/*
Find pending commands in replication
*/
exec sp_executesql N'SET NOCOUNT ON;

SET @____MachineName = UPPER(@____MachineName)
SET @____InstanceName = UPPER(@____InstanceName)
DECLARE @__MachineName NVARCHAR(128)
SET @__MachineName = (SELECT UPPER(CONVERT(NVARCHAR(128), SERVERPROPERTY(''MachineName''))))
DECLARE @__InstanceName NVARCHAR(128)
SET @__InstanceName = (SELECT UPPER(CONVERT(NVARCHAR(128), ISNULL(SERVERPROPERTY(''InstanceName''), ''MSSQLSERVER''))))
IF @____MachineName != @__MachineName OR @____InstanceName != @__InstanceName
BEGIN
	DECLARE @msg NVARCHAR(MAX)	
	DECLARE @throwError NVARCHAR(MAX)
	
	IF (LEFT(CAST(SERVERPROPERTY(''productversion'') as NVARCHAR), 2) > 10)
	  BEGIN 
		  SET @msg = N''Properties MachineName and InstanceName do not match. Requested properties MachineName="'' + @____MachineName + N''" and InstanceName="'' + @____InstanceName + N''". Expected properties MachineName="'' + @__MachineName + N''" and InstanceName="'' + @__InstanceName + N''".'';
		  set @throwError = N''THROW 60000,@msg,1''
	  END 
	ELSE 
	  BEGIN 
		  SET @msg = N''SQLServer2008: Properties MachineName and InstanceName do not match. Requested properties MachineName="'' + @____MachineName + N''" and InstanceName="'' + @____InstanceName + N''". Expected properties MachineName="'' + @__MachineName + N''" and InstanceName="'' + @__InstanceName + N''".'';
		  set @throwError = N''RAISERROR (@msg, 16, 1)''
	  END 

	EXEC sp_executesql @throwError, N''@msg NVARCHAR(MAX)'', @msg = @msg
END; 

DECLARE @query NVARCHAR(max);

SET @query = N''
DECLARE @replication_servers TABLE (
	server_id INT NOT NULL
	,[name] SYSNAME NOT NULL
	,[data_source] NVARCHAR(4000)
	);
DECLARE @data TABLE (
	Publisher NVARCHAR(4000)
	,Subscriber NVARCHAR(4000)
	,PublisherDb SYSNAME
	,SubscriberDb SYSNAME
	,Publication SYSNAME
	,PendingCmdCount INT NULL
	);
DECLARE @temp TABLE (pendingcmdcount INT NULL);
DECLARE @agent_id INT
	,@xact_seqno VARBINARY(16)
	,@subscriber_db SYSNAME
	,@publisher_db SYSNAME
	,@publication SYSNAME
	,@publisher NVARCHAR(4000)
	,@subscriber NVARCHAR(4000)
	,@pendingcmdcount INT;

DECLARE @pend_command_limit INT = '' + CAST(@pendingCommandLimit AS NVARCHAR(MAX)) + '';'';

SELECT @query = @query + N''

USE '' + QUOTENAME([name]) + N'';

DELETE
FROM @replication_servers;

IF OBJECT_ID(N''''dbo.MSreplservers'''') IS NOT NULL
	INSERT INTO @replication_servers
	SELECT srvid
		,srvname
		,[data_source]
	FROM dbo.MSreplservers AS r
	INNER JOIN [master].sys.servers AS s ON s.[name] = r.srvname COLLATE SQL_Latin1_General_CP1_CI_AS;
ELSE
	INSERT INTO @replication_servers
	SELECT server_id
		,[name]
		,[data_source]
	FROM [master].sys.servers;

DECLARE INFO_CURSOR CURSOR
FOR
SELECT a.id
	,ISNULL(h.xact_seqno, 0x0) AS xact_seqno
	,a.publisher_db
	,a.subscriber_db
	,a.publication
	,p.[data_source] publisher
	,s.[data_source] subscriber
FROM dbo.MSdistribution_agents a
INNER JOIN dbo.MSdistribution_history h ON a.id = h.agent_id
INNER JOIN @replication_servers p ON p.server_id = a.publisher_id
INNER JOIN @replication_servers s ON s.server_id = a.subscriber_id
WHERE h.[timestamp] = (
		SELECT MAX(mts)
		FROM (
			SELECT MAX(timestamp) AS mts
			FROM dbo.MSdistribution_history
			WHERE agent_id = a.id
				AND runstatus IN (2 ,3 ,4)
			GROUP BY start_time
			) AS T
		)

OPEN INFO_CURSOR;

FETCH NEXT
FROM INFO_CURSOR
INTO @agent_id
	,@xact_seqno
	,@publisher_db
	,@subscriber_db
	,@publication
	,@publisher
	,@subscriber;

WHILE @@FETCH_STATUS = 0
BEGIN
	INSERT INTO @temp
	EXEC sp_MSget_repl_commands @agent_id = @agent_id
		,@last_xact_seqno = @xact_seqno
		,@get_count = 2
		,@compatibility_level = 9000000;

	SELECT TOP 1 @pendingcmdcount = pendingcmdcount
	FROM @temp;

	DELETE
	FROM @temp;

	IF (@pendingcmdcount > @pend_command_limit)
		INSERT INTO @data
		VALUES (
			@publisher
			,@subscriber
			,@publisher_db
			,@subscriber_db
			,@publication
			,@pendingcmdcount
			)

	FETCH NEXT
	FROM INFO_CURSOR
	INTO @agent_id
		,@xact_seqno
		,@publisher_db
		,@subscriber_db
		,@publication
		,@publisher
		,@subscriber;
END

CLOSE INFO_CURSOR;

DEALLOCATE INFO_CURSOR;''
FROM [master].sys.databases
WHERE is_distributor = 1;

SET @query = @query + N''

SELECT *
FROM @data;'';

EXEC (@query);',N'@pendingCommandLimit int,@____MachineName nvarchar(15),@____InstanceName nvarchar(12)',@pendingCommandLimit=0,@____MachineName=N'SCB-PR-DBREP4W1',@____InstanceName=N'PR_REPL_DKNO'