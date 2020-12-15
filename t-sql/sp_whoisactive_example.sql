sp_whoisactive 
--@help=1
--@output_column_list = '[dd%][session_id][sql_text][sql_command][login_name][wait_info][tasks][tran_log%][cpu%][temp%][block%][reads%][writes%][context%][physical%][query_plan][locks][%]'
@sort_order = '[database_name] ASC'
--@filter_type  = 'database',
--@filter = 'hastus2015',
--@find_block_leaders = 1,
--@get_plans = 1,
--@get_locks = 1


USE [bf_dba]
exec sp_WhoIsActive @show_sleeping_spids = 0,--@get_full_inner_text = 1,
@get_plans = 2,@get_additional_info = 1,
@output_column_list ='[dd%][session_id][blocking_session_id][sql_text][database_name][program_name][percent_complete][wait_info][login_name][host_name][query_plan][additional_info][start_time]'
