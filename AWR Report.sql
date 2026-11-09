

----VIMP-------
-------https://oracle-base.com/dba/scripts
QUERIES TO EXCUTE FOR GETTING RECORDS.....
ACTIVE_SESSIONS/OBJJECT LOCK, ETC....

• Snapshots – DBA_HIST_SNAPSHOT
• Tracks Snapshots in the AWR

• Time Model – v$sys_time_model => dba_hist_sys_time_model
– DB Time
– Automatic Tracking of Operation Times
• Overall parse time (hard, soft, failed,..)
• SQL, PLSQL and Java overall execution times

• Wait Model – v$system_event => dba_hist_system_event
– Wait Events Categorized Based On Solution Area
– More than 900 different wait events. 12 wait classes (Application, Concurrency)

• SQL statement statistics – v$sqlstats => dba_hist_sqlstat
– Resource Usage: Executions, Physical Reads, Physical Writes
– Efficient Top SQL identification using deltas in the kernel

• OS Stats – v$osstat => dba_hist_osstat
– CPU + Memory



-------------------------------------------



In Oracle databases, the buffer cache and shared pool are both parts of the System Global Area (SGA), a memory region used by the database instance to store frequently accessed data and information. The buffer cache stores copies of database blocks read from data files, while the shared pool caches various program data, including SQL statements and PL/SQL blocks. 

BUFFER CACHE:
-------------
Purpose: The primary function of the buffer cache is to minimize physical disk I/O by storing copies of data blocks in memory.

Mechanism: When Oracle needs to access a data block, it first checks if its already in the buffer cache. If it is, the data is 				retrieved from memory instead of reading from disk. 

Buffer Pools: The buffer cache is divided into buffer pools (e.g., KEEP, DEFAULT, RECYCLE) to manage different types of data 				blocks. 

Example: When you run a SQL query, the data returned by the query is first stored in the buffer cache. 

Tuning: You can tune the buffer cache by adjusting the size of each buffer pool and the LRU replacement algorithm. 


SHARED POOL:
-------------
Purpose:
The shared pool caches various types of data, including SQL statements, PL/SQL blocks, and data dictionary information. 

Mechanism: When a SQL statement is parsed for the first time, the database stores the executable version of the statement in 			the shared pool. Subsequent executions of the same statement can reuse the cached version, reducing parse time and 				resource usage. 

Components: The shared pool includes the library cache, dictionary cache, and result cache. 
Example:
		If you run the same SQL query multiple times, the database will retrieve the executable version from the shared pool rather than re-parsing the statement. 

Tuning: You can tune the shared pool by adjusting its size, and by optimizing SQL statements and PL/SQL code to reduce the 			amount of time spent in the shared pool. 


REDO LOG BUFFER 
---------------
The Oracle redo log buffer is a crucial part of the System Global Area (SGA) that stores information about changes made to the database. These changes, called redo entries, are necessary for recovering the database to a consistent state after a crash or failure. The Log Writer (LGWR) process writes these redo entries from the buffer to the online redo log files on disk, ensuring that changes are permanently stored. 

Heres a more detailed explanation:

Purpose: The redo log buffer acts as a temporary memory store for redo entries, which contain the details of database 			modifications like INSERT, UPDATE, and DELETE operations. 

SGA Component:	It resides within the System Global Area (SGA), a shared memory region accessible by all database processes. 

Circular Buffer: The redo log buffer is a circular buffer, meaning when its full, new entries overwrite the oldest ones. This 					ensures continuous storage of changes, even when the buffer is full. 

LGWR Process: The Log Writer (LGWR) process manages the writing of redo entries from the buffer to the online redo log files 				on disk. 

Recovery: In case of a database crash or failure, the redo log entries are used to reconstruct lost changes and bring the 			database back to a consistent state. 

Size Configuration: The size of the redo log buffer is determined by the initialization parameter LOG_BUFFER, which can be 						adjusted to optimize performance. Larger buffers can reduce the frequency of writes to disk but require 						more memory.


LOGONS
-------
In the context of an Oracle databases Load Profile, Logons refers to the number of successful database connections established during a given period. A high number of logons can indicate performance issues, especially if coupled with logon storms, which can lead to significant resource contention. Analyzing logon activity helps identify potential bottlenecks in connection management and can guide performance tuning efforts. 

