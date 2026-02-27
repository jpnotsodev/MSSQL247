CREATE PROCEDURE [dbo].[usp_mssql247_collect_os_ring_buffers]
AS
  
  WITH ring_buffer_resource_last_record_ids (ring_buffer_type, record_id) AS (
    SELECT 
      ring_buffer_type, 
      MAX(record.value('(/Record/@id)[1]', 'int')) record_id 
    FROM (
          SELECT timestamp, CAST(record AS XML) record, ring_buffer_type FROM sys.dm_os_ring_buffers
            WHERE ring_buffer_type = 'RING_BUFFER_RESOURCE_MONITOR'
              OR ring_buffer_type = 'RING_BUFFER_SCHEDULER_MONITOR'
          ) ringbuffer
    GROUP BY ring_buffer_type
  ), ring_buffer AS (
    SELECT *, record.value('(/Record/@id)[1]', 'int') record_id
    FROM (
          SELECT 
            ring_buffer_address, 
            ring_buffer_type, 
            timestamp, 
            CAST(record AS XML) record 
          FROM sys.dm_os_ring_buffers 
          WHERE ring_buffer_type = 'RING_BUFFER_RESOURCE_MONITOR'
              OR ring_buffer_type = 'RING_BUFFER_SCHEDULER_MONITOR'
      ) annon1
    WHERE record.value('(/Record/@id)[1]', 'int') IN (
            SELECT record_id FROM ring_buffer_resource_last_record_ids)
  )
    INSERT mssql247_os_ring_buffers 
      (sql_instance,
        ring_buffer_address,
        ring_buffer_type,
        ring_buffer_timestamp,
        record)
      SELECT 
        dbo.udf_get_server_name(),
        ring_buffer_address,
        ring_buffer_type,
        DATEADD(MS, timestamp - (SELECT ms_ticks FROM sys.dm_os_sys_info), getdate()),
        CONVERT(NVARCHAR(2048), record)
      FROM ring_buffer
RETURN 0