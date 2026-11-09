✈️🐅🐫👍🗼🥇💡🧠🎓🇸🇦✈️🐅🐫👍🗼🥇   💻🎁🎒💣📩🔆🎤🧰️🎭

Q1. Why are views created?

IN-LINE VIEW -  Smply a type of Sub Query ex..common columns would be reperated if its available in both tables
						sql> Select * from 
													(select ename, empno, sal, deptno from emp) a, dept b	
													 where a.deptno = b.DEPARTMENT_ID;

Answer. Views are created for:
• Storing complicated queries in the database so that they are not to be re-written every time they are required.
• Hide the complicated logics on joins from the users.
• Hide the sensitive data from the users by limiting their view to limited fields mentioned in views.
• Make querying the data easy for the users as complicated logics on joins are already embedded in views.

Q2. Difference between View and Materialized View.

Answer.

View								Materialized View
Data is up-to-date				Data is as of time when it was created or last refreshed
Data is not stored				Data is stored in the table
Indexes cannot be applied		Indexes can be applied
No need to refresh				It is refreshed automatically or manually
Only View query is stored in 	View Query along with Table used to store the data snapshot are stored in the meta data tables
the Meta data tables 
& data is not stored	.
Slow in performance				Fast in performance


Q3. What is a force view?

Answer. Creates the view even if the underlying objects required for the view are not existing. It is used by import and other installation tools, to create a view before the underlying objects are created, to not have to figure out what objects are needed to be created in what order to succeed.

Q4. How are materialized views refreshed?

Answer. Materialized view can be refreshed Manually (On Demand) & Automatically (ON COMMIT, DBMS_JOB, DBMS_SCHEDULER).

Use one for the following command to refresh the materialized view manually.

DBMS_MVIEW.REFRESH ==> Refreshes one or more Oracle materialized views
DBMS_MVIEW.REFRESH_ALL_MVIEWS ==> Refreshes all Oracle materialized views
DBMS_MVIEW.REFRESH_DEPENDENT ==> Refreshes all table-based Oracle materialized views

Materialized View can be refreshed automatically by specifying ON COMMIT clause while creating materialized view. 
It can also be refreshed using scheduled jobs created using DBMS_JOBS or DBMS_SCHEDULER.

create table t ( x int primary key, y int );

Table created.

SQL>
SQL> create materialized view mv
  2  as
  3  select * from t;

Materialized view created.

SQL>
SQL> alter table mv add constraint check_y check(y>0);

Table altered.

SQL>
SQL> insert into t values ( 1, 1 );

1 row created.

SQL> commit;

Commit complete.

SQL> exec dbms_mview.refresh( MV, method=>C,atomic_refresh=>true);



SQL> select * from mv;

         X          Y
---------- ----------
         1          1

SQL> insert into t values ( 1, -1 )


--------------------------------------------MV REFRESH----------------------------------------
MATERIALIZED VIEW -> EMP_MV

EXEC DBMS_MVIEW.REFRESH( 'MV', METHOD=>C,ATOMIC_REFRESH=>TRUE);
EXEC DBMS_MVIEW.REFRESH('EMP_MV','?');			-----> FORCE REFRESH

BEGIN
  DBMS_MVIEW.REFRESH(
      'EMP_MV2',
      method => 'F'
  );
END;
/

BEGIN
  DBMS_SCHEDULER.CREATE_JOB (
    job_name        => 'EMP_MV_REFRESH_JOB',
    job_type        => 'PLSQL_BLOCK',
    job_action      => 'BEGIN DBMS_MVIEW.REFRESH(''EMP_MV'',''C''); END;',
    start_date      => SYSTIMESTAMP,
    repeat_interval => 'FREQ=HOURLY; INTERVAL=6',
    enabled         => TRUE
  );
END;
/

CREATE MATERIALIZED VIEW emp_mv
BUILD IMMEDIATE
REFRESH COMPLETE
START WITH SYSDATE
NEXT SYSDATE + 6/24
AS
SELECT * FROM emp;
--------------------------------------------------------------------------------------------------------------------------------------------

