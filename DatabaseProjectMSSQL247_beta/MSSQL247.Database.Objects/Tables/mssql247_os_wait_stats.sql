CREATE TABLE [dbo].[mssql247_os_wait_stats]
(
  [wait_stats_id] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
  [sql_instance] VARCHAR(55) NOT NULL,
  [wait_type] VARCHAR(55) NOT NULL,
  [waiting_tasks_count] BIGINT NOT NULL DEFAULT 0,
  [wait_time_ms] BIGINT NOT NULL DEFAULT 0,
  [max_wait_time_ms] BIGINT NOT NULL DEFAULT 0,
  [signal_wait_time_ms] BIT NOT NULL,
  [collection_datetime] DATETIME DEFAULT GETDATE(),
  [collection_datetime_utc] DATETIME DEFAULT GETUTCDATE()
)