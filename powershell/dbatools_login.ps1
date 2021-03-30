############################### Export db user ##############################
Export-DbaUser -SqlInstance baq-t1-list\preprod -Database dts_in_preprod   -Path C:\temp\quan\sqlloginsexport


############################### Get user permission ##############################
Get-DbaUserPermission -SqlInstance spc-sql-s01701.prodno.osl.basefarm.net\mssql | Format-Table Object,Type,Member,RoleSecurableClass,SchemaOwner ,Securable,GranteeType ,Grantee,Permission,State,Grantor,GrantorType,SourceView


############################### Get all orphan users ##############################
Get-DbaDbOrphanUser -SqlInstance udr-cq-sqlc1.udr.osl.basefarm.net  | Format-Table


############################### Remove orphan users ##############################
Remove-DbaDbOrphanUser -SqlInstance udr-co-sqlc1.udr.osl.basefarm.net -Database id-ops-prod, id-prod, id-worker-prod, pas2-prod, prover-prod -Verbose


############################### Get Login ##############################
Get-DbaLogin -SqlInstance udr-co-sqlc1.udr.osl.basefarm.net | Out-GridView


############################### Copy Login ##############################
Get-DbaLogin -SqlInstance EPS-P-SQLC01W03\DAGENSINDUSTRI | Out-GridView -Passthru | Copy-DbaLogin -Destination bbm-p-mssql101.ad.dex.nu\BBMEDIA


############################### DB filespace usage ##############################
Get-DbaDbSpace -SqlInstance SKL-P-C1SQLW01.kolan.org | Where-Object {$_.FileType -eq "Log"} | Format-Table ComputerName,InstanceName,SqlInstance,Database,FileName,FileGroup,PhysicalName,FileType,UsedSpace,FreeSpace,PercentUsed


############################### Server diska space ##############################
Get-DbaDiskSpace -ComputerName SKL-P-C1SQLW01.kolan.org | Where-Object{$_.Label -like 'Log%'}