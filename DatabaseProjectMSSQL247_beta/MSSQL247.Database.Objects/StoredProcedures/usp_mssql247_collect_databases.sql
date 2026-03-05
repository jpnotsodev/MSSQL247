CREATE PROCEDURE [dbo].[usp_mssql247_collect_databases]
AS
  ;WITH cteDatabases AS (
        SELECT databases.name, databases.database_id,
            databases.create_date, databases.collation_name,
            databases.user_access_desc, databases.is_read_only,
            databases.is_auto_close_on, databases.is_auto_shrink_on,
            databases.is_in_standby,
            databases.compatibility_level, databases.recovery_model,
            databases.recovery_model_desc, databases.state,
            databases.state_desc
        FROM [sys].[databases] databases 
    )
    INSERT INTO [dbo].[mssql247_databases]
        ([sql_instance], [name], [database_id], [create_date], [collation_name], 
        [user_access], [is_read_only], [is_auto_close_on],
        [is_auto_shrink_on], [compatibility_level],
        [recovery_model], [state], [is_in_standby])
    SELECT dbo.udf_get_server_name(), name, database_id,
        create_date,  collation_name, user_access_desc, is_read_only,
        is_auto_close_on, is_auto_shrink_on, compatibility_level, 
        recovery_model_desc, state_desc, is_in_standby
    FROM cteDatabases
      
RETURN 0