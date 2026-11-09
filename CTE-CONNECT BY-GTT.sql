
A CTE in Oracle is a temporary, NAMED RESULT SET that exists only for the duration of a single SQL statement. 
It is created using the WITH clause and helps make complex queries more readable, reusable, and maintainable.

WITH cte_name AS (
    SELECT column1, column2
    FROM table_name
    WHERE condition
)
SELECT *
FROM cte_name;


📌 The CTE is not stored in the database
📌 It is evaluated only for that SQL statement
✔ Improves readability
✔ Avoids repeating subqueries


WITH dept_cte AS (
    SELECT deptno, COUNT(*) emp_count
    FROM empp
    GROUP BY deptno
)
SELECT *
FROM dept_cte
WHERE emp_count > 5;

3️⃣ Multiple CTEs in One Query

WITH
emp_cte AS (
    SELECT empno, ename, deptno, sal
    FROM empp
),
dept_cte AS (
    SELECT deptno, dname
    FROM dept
)
SELECT e.empno, e.ename, d.dname
FROM emp_cte e
JOIN dept_cte d ON e.deptno = d.deptno;


------------RECURSIVE CTE---------------
“A recursive CTE is a common table expression that references itself, 
consisting of an anchor query and a recursive query, 
used to process hierarchical data iteratively until no further rows are returned.”

It is mainly used to handle:

Organizational hierarchies
Tree structures
Bill of materials
Manager–employee relationships

WITH emp_hierarchy (empno, ename, M_ID, lvl) AS (

  -- 1️⃣ Anchor member (Top-level managers)
  SELECT empno, ename, M_ID, 1
  FROM empp
  WHERE M_ID IS NULL

  UNION ALL

  -- 2️⃣ Recursive member (Find subordinates)
  SELECT e.empno, e.ename, e.M_ID, h.lvl + 1
  FROM empp e
  JOIN emp_hierarchy h
    ON e.M_ID = h.empno
)
SELECT *
FROM emp_hierarchy
ORDER BY lvl, empno;


--------------CONNECT BY LEVEL------------

The CONNECT BY clause in Oracle is used to query hierarchical (parent–child) data efficiently. 
It is Oracle’s native and optimized feature for tree-structured data.

“In Oracle, CONNECT BY is preferred over recursive CTEs for hierarchical queries 
because it is optimizer-optimized, provides built-in cycle detection, 
and offers hierarchy-specific pseudo-columns like LEVEL and CONNECT_BY_ISLEAF.”


🏆 Real-Time Use Cases

✔ Organization structure
✔ Product category trees
✔ Menu navigation
✔ Folder structures
✔ Bill of Materials (BOM)


5️⃣ Why CONNECT BY Is Faster in Oracle

✔ Purpose-built hierarchical engine
✔ Avoids repeated joins
✔ Optimizer understands tree traversal
✔ Special pseudo-columns:

LEVEL
CONNECT_BY_ISLEAF
CONNECT_BY_ROOT
SYS_CONNECT_BY_PATH

🏆 Rule of Thumb

👉 Oracle-only + performance → CONNECT BY
👉 Portable SQL + light hierarchy → Recursive CTE


SELECT empno,
       ename,
       m_id,
       LEVEL AS lvl
FROM empp
START WITH m_id IS NULL
CONNECT BY PRIOR empno = m_id;

100	Steven King				1
101	Neena Kochhar		100	2
108	Nancy Greenberg		101	3
109	Daniel Faviet		108	4
110	John Chen			108	4
111	Ismael Sciarra		108	4
112	Jose Manuel Urman	108	4
113	Luis Popp			108	4
200	Jennifer Whalen		101	3
203	Susan Mavris		101	3
204	Hermann Baer		101	3
205	Shelley Higgins		101	3
206	William Gietz		205	4
102	Lex De Haan			100	2
103	SAMEER				102	3
104	Bruce Ernst			103	4
105	David Austin		103	4

SELECT empno,
       SYS_CONNECT_BY_PATH(ename,  → ) AS path
FROM empp
START WITH m_id IS NULL
CONNECT BY PRIOR empno = m_id;

