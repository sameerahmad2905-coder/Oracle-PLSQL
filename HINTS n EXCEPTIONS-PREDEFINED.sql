------------------------HINTS-------------

Oracle hints are instructions within a SQL statement that guide the optimizer in choosing an execution plan. They provide a way to influence the optimizers decision-making, potentially improving query performance by forcing the use of a more efficient plan than the one the optimizer would otherwise choose. 

Types of Hints:
----------------
Single-table hints (STH): Apply to a single table or view (e.g., INDEX, USE_NL).
Multi-table hints (MTH): Apply to multiple tables or views (e.g., LEADING).
Query block hints: Apply to a specific query block (e.g., STAR_TRANSFORMATION, UNNEST, STAR).
Statement hints (SMH): Apply to the entire SQL statement (e.g., ALL_ROWS). 

Key Considerations:
-----------------------
Hint Placement: Hints are placed within a comment following the SELECT, UPDATE, MERGE, or DELETE keyword. 
Syntax: Hints typically use the syntax /*+ hint_name(parameters) */. 

Not Guaranteed: The optimizer may still choose a different plan, even if a hint is used. 
Potential for Performance Degradation: Incorrectly used hints can sometimes lead to performance degradation. 

2. INDEX Hint  -- (STH)
Purpose: Forces Oracle to use a specific index for a table instead of performing a full table scan or choosing another index.

Syntax:

SELECT /*+ INDEX(table_name index_name) */ column_name
FROM table_name;

Example:

SELECT /*+ INDEX(customers idx_customer_name) */ name, email
FROM customers
WHERE name = 'John Doe';

Explanation:
This hint forces Oracle to use the idx_customer_name index on the customers table for the query. It can improve performance, 
especially if theres a large dataset and the default plan would have chosen a full table scan.

3. FULL Hint (STH)
Purpose: Forces Oracle to perform a full table scan, even if indexes are available.
There are situations where Oracle’s optimizer will deliberately choose a full-table scan (FTS) because it is the cheapest or only reasonable way to get the data.  The key is “cheapest,” not “prettiest, reasons can be

✅ This type of Index is used in case where a column is having larger amoutn of same value, exampel 
				Col Status is havign these 3-values 
							ACTIVE - 80%
							INACTIVE - 10%
							UNKNOWN - 10%
Syntax:							    

SELECT /*+ FULL(table_name) */ column_name
FROM table_name;

Example:

SELECT /*+ FULL(customers) */ *
FROM customers;

Explanation:
This hint overrides the optimizer’s decision and forces a full table scan on the customers table. It can be beneficial when a query involves retrieving most or all rows from a small table, making a full scan more efficient than using an index

		EX...
		
						EXPLAIN PLAN FOR 
								SELECT * FROM EMP WHERE STATUS='ACTIVE';
						
						   SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
						   
						   Plan hash value: 1753735159
 
									-------------------------------------------------------------------------------------------
									| Id  | Operation          				| Name | Rows  | Bytes | Cost (%CPU)| Time     | Pstart| Pstop |
									-------------------------------------------------------------------------------------------
									|   0 | SELECT STATEMENT   		|      |     1 |    69 |    64   (0)| 00:00:01 |       |       |
									|   1 |  PARTITION LIST ALL			|      |     1 |    69 |    64   (0)| 00:00:01 |     1 |    13 |
									|*  2 |   TABLE ACCESS FULL		| EMP |     1 |    69 |    64   (0)| 00:00:01 |     1 |    13 |
									-------------------------------------------------------------------------------------------
 
 In case we dont use the column having that larger amount of same value 'STATUS = ACTIVE' we get
 
		EXPLAIN PLAN FOR 
								SELECT * FROM EMP;
									
									Plan hash value: 1753735159
 
									-------------------------------------------------------------------------------------------
									| Id  | Operation          						| Name | Rows  | Bytes | Cost (%CPU)| Time     | Pstart| Pstop |
									-------------------------------------------------------------------------------------------
									|   0 | SELECT STATEMENT   				|      |   107 		|  7383 |    64   (0)| 00:00:01 |       |       |
									|   1 |  PARTITION LIST ALL					|      |   107 		|  7383 |    64   (0)| 00:00:01 |     1 |    13 |
									|   2 |   TABLE ACCESS FULL				| EMP |   107 	|  7383 |    64   (0)| 00:00:01 |     1 |    13 |
									-------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - filter(STATUS='ACTIVE')

4. LEADING Hint (MTH)
Purpose: Forces Oracle to process tables in the order specified, which is useful for optimizing join queries.

Syntax:

SELECT /*+ LEADING(table1 table2) */ column_name
FROM table1, table2
WHERE table1.id = table2.id;

Example:

SELECT /*+ LEADING(orders customers) */ order_id, name
FROM orders, customers
WHERE orders.customer_id = customers.customer_id;

Explanation:
This hint forces Oracle to join the orders table first, followed by the customers table. This is useful if the orders table is smaller or more selective, and processing it first would improve the query performance.

