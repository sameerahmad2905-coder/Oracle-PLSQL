
1. IDLE EVENTS (NOT A PROBLEM)
THESE EVENTS MEAN THE SESSION IS SITTING AROUND WAITING FOR WORK. YOU GENERALLY DO NOT NEED TO TUNE THESE.

EVENT NAME														EXPLANATION

SQL*NET MESSAGE FROM CLIENT -	THE SESSION IS WAITING FOR THE CLIENT APPLICATION (LIKE SQL DEVELOPER OR JAVA APP) TO SEND A NEW QUERY. THIS 																IS THE STANDARD "IDLE" STATE.
SQL*NET MESSAGE TO CLIENT - THE SESSION HAS FINISHED SENDING DATA TO THE CLIENT AND IS WAITING FOR AN ACKNOWLEDGMENT (USUALLY VERY 															FAST).
RDBMS IPC MESSAGE	- 								A BACKGROUND PROCESS (LIKE DBWN OR LGWR) IS IDLE AND WAITING FOR INSTRUCTIONS.
SMON TIMER -											THE SYSTEM MONITOR (SMON) BACKGROUND PROCESS IS SLEEPING, WAITING FOR ITS NEXT MAINTENANCE TASK.   
PMON TIMER - 										THE PROCESS MONITOR (PMON) BACKGROUND PROCESS IS SLEEPING.


2. APPLICATION / LOCKING EVENTS (USER WAITS)  --> THESE EVENTS OCCUR DUE TO APPLICATION LOGIC OR LOCKING ISSUES BETWEEN USERS.
-------------------------------------------------------------
EVENT NAME    																EXPLANATION
ENQ: TX - ROW LOCK CONTENTION			VERY COMMON. A SESSION IS TRYING TO UPDATE A ROW THAT IS CURRENTLY LOCKED BY ANOTHER SESSION.
					EXAMPLE: USER A IS UPDATING EMP ID 100 BUT HASNT COMMITTED. USER B TRIES TO UPDATE THE SAME ROW AND WAITS HERE.

ENQ: TM - DML LOCK								A SESSION IS WAITING FOR A LOCK ON A TABLE. THIS OFTEN HAPPENS 
														WHEN A DDL OPERATION (LIKE ALTER TABLE) TRIES TO RUN WHILE PEOPLE ARE STILL QUERYING OR 														   UPDATING THAT TABLE.
ENQ: SV - CONTAINMENT							A WAIT FOR LOGICAL CONTAINMENT, OFTEN SEEN IN RAC ENVIRONMENTS OR SPECIFIC DISTRIBUTED TRANSACTIONS.


3. USER I/O EVENTS (DISK READS/WRITES) ---->THESE ARE RELATED TO THE DATABASE READING DATA FROM DISK INTO MEMORY (BUFFER CACHE).
------------------------------------------------
EVENT NAME														EXPLANATION
DB FILE SEQUENTIAL READ				VERY COMMON. THE SESSION IS WAITING FOR A SINGLE BLOCK TO BE READ FROM DISK.
			CONTEXT: TYPICALLY HAPPENS DURING INDEX LOOKUPS (BY ROWID). HIGH VALUES USUALLY INDICATE INDEX SCANNING OR FRAGMENTED DISKS.

DB FILE SCATTERED READ					THE SESSION IS WAITING FOR MULTIPLE BLOCKS TO BE READ FROM DISK AT ONCE.
			CONTEXT: TYPICALLY HAPPENS DURING FULL TABLE SCANS. THE BLOCKS ARE "SCATTERED" IN MEMORY, HENCE THE NAME.

DIRECT PATH READ							THE SESSION IS READING DATA DIRECTLY FROM DISK BYPASSING THE BUFFER CACHE (PGA).
			CONTEXT: COMMON IN DATA WAREHOUSING, PARALLEL QUERY, OR WHEN "DIRECT PATH" INSERTS ARE HAPPENING.

DIRECT PATH WRITE						SIMILAR TO ABOVE, BUT FOR WRITING DATA (E.G., DURING A DATA LOAD OR CREATE TABLE AS SELECT).


