# grant permissions
.\GrantPermission.ps1 -ParamSqlInstance SCB-PP-SE-AG01 -ParamLogin SCB\BF.PP.T520020 -ParamDBRole write  -ParamDatabase db1
.\GrantPermission.ps1 -ParamSqlInstance SCB-PP-SE-AG01 -ParamLogin SCB\BF.PP.T520020 -ParamDBRole admin  -ParamDatabase db2
.\GrantPermission.ps1 -ParamSqlInstance SCB-PP-SE-AG01 -ParamLogin SCB\BF.PP.T520020 -ParamDBRole read  -ParamDatabase db3
.\GrantPermission.ps1 -ParamSqlInstance SCB-PP-SE-AG01 -ParamLogin SCB\BF.PP.T520020 -ParamDBRole execute  -ParamDatabase db4

###########################################################################################
