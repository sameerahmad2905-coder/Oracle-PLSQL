


✅ DBA_HIST*
Any job running in back ground can be checked using DBA_HIST* Dictionary views.
From these views onlky teh AWR report is generated
from several tables here we an get the SQL_ID using which we can teh SQL query taking time.

SELECT * FROM DBA_HIST_SNAPSHOT;

SELECT * FROM DBA_HIST_SQLSTAT;

SELECT 
    s.sql_id,
    SUM(s.cpu_time_delta)/1000000 AS total_cpu_seconds,
    SUM(s.executions_delta) AS total_executions
FROM 
    dba_hist_sqlstat s
JOIN 
    dba_hist_snapshot sn ON s.snap_id = sn.snap_id
WHERE 
    sn.end_interval_time BETWEEN SYSDATE-1 AND SYSDATE
GROUP BY 
    s.sql_id
ORDER BY 
    total_cpu_seconds DESC;

SQL_ID				TOTAL_CPU_SECONDS	TOTAL_EXECUTIONS
b39m8n96gxk7c	100.87202						34
ampw9ddqufjd3	100.723729					34
c61ajdcqbqn42	93.813852	                   34
7hnc5ucz8grnt		83.701925						34
fn0stp00nzmj6	63.31714						34
05s9358mm6vrr	33.951252						1
b6usrg82hwsa3	24.286478						1
ggh55rhz95kyj	13.050359						1
5sf7xj9w1zhuv	9.381559						1
fzg2hjtqudy86	   7.262893							75



SELECT *
FROM v$sqltext
WHERE sql_id = 'b39m8n96gxk7c'  -- Replace with your ID
ORDER BY piece;

ADDRESS				      SQL_ID				HASH_VALUE	CMD_TYPE		PIECE			SQL_TEXT												CON_ID
00007FFF2333F7F0	b39m8n96gxk7c	1291765996			170				0	call dbms_autotask_prvt.run_autotask ( :0,:1 )	  3

SELECT *
FROM dba_hist_sqltext
WHERE sql_id = 'b39m8n96gxk7c';

Why use DBA_HIST_ACTIVE_SESS_HISTORY?
DBA_HIST_SQLTEXT: Only stores the text of the query. It does not store who ran it or when.
DBA_HIST_SQLSTAT: Stores aggregate performance stats (total executions, total time), but not the specific timestamp of every single execution.
DBA_HIST_ACTIVE_SESS_HISTORY: Stores a sample of active sessions every 10 seconds. It connects the SQL ID to the User ID and the Timestamp. This is the only place to fulfill your specific request.

-------------------------------------------------------------------------------------------------------------------
 
 https://docs.oracle.com/en/database/oracle/oracle-database/19/refrn/V-LOCK_TYPE.html#GUID-2DCB0E6F-0BA7-4E15-A52B-F8AFB8DF5F90 
 
ABOVE LINK HAVING ALL THE DYNAMIC PERFORMANCE VIEWS USED IN ERORMANCE TUNING

v$session_longops - SHOWS THE LONG RUNNING OPERATIONS;

V$SESSION - displays session information for each current session. 

V$SESSION_WAIT - displays the current or last wait for each session.

V$SQL - lists statistics on shared SQL areas without the GROUP BY clause and contains one row for each child 
of the original SQL text entered. Statistics displayed in V$SQL are normally updated at the end of query execution. 
However, for long running queries, they are updated every 5 seconds. 
This makes it easy to see the impact of long running SQL statements while they are still in progress.

V$SQL_CURSOR - displays debugging information for each cursor associated with the session querying this view.

V$LOCK_TYPE - describes the type of locks available.
V$LOCK - lists the locks currently held by the Oracle Database and outstanding requests for a lock or latch.
			Col Type in the table denotes th etype of operation causing lock ex TM - DML , TX - Transaction, etc..
			contains both SID & SERIAL# using which can kill the seesioon.

V$LOCKED_OBJECT - lists all locks acquired by every transaction on the system. 
It shows which sessions are holding DML locks (that is, TM-type enqueues) on what objects and in what mode.

V$SQL_MONITOR - displays SQL statements whose execution have been (or are being) monitored by Oracle.