100	 → Steven King
101	 → Steven King → Neena Kochhar
108	 → Steven King → Neena Kochhar → Nancy Greenberg
109	 → Steven King → Neena Kochhar → Nancy Greenberg → Daniel Faviet
110	 → Steven King → Neena Kochhar → Nancy Greenberg → John Chen
111	 → Steven King → Neena Kochhar → Nancy Greenberg → Ismael Sciarra
112	 → Steven King → Neena Kochhar → Nancy Greenberg → Jose Manuel Urman
113	 → Steven King → Neena Kochhar → Nancy Greenberg → Luis Popp
200	 → Steven King → Neena Kochhar → Jennifer Whalen
203	 → Steven King → Neena Kochhar → Susan Mavris
204	 → Steven King → Neena Kochhar → Hermann Baer
205	 → Steven King → Neena Kochhar → Shelley Higgins
206	 → Steven King → Neena Kochhar → Shelley Higgins → William Gietz
102	 → Steven King → Lex De Haan
103	 → Steven King → Lex De Haan → SAMEER
104	 → Steven King → Lex De Haan → SAMEER → Bruce Ernst
105	 → Steven King → Lex De Haan → SAMEER → David Austin
106	 → Steven King → Lex De Haan → SAMEER → Valli Pataballa


-------------------------GLOBAL TEMPORARY TABLE--------------------

A Global Temporary Table (GTT) in Oracle is a special type of table where data is temporary and session-specific or transaction-specific, 
while the table definition is permanent.


HOW CAN A GTT BE USED FOR DML OPERATION OVER A TABLE IN ORACLE...?

Thought Process


A Global Temporary Table (GTT) is typically used as a Staging Area to improve the performance of complex DML operations (Insert, Update, Delete) on a permanent table.

Instead of executing thousands of small, slow row-by-row operations against the main table, you load the data into the GTT first, process it there, and then perform a single bulk operation to sync the data with the main table.

Here is the step-by-step approach and examples of how to use a GTT for DML operations.

The General Workflow
Create/Truncate: Ensure the GTT is empty (GTTs retain data for the duration of a session or transaction).
Load Data: Insert the raw data or IDs into the GTT (fast, generates minimal redo).
Process/Prepare: Update or clean the data inside the GTT if necessary.
Execute DML: Perform the bulk Insert/Update/Delete on the Main Table by joining it with the GTT.


SCENARIO 1: BULK UPDATE USING A GTT
-------------------------------------------------
Situation: You need to update the SALARY for 5,000 employees based on data provided in a text file or an external calculation. Doing a standard cursor loop is slow.

The GTT Approach:

Load the 5,000 Employee IDs and new salaries into a GTT.
Perform a single UPDATE joining the Main Table to the GTT.
sql

-- 1. Create the GTT (if not exists)
CREATE GLOBAL TEMPORARY TABLE gtt_salary_updates (
    emp_id NUMBER,
    new_salary NUMBER
) ON COMMIT PRESERVE ROWS; -- Keeps data until end of session

-- 2. Load data into GTT (Simulating a bulk load from an external source)
INSERT INTO gtt_salary_updates VALUES (101, 60000);
INSERT INTO gtt_salary_updates VALUES (102, 75000);
-- ... (Imagine 5000 rows here)

-- 3. Perform the Bulk Update on the Main Table
UPDATE employees e
SET    salary = (SELECT new_salary 
                 FROM   gtt_salary_updates g 
                 WHERE  g.emp_id = e.employee_id)
WHERE  EXISTS (
    SELECT 1 
    FROM   gtt_salary_updates g 
    WHERE  g.emp_id = e.employee_id
);
Why this is better: Oracle performs a Hash Join or Nested Loop between EMPLOYEES and the GTT (which is in memory/temp space) and applies the update in one pass.

SCENARIO 2: BULK DELETE USING A GTT
--------------------------------------------------
Situation: You need to delete 10,000 orders from the ORDERS table based on a list of Invalid Order IDs GENERATED BY A COMPLEX REPORT.

The GTT Approach:

Insert the bad IDs into the GTT.
Delete from the main table using the GTT as the filter.
sql

-- 1. GTT for IDs
CREATE GLOBAL TEMPORARY TABLE gtt_orders_to_delete (
    order_id NUMBER PRIMARY KEY
) ON COMMIT PRESERVE ROWS;

-- 2. Populate the GTT with the list of bad IDs
INSERT INTO gtt_orders_to_delete 
SELECT order_id FROM COMPLEX_AUDIT_REPORT WHERE status = FRAUD;

