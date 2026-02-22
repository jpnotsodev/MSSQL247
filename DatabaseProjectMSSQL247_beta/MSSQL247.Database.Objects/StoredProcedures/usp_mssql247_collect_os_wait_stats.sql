CREATE PROCEDURE [dbo].[usp_mssql247_collect_os_wait_stats]
AS
  
  WITH wait_stats AS (
    SELECT dbo.udf_get_server_name() sql_instance,
      wait_type, waiting_tasks_count,
      wait_time_ms, max_wait_time_ms,
      signal_wait_time_ms
    FROM sys.dm_os_wait_stats
  )

    INSERT INTO [dbo].[mssql247_os_wait_stats]
     (sql_instance, wait_type, waiting_tasks_count,
     wait_time_ms, max_wait_time_ms, signal_wait_time_ms)
      SELECT sql_instance, wait_type,
        waiting_tasks_count, wait_time_ms, 
        max_wait_time_ms, signal_wait_time_ms
      FROM wait_stats
RETURN 0
