CREATE TABLE [dbo].[mssql247_blocked_query_stats]
(
  blocked_query_stat_id INT IDENTITY(1,1) NOT NULL,
  session_id INT NOT NULL,
  status VARCHAR(25) NOT NULL,
  start_time DATETIME NOT NULL,
  host_name VARCHAR(155),
  client_interface_name VARCHAR(155),
  login_name VARCHAR(155),
  nt_domain VARCHAR(155),
  nt_user_name VARCHAR(155),
  cpu_time BIGINT DEFAULT 0,
  memory_usage INT DEFAULT 0,
  command VARCHAR(25),
  sql_text NVARCHAR(MAX) NOT NULL,
  database_name VARCHAR(25) NOT NULL,
  wait_type VARCHAR(25),
  wait_time BIGINT NOT NULL DEFAULT 0,
  last_wait_type VARCHAR(25) NOT NULL,
  open_transaction_count BIT DEFAULT 0,
  transaction_id BIGINT NOT NULL DEFAULT 0,
  blocking_session_id INT NOT NULL DEFAULT 0,
  program_name VARCHAR(155),
  local_net_address VARCHAR(155), 
  client_net_address VARCHAR(155),
  blocked_query_status BIT NOT NULL DEFAULT 1,
  snapshot_timestamp DATETIME
)

ALTER TABLE dbo.mssql247_blocked_query_stats
ADD CONSTRAINT pk_id_293128390128 PRIMARY KEY (blocked_query_stat_id)

ALTER TABLE dbo.mssql247_blocked_query_stats
ADD CONSTRAINT df_snapshot_timestamp_3289329833 DEFAULT GETDATE() FOR snapshot_timestamp