Materialized views in Oracle can be thought of as a way to cache the result of a query by storing its data physically. 
They differ significantly from normal (or logical) views, which do not store data but simply store a query definition 
that is executed every time you reference the view.


DBA_MVIEWS, ALL_MVIEWS, or USER_MVIEWS data dictionary views. DBA_MVIEWS


MATERIALIZED VIEW IN ORACLE
----------------------------
A materialized view is an object that contains the results of a query. Unlike a standard view that is virtual, a materialized view physically stores the data computed by the query. This stored result can then be refreshed periodically (manually, on demand, or automatically) to bring it in sync with the underlying base tables.

Materialized views are particularly useful for improving performance in complex queries, especially those that involve aggregation,  
joins, or large datasets.

Key Features of Materialized Views:

i) Performance Optimization: Since the results are stored physically, queries accessing the materialized view can be much faster.

ii) Periodic Refreshing: Data in a materialized view can be refreshed at scheduled intervals to keep it in sync with the underlying tables.

iii) Snapshot Capabilities: Often used for reporting purposes where real-time data isnt necessary.

iv) Replication Support: Helps distribute data across different locations for better availability and reduced load on the source database.

KEY DIFFERENCES BETWEEN MATERIALIZED VIEWS AND NORMAL VIEWS
------------------------------------------------------------

🥇 DATA STORAGE:

MATERIALIZED VIEW: Stores the result set physically in the database.

NORMAL VIEW: Stores only the SQL query; no data is kept on disk.

🥇 PERFORMANCE:

Materialized View: Can greatly speed up query performance for complex aggregations or joins since the result is precomputed. 
It reduces the need for recalculating summaries or complex joins repeatedly.

NORMAL VIEW: Always runs the underlying query, which might be time-consuming for complicated queries or large datasets.

🥇 DATA FRESHNESS & MAINTENANCE:

MATERIALIZED VIEW: The data is as fresh as its last refresh. You control when to refresh—either periodically or manually. Refresh options include:

COMPLETE REFRESH: Rebuilds the entire materialized view.

FAST REFRESH: Applies incremental changes if supported (requires additional setup such as materialized view logs).

FORCE REFRESH: Attempts a fast refresh and falls back to complete refresh if necessary.

NORMAL VIEW: Always retrieves the latest data, as it directly reflects the current state of the underlying tables.

🥇 USAGE SCENARIO:

MATERIALIZED VIEW:: Ideal for data warehousing, reporting, and dashboards where query performance 
and aggregations on large datasets are critical, and slight data staleness is acceptable.

NORMAL VIEW: Suited for simplifying complex queries and providing a logical abstraction, especially when the data must always be current.

🥇 MAINTENANCE OVERHEAD:

Materialized View: Requires management of refresh strategies; you might need to schedule refresh jobs or manage refresh on demand.

NORMAL VIEW: Has minimal maintenance overhead since it’s simply a stored query.

🥇 ADDITIONAL CONSIDERATIONS
Indexing & Query Optimization: Materialized views can be indexed just like tables. Proper indexes on a materialized view can further 
improve query performance, making them extremely powerful for read-intensive operations.

Replication & Query Rewrite: Oracle’s query optimizer can automatically rewrite queries to use a materialized view instead of accessing base tables, provided certain conditions are met. This query rewrite feature can make maintenance of a large-scale data warehouse more efficient.

Flexibility in Refresh Options: Depending on your application, you might choose:

ON COMMIT Refresh: The materialized view is refreshed every time a transaction on the base table commits (more suitable for smaller or less frequently updated datasets).

ON DEMAND/Periodic Refresh: Ideal for large datasets where refreshing on every commit would be too costly.

MATERIALIZED VIEW REFRESH TYPES:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Summary Table
**************

Refresh Type		Method					Performance				Use	Case
Complete		Drops & recreates data		 Slowest		When major changes occur
Fast			Applies incremental changes	 Fastest		When frequent refreshes are needed
Force	  Tries fast, falls back to complete Variable		When uncertain if fast refresh can be done