-- 3. Delete from Main Table using the GTT
DELETE FROM orders o
WHERE EXISTS (
    SELECT 1 
    FROM   gtt_orders_to_delete g 
    WHERE  g.order_id = o.order_id
);
Why this is better: If you simply ran DELETE FROM orders WHERE status = FRAUD, Oracle might struggle to use an index if status has low selectivity. By putting the specific IDs into a GTT (Primary Key), you ensure the delete is precise and efficient.

SCENARIO 3: ETL / UPSERT (MERGE) USING A GTT
-------------------------------------------------------------

Situation: You are loading daily sales data. If the record exists, update it; if not, insert it.

The GTT Approach:

Load the daily file into the GTT.
Use the MERGE command to sync the GTT with the Main Table.
sql

-- 1. GTT Staging
CREATE GLOBAL TEMPORARY TABLE gtt_daily_sales (
    txn_id NUMBER,
    amount NUMBER,
    sale_date DATE
) ON COMMIT PRESERVE ROWS;

-- 2. Load daily data
INSERT INTO gtt_daily_sales VALUES (999, 500, SYSDATE);

-- 3. Merge (Upsert) into Main Table
MERGE INTO sales_target s
USING gtt_daily_sales g
ON (s.txn_id = g.txn_id)
WHEN MATCHED THEN
    UPDATE SET s.amount = g.amount, s.sale_date = g.sale_date
WHEN NOT MATCHED THEN
    INSERT (txn_id, amount, sale_date)
    VALUES (g.txn_id, g.amount, g.sale_date);
	
	
Key Benefits of using GTT for DML

Reduces Redo Log Generation: DML operations inside a GTT generate little to no REDO logs (only UNDO). This makes the staging phase very fast. The actual DML on the main table happens only once.
Reduces Locking: If you updated the main table row-by-row, you hold locks for a long time. With the GTT approach, the main table is locked only for the duration of the final bulk operation.
Simplifies Logic: Instead of complex PL/SQL loops (FOR rec IN cursor LOOP ... UPDATE ... END LOOP;), you write clean, set-based SQL.
Concurrency: Since GTTs are session-specific, multiple users can run the same batch process simultaneously without interfering with each others staging data.
Important Note: Statistics
Since GTTs are temporary, Oracle often has trouble gathering statistics on them (or they get shared between sessions). Before running the big DML (Step 4 in the examples above), it is often good practice to lock the stats of the GTT or set them manually so Oracle knows the GTT contains 5,000 rows, not 0 rows.

sql

-- Example of locking stats for a GTT so the optimizer knows the size
EXEC DBMS_STATS.LOCK_TABLE_STATS(USER_NAME, GTT_SALARY_UPDATES);


For large, bulky data (e.g., hundreds of thousands or millions of rows), Global Temporary Tables (GTT) are generally the better and safer choice.

Here is the detailed comparison of why GTT usually wins for massive data volumes, and when you might consider Collections.

1. The Memory Constraint (PGA vs. Temp Tablespace) - This is the most critical factor for "bulky" data.
-----------------------------------------------------------------------

Collections (PL/SQL Tables): Stored in the PGA (Process Global Area)—essentially RAM.
Risk: If you load 1 million rows into a collection, you consume massive amounts of RAM. If the server doesnt have enough memory allocated to the PGA, 
your session will crash with ORA-04030: out of process memory.

GTT: Stored in the Temporary Tablespace (on disk).
Benefit: You are limited by the size of your hard drive/Temp Tablespace, which is massive (Terabytes) compared to RAM. You can load billions of rows into a GTT without worrying about crashing the server memory.

2. SQL Capabilities (Joins, Sorting, Grouping)
--------------------------------------------------------------
GTT: It is a Table. You can create indexes on it. You can run complex SQL commands (GROUP BY, ORDER BY, WINDOW FUNCTIONS, DISTINCT) inside the GTT before you perform the DML on the main table.
Example: You can pre-calculate totals or rankings in the GTT and then merge them.

Collections: They are Arrays. You cannot join a collection directly to a table using standard SQL syntax (unless you use TABLE() and CAST, which is complex). You cannot easily index a collection or sort it efficiently for bulk operations.

3. Performance of the Final DML
------------------------------------------
GTT (Set-Based):
You perform a MERGE or INSERT INTO ... SELECT ... FROM GTT.
The Oracle SQL Engine is a powerhouse at processing table-to-table operations. It uses Hash Joins and Direct Path writes efficiently.

