--1

create table EMPLOYS
   (employee_id number(6,0), 
 first_name varchar2(20 byte),
 last_name varchar2(25 byte) not null enable, 
 email varchar2(25 byte) not null enable, 
 phone_number varchar2(20 byte), 
 hire_date date not null enable, 
 job_id varchar2(10 byte) not null enable, 
 salary number(8,2), 
 commission_pct number(2,2), 
 manager_id number(6,0), 
 department_id number(4,0)
   )
   PARTITION BY LIST(JOB_ID) 
   --INTERVAL (NUMTOYMINTERVAL(1, 'MONTH'))
   (
    PARTITION P1 VALUES ('AC_ACCOUNT','AC_MGR','AD_ASST','AD_PRES'),
    PARTITION P2 VALUES ('AD_VP','FI_ACCOUNT','FI_MGR','HR_REP'),
    PARTITION P3 VALUES ('IT_PROG','MK_MAN','MK_REP','PR_REP'),
    PARTITION P4 VALUES ('PU_CLERK','PU_MAN','SA_MAN','SA_REP'),
    PARTITION P5 VALUES ('SH_CLERK','ST_CLERK','ST_MAN'),
    PARTITION PO VALUES (DEFAULT)
    );    
    
   DROP TABLE EMPLOYS;
   SELECT DISTINCT(JOB_ID) FROM EMP;
   SELECT * FROM EMPLOYS PARTITION (PO);
   
   INSERT INTO EMPLOYS VALUES (314	,'Don','Saphaely','SDRAHEAL','515.127.456',to_date('07-12-2002','dd-mm-yyyy'),'TEST',11000,null,100,30);
   SELECT * FROM EMPLOYS WHERE JOB_ID='TEST';
   /
   
   
   CREATE TABLE orders (
  order_id   NUMBER,
  order_date DATE,
  amount     NUMBER
)
PARTITION BY RANGE (order_date)
INTERVAL (NUMTOYMINTERVAL(1, 'MONTH'))   -- 👈 AUTOMATIC part
(
  PARTITION P1 VALUES LESS THAN (DATE '2024-01-01'),
    PARTITION P2 VALUES LESS THAN (DATE '2024-02-01'),
      PARTITION P3 VALUES LESS THAN (DATE '2024-03-01')
);

   INSERT INTO orders VALUES (1,TO_DATE('23-12-24','DD-MM-YY'),100);
      INSERT INTO orders VALUES (1,TO_DATE('13-02-24','DD-MM-YY'),200);
      
      SELECT * FROM ORDERS PARTITION (SYS_P569);
      SELECT * FROM USER_TAB_PARTITIONS;
	

CREATE TABLE ord (
  order_id   NUMBER,
  order_date DATE,
  amount     NUMBER
)
PARTITION BY RANGE (order_date)
INTERVAL (NUMTOYMINTERVAL(1, 'YEAR'))   -- 👈 AUTOMATIC part
(
  PARTITION P1 VALUES LESS THAN (DATE '2023-01-01'),
    PARTITION P2 VALUES LESS THAN (DATE '2024-01-01'),
      PARTITION P3 VALUES LESS THAN (DATE '2025-01-01')
);

   INSERT INTO ord VALUES (1,TO_DATE('23-12-25','DD-MM-YY'),100);
      INSERT INTO ord VALUES (1,TO_DATE('13-02-23','DD-MM-YY'),200);      
      
      SELECT * FROM USER_TAB_PARTITIONS;
      SELECT * FROM ORD

--------------------------------------


CREATE TABLE orders (
  order_id   NUMBER,
  order_date DATE,
  cust_id    NUMBER,
  amount     NUMBER
)
PARTITION BY RANGE (order_date)
INTERVAL (NUMTOYMINTERVAL(1,'MONTH'))
SUBPARTITION BY HASH (cust_id)
SUBPARTITIONS 4
(
  PARTITION p_jan VALUES LESS THAN (DATE '2024-01-01'),
  PARTITION p_feb VALUES LESS THAN (DATE '2024-02-01'),
  PARTITION p_mar VALUES LESS THAN (DATE '2024-03-01')
);	  
	