Different ways of refreshing materialized views
Refreshing Materialized Views in Oracle ensures that the data remains up to date with the underlying tables. There are several ways to refresh a materialized view, depending on performance needs and hosw frequently the data changes.

🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆
1. 🎓MANUAL REFRESH/COMPLETE REFRESH 
🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆
In case of refreshing any Materialized View having Complete refresh 
when its refreshed its Drop the existing data and repopulates the materialized view with fresh data.
Used immediately after creation of DEFERRED MATERIALIZED VIEW to populate the data within the created empty MAT VIEW

How it works: This method drops all existing data in the materialized view and re-executes the defining query to 
repopulate it from scratch.

🚀USE CASE:
 
Needed when incremental changes cannot be applied efficiently 
(e.g., when the underlying tables have undergone STRUCTURAL CHANGES or MASSIVE UPDATES).

---Structural Changes----

			🎤Schema changes (like adding/removing columns, altering data types) make incremental updates impossible.

			🎤Indexes and constraints may be modified, affecting query execution plans.

			🎤Partitioning changes impact how data is stored and accessed.

			🎤Dependencies on new or removed columns require a full rebuild to maintain consistency.
			
----Massive Updates------

			🎤When the underlying tables undergo massive updates, a Complete Refresh is necessary for the materialized view because:

			🎤Large-scale data modifications (bulk inserts, updates, or deletes) make incremental updates inefficient.

			🎤Fast Refresh may not be feasible if the changes affect a significant portion of the dataset.

			🎤Indexes and statistics may need to be rebuilt to optimize query performance.			

A Complete Refresh in a materialized view is used when you need to fully rebuild the view from scratch. This happens in scenarios where:

🔹 The materialized view does not support Fast Refresh due to complex joins, aggregations, or lack of materialized view logs.

🔹 The underlying data has changed significantly, making incremental updates inefficient.

🔹 You need to ensure consistency by completely replacing outdated data.

🔹 The materialized view is defined with BUILD IMMEDIATE, meaning it is populated upon creation.

🔹 The refresh method is explicitly set to REFRESH COMPLETE ON DEMAND.


🚀PERFORMANCE: Takes longer since it retrieves and stores the entire dataset again.

💡 Example SQL:

🧠 EXEC DBMS_MVIEW.REFRESH(your_materialized_view, C);
You can explicitly refresh the materialized view using the DBMS_MVIEW.REFRESH procedure in SQL.

4. 🎓FAST REFRESH (Incremental Updates)
🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆
Uses incremental changes recorded in a log table, making refreshes quicker.

How it works: Instead of refreshing the entire dataset, it applies only the incremental changes (updates, inserts, deletes) since the last refresh using a Materialized View Log.

USE CASE: Preferred when frequent refreshes are required and changes to the base tables are minimal.

PERFORMANCE: Much faster than a complete refresh because only modified rows are updated.

Example SQL:

EXEC DBMS_MVIEW.REFRESH(your_materialized_view, F);

Uses a Materialized View Log to track changes in the base table.


CREATE MATERIALIZED VIEW LOG ON your_table WITH ROWID;

CREATE MATERIALIZED VIEW your_materialized_view 
REFRESH FAST AS 
SELECT * FROM your_table;

USE CASE:

When only small changes happen to the base table.

More efficient than a full refresh.

🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆
5. 🎓FORCE REFRESH 
🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆
Tries a fast refresh first, and if not possible, does a complete refresh.

How it works: This method attempts a fast refresh first. If the conditions for fast refresh are not met (e.g., materialized view logs are missing), it falls back to a complete refresh.

USE CASE: A flexible option when unsure whether fast refresh can be used.

PERFORMANCE: Depends on whether it performs a fast or complete refresh.

Example SQL:

EXEC DBMS_MVIEW.REFRESH(your_materialized_view, FORCE);


🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆
2. 🎓ON-DEMAND REFRESH
🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆

Materialized views can be refreshed only when needed, rather than automatically on a schedule.

sql
CREATE MATERIALIZED VIEW your_materialized_view 
REFRESH ON DEMAND AS 
SELECT * FROM your_table;

