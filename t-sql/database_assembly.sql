/*
The security choices you now have for an assembly in SQL Server 2017 are:

The database is set to be TRUSTWORTHY, OR
The assembly is signed with a certificate that has a corresponding login with UNSAFE ASSEMBLY permission, OR
The assembly is signed with an asymmetric key that has a corresponding login with UNSAFE ASSEMBLY permission, OR
The assembly is marked as trustworthy by the sys.sp_add_trusted_assembly procedure.

*/

--For å liste innholdet i Assembly. 

select * from sys.assembly_files
where assembly_id = 65536

--Kopier "Content" til @asmBin variabel. 
USE master;
GO
DECLARE @clrName nvarchar(4000) = 'jaro-winkler, version=0.0.0.0, culture=neutral, publickeytoken=null, processorarchitecture=msil'
DECLARE @asmBin varbinary(max) = 0x1234......;
DECLARE @hash varbinary(64);
SELECT @hash = HASHBYTES('SHA2_512', @asmBin);
EXEC sys.sp_add_trusted_assembly @hash = @hash,
@description = @clrName;