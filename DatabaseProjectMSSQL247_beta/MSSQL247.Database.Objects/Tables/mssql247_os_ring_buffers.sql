CREATE TABLE [dbo].[mssql247_os_ring_buffers]
(
  [ring_buffer_id] INT IDENTITY(1,1) PRIMARY KEY,
  [sql_instance] VARCHAR(55) NOT NULL,
  [ring_buffer_address] VARBINARY(2048) NOT NULL,
  [ring_buffer_type] VARCHAR(155) NOT NULL,
  [ring_buffer_timestamp] DATETIME,
  [record] VARCHAR(2048) NOT NULL,
  [collection_datetime] DATETIME,
  [collection_datetime_utc] DATETIME
)

ALTER TABLE [dbo].[mssql247_os_ring_buffers] 
ADD CONSTRAINT df_os_ring_buffer_collection_datetime DEFAULT GETDATE() FOR [collection_datetime]

ALTER TABLE [dbo].[mssql247_os_ring_buffers] 
ADD CONSTRAINT df_os_ring_buffer_collection_datetime_utc DEFAULT GETUTCDATE() FOR [collection_datetime_utc]