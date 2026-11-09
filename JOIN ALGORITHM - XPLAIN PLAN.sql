JOIN ALGORITHM

https://www.youtube.com/watch?v=ZXnD3Mzy_TM
https://www.youtube.com/watch?v=NkXxRodAFUY
https://www.youtube.com/watch?v=IYWmauKtwXI

HASH/MERGE SORT/NESTED
USING TABLE STATISTICS - 

🥇 NESTED JOIN
-------------

TABLE A (OUTER TABLE-SMALLER)  		TBALE B (INNER TABLE)
IT WILL WORK FINE IF THE TABLE B IS HAVING ANY INDEX OVER IT, RATHER IT(TABLE A) WOULD HAVE TO SEARCH FOR THE RECORD ONE AFTER THE OTHER & HAD TO A FULL TABLE SCAN FOR EACH & EVERY VALUES


🥇 MERGE SORT JOIN
----------------------------
Merge Sort Join (also called Sort Merge Join) is a join method Oracle uses when joining two large datasets. 
Oracle sorts both datasets on the join key first, then merges them together like a zipper.


When Oracle Chooses Merge Sort Join
sql-- 1. When both tables are LARGE
-- 2. When data is already SORTED (big advantage)
-- 3. When NO suitable INDEX exists
-- 4. Non-equi joins (>, <, >=, <=)
-- 5. When hash join is not efficient

How It Works Step by Step
Table A (Employees)          Table B (Departments)
-----------------            -----------------
EMP_ID | DEPT_ID             DEPT_ID | DEPT_NAME
1      | 10                  10      | Accounting
3      | 20                  20      | Research
2      | 10                  30      | Sales
5      | 30
4      | 20
Step 1 — Sort Both Tables on Join Key
Sorted Table A               Sorted Table B
-----------------            -----------------
EMP_ID | DEPT_ID             DEPT_ID | DEPT_NAME
1      | 10                  10      | Accounting
2      | 10                  20      | Research
3      | 20                  30      | Sales
4      | 20
5      | 30
Step 2 — Merge (like a zipper)
Oracle reads both sorted sets simultaneously:
- Pointer A starts at DEPT_ID = 10
- Pointer B starts at DEPT_ID = 10
- MATCH → Output row, advance pointers
- Continue until all rows processed
Step 3 — Final Result
EMP_ID | DEPT_ID | DEPT_NAME
1      | 10      | Accounting
2      | 10      | Accounting
3      | 20      | Research
4      | 20      | Research
5      | 30      | Sales

Basic Example
sql-- Oracle automatically decides join method
SELECT e.employee_id, e.employee_name, d.department_name
FROM employees e, departments d
WHERE e.department_id = d.department_id;
Forcing Merge Sort Join with Hint
sql-- USE_MERGE hint forces Oracle to use Sort Merge Join
SELECT /*+ USE_MERGE(e d) */ 
       e.employee_id, 
       e.employee_name, 
       d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id;

-- Non-equi join example (very common for merge sort)
SELECT e.employee_name, e.salary, sg.grade
FROM employees e
JOIN salary_grades sg 
  ON e.salary BETWEEN sg.low_salary AND sg.high_salary;

Three Types of Oracle Joins Compared
sql/*
┌─────────────────┬──────────────────┬───────────────────┐
│   JOIN TYPE     │   BEST FOR       │   HOW IT WORKS    │
├─────────────────┼──────────────────┼───────────────────┤
│ NESTED LOOP     │ Small tables     │ Row by row lookup │
│                 │ Indexed columns  │ like nested FOR   │
│                 │                  │ loop              │
├─────────────────┼──────────────────┼───────────────────┤
│ HASH JOIN       │ Large tables     │ Builds hash table │
│                 │ Equi joins only  │ in memory         │
│                 │                  │                   │
├─────────────────┼──────────────────┼───────────────────┤
│ SORT MERGE JOIN │ Large tables     │ Sort both sides   │
│                 │ Non-equi joins   │ then merge        │
│                 │ Pre-sorted data  │                   │
└─────────────────┴──────────────────┴───────────────────┘
*/

