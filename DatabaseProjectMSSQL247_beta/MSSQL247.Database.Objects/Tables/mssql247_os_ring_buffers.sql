CREATE TABLE [dbo].[mssql247_os_ring_buffers]
(
  [ring_buffer_id] INT IDENTITY(1,1) PRIMARY KEY,
  [sql_instance] VARCHAR(55) NOT NULL,
  [ring_buffer_address] VARBINARY(2048) NOT NULL,
  [ring_buffer_type] VARCHAR(155) NOT NULL,
  [ring_buffer_timestamp] DATETIME,
  [record] VARCHAR(2048) NOT NULL,
  [snapshot_timestamp] DATETIME
)

ALTER TABLE [dbo].[mssql247_os_ring_buffers] 
ADD CONSTRAINT df_os_ring_buffer_napshot_timestamp_default_getdate DEFAULT GETDATE() FOR [snapshot_timestamp]