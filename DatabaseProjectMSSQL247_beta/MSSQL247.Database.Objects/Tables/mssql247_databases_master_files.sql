CREATE TABLE [dbo].[mssql247_master_files]
(
  [database_master_file_id] INT IDENTITY (1, 1) NOT NULL PRIMARY KEY,
  [sql_instance] VARCHAR(55) NULL,
  [database_id] SMALLINT NOT NULL,
  [file_id] SMALLINT NOT NULL,
  [database_name] VARCHAR(55) NULL,
  [type] SMALLINT NOT NULL,
  [type_desc] VARCHAR(55) NULL,
  [physical_name] NVARCHAR(2048) NULL,
  [size] BIGINT NOT NULL,
  [max_size] INT NOT NULL,
  [growth] INT NOT NULL,
  [is_media_read_only] BIT NOT NULL DEFAULT 0,
  [is_sparse] BIT NOT NULL DEFAULT 0,
  [is_percent_growth] BIT NOT NULL DEFAULT 0,
  [collection_datetime] DATETIME DEFAULT GETDATE(),
  [collection_datetime_utc] DATETIME DEFAULT GETUTCDATE()
)