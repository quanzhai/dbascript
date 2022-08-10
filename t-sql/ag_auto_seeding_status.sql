-- Monitor the status of the automatic seeding
SELECT start_time,
         completion_time,
       ag.name,
       db.database_name,
       current_state,
       performed_seeding,
       failure_state,
       failure_state_desc
         number_of_attempts
FROM sys.dm_hadr_automatic_seeding autos 
    JOIN sys.availability_databases_cluster db 
    ON autos.ag_db_id = db.group_database_id
    JOIN sys.availability_groups ag 
    ON autos.ag_id = ag.group_id
Order by start_time desc

-- If a seeding activity is currently in progres then you can also query the following DMV
SELECT * FROM sys.dm_hadr_physical_seeding_stats

/*As it executes a VDI backup, you need to run the following command on Primary replica to check the status of backup*/

SELECT
r.session_id, r.status, r.command, r.wait_type
, r.percent_complete, r.estimated_completion_time
FROM sys.dm_exec_requests r JOIN sys.dm_exec_sessions s
ON r.session_id = s.session_id
WHERE r.session_id <> @@SPID
AND s.is_user_process = 0
AND r.command like 'VDI%'
and wait_type ='BACKUPTHREAD'




/*On the secondary replica of Always On Availability Groups, you can run the following command to check the status of REDO operation.*/

SELECT
r.session_id, r.status, r.command, r.wait_type
, r.percent_complete, r.estimated_completion_time
FROM sys.dm_exec_requests r JOIN sys.dm_exec_sessions s
ON r.session_id = s.session_id
WHERE r.session_id <> @@SPID
AND s.is_user_process = 0
AND r.command like 'REDO%'
and wait_type ='BACKUPTHREAD'




/*
Let’s execute the DMV to check the seeding status from the primary replica.*/

select local_database_name
, remote_machine_name,role_desc ,internal_state_desc
,transfer_rate_bytes_per_second/1024/1024 as transfer_rate_MB_per_second ,transferred_size_bytes/1024/1024 as transferred_size_MB
,database_size_bytes/1024/1024/1024/1024 as Database_Size_TB,
is_compression_enabled
from sys.dm_hadr_physical_seeding_stats