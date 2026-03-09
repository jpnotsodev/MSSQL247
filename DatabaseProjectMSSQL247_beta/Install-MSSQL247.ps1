Param (

    [Parameter(Mandatory=$True)]
    [string]$SqlInstance,
    [Parameter(Mandatory=$True)]
    [string]$Username,
    [Parameter(Mandatory=$True)]
    [string]$Password

)

clear

$inspath = $PSScriptRoot
$defdatabase  = "MSSQL247_beta"

$sql = "IF EXISTS (SELECT name FROM sys.databases WHERE name = '$defdatabase')
        BEGIN
            ALTER DATABASE $defdatabase SET SINGLE_USER WITH ROLLBACK IMMEDIATE
            DROP DATABASE $defdatabase
        END
        
        CREATE DATABASE $defdatabase

        ALTER DATABASE $defdatabase SET RECOVERY SIMPLE 
"

$login = "CREATE LOGIN mssql247 WITH PASSWORD = 'mssql247'
        ,CHECK_POLICY=OFF, CHECK_EXPIRATION=OFF

        USE MSSQL247_beta

        CREATE USER mssql247 FOR LOGIN mssql247

        EXEC sp_addrolemember 'db_datareader', 'mssql247'

        GRANT EXECUTE ON DATABASE::MSSQL247_beta TO mssql247
"

try {
    invoke-sqlcmd -serverinstance $sqlinstance -username $username -password $password -query $sql -erroraction stop -trustservercertificate
} catch  {
    write-host error: $_ -foregroundcolor red
}

$tables_dir = (Join-Path -Path $PSScriptRoot -ChildPath "MSSQL247.Database.Objects\Tables")
foreach ($table in (Get-ChildItem -Path $tables_dir -Filter mssql247_*.sql)) {
    $sql = [string](Get-Content $tables_dir\$table)
    Try {
        Invoke-Sqlcmd -ServerInstance $SqlInstance -Username $Username -Password $Password -Query $sql -Database $defdatabase -ErrorAction Stop -TrustServerCertificate
        Write-Host "Creating table '$table' in '$defdatabase'. "-ForegroundColor Green
    } Catch {
        Write-Host Error: $_ -ForegroundColor Red
    }
}

$storedprocs_dir = (Join-Path -Path $PSScriptRoot -ChildPath "MSSQL247.Database.Objects\StoredProcedures")
foreach ($storedproc in (Get-ChildItem -Path $storedprocs_dir -Filter usp_mssql247_*.sql)) {
    $sql = [string](Get-Content $storedprocs_dir\$storedproc)
    Try {
        Invoke-Sqlcmd -ServerInstance $SqlInstance -Username $Username -Password $Password -Query $sql -Database $defdatabase -ErrorAction Stop -TrustServerCertificate
        Write-Host "Creating stored procedure '$storedproc' in '$defdatabase'. "-ForegroundColor Green
    } Catch {
        Write-Host Error: $_ -ForegroundColor Red
    }
}

$functions_dir = (Join-Path -Path $PSScriptRoot -ChildPath "MSSQL247.Database.Objects\Functions")
foreach ($function in (Get-ChildItem -Path $functions_dir -Filter udf_*.sql)) {
    $sql = [string](Get-Content $functions_dir\$function)
    Try {
        Invoke-Sqlcmd -ServerInstance $SqlInstance -Username $Username -Password $Password -Query $sql -Database $defdatabase -ErrorAction Stop -TrustServerCertificate
        Write-Host "Creating function '$function' in '$defdatabase'. "-ForegroundColor Green
    } Catch {
        Write-Host Error: $_ -ForegroundColor Red
    }
}