V$LOG - displays log file information from the control file.
 
  SELECT
  OBJECT_NAME, 
  OBJECT_TYPE, 
  SESSION_ID, 
  TYPE,         -- TYPE OR SYSTEM/USER LOCK
  LMODE,        -- LOCK MODE IN WHICH SESSION HOLDS LOCK
  REQUEST, 
  BLOCK, 
  CTIME         -- TIME SINCE CURRENT MODE WAS GRANTED
FROM
  V$LOCKED_OBJECT, ALL_OBJECTS, V$LOCK
WHERE
  V$LOCKED_OBJECT.OBJECT_ID = ALL_OBJECTS.OBJECT_ID AND
  V$LOCK.ID1 = ALL_OBJECTS.OBJECT_ID AND
  V$LOCK.SID = V$LOCKED_OBJECT.SESSION_ID
ORDER BY
  SESSION_ID, CTIME DESC, OBJECT_NAME;
  
  ---------------------------------------------------------------------------------------------



This view contains global, high-level information about simple and composite database operations.
Oracle Database monitors simple database operations, which are top SQL statements and PL/SQL subprograms, 
when any of the following conditions is true:

The operations run in parallel.
The operations have consumed at least 5 seconds of CPU or I/O time in a single execution.
Tracking for the operations is forced by the /*+ MONITOR */ hint.
For simple database operations, monitoring statistics are not cumulative over several executions. 
In this case, one entry in V$SQL_MONITOR is dedicated to a single execution of a SQL statement. 
If the database monitors two executions of the same SQL statement, then each execution has a 
separate entry in V$SQL_MONITOR.

For simple database operations, V$SQL_MONITOR has one entry for the parallel execution coordinator process 
and one entry for each parallel execution server process. Each entry has corresponding entries in V$SQL_PLAN_MONITOR. 
Because the processes allocated for the parallel execution of a SQL statement are cooperating for the same execution, 
these entries share the same execution key (the combination of SQL_ID, SQL_EXEC_START, and SQL_EXEC_ID).

Oracle Database monitors composite database operations when either of the following conditions is true:

A database operation was started with DBMS_SQL_MONITOR.BEGIN_OPERATION and the operation has consumed at least 5 seconds 
of CPU or I/O time.
Tracking for the operation is forced by setting FORCE_TRACKING to Y in DBMS_SQL_MONITOR.BEGIN_OPERATION.

For composite database operations, each row contains an operation whose statistics are accumulated over the 
SQL statements and PL/SQL subprograms that run in the same session as part of the operation.

The V$SQL_MONITOR view contains a subset of the statistics available in V$SQL. However, unlike V$SQL, 
monitoring statistics are not cumulative over several executions. Instead, one entry in V$SQL_MONITOR is 
dedicated to a single execution of a SQL statement. If the database monitors two executions of the same 
SQL statement, then each execution has a separate entry in V$SQL_MONITOR.

The primary key is the combination of the columns SQL_ID, SQL_EXEC_START, and SQL_EXEC_ID.

V$SQL_MONITOR has one entry for the parallel execution coordinator process, and one entry for each parallel execution server
process. Each entry has corresponding entries in V$SQL_PLAN_MONITOR. Because the processes allocated for the 
parallel execution of a SQL statement are cooperating for the same execution, these entries share the same execution 
key (the composite SQL_ID, SQL_EXEC_START, and SQL_EXEC_ID). You can aggregate the execution key to determine the 
overall statistics for a parallel execution.

When the SQL statement being monitored is executing, statistics in V$SQL_MONITOR are generally refreshed in near 
real time, once every second. Once the execution ends, monitoring information is not deleted immediately. 
Instead, it is kept in V$SQL_MONITOR for at least one minute. The entry will eventually be deleted to reclaim 
its space as new statements are monitored.
 
 
 V$LOCKED_OBJECT, ALL_OBJECTS, V$LOCK			--- 
 



  
  
  
  SELECT * FROM V$SQL_PLAN WHERE HASH_VALUE=3956160932;

EXPLAIN PLAN FOR SELECT /*+ MONITOR */ * FROM EMP WHERE DEPTNO=50;
SET AUTOTRACE ON;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);


EXPLAIN PLAN FOR SELECT /*+ INDEX */ * FROM EMP WHERE JOB_ID=IT_PROG;
SET AUTOTRACE ON;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

SELECT * FROM V$SESSTAT;

