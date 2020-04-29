SELECT  
  [restore_date]
      ,[destination_database_name]
      ,[user_name]
      ,[backup_set_id]
      ,[restore_type]
      ,[replace]
      ,[recovery]
      ,[restart]
  FROM [msdb].[dbo].[restorehistory]
order by restore_date desc