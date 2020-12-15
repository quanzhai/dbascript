SELECT database_name, backup_size, compressed_backup_size,type,
backup_size/compressed_backup_size AS CompressedRatio,backup_start_date
FROM msdb..backupset
where backup_start_date between '2020-11-24 00:00:00.000' and '2020-11-25 00:00:00.000' and type = 'L' 
order by backup_start_date desc

SELECT sum(backup_size)
FROM msdb..backupset
where backup_start_date between '2020-11-24 00:00:00.000' and '2020-11-25 00:00:00.000' and type = 'L' 