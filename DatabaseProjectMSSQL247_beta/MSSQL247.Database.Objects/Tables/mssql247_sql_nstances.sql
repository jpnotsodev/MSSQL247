CREATE TABLE [dbo].[mssql247_sql_instance]
(
  id INT NOT NULL PRIMARY KEY,
  [sql_instance] VARCHAR(155),
  [sqlserver_product_version] VARCHAR(155),
  [sqlserver_edition] VARCHAR(155),
  [machine_name] VARCHAR(155),
  [server_name] VARCHAR(155),
  [instance_name] VARCHAR(155),
  [local_net_address] VARCHAR(155),
  [client_net_address] VARCHAR(155), 
  [last_updated] DATETIME DEFAULT GETDATE()
)