Viewing Merge Sort Join in Execution Plan
sql-- Check execution plan
EXPLAIN PLAN FOR
SELECT /*+ USE_MERGE(e d) */
       e.employee_name, d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id;

-- View the plan
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

/* Output will show:
-----------------------------------------------
| Id | Operation               | Name         |
-----------------------------------------------
|  0 | SELECT STATEMENT        |              |
|  1 |  MERGE JOIN             |              |  ← Merge Sort Join
|  2 |   SORT JOIN             | EMPLOYEES    |  ← Sort Step
|  3 |    TABLE ACCESS FULL    | EMPLOYEES    |
|  4 |   SORT JOIN             | DEPARTMENTS  |  ← Sort Step
|  5 |    TABLE ACCESS FULL    | DEPARTMENTS  |
-----------------------------------------------
*/

Real World Practical Examples
sql-- Example 1: Large table join with hint
SELECT /*+ USE_MERGE(o c) */
       o.order_id, 
       o.order_date, 
       c.customer_name
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
ORDER BY o.order_id;

-- Example 2: Range join (perfect for sort merge)
SELECT e.employee_name, 
       e.salary,
       sg.grade_level
FROM employees e
JOIN salary_grades sg
  ON e.salary >= sg.min_salary 
  AND e.salary <= sg.max_salary;

-- Example 3: Date range join
SELECT t.transaction_id,
       t.amount,
       p.promotion_name
FROM transactions t
JOIN promotions p
  ON t.transaction_date BETWEEN p.start_date AND p.end_date;
```

---

## Advantages and Disadvantages
```
ADVANTAGES
✔ Very efficient for large datasets
✔ Works well for non-equi joins (BETWEEN, >, <)
✔ If data already sorted, sort step is skipped
✔ Predictable and consistent performance
✔ Good for parallel query execution

DISADVANTAGES
✘ Sorting is expensive (CPU + memory)
✘ Slower than Hash Join for equi joins
✘ Requires significant memory/temp space
✘ Not good for small tables

Performance Tuning Tips
sql-- TIP 1: If data is already indexed/sorted, merge join is faster
CREATE INDEX idx_emp_dept ON employees(department_id);
CREATE INDEX idx_dept_id ON departments(department_id);

-- TIP 2: Increase sort area for better performance
ALTER SESSION SET SORT_AREA_SIZE = 10485760; -- 10MB

-- TIP 3: Use NO_USE_MERGE to avoid sort merge join
SELECT /*+ NO_USE_MERGE(e d) */
       e.employee_name, d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id;

-- TIP 4: Check if parallel helps
SELECT /*+ USE_MERGE(e d) PARALLEL(e 4) PARALLEL(d 4) */
       e.employee_name, d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id;
```

---

## Summary
```
Sort Merge Join Process:
────────────────────────
1. SORT  → Both tables sorted on join key
2. MERGE → Walk through both sorted sets simultaneously
3. MATCH → When keys match, combine and output the row
4. DONE  → Until both pointers reach end of data

Best Use Cases:
───────────────
→ Large to Large table joins
→ Non-equi joins (BETWEEN, ranges)
→ Data already pre-sorted
→ No proper indexes available
→ Parallel query environments
Would you like me to explain Hash Join or Nested Loop Join in the same detail for comparison? Sonnet 4.5



🥇 HASH JOINS
-------------------

What is Hash Join? Hash Join is Oracles most efficient join method for large tables with equi-joins (= operator only). 
Oracle builds a HASH TABLE in memory from the smaller table, then probes it with the larger table.

How It Works Step by Step

