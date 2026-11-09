🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆

In Oracle, “gather stats” (or “gathering optimizer statistics”) means collecting detailed information about database objects (like tables, indexes, columns, partitions, and the system itself) so the query optimizer can estimate how much data there is and how it’s distributed, and then choose the most efficient execution plan for SQL queries

“Gather stats” is the process of using the DBMS_STATS package (or automatic jobs) to:
Collect optimizer statistics on:
Tables (number of rows, blocks, average row length)
Columns (distinct values, nulls, data distribution/histograms)
Indexes (leaf blocks, levels, clustering factor)
Partitions and subpartitions
System (I/O and CPU performance characteristics)
Store these statistics in the data dictionary
Enable the cost-based optimizer to calculate costs of different execution plans and pick the lowest-cost plan for each SQL statemen

GATHERING STATS simply means:
Updating the databases map so it knows how much data is actually there, so it can stop guessing and start taking the fastest route.

1. Without Gathering Stats (The Blind Approach)
2. With Gathering Stats (The Informed Approach)
3. What happens if you dont do it often? (The Old Map Problem)

DBMS_STATS.GATHER_TABLE_STATS - is used to COLLECT OPTIMIZER STATISTICS for a table, 
								so that the Oracle Cost-Based Optimizer (CBO) can choose 
								the most efficient execution plan for SQL queries.
								
GATHER_TABLE_STATS - is a procedure of the DBMS_STATS package used to collect optimizer statistics for a 
										table (and optionally its indexes).					  
					👉 It updates Oracle with accurate information about a tables data, so SQL queries run efficiently.					
					🔹 Why It Is Needed
							 Oracle’s Cost-Based Optimizer (CBO) relies on statistics to decide:
								🔆 Full table scan vs index scan
								🔆 Join order and join method
								🔆 Which index is most efficient
								🔆 Without updated stats → slow or wrong execution plans.								
🔹 Key Interview Line (Remember This)

DBMS_STATS.GATHER_TABLE_STATS collects table, column, and index statistics required by the Oracle Cost-Based Optimizer to generate optimal execution plans.

BEGIN
	DBMS_STATS.GATHER_TABLE_STATS (null, EMP, no_invalidate => false, cascade => TRUE);  --> cascade => TRUE --> Gathers Index stat also
	DBMS_STATS.GATHER_TABLE_STATS (null, DEPT, no_invalidate => false);
END;
/
----TO CHECK FOR THE LATEST UPDATE/STATS BEEN MADE ON ANY TABLE...

SELECT
  owner,
  table_name,
  last_analyzed,
  stale_stats,
  num_rows,
  sample_size
FROM dba_tab_statistics
WHERE owner = 'HR'
  AND object_type = 'TABLE'
ORDER BY last_analyzed desc;

BEGIN																--Estimate_percent Percentage of table rows sampled Controls accuracy vs performance Recommended: AUTO_SAMPLE_SIZE
  DBMS_STATS.GATHER_TABLE_STATS(							--estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE Options:
    'HR',																				--100 → Full scan (very accurate, slower), 10 → Sample 10% of rows
    'EMPLOYEES',																--- AUTO_SAMPLE_SIZE → Oracle chooses automatically (best practice)
    estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE
  );
END;
/

BEGIN
  DBMS_STATS.GATHER_TABLE_STATS(
    ownname          => HR,
    tabname          => EMPLOYEES,
    estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE,
    method_opt       => FOR ALL COLUMNS SIZE AUTO,
    cascade          => TRUE
  );
END;
/

Examples..

1 Table Statistics
👉 Use when only one table’s data changes.
EXEC DBMS_STATS.GATHER_TABLE_STATS(HR,EMPLOYEES);

2 Index Statistics
👉 Use when indexes are rebuilt or behaving poorly, You rebuilt an index after deletes. 
	➡ Gather index stats so Oracle chooses it correctly.
EXEC DBMS_STATS.GATHER_INDEX_STATS(HR,EMP_NAME_IDX);
EXEC DBMS_STATS.GATHER_INDEX_STATS(ownname => SCOTT,indname => EMP_ENAME_IDX);

