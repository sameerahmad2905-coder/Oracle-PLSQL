
SQL Loader requires a Control File (.ctl) to define how to read the data.
Log file: Summary of load.
Bad file: Records that failed to load.

OPTIONS (SKIP=1, DIRECT=TRUE) -- Skip header row, use Direct Path load
LOAD DATA INFILE 'employees.dat'       -- Name of the data file
APPEND                        -- Options: INSERT, APPEND, REPLACE, TRUNCATE
INTO TABLE EMPP          -- Target table name
FIELDS TERMINATED BY ","     -- Comma delimited
OPTIONALLY ENCLOSED BY '"'   -- Handles text in quotes
TRAILING NULLCOLS            -- Allows empty columns at end of line
	(
	  EID,
	  ENAME,
	  SAL
	)


OPTIONS(ROWS=10000,  BINDSIZE=10485760,  READSIZE=10485760)
LOAD DATA INFILE 'E:\Oracle_Practice\EMPP.csv'
APPEND
INTO TABLE EMPP
FIELDS TERMINATED BY ","
OPTIONALLY ENCLOSED BY ' " '
TRAILING NULLCOLS
    (
        EID,
        ENAME,
        SAL
    )


FROM THE CMD PROMPT OF WINDOWS 
-----------------------------------------------
sqlldr userid=HR/sameer@orclpdb control="E:\Oracle_SQL_Practice\load_empp.ctl" log="E:\Oracle_SQL_Practice\emp_load.log"


1. READSIZE
READSIZE controls the size of the buffer used to read data from the input file.
What it does: It tells SQL*Loader, "Every time you go to the hard drive to look at the .csv file, grab this much data."

Default: Usually 1,048,576 bytes (1 MB).
Why change it? If you have very long records (large VARCHAR2 or LOB columns), the default might not be big enough to hold a single row of data. Increasing this can reduce the number of times SQL*Loader has to "ping" your hard drive.

2. BINDSIZE
BINDSIZE controls the size of the buffer used to prepare data for insertion into the database.
What it does: It defines the maximum size of the "Bind Array." This is the memory space where rows are "parked" before being sent to the database in one big batch.

Default: Usually 256,000 bytes (256 KB).
Why change it? A larger BINDSIZE allows SQL*Loader to send more rows per "insert" operation. This reduces network overhead and makes the load much faster.

3. How They Work Together
There is a specific relationship between these two:
The Rule: The BINDSIZE cannot actually be larger than the READSIZE.
The Interaction: If you set a massive BINDSIZE but leave READSIZE at its small default, Oracle will automatically increase your READSIZE to match your BINDSIZE.

/*

SQL*Loader: Release 21.0.0.0.0 - Production on Tue Feb 10 12:56:14 2026
Version 21.3.0.0.0

Copyright (c) 1982, 2021, Oracle and/or its affiliates.  All rights reserved.

Control File:   E:\Oracle_SQL_Practice\load_empp.ctl
Data File:      E:\Oracle_SQL_Practice\EMPP.csv
  Bad File:     E:\Oracle_SQL_Practice\EMPP.bad
  Discard File:  none specified
 
 (Allow all discards)

Number to load: ALL
Number to skip: 1
Errors allowed: 50
Continuation:    none specified
Path used:      Direct

Table EMPP, loaded from every logical record.
Insert option in effect for this table: APPEND
TRAILING NULLCOLS option in effect

   Column Name                  Position   Len  Term Encl Datatype
------------------------------ ---------- ----- ---- ---- ---------------------
EID                                 FIRST     *   ,  O(") CHARACTER            
ENAME                                NEXT     *   ,  O(") CHARACTER            
SAL                                  NEXT     *   ,  O(") CHARACTER            

The following index(es) on table EMPP were processed:
index HR.SYS_C008322 loaded successfully with 983482 keys 

Table EMPP:
  983482 Rows successfully loaded.
  0 Rows not loaded due to data errors.
  0 Rows not loaded because all WHEN clauses were failed.
  0 Rows not loaded because all fields were null.

Bind array size not used in direct path.
Column array  rows :    5000
Stream buffer bytes:  256000
Read   buffer bytes: 1048576

Total logical records skipped:          1
Total logical records read:        983482
Total logical records rejected:         0
Total logical records discarded:        0
Total stream buffers loaded by SQL*Loader main thread:      202
Total stream buffers loaded by SQL*Loader load thread:        0

Run began on Tue Feb 10 12:56:14 2026
Run ended on Tue Feb 10 12:56:18 2026

Elapsed time was:     00:00:03.93
CPU time was:         00:00:00.61

*/

----------------------------------------------------------------------------------------------------------------



2. EXTERNAL TABLE
External Tables use the same access driver (ORACLE_LOADER) but define the structure as a database object.

Scenario
Data File: /home/oracle/data/employees.dat (Same data as above)

Step A: Create a Directory Object
The directory must be a path on the Database Server, not your local machine.

sql

CREATE OR REPLACE DIRECTORY ext_data_dir AS '/home/oracle/data/';
Step B: External Table Syntax
sql

CREATE TABLE emp_external (
    emp_id    NUMBER,
    emp_name  VARCHAR2(50),
    salary    NUMBER
)
ORGANIZATION EXTERNAL
(
    TYPE ORACLE_LOADER
    DEFAULT DIRECTORY ext_data_dir
    ACCESS PARAMETERS
    (
        RECORDS DELIMITED BY NEWLINE
        BADFILE ext_data_dir:'emp.bad'
        LOGFILE ext_data_dir:'emp.log'
        FIELDS TERMINATED BY ","
        OPTIONALLY ENCLOSED BY ''''
        (
            emp_id    CHAR(10),
            emp_name  CHAR(50),
            salary    CHAR(10)
        )
    )
    LOCATION ('employees.dat') -- The actual file name
)
REJECT LIMIT UNLIMITED; -- Allows the table to be created even if there are bad rows