5. PARALLEL Hint (STH)
Purpose: Enables parallel execution of a query, which can speed up the processing of large tables or complex queries.

Syntax:

SELECT /*+ PARALLEL(table_name degree) */ column_name
FROM table_name;

Example:

SELECT /*+ PARALLEL(orders 4) */ order_id, total_amount
FROM orders;

Explanation:
This hint tells Oracle to use parallel execution for the orders table, with a degree of parallelism of 4 (i.e., Oracle will use 4 parallel processes). This is particularly useful for large datasets where parallelism can significantly reduce query execution time.


---DISADVANTAGES OF USING PARALLEL HINT IN ORACLE----

CPU Spike: A query running with a degree of parallelism (DOP) of 8 will effectively try to use 800% of a single CPU core (or 8 full cores). 
If multiple users do this simultaneously, the CPU can hit 100%, causing system-wide slowdowns.

Memory Pressure: Each Parallel Execution Server (PX process) requires its own Program Global Area (PGA) memory for sorting and hashing. 
High parallelism can consume memory rapidly, leading to swapping (using disk as RAM) or Out-Of-Memory (OOM) errors.


6. USE_NL (Nested Loop Join) Hint
Purpose: Forces Oracle to use a Nested Loop join method for the specified tables.

Syntax:

SELECT /*+ USE_NL(table1 table2) */ column_name
FROM table1, table2
WHERE table1.id = table2.id;

Example:

SELECT /*+ USE_NL(orders customers) */ order_id, name
FROM orders, customers
WHERE orders.customer_id = customers.customer_id;

Explanation:
This hint forces Oracle to use a Nested Loop join between the orders and customers tables. 
Nested Loop joins are generally efficient when one table is small and can be used as the outer loop for fetching matching rows from the larger table.


9. NO_INDEX Hint
Purpose: Prevents the use of any index for a given table.

Syntax:

SELECT /*+ NO_INDEX(table_name) */ column_name
FROM table_name;

Example:

SELECT /*+ NO_INDEX(customers) */ *
FROM customers;

Explanation:
This hint prevents the optimizer from using any indexes for the customers table. This can be useful when an index is outdated or when a full table scan would be more efficient than using an index.

20. ORDERED
Forces Oracle to join the tables exactly in the order they appear in the FROM clause.

Scenario: You know the best order based on your data volume, and you dont want Oracle to guess.
Example:
sql

SELECT /*+ ORDERED */ *
FROM Small_Table a, Medium_Table b, Large_Table c
WHERE a.id = b.id AND b.id = c.id;
Oracle guarantees: A -> B -> C.


21 USE_HASH (Hash Join)
Best for joining large data sets together. It creates a hash table in memory of the smaller table 
and probes it with the larger table without indexes. 

Faster than Nested Loops for large data, but requires more memory (PGA).

1️⃣ Build phase (smaller table)
			Oracle picks the smaller table
			Reads it fully
			Creates an in-memory hash table
			Hash key = join column
			👉 This is why memory (PGA) matters.

2️⃣ Probe phase (larger table)
			Oracle reads the larger table
			For each row, computes the hash value
			Probes the hash table to find matching rows
			If hash matches → rows are joined

🚀 When Oracle chooses HASH JOIN
			Oracle optimizer prefers hash join when:
			Join condition is =
			Tables are large
			No selective index exists
			optimizer_mode = ALL_ROWS

Scenario: Generating a report of all sales from last month joined with all products. Millions of rows.
Example:
sql

SELECT /*+ USE_HASH(s p) */ *
FROM Sales s, Products p
WHERE s.product_id = p.id;

22. The APPEND hint is used to tell Oracle to perform a direct-path insert instead of a conventional insert.
---🧠 APPEND hint means: “Don’t try to fit new data in between old data — just add it at the end, as fast as possible.”
🔁 Important behavior
DELETE does NOT reduce HWM
UPDATE does NOT reduce HWM
TRUNCATE resets HWM
APPEND inserts write AFTER HWM

🔸 INSERT /*+ APPEND */ (Direct Path)
Writes directly after HWM
Minimal UNDO (only metadata)
REDO can be reduced
Indexes maintained after insert
Much faster for bulk loads 🚀

🧱 Think of it like a notebook 📒
Normal INSERT
You flip through pages and write wherever there’s space → slow

INSERT with APPEND
You open a new page at the end and keep writing → fast

🗄️ In Oracle table terms
Oracle tables are stored in blocks
As rows are inserted, blocks get used
The last block that has ever contained data defines the HWM (High Water Mark)

INSERT /*+ APPEND */ INTO target_table
SELECT ...
FROM source_table;
👉 It forces direct-path insert, meaning:
Oracle bypasses the buffer cache
Writes data directly above the high-water mark
Is much faster for large inserts


-- Managing Subqueries and CTEs (With Clauses)

