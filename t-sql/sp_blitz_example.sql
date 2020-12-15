-- sp_BlitzCache
EXEC sp_BlitzCache  @SortOrder = 'durations', @Top=50, @ExportToExcel = 1;
GO

EXEC sp_BlitzCache  @SortOrder = 'reads', @Top=50, @ExportToExcel = 1;
GO

EXEC sp_BlitzCache  @SortOrder = 'cpu', @Top=50, @ExportToExcel = 1;
GO

EXEC sp_BlitzCache  @SortOrder = 'executions', @Top=50, @ExportToExcel = 1;
GO

-- sp_BlitzIndex
sp_BlitzIndex @Mode = 3, @GetAllDatabases = 1; -- All missing indexes
GO

sp_Blitzindex @GetAllDatabases = 1, @BringThePain = 1
GO

sp_Blitzindex @Mode=4
GO