Table A - Employees (SMALLER)    				Table B - Orders (LARGER)
----------------------           						-------------------
EMP_ID | EMP_NAME         					ORDER_ID | EMP_ID
1      | John                    						101      | 2
2      | Mary                    						102      | 1
3      | Steve                   						103      | 3
4      | Alice                   						104      | 1
															105      | 4
										
					🥇STEP 1 — BUILD PHASE (SMALLER TABLE)
						Oracle applies HASH FUNCTION on join key (EMP_ID)

						HASH FUNCTION: h(EMP_ID) = EMP_ID % 3			--------< On the Join key Dividing the JOIN key by 3 & getting the MODULOUS using whihc creating BUCKET

						EMP_ID=1 → h(1)=1 → Bucket 1 → {1, John}
						EMP_ID=2 → h(2)=2 → Bucket 2 → {2, Mary}
						EMP_ID=3 → h(3)=0 → Bucket 0 → {3, Steve}
						EMP_ID=4 → h(4)=1 → Bucket 1 → {4, Alice}

													-- Hash Table in Memory:	M NJDX
													┌──────────┬────────────────────┐
													│ Bucket 0  │ {3, Steve}         │
													│ Bucket 1  │ {1, John}          │
													│          	│ {4, Alice}         │
													│ Bucket 2  │ {2, Mary}          │
													└──────────┴────────────────────┘
					🥇STEP 2 — PROBE PHASE (LARGER TABLE)
						Oracle applies SAME HASH FUNCTION on Orders.EMP_ID

						ORDER_ID=101, EMP_ID=2 → h(2)=2 → Bucket 2 → MATCH Mary
						ORDER_ID=102, EMP_ID=1 → h(1)=1 → Bucket 1 → MATCH John
						ORDER_ID=103, EMP_ID=3 → h(3)=0 → Bucket 0 → MATCH Steve
						ORDER_ID=104, EMP_ID=1 → h(1)=1 → Bucket 1 → MATCH John
						ORDER_ID=105, EMP_ID=4 → h(4)=1 → Bucket 1 → MATCH Alice

					🥇STEP 3 — FINAL OUTPUT
						ORDER_ID | EMP_ID | EMP_NAME
						101      		| 2      | Mary
						102      		| 1      | John
						103      		| 3      | Steve
						104      		| 1      | John
						105      		| 4      | Alice

Basic Example
sql-- Oracle automatically picks hash join for large tables
SELECT e.employee_name, 
       o.order_id, 
       o.order_date
FROM employees e
JOIN orders o ON e.employee_id = o.employee_id;

Forcing Hash Join with Hint
--------------------------------
sql-- USE_HASH hint forces Oracle to use Hash Join
SELECT /*+ USE_HASH(e o) */
       e.employee_name,
       o.order_id,
       o.order_date
FROM employees e
JOIN orders o ON e.employee_id = o.employee_id;

Execution Plan for Hash Join
sql
EXPLAIN PLAN FOR
SELECT /*+ USE_HASH(e d) */
       e.employee_name, 
       d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

/* Output:
-----------------------------------------------
| Id | Operation               | Name         |
-----------------------------------------------
|  0 | SELECT STATEMENT        |              |
|  1 |  HASH JOIN              |              | ← Hash Join
|  2 |   TABLE ACCESS FULL     | DEPARTMENTS  | ← BUILD (smaller)
|  3 |   TABLE ACCESS FULL     | EMPLOYEES    | ← PROBE (larger)
-----------------------------------------------

Note: Oracle always puts SMALLER table first (BUILD side)
      and LARGER table second (PROBE side)
*/

HASH JOIN INTERNAL MEMORY BEHAVIOR
SQL/*
SCENARIO 1: Hash Table FITS in Memory (Best Case)
──────────────────────────────────────────────────
  Employees ──► Build Hash Table in PGA Memory
  Orders    ──► Probe Hash Table
  Result    ──► Direct output
  Performance: FASTEST

SCENARIO 2: Hash Table does NOT fit in Memory
──────────────────────────────────────────────
  Oracle splits into PARTITIONS and spills to TEMP tablespace
  
  Build side partitioned:
  Partition 1 → Memory
  Partition 2 → Temp Disk
  Partition 3 → Temp Disk
  
  Probe side scanned for each partition
  Performance: SLOWER (disk I/O involved)
*/

-- Check if hash join is spilling to disk
SELECT * FROM V$SQL_WORKAREA 
WHERE OPERATION_TYPE = 'HASH-JOIN'
AND ONEPASS_EXECUTIONS > 0   -- spilling once to disk
OR MULTIPASS_EXECUTIONS > 0; -- spilling multiple times (very slow)