SELECT COUNT(*) FROM V$CONTAINERS
  WHERE open_mode != MOUNTED;
  
  
  SELECT VALUE FROM v$parameter WHERE NAME = job_queue_processes;
  ALTER SYSTEM SET JOB_QUEUE_PROCESSES = 2;


select S.USERNAME, s.sid, s.osuser, t.sql_id, sql_text
from v$sqltext_with_newlines t,V$SESSION s
where t.address =s.sql_address
and t.hash_value = s.sql_hash_value
and s.status = ACTIVE
and s.username <> SYSTEM
order by s.sid,t.piece;



select
  object_name, 
  object_type, 
  session_id, 
  type,         -- Type or system/user lock
  lmode,        -- lock mode in which session holds lock
  request, 
  block, 
  ctime         -- Time since current mode was granted
from
  v$locked_object, all_objects, v$lock
where
  v$locked_object.object_id = all_objects.object_id AND
  v$lock.id1 = all_objects.object_id AND
  v$lock.sid = v$locked_object.session_id
order by
  session_id, ctime desc, object_name;
  /




SELECT sid, to_char(start_time,hh24:mi:ss) stime, 
message,( sofar/totalwork)* 100 percent 
FROM v$session_longops
WHERE sofar/totalwork < 1
/

SELECT * FROM V$SQL;
SELECT SQL_ID, SQL_TEXT, ELAPSED_TIME, FIRST_LOAD_TIME, LAST_LOAD_TIME, CPU_TIME, DISK_READS, BUFFER_GETS, EXECUTIONS FROM V$SQL
ORDER BY ELAPSED_TIME DESC;

SELECT * FROM V$SQL_MONITOR;

0

select sq.PARSING_SCHEMA_NAME, sq.LAST_LOAD_TIME, sq.ELAPSED_TIME, sq.ROWS_PROCESSED, ltrim(sq.sql_text), sq.SQL_FULLTEXT
  from v$sql sq, v$session se
 order by sq.ELAPSED_TIME desc, sq.LAST_LOAD_TIME desc;
 
 
 @?/rdbms/admin/awrrpt.sql 
 @?/rdbms/admin/ashrpt.sql;
 
 
 select
  object_name, 
  object_type, 
  session_id, 
  type,         -- Type or system/user lock
  lmode,        -- lock mode in which session holds lock
  request, 
  block, 
  ctime         -- Time since current mode was granted
from
  v$locked_object, all_objects, v$lock
where
  v$locked_object.object_id = all_objects.object_id AND
  v$lock.id1 = all_objects.object_id AND
  v$lock.sid = v$locked_object.session_id
order by
  session_id, ctime desc, object_name
/

SELECT * FROM v$locked_object;
SELECT * FROM all_objects;
SELECT * FROM v$lock;



SELECT * FROM ALL_TRIGGERS WHERE TABLE_NAME=EMP;


SELECT * FROM EMP;
SELECT * FROM EMP_DEP;
DELETE FROM EMP_DEP WHERE EMPNO=301;
DELETE FROM EMP WHERE EMPNO=301;

SELECT * FROM PLAN_TABLE$;

SELECT * FROM EMP_AUDIT;

SELECT * FROM V$SCHEDULER_RUNNING_JOBS;


SELECT * FROM V$SERVICE_WAIT_CLASS;

SELECT * FROM V$SERVICES;

SELECT * FROM V$EVENT_NAME WHERE NAME LIKE %DML%;

SELECT * FROM V$SESSION_WAIT;
SELECT * FROM V$SQL;

SELECT * FROM V$LOCK;

SELECT * FROM V$SQL_CURSOR;

SELECT * FROM V$SQL_MONITOR;

SELECT * FROM V$LOG;


SELECT s.inst_id,
       s.sid,
       s.serial#,
       --s.sql_id,
       p.spid,
       s.username,
       s.program
FROM   gv$session s
       JOIN gv$process p ON p.addr = s.paddr AND p.inst_id = s.inst_id
WHERE  s.type != BACKGROUND;

ALTER SYSTEM KILL SESSION '1139,95' IMMEDIATE;

ALTER SYSTEM KILL SESSION ‘sid,serial#’;



This one shows SQL that is currently ACTIVE:-