USE CASES:
When real-time updates are not required.
Avoid heavy refresh operations during peak hours.
Refresh during off-peak / night batch windows
Data freshness is needed hourly / daily, not instantly
Users don’t require real-time data

Ideal for large tables or complex joins

Can be manually triggered with DBMS_MVIEW.REFRESH(MV NAME)

🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆
3. 🎓SCHEDULED REFRESH (Auto Refresh)
🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆

You can configure automatic refresh using NEXT or START WITH clauses.
sql
CREATE MATERIALIZED VIEW your_materialized_view 
REFRESH COMPLETE START WITH SYSDATE 
NEXT SYSDATE + 1; -- Refreshes once per day

USE CASES:
Ideal for reporting purposes where data updates periodically.

Reduces manual intervention.

🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆

-----------------------------------------------------------------------------------------------------------------------------

Use cases:
When unsure whether fast refresh conditions are met.
Provides flexibility between performance and accuracy.
Would you like help setting up a Materialized View Log for fast refresh? I can provide additional SQL examples!

How do these refresh methods affect database performance?
Great question! The refresh method chosen for a Materialized View has a significant impact on database performance, influencing CPU usage, disk I/O, memory consumption, and overall responsiveness. Here’s how each method affects the system:

1. Complete Refresh
****Used immediately after creation of DEFERRED Materialized View to populate the data within the created empty MAT VIEW**** 
Impact: Heavy CPU & I/O usage as it rebuilds the entire materialized view.
Performance: Slowest method because it retrieves all data from underlying tables.
Best suited for: Scenarios where a full refresh is necessary, such as after major schema changes or large-scale data modifications.

2. Fast Refresh
----------------
Impact: Low resource consumption since only incremental updates are applied.
Performance: Much faster than a complete refresh.
Best suited for: Frequently refreshed views where small changes occur in the underlying tables.

3. Force Refresh
------------------
Impact: Variable, depends on whether fast refresh is possible.
Performance: Can be efficient or expensive, depending on data changes.
Best suited for: General use cases where refresh conditions aren’t guaranteed.

4. On-Demand Refresh
---------------------
Impact: Low system strain since it’s executed only when necessary.
Performance: Controlled by user intervention—avoids unnecessary overhead.
Best suited for: Reports that don’t need frequent updates.

5. Scheduled Refresh
---------------------
Impact: Can strain the system if refreshes occur too frequently or during peak hours.
Performance: Depends on refresh intervals; optimized scheduling reduces impact.
Best suited for: Periodic data updates where refresh timing is important.

Optimizing Performance
✅ Use Fast Refresh whenever possible—it minimizes resource consumption. 
✅ Schedule refreshes during off-peak hours to avoid performance degradation. 
✅ Partition large materialized views to improve efficiency.

Would you like help optimizing your materialized views based on your specific use case? I’d love to assist!

Can you explain when to use each refresh method?What are some best practices for optimizing database performance?What are some alternatives to using materialized views?


ENABLE ON QUERY COMPUTATION 
-----------------------------
means that the materialized view does not store its data physically but instead computes the results dynamically whenever queried. Unlike traditional materialized views that persist their data for faster retrieval, this option ensures the view’s data is always fresh but at the cost of increased computation time.



CREATE MATERIALIZED VIEW MV_EMP_DEP
BUILD IMMEDIATE
REFRESH FAST
ON DEMAND
ENABLE QUERY REWRITE
AS
SELECT E.EMPLOYEE_ID, 
E.FIRST_NAME|| ||E.LAST_NAME AS EMP_NAME,  
E.SALARY,
E.DEPARTMENT_ID,
D.DEPARTMENT_NAME
FROM EMP E, DEPARTMENTS D
WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID;

samahm
noi13579


CREATE TABLE DEP (DEP_ID NUMBER PRIMARY KEY, DEP_NAME VARCHAR2(50));
CREATE TABLE EMP_DEP (EMP_ID NUMBER PRIMARY KEY, DEP_NAME VARCHAR2(50));

