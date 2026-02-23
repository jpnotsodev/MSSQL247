$Name = @{Label="Name"; Expression={$_.VolumeName}}
$Root = @{Label="Root"; Expression={$_.DeviceID}}
$Free = @{Label="Free"; Expression={$_.FreeSpace}}
$Total = @{Label="Total"; Expression={$_.Size}}

$Volumes = Get-WmiObject Win32_LogicalDisk | Select-Object $Name,$Root,$Free,$Total
$Volumes
$Query = ""
$Timestamp = Get-Date

 $Volumes| ForEach-Object -Process {
    $VolumeName = $_.Name;
    $VolumeMountPoint = $_.Root; 
    $FreeCapacity = $_.Free; 
    $TotalCapacity = $_.Total

    If ($VolumeName.Equals("")) {
        $VolumeName = "Local Disk (" + $VolumeMountPoint + ")"
    }
     
    [string]$Query += "INSERT MSSQL247_beta.dbo.mssql247_os_volumes 
                        (sql_instance, volume_name, volume_mount_point, total_size_kb, size_remaining_kb, snapshot_timestamp) 
                            VALUES ((SELECT MSSQL247_beta.dbo.udf_get_server_name()), '$VolumeName', '$VolumeMountPoint',
                                '$TotalCapacity', '$FreeCapacity', '$Timestamp');"
}
# insert volume data into dbo.mssql247_os_volumes
# using SQLCMD command line tool 
SQLCMD -S localhost -Q $Query