CREATE PROCEDURE [dbo].[usp_mssql247_collect_file_io_stats]
  @dbid int = NULL,
  @fileid int = NULL
AS
  ; WITH file_io_stats AS (
         SELECT dbo.udf_get_server_name() sql_instance, database_id, file_id, sample_ms,
        num_of_reads, num_of_bytes_read,
        io_stall_read_ms, num_of_writes,
        num_of_bytes_written, io_stall_write_ms, io_stall
        FROM sys.dm_io_virtual_file_stats(@dbid, @fileid)
    )
    INSERT INTO mssql247_file_io_stats 
      (sql_instance, 
      database_id,
      file_id,
      sample_ms,
      num_of_reads,
      num_of_bytes_read,
      io_stall_read_ms,
      num_of_writes,
      num_of_bytes_written,
      io_stall_write_ms,
      io_stall)
        SELECT sql_instance,
          database_id,
          file_id,
          sample_ms,
          num_of_reads,
          num_of_bytes_read,
          io_stall_read_ms,
          num_of_writes,
          num_of_bytes_written,
          io_stall_write_ms,
          io_stall
        FROM file_io_stats
RETURN 0