--------------------------LOCAL n GLOBAL INDEX------------------------


Index Type									How It Works														Partition Pruning Behavior
Local Index	Each partition of the table has its own corresponding index partition. Index partitions are aligned with table partitions.	When 			Oracle prunes table partitions, it automatically prunes the 
					matching index partitions too. This makes local indexes 
					highly efficient for partition pruning.
Global Index																									A single index structure spans across all table 																												partitions. It is not aligned with table partitions.																												Partition pruning cannot eliminate parts of the global index																													, because the index covers rows across all partitions. 																												Oracle may still prune table partitions, but the global 																														index must be scanned more broadly.

	
🔹 LOCAL INDEX (Partition-aligned)

What it means
Index is partitioned the same way as the table

P1						P2					P3						P4
IDX_LOCAL		IDX_LOCAL		IDX_LOCAL		IDX_LOCAL
One index partition per table partition
Automatically maintained

Local index example

CREATE INDEX idx_orders_date
ON orders (order_date)
LOCAL;


What happens internally:

orders partition  → index partition
Jan 2024          → idx partition Jan 2024
Feb 2024          → idx partition Feb 2024


✔ Partition pruning works
✔ Index pruning works
✔ Safe with automatic partitions
✔ Best choice for composite tables

Query example
SELECT *
FROM orders
WHERE order_date = DATE '2024-02-10';


Execution plan:

PARTITION RANGE SINGLE
INDEX RANGE SCAN (LOCAL)


🔥 Only one table partition + one index partition accessed

Local index on subpartition key
CREATE INDEX idx_orders_cust
ON orders (cust_id)
LOCAL;


✔ One index per table partition
✔ Inside each partition → covers all subpartitions

------------------------------------------------------------------------------

🔸 GLOBAL INDEX (Across all partitions)
What it means

Single index structure
Spans all partitions
Not aligned with table partitions

Global index example
-------------------------------
CREATE INDEX idx_orders_oid
ON orders (order_id)
GLOBAL;


Internally:

ONE index → points to rows in ALL partitions

Query example
SELECT *
FROM orders
WHERE order_id = 1001;


Execution plan:

INDEX UNIQUE SCAN (GLOBAL)
TABLE ACCESS BY ROWID


✔ Fast for single-row lookups
❌ No partition pruning benefit
❌ Dangerous with partition maintenance

🚨 Big difference during partition maintenance
Interval partition added automatically
INSERT INTO orders
VALUES (1001, DATE '2024-04-10', 200, 5000);

With LOCAL index

✔ Index partition created automatically
✔ Index remains usable
✔ No DBA action required

With GLOBAL index

❌ Index may become UNUSABLE
❌ Requires rebuild

ALTER INDEX idx_orders_oid REBUILD;


This is why GLOBAL indexes are risky in composite + INTERVAL tables.

🧠 Composite-specific behavior
Feature										LOCAL Index												GLOBAL Index
Partition pruning								✅ Yes															❌ No
Subpartition pruning							✅ Yes															❌ No
Interval partition safe						✅ Yes															❌ No
Auto-maintained								✅ Yes															❌ No
OLTP point lookup							❌ Slower														✅ Faster


When to use WHAT?
✅ Use LOCAL indexes when:

Table is RANGE / INTERVAL / COMPOSITE

Queries filter on partition key


Frequent partition maintenance

Data warehouse / large OLTP

👉 Default choice (90% cases)

⚠️ Use GLOBAL indexes when:

Query always filters by non-partition key

Point lookups (order_id = ?)

Very selective predicates

You accept rebuild cost

👉 Use sparingly
	  
	  -------------------------------------------------------------------------------------------------------------------------


Enter user-name: conn /as sysdba
Enter password:

Connected to:
Oracle Database 21c Enterprise Edition Release 21.0.0.0.0 - Production
Version 21.3.0.0.0

-----------------------------------------------------------------------------

ENABLE ROW MOVEMENT IS USED WHERE IN ORACLE...?

Thought Process


ENABLE ROW MOVEMENT is primarily used in two specific scenarios in Oracle:

