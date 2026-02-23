CREATE TABLE [dbo].[mssql247_os_ring_buffers]
(
  [ring_buffer_id] INT IDENTITY(1,1) PRIMARY KEY,
  [sql_instance] VARCHAR(55) NOT NULL,
  [ring_buffer_address] VARBINARY(2048) NOT NULL,
  [ring_buffer_type] VARCHAR(155) NOT NULL,
  [ring_buffer_timestamp] DATETIME,
  [record] VARCHAR(2048) NOT NULL,
  [snapshot_datetime] DATETIME DEFAULT GETDATE()
)