10. MATERIALIZE Hint
MATERIALIZE means: “Run this part once, store its result somewhere temporarily, and reuse it instead of recalculating again.”

Purpose: Forces Oracle to materialize a subquery (execute it and store the result temporarily).
Oracle often rewrites your code (Query Transformation). These hints stop it or force specific behaviors.

WITH Complex_Calc AS (
    SELECT /*+ MATERIALIZE */ dept_id, SUM(salary) total
    FROM employees
    GROUP BY dept_id
)
SELECT d.name, c.total
FROM departments d
JOIN Complex_Calc c ON d.id = c.dept_id;

Forces Oracle to actually run the subquery (or CTE) and store the result in temporary memory before running the main query.
Scenario: You have a complex subquery that is used multiple times in the main query. Without this hint, Oracle might recalculate it multiple times.

Syntax:

SELECT /*+ MATERIALIZE */ column_name
FROM (SELECT * FROM table_name WHERE condition);

Example:

SELECT /*+ MATERIALIZE */ order_id
FROM (SELECT * FROM orders WHERE order_date = '2024-11-01');

Explanation:
This hint ensures that the subquery is executed and stored in a temporary table, which can improve performance in certain scenarios where the subquery result set is reused multiple times.


-- Fixing Bad Estimates
Sometimes Oracle calculates the number of rows (Cardinality) incorrectly, leading to poor join choices.

22. CARDINALITY
You can manually tell Oracle This query returns about X rows.

Scenario: Oracle thinks a complex PL/SQL function filter returns 1 million rows, so it picks a Hash Join. But you know it only returns 5 rows, so a Nested Loop is better.
Example:
sql

SELECT /*+ CARDINALITY(t 5) */ *
FROM My_Table t
WHERE complex_function(t.id) = 1;
Oracle assumes table t returns 5 rows.



11. STAR (SMH) Hint Purpose: Directs Oracle to process the query as if it were a star query (use the fact table in the center with
    dimension tables around it).

Syntax:

SELECT /*+ STAR(query_name) */ column_name
FROM fact_table, dimension_table;

Example:

SELECT /*+ STAR(order_items) */ product_id, order_quantity
FROM order_items, products, categories;

Explanation:
This hint tells Oracle to process the order_items as a central fact table and perform the joins with the products and categories dimension tables in an optimized manner for star schema queries.

-------->https://psoug.org/reference/hints.html

12. ALL_ROWS	
			The ALL_ROWS hint explicitly chooses the cost-based approach to optimize a statement block with a goal of best throughput 
			(that is, minimum total resource consumption).

/*+ ALL_ROWS */

Conclusion:

These are some of the most commonly used Oracle hints. Each hint provides the database optimizer with additional context, allowing it to choose the best execution plan for the query. However, hints should be used carefully since they can override the optimizer’s decisions, and excessive use can lead to inefficient query performance in different contexts. Proper testing and performance monitoring are essential when utilizing hints in your SQL queries.


1.GATHER_PLAN_STATISTICS (SMH)

You can use the GATHER_PLAN_STATISTICS hint to compare the estimated number of rows (E-Rows) with the actual number of rows processed (A-Rows) in the execution plan. 

	SELECT   /*+ GATHER_PLAN_STATISTICS */ p.prod_name, SUM(s.quantity_sold)
	FROM     sales s, products p
	WHERE    s.prod_id =p.prod_id
	AND      p.prod_desc = 'Envoy Ambassador'
	GROUP By p.prod_name ;


BEGIN
	DBMS_STATS.GATHER_TABLE_STATS (null, 'EMP', no_invalidate => false);
	DBMS_STATS.GATHER_TABLE_STATS (null, 'DEPT', no_invalidate => false);
END;
/

	The GATHER_PLAN_STATISTICS hint tells Oracle to collect execution statistics for a SQL statement. These execution statistics are then shown next to the original Optimizer estimates in the execution plan if you use the function DBMS_XPLAN.DISPLAY_CURSOR to display the plan. You also have to set the  FORMAT parameter to 'ALLSTATS LAST' (DBMS_XPLAN.DISPLAY_CURSOR(FORMAT=>'ALLSTATS LAST')). The original Optimizer estimates are shown in the E-Rows column while the actual statistics gathered during execution are shown in the A-Rows column.


Optimizer Modes:
---------------
ALL_ROWS: Optimizes for the fastest completion of the entire query, even if it means potentially sacrificing initial response time. 

13. FIRST_ROWS: Optimizes for the fastest delivery of the first few rows, which is useful for applications that display results in pages or other partial presentations. 



14. FIRST_ROWS(n): Specifies the number of rows to optimize for (e.g., FIRST_ROWS(10) for fetching the first 10 rows). 

This hint causes the optimizer to make these choices:

