CREATE TABLE [dbo].[mssql247_os_process_memory]
(
  [process_memory_id] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
  [sql_instance] VARCHAR(55) NOT NULL,
  [physical_memory_in_use_kb] BIGINT NOT NULL,
  [large_page_allocations_kb] BIGINT NOT NULL,
  [locked_page_allocations_kb] BIGINT NOT NULL,
  [total_virtual_address_space_kb] BIGINT NOT NULL,
  [virtual_address_space_reserved_kb] BIGINT NOT NULL,
  [virtual_address_space_committed_kb] BIGINT NOT NULL,
  [page_fault_count] BIGINT NOT NULL,
  [memory_utilization_percentage] INT NOT NULL,
  [available_commit_limit_kb] BIGINT NOT NULL,
  [process_physical_memory_low] BIT NOT NULL,
  [process_virtual_memory_low] BIT NOT NULL,
  [snapshot_timestamp] DATETIME DEFAULT GETDATE()
)
