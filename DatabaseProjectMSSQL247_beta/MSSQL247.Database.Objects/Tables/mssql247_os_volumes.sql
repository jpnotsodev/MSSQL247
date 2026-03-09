CREATE TABLE [dbo].[mssql247_os_volumes]
(
  [volume_id] INT IDENTITY(1,1) NOT NULL,
  [sql_instance] VARCHAR(55),
  [volume_name] VARCHAR(55),
  [volume_mount_point] VARCHAR(55),
  [total_size_kb] BIGINT,
  [size_remaining_kb] BIGINT,
  [collection_datetime] DATETIME DEFAULT GETDATE(),
  [collection_datetime_utc] DATETIME DEFAULT GETUTCDATE(),
  CONSTRAINT PK_os_volumes_id PRIMARY KEY ([volume_id]),
)

CREATE NONCLUSTERED INDEX [NONCLUSTERED_os_volumes_collection_datetime_utc] ON 
[dbo].[mssql247_os_volumes] (collection_datetime_utc)