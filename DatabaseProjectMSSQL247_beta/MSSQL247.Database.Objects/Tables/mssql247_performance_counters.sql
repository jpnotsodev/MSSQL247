CREATE TABLE [dbo].[mssql247_performance_counters]
(
  perf_counter_id INT IDENTITY(1, 1) PRIMARY KEY,
  sql_instance VARCHAR(255),
  object_name NVARCHAR(255),
  counter_name NVARCHAR(255), 
  instance_name NVARCHAR(255),
  cntr_value BIGINT, 
  cntr_type INT,
  collection_datetime DATETIME,
  collection_datetime_utc DATETIME
)

ALTER TABLE [dbo].[mssql247_performance_counters]
ADD CONSTRAINT df_perfcounter_stamp_getdate DEFAULT GETDATE() FOR collection_datetime

ALTER TABLE [dbo].[mssql247_performance_counters]
ADD CONSTRAINT df_perfcounter_stamp_getutcdate DEFAULT GETDATE() FOR collection_datetime_utc