If an index scan is available, the optimizer may choose it over a full table scan.
If an index scan is available, the optimizer may choose a nested loops join over a sort-merge join whenever the associated table is the potential inner table of the nested loops.
If an index scan is made available by an ORDER BY clause, the optimizer may choose it to avoid a sort operation.
The optimizer ignores this hint in DELETE and UPDATE statement blocks and in SELECT statement blocks that contain any of the following: UNION, INTERSECT, MINUS, UNION ALL, GROUP BY, FOR UPDATE, aggregating function and the DISTINCT operator.

15. RULE - Disables the use of the optimizer. This hint is not supported and should not be used.

16. CACHE - Instructs the optimizer to place the blocks retrieved for the table at the most recently used end of the LRU list   in the buffer cache when a full table scan is performed. This hint is useful for small lookup tables.

set autotrace traceonly exp

SELECT /*+ FULL (hr_emp) CACHE(hr_emp) */ last_name
FROM employees hr_emp;

17. NOCACHE	- Specifies that the blocks retrieved for this table are placed at the least recently used end of the LRU list in the buffer cache when a full table scan is performed. This is the normal behavior of blocks in the buffer cache.

SELECT /*+ FULL(hr_emp) NOCACHE(hr_emp) */ last_name
FROM employees hr_emp;



8. ALL_ROWS Hint (SMH)
Purpose: Directs the optimizer to choose a plan that minimizes the total elapsed time for the query, generally favoring full table scans and large sorts.

Syntax:

SELECT /*+ ALL_ROWS */ column_name
FROM table_name;

Example:

SELECT /*+ ALL_ROWS */ *
FROM employees
WHERE department = 'HR';

Explanation:
This hint advises the optimizer to choose the plan that minimizes the total elapsed time for the query. Oracle may choose a full table scan and optimized sorting operations. It is typically used for large reports or complex queries where response time is more important than avoiding disk I/O.

7. NO_MERGE Hint
Purpose: Prevents the optimizer from merging views or subqueries into the main query.

Syntax:

SELECT /*+ NO_MERGE(view_name) */ column_name
FROM view_name;

Example:

SELECT /*+ NO_MERGE(customer_orders) */ *
FROM customer_orders;

Explanation:
This hint tells Oracle to not merge the customer_orders view into the main query. Merging views can sometimes result in inefficient execution plans, and this hint can help maintain better control over the execution plan.


EXPLAIN PLAN FOR 
SELECT /*+ USE_HASH (EMPLOYEES DEPARTMENTS) */ LOCATION_ID 
FROM EMPLOYEES E,  DEPARTMENTS D
WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, FORMAT=>'ALLSTATS LAST'));--- ALL'));

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, FORMAT=>'ALLSTATS'));

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
----EXPLAIN PLAN FOR 
SELECT /*+ GATHER_PLAN_STATISTICS *//*+ PARALLEL(4) */ E.FIRST_NAME, E.LAST_NAME, E.SALARY, D.DEPARTMENT_NAME, L.LOCATION_ID,
L.CITY
FROM EMPLOYEES E,  DEPARTMENTS D, LOCATIONS L
WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID
AND D.LOCATION_ID = L.LOCATION_ID;

BEGIN
	DBMS_STATS.GATHER_TABLE_STATS (null, 'LOCATIONS', no_invalidate => false);
	DBMS_STATS.GATHER_TABLE_STATS (null, 'DEPARTMENTS', no_invalidate => false);
END;
/


SELECT /*+ ALL_ROWS */ E.FIRST_NAME, E.LAST_NAME, E.SALARY, D.DEPARTMENT_NAME, L.LOCATION_ID,
L.CITY
FROM EMPLOYEES E,  DEPARTMENTS D, LOCATIONS L
WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID
AND D.LOCATION_ID = L.LOCATION_ID;

SELECT * FROM LOCATIONS;

ALTER SESSION SET STATISTICS_LEVEL = ALL;

SET AUTOTRACE ON;

18. The STAR_TRANSFORMATION - hint in Oracle is used to guide the optimizer to favor a star query execution plan, which involves subqueries for dimension tables to filter the fact table instead of joining all tables in the FROM clause. This can be more efficient than full table scans when dimension tables have indexes on their join columns and filter significant data. 
Heres how the star transformation works and an example:


EXPLAIN PLAN FOR 
SELECT /*+ USE_HASH (EMPLOYEES DEPARTMENTS) */ LOCATION_ID 
FROM EMPLOYEES E,  DEPARTMENTS D
WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, FORMAT=>'ALLSTATS LAST'));--- ALL'));

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, FORMAT=>'ALLSTATS'));

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
----EXPLAIN PLAN FOR 
SELECT /*+ GATHER_PLAN_STATISTICS *//*+ PARALLEL(4) */ E.FIRST_NAME, E.LAST_NAME, E.SALARY, D.DEPARTMENT_NAME, L.LOCATION_ID,
L.CITY
FROM EMPLOYEES E,  DEPARTMENTS D, LOCATIONS L
WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID
AND D.LOCATION_ID = L.LOCATION_ID;