Updating the Partition Key (Partitioned Tables)
Flashback Table Operations
Here is the simple explanation of why it is needed in these situations.

1. Updating the Partition Key (Partitioned Tables)
This is the most common technical use case.

The Scenario:
Imagine you have a table called SALES partitioned by YEAR. All rows for the year 2022 are in the SALES_2022 partition, and rows for 2023 are in SALES_2023.

The Problem:
If you try to update a rows year from 2022 to 2023, that row physically needs to move from the SALES_2022 data block to the SALES_2023 data block.

By default, Oracle prevents this because it changes the Rowid of the row. You will get this error:

ORA-14402: updating partition key column would cause a partition change

The Solution:
You must enable row movement to allow the row to migrate to the new partition.

sql

ALTER TABLE sales ENABLE ROW MOVEMENT;

-- Now this command works:
UPDATE sales SET year = 2023 WHERE year = 2022;
Oracle handles this internally as a DELETE from the old partition followed by an INSERT into the new partition.

2. Flashback Table Operations
The Scenario:
You (or someone else) accidentally deleted data or dropped a table, and you want to rewind the table to a specific time using the FLASHBACK TABLE command.

The Problem:
When Oracle restores rows to a previous state (e.g., restores a row that was deleted 1 hour ago), it often cannot put the row back into the exact same physical memory block (Rowid) it occupied before, because that space might have been taken by new data.

The Solution:
Oracle needs the freedom to place that restored row in a new location. Therefore, Row Movement must be enabled.

sql

ALTER TABLE my_table ENABLE ROW MOVEMENT;

-- Now this command works:
FLASHBACK TABLE my_table TO TIMESTAMP SYSTIMENAL - INTERVAL 1 HOUR;
Important Warning: Performance
While enabling row movement is powerful, remember that it updates the Rowids.

If your application relies on Rowids (using the ROWID pseudocolumn) for rapid access, enabling row movement can break that logic because the Rowid of a row can change without the application knowing.
Partition updates (Scenario 1) generate more Redo/Undo logs because they act as a Delete + Insert.



-------------------------------------------------------------------------



SQL> alter session set container=orclpdb;

Session altered.
https://copilot.microsoft.com/chats/7w1Styqo4vmBrX7G9Ma7c
SQL> startup;
Pluggable Database opened.
SQL>

https://copilot.microsoft.com/chats/7w1Styqo4vmBrX7G9Ma7c

https://oracle-base.com/articles/12c/online-conversion-of-a-non-partitioned-table-to-a-partitioned-table-12cr2

CREATE TABLE WOTH THE SAME STRUCTIRE AS THAT OF THE TABLE (ACCOUNTS) ON WHIHC PARTITION NEEDS TO CREAED--

CREATE TABLE accounts_tmp
  ( id             NUMBER
   , account_number NUMBER
   , customer_id    NUMBER
   , branch_id      NUMBER
   , region         VARCHAR(2)
   , status         VARCHAR2(1)
    )
   PARTITION BY LIST (status)
  ( PARTITION statusB VALUES (B),
     PARTITION statusA VALUES (A),
     PARTITION statusG VALUES (G)
    );
 
Table created.


--2
exec dbms_redefinition.start_redef_table(USER, ACCOUNTS, ACCOUNTS_TMP);
 
PL/SQL procedure successfully completed.


select * from accounts_tmp;

  ID ACCOUNT_NUMBER CUSTOMER_ID  BRANCH_ID RE S
---------- -------------- ----------- ---------- -- -
         2            112          31        505 US B
         3            113          56        688 UK B
         1            111          23        505 US G



---3


Run dbms_redefinition.copy_table_dependents to copy the dependent objects of the original table onto the interim table
COPY_TABLE_DEPENDENTS clones the dependent objects (such as triggers, indexes, materialized view logs, grants, constraints)
 and statistics from the original table to the interim table.
 

SQL> -- Clone table dependents from original table
SQL> -- to interim table
SQL> declare
  2     v_err    NUMBER := 0;
  3  begin
  4    dbms_redefinition.copy_table_dependents
  5      (USER, ACCOUNTS, ACCOUNTS_TMP,
  6       copy_indexes => dbms_redefinition.cons_orig_params,
  7       num_errors   => v_err);
  8    dbms_output.put_line(Error count: || v_err);
  9  end;
 10  /