select S.USERNAME, s.sid, s.osuser, t.sql_id, sql_text
from v$sqltext_with_newlines t,V$SESSION s
where t.address =s.sql_address
and t.hash_value = s.sql_hash_value
and s.status = ACTIVE
and s.username <> SYSTEM
order by s.sid,t.piece
/
This shows locks. Sometimes things are going slow, but its because it is blocked waiting for a lock:

select
  object_name, 
  object_type, 
  session_id, 
  type,         -- Type or system/user lock
  lmode,        -- lock mode in which session holds lock
  request, 
  block, 
  ctime         -- Time since current mode was granted
from
  v$locked_object, all_objects, v$lock
where
  v$locked_object.object_id = all_objects.object_id AND
  v$lock.id1 = all_objects.object_id AND
  v$lock.sid = v$locked_object.session_id
order by
  session_id, ctime desc, object_name
/


This is a good one for finding long operations (e.g. full table scans). If it is because of lots of short operations, 
nothing will show up.

COLUMN percent FORMAT 999.99 

SELECT sid, to_char(start_time,hh24:mi:ss) stime, 
message,( sofar/totalwork)* 100 percent 
FROM v$session_longops
WHERE sofar/totalwork < 1
/


2

You can check the long-running queries details like % completed and remaining time using the below query:

 SELECT SID, SERIAL#, OPNAME, CONTEXT, SOFAR, 
 TOTALWORK,ROUND(SOFAR/TOTALWORK*100,2) %_COMPLETE 
 FROM V$SESSION_LONGOPS 
 WHERE OPNAME NOT LIKE %aggregate% 
       AND TOTALWORK != 0 
       AND SOFAR <> TOTALWORK;
	   
	   
	   
Try this, it will give you queries currently running for more than 60 seconds. Note that it prints multiple lines per running query if the SQL has multiple lines. Look at the sid,serial# to see what belongs together.

select s.username,s.sid,s.serial#,s.last_call_et/60 mins_running,q.sql_text from v$session s 
join v$sqltext_with_newlines q
on s.sql_address = q.address
 where status=ACTIVE
and type <>BACKGROUND
and last_call_et> 60
order by sid,serial#,q.piece



Find Long Running Transactions:

col sid format 9999999 col serial# for 9999999 column opname format a14 column message format a41 set lines 1000 
set pages 100 

select sid,serial#,sql_id,opname,message,sofar,totalwork,round((sofar/decode(totalwork,0,1,totalwork))*100,2) work_done, 
time_remaining Time_remain,ELAPSED_SECONDS ela_seconds from v$session_longops where sofar<>totalwork ;	


This one returns the most expensive queries, and the SQL which caused them:

SELECT vsl.opname, vsl.target, vsl.totalwork, vsl.units, vsl.elapsed_seconds, vsl.message, vs.sql_text FROM v$session_longops vsl
  JOIN v$sql vs ON vsl.sql_id = vs.sql_id
ORDER BY vsl.elapsed_seconds DESC   


ALTER SESSION SET STATISTICS_LEVEL = ALL;

SET AUTOTRACE ON;


select sql_id, plan_hash_value, child_number, executions, fetches, cpu_time, elapsed_time, physical_read_requests, physical_read_bytes
from v$sql s
where sql_fulltext like SELECT /*+ GATHER_PLAN_STATISTICS */ E.FIRST_NAME, E.LAST_NAME, E.SALARY, D.DEPARTMENT_NAME, L.LOCATION_ID,
L.CITY
FROM EMPLOYEES E,  DEPARTMENTS D, LOCATIONS L
WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID
AND D.LOCATION_ID = L.LOCATION_ID%
  and sql_fulltext not like %from v$sql ;




select sql_id, plan_hash_value, child_number, executions, fetches, cpu_time, elapsed_time, physical_read_requests, physical_read_bytes
from v$sql s
where sql_fulltext like SELECT /*+ GATHER_PLAN_STATISTICS */ E.FIRST_NAME, E.LAST_NAME, E.SALARY, D.DEPARTMENT_NAME, L.LOCATION_ID,
L.CITY
FROM EMPLOYEES E,  DEPARTMENTS D, LOCATIONS L
WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID
AND D.LOCATION_ID = L.LOCATION_ID%
  and sql_fulltext not like %from v$sql ;


