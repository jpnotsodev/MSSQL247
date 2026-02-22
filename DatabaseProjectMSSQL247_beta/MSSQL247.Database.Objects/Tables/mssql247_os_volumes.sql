CREATE TABLE [dbo].[mssql247_os_volumes]
(
  [volume_id] INT NOT NULL,
  [sql_instance] VARCHAR(55),
  [volume_name] VARCHAR(55),
  [volume_mount_point] VARCHAR(55),
  [total_size_kb] BIGINT,
  [size_remaining_kb] BIGINT,
  [snapshot_timestamp] DATETIME DEFAULT GETDATE(),
  CONSTRAINT PK_os_volumes_id PRIMARY KEY ([volume_id]),
)