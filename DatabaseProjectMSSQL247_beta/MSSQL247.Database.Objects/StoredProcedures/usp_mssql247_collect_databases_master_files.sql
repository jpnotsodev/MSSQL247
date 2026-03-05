CREATE PROCEDURE [dbo].[usp_mssql247_collect_master_files]
AS  
  DECLARE @SqlInstance VARCHAR(255) = dbo.udf_get_server_name()
  ;WITH db_master_files AS (
    SELECT @SqlInstance sql_instance, [database_id],
        [file_id], [name], [type], [type_desc], 
        [physical_name], [size], [max_size], [growth],
        [is_media_read_only], [is_sparse], [is_percent_growth]
    FROM sys.master_files
  )
  INSERT INTO mssql247_master_files
   ([sql_instance], [database_id], 
    [file_id], [database_name], [type], [type_desc],
    [physical_name], [size], [max_size], [growth],
    [is_media_read_only], [is_sparse], [is_percent_growth])
    SELECT * FROM db_master_files
  
RETURN 0

