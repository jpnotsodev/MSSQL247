CREATE PROCEDURE [dbo].[usp_mssql247_collect_performance_counters]
AS
  
  WITH ctePerfCounters (object_name, counter_name,
                            instance_name, cntr_value, cntr_type)  
  AS (SELECT object_name, counter_name, instance_name,
      cntr_value, cntr_type
    FROM sys.dm_os_performance_counters
    WHERE object_name IN ('SQLServer:Buffer Manager', 'SQLServer:General Statistics',
                          'SQLServer:Locks', 'SQLServer:Databases', 'SQLServer:Latches',
                          'SQLServer:Wait Statistics', 'SQLServer:SQL Statistics',
                          'SQLServer:Memory Manager', 'SQLServer:Transactions',
                          'SQLServer:Resource Pool Stats'))
  INSERT INTO dbo.mssql247_performance_counters
  (sql_instance, object_name, counter_name,
  instance_name, cntr_value, cntr_type)
  SELECT dbo.udf_get_server_name(), object_name, counter_name, instance_name,
    cntr_value, cntr_type
  FROM ctePerfCounters 

RETURN 0