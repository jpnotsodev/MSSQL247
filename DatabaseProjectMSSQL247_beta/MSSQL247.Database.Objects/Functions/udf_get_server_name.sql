-- Write your own SQL object definition here, and it'll be included in your package.
CREATE FUNCTION udf_get_server_name ()
RETURNS NVARCHAR(155)
AS BEGIN
    RETURN (COALESCE((SELECT CONVERT(NVARCHAR(155), SERVERPROPERTY('ServerName'))), 
                (SELECT CONVERT(NVARCHAR(155), SERVERPROPERTY('MachineName')))) + '\' +
                COALESCE((SELECT CONVERT(NVARCHAR(155), SERVERPROPERTY('InstanceName'))), 
                    'MSSQLSERVER'))
END