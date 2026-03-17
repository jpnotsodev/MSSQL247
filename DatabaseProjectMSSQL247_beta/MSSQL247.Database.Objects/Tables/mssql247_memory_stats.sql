CREATE TABLE [dbo].[mssql247_memory_stats]
(
  memory_stats_id INT identity(1, 1) PRIMARY KEY,
  sql_instance varchar(155),
  total_physical_memory_kb bigint,
  available_physical_memory_kb bigint,
  physical_memory_in_use_kb bigint,
  total_page_file_kb bigint,
  available_page_file_kb bigint,
  system_cache_kb bigint,
  kernel_paged_pool_kb bigint,
  kernel_nonpaged_pool_kb bigint,
  system_high_memory_signal_state int,
  system_low_memory_signal_state int,
  system_memory_state_desc varchar(255),
  collection_datetime datetime default getdate(),
  collection_datetime_utc datetime default getutcdate()
)

CREATE INDEX NIX_collection_datetime_utc ON dbo.mssql247_memory_stats (collection_datetime_utc)