Elaboration:

What are Logons? -> Logons represent the successful establishment of a database connection by a user or application. Each 					logon requires resources to authenticate the user and establish a session. 

Why are they important?
						A large number of logons, especially if they are frequent or clustered, can impact database performance. Establishing a new connection involves overhead, including authentication, process allocation, and resource allocation. 
How to analyze them?
					The Load Profile section of an AWR (Automatic Workload Repository) report provides detailed information about logon activity, including the number of logons, connection management time, and other relevant statistics. 
What to do if there are too many logons?
										If the number of logons is high and negatively impacting performance, investigate the source of the logons. Consider reducing logon frequency by optimizing applications to reuse existing connections or implementing connection pooling. 
Logon Storms:
			A sudden surge in logons (a logon storm) can overwhelm the database and cause significant delays. Monitoring logon activity can help identify and address these issues. 
Time Model Statistics:
						The connection management elapsed time, which can be found in the Time Model statistics section of the AWR report, is a good indicator of the overhead associated with establishing connections. 



----------------------------------------------------------------------------------------------


The document provides several strategies for optimizing SQL statements based on the AWR report analysis. Here are the key approaches:


REDUCE TOTAL ELAPSED TIME: - Optimize SQL statements that appear in the Total Elapsed Time section by addressing excessive 							 CPU usage or wait times. ​Investigate sorting, function usage, or long parse times that may 							contribute to high elapsed time. ​



MINIMIZE TOTAL CPU TIME: - Reduce sorting by using composite indexes that cover sorting requirements. ​
							Use bind variables to reduce parse times and avoid excessive CPU cycles during processing. ​



Optimize Total Buffer Gets:

Address excessive logical I/O (buffer gets) by optimizing SQL to use appropriate indexes. ​
Reduce full table scans and improve indexing strategies. ​
Consider deploying partitioning to improve data access efficiency. ​



Reduce Total Disk Reads:

Minimize physical I/O by optimizing SQL to avoid excessive full table scans. ​
Use indexes and consider partitioning to reduce disk reads. ​
Address high physical reads, especially in OLTP systems, as they can cause performance issues. ​



Review Total Executions:

Investigate SQL statements with high execution counts to determine if they are genuine or caused by loops in SQL code. ​
Check for duplicate executions from jobs or processes. ​



Address Excessive Parse Calls:

Reduce excessive parse calls by using safe bind variables to avoid reparsing. ​
Investigate low parse ratios and high version counts in the AWR report. ​



Optimize Sharable Memory Usage:

Address SQL statements consuming excessive shared pool memory due to large or complex queries. ​
Investigate issues like bind variable mismatches, security mismatches, or overly large SQL statements. ​



Reduce High Version Counts:

Address high version counts caused by unsafe bind variables, multiple identical-schema databases, or Oracle bugs. ​
Optimize coding practices to reduce excessive parsing and recursion. ​



By regularly analyzing the AWR report and identifying SQL statements that appear in multiple sections (e.g., Total Elapsed Time, Total CPU Time, Total Buffer Gets), you can prioritize tuning efforts to improve database performance. ​




https://dev.to/mrcaption49/sqlbulkexceptions-attribute-in-bulk-collect-3f6n

AWR, ASH, ADDM
SAVE EXCEPTION - BULK COLLECT
REGEXP
REFERNETIAL INTEGRITY
UNION, UNION ALL, INTERSECT, MINUS N 

--------------------------ASH--------------


Sampled data captured by ASH can be aggregated based on the dimensions in the data, including the following:

* SQL identifier of a SQL statement
* Object number, file number, and block number
* Wait event identifier and parameters
* Session identifier and session serial number
* Module and action name
* Client identifier of the session
* Service hash identifier
Major ASH report sections are:

Top User Events
Top Background Events
Top Cluster Events
Top Service/Module
Top SQL Command Types
Top Phases of Execution
Top Remote Instances
Top SQL with Top Events



Steps to generate a ASH report (for all active sessions) :
1. Using ashrpt.sql
2. Using Oracle Enterprise Manager (OEM)
3. Using v$active_session_history