BEGIN
	DBMS_STATS.GATHER_TABLE_STATS (null, 'LOCATIONS', no_invalidate => false);
	DBMS_STATS.GATHER_TABLE_STATS (null, 'DEPARTMENTS', no_invalidate => false);
END;
/


SELECT /*+ ALL_ROWS */ E.FIRST_NAME, E.LAST_NAME, E.SALARY, D.DEPARTMENT_NAME, L.LOCATION_ID,
L.CITY
FROM EMPLOYEES E,  DEPARTMENTS D, LOCATIONS L
WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID
AND D.LOCATION_ID = L.LOCATION_ID;

SELECT * FROM LOCATIONS;


How Star Transformation Works:
1. Rewriting the Query:
The optimizer transforms the original query (with joins) into a query where the fact table is in the FROM clause, and dimension tables are used as subqueries in the WHERE clause. 
2. Subquery predicates:
These subqueries act as predicates to filter rows from the fact table based on dimension table values or ranges. 
3. Bitmap Join Operations:
The database uses bitmaps from indexes on the fact tables join columns to perform AND and OR operations on the key values provided by the subqueries. 
4. Efficient Data Retrieval:
This allows the database to retrieve only the relevant rows from the fact table, potentially avoiding full table scans if the dimension table filters are selective. 
Example:
Code

-- Original Query
SELECT s.amount_sold, c.cust_city, t.calendar_quarter_desc
FROM sales s
JOIN customers c ON s.cust_id = c.cust_id
JOIN times t ON s.time_id = t.time_id
WHERE c.cust_state_province = 'CA' AND t.calendar_quarter_desc IN ('1999-01', '1999-02');

-- With STAR_TRANSFORMATION hint
SELECT s.amount_sold, c.cust_city, t.calendar_quarter_desc
/*+ STAR_TRANSFORMATION */
FROM sales s
JOIN customers c ON s.cust_id = c.cust_id
JOIN times t ON s.time_id = t.time_id
WHERE c.cust_state_province = 'CA' AND t.calendar_quarter_desc IN ('1999-01', '1999-02');

-- Example of the transformed query (after the hint is applied by the optimizer)
SELECT s.amount_sold, c.cust_city, t.calendar_quarter_desc
FROM sales s
WHERE s.cust_id IN (SELECT cust_id FROM customers WHERE cust_state_province = 'CA')
  AND s.time_id IN (SELECT time_id FROM times WHERE calendar_quarter_desc IN ('1999-01', '1999-02'));

	In this example, the STAR_TRANSFORMATION hint encourages the optimizer to use subqueries for customers and times tables to filter the sales fact table, potentially improving performance compared to the original query with joins. 

Key Points:
The optimizer only applies the transformation if it considers it beneficial based on cost and available indexes.
The hint doesnt guarantee the transformation will occur, but it increases the likelihood of the optimizer using the star plan.
Star transformation is particularly effective when dimension tables are small and have indexes on the join columns with significant selectivity.

 
------------------->>>>>>  https://psoug.org/reference/hints.html




----------------------------------------------------------------EXCEPTIONS----------------------------------------------------------------------------------------

Predefined exceptions: Oracle gives you ready-to-use (e.g., NO_DATA_FOUND).

User-defined exceptions: You declare your own and raise when needed.

Non-predefined exceptions: Map Oracle error codes using PRAGMA EXCEPTION_INIT.

When Others: Catch-all for unhandled errors.


1. - SYSTEM DEFINED (Predefined exceptions) 

	  Exception						Oracle Error	SQLCODE Value
	ACCESS_INTO_NULL					ORA-06530		-6530
	CASE_NOT_FOUND						ORA-06592		-6592
	COLLECTION_IS_NULL					ORA-06531	    -6531
	CURSOR_ALREADY_OPEN					ORA-06511		-6511
	DUP_VAL_ON_INDEX					ORA-00001		-1
	INVALID_CURSOR						ORA-01001		-1001
	INVALID_NUMBER						ORA-01722		-1722
	LOGIN_DENIED						ORA-01017		-1017
	NO_DATA_FOUND						ORA-01403		+100
	NOT_LOGGED_ON						ORA-01012		-1012
	PROGRAM_ERROR						ORA-06501		-6501
	ROWTYPE_MISMATCH					ORA-06504		-6504
	SELF_IS_NULL						ORA-30625		-30625
	STORAGE_ERROR						ORA-06500		-6500
	SUBSCRIPT_BEYOND_COUNT				ORA-06533		-6533
	SUBSCRIPT_OUTSIDE_LIMIT				ORA-06532		-6532
	SYS_INVALID_ROWID					ORA-01410		-1410
	TIMEOUT_ON_RESOURCE					ORA-00051		-51
	TOO_MANY_ROWS						ORA-01422		-1422
	VALUE_ERROR							ORA-06502		-6502
	ZERO_DIVIDE							ORA-01476		-1476
	
	