Real World Practical Examples
sql-- Example 1: Basic Hash Join between large tables
SELECT /*+ USE_HASH(o c) */
       o.order_id,
       o.order_date,
       c.customer_name,
       c.city
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_date >= SYSDATE - 30;

-- Example 2: Multi-table Hash Join
SELECT /*+ USE_HASH(e d l) */
       e.employee_name,
       d.department_name,
       l.city
FROM employees   e
JOIN departments d ON e.department_id  = d.department_id
JOIN locations   l ON d.location_id    = l.location_id;

-- Example 3: Hash Join with aggregation
SELECT /*+ USE_HASH(o p) */
       p.product_name,
       COUNT(o.order_id)   as total_orders,
       SUM(o.quantity)     as total_qty,
       SUM(o.amount)       as total_revenue
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_revenue DESC;

-- Example 4: Hash Join with subquery
SELECT /*+ USE_HASH(e sub) */
       e.employee_name, 
       e.salary
FROM employees e
JOIN (SELECT department_id, AVG(salary) avg_sal
      FROM employees
      GROUP BY department_id) sub
  ON e.department_id = sub.department_id
WHERE e.salary > sub.avg_sal;
```

---

## Hash Join vs Sort Merge vs Nested Loop
```
┌──────────────────┬─────────────────┬──────────────┬─────────────────┐
│   CRITERIA       │   HASH JOIN     │  SORT MERGE  │  NESTED LOOP    │
├──────────────────┼─────────────────┼──────────────┼─────────────────┤
│ Join Type        │ Equi (=) only   │ All types    │ All types       │
│ Table Size       │ Large + Large   │ Large+Large  │ Small + Large   │
│ Memory Usage     │ High (PGA)      │ High (sort)  │ Low             │
│ Index Required   │ No              │ No           │ Yes (preferred) │
│ Pre-sorted Data  │ No benefit      │ Big benefit  │ No benefit      │
│ First Row Speed  │ Slow            │ Slow         │ FAST            │
│ Total Speed      │ FASTEST         │ Medium       │ Slow (large)    │
│ Parallel Query   │ Excellent       │ Good         │ Limited         │
└──────────────────┴─────────────────┴──────────────┴─────────────────┘

Performance Tuning for Hash Join
sql-- TIP 1: Increase PGA memory to avoid disk spills
ALTER SESSION SET PGA_AGGREGATE_TARGET = 500M;

-- TIP 2: Use LEADING hint to tell Oracle which table to build from
SELECT /*+ USE_HASH(e d) LEADING(d e) */
       e.employee_name, d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id;
-- LEADING(d) = departments is BUILD side (should be smaller table)

-- TIP 3: SWAP_JOIN_INPUTS forces Oracle to swap build/probe sides
SELECT /*+ USE_HASH(e d) SWAP_JOIN_INPUTS(e) */
       e.employee_name, d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id;

-- TIP 4: NO_USE_HASH to avoid hash join
SELECT /*+ NO_USE_HASH(e d) */
       e.employee_name, d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id;

-- TIP 5: Parallel Hash Join for very large tables
SELECT /*+ USE_HASH(e d) PARALLEL(e 4) PARALLEL(d 4) */
       e.employee_name, d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id;

Monitoring Hash Join Performance
sql-- Check memory usage of hash joins
SELECT sql_id,
       operation_type,
       policy,
       estimated_optimal_size/1024/1024 as optimal_mb,
       last_memory_used/1024/1024       as used_mb,
       last_execution,
       onepass_executions,
       multipass_executions
FROM V$SQL_WORKAREA
WHERE operation_type = 'HASH-JOIN'
ORDER BY last_memory_used DESC;

-- Find hash joins spilling to disk (performance problem)
SELECT sql_id, 
       sql_text
FROM V$SQL
WHERE sql_id IN (
    SELECT sql_id 
    FROM V$SQL_WORKAREA
    WHERE operation_type      = 'HASH-JOIN'
    AND   multipass_executions > 0
);
```

---

## Summary — Hash Join Process
```
Hash Join in 2 Phases:
───────────────────────────────────────────────
PHASE 1: BUILD
  → Take SMALLER table
  → Apply hash function on join key
  → Store in hash buckets in PGA memory
  → If too large → spill partitions to TEMP