Collections (Context Switching):
You must use FORALL (Bulk Bind) to write data to the table.
While FORALL is very fast, it still requires moving data from the PL/SQL engine (Collection) to the SQL Engine (Table). For extremely large datasets, the overhead of this data movement is higher than a table-to-table operation.


4. Ease of Debugging
---------------------------
GTT: While your procedure is running, you can open a separate SQL session and run SELECT * FROM my_gtt. You can actually see the data you are processing to debug issues.

Collections: The data exists only in the memory of the running PL/SQL code. You cannot query it from outside while the code is running, making debugging difficult.

Summary Comparison Table
Feature
Global Temporary Table (GTT)
PL/SQL Collection
Best For	Very Large Data (Millions+ rows)	Medium/Small Data (< 100k rows)
Storage	Temporary Tablespace (Disk)	PGA (RAM)
Risk	Disk space usage	Memory Crash (ORA-04030)
Indexing	Supported (Can speed up joins)	Not supported (Linear scan)
DML Syntax	MERGE INTO main USING gtt...	FORALL i IN 1..count INSERT...
Debugging	Can query the table from another session	Cannot see data while code runs

When to use which?
Use a GTT when:

The data volume is huge (Millions of rows).
You need to perform complex SQL logic (Grouping, Ranking, Joining) on the data before updating the main table.
You want to use MERGE for efficient Upserts.
Use a COLLECTION when:

The data volume is small (e.g., a few hundred rows retrieved from a cursor).
You need to perform complex row-by-row procedural logic (calculations, IF/ELSE statements) that cannot be done easily in SQL.
You need to pass the data into a stored procedure as a parameter (using associative arrays).
Final Verdict
For "Large Bulky Data," GTT is the winner. It is safer, more scalable, and leverages the full power of the SQL engine.






-------------------------------------------------------------------------------------------------------------------------------------------

Key Characteristics
	Feature						Behavior
→ Table definition		Permanent (stored in data dictionary)
→ Data storage			Temporary (in TEMP tablespace)
→ Data visibility		Private to session
→ Data persistence		Depends on ON COMMIT option
→ Redo/Undo	Minimal 	redo (performance benefit)
→ Triggers & Indexes	Supported
→ Statistics			Static unless explicitly gathered

CREATE GLOBAL TEMPORARY TABLE emp_gtt
(
    emp_id   NUMBER,
    emp_name VARCHAR2(50),
    salary   NUMBER
)
ON COMMIT PRESERVE ROWS;

ON COMMIT Options (Very Important)
1️⃣ ON COMMIT PRESERVE ROWS

Data retained for the session
Deleted automatically when the session ends.

✔ Used when:
Data needed across multiple transactions
Reporting, batch processing, complex logic.


2️⃣ ON COMMIT DELETE ROWS

Data deleted on every COMMIT
Exists only within the current transaction

✔ Used when:
Intermediate calculations
Transaction-level processing


When to Use Global Temporary Tables

✔ Replacing PL/SQL collections
✔ Intermediate result storage
✔ Performance tuning (large joins, complex logic)
✔ ETL staging within sessions
✔ Avoiding row-level locks


Why Replace PL/SQL Collections with GTT?
------------------------------------------
Limitation of Collections				How GTT Solves It
Exists only in PL/SQL				Accessible in pure SQL
Poor for large data				Handles millions of rows
Cannot be indexed easily		Indexes supported
No statistics							Optimizer can use stats
Hard to join							Easy joins with base tables
Memory pressure (PGA)			Uses TEMP tablespace

🏆 We replace PL/SQL collections with GTTs when data needs to be processed using SQL, joined with large tables, indexed, 
	or optimized for performance. GTTs reduce PGA usage and allow the optimizer to generate better execution plans.
	
🏆  Yes, GTTs can be used inside PL/SQL just like normal tables. They are often preferred over collections for large datasets, 
	bulk processing, and SQL joins, while keeping data session-private and automatically cleaned up.
	
🏆 Need for GTT..

3️⃣ For Complex SQL Joins & Transformations

Break one complex SQL into multiple manageable steps.

INSERT INTO order_gtt
SELECT o.order_id, c.customer_name
FROM orders o
JOIN customers c ON c.id = o.cust_id;


Then:

SELECT *
FROM order_gtt
WHERE customer_name LIKE A%;

---------------------------------------

8️⃣ For Parallel Execution

GTTs support parallel DML & queries.