Error count: 0
 
PL/SQL procedure successfully completed. 


--4

Run dbms_redefinition.finish_redef_table to complete the redefinition process
FINISH_REDEF_TABLE completes the redefinition process.

SQL> -- Finish the redefinition process
SQL> exec dbms_redefinition.finish_redef_table(USER, ACCOUNTS, ACCOUNTS_TMP);
 
PL/SQL procedure successfully completed.


--5

SQL> -- AFTER: Check if original table is partitioned
SQL> select table_name
  2       , partitioned
  3  from user_tables
  4  where table_name like ACCOUNTS;
 
TABLE_NAME    PARTITIONED
------------- --------------
ACCOUNTS      YES
 
SQL> -- Check partitioning details
SQL> select partition_name
  2       , partition_position
  3  from user_tab_partitions
  4  where table_name = ACCOUNTS;
 
PARTITION_NAME       PARTITION_POSITION
-------------------- ------------------
STATUSB                               1
STATUSA                               2
STATUSG                               3

SQL> -- Redefinition done: non-partitioned table converted to partitioned
SQL> select dbms_metadata.get_ddl( TABLE, ACCOUNTS)
  2  from dual;
  
  You will see that the NOT NULL constraints are marked NOVALIDATE. 
  According to Doc ID 1089860.1, constraints are copied in NOVALIDATE mode in order to speed up the redefinition process.
  
  --> NOT NULL ENABLE NOVALIDATE,
  
--6

SQL> select constraint_name
  2        ,constraint_type
  3        ,validated
  4  from user_constraints
  5  where table_name = ACCOUNTS;
 
CONSTRAINT_NAME  C VALIDATED
---------------- - -------------
SYS_C0027391674  C NOT VALIDATED
SYS_C0027391675  P VALIDATED


--7
After redefinition, you can run ALERT TABLE ENABLE VALIDATE to enable the NOT NULL constraint. 
Here’s a dynamic SQL script to do it for multiple constraints in one go:

SQL> -- Script to enable constraints for VALIDATE
SQL> begin
  2    for uc in
  3      (select table_name
  4             ,constraint_name
  5       from user_constraints
  6       where table_name = ACCOUNTS ) loop
  7      execute immediate alter table 
  8                     || uc.table_name
  9                     || enable validate constraint 
 10                     || uc.constraint_name;
 11    end loop;
 12  end;
 13  /
 
PL/SQL procedure successfully completed.


--8

SQL> -- After enabling constraints for VALIDATE
SQL> select constraint_name
  2        ,constraint_type
  3        ,validated
  4  from user_constraints
  5  where table_name = ACCOUNTS;
 
CONSTRAINT_NAME  C VALIDATED
---------------- - -------------
SYS_C0027391674  C VALIDATED
SYS_C0027391675  P VALIDATED


--9
Drop the interim table
Now that the original table has got the partitions as we wanted, the interim table can be dropped.


SQL> -- Drop the interim table
SQL> drop table accounts_tmp;
 
 
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------




sql
CREATE TABLE sales (
    sale_id     NUMBER,
    sale_date   DATE,
    amount      NUMBER
)
PARTITION BY RANGE (sale_date) 
(
    PARTITION sales_2023 VALUES LESS THAN (TO_DATE(01-JAN-2024,DD-MON-YYYY)),
    PARTITION sales_2024 VALUES LESS THAN (TO_DATE(01-JAN-2025,DD-MON-YYYY)),
    PARTITION sales_max  VALUES LESS THAN (MAXVALUE)
);


📋 2. List Partitioning
Used when data is grouped by discrete values (e.g., region, category).

sql
CREATE TABLE customers (
    customer_id NUMBER,
    region      VARCHAR2(20)
)
PARTITION BY LIST (region) (
    PARTITION north VALUES (NORTH),
    PARTITION south VALUES (SOUTH),
    PARTITION east  VALUES (EAST),
    PARTITION west  VALUES (WEST),
    PARTITION other VALUES (DEFAULT)
);


