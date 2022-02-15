# add disks
#Mount:
new-cloVirtualDiskDrive -VMname [hostname] -VirtualHardDiskSizeGB 1 -diskname mountE
#Install:
new-cloVirtualDiskDrive -VMname [hostname] -VirtualHardDiskSizeGB 10 -diskname installE
#Data:
new-cloVirtualDiskDrive -VMname [hostname] -VirtualHardDiskSizeGB 15 -diskname dataE
#Log:
new-cloVirtualDiskDrive -VMname [hostname] -VirtualHardDiskSizeGB 5 -diskname logE
#TempDB:
new-cloVirtualDiskDrive -VMname [hostname] -VirtualHardDiskSizeGB 5 -diskname tempdbE

###########################################################################################

# get disk
get-cloVirtualMachineDisk -VMname bf-omdb-ops02.mgmt.basefarm.net -outgridview

###########################################################################################

# expend disk
expand-cloVirtualHardDisk -VirtualHardDiskSizeGB 850 -VMname ind-pc-brt01.ind.sth.basefarm.net -DiskName Datadisk_fixed_mssql_Data_20GB.vhdx

###########################################################################################

# set spn
setspn -S MSSQLSvc/udr-co-sqlb1.udr.osl.basefarm.net:SHAREPOINT UDR\udr-co-sqlb-ss
setspn -S MSSQLSvc/udr-co-sqlb1.udr.osl.basefarm.net:14301 UDR\udr-co-sqlb-ss

###########################################################################################

# get event log
get-eventlog -logname system -source user32 -newest 2 | Format-Table -wrap

# Add SQLPS module if it is not included
$env:PSModulePath = $env:PSModulePath + ";C:\Program Files (x86)\Microsoft SQL Server\150\Tools\PowerShell\Modules"