CREATE MATERIALIZED VIEW MV_EMP_DEP
BUILD IMMEDIATE
REFRESH COMPLETE
ON DEMAND
AS
SELECT E.EMP_ID, 
D.DEP_ID,
D.DEP_NAME
FROM EMP_DEP E, DEP D
WHERE E.DEP_NAME = D.DEP_NAME;

CREATE MATERIALIZED VIEW LOG ON DEP
WITH ROWID, PRIMARY KEY, SEQUENCE
INCLUDING NEW VALUES;

CREATE MATERIALIZED VIEW LOG ON EMP_DEP
WITH ROWID, PRIMARY KEY, SEQUENCE
INCLUDING NEW VALUES;

ALTER TABLE EMP_DEP ADD CONSTRAINT UK_DEP_NAME UNIQUE(DEP_NAME);
ALTER TABLE DEP ADD CONSTRAINT UK_DEP_NAME1 UNIQUE(DEP_NAME);


DROP MATERIALIZED VIEW LOG ON EMP;

INSERT INTO DEPARTMENTS VALUES (402,TEST,1111,560);
CREATE TABLE DEPT AS SELECT * FROM DEPARTMENTS;
SELECT * FROM DEPARTMENTS;

UPDATE DEPARTMENTS SET DEPARTMENT_NAME=Administration WHERE DEPARTMENT_ID=10;

SELECT * FROM MLOG$_DEPARTMENTS;

SELECT * FROM ALL_CONSTRAINTS WHERE TABLE_NAME IN (EMP,DEPARTMENTS);

DROP MATERIALIZED VIEW MV_EMP_DEP;

CREATE MATERIALIZED VIEW MV_EMP1
BUILD IMMEDIATE
REFRESH FAST
ON DEMAND
AS
SELECT EMPLOYEE_ID, FIRST_NAME|| ||LAST_NAME EMP_NAME
FROM EMP;


CREATE MATERIALIZED VIEW LOG ON EMP
WITH ROWID, PRIMARY KEY;--, SEQUENCE
--INCLUDING NEW VALUES;

CREATE MATERIALIZED VIEW LOG ON DEPARTMENTS
WITH ROWID;

DROP MATERIALIZED VIEW MV_EMP1;

DROP MATERIALIZED VIEW LOG ON DEPARTMENTS;MV_EMP1;

   CREATE MATERIALIZED VIEW LOG ON EMP WITH ROWID INCLUDING NEW VALUES;
    CREATE MATERIALIZED VIEW LOG ON DEPARTMENTS WITH ROWID INCLUDING NEW VALUES;


****************************************************************************************************************


CREATE MATERIALIZED VIEW MV_EMP_DEP1
REFRESH FAST ON COMMIT
ON DEMAND
WITH PRIMARY KEY
AS
SELECT E.EMPLOYEE_ID WITH ROWID, 
E.FIRST_NAME|| ||E.LAST_NAME AS EMP_NAME,  
E.SALARY,
E.EMAIL,
E.PHONE_NUMBER,
E.HIRE_DATE,
E.JOB_ID,
E.COMMISSION_PCT,
E.MANAGER_ID,
D.DEPARTMENT_ID,
D.DEPARTMENT_NAME,
D.LOCATIONS_ID
FROM EMP E, DEPARTMENTS D
WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID;

SELECT * FROM DEPARTMENTS;
SELECT * FROM EMP;
ALTER TABLE EMP READ WRITE;




CREATE TABLE foo(foo NUMBER, CONSTRAINT foo_pk PRIMARY KEY(foo));

CREATE MATERIALIZED VIEW LOG ON foo WITH ROWID;

CREATE TABLE bar(foo NUMBER, bar NUMBER, CONSTRAINT bar_pk PRIMARY KEY(foo, bar));

CREATE MATERIALIZED VIEW LOG ON bar WITH ROWID;

CREATE MATERIALIZED VIEW foo_bar
  NOLOGGING
  CACHE
  BUILD IMMEDIATE
  REFRESH FAST ON COMMIT  AS SELECT foo.foo, 
                                    bar.bar, 
                                    foo.ROWID AS foo_rowid, 
                                    bar.ROWID AS bar_rowid 
                               FROM foo, bar
                              WHERE foo.foo = bar.foo;
                              
                              