INSERT /*+ PARALLEL */ INTO gtt_data
SELECT * FROM huge_table;

✔ Scales well for large volumes	

---------------------------------------

9️⃣ For Temporary Result Caching

Reuse same derived data multiple times in a session.

INSERT INTO cache_gtt
SELECT expensive_function(col) FROM big_table;

✔ Avoid repeated computation

---------------------------------------

1️⃣1️⃣ Using GTT with Indexes
CREATE INDEX idx_gtt_id ON emp_gtt(empno);


✔ Improves joins & lookups

---------------------------------------

1️⃣2️⃣ Using GTT Inside PL/SQL
BEGIN
   INSERT INTO emp_gtt SELECT * FROM emp;
   UPDATE emp_gtt SET sal = sal * 1.1;
END;
/
---------------------------------------

✔ Works like normal tables

1️⃣3️⃣ Using GTT in Views & Subqueries
CREATE VIEW v_emp_gtt AS
SELECT * FROM emp_gtt;

----------------------------------------

One-Line Interview Answer

A GTT can be used as a session-private staging table for intermediate data, bulk processing, performance tuning, reporting, 
and replacing PL/SQL collections, while avoiding locking and reducing PGA usage.



Yes, absolutely. Global Temporary Tables (GTT) are designed to be used within PL/SQL blocks (Stored Procedures, Functions, Triggers, or Anonymous Blocks).

They are commonly used in PL/SQL to PROCESS LARGE AMOUNTS OF INTERMEDIATE DATA WITHOUT FILLING UP THE PERMANENT TABLESPACE OR GENERATING A LOT OF REDO LOGS.

Here is how to use them, along with the specific rules regarding data retention.

1. How it Works
The syntax inside PL/SQL is identical to using a regular table. You perform INSERT, UPDATE, DELETE, and SELECT statements exactly as you normally would.

Key Concept: While the table definition is global (everyone can see the table), the data is private. Only the session that inserted the data can see it.

2. Two Types of GTTs (Crucial for PL/SQL)
When creating the GTT, you must choose how long the data persists. This affects how your PL/SQL block behaves.

Type A: ON COMMIT DELETE ROWS (Transaction-Level)
Behavior: Data is stored only for the duration of the transaction.
What happens: As soon as you issue a COMMIT in your PL/SQL block, the table truncates itself (data disappears).
Best for: ETL processes where you want to stage data, commit the main changes, and have the temp data vanish automatically.

Type B: ON COMMIT PRESERVE ROWS (Session-Level) (Most Common)
Behavior: Data is stored for the duration of the session.
What happens: The data stays in the table even after you COMMIT. It only disappears when you log out or disconnect.
Best for: PL/SQL procedures that run multiple steps or loops and need to keep reference data around for a while.

3. Example Implementation
Step 1: Create the Global Temporary Table (DDL)
Note: This is done once, outside the PL/SQL block.

sql

CREATE GLOBAL TEMPORARY TABLE temp_emp_processing (
    emp_id NUMBER,
    emp_name VARCHAR2(100),
    processed_flag CHAR(1)
) ON COMMIT PRESERVE ROWS; -- Data stays until I log out
Step 2: Use it in PL/SQL

sql

DECLARE
    v_count NUMBER;
BEGIN
    -- 1. Insert data into GTT (Fast, generates almost no redo)
    INSERT INTO temp_emp_processing 
    SELECT employee_id, last_name, N 
    FROM employees 
    WHERE department_id = 10;

    -- 2. Process the data (Simulate complex logic)
    UPDATE temp_emp_processing 
    SET processed_flag = Y 
    WHERE emp_id > 100;

    -- 3. Count how many rows we handled
    SELECT COUNT(*) INTO v_count 
    FROM temp_emp_processing 
    WHERE processed_flag = Y;

    DBMS_OUTPUT.PUT_LINE(Total Processed Employees:  || v_count);

    -- 4. Commit the main transaction (optional)
    -- Since we used ON COMMIT PRESERVE ROWS, this COMMIT 
    -- does NOT delete the data in the temp table.
    COMMIT;

    -- 5. Optionally, manually clear it if you are done
    -- EXECUTE IMMEDIATE TRUNCATE TABLE temp_emp_processing;