A BUFFER is a temporary storage area in computer memory used to hold data while its being transferred between different parts of a system, such as between a device and an application, or between two processes.

In operating systems, CACHE MEMORY is a high-speed memory that stores frequently accessed data and instructions, acting as a buffer between the CPU and the main memory (RAM). 
/*
------------------------------LAST CR BUFFER GETS------------------------------------

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
 
 */

4. CONCURRENCY / MEMORY EVENTS (INTERNAL CONTENTION)  --------->  THESE OCCUR WHEN MULTIPLE SESSIONS FIGHT OVER INTERNAL DATABASE STRUCTURES.
------------------------------------------------------------------------
EVENT NAME
EXPLANATION
LATCH: SHARED POOL	THE SESSION IS WAITING TO ACCESS THE SHARED POOL (MEMORY AREA FOR SQL PARSING). HIGH WAITS HERE MIGHT INDICATE HARD PARSING OF SQL STATEMENTS (LACK OF BIND VARIABLES).
LATCH: CACHE BUFFERS CHAINS	THE SESSION IS WAITING FOR A SPECIFIC BLOCK IN THE BUFFER CACHE THAT IS "HOT" (VERY POPULAR).
CONTEXT: OFTEN INDICATES MANY SESSIONS ACCESSING THE SAME INDEX BLOCK (E.G., A PRIMARY KEY ON A SEQUENCE).
BUFFER BUSY WAITS	THE SESSION WANTS TO ACCESS A DATA BLOCK BUT ANOTHER SESSION IS CURRENTLY READING OR MODIFYING IT, AND THE BUFFER IS BUSY.

5. COMMIT / REDO LOG EVENTS (TRANSACTION INTEGRITY)
THESE ARE RELATED TO COMMITTING TRANSACTIONS AND WRITING TO THE REDO LOGS.

EVENT NAME
EXPLANATION
LOG FILE SYNC	A SESSION ISSUED A COMMIT AND IS WAITING FOR ORACLE TO CONFIRM THAT THE REDO DATA HAS BEEN PHYSICALLY WRITTEN TO THE REDO LOG FILE ON DISK.
CONTEXT: HIGH WAITS HERE OFTEN MEAN APPLICATIONS ARE COMMITTING TOO FREQUENTLY (COMMITTING INSIDE LOOPS).
LOG FILE PARALLEL WRITE	THE BACKGROUND PROCESS (LGWR) IS WAITING WHILE IT WRITES REDO RECORDS TO THE ONLINE REDO LOG FILES. IF THIS IS HIGH, THE DISK HOUSING THE REDO LOGS MIGHT BE SLOW.

6. NETWORK EVENTS
RELATED TO DATABASE CONNECTIONS ACROSS THE NETWORK.

EVENT NAME
EXPLANATION
SQL*NET MORE DATA FROM CLIENT	THE SERVER IS WAITING FOR THE CLIENT TO SEND MORE DATA (USUALLY FOR LARGE INSERTS OR UPDATES).
SQL*NET MORE DATA TO CLIENT	THE SERVER IS WAITING FOR THE NETWORK TO CLEAR SO IT CAN SEND MORE DATA BACK TO THE CLIENT (OFTEN RETURNING LARGE RESULT SETS).

IMPORTANT TIP: HOW TO READ THIS DATA
WHEN YOU QUERY V$SESSION, ALWAYS LOOK AT THE WAIT_CLASS COLUMN TO FILTER OUT THE NOISE.

EXAMPLE QUERY:

SQL

SELECT SID, SERIAL#, USERNAME, EVENT, WAIT_CLASS, SECONDS_IN_WAIT, STATE
FROM V$SESSION
WHERE USERNAME IS NOT NULL
AND WAIT_CLASS != IDLE;  -- THIS FILTERS OUT THE "MESSAGE FROM CLIENT" WAITS
ORDER BY SECONDS_IN_WAIT DESC;
STATE = WAITING: THE SESSION IS CURRENTLY STUCK ON THAT EVENT.
STATE = WAITED KNOWN TIME: THE SESSION WAS WAITING, BUT IS NOW WORKING ON THE CPU (OR WAITING AGAIN). THE EVENT SHOWN IS THE LAST THING IT WAITED FOR.


