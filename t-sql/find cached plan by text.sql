--Find procedure by Text
select text [Procedure],execution_count,cached_time,last_execution_time,* from sys.dm_exec_procedure_stats
cross apply sys.dm_exec_sql_text(sql_handle)
cross apply sys.dm_exec_query_plan(plan_handle)
where text like '%Role_GetReporteeList161_SELECT%'
and database_id = db_id()