EXCEPTION					RAISED WHEN ...
------------				--------------
ACCESS_INTO_NULL			A program attempts to assign values to the attributes of an uninitialized object.
CASE_NOT_FOUND			None of the choices in the WHEN clauses of a CASE statement is selected, and there is no ELSE clause.
COLLECTION_IS_NULL		A program attempts to apply collection methods other than EXISTS to an uninitialized nested table or 										varray, or the program attempts to assign values to the elements of an uninitialized nested table or 									  varray.
CURSOR_ALREADY_OPEN		A program attempts to open an already open cursor. A cursor must be closed before it can be reopened. 											 A cursor FOR loop automatically opens the cursor to which it refers, so your program cannot open that 						  					cursor inside the loop.
DUP_VAL_ON_INDEX			A program attempts to store duplicate values in a database column that is constrained by a unique			      						 index.
INVALID_CURSOR			  A program attempts a cursor operation that is not allowed, such as closing an unopened cursor.
INVALID_NUMBER			  In a SQL statement, the conversion of a character string into a number fails because the string does 						               not represent a valid number. (In procedural statements, VALUE_ERROR is raised.) This exception is 						               also raised when the LIMIT-clause expression in a bulk FETCH statement does not evaluate to a positive 						               number.
LOGIN_DENIED			    A program attempts to log on to Oracle with an invalid username or password.
NO_DATA_FOUND			A SELECT INTO statement returns no rows, or your program references a deleted element in a nested 						           table or an uninitialized element in an index-by table.
						             Because this exception is used internally by some SQL functions to signal that they are finished, you should not rely on this exception being propagated if you raise it within a function that is called a part of a query.
NOT_LOGGED_ON			A program issues a database call without being connected to Oracle.
PROGRAM_ERROR			PL/SQL has an internal problem.
ROWTYPE_MISMATCH   The host cursor variable and PL/SQL cursor variable involved in an assignment have incompatible return 						             types. For example, when an open host cursor variable is passed to a stored subprogram, the return 						             types of the actual and formal parameters must be compatible.
SELF_IS_NULL			   A program attempts to call a MEMBER method, but the instance of the object type has not been 					                  initialized. The built-in parameter SELF points to the object, and is always the first parameter   						         passed to a MEMBER method.
STORAGE_ERROR	        PL/SQL runs out of memory or memory has been corrupted.
SUBSCRIPT_BEYOND_COUNT	A program references a nested table or varray element using an index number larger than the number of 						                   elements in the collection.
SUBSCRIPT_OUTSIDE_LIMIT	A program references a nested table or varray element using an index number (-1 for example) that is 						                  outside the legal range.
SYS_INVALID_ROWID		The conversion of a character string into a universal rowid fails because the character string does 					                 not Represent a valid rowid.
TIMEOUT_ON_RESOURCE		A time-out occurs while Oracle is waiting for a resource.
TOO_MANY_ROWS			A SELECT INTO statement returns more than one row.
VALUE_ERROR				   An arithmetic, conversion, truncation, or size-constraint error occurs. For example, when your program 						              selects a column value into a character variable, if the value is longer than the declared length of   					  				the variable, PL/SQL aborts the assignment and raises VALUE_ERROR. In procedural statements, 						  			VALUE_ERROR is raised if the conversion of a character string into a number fails. (In SQL statements,				 						INVALID_NUMBER is raised.)
ZERO_DIVIDE				A program attempts to divide a number by zero.	


create or replace PROCEDURE PROC_EMPID (E_ID IN NUMBER)
AS
    V_ENAME VARCHAR2(50);
    V_CELL VARCHAR2(30);
     incorrect_eid EXCEPTION;
	BEGIN
        
				begin
					select first_name||' '||last_name, phone_number 
					into v_ename, v_cell 
					from employees 
					where employee_id = e_id;
				   
					exception
					WHEN no_data_found then
					RAISE incorrect_eid;						---🧠 Here using RAISE command within an another Anonymous block.
				end;
        
    DBMS_OUTPUT.PUT_LINE('Employee: ' || V_ENAME);
    DBMS_OUTPUT.PUT_LINE('Phone: ' || V_CELL);

	EXCEPTION

    WHEN incorrect_eid THEN
        RAISE_APPLICATION_ERROR(-20001, 'Employee with ID ' || E_ID || ' not found');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002, 'Unexpected error: ' || SQLERRM);
END;
/


EXECUTE PROC_EMPID(100);
/


CREATE OR REPLACE PROCEDURE PROC_EMP1 (E_ID IN NUMBER)
AS
    V_ENAME VARCHAR2(50);
    V_CELL VARCHAR2(30);
    NO_OUTPUT EXCEPTION;  -- DECLARED EXCEPTION
BEGIN
    BEGIN  -- Nested block
        SELECT FIRST_NAME||' '||LAST_NAME, PHONE_NUMBER 
        INTO V_ENAME, V_CELL 
        FROM EMPLOYEES 
        WHERE EMPLOYEE_ID = E_ID;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE NO_OUTPUT;  -- Convert to your custom exception		---🧠 Here using RAISE command within an another Anonymous block.
    END;
    
    DBMS_OUTPUT.PUT_LINE(V_ENAME||' '||V_CELL);
    
