Test-Cluster -Node "scb-pr-codbn71.scb.osl.basefarm.net","scb-pr-codbn72.scb.osl.basefarm.net" -Ignore "Storage"
#initialize disks
New-Cluster -Name scb-pr-codbn7c1 -Node "scb-pr-codbn71.scb.osl.basefarm.net","scb-pr-codbn72.scb.osl.basefarm.net" -StaticAddress 10.84.116.115
#fix disks
scb-pr-codbn7w1.scb.osl.basefarm.net
-InstallAction 'InstallCluster' -SqlVersion 'sql2019' -SqlEdition 'Standard' -ProductStringName 'Default' -InstanceName 'PR_CO_REPORT' -UpdateEnabled 'Yes' -MountPointLetter 'E:' -RPCDynamicPortsRange '50000-51000' -SqlCollation 'Danish_Norwegian_CI_AS' -AutoInstallerVersion '1.0.1.9' -PrimaryNode 'SCB-PR-CODBN71.scb.osl.basefarm.net' -FailoverClusterIpaddresses 'IPv4;10.84.116.116;Cluster Network 1;255.255.255.128' -FailoverClusterNetworkName 'scb-pr-codbn7w1' -AGTSVCAccount 'SCB\scb-pr-codbn7w1-sa' -AGTSVCPassword '' -SQLSVCAccount 'SCB\scb-pr-codbn7w1-ss' -SQLSVCPassword '' -Full
-InstallAction 'InstallCluster' -SqlVersion 'sql2019' -SqlEdition 'Standard' -ProductStringName 'Default' -InstanceName 'PR_CO_REPORT' -UpdateEnabled 'Yes' -MountPointLetter 'E:' -RPCDynamicPortsRange '50000-51000' -SqlCollation 'Danish_Norwegian_CI_AS' -AutoInstallerVersion '1.0.1.9' -PrimaryNode 'SCB-PR-CODBN71.scb.osl.basefarm.net' -FailoverClusterIpaddresses 'IPv4;10.84.116.116;Cluster Network 1;255.255.255.128' -FailoverClusterNetworkName 'scb-pr-codbn7w1' -AGTSVCAccount 'SCB\scb-pr-codbn7w1-sa' -AGTSVCPassword '' -SQLSVCAccount 'SCB\scb-pr-codbn7w1-ss' -SQLSVCPassword '' -PostClusterOnly

Test-Cluster -Node "scb-pr-codbn61.scb.osl.basefarm.net","scb-pr-codbn62.scb.osl.basefarm.net" -Ignore "Storage"
#initialize disks
New-Cluster -Name scb-pr-codbn6c1 -Node "scb-pr-codbn61.scb.osl.basefarm.net","scb-pr-codbn62.scb.osl.basefarm.net" -StaticAddress 10.84.116.114
#fix disks
scb-pr-codbn6w1.scb.osl.basefarm.net
-InstallAction 'InstallCluster' -SqlVersion 'sql2019' -SqlEdition 'Standard' -ProductStringName 'Default' -InstanceName 'PR_CO_CARDS' -UpdateEnabled 'Yes' -MountPointLetter 'E:' -RPCDynamicPortsRange '50000-51000' -SqlCollation 'Danish_Norwegian_CI_AS' -AutoInstallerVersion '1.0.1.9' -PrimaryNode 'scb-pr-codbn61.scb.osl.basefarm.net' -FailoverClusterIpaddresses 'IPv4;10.84.116.113;Cluster Network 1;255.255.255.128' -FailoverClusterNetworkName 'scb-pr-codbn6w1' -AGTSVCAccount 'SCB\scb-pr-codbn6w1-sa' -AGTSVCPassword '' -SQLSVCAccount 'SCB\scb-pr-codbn6w1-ss' -SQLSVCPassword '' -Full
-InstallAction 'InstallCluster' -SqlVersion 'sql2019' -SqlEdition 'Standard' -ProductStringName 'Default' -InstanceName 'PR_CO_CARDS' -UpdateEnabled 'Yes' -MountPointLetter 'E:' -RPCDynamicPortsRange '50000-51000' -SqlCollation 'Danish_Norwegian_CI_AS' -AutoInstallerVersion '1.0.1.9' -PrimaryNode 'scb-pr-codbn61.scb.osl.basefarm.net' -FailoverClusterIpaddresses 'IPv4;10.84.116.113;Cluster Network 1;255.255.255.128' -FailoverClusterNetworkName 'scb-pr-codbn6w1' -AGTSVCAccount 'SCB\scb-pr-codbn6w1-sa' -AGTSVCPassword '' -SQLSVCAccount 'SCB\scb-pr-codbn6w1-ss' -SQLSVCPassword '' -PostClusterOnly

Test-Cluster -Node "scb-pr-codbn51.scb.osl.basefarm.net","scb-pr-codbn52.scb.osl.basefarm.net" -Ignore "Storage"
#initialize disks
New-Cluster -Name scb-pr-codbn5c1 -Node "scb-pr-codbn51.scb.osl.basefarm.net","scb-pr-codbn52.scb.osl.basefarm.net" -StaticAddress 10.84.116.117
#fix disks
scb-pr-codbn5w1.scb.osl.basefarm.net
-InstallAction 'InstallCluster' -SqlVersion 'sql2019' -SqlEdition 'Standard' -ProductStringName 'Default' -InstanceName 'PR_CO_CUSTOMER' -UpdateEnabled 'Yes' -MountPointLetter 'E:' -RPCDynamicPortsRange '50000-51000' -SqlCollation 'Danish_Norwegian_CI_AS' -AutoInstallerVersion '1.0.1.9' -PrimaryNode 'scb-pr-codbn51.scb.osl.basefarm.net' -FailoverClusterIpaddresses 'IPv4;10.84.116.118;Cluster Network 1;255.255.255.128' -FailoverClusterNetworkName 'scb-pr-codbn5w1' -AGTSVCAccount 'SCB\scb-pr-codbn5w1-sa' -AGTSVCPassword '' -SQLSVCAccount 'SCB\scb-pr-codbn5w1-ss' -SQLSVCPassword ''S$L#U&r!tr'' -Full
-InstallAction 'InstallCluster' -SqlVersion 'sql2019' -SqlEdition 'Standard' -ProductStringName 'Default' -InstanceName 'PR_CO_CUSTOMER' -UpdateEnabled 'Yes' -MountPointLetter 'E:' -RPCDynamicPortsRange '50000-51000' -SqlCollation 'Danish_Norwegian_CI_AS' -AutoInstallerVersion '1.0.1.9' -PrimaryNode 'scb-pr-codbn51.scb.osl.basefarm.net' -FailoverClusterIpaddresses 'IPv4;10.84.116.118;Cluster Network 1;255.255.255.128' -FailoverClusterNetworkName 'scb-pr-codbn5w1' -AGTSVCAccount 'SCB\scb-pr-codbn5w1-sa' -AGTSVCPassword '' -SQLSVCAccount 'SCB\scb-pr-codbn5w1-ss' -SQLSVCPassword '' -PostClusterOnly


NO-11784
backup-osl-ha-v2883.osl.basefarm.net
\\wdepot\wdepot\Microsoft\mssql\tsm\installer\SQL2014+\TSM-Win_8.1.12
\\wdepot\wdepot\Microsoft\mssql\tsm\installer\SQL2014+\TSMSQL-Win_8.1.12
08.01.1200
scb-pr-codbn72.scb.osl.basefarm.net