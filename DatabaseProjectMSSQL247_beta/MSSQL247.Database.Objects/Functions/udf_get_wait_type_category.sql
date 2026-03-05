CREATE FUNCTION dbo.udf_get_wait_type_category  (@wait_type VARCHAR(155))
RETURNS VARCHAR(155)
AS
BEGIN
    RETURN case when @wait_type = N'SOS_SCHEDULER_YIELD' then N'CPU' 
		when @wait_type = N'THREADPOOL' then 'CPU - Unavailable Worker Threads'
		when @wait_type like N'LCK_%' OR @wait_type = N'LOCK' then N'Lock' 
		when @wait_type like N'LATCH_%' then N'Latch' 
		when @wait_type like N'PAGELATCH_%' then N'Buffer Latch' 
		when @wait_type like N'PAGEIOLATCH_%' then N'Buffer IO' 
		when @wait_type like N'HADR_SYNC_COMMIT' then N'Always On - Secondary Synch' 
		when @wait_type like N'HADR_%' OR @wait_type like N'PWAIT_HADR_%' then N'Always On'
		when @wait_type like N'FFT_%' then N'FileTable'
		when @wait_type like N'RESOURCE_SEMAPHORE_%' OR @wait_type like N'RESOURCE_SEMAPHORE_QUERY_COMPILE' then N'Memory - Compilation'
		when @wait_type in (N'UTIL_PAGE_ALLOC', N'SOS_VIRTUALMEMORY_LOW', N'SOS_RESERVEDMEMBLOCKLIST', N'RESOURCE_SEMAPHORE', N'CMEMTHREAD', N'CMEMPARTITIONED', N'EE_PMOLOCK', N'MEMORY_ALLOCATION_EXT', N'RESERVED_MEMORY_ALLOCATION_EXT', N'MEMORY_GRANT_UPDATE') then N'Memory'
		when @wait_type like N'CLR%' OR @wait_type like N'SQLCLR%' then N'SQL CLR' 
		when @wait_type like N'DBMIRROR%' OR @wait_type = N'MIRROR_SEND_MESSAGE' then N'Mirroring' 
		when @wait_type like N'XACT%' or @wait_type like N'DTC%' or @wait_type like N'TRAN_MARKLATCH_%' or @wait_type like N'MSQL_XACT_%' or @wait_type = N'TRANSACTION_MUTEX' then N'Transaction' 
		when @wait_type like N'PREEMPTIVE_%' then N'External APIs or XPs' 
		when @wait_type like N'BROKER_%' AND @wait_type <> N'BROKER_RECEIVE_WAITFOR' then N'Service Broker' 
		when @wait_type in (N'LOGMGR', N'LOGBUFFER', N'LOGMGR_RESERVE_APPEND', N'LOGMGR_FLUSH', N'LOGMGR_PMM_LOG', N'CHKPT', N'WRITELOG') then N'Transaction Log IO' 
		when @wait_type in (N'ASYNC_NETWORK_IO', N'NET_WAITFOR_PACKET', N'PROXY_NETWORK_IO', N'EXTERNAL_SCRIPT_NETWORK_IO') then N'Network IO' 
		when @wait_type in (N'CXPACKET', N'EXCHANGE', N'CXCONSUMER') then N'CPU - Parallelism'
		when @wait_type in (N'WAITFOR', N'WAIT_FOR_RESULTS', N'BROKER_RECEIVE_WAITFOR') then N'User Wait' 
		when @wait_type in (N'TRACEWRITE', N'SQLTRACE_LOCK', N'SQLTRACE_FILE_BUFFER', N'SQLTRACE_FILE_WRITE_IO_COMPLETION', N'SQLTRACE_FILE_READ_IO_COMPLETION', N'SQLTRACE_PENDING_BUFFER_WRITERS', N'SQLTRACE_SHUTDOWN', N'QUERY_TRACEOUT', N'TRACE_EVTNOTIF') then N'Tracing' 
		when @wait_type like N'FT_%' OR @wait_type in (N'FULLTEXT GATHERER', N'MSSEARCH', N'PWAIT_RESOURCE_SEMAPHORE_FT_PARALLEL_QUERY_SYNC') then N'Full Text Search' 
		when @wait_type in (N'ASYNC_IO_COMPLETION', N'IO_COMPLETION', N'WRITE_COMPLETION', N'IO_QUEUE_LIMIT', N'IO_RETRY') then N'Disk IO' 
		when @wait_type in (N'BACKUPIO', N'BACKUPBUFFER') then 'Backup IO'
		when @wait_type like N'SE_REPL_%' or @wait_type like N'REPL_%'  or @wait_type in (N'REPLICA_WRITES', N'FCB_REPLICA_WRITE', N'FCB_REPLICA_READ', N'PWAIT_HADRSIM') then N'Replication' 
		when @wait_type in (N'LOG_RATE_GOVERNOR', N'POOL_LOG_RATE_GOVERNOR', N'HADR_THROTTLE_LOG_RATE_GOVERNOR', N'INSTANCE_LOG_RATE_GOVERNOR') then N'Log Rate Governor'
		when @wait_type = N'REPLICA_WRITE' then 'Snapshots'
		when @wait_type = N'WAIT_XTP_OFFLINE_CKPT_LOG_IO' OR @wait_type = N'WAIT_XTP_CKPT_CLOSE' then 'In-Memory OLTP Logging'
		when @wait_type like N'QDS%' then N'Query Store'
		when @wait_type like N'XTP%' OR @wait_type like N'WAIT_XTP%' then N'In-Memory OLTP'
		when @wait_type like N'PARALLEL_REDO%' then N'Parallel Redo'
		when @wait_type like N'COLUMNSTORE%' then N'Columnstore'
	else N'Other' end 
END

-- SELECT * FROM sys.dm_os_wait_stats