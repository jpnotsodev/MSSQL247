CREATE PROCEDURE [dbo].[usp_mssql247_collect_os_process_memory]
AS
  ;WITH os_process_memory AS (
    SELECT dbo.udf_get_server_name() sql_instance, 
      [physical_memory_in_use_kb],
      [large_page_allocations_kb],
      [locked_page_allocations_kb],
      [total_virtual_address_space_kb],
      [virtual_address_space_reserved_kb],
      [virtual_address_space_committed_kb],
      [page_fault_count],
      [memory_utilization_percentage],
      [available_commit_limit_kb],
      [process_physical_memory_low],
      [process_virtual_memory_low]
    FROM sys.dm_os_process_memory
  )
  INSERT INTO [dbo].[mssql247_os_process_memory]
    (sql_instance, physical_memory_in_use_kb, large_page_allocations_kb,
    locked_page_allocations_kb, total_virtual_address_space_kb, 
    virtual_address_space_reserved_kb, virtual_address_space_committed_kb,
    page_fault_count, memory_utilization_percentage, available_commit_limit_kb,
    process_physical_memory_low, process_virtual_memory_low)
  SELECT sql_instance, 
      [physical_memory_in_use_kb],
      [large_page_allocations_kb],
      [locked_page_allocations_kb],
      [total_virtual_address_space_kb],
      [virtual_address_space_reserved_kb],
      [virtual_address_space_committed_kb],
      [page_fault_count],
      [memory_utilization_percentage],
      [available_commit_limit_kb],
      [process_physical_memory_low],
      [process_virtual_memory_low] 
    FROM os_process_memory 
RETURN 0