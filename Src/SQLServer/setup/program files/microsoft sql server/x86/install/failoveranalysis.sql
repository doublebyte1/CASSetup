USE master
Go
SET NOCOUNT ON   
Go
SELECT GetDate()
Go
PRINT '----> DBCC TRACESTATUS (-1):'
DBCC TRACESTATUS (-1)
PRINT ''
Go
PRINT '****************************************************************************************'
PRINT 'Basic SPID information for blocking, multi-ECs and etc.'
PRINT ''
PRINT '----> sys.dm_exec_sessions'
PRINT ''
SELECT * FROM sys.dm_exec_sessions
PRINT ''
GO
PRINT '----> sys.dm_exec_requests'
PRINT ''
SELECT * FROM sys.dm_exec_requests
Go
PRINT ''
PRINT '----> sys.dm_exec_connections'
PRINT ''
SELECT * FROM sys.dm_exec_connections
PRINT ''
Go

PRINT '****************************************************************************************'
PRINT 'Core System Information'
PRINT ''
PRINT '----> sys.dm_os_sys_info'
PRINT ''
SELECT * FROM sys.dm_os_sys_info		--	Basic system info like tick count – single row
PRINT ''
Go
PRINT '----> sys.dm_os_schedulers'
PRINT ''
SELECT * FROM sys.dm_os_schedulers	--	Basic scheduler information – limited by # if schedulers
PRINT ''
Go

PRINT '****************************************************************************************'
PRINT 'Core stats'
PRINT ''
PRINT '----> sys.dm_os_wait_stats'
PRINT ''
SELECT * FROM sys.dm_os_wait_stats
PRINT ''
Go
PRINT '----> sys.dm_os_latch_stats'
PRINT ''
SELECT * FROM sys.dm_os_latch_stats --  Identify latch contention
PRINT ''
Go
PRINT '-> sys.dm_os_sublatches'
PRINT ''
SELECT * FROM sys.dm_os_sublatches
PRINT ''
Go

PRINT '****************************************************************************************'
PRINT 'Transaction, io, and other stats'
PRINT ''
PRINT '----> sys.dm_tran_database_transactions'
SELECT db_name(database_id), * FROM sys.dm_tran_database_transactions 
PRINT ''
Go
PRINT '----> sys.dm_tran_active_transactions'
SELECT * FROM sys.dm_tran_active_transactions 
PRINT ''
Go
PRINT '----> sys.dm_io_pending_io_requests'
PRINT ''
SELECT * FROM sys.dm_io_pending_io_requests
PRINT ''
Go
PRINT '----> sys.dm_io_virtual_file_stats'
PRINT ''
SELECT * FROM sys.dm_io_virtual_file_stats(NULL, NULL)
PRINT ''
Go
PRINT '----> dbcc sqlperf(spinlockstats)'
PRINT ''
dbcc sqlperf(spinlockstats)
PRINT ''
Go

PRINT '****************************************************************************************'
PRINT 'CLR information'
PRINT ''
PRINT '----> sys.dm_clr_tasks'
PRINT ''
SELECT t.session_id, c.* FROM sys.dm_clr_tasks  c inner join sys.dm_os_tasks t on c.sos_task_address = t.task_address
-- Capture forced_yield_count to check if CLR was not yielding
PRINT ''
Go

PRINT '****************************************************************************************'
PRINT 'Memory Information'
PRINT ''
PRINT '----> sys.dm_os_memory_pools'
SELECT * FROM sys.dm_os_memory_pools
PRINT ''
Go
PRINT '----> sys.dm_os_memory_clerks'
SELECT * FROM sys.dm_os_memory_clerks
PRINT ''
Go
PRINT '----> sys.dm_db_session_space_usage'
SELECT * FROM sys.dm_db_session_space_usage
PRINT ''
Go
PRINT '----> sys.dm_db_task_space_usage'
SELECT * FROM sys.dm_db_task_space_usage
PRINT ''
Go

PRINT '****************************************************************************************'
--Query stats
PRINT '----> Stats for currently running queries'
PRINT ''
SELECT 
    r.*, 
    t.dbid, 
    t.objectid, 
    t.encrypted,
    substring(t.text, statement_start_offset / 2, (case when statement_end_offset = -1 then datalength(t.text) else statement_end_offset end - statement_start_offset) / 2) as query_text
FROM sys.dm_exec_requests as r outer apply sys.dm_exec_sql_text(r.sql_handle) as t
PRINT ''
Go

PRINT '****************************************************************************************'
PRINT 'Ring buffers and waiting tasks'
PRINT ''
PRINT '----> sys.dm_os_ring_buffers'
PRINT ''
SELECT * FROM sys.dm_os_ring_buffers	--	Basics about recient exceptions and such, always limited in size by ring buffer size  
PRINT ''
Go
PRINT '----> sys.dm_os_waiting_tasks top 1000 ORDER BY wait_duration_ms DESC'
PRINT ''
SELECT TOP 1000 * FROM sys.dm_os_waiting_tasks ORDER BY wait_duration_ms DESC  --  Tasks in a wait state    
PRINT ''
Go
PRINT '----> sys.dm_os_workers'
PRINT ''
SELECT * FROM sys.dm_os_workers     --  Gets status of each worker, limited by the number of workers
PRINT ''
Go

PRINT '****************************************************************************************'
PRINT 'sql counters information'
PRINT ''
PRINT '----> sys.dm_os_performance_counters'
PRINT ''
SELECT * FROM sys.dm_os_performance_counters
PRINT ''
Go

PRINT '****************************************************************************************'
PRINT 'Traces, Good for tracking down commands just submitted'
PRINT ''
PRINT '----> sys.traces'
PRINT ''
SELECT * FROM sys.traces
PRINT ''
Go

PRINT '****************************************************************************************'
PRINT 'Could need loader lock – do last, if does not run can get list FROM any mini-dump if needed'
PRINT ''
PRINT '----> sys.dm_os_loaded_modules'
PRINT ''
SELECT * FROM sys.dm_os_loaded_modules	
PRINT ''
Go

PRINT '****************************************************************************************'
PRINT 'Thread/worker information'
PRINT ''
PRINT '----> sys.dm_os_threads'
PRINT ''
SELECT * FROM sys.dm_os_threads		--	Like listing of basic thread info in debugger, match thread id to KPID type things –makes GetThreadTimes calls
PRINT ''
Go
SELECT GetDate()
Go



