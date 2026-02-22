CREATE PROCEDURE [dbo].[usp_mssql247_collect_databases_info]
AS
  ;WITH data_file_size AS (
        SELECT databases.name, databases.database_id,
            databases.create_date, databases.collation_name,
            databases.user_access_desc, databases.is_read_only,
            databases.is_auto_close_on, databases.is_auto_shrink_on,
            databases.is_in_standby,
            databases.compatibility_level, databases.recovery_model,
            databases.recovery_model_desc, databases.state,
            databases.state_desc, (CONVERT(DECIMAL(10, 5), size)*8) size_in_mb 
        FROM [sys].[databases] databases 
        INNER JOIN [sys].[master_files] masterfiles
            ON databases.[database_id] = masterfiles.[database_id]
        WHERE masterfiles.[type] = 0
    ), log_file_size AS (
        SELECT databases.name, databases.database_id,
            databases.create_date, databases.collation_name,
            databases.user_access_desc, databases.is_read_only,
            databases.is_auto_close_on, databases.is_auto_shrink_on,
            databases.is_in_standby,
            databases.compatibility_level, databases.recovery_model,
            databases.recovery_model_desc, databases.state,
            databases.state_desc, (CONVERT(DECIMAL(10, 5), size)*8) size_in_mb 
        FROM [sys].[databases] databases
        INNER JOIN [sys].[master_files] masterfiles
            ON databases.[database_id] = masterfiles.[database_id]
        WHERE masterfiles.[type] = 1
    )
    INSERT INTO [MSSQL247_beta].[dbo].[mssql247_databases]
    ([name], [database_id], [create_date], [collation_name], 
    [user_access], [is_read_only], [is_auto_close_on],
    [is_auto_shrink_on], [compatibility_level],
    [recovery_model], [state], [is_in_standby])
    SELECT data_file_size.name, data_file_size.database_id,
        data_file_size.create_date, data_file_size. collation_name,
        data_file_size.user_access_desc, data_file_size.is_read_only,
        data_file_size.is_auto_close_on, data_file_size.is_auto_shrink_on,
        data_file_size.compatibility_level, data_file_size.recovery_model_desc,
        data_file_size.state_desc, data_file_size.is_in_standby
    FROM data_file_size
    INNER JOIN log_file_size
      ON data_file_size.database_id = log_file_size.database_id
      
RETURN 0