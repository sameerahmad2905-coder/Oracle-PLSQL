
TKPROF (Trace Kernel Profiler) - Its a prformance diagnostic tool heling developer & DBA to analyze the perfromance of SQL parametrs 
execution during a session.
It results 
CPU TIME
Elapsed Time
Disk/Logical readable
No of rows processed.
Also checks for any wait events.

It is a command-line utility that transforms a cryptic, raw Oracle trace file (.trc) into a clean, human-readable report.

Used for findign

Slow Queries
Optimizing Query.


While an Explain Plan tells you what Oracle plans to do, TKPROF tells you what it actually did.


1. The Three Stages of a Query.

TKPROF breaks down every SQL statement in the trace into the three phases of execution. 
This is where you find your bottlenecks:

PARSE: Check if you have high "Misses in library cache" (hard parsing), which wastes CPU.

EXECUTE: For DML (Insert/Update/Delete), this is where the work happens.

FETCH: For Select statements, this shows the effort to retrieve rows.

Steps to Trace and Analyze SQL Using TKPROF...

1) Identifying the Default Trace file location.
SELECT VALUE FROM V$DIAG_INFO WHERE NAME = 'Default Trace File';

2) ENnable SQL Tracing for Current Sessions.
ALTER SESSION SET sql_trace=TRUE;

3) Our query.
SELECT * FROM EMP WHERE EMPNO=100;

4) Disable SQL Tracing for Current Sessions.
ALTER SESSION SET sql_trace=FALSE;

5) Converting teh Trace file to Readable format using TKPROF.
C:\ORACLE21CEE\diag\rdbms\orcl\orcl\trace\orcl_ora_16968.trc
tkprof orcl_ora_16968.trc output_file.txt explain HR/sameer@orclpdb



1. The Three Stages of a Query
TKPROF breaks down every SQL statement in the trace into the three phases of execution. This is where you find your bottlenecks:

Parse: Check if you have high "Misses in library cache" (hard parsing), which wastes CPU.

Execute: For DML (Insert/Update/Delete), this is where the work happens.

Fetch: For Select statements, this shows the effort to retrieve rows.

2. How to Read the Statistics
In the report, you will see a table for every SQL statement. Here is what the columns actually mean for your tuning:

Column							What it represents												Tuning Tip
Count				Number of times the call was made.				High fetch counts might mean your application "Array Size" is too small.
CPU					Total CPU time used (in seconds).				High CPU during Execute usually means complex calculations or joins.
Elapsed				Total "Clock" time (includes waiting).			If Elapsed is much higher than CPU, your query is waiting for Disk or Locks.
Disk					Physical reads from the hard drive.			High Disk values suggest you need better indexing or more memory.
Query				Logical reads for consistent results.				This is the most common metric for tuning; lower is always better.
Current					Logical reads for current data.					Usually high during Updates/Deletes.
Rows						Number of rows processed.				Compare this to "Query" reads; if you read 1 million blocks for 1 row, you have a problem.


SELECT * FROM V$DIAG_INFO;

ALTER SESSION SET sql_trace=FALSE;

tkprof orcl_ora_16968.trc output_file.txt explain="HR/sameer@orclpdb" sort=fchela,exeela sys=no

C:\ORACLE21CEE\diag\rdbms\orcl\orcl\trace\orcl_ora_16968.trc


High DISK? $\rightarrow$ You are hitting the physical hard drive. Optimize indexes to keep data in the Buffer Cache.

High QUERY? $\rightarrow$ You are reading too many blocks in memory. Check for missing Join conditions or filters.

High PARSE? $\rightarrow$ You arent using Bind Variables. Oracle is re-compiling the query every time it runs.

High ELAPSED but Low CPU/DISK? $\rightarrow$ Check for "Wait Events" (like enq: TX - row lock contention) in the raw trace file or specialized TKPROF sections.