PHASE 2: PROBE  
  → Scan LARGER table row by row
  → Apply SAME hash function on join key
  → Look up matching bucket
  → If match found → output combined row

Key Rules:
───────────────────────────────────────────────
✔ Only works with EQUI JOIN (= operator)
✔ Smaller table always on BUILD side
✔ Faster when hash table fits in memory
✔ Best choice for large table joins
✔ No index required
✘ Cannot be used for non-equi joins
✘ Memory intensive

Would you like me to explain Nested Loop Join in the same detail to complete all three join methods? Sonnet 4.5
	
	

-------------------------EXPLAIN PLAN--------



https://www.youtube.com/watch?v=ZXnD3Mzy_TM
https://www.youtube.com/watch?v=NkXxRodAFUY
https://www.youtube.com/watch?v=IYWmauKtwXI
https://www.youtube.com/channel/UCWeOtlakw8g01MrR8U4yYtg/videos

USING TABLE STATISTICS - CPU OPTIMATION, NO OF ROWS, NO OF UNIQUE VALUES IN COL, MAX, MIN VALUES USING THESE 
							TO ESTIMATE THE COST, KEEP TABLE DATA UP TO DATE
							
Example: EXEC DBMS_STATS.GATHER_TABLE_STATS(ownname => 'MY_SCHEMA', tabname => 'MY_TABLE') FOR ANY PARTICULAR TBBL
			EXEC DBMS_STATS.GATHER_SCHEMA_STATS(ownname => '<schema_name>'); FOR ALL TABLE IN THAT SCHEMA
			

EXPLAIN PLAN IS JUST A PREDICTION THAT HOW CAN IT RUN

EXECUTION PLAN - SQL_MONITOR, XPLAN
TABLES ARE LEAFS, SELECT IS ROOT & OPERATIONS ARE BRANCHES

CATEGORIES
SINGLE CHILD, MULTI CHILD., JOIN


SINGLE CHILD - HAVING ONE OPERATION BENEATH IT, EX - SORTING, GROUPING, VIEW
	
	MULTI CHILD - ONE OR MORE DATA SOURCES BENEATH IT EX...UNION
	
	
CPU, DIK READ, I/O READ	
	

--------------------------TYPE OF SCAN WHILE EXCEUTION ANY QUERY--------------------

TABLE ACCESS BY INDEX ROWID BATCHED -  In an Oracle execution plan means the database is using an index to locate rows, but its retrieving multiple row IDs (ROWIDs) at a time and then accessing the corresponding data blocks in a batched, or grouped, manner to reduce disk I/O. This optimization, introduced in Oracle 12c, aims to improve performance by minimizing the number of times the database needs to access a data block. 
The ROWID is obtained either from the WHERE clause predicate or through an index scan.

Example...

In the Normal ROWID (not batched) method, Oracle retrieves rows in the order determined by the index:

1. retrieves block 15, then retrieves row 015-000123 from this block
2. retrieves block 34, then retrieves row 034-000527 from this block
3. retrieves block 88, then retrieves row 088-000285 from this block
4. retrieves block 15 (again), then retrieves row 015-000889 from this block
5. retrieves block 88 (again), then retrieves row 088-000632 from this block

In the batched method oracle retrieves a few entries from the index, then first sorts them by the number of block, then process entries in the order determined by number of blocks:

1. retrieves block 15, then retrieves rows 015-000123 and 015-000889 from this block
2. retrieves block 34, then retrieves row 034-000527 from this block
3. retrieves block 88, then retrieves rows 088-000285 and 088-000632 from this block
As you see in this example, blocks were fetched only 3 times instead of 5 times, so a number of block reads from the disk has been reduced – some blocks have been read only once instead of two (or more) times.

 


------------------------------------TKPROF-------------------------------

			DESC EMP;

