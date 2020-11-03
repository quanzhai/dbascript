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