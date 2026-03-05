CREATE PROCEDURE [dbo].[usp_mssql247_collect_instance_info]
AS
  DECLARE @SqlInstance VARCHAR(155) = dbo.udf_get_server_name()

  IF (SELECT COUNT(*) FROM dbo.mssql247_sql_instance) = 0
  BEGIN
    INSERT INTO dbo.mssql247_sql_instance (
      id, sql_instance, sqlserver_product_version,
      sqlserver_edition, machine_name, server_name,
      instance_name, local_net_address, client_net_address
    )
    SELECT 1, @SqlInstance, CONVERT(VARCHAR(155), SERVERPROPERTY('ProductVersion'))
      , CONVERT(VARCHAR(155), SERVERPROPERTY('Edition'))
      , CONVERT(VARCHAR(155), SERVERPROPERTY('MachineName'))
      , CONVERT(VARCHAR(155), SERVERPROPERTY('ServerName'))
      , CONVERT(VARCHAR(155), SERVERPROPERTY('InstanceName'))
      , CONVERT(VARCHAR(155), CONNECTIONPROPERTY('local_net_address'))
      , CONVERT(VARCHAR(155), CONNECTIONPROPERTY('client_net_address'))
  END
RETURN 0
