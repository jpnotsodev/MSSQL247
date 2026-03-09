CREATE PROCEDURE [dbo].[usp_mssql247_create_default_collector_jobs]
  @param1 int = 0,
  @param2 int
AS
  DECLARE @Jobs TABLE 
    (job_name nvarchar(250),
    job_desc nvarchar(2000),
    category_name varchar(255),
    job_step_name nvarchar(200),
    job_step_id int,
    command nvarchar(2000),
    subsystem nvarchar(55),
    cmdexec_success_code int,
    on_success_action int,
    on_fail_action int,
    database_name varchar(55),
    job_schedule_name varchar(200),
    freq_type int,
    freq_interval int,
    freq_subday_type int,
    freq_subday_interval int,
    freq_relative_interval int,
    freq_recurrence_factor int)

  INSERT INTO @Jobs 
    SELECT 'MSSQL247_CPU_MEM', 'n/a', 'Data Collector', 'RING_BUFFER', 1, 'EXEC dbo.usp_mssql247_collect_os_ring_buffers', 'TSQL', 0, 3, 2, 'MSSQL247_beta', 'MSSQL247_CPU_MEM_SCHEDULE', 4, 1, 4, 1, 0, 1 UNION
    SELECT 'MSSQL247_CPU_MEM', 'n/a', 'Data Collector', 'PROCESS_MEMORY', 2, 'EXEC dbo.usp_mssql247_collect_os_process_memory', 'TSQL', 0, 3, 2, 'MSSQL247_beta', 'MSSQL247_CPU_MEM_SCHEDULE', 4, 1, 4, 1, 0, 1 UNION
    SELECT 'MSSQL247_CPU_MEM', 'n/a', 'Data Collector', 'SYS_MEMORY', 3, 'EXEC dbo.usp_mssql247_collect_os_sys_memory', 'TSQL', 0, 1, 2, 'MSSQL247_beta', 'MSSQL247_CPU_MEM_SCHEDULE', 4, 1, 4, 1, 0, 1 UNION
    SELECT 'MSSQL247_SYS_GENERAL', 'n/a', 'Data Collector', 'SYS_INFO', 1, 'EXEC dbo.usp_mssql247_collect_os_sys_info', 'TSQL', 0, 3, 2, 'MSSQL247_beta', 'MSSQL247_SYS_GENERAL_SCHEDULE', 4, 1, 4, 1, 0, 1 UNION
    SELECT 'MSSQL247_SYS_GENERAL', 'n/a', 'Data Collector', 'SYS_INFO_2', 2, 'EXEC dbo.usp_mssql247_collect_instance_info', 'TSQL', 0, 1, 2, 'MSSQL247_beta', 'MSSQL247_SYS_GENERAL_SCHEDULE', 4, 1, 4, 1, 0, 1 UNION
    SELECT 'MSSQL247_DATABASES', 'n/a', 'Data Collector', 'DATABASES', 1, 'EXEC dbo.usp_mssql247_collect_databases', 'TSQL', 0, 3, 2, 'MSSQL247_beta', 'MSSQL247_DATABASES_SCHEDULE', 4, 1, 4, 1, 0, 1 UNION
    SELECT 'MSSQL247_DATABASES', 'n/a', 'Data Collector', 'MASTER_FILES', 2, 'EXEC dbo.usp_mssql247_collect_master_files', 'TSQL', 0, 1, 2, 'MSSQL247_beta', 'MSSQL247_DATABASES_SCHEDULE', 4, 1, 4, 1, 0, 1 UNION
    SELECT 'MSSQL247_FILE_IO', 'n/a', 'Data Collector', 'FILE_IO_STATS', 1, 'EXEC dbo.usp_mssql247_collect_file_io_stats', 'TSQL', 0, 1, 2, 'MSSQL247_beta', 'MSSQL247_FILE_IO_SCHEDULE', 4, 1, 4, 1, 0, 1 UNION
    SELECT 'MSSQL247_WAIT_STATS', 'n/a', 'Data Collector', 'WAIT_STATS', 1, 'EXEC dbo.usp_mssql247_collect_os_wait_stats', 'TSQL', 0, 1, 2, 'MSSQL247_beta', 'MSSQL247_WAIT_STATS_SCHEDULE', 4, 1, 4, 1, 0, 1 UNION
    SELECT 'MSSQL247_PERF_COUNTER', 'n/a', 'Data Collector', 'PERFORMANCE_COUNTERS', 1, 'EXEC dbo.usp_mssql247_collect_performance_counters', 'TSQL', 0, 1, 2, 'MSSQL247_beta', 'MSSQL247_PERF_COUNTER_SCHEDULE', 4, 1, 4, 1, 0, 1 UNION
    SELECT 'MSSQL247_BLOCKING_EVENTS', 'n/a', 'Data Collector', 'BLOCKED_QUERIES', 1, 'EXEC dbo.usp_mssql247_collect_blocked_query_stats', 'TSQL', 0, 1, 2, 'MSSQL247_beta', 'MSSQL247_BLOCKING_EVENTS_SCHEDULE', 4, 1, 4, 1, 0, 1 UNION
    SELECT 'MSSQL247_OS_VOLUMES', 'n/a', 'Data Collector', 'OS_VOLUMES', 1, '$Name = @{Label="Name"; Expression={$_.VolumeName}}
