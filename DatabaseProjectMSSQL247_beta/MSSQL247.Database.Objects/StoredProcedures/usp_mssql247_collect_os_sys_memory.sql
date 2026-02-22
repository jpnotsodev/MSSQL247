CREATE PROCEDURE [dbo].[usp_mssql247_collect_os_sys_memory]
AS
  ;WITH os_sys_memory AS (

      SELECT dbo.udf_get_server_name() sql_instance, 
          total_physical_memory_kb,
          available_physical_memory_kb, total_page_file_kb, 
          available_page_file_kb, system_high_memory_signal_state,
          system_low_memory_signal_state, system_memory_state_desc
      FROM sys.dm_os_sys_memory

  )
  INSERT INTO [dbo].[mssql247_os_sys_memory]
    ([sql_instance], [total_physical_memory_kb], [available_physical_memory_kb],
      [total_page_file_kb], [available_page_file_kb], 
      [system_high_memory_signal_state], [system_low_memory_signal_state],
      [system_memory_state_desc])
    SELECT sql_instance, total_physical_memory_kb, available_physical_memory_kb,
      total_page_file_kb, available_page_file_kb, system_high_memory_signal_state, 
      system_low_memory_signal_state, system_memory_state_desc
    FROM os_sys_memory
RETURN 0