END;
/
Why use GTTs in PL/SQL?
Performance: Operations on GTTs do not generate Redo Logs (only Undo), making inserts/updates significantly faster than permanent tables.
Memory Efficiency: Unlike using a PL/SQL Collection (like an Array in memory), if your dataset is huge (e.g., 1 million rows), a GTT uses disk space (Temp Tablespace) rather than consuming expensive PGA (RAM) memory.
Ease of Coding: It is often easier to write SQL against a table than to write complex PL/SQL code to loop through arrays.
Important Warning
You cannot create a GTT inside a PL/SQL block using standard DDL. You must create the table structure beforehand.

sql

-- THIS WILL FAIL:
BEGIN
    CREATE GLOBAL TEMPORARY TABLE ... -- Syntax Error
END;
You must create the table once, and then the PL/SQL block simply uses it.



CAN A GTT BE CREATED USING AN EXISITING SQL TABLE WITH THE COMMIT CLAUSE

Thought Process


No, you cannot do this in a single statement.

Oracle does not allow you to combine the CREATE ... AS SELECT (CTAS) syntax with the ON COMMIT clause for Global Temporary Tables. If you try this:

sql

-- THIS CAUSES AN ERROR
CREATE GLOBAL TEMPORARY TABLE temp_emp 
AS SELECT * FROM employees 
ON COMMIT PRESERVE ROWS;
You will get an error like: ORA-00905: missing keyword or ORA-32035: unsupported optional clause for this operation.

The Solution
To create a GTT from an existing table, you must first define the structure (columns) and then populate it.

There are two ways to handle this depending on how complex your table is.

Method 1: The Manual Method (Simple Tables)
If the source table has few columns, simply list them out.

sql

CREATE GLOBAL TEMPORARY TABLE temp_emp (
    employee_id   NUMBER,
    first_name    VARCHAR2(50),
    last_name     VARCHAR2(50),
    hire_date     DATE,
    salary        NUMBER
) ON COMMIT PRESERVE ROWS;

-- Then populate it in the same script
INSERT INTO temp_emp 
SELECT * FROM employees;
COMMIT;
Method 2: The Dynamic PL/SQL Method (Best for Large/Complex Tables)
If the source table has 50+ columns or you do this frequently, typing the column definitions manually is error-prone. You can use a PL/SQL block to query the Data Dictionary, copy the structure, and create the GTT for you.

Here is a reusable script to do this:

sql

DECLARE
    v_sql VARCHAR2(32000);
    v_new_table_name VARCHAR2(30) := TEMP_EMP_GTT; -- Name for your GTT
    v_source_table VARCHAR2(30) := EMPLOYEES;     -- Existing Table Name
BEGIN
    -- Build the CREATE statement by querying existing column definitions
    FOR col_rec IN (
        SELECT column_name, 
               data_type, 
               data_length, 
               data_precision, 
               data_scale, 
               nullable
        FROM user_tab_columns 
        WHERE table_name = v_source_table
        ORDER BY column_id
    ) LOOP
        IF v_sql IS NULL THEN
            v_sql := CREATE GLOBAL TEMPORARY TABLE  || v_new_table_name ||  (;
        ELSE
            v_sql := v_sql || , ;
        END IF;

        -- Build column definition (e.g., NUMBER(6) or VARCHAR2(50))
        v_sql := v_sql || col_rec.column_name ||   || col_rec.data_type;
        
        IF col_rec.data_precision IS NOT NULL THEN
             v_sql := v_sql || ( || col_rec.data_precision;
             IF col_rec.data_scale IS NOT NULL THEN
                 v_sql := v_sql || , || col_rec.data_scale;
             END IF;
             v_sql := v_sql || );
        ELSIF col_rec.data_type = VARCHAR2 OR col_rec.data_type = CHAR THEN
             v_sql := v_sql || ( || col_rec.data_length || );
        END IF;
        
        IF col_rec.nullable = N THEN
            v_sql := v_sql ||  NOT NULL;
        END IF;
    END LOOP;

    -- Add the Commit Clause and close parenthesis
    v_sql := v_sql || ) ON COMMIT PRESERVE ROWS;

    -- Execute the creation
    EXECUTE IMMEDIATE v_sql;
    
    DBMS_OUTPUT.PUT_LINE(Created GTT:  || v_new_table_name);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(Error:  || SQLERRM);
END;
/
Once the GTT is created using Method 2:
You can simply populate it whenever needed:

sql

INSERT INTO TEMP_EMP_GTT SELECT * FROM EMPLOYEES;

----------------------------------------------------------------------------------------------------