EXCEPTION
    WHEN NO_OUTPUT THEN  -- HANDLE DECLARED EXCEPTION
        RAISE_APPLICATION_ERROR(-20001, 'DATA NOT FOUND for ID: ' || E_ID);
END;
/

EXEC PROC_EMP1(1001);

CREATE OR REPLACE PROCEDURE PROC_EMP (E_ID IN NUMBER)
AS
    V_ENAME VARCHAR2(50);
    V_CELL VARCHAR2(30);
BEGIN
    SELECT FIRST_NAME||' '||LAST_NAME, PHONE_NUMBER 
    INTO V_ENAME, V_CELL 
    FROM EMPLOYEES 
    WHERE EMPLOYEE_ID = E_ID;
      
    DBMS_OUTPUT.PUT_LINE(V_ENAME||' '||V_CELL);
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN  -- HANDLE DECLARED EXCEPTION
        RAISE_APPLICATION_ERROR(-20001, 'DATA NOT FOUND for ID: ' || E_ID);
END;
/


EXECUTE  PROC_EMP(1001);


create or replace PROCEDURE PROC_EMP (E_ID IN NUMBER)
AS
    V_ENAME VARCHAR2(50);
    V_CELL VARCHAR2(30);

    -- DECLARE CUSTOM EXCEPTION
        incorrect_eid EXCEPTION;
        duplicate_values EXCEPTION;
		v_emp_count NUMBER;
BEGIN
    -- 1. Check if employee exists using COUNT
    SELECT COUNT(*)
    INTO v_emp_count
    FROM EMPLOYEES 
    WHERE EMPLOYEE_ID = E_ID;

    -- 2. RAISE custom exception if not found
    IF v_emp_count = 0 THEN
        RAISE incorrect_eid; 
    END IF;

      IF v_emp_count > 1 THEN
        RAISE duplicate_values;
    END IF;

    -- 3. Fetch employee details
    SELECT FIRST_NAME||' '||LAST_NAME, PHONE_NUMBER 
    INTO V_ENAME, V_CELL 
    FROM EMPLOYEES 
    WHERE EMPLOYEE_ID = E_ID;

    -- 4. Process/display data
    DBMS_OUTPUT.PUT_LINE('Employee: ' || V_ENAME);
    DBMS_OUTPUT.PUT_LINE('Phone: ' || V_CELL);

EXCEPTION
    -- 5. HANDLE custom exception
    WHEN incorrect_eid THEN
        RAISE_APPLICATION_ERROR(-20001, 'Employee with ID ' || E_ID || ' not found');

        WHEN duplicate_values THEN
        RAISE_APPLICATION_ERROR(-20002, 'Duplicate values found');

    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002, 'Unexpected error: ' || SQLERRM);
END PROC_EMP;
/


-


🆚 							PRAGMA vs 						RAISE_APPLICATION_ERROR (core difference)
	Aspect						PRAGMA								RAISE_APPLICATION_ERROR
	Purpose			Compiler instruction								Runtime error
	When it works		Compile time										Runtime
	Raises error?			❌ No													✅ Yes
	Used to				Map Oracle errors					Throw business errors
	Message shown to user	❌												✅
	Error range				Oracle errors							-20000 to -20999


	CREATE OR REPLACE PROCEDURE add_new_order
   (order_id_in IN NUMBER, sales_in IN NUMBER)
	IS
	   no_sales EXCEPTION;

	BEGIN
	   IF sales_in = 0 THEN
		  RAISE no_sales;

	   ELSE
		  INSERT INTO orders (order_id, total_sales )
		  VALUES ( order_id_in, sales_in );
	   END IF;

	EXCEPTION
	   WHEN no_sales THEN
		  raise_application_error (-20001,'You must have sales in order to submit the order.');

	   WHEN OTHERS THEN
		  raise_application_error (-20002,'An error has occurred inserting an order.');

	END;
	
	
	
	   DECLARE  ---------- sub-block begins
      past_due EXCEPTION;  -- this declaration prevails
      acct_num NUMBER;
     due_date DATE := SYSDATE - 1;
     todays_date DATE := SYSDATE;
     BEGIN
      IF due_date < todays_date THEN
         RAISE past_due;  -- this is not handled
      END IF;
    END;  ------------- sub-block ends
	EXCEPTION
	   WHEN past_due THEN  -- does not handle RAISEd exception
		  dbms_output.put_line('Handling PAST_DUE exception.');
	   WHEN OTHERS THEN
		 dbms_output.put_line('Could not recognize PAST_DUE_EXCEPTION in this scope.');
	END;
	/
	
	
-------------------Pragma EXCEPTION_INIT----------------------

3. Non-predefined exceptions: Map Oracle error codes using PRAGMA EXCEPTION_INIT.

