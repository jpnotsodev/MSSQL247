CREATE TABLE [dbo].[mssql247_file_io_stats]
(
  [file_io_stats_id] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
  [sql_instance] VARCHAR(55),
  [database_id] INT NOT NULL,
  [file_id] INT NOT NULL,
  [sample_ms] BIGINT NOT NULL,
  [num_of_reads] BIGINT NOT NULL,
  [num_of_bytes_read] BIGINT NOT NULL,
  [io_stall_read_ms] BIGINT NOT NULL,
  [num_of_writes] BIGINT NOT NULL,
  [num_of_bytes_written] BIGINT NOT NULL,
  [io_stall_write_ms] BIGINT NOT NULL,
  [io_stall] BIGINT NOT NULL,
  [collection_datetime] DATETIME,
  [collection_datetime_utc] DATETIME 
)

ALTER TABLE [dbo].[mssql247_file_io_stats] 
ADD CONSTRAINT df_sample_ms_default_0 DEFAULT 0 FOR [sample_ms]

ALTER TABLE [dbo].[mssql247_file_io_stats] 
ADD CONSTRAINT df_collection_datetime_getdate DEFAULT GETDATE() FOR [collection_datetime]

ALTER TABLE [dbo].[mssql247_file_io_stats] 
ADD CONSTRAINT df_collection_datetime_utc_getutcdate DEFAULT GETUTCDATE() FOR [collection_datetime_utc]