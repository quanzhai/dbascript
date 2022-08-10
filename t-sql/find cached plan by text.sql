--Find procedure by Text
select text [Procedure],execution_count,cached_time,last_execution_time,* from sys.dm_exec_procedure_stats
cross apply sys.dm_exec_sql_text(sql_handle)
cross apply sys.dm_exec_query_plan(plan_handle)
where text like '%Role_GetReporteeList161_SELECT%'
and database_id = db_id()

--Find procedure by Text from query store
SELECT 
   *
FROM sys.query_store_query qsq
    INNER JOIN sys.query_store_query_text qsqt
        ON qsq.query_text_id = qsqt.query_text_id
WHERE
    qsqt.query_sql_text LIKE '%30060%';


--Find query by Text
	SELECT *
FROM sys.dm_exec_query_stats AS qstats
    CROSS APPLY sys.dm_exec_sql_text(qstats.plan_handle) as qtext
where text like '%30060%';


-- Remove the specific plan from the cache using the plan handle
DBCC FREEPROCCACHE (0x05000800F7BA926C40C15055070000000000000000000000);