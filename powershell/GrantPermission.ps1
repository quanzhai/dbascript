Param (
    [Parameter(Mandatory = $true)]
    [string]$ParamSqlInstance,
    [Parameter(Mandatory = $true)]
    [string]$ParamLogin,
    [ValidateSet("admin", "read", "write", "execute")]
    [Parameter(Mandatory = $true)]
    [string]$ParamDBRole,
    [Parameter(Mandatory = $true)]
    [string]$ParamDatabase
)

$isLoginExist = $false
$isDBUserExist = $false

#Check if login exists
$logins = Get-DbaLogin -SqlInstance $ParamSqlInstance
if($logins)
{
    foreach($login in $Logins)
    {
        if( $login.Name -eq $ParamLogin)
        {
            $isLoginExist = $true
        }
    }
}

#If login doens't exist, create one
if($isLoginExist -eq $false)
{
    Write-Warning "Create login"
    New-DbaLogin -SqlInstance $ParamSqlInstance -Login $ParamLogin
}

#Check if login is dbUser
$dbUsers = Get-DbaDbUser -SqlInstance $ParamSqlInstance -Database $ParamDatabase

if($dbUsers)
{
    foreach($dbUser in $dbUsers)
    {
        if( $dbUser.Name -eq $ParamLogin)
        {
            $isDBUserExist = $true
        }
    }
}

#Add dbuser
if($isDBUserExist -eq $false)
{
    Write-Warning "Add dbuser"
    try
    {
        New-DbaDbUser -SqlInstance $ParamSqlInstance -Database $ParamDatabase -Login $ParamLogin
    }
    catch
    {
    }
}

#Check which roles user should have
$dbRoles = switch($ParamDBRole)
{
    "admin"   {'db_ddladmin', 'db_datawriter', 'db_datareader', 'db_execute'}
    "read"    {'db_datareader'}
    "write"   {'db_datawriter', 'db_datareader'}
    "execute" {'db_execute'}
}

#Check if db_execute exists
if($ParamDBRole -eq "admin" -or $ParamDBRole -eq "execute")
{
    $dbExecuteRole = Get-DbaDbRole -SqlInstance $ParamSqlInstance -Database $ParamDatabase -Role 'db_execute'
    if($dbExecuteRole -eq $null)
    {
        New-DbaDbRole -SqlInstance $ParamSqlInstance -Database $ParamDatabase -Role 'db_execute'
    }
}

#Add db roles
Add-DbaDbRoleMember -SqlInstance $ParamSqlInstance -Database $ParamDatabase -Role $dbRoles -User $ParamLogin