CREATE TABLE [dbo].[mssql247_databases]
(
  [id] INT NOT NULL IDENTITY(1, 1),
  [sql_instance] NVARCHAR(255) NULL,
  [name] VARCHAR(55),
  [database_id] INT,
  [create_date] DATETIME,
  [collation_name] VARCHAR(55),
  [user_access] VARCHAR(55),
  [is_read_only] BIT NOT NULL DEFAULT 0,
  [is_auto_close_on] BIT NOT NULL DEFAULT 0,
  [is_auto_shrink_on] BIT NOT NULL DEFAULT 0,
  [compatibility_level] VARCHAR(55),
  [recovery_model] VARCHAR(55),
  [state] VARCHAR(55),
  [is_in_standby] BIT NOT NULL DEFAULT 0,
  [collection_datetime] DATETIME DEFAULT GETDATE(),
  [collection_datetime_utc] DATETIME DEFAULT GETUTCDATE(),
  CONSTRAINT PK_databases_id PRIMARY KEY ([id])
)