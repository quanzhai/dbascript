/*
This job defragments columnstore indexes with thresholds configured below. It consideres partitioned tables and rebuild per partition.
*/

--Config fragmentation thresholds
DECLARE @FragmentationPercent INT = 10; --Rebuilds if fragmentation per partition is higher than threshold
DECLARE @DeletedSegmentsRowPercentage INT = 20; --Rebuilds if ANY individual row group has a higher fragmentation than threshold
DECLARE @EmptySegmentsAllowed INT = 0; --Rebuilds if count of empty rowgroup per partition is higher than threshold
---

DECLARE @IndexesToRebuild TABLE (SchemaName SYSNAME, TableName SYSNAME, IndexName SYSNAME, [Partition] SYSNAME);

WITH ClusteredColumnstoreIndexes
AS
( SELECT t.object_id AS ObjectID,
         SCHEMA_NAME(t.schema_id) AS SchemaName,
         t.name AS TableName,
         i.name AS IndexName
  FROM sys.indexes AS i
  INNER JOIN sys.tables AS t
  ON i.object_id = t.object_id
  WHERE i.type = 5
),
RowGroups
AS
( SELECT csrg.object_id AS ObjectID,
		 csrg.partition_number,
         csrg.total_rows AS TotalRows,
         csrg.deleted_rows AS DeletedRows,
         csrg.deleted_rows * 100.0 / csrg.total_rows AS DeletedPercentage,
         CASE WHEN csrg.total_rows = csrg.deleted_rows
              THEN 1 ELSE 0
         END AS IsEmptySegment
  FROM sys.column_store_row_groups AS csrg
  WHERE csrg.state = 3
),
IndexStats
AS
( SELECT cci.ObjectID,
		 rg.partition_number AS [Partition],
         cci.SchemaName,
         cci.TableName,
         cci.IndexName,
		 COUNT(*) AS CountRGs,
		 CAST(((SUM(rg.IsEmptySegment) *1.0/ COUNT(*)*1.0) *100) as Decimal(5,2)) as EmptyRowGroupsPercent,
		 SUM(CASE WHEN rg.DeletedRows >0 THEN 1 ELSE 0 END ) AS 'NumRowgroupsWithDeletedRows',
		 SUM(rg.DeletedRows * 1.0)/SUM(rg.TotalRows *1.0) *100 AS 'DeletedRowsPercent',
		 SUM(rg.IsEmptySegment) aS EmptySegments
  FROM ClusteredColumnstoreIndexes AS cci
  INNER JOIN RowGroups AS rg  ON cci.ObjectID = rg.ObjectID
  GROUP BY cci.ObjectID,rg.partition_number, cci.IndexName, cci.SchemaName, cci.TableName
)
--select * from IndexStats

INSERT @IndexesToRebuild (SchemaName, TableName, IndexName, [Partition])
SELECT s.SchemaName, s.TableName, s.IndexName, s.[Partition]
FROM IndexStats AS s
	WHERE 1=1 
	AND s.DeletedRowsPercent > @FragmentationPercent
	OR s.EmptySegments > @EmptySegmentsAllowed
	OR EXISTS(SELECT 1 FROM RowGroups AS rg
		WHERE rg.ObjectID = s.ObjectID
		AND rg.partition_number = s.[Partition]
		AND rg.DeletedPercentage > @DeletedSegmentsRowPercentage)
		
;
--SELECT * FROM @IndexesToRebuild

DECLARE @SchemaName SYSNAME;
DECLARE @TableName SYSNAME;
DECLARE @IndexName SYSNAME;
DECLARE @Partition NVARCHAR(10);
DECLARE @SqlCommand NVARCHAR(MAX);

DECLARE IndexList CURSOR FAST_FORWARD READ_ONLY
FOR
  SELECT SchemaName, TableName, IndexName, [Partition]
  FROM @IndexesToRebuild
  ORDER BY TableName, [Partition], SchemaName, IndexName;

OPEN IndexList;

FETCH NEXT FROM IndexList INTO @SchemaName, @TableName, @IndexName, @Partition;

WHILE @@FETCH_STATUS = 0
BEGIN
  SET @SqlCommand = N'ALTER INDEX ' + QUOTENAME(@IndexName)
                  + N' ON ' + QUOTENAME(@SchemaName)
                  + N'.' + QUOTENAME(@TableName)
                  + N' REBUILD PARTITION = ' + @Partition +';';
  --PRINT @SqlCommand;
  EXEC(@SqlCommand); 
  FETCH NEXT FROM IndexList INTO @SchemaName, @TableName, @IndexName, @Partition;
END;
CLOSE IndexList;
DEALLOCATE IndexList;