Most commmon & recommended, 
EXEC DBMS_STATS.GATHER_TABLE_STATS(ownname => SCOTT,tabname => EMP,cascade => TRUE);
✔ Table stats + all indexes on EMP
✔ One command, safer


3 Schema Statistics
👉 Use after big ETL or deployment. You refreshed all HR tables overnight. 
	➡ Gather schema stats once instead of table-by-table.
EXEC DBMS_STATS.GATHER_SCHEMA_STATS(HR);

4 Database Statistics
👉 Use in data warehouse systems after full refresh. Monthly full data reload of the DB. 
	➡ Gather database stats for global optimization.
EXEC DBMS_STATS.GATHER_DATABASE_STATS;

5 Partition Statistics
👉 Use when only one partition changes. Stats for one partition only. 
	➡ No need to scan other months.
EXEC DBMS_STATS.GATHER_TABLE_STATS( HR,SALES,  partname => SALES_2025_JAN);
🧠 Example:
January sales data loaded.


6 Global Statistics (Partitioned Tables)
👉 Overall stats across all partitions. Queries ask for total yearly sales. 
	➡ Oracle needs global stats.
EXEC DBMS_STATS.GATHER_TABLE_STATS(HR,SALES, granularity => GLOBAL);

granularity => 'GLOBAL' in DBMS_STATS means “gather statistics only for the table as a whole (global statistics), and do not gather separate partition or subpartition statistics.”

7 Incremental Statistics
👉 Daily sales partition added. Only changed partitions are scanned 
	➡ Oracle updates stats quickly without scanning old data.
ALTER TABLE SALES SET (INCREMENTAL = TRUE);
EXEC DBMS_STATS.GATHER_TABLE_STATS(HR,SALES);

8 Stale Statistics Only
👉 Gather stats only if data changed. Only 2 tables changed today. 
	➡ Oracle ignores unchanged tables.
EXEC DBMS_STATS.GATHER_SCHEMA_STATS(HR,options => GATHER STALE);

9 Automatic Statistics (Oracle Job)
👉 Runs during maintenance window. Oracle gathers stats automatically. Night-time auto job updates stats. ➡ No manual effort needed (most OLTP systems).


🔟 Fixed Object Statistics
Stats for Oracle internal tables. Performance issue after DB restart. 
	➡ Helps optimizer choose better internal plans.
EXEC DBMS_STATS.GATHER_FIXED_OBJECTS_STATS;

📌 DBMS_STATS.GATHER_TABLE_STATS – Definition & Detailed Explanation

1 ownname
Schema that owns the table
Mandatory parameter
	ownname => HR


2 tabname
Table name for which statistics are collected
Mandatory
	tabname => EMPLOYEES

3 estimate_percent
Percentage of table rows sampled
Controls accuracy vs performance
Recommended: AUTO_SAMPLE_SIZE
	estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE
Options:
100 → Full scan (very accurate, slower)
10 → Sample 10% of rows
AUTO_SAMPLE_SIZE → Oracle chooses automatically (best practice)


4 method_opt
Controls column statistics & histograms
method_opt => FOR ALL COLUMNS SIZE AUTO


5 cascade
Whether to gather index statistics also
cascade => TRUE
Value	Meaning
TRUE	Gathers index stats
FALSE	Only table stats

6 granularity
Used for partitioned tables
granularity => ALL
Value			Description
GLOBAL			Global stats only
PARTITION		Partition-level stats
SUBPARTITION	Subpartition stats
ALL				All levels

7 degree
Degree of parallelism
degree => 4
Value	Meaning
NULL	Default
n		Parallel execution


8 no_invalidate
Controls cursor invalidation
no_invalidate => FALSE
Value	Meaning
FALSE	Existing SQL cursors invalidated
TRUE	Keeps old execution plans


9 force
Forces stats collection even if locked
force => TRUE



🔍 Easy Comparison Table
Type						Example Use
Table						One table updated
Index						Index rebuilt
Schema						Full schema refresh
Database					Full DB load
Partition					One month’s data
Global						Yearly totals
Incremental					Huge partitioned tables
Stale						Reduce workload
Automatic					Default Oracle behavior
Fixed						Oracle internals


