exec sp_configure 'show advanced options', 1 
go 
reconfigure 
go
exec sp_configure 'xp_cmdshell',1 
go 
reconfigure with override 
go
xp_cmdshell 'net use H: \\server_name\drive_name passwordhere /user:DOMAIN\USERNAME'