CREATE MATERIALIZED VIEW MV_TEST
  NOLOGGING
  CACHE
  BUILD IMMEDIATE
  REFRESH FAST ON COMMIT  AS SELECT EMP.EMPLOYEE_ID, 
                                    DEPARTMENTS.DEPARTMENT_ID, 
                                    EMP.ROWID AS foo_rowid, 
                                    DEPARTMENTS.ROWID AS bar_rowid 
                               FROM EMP, DEPARTMENTS
                              WHERE EMP.DEPARTMENT_ID = DEPARTMENTS.DEPARTMENT_ID;   
                              
CREATE MATERIALIZED VIEW MV_TEST2
  NOLOGGING
  CACHE
  BUILD IMMEDIATE
  REFRESH FAST ON COMMIT  AS SELECT EMP.EMPLOYEE_ID, 
									EMP.FIRST_NAME, 
									EMP.LAST_NAME, 
                                    DEPARTMENTS.DEPARTMENT_NAME, DEPARTMENTS.LOCATION_ID, 
                                    EMP.ROWID AS EMP_ID, 
                                    DEPARTMENTS.ROWID AS DEP_ID 
                               FROM EMP, DEPARTMENTS
                              WHERE EMP.DEPARTMENT_ID = DEPARTMENTS.DEPARTMENT_ID; 
							  
https://copilot.microsoft.com/shares/MmQWRYyZtqSDfqtdRYKD7							  


-----------------------------------------19-DEC---------------------------------------


--STORED DATA THAT NEEDS TO BE REFRESHED IF WANTS TO GET LATEST DATA. FOR DOING FAST & FORCE REFRESH MATERIALIZED LOG VIEW IS NEEDED.
--CREATE MATERIALIZED VIEW LOG ON EMPP WITH ROWID;


CREATE MATERIALIZED VIEW MV_EMPP_DEP
BUILD IMMEDIATE
REFRESH FORCE
ON DEMAND
AS
SELECT E.ID, E.NAME, E.SAL, E.M_ID
FROM EMPP E
WHERE  E.D_ID in (20,30,40);

SELECT * FROM MV_EMPP_DEP;

UPDATE EMPP SET SAL=3000 WHERE ID=117;       --2900
EXEC DBMS_MVIEW.REFRESH(MV_EMPP_DEP, COMPLETE);

SELECT * FROM EMPP;

UPDATE MV_EMPP_DEP SET SAL=2900 WHERE ID=117;  


---------------------------------------------------------
/
DROP MATERIALIZED VIEW MV_EMPp_DEP;
/
CREATE  MATERIALIZED VIEW MV_EMP_DEP
BUILD IMMEDIATE
REFRESH FORCE
ON DEMAND
--ENABLE QUERY REWRITE
--USING DEFAULT LOCAL ROLLBACK SEGMENT
  --USING ENFORCED CONSTRAINTS 
  --ENABLE ON QUERY COMPUTATION 
AS
SELECT E.ID, 
D.DEPARTMENT_ID,
D.DEPARTMENT_NAME
FROM EMPP E, DEPARTMENTS D
WHERE E.D_ID = D.DEPARTMENT_ID
AND D.LOCATION_ID IN (1700,1400,1500);
/

CREATE MATERIALIZED VIEW LOG ON EMPP WITH ROWID;

SELECT * FROM MV_EMP_DEP;

UPDATE DEPARTMENTS SET DEPARTMENT_NAME=Finance WHERE DEPARTMENT_ID=100;
EXEC DBMS_MVIEW.REFRESH(MV_EMP_DEP, COMPLETE);

UPDATE MV_EMP_DEP SET DEPARTMENT_NAME=Fina WHERE DEPARTMENT_ID=100;

SELECT * FROM DBA_MVIEWS;
SELECT * FROM ALL_MVIEWS;
SELECT * FROM USER_MVIEWS;


