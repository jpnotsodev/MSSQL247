CREATE PROCEDURE [dbo].[usp_mssql247_collect_blocked_query_stats]
AS
  INSERT  INTO  MSSQL247_beta.dbo.mssql247_blocked_query_stats
	(session_id, status, start_time, host_name, 
	client_interface_name, login_name, nt_domain, 
	nt_user_name, cpu_time, memory_usage, command,
	sql_text, database_name, wait_type, wait_time,
	last_wait_type, open_transaction_count, transaction_id,
	blocking_session_id, program_name, local_net_address,
	client_net_address )
	SELECT req.session_id, req.status, req.start_time,
		ses.host_name, ses.client_interface_name, ses.login_name,
		ses.nt_domain, ses.nt_user_name, ses.cpu_time, ses.memory_usage, 
		req.command, SUBSTRING(txt.text, (statement_start_offset / 2 + 1), 
						CASE WHEN statement_end_offset = -1 THEN LEN(txt.text) 
						ELSE statement_end_offset/2 END) sql_text, DB_NAME(req.database_id) database_name, 
		req.wait_type, req.wait_time, req.last_wait_type, req.open_transaction_count, 
		req.transaction_id, req.blocking_session_id, ses.program_name, 
		con.local_net_address, con.client_net_address
	FROM sys.dm_exec_requests req
	INNER JOIN sys.dm_exec_sessions ses
	ON req.session_id = ses.session_id
	LEFT JOIN sys.dm_exec_connections con
	ON con.session_id = req.session_id
	CROSS APPLY sys.dm_exec_sql_text (req.sql_handle) txt
	WHERE blocking_session_id <> 0
	AND NOT EXISTS (SELECT * FROM MSSQL247_beta.dbo.mssql247_blocked_query_stats 
					WHERE session_id = req.session_id
					AND blocking_session_id = req.blocking_session_id
					AND start_time = req.start_time )

	UPDATE MSSQL247_beta.dbo.mssql247_blocked_query_stats
	SET blocked_query_status = 0
	WHERE CONVERT(VARCHAR(20), session_id) + ',' + CONVERT(VARCHAR(20), blocking_session_id) 
		NOT IN (SELECT CONVERT(VARCHAR(20), session_id) + ',' + CONVERT(VARCHAR(20), blocking_session_id)
						FROM sys.dm_exec_requests
						WHERE blocking_session_id <> 0)
RETURN 0
