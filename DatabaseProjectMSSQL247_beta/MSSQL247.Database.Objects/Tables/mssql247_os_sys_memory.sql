CREATE TABLE [dbo].[mssql247_os_sys_memory]
(
  [sys_memory_id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
  [sql_instance] VARCHAR(55) NULL,
  [total_physical_memory_kb] BIGINT NOT NULL,
  [available_physical_memory_kb] BIGINT NOT NULL,
  [total_page_file_kb] BIGINT NOT NULL,
  [available_page_file_kb] BIGINT NOT NULL,
  [system_high_memory_signal_state] BIT NOT NULL DEFAULT 0,
  [system_low_memory_signal_state] BIT NOT NULL DEFAULT 0,
  [system_memory_state_desc] VARCHAR(55),
  [collection_datetime] DATETIME DEFAULT GETDATE(),
  [collection_datetime_utc] DATETIME DEFAULT GETUTCDATE()
)