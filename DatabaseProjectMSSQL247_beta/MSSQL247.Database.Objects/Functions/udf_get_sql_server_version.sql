CREATE FUNCTION dbo.udf_get_sql_server_version (
	@productVersion VARCHAR(20) = NULL)
RETURNS VARCHAR(155)
BEGIN 
	IF @productVersion IS NULL 
		SET @productVersion = (SELECT CONVERT(NVARCHAR(155), SERVERPROPERTY('productVersion')));
	RETURN 
		(SELECT CASE WHEN @productVersion LIKE N'16%' 
							THEN N'SQL Server 2022'
				WHEN @productVersion LIKE N'15%' 
							THEN N'SQL Server 2019' 
				WHEN @productVersion LIKE N'14%' 
							THEN N'SQL Server 2017' 
				WHEN @productVersion LIKE N'13%' 
							THEN N'SQL Server 2016' 
				WHEN @productVersion LIKE N'12%' 
							THEN N'SQL Server 2015' 
				WHEN @productVersion LIKE N'11%' 
							THEN N'SQL Server 2012' 
				WHEN @productVersion LIKE N'10.5%' 
							THEN N'SQL Server 2008 R2' 
				WHEN @productVersion LIKE N'10%' 
							THEN N'SQL Server 2008'  
				WHEN @productVersion LIKE N'9%' 
							THEN N'SQL Server 2005'  
				WHEN @productVersion LIKE N'8%' 
							THEN N'SQL Server 2000'  
				WHEN @productVersion LIKE N'7%' 
							THEN N'SQL Server 7.0'  
				WHEN @productVersion LIKE N'6.50%' 
							THEN N'SQL Server 6.5' END)
END