🏆Interview-ready definition 

🧠A PRAGMA in Oracle is a compiler directive, that provides special instructions to the PL/SQL compiler to control compilation or runtime 	behavior of PL/SQL programs

🧠We use PRAGMA EXCEPTION_INIT only when Oracle already raises an error having an error number, but we want to handle it with a meaningful, business-friendly exception name.

🧠 For this PRAGMA EXCEPTION_INIT we dont need the RAISE command as is used in case of USER DEFINED - RAISE_APPLICATION_ERROR	


PRAGMA EXCEPTION_INIT(exception_name, -Oracle_error_number);


DECLARE
   deadlock_detected EXCEPTION;
   PRAGMA EXCEPTION_INIT(deadlock_detected, -60);
BEGIN
   UPDATE EMP SET SALARY=45000 WHERE JOB_ID = 'IT_PROG'; -- Some operation that causes an ORA-00060 error
EXCEPTION
   WHEN deadlock_detected THEN
      null; -- handle the error
END;
/


DECLARE
    NULL_VALUE EXCEPTION;
    PRAGMA EXCEPTION_INIT (NULL_VALUE, -01400);  --Associate e_my_error with ORA-1400 Insertion of null value in a Not NUll cL
    FOR_KEY EXCEPTION;
    PRAGMA EXCEPTION_INIT(FOR_KEY, -02291);
BEGIN
    -- Some code that might raise ORA-1400
    -- ...
    INSERT INTO EMPLOYEES (EMPLOYEE_ID, FIRST_NAME, last_name, EMAIL, HIRE_DATE, JOB_ID) VALUES (300, 'Sameer','Ahmad','sameer.ahmad@gmail.com',TO_DATE('01-03-88','DD-MM-YY'),'Manager');
    -- ...

EXCEPTION
    WHEN NULL_VALUE THEN
        DBMS_OUTPUT.PUT_LINE('Error: Null value enetered to a NOT NULL col');
     WHEN FOR_KEY THEN
        DBMS_OUTPUT.PUT_LINE('Error: Integrity Constraint violated');    
    WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE('Error:  Unexpected error occurred');
END;
/


DECLARE
  e_dup EXCEPTION;
  PRAGMA EXCEPTION_INIT(e_dup, -1); -- ORA-00001
BEGIN
  INSERT INTO emp(empno, sal) VALUES (1001, -500);
EXCEPTION
  WHEN e_dup THEN
    RAISE_APPLICATION_ERROR(-20001,'Employee number already exists' );
END;
/


ORA-02449	-> PARENT CHILD RELATIONSHIP EXISTS & DROPPING THE PARENT TABLE	
ORA-01400	-> NULL VALUES BEING ENTERED INTO A NOT NULL col
ORA-02291	-> INTEGRITY CONSTRAINT VIOLATED

/*
To handle error conditions (typically ORA-messages) that have no predefined name, 
we must use the OTHERS handler or the pragma EXCEPTION_INIT.

A pragma is a compiler directive that is processed at compile time, not at run time.

In PL/SQL, the pragma EXCEPTION_INIT tells the compiler to associate an exception name with an Oracle error number. 
That lets you refer to any internal exception by name and to write a specific handler for it. When you see an error stack, or sequence of error messages, the one on top is the one that you can trap and handle.

You code the pragma EXCEPTION_INIT in the declarative part of a PL/SQL block, subprogram, or package using the syntax

The EXCEPTION_INIT pragma in PL/SQL associates a user-defined exception with a specific Oracle error number
*/

-------------------------RE-RAISING EXCEPTIONS---------------------


DECLARE
   salary_too_high  EXCEPTION;
   current_salary NUMBER := 20000;
   max_salary NUMBER := 10000;
   erroneous_salary NUMBER;
BEGIN
   BEGIN  ---------- sub-block begins
      IF current_salary > max_salary THEN
         RAISE salary_too_high;  -- raise the exception
      END IF;
   EXCEPTION
      WHEN salary_too_high THEN
         -- first step in handling the error
        dbms_output.put_line('Salary ' || erroneous_salary ||
          ' is out of range.');
        dbms_output.put_line('Maximum salary is ' || max_salary || '.');
         RAISE;  -- reraise the current exception
   END;  ------------ sub-block ends
EXCEPTION
   WHEN salary_too_high THEN
      -- handle the error more thoroughly
      erroneous_salary := current_salary;
      current_salary := max_salary;
     dbms_output.put_line('Revising salary from ' || erroneous_salary ||
       'to ' || current_salary || '.');
END;
/

DESC EMPLOYEES;

SET SERVEROUTPUT ON;


SELECT *FROM EMPLOYEES;

SELECT * FROM ALL_CONSTRAINTS WHERE OWNER='HR';

DESC EMPLOYEES;

SET SERVEROUTPUT ON;


SELECT *FROM EMPLOYEES;

SELECT * FROM ALL_CONSTRAINTS WHERE OWNER='HR';

