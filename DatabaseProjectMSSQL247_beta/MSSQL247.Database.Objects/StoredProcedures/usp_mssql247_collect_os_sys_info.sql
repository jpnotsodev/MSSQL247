CREATE PROCEDURE [dbo].[usp_mssql247_collect_os_sys_info]
AS
    DECLARE @Query NVARCHAR(2000) 
    DECLARE @SqlInstance VARCHAR(155) = dbo.udf_get_server_name()
    DECLARE @ProductVersion nvarchar(60) = CONVERT(NVARCHAR(60), SERVERPROPERTY('productversion'))
    DECLARE @sys_info_temp_table TABLE (sql_instance VARCHAR(155) NULL,
        cpu_ticks BIGINT NOT NULL,
        ms_ticks BIGINT NOT NULL,
        cpu_count INT NOT NULL,
        hyperthread_ratio INT NOT NULL,
        physical_memory_kb BIGINT NOT NULL,
        virtual_memory_kb BIGINT NOT NULL,
        committed_memory_kb BIGINT NOT NULL,
        committed_target_kb BIGINT NOT NULL,
        visible_target_kb BIGINT NOT NULL,
        max_workers_count INT NOT NULL,
        scheduler_count INT NOT NULL,
        scheduler_total_count INT NOT NULL,
        sqlserver_start_time_ms_ticks BIGINT NOT NULL,
        sqlserver_start_time DATETIME NOT NULL)
    IF @ProductVersion LIKE '10.%'
    BEGIN
        SET @Query = 'select ''' + @SqlInstance + ''', cpu_ticks, 
                        ms_ticks, cpu_count, hyperthread_ratio, 
                        physical_memory_in_bytes/1024, virtual_memory_in_bytes/1024,
                        bpool_committed, bpool_commit_target, bpool_visible, 
                        max_workers_count, scheduler_count, scheduler_total_count,
                        sqlserver_start_time_ms_ticks, sqlserver_start_time
                from sys.dm_os_sys_info'
        INSERT INTO @sys_info_temp_table
        EXEC (@Query)
    END
    ELSE
    BEGIN
        SET @Query = 'select ''' + @SqlInstance + ''', cpu_ticks, 
                        ms_ticks, cpu_count, hyperthread_ratio, 
                        physical_memory_kb, virtual_memory_kb,
                        committed_kb, committed_target_kb, visible_target_kb, 
                        max_workers_count, scheduler_count, scheduler_total_count,
                        sqlserver_start_time_ms_ticks, sqlserver_start_time
                from sys.dm_os_sys_info'
        INSERT INTO @sys_info_temp_table
        EXEC (@Query)
    END

    INSERT INTO dbo.mssql247_os_sys_info (
        sql_instance, cpu_ticks, ms_ticks, cpu_count,
        hyperthread_ratio, physical_memory_kb, virtual_memory_kb,
        committed_memory_kb, committed_target_kb, visible_target_kb,
        max_workers_count, scheduler_count, scheduler_total_count,
        sqlserver_start_time_ms_ticks, sqlserver_start_time
    )
    SELECT sql_instance, cpu_ticks, ms_ticks, cpu_count,
        hyperthread_ratio, physical_memory_kb, virtual_memory_kb,
        committed_memory_kb, committed_target_kb, visible_target_kb,
        max_workers_count, scheduler_count, scheduler_total_count,
        sqlserver_start_time_ms_ticks, sqlserver_start_time
    FROM @sys_info_temp_table

RETURN 0