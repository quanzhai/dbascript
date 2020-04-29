SELECT
    d.name AS 'Database',
    m.name AS 'File',
	m.physical_name,
    m.size,
    cast(cast(m.size as float)  * 8/1024 as varchar) + ' (MB)',
	cast(cast(m.size as float)  * 8/1024/1024 as varchar) + ' (GB)',
    SUM(cast(m.size as float) * 8/1024) OVER (PARTITION BY d.name) AS 'Database Total',
    m.max_size,
	m.type_desc
FROM sys.master_files m
INNER JOIN sys.databases d ON d.database_id = m.database_id
where m.type_desc in ('rows', 'log')
order by m.size desc