ALTER TABLE EMP ADD CONSTRAINT PK_EMP_EID PRIMARY KEY (EMPLOYEE_ID);

DELETE FROM EMP E2 WHERE ROWID NOT IN (SELECT MAX(ROWID) FROM EMP E1 WHERE E1.EMPLOYEE_ID = E2.EMPLOYEE_ID);

SELECT * FROM V$LOCKED_OBJECT;
SELECT * FROM DEPARTMENTS;
SELECT * FROM LOCATIONS;

EXPLAIN PLAN FOR 
SELECT EMPLOYEE_ID, FIRST_NAME, D.DEPARTMENT_NAME, L.LOCATION_ID, L.CITY, L.STATE_PROVINCE
FROM EMP E INNER JOIN DEPARTMENTS D
ON (E.DEPARTMENT_ID = D.DEPARTMENT_ID)
INNER JOIN LOCATIONS L
ON (D.LOCATION_ID = L.LOCATION_ID) WHERE L.COUNTRY_ID='US' AND D.DEPARTMENT_ID=110;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);


SELECT * FROM USER_INDEXES WHERE TABLE_NAME='EMP';
SELECT IOT_TYPE, IOT_NAME, U.* FROM USER_TABLES U WHERE TABLE_NAME='EMP';

SELECT * FROM USER_SEGMENTS WHERE TABLE_NAME='EMP';

EXPLAIN PLAN FOR
SELECT * FROM EMP WHERE JOB_ID='AD_VP';


--------------------EXECUTION PLAN--------------

----------EX Plan Document ORACLE base in Brief-------

https://docs.oracle.com/cd/E11882_01/server.112/e41573/ex_plan.htm#PFGRF009
https://docs.oracle.com/cd/B19306_01/server.102/b14211/ex_plan.htm#g42231

-------------------------------------------------------




https://www.youtube.com/watch?v=ewgcjJ8gXyg&t=2s

-------------------------------LAST CR BUFFER GETS------------------------------------

In Oracle databases, a buffer get refers to the number of times the database needs to access a data block. This access can happen from memory (if the block is already cached) or by reading it from disk. Last CR Buffer Gets specifically refers to the number of times blocks were retrieved in consistent read mode, which is typically used for queries. 

When Oracle needs to access a piece of data, it checks if the data block containing that data is already in the buffer cache 
(memory). If it is, the data is read directly from the buffer. If not, the block is read from disk into the buffer cache, and then the data is accessed. Each time a block is accessed, whether from memory or disk, its considered a buffer get. 

Consistent Reads:
When reading data for a query, Oracle needs to see a consistent snapshot of the data, as it was at the beginning of the query. This is achieved by using consistent read mode, where a consistent version of the data block is fetched from the buffer cache. This ensures that the query sees a consistent view of the data, even if other operations are modifying it. 

A BUFFER is a temporary storage area in computer memory used to hold data while its being transferred between different parts of a system, such as between a device and an application, or between two processes.

In operating systems, CACHE MEMORY is a high-speed memory that stores frequently accessed data and instructions, acting as a buffer between the CPU and the main memory (RAM). 

When Oracle requires a data block, it first checks to see if this data block is already in memory (database buffer cache). If the data block is found there, Oracle will read it. This process is called as ‘buffer get’. If the data block is not found, Oracle will need to bring the data block from disk into buffer cache first. This process is called as ‘disk read’. From Oracle database’s standpoint, the ‘buffer get’ is ‘logical I/O’, while ‘disk read’ is ‘physical I/O’. A buffer get may or may not require a disk read.

The SQL statements with high buffer gets are always the concern of database performance tuner:

  High buffer gets can cause high disk reads, which causes I/O workload increase and I/O path bottleneck. When accessing tables with a large amount of data, or database buffer cache with insufficient size, or combination of both, the SQL statements with high buffer gets will also have high disk reads because not all data blocks will be able to fit in database buffer cache and need to swap out to disk.
  
  Even under situations where the majority of data blocks already exist in database buffer cache and disk reads are low, high buffer gets put pressure on the Oracle memory structure, causing contention as well as burning CPU cycle. It is not rare to find out that the SQL statements with high buffer gets also have high CPU time, or get stuck with wait events such as ‘free buffer waits’, ‘buffer busy wait’, etc.

