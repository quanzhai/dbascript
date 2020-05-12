############################### Export db user ##############################
Export-DbaUser -SqlInstance baq-t1-list\preprod -Database dts_in_preprod   -Path C:\temp\quan\sqlloginsexport


############################### Get user permission ##############################
Get-DbaUserPermission -SqlInstance spc-sql-s01701.prodno.osl.basefarm.net\mssql | Format-Table Object,Type,Member,RoleSecurableClass,SchemaOwner ,Securable,GranteeType ,Grantee,Permission,State,Grantor,GrantorType,SourceView


############################### Get all orphan users ##############################
Get-DbaDbOrphanUser -SqlInstance udr-cq-sqlc1.udr.osl.basefarm.net  | Format-Table


############################### Remove orphan users ##############################
Remove-DbaDbOrphanUser -SqlInstance udr-cq-sqlc1.udr.osl.basefarm.net -Database UBAS_Copy -Verbose