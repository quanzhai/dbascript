############################### Get db growth event ##############################
Find-DbaDbGrowthEvent -SqlInstance baq-p-db02.prodno.osl.basefarm.net,14302 -Database tempdb | Format-table

  
############################### Find instance ##############################
Find-DbaInstance -ComputerName sg-p1-sql1.sgf.osl.basefarm.net

  
############################### Create new database ##############################
New-DbaDatabase -SqlInstance SCB-PR-SQL-COMMON -Name SCB_PartnerRepository -PrimaryFilesize 1024 -PrimaryFileGrowth 256 -LogSize 256 -LogGrowth 128 -Owner SA_BF_disabled


############################### Restore set of databases ##############################
Restore-DbaDatabase -SqlInstance UDR-CQ-SQLA1 -Path E:\Data\MSSQLSERVER\Backups\UserDB

  
############################### Add database to AG ##############################
Get-DbaDatabase -SqlInstance UDR-CQ-SQLA1 | Where-Object {($_.Name -ne 'master') -and ($_.Name -ne 'msdb') -and ($_.Name -ne 'model') -and ($_.Name -ne 'tempdb') -and ($_.Name -ne 'bf_dba') } | Out-GridView -Passthru | Add-DbaAgDatabase -AvailabilityGroup udr-cq-sqlaa1 -SharedPath \\udr-cq-sqla1\AGShare-MSSQLSERVER
Get-DbaDatabase -SqlInstance UDR-CQ-SQLc2 | Out-GridView -Passthru | Add-DbaAgDatabase -AvailabilityGroup udr-cq-sqlca1


############################### Remove database from AG ##############################
Remove-DbaAgDatabase -SqlInstance udr-cq-sqlc2 -AvailabilityGroup udr-cq-sqlca1 -Database Udir.Epi, Udir.LPV, Udir.Ext -Confirm:$false


############################### Get disk space ##############################
Get-DbaDiskSpace -ComputerName SCB-PP-SEDBN01.SCB.OSL.BASEFARM.NET   -ExcludeDrive 'C:\'   | Where-Object {$_.Name -like '*Log*'}


############################### Get last backup ##############################
Get-DbaLastBackup -SqlInstance SCB-PP-SEDBN01.SCB.OSL.BASEFARM.NET   | Format-Table