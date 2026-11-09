SELECT 
    'Session ' || s1.sid || ' (' || s1.username || ') is WAITING' AS session_info,
    'Blocked by Session ' || s2.sid || ' (' || s2.username || ')' AS blocked_by,
    s1.event AS waiting_for,
    s1.seconds_in_wait AS wait_time_sec
FROM v$session s1
LEFT JOIN v$session s2 ON s1.blocking_session = s2.sid
WHERE s1.blocking_session IS NOT NULL;
/

SELECT 
    'Session ' || s1.sid || ' (' || s1.username || ') is WAITING' AS session_info,
    'Blocked by Session ' || s2.sid || ' (' || s2.username || ')' AS blocked_by,
    s1.event AS waiting_for,
    s1.seconds_in_wait AS wait_time_sec,
    s1.sql_id
FROM v$session s1
LEFT JOIN v$session s2 ON s1.blocking_session = s2.sid
WHERE s1.blocking_session IS NOT NULL
ORDER BY s1.seconds_in_wait DESC;


SELECT 
    s1.sid AS waiting_session,
    s1.username AS waiting_user,
    s1.event AS waiting_event,
    s1.seconds_in_wait AS wait_sec,
    s2.sid AS blocking_session,
    s2.username AS blocking_user,
    s2.status AS blocking_status
FROM v$session s1
LEFT JOIN v$session s2 ON s1.blocking_session = s2.sid
WHERE s1.blocking_session IS NOT NULL
ORDER BY s1.seconds_in_wait DESC;


SELECT 
    TO_CHAR(originating_timestamp, 'DD-MON HH24:MI:SS') AS deadlock_time,
    SUBSTR(message_text, 1, 80) AS details
FROM V$DIAG_ALERT_EXT
WHERE message_text LIKE '%deadlock%'
  AND originating_timestamp > SYSDATE - (1/24)
ORDER BY originating_timestamp DESC;



SELECT 
    sid,
    serial#,
    username,
    status,
    blocking_session,
    event,
    seconds_in_wait
FROM v$session
WHERE username IS NOT NULL
ORDER BY seconds_in_wait DESC;



---------------How to Identify Which Session to Kill, Query to See Blocker vs Waiter:----------------------------------------

SELECT 
    s1.sid AS waiting_session,
    s1.serial# AS waiting_serial,
    s1.username AS waiting_user,
    s1.status AS waiting_status,
    s1.event AS waiting_event,
    s1.seconds_in_wait,
    s2.sid AS blocking_session,
    s2.serial# AS blocking_serial,
    s2.username AS blocking_user,
    s2.status AS blocking_status,
    '>>> KILL THIS ONE >>> ALTER SYSTEM KILL SESSION ''' || 
    s2.sid || ',' || s2.serial# || ''' IMMEDIATE;' AS kill_command
FROM v$session s1
JOIN v$session s2 ON s1.blocking_session = s2.sid
WHERE s1.blocking_session IS NOT NULL;



-- See the complete blocking hierarchy
SELECT 
    LPAD(' ', LEVEL * 2) || s.sid || ' - ' || s.username || 
    ' (' || s.status || ')' AS session_tree,
    s.blocking_session,
    s.event,
    s.seconds_in_wait
FROM v$session s
WHERE s.blocking_session IS NOT NULL
   OR s.sid IN (SELECT blocking_session FROM v$session WHERE blocking_session IS NOT NULL)
CONNECT BY PRIOR s.sid = s.blocking_session
START WITH s.blocking_session IS NULL;
/



SELECT 
    'Session ' || s1.sid || ' (' || s1.username || ') is WAITING' AS session_info,
    'Blocked by Session ' || s2.sid || ' (' || s2.username || ')' AS blocked_by,
    s1.event AS waiting_for,
    s1.seconds_in_wait AS wait_time_sec,
    s1.sql_id
FROM v$session s1
LEFT JOIN v$session s2 ON s1.blocking_session = s2.sid
WHERE s1.blocking_session IS NOT NULL
ORDER BY s1.seconds_in_wait DESC;


SELECT 
    E.EMPLOYEE_ID, 
    E.FIRST_NAME  AS EMPLOYEE_NAME, 
    E.SALARY, 
    M.EMPLOYEE_ID AS MANAGER_ID, 
    M.FIRST_NAME AS MANAGER_NAME
FROM 
    EMPLOYEES E 
JOIN 
    EMPLOYEES M 
ON 
    E.MANAGER_ID = M.EMPLOYEE_ID;  -- Changed from E.ID = M.ID to E.MgrID = M.ID

------------------CHECK what THE sessions ARE doing---------------------------
-- See the SQL being executed
SELECT 
    s.sid,
    s.serial#,
    s.username,
    s.status,
    s.blocking_session,
    s.sql_id,
    SUBSTR(q.sql_text, 1, 100) AS current_sql
FROM v$session s
LEFT JOIN v$sql q ON s.sql_id = q.sql_id
WHERE s.sid IN (269,144,23,145)  -- Your session IDs
ORDER BY s.sid;


ALTER SYSTEM KILL SESSION '405,32318' IMMEDIATE;


ALTER SYSTEM KILL SESSION '144,43406' IMMEDIATE;


SELECT 
    b.object_name,
    c.osuser,
    c.username,
    c.sid,
    c.serial#,
    c.status,
    c.logon_time
FROM 
    v$locked_object a, 
    dba_objects b, 
    v$session c
WHERE 
    a.object_id = b.object_id 
    AND a.session_id = c.sid
ORDER BY 
    b.object_name, c.logon_time;
    
    SELECT * FROM v$session