The key tuning strategies include:

  Review application logic to adjust I/O demands.
  Increase database parameters such as database cache size to accommodate high I/O workload.
  Ensure optimal SQL plans for SQL statements and try to avoid those high I/O cost algorithms such as ‘TABLE ACCESS FULL’, ‘MAT_VIEW ACCESS FULL’, etc.
  Address concurrency issue and reduce contention.
  
You can monitor the V$SQLAREA view to identify queries with high buffer gets. Look for queries with high BUFFER_GETS and low PHYSICAL_READS. This can indicate that the query is relying heavily on the buffer cache, potentially because its not well-tuned or indexed. 
  
Case Summary:

The following example describes a case scenario of performance tuning a SQL statement with high buffer gets. The root cause of high buffer gests turned out to be the full table scan involved on a big table. A new index was offered as the solution.
The list of steps include:

Check SQL stats to confirm the improvement

 Step 1 : Identify the SQL with high buffer gets

 Step 2 : Check SQL stats to identify the pattern

 Step 3 : Check SQL text and SQL plan to identify the full table scan as the issue

 Step 4 : Create a index to confirm the new SQL plan

 Step 5 : Check SQL stats to confirm the improvement

--------------------------COLUMN---CARDINALITY------------------

In Oracles execution plans, cardinality represents the estimated number of rows that will be returned by each operation. This is a key factor the optimizer uses to determine the most efficient execution path for a SQL query. 

Heres a more detailed explanation:

Purpose:

Cardinality helps the optimizer estimate the amount of work (cost) involved in each step of the execution plan. A higher cardinality for a step means more rows will be processed, potentially leading to higher costs and longer execution times. 

How its determined:

The optimizer calculates cardinality based on table and column statistics, and potentially dynamic sampling. For a simple equality predicate on a single table, it might assume a uniform distribution of values and divide the total number of rows by the number of distinct values in the column. 

Impact on execution plans:

When cardinality estimates are inaccurate, the optimizer might choose suboptimal execution plans, leading to performance issues. For example, if the optimizer underestimates the cardinality of a join, it might choose a nested loop join even when a hash join would be more efficient. 

Identifying misestimates:

You can use the GATHER_PLAN_STATISTICS hint to compare the estimated number of rows (E-Rows) with the actual number of rows processed (A-Rows) in the execution plan. 

For updation of teh data within the table with the recent any update need execute the below procedure....
BEGIN
	DBMS_STATS.GATHER_TABLE_STATS (null, 'EMP', no_invalidate => false);
	DBMS_STATS.GATHER_TABLE_STATS (null, 'DEPT', no_invalidate => false);
END;
/	


----------COLUMNS IN EXECUTION PLAN----------

LAST CR BUFFER GETS:
---------------------
The LAST CR Buffer Gets metric (visible in Oracle SQL Developer Autotrace) specifically tracks the number of times blocks were accessed in consistent read mode during the execution of a SQL statement. This metric can help you understand how much data was accessed in consistent mode, which can be valuable for performance tuning, especially when dealing with large queries or workloads that involve frequent data access. 


CACRDINALITY:
--------------

Cardinality represents the estimated number of rows that will be returned by each operation. This is a key factor the optimizer uses to determine the most efficient execution path for a SQL query. 
Heres a more detailed explanation:


OMEM (OPTIMAL MEMORY):
-----------------------
Represents the estimated memory needed to perform the operation entirely in memory. This is considered the optimal execution scenario, avoiding disk I/O for the operation.


1MEM (ONE-PASS MEMORY):
-------------------------
Represents the estimated memory needed to perform the operation using temporary space (like disk) only once. This is a one-pass execution, where the data is written to and read from temporary storage a single time.


USED-MEM:
---------
Shows the actual amount of memory used for the operation. It also includes a number in brackets indicating the number of passes (0 for optimal, 1 for one-pass, or a higher number for multi-pass).


USED-TMP:
---------
Shows the amount of temporary space used during the operation, if any.

