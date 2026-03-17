CREATE PROCEDURE [dbo].[usp_mssql247_collect_memory_stats]
AS
  DECLARE @SqlInstance varchar(155) = dbo.udf_get_server_name()
  ;WITH cteMemoryStats 
    (sql_instance, total_physical_memory_kb, available_physical_memory_kb,
    physical_memory_in_use_kb, total_page_file_kb, available_page_file_kb, 
    system_cache_kb, kernel_paged_pool_kb, kernel_nonpaged_pool_kb,
    system_high_memory_signal_state, system_low_memory_signal_state, 
    system_memory_state_desc)
  AS (SELECT @SqlInstance,
    total_physical_memory_kb, available_physical_memory_kb,
      (SELECT physical_memory_in_use_kb FROM sys.dm_os_process_memory),
      total_page_file_kb, available_page_file_kb, system_cache_kb,
      kernel_paged_pool_kb, kernel_nonpaged_pool_kb, system_high_memory_signal_state,
      system_low_memory_signal_state, system_memory_state_desc
    FROM sys.dm_os_sys_memory)

  INSERT INTO dbo.mssql247_memory_stats
  (sql_instance, total_physical_memory_kb, available_physical_memory_kb,
    physical_memory_in_use_kb, total_page_file_kb, available_page_file_kb, 
    system_cache_kb, kernel_paged_pool_kb, kernel_nonpaged_pool_kb,
    system_high_memory_signal_state, system_low_memory_signal_state, 
    system_memory_state_desc)
  SELECT sql_instance, total_physical_memory_kb, available_physical_memory_kb,
    physical_memory_in_use_kb, total_page_file_kb, available_page_file_kb, 
    system_cache_kb, kernel_paged_pool_kb, kernel_nonpaged_pool_kb,
    system_high_memory_signal_state, system_low_memory_signal_state, 
    system_memory_state_desc
  FROM cteMemoryStats
RETURN 0