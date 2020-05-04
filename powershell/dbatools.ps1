# Export db user
Export-DbaUser -SqlInstance baq-t1-list\preprod -Database dts_in_preprod   -Path C:\temp\quan\sqlloginsexport

###########################################################################################
  
# Get db growth event
Find-DbaDbGrowthEvent -SqlInstance scb-pr-dkdbn03.scb.osl.basefarm.net -Database tempdb | Format-table

###########################################################################################
  
# Find instance
Find-DbaInstance -ComputerName sg-p1-sql1.sgf.osl.basefarm.net

###########################################################################################
  
# Get user permission
Get-DbaUserPermission -SqlInstance spc-sql-s01701.prodno.osl.basefarm.net\mssql | Format-Table Object,Type,Member,RoleSecurableClass,SchemaOwner ,Securable,GranteeType ,Grantee,Permission,State,Grantor,GrantorType,SourceView

###########################################################################################
  
# Create new database
New-DbaDatabase -SqlInstance SCB-PR-SQL-COMMON -Name SCB_PartnerRepository -PrimaryFilesize 1024 -PrimaryFileGrowth 256 -LogSize 256 -LogGrowth 128 -Owner SA_BF_disabled

###########################################################################################
  
# Restore set of databases
Restore-DbaDatabase -SqlInstance UDR-CQ-SQLA1 -Path E:\Data\MSSQLSERVER\Backups\UserDB

###########################################################################################
  
# Add database to AG
Get-DbaDatabase -SqlInstance UDR-CQ-SQLA1 | Where-Object {($_.Name -ne 'master') -and ($_.Name -ne 'msdb') -and ($_.Name -ne 'model') -and ($_.Name -ne 'tempdb') -and ($_.Name -ne 'bf_dba') } | Out-GridView -Passthru | Add-DbaAgDatabase -AvailabilityGroup udr-cq-sqlaa1 -SharedPath \\udr-cq-sqla1\AGShare-MSSQLSERVER