SELECT DB_NAME(database_id) AS [Database Name],
       reserved_page_count AS [Version Store Reserved Page Count], 
	   reserved_space_kb/1024 AS [Version Store Reserved Space (MB)] 
FROM sys.dm_tran_version_store_space_usage WITH (NOLOCK) 
ORDER BY reserved_space_kb/1024 DESC OPTION (RECOMPILE);

/*
https://docs.microsoft.com/en-us/previous-versions/sql/sql-server-2008-r2/ms186328(v=sql.105)
*/
SELECT
    transaction_sequence_num,
    version_sequence_num,
    database_id, rowset_id,
    status,
    min_length_in_bytes,
    record_length_first_part_in_bytes,
    record_image_first_part,
    record_length_second_part_in_bytes,
    record_image_second_part
  FROM sys.dm_tran_version_store;


select hostname,elapsed_time_seconds,session_id, is_snapshot, blocked, lastwaittype, cpu, physical_io,  open_tran, cmd 
from sys.dm_tran_active_snapshot_database_transactions a
join master..sysprocesses b
on a.session_id=b.spid 
order by a.elapsed_time_seconds desc

/*
https://dba.stackexchange.com/questions/36382/find-transactions-that-are-filling-up-the-version-store?rq=1
*/
SELECT 
  obj = QUOTENAME(OBJECT_SCHEMA_NAME(p.object_id))
  + '.' + QUOTENAME(OBJECT_NAME(p.object_id)),
  referenced_by = QUOTENAME(r.referencing_schema_name)
  + '.' + QUOTENAME(r.referencing_entity_name),
  vs.aggregated_record_length_in_bytes AS size
FROM sys.dm_tran_top_version_generators AS vs
INNER JOIN sys.partitions AS p
ON vs.rowset_id = p.hobt_id
CROSS APPLY sys.dm_sql_referencing_entities
(
  QUOTENAME(OBJECT_SCHEMA_NAME(p.object_id))
  + '.' + QUOTENAME(OBJECT_NAME(p.object_id)), 'OBJECT'
) AS r
WHERE vs.database_id = DB_ID()
AND p.index_id IN (0,1)
ORDER BY size DESC, referenced_by;