$Root = @{Label="Root"; Expression={$_.DeviceID}}
$Free = @{Label="Free"; Expression={$_.FreeSpace}}
$Total = @{Label="Total"; Expression={$_.Size}}

$Volumes = Get-WmiObject Win32_LogicalDisk | Select-Object $Name,$Root,$Free,$Total
$Volumes
$Query = ""
$Timestamp = Get-Date
$TimestampUtc = (Get-Date).ToUniversalTime()

 $Volumes| ForEach-Object -Process {
    $VolumeName = $_.Name;
    $VolumeMountPoint = $_.Root; 
    $FreeCapacity = $_.Free; 
    $TotalCapacity = $_.Total

    If ($VolumeName.Equals("")) {
        $VolumeName = "Local Disk (" + $VolumeMountPoint + ")"
    }
     
    [string]$Query += "INSERT MSSQL247_beta.dbo.mssql247_os_volumes 
                        (sql_instance, volume_name, volume_mount_point, total_size_kb, size_remaining_kb, collection_datetime, collection_datetime_utc) 
                            VALUES ((SELECT MSSQL247_beta.dbo.udf_get_server_name()), ''''$VolumeName'''', ''''$VolumeMountPoint'''',
                                ''''$TotalCapacity'''', ''''$FreeCapacity'''', ''''$Timestamp'''', ''''$TimestampUtc'''');"
}
# insert volume data into dbo.mssql247_os_volumes
# using SQLCMD command line tool 
SQLCMD -S localhost -Q $Query', 'PowerShell', 0, 1, 2, 'MSSQL247_beta', 'MSSQL247_OS_VOLUMES_SCHEDULE', 4, 1, 4, 1, 0, 1

  DECLARE @JobName varchar(255)
  DECLARE @JobDesc varchar(255)
  DECLARE @CategoryName varchar(255)
  DECLARE @OwnerLoginName varchar(255) = 'sa'
  DECLARE @JobServerName varchar(255) = '(LOCAL)'
  DECLARE @Sql nvarchar(max)
  DECLARE cur1 CURSOR FOR
  SELECT DISTINCT job_name, job_desc,
    category_name
  FROM @Jobs
  OPEN cur1 
  FETCH NEXT FROM cur1 INTO @JobName, @JobDesc, @CategoryName
  WHILE @@FETCH_STATUS = 0
  BEGIN
    SET @Sql = 'DECLARE @jobId BINARY(16)
      EXEC  msdb.dbo.sp_add_job @job_name=N''' + @JobName + ''', 
          @enabled=1, 
          @notify_level_eventlog=0, 
          @notify_level_email=2, 
          @notify_level_netsend=2, 
          @notify_level_page=2, 
          @delete_level=0, 
          @category_name=N'''+ @CategoryName +''', 
          @owner_login_name=N''' + @OwnerLoginName + ''', @job_id = @jobId OUTPUT

      EXEC msdb.dbo.sp_add_jobserver @job_name=N''' + @JobName + ''', @server_name = N''' + @JobServerName + '''
'
    FETCH NEXT FROM cur1 INTO @JobName, @JobDesc, @CategoryName
    EXECUTE(@Sql) 
  END
  CLOSE cur1
  DEALLOCATE cur1 

  DECLARE @JobName1 varchar(255)
  DECLARE @JobStepName varchar(255)
  DECLARE @JobStepId int
  DECLARE @Command varchar(255)
  DECLARE @Subsystem varchar(255)
  DECLARE @CmdexecSuccessCode int
  DECLARE @OnSuccessAction int
  DECLARE @OnFailAction int
  DECLARE @DatabaseName varchar(55)
  DECLARE cur1 CURSOR FOR
  SELECT job_name, job_step_name, job_step_id,
    command, subsystem, cmdexec_success_code, on_success_action,
    on_fail_action, database_name
  FROM @Jobs
  ORDER BY job_name, job_step_id
  OPEN cur1 
  FETCH NEXT FROM cur1 INTO @JobName1, @JobStepName, @JobStepId, @Command, @Subsystem, @CmdexecSuccessCode,
                              @OnSuccessAction, @OnFailAction, @DatabaseName
  WHILE @@FETCH_STATUS = 0
  BEGIN
    DECLARE @Sql1 nvarchar(max)
    SET @Sql1 = 'EXEC msdb.dbo.sp_add_jobstep @job_name=N''' + @JobName1 + ''', @step_name=N''' + @JobStepName + ''', 
		@step_id=' + CONVERT(varchar(10), @JobStepId) + ', 
		@cmdexec_success_code=' + CONVERT(varchar(10), @CmdexecSuccessCode) + ', 
		@on_success_action=' + CONVERT(varchar(10), @OnSuccessAction) +', 
		@on_fail_action='+ CONVERT(varchar(10), @OnFailAction) +', 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N''' + @Subsystem + ''', 
		@command=N''' + @Command + ''', 
		@database_name=N''' + @DatabaseName + ''', 
		@flags=0
'
    FETCH NEXT FROM cur1 INTO @JobName1, @JobStepName, @JobStepId, @Command, @Subsystem, @CmdexecSuccessCode,
                                @OnSuccessAction, @OnFailAction, @DatabaseName
    EXECUTE (@Sql1) 
  END
  CLOSE cur1
  DEALLOCATE cur1 

  DECLARE @JobName2 varchar(255)
  DECLARE @JobScheduleName varchar(255)
  DECLARE @FreqType varchar(10)
  DECLARE @FreqInterval varchar(10)
  DECLARE @FreqSubdayType varchar(10)
  DECLARE @FreqSubdayInterval varchar(10)
  DECLARE @FreqRelativeInterval varchar(10)
  DECLARE @FreqRecurrenceFactor varchar(10)
  DECLARE @ActiveStartDate varchar(8) = REPLACE(CONVERT(VARCHAR(25), CONVERT(DATE, GETDATE())), '-', '')
  DECLARE @ActiveEndDate varchar(8) = '99991231'
  DECLARE @ActiveStartTime varchar(6) = '0'
  DECLARE @ActiveEndTime varchar(6) = '235959'
  DECLARE cur1 CURSOR FOR
  SELECT DISTINCT job_name, job_schedule_name, freq_type,
    freq_interval, freq_subday_type, freq_subday_interval, freq_relative_interval,
    freq_recurrence_factor
  FROM @Jobs
  OPEN cur1 
  FETCH NEXT FROM cur1 INTO @JobName2, @JobScheduleName, @FreqType, @FreqInterval, @FreqSubdayType, 
                              @FreqSubdayInterval, @FreqRelativeInterval, @FreqRecurrenceFactor
  WHILE @@FETCH_STATUS = 0
  BEGIN
    DECLARE @Sql2 nvarchar(max)
    SET @Sql2 = 'DECLARE @schedule_id int
    EXEC msdb.dbo.sp_add_jobschedule @job_name=N''' + @JobName2 + ''', @name=N''' + @JobScheduleName + ''', 
        @enabled=1, 
        @freq_type=' + @FreqType + ', 
        @freq_interval=' + @FreqInterval +  ', 
        @freq_subday_type=' + @FreqSubdayType +  ', 
        @freq_subday_interval=' + @FreqSubdayInterval +  ', 
        @freq_relative_interval=' + @FreqRelativeInterval +  ', 
        @freq_recurrence_factor=' + @FreqRecurrenceFactor +  ', 
        @active_start_date=' + @ActiveStartDate +  ', 
        @active_end_date=' + @ActiveEndDate +  ', 
        @active_start_time=' + @ActiveStartTime +  ', 
        @active_end_time=' + @ActiveEndTime +  ', @schedule_id = @schedule_id OUTPUT
'
    FETCH NEXT FROM cur1 INTO @JobName2, @JobScheduleName, @FreqType, @FreqInterval, @FreqSubdayType, 
                              @FreqSubdayInterval, @FreqRelativeInterval, @FreqRecurrenceFactor
    EXECUTE (@Sql2) 
  END
  CLOSE cur1
  DEALLOCATE cur1 


RETURN 0