SELECT AGS.NAME AS AGGroupName
    ,AR.replica_server_name AS InstanceName
    ,HARS.role_desc
    ,DRS.synchronization_state_desc AS SyncState
    ,DRS.last_hardened_time
    ,DRS.last_redone_time
    ,((DRS.log_send_queue_size)/8)/1024 QueueSize_MB
	,datediff(SECOND, last_redone_time, last_hardened_time) as Latency_Seconds
	,db.name
FROM sys.dm_hadr_database_replica_states DRS
LEFT JOIN sys.availability_replicas AR ON DRS.replica_id = AR.replica_id
LEFT JOIN sys.availability_groups AGS ON AR.group_id = AGS.group_id
LEFT JOIN sys.dm_hadr_availability_replica_states HARS ON AR.group_id = HARS.group_id
    AND AR.replica_id = HARS.replica_id
LEFT JOIN sys.databases db on db.database_id = DRS.database_id