🔢 3. Hash Partitioning
Used for evenly distributing data across partitions when values are not naturally grouped.

sql
CREATE TABLE employees (
    emp_id   NUMBER,
    name     VARCHAR2(100)
)
PARTITION BY HASH (emp_id)
PARTITIONS 4;
This creates 4 partitions with hashed distribution based on emp_id.


🧬 4. Composite Partitioning (Range + Hash)
Combines two strategies—typically range for time and hash for load balancing.

sql
CREATE TABLE orders (
    order_id    NUMBER,
    order_date  DATE,
    customer_id NUMBER
)
PARTITION BY RANGE (order_date)
SUBPARTITION BY HASH (customer_id)
SUBPARTITIONS 4
(
    PARTITION orders_q1 VALUES LESS THAN (TO_DATE(01-APR-2025,DD-MON-YYYY)),
    PARTITION orders_q2 VALUES LESS THAN (TO_DATE(01-JUL-2025,DD-MON-YYYY)),
    PARTITION orders_q3 VALUES LESS THAN (TO_DATE(01-OCT-2025,DD-MON-YYYY)),
    PARTITION orders_q4 VALUES LESS THAN (TO_DATE(01-JAN-2026,DD-MON-YYYY))
);


🧠 Bonus: Interval Partitioning (Automatic Range)
Introduced in Oracle 11g for automatic range partition creation.

sql
CREATE TABLE logs (
    log_id    NUMBER,
    log_date  DATE
)
PARTITION BY RANGE (log_date)
INTERVAL (NUMTOYMINTERVAL(1, MONTH)) (
    PARTITION logs_start VALUES LESS THAN (TO_DATE(01-JAN-2025,DD-MON-YYYY))
);
Oracle will automatically create monthly partitions as new data arrives.

Would you like help choosing the best partitioning strategy for your use case? Just share your table structure or data distribution goals.

What happens to partitions when I delete data?
Great question! In Oracle, deleting data from a partitioned table affects rows, not the partition structure itself. Heres a breakdown of what happens and what you can do:

🧹 What Happens When You Delete Data from a Partition?
Only rows are removed, not the partition itself.

The partition remains in the table, even if it becomes empty.

Indexes on the partition are updated accordingly.

Statistics may become stale and should be refreshed if needed.

Example:

sql
DELETE FROM sales PARTITION (sales_2023) WHERE amount < 100;
This deletes rows from the sales_2023 partition but does not drop the partition.

🧨 If You Want to Remove the Entire Partition
Use the DROP PARTITION command:

sql
ALTER TABLE sales DROP PARTITION sales_2023;
This:

Deletes all data in that partition.

Removes the partition structure itself.

Is faster than a row-by-row delete (especially for large partitions).

May require index maintenance or rebuilding.

🧼 If You Want to Empty a Partition but Keep It
Use TRUNCATE PARTITION:

sql
ALTER TABLE sales TRUNCATE PARTITION sales_2023;
This:

Removes all rows from the partition.

Keeps the partition definition intact.

Is much faster than DELETE.

🔍 Best Practices
Use TRUNCATE PARTITION for performance when clearing data.

Use DROP PARTITION only if you no longer need that partition.

Always update statistics after large deletes or truncates:

sql
EXEC DBMS_STATS.GATHER_TABLE_STATS(schema_name, sales);
Would you like help automating partition cleanup based on date or size? I can show you how to use partition maintenance scripts or even interval partitioning for that.

syntax for creating all the different partitions on table in Oracle having automatically creating new partition when needed
Perfect! If youre looking for automatic partition creation in Oracle, youre talking about Interval Partitioning — a powerful feature that extends Range Partitioning by automatically creating new partitions as data arrives.

Let’s walk through the syntax for different types of auto-expanding partitioned tables:

🧭 1. Interval Partitioning (Range-Based, Auto-Creation)
This is the most common method for automatic partition creation.

sql
CREATE TABLE sales (
    sale_id     NUMBER,
    sale_date   DATE,
    amount      NUMBER
)
PARTITION BY RANGE (sale_date)
INTERVAL (NUMTOYMINTERVAL(1, MONTH)) -- Automatically creates monthly partitions
(
    PARTITION sales_start VALUES LESS THAN (TO_DATE(01-JAN-2025,DD-MON-YYYY))
);
🔹 How It Works:
You define a starting partition.

Oracle automatically creates new partitions each month as new data arrives beyond the defined range.

You can use other intervals like:

NUMTODSINTERVAL(1, DAY) – daily

NUMTOYMINTERVAL(1, YEAR) – yearly

🧬 2. Interval + Subpartitioning (Composite Partitioning)
You can combine interval partitioning with subpartitioning (e.g., hash or list) for more control.

sql
CREATE TABLE orders (
    order_id    NUMBER,
    order_date  DATE,
    region      VARCHAR2(20)
)
PARTITION BY RANGE (order_date)
INTERVAL (NUMTOYMINTERVAL(1, MONTH))
SUBPARTITION BY LIST (region) (
    PARTITION orders_start VALUES LESS THAN (TO_DATE(01-JAN-2025,DD-MON-YYYY))
    (
        SUBPARTITION north VALUES (NORTH),
        SUBPARTITION south VALUES (SOUTH),
        SUBPARTITION other VALUES (DEFAULT)
    )
);
🔹 How It Works:
Oracle creates a new range partition each month.

Each new partition automatically includes the defined subpartitions.

🧪 3. Hybrid: Interval + Virtual Columns (Advanced Use)
You can use virtual columns to partition by derived values like year or month.

sql
CREATE TABLE logs (
    log_id     NUMBER,
    log_date   DATE,
    log_month  GENERATED ALWAYS AS (TRUNC(log_date, MM)) VIRTUAL
)
PARTITION BY RANGE (log_month)
INTERVAL (NUMTOYMINTERVAL(1, MONTH))
(
    PARTITION logs_start VALUES LESS THAN (TO_DATE(01-JAN-2025,DD-MON-YYYY))
);
This lets you partition by month start dates automatically.

🧠 Notes & Best Practices
Interval partitioning is available from Oracle 11g onward.

You must define at least one initial partition.

Oracle will not retroactively create partitions for existing data — only for new inserts.

Works best with date/time columns.

Would you like help designing a partition strategy based on your data volume or retention policy? I can even help you script automatic cleanup of old partitions.


Edit in a page
adding a new partition to an existing list partition table
To add a new partition to an existing list-partitioned table in Oracle, you use the ALTER TABLE ... ADD PARTITION command. Heres how it works:

🧾 Syntax for Adding a List Partition
sql
ALTER TABLE table_name
ADD PARTITION partition_name VALUES (new_value);
🧪 Example
Suppose you have a table customers partitioned by region:

sql
CREATE TABLE customers (
    customer_id NUMBER,
    region      VARCHAR2(20)
)
PARTITION BY LIST (region) (
    PARTITION north VALUES (NORTH),
    PARTITION south VALUES (SOUTH)
);
To add a new partition for the EAST region:

sql
ALTER TABLE customers
ADD PARTITION east VALUES (EAST);
⚠️ Important Notes
You cannot add values to an existing partition — each value must be unique across partitions.

If you want to handle unexpected or undefined values, you can add a default partition:

sql
ALTER TABLE customers
ADD PARTITION other VALUES (DEFAULT);
If the table has subpartitions, you must define them when adding the new partition.

🧩 Adding Multiple Values
You can add multiple values to a single partition:

sql
ALTER TABLE customers
ADD PARTITION central VALUES (CENTRAL, MIDWEST);
Would you like help scripting a dynamic partition addition based on incoming data? I can show you how to automate it with PL/SQL or triggers.



----PARTITIONING ANON PARTITOINED TABLE----------

CREATE TABLE EMP (
    HIRE_DATE DATE,
    EMP_ID NUMBER
);

SELECT * FROM EMP;
INSERT INTO EMP VALUES (TO_DATE(11-JUN-2026,DD-MON-YYYY), 103);

ALTER TABLE EMP MODIFY
  PARTITION BY RANGE (HIRE_DATE) 
  INTERVAL (NUMTOYMINTERVAL(1,YEAR)) --AUTOMATIC --INTERVAL (1000)
  ( PARTITION P1 VALUES LESS THAN (to_date(01-JAN-2021,dd-mon-yyyy)),
    PARTITION P2 VALUES LESS THAN (to_date(01-JAN-2022,dd-mon-yyyy)),
    PARTITION P3 VALUES LESS THAN (to_date(01-JAN-2023,dd-mon-yyyy)),
    PARTITION P4 VALUES LESS THAN (to_date(01-JAN-2024,dd-mon-yyyy))
);

SELECT * FROM USER_TAB_PARTITIONS;
DROP TABLE EMP;

SELECT * FROM EMP;

ALTER TABLE EMP MODIFY
  PARTITION BY RANGE (HIRE_DATE) --AUTOMATIC --INTERVAL (1000)
  ( PARTITION P1 VALUES LESS THAN (to_date(01042010,ddmmyyyy)),
    PARTITION P2 VALUES LESS THAN (to_date(01042013,ddmmyyyy)),
    PARTITION P3 VALUES LESS THAN (to_date(01042015,ddmmyyyy)),
    PARTITION P4 VALUES LESS THAN (to_date(01042017,ddmmyyyy))
);

     SELECT * FROM EMP PARTITION (P4); 
     ALTER TABLE EMP DROP PARTITION P4;
     
     ALTER TABLE EMP DROP IF EXISTS PARTITION (P1,P2,P3,P4);
     
     alter table EMP set interval ( numtoyminterval (1,MONTH) );
     select partition_name, interval
   from   user_tab_partitions
   where  table_name = EMP;
/*
   (PARTITION P5 VALUES >= 20000
   );
   
   /*ONLINE
  UPDATE INDEXES
 ( IDX1_SALARY LOCAL,
   IDX2_EMP_ID GLOBAL PARTITION BY RANGE (employee_id)
  ( PARTITION IP1 VALUES LESS THAN (MAXVALUE))
 );
 */
 
 
 DROP TABLE EMP;
 
 
 CREATE TABLE EMP AS SELECT * FROM EMPLOYEES;
 
 SELECT * FROM EMP;
 
 ALTER TABLE EMP
 MODIFY
 PARTITION BY RANGE (SALARY)
 (
 PARTITION P1_5K VALUES LESS THAN (5000),
 PARTITION P1_10K VALUES LESS THAN (10000),
 PARTITION P1_MAX VALUES LESS THAN (MAXVALUE)
 );
 
 SELECT * FROM EMP PARTITION(P1_10K) WHERE DEPARTMENT_ID =100;
 
 
  ALTER TABLE EMP
 MODIFY
 PARTITION BY RANGE (SALARY) --AUTOMATIC
 (
 PARTITION P_5K VALUES LESS THAN (5000),
 PARTITION P_10K VALUES LESS THAN (10000),
 PARTITION P_15K VALUES LESS THAN (15000),
 PARTITION P_20K VALUES LESS THAN (20000),
  PARTITION P_MAX VALUES LESS THAN (MAXVALUE)
 )
 ;
 
 DESC EMP;
ALTER TABLE EMP MODIFY (LAST_NAME NULL, EMAIL NULL, HIRE_DATE NULL, JOB_ID NULL);
 SELECT * FROM EMP;
 INSERT INTO EMP (EMPLOYEE_ID, FIRST_NAME, SALARY, JOB_ID) VALUES (207,Sameer,30001,TEST);
 
 SELECT * FROM EMP PARTITION (P_MAX);
     ALTER TABLE EMP DROP PARTITION P_MAX;
     
     SELECT PARTITION_NAME, HIGH_VALUE  FROM USER_TAB_PARTITIONS
     WHERE TABLE_NAME=EMP;
     
     SELECT * FROM EMP;
     SELECT DISTINCT(JOB_ID) FROM EMP;
     
     
