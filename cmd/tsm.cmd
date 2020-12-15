upd n scb-pr-sedbn01.scb.osl.basefarm.net_mssql xxyyz
upd n scb-pr-sedbn01.scb.osl.basefarm.net_mssql_log xxyyz
upd n scb-pr-sedbn02.scb.osl.basefarm.net_mssql xxyyz
upd n scb-pr-sedbn02.scb.osl.basefarm.net_mssql_log xxyyz
upd n scb-se-ag01.scb.osl.basefarm.net_mssql xxyyz

dsmcutil.exe updatepw /node:'scb-pr-sedbn01.scb.osl.basefarm.net_mssql' /password:xxyyz /optfile:'E:\Install\tsm\sql\sql.opt'
dsmcutil.exe updatepw /node:'scb-pr-sedbn01.scb.osl.basefarm.net_mssql' /password:xxyyz /optfile:'E:\Install\tsm\sql\SchFull.opt'
dsmcutil.exe updatepw /node:'scb-pr-sedbn01.scb.osl.basefarm.net_mssql_log' /password:xxyyz /optfile:'E:\Install\tsm\sql\SchLog.opt'

dsmcutil.exe updatepw /node:'scb-pr-sedbn02.scb.osl.basefarm.net_mssql' /password:xxyyz /optfile:'E:\Install\tsm\sql\sql.opt'
dsmcutil.exe updatepw /node:'scb-pr-sedbn02.scb.osl.basefarm.net_mssql' /password:xxyyz /optfile:'E:\Install\tsm\sql\SchFull.opt'
dsmcutil.exe updatepw /node:'scb-pr-sedbn02.scb.osl.basefarm.net_mssql_log' /password:xxyyz /optfile:'E:\Install\tsm\sql\SchLog.opt'