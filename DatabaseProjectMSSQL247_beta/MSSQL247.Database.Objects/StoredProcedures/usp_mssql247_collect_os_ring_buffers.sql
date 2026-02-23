CREATE PROCEDURE [dbo].[usp_mssql247_collect_os_ring_buffers]
AS
  WITH ring_buffers_filtered AS (
    SELECT ring_buffer_address, 
            ring_buffer_type, 
            DATEADD(MS, timestamp - (SELECT ms_ticks FROM sys.dm_os_sys_info), GETDATE()) timestamp, 
            CAST(record AS XML) record FROM sys.dm_os_ring_buffers 
      WHERE ring_buffer_type IN ('RING_BUFFFER_RESOUCE_MONITOR', 
                                    'RING_BUFFER_SCHEDULER_MONITOR')
  )
    INSERT mssql247_os_ring_buffers 
      (sql_instance,
        ring_buffer_address,
        ring_buffer_type,
        ring_buffer_timestamp,
        record)
      SELECT dbo.udf_get_server_name(),
        ring_buffer_address,
        ring_buffer_type,
        timestamp,
        CONVERT(NVARCHAR(2048), record)
      FROM ring_buffers_filtered
RETURN 0