ALTER TABLE EMP    
MODIFY
PARTITION BY LIST(JOB_ID)
     (
     PARTITION P1 VALUES (IT_PROG,PU_CLERK,ST_CLERK,SH_CLERK,AD_ASST,FI_ACCOUNT),
     PARTITION P2 VALUES (ST_MAN,SA_REP,MK_REP,HR_REP,AC_ACCOUNT),
     PARTITION P3 VALUES (FI_MGR,PU_MAN,SA_MAN,MK_MAN,PR_REP),
     PARTITION P4 VALUES (AC_MGR,AD_VP,AD_PRES),
	 PARTITION PD VALUES (DEFAULT)
     );
     
     DESC EMP;
     
     SELECT * FROM EMP PARTITION (P_MAX);
     
     
EXEC DBMS_STATS.gather_table_stats(NULL, EMP);


SELECT table_name, partition_name, num_rows
FROM   user_tab_partitions
ORDER BY 1,2; 

----------------------------------------------------------


CREATE TABLE t1 (
  id           NUMBER,
  description  VARCHAR2(50),
  created_date DATE,
  CONSTRAINT t1_pk PRIMARY KEY (id)
);

CREATE INDEX t1_created_date_idx ON t1(created_date);

INSERT INTO t1
SELECT level,
       Description for  || level,
       ADD_MONTHS(TO_DATE(01-JAN-2017, DD-MON-YYYY), -TRUNC(DBMS_RANDOM.value(1,4)-1)*12)
FROM   dual
CONNECT BY level <= 10000;
COMMIT;


SELECT * FROM T1;


SELECT created_date, COUNT(*)
FROM   t1
GROUP BY created_date
ORDER BY 1;

ALTER TABLE t1 MODIFY
  PARTITION BY RANGE (created_date) (
    PARTITION t1_part_2015 VALUES LESS THAN (TO_DATE(01-JAN-2016,DD-MON-YYYY)),
    PARTITION t1_part_2016 VALUES LESS THAN (TO_DATE(01-JAN-2017,DD-MON-YYYY)),
    PARTITION t1_part_2017 VALUES LESS THAN (TO_DATE(01-JAN-2018,DD-MON-YYYY))
  );
  
  INSERT INTO T1 VALUES (10001, Desc fro 10001,TO_DATE(01-01-18,DD-MM-YY));




SELECT LEVEL, 
TRUNC(DBMS_RANDOM.value(1,4)-1)*12
FROM   dual
CONNECT BY level <= 20;


EXEC DBMS_STATS.gather_table_stats(NULL, EMP);


SELECT table_name, partition_name, num_rows
FROM   user_tab_partitions
ORDER BY 1,2;


SELECT index_name, partitioned, status
FROM   user_indexes WHERE TABLE_NAME=T1
ORDER BY 1;

SELECT * FROM USER_INDEXES;

SELECT * FROM USER_IND_PARTITIONS; WHERE TABLE_NAME=T1;

ALTER TABLE t1 MODIFY
  PARTITION BY RANGE (created_date) SUBPARTITION BY HASH (id)(
    PARTITION t1_part_2015 VALUES LESS THAN (TO_DATE(01-JAN-2016,DD-MON-YYYY)) (
      SUBPARTITION t1_sub_part_2015_1,
      SUBPARTITION t1_sub_part_2015_2,
      SUBPARTITION t1_sub_part_2015_3,
      SUBPARTITION t1_sub_part_2015_4
    ),
    PARTITION t1_part_2016 VALUES LESS THAN (TO_DATE(01-JAN-2017,DD-MON-YYYY)) (
      SUBPARTITION t1_sub_part_2016_1,
      SUBPARTITION t1_sub_part_2016_2,
      SUBPARTITION t1_sub_part_2016_3,
      SUBPARTITION t1_sub_part_2016_4
    ),
    PARTITION t1_part_2017 VALUES LESS THAN (TO_DATE(01-JAN-2018,DD-MON-YYYY)) (
      SUBPARTITION t1_sub_part_2017_1,
      SUBPARTITION t1_sub_part_2017_2,
      SUBPARTITION t1_sub_part_2017_3,
      SUBPARTITION t1_sub_part_2017_4
    )
  ) ONLINE
  UPDATE INDEXES
  (
    t1_pk GLOBAL,
    t1_created_date_idx LOCAL
  );