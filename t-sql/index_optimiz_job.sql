EXECUTE [dbo].[IndexOptimize]
@Databases = 'USER_DATABASES',
@FragmentationMedium = 'INDEX_REORGANIZE,INDEX_REBUILD_ONLINE',
@FragmentationHigh = 'INDEX_REBUILD_ONLINE,INDEX_REBUILD_OFFLINE',
@FragmentationLevel1 = '20',
@FragmentationLevel2 = '60',
@UpdateStatistics = 'ALL',
@OnlyModifiedStatistics = 'Y',
@WaitAtLowPriorityMaxDuration = 5,
@WaitAtLowPriorityAbortAfterWait = 'SELF',
@LockMessageSeverity=10,
@LogToTable = 'Y'