CREATE TABLE [dbo].[mssql247_os_sys_info]
(
  sys_info_id INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
  sql_instance VARCHAR(155) NULL,
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
  sqlserver_start_time DATETIME NOT NULL,
  collection_datetime DATETIME DEFAULT GETDATE(),
  collection_datetime_utc DATETIME DEFAULT GETUTCDATE()
)