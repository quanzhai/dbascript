SELECT  *,xevents.event_data.value('(event/@timestamp)[1]','datetime2')
FROM sys.fn_xe_file_target_read_file('Long_running_queries*.xel',null,null,null)
CROSS APPLY (select CAST(event_data as XML) as event_data) as xevents
 where 1=1
 and xevents.event_data.value('(event/@timestamp)[1]','datetime2') < @currentTime
 and xevents.event_data.value('(event/@timestamp)[1]','datetime2') > DateADD(mi, -30, @currentTime)