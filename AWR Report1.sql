https://ittutorial.org/awr-report-analysis-how-to-analyze-an-awr-report-in-oracle-4-top-sql/#google_vignette

 

%CPU - CPU Time as a percentage of Elapsed Time
%IO - User I/O Time as a percentage of Elapsed Time 

						/**************************
						* SQL Statistics ECWBPEPS *
						***************************/

1. SQL ordered by Elapsed Time
2. SQL ordered by CPU Time
3. SQL ordered by User I/O wait time
4. SQL ordered by Buffer Gets
5. SQL ordered by Physical Reads (UnOptimized)
6. SQL ordered by Executions
7. SQL ordered by Parse Calls
8. SQL ordered by Sharable Memory
9. SQL ordered by Version Count
10. SQL ordered by SQL Text

 

 

SQL ordered by Elapsed Time
---------------------------
Its maximum execution time during processing


SQL ordered by CPU Time
------------------------
This section lists the most CPU-consuming SQLs in the database. SQL that spend the most CPU time are candidates 
for SQL Tuning, they are immediately examined and if it is problem , then SQL Tuning is done. 


SQL ordered by User I/O Wait Time
----------------------------------
This section lists SQLs ordered by User I/O wait time in the database.

 
SQL ordered by Gets
--------------------
i.e. SQL Statement hitting the Buffer Cache mostly to get the data from there.
----This section lists SQLs ordered by Gets that TOP logical reading SQLs from Buffer Gets in the database

 
SQL ordered by Physical Reads (UnOptimized)
--------------------------------------------
This section list the SQLs that perform the highest Physical I/O in the database.
The tables that are used by queries that make physical I/O in this section are generally non-indexed. If so, index is created on the related tables and related column.


SQL ordered by Executions
--------------------------
This section list the SQLs that perform the highest executions in the database.
Most executed SQLs are candidates for SQL Tuning, they are immediately examined and if it is problem , then SQL Tuning is done

 
							/*****************************
							* LOAD PROFILE in AWR REPORT *
							*****************************/


The Load Profile section in an AWR (Automatic Workload Repository) report provides a high-level summary of your database’s overall workload during the snapshot period. Rather than showing detailed wait event timelines, it aggregates key performance metrics into averages (often per second) that help you quickly understand where resources are spent. Here’s a closer look at what the Load Profile offers and how it can aid in performance tuning:

Key Metrics in the Load Profile
DB Time:

Definition: The total time (in seconds) the database spent processing—this encapsulates both CPU time and wait times.

Importance: A high DB Time can indicate either that your database is busy handling many operations or that there’s significant wait time due to bottlenecks.

DB CPU:

Definition: Portion of DB Time that was spent on actual CPU processing (i.e., executing SQL, running PL/SQL, etc.).

Importance: Helps you see whether the workload is CPU-bound. A high DB CPU with low wait times suggests that the system is processing efficiently, whereas low CPU with high DB Time might point to waits.

I/O Metrics (User I/O, Physical Reads/Writes):

Definition: Indicators of the amount and efficiency of I/O operations.

Importance: High physical I/O (reads/writes) might suggest disk bottlenecks or inefficient queries that are not taking advantage of caching.

Redo Size:

Definition: The amount of redo generated per second.

Importance: Provides insight into the volume of changes made to the database, which can impact recovery requirements and I/O performance.

Transactions and Logical Reads:

Definition: Average number of transactions and the number of logical (memory) reads per second.

Importance: These numbers help you assess the overall throughput of your database and can be used to calculate average resource usage per transaction.

How the Load Profile Aids in Performance Tuning
Quick Workload Assessment: By summarizing millions of rows’ worth of activity into a few critical numbers, the Load Profile gives you a baseline view of your system’s workload. This baseline is vital for comparing performance over time and spotting trends or anomalies.

Identifying Bottlenecks: With metrics like DB Time and DB CPU in one section, you can discern whether your workload is primarily limited by CPU capacity or by waits (e.g., I/O waits). If the DB Time is high but DB CPU is relatively low, then a significant portion of time is being spent waiting for resources.

Resource Utilization Analysis: Understanding metrics such as physical versus logical I/O helps determine if caching strategies need revisiting. If logical reads are high relative to physical reads, it suggests efficient use of memory caches. Conversely, a spike in physical I/O may highlight disk subsystem performance issues.

Baseline for Query Rewrite and Materialized Views: The aggregated numbers in the Load Profile can justify the use of performance tuning techniques like query rewrite (where complex queries are redirected to a materialized view) or further indexing. When you see a heavy load on certain operations, these techniques can be employed to move or reduce the computation overhead.

Trend Analysis and Capacity Planning: Regular review of the Load Profile allows DBAs to track workload changes over time. Rising trends in DB Time or I/O metrics can alert you before performance degrades critically, enabling proactive capacity planning and tuning.

Real-World Example
Imagine you run daily sales reports that aggregate huge amounts of order data. A normal execution of the report might involve complex joins and aggregations. By examining the Load Profile in your AWR report, you might notice that:

High DB Time with a small portion accounted for by DB CPU indicates that most of the processing time is spent waiting (perhaps due to disk I/O).

High Redo size suggests that the volume of transactional changes is significant.

Armed with this knowledge, you might decide to optimize your reporting query by creating a materialized view that aggregates the data during off-peak hours. The AWR’s Load Profile helps justify and design such optimizations by clearly showing where the bottlenecks lie.

In summary, the Load Profile in an AWR report is a powerful diagnostic tool that distills complex workload statistics into a few key metrics. These metrics help DBAs quickly identify performance issues, tune system resources, and plan for future growth.

Would you like more detail on how to interpret specific wait events from the Load Profile or perhaps guidance on using this data in conjunction with other sections of the AWR report for a comprehensive performance tuning strategy?

							

											/*********************************
											* Avoiding SQL Statistics in AWR *
											**********************************/

**************************************
* 5. Avoid SQL Ordered Physical Read *
**************************************

Reducing physical reads in an Oracle database can significantly improve performance. Here are some strategies to help minimize physical reads: 

Optimize SQL Queries:
----------------------
Ensure that SQL queries are well-tuned and use appropriate indexes. Poorly written queries can lead to excessive physical reads. Use the EXPLAIN PLAN to understand the execution path of your queries and make necessary adjustments.

Increase Buffer Cache Size:
---------------------------
Increasing the size of the buffer cache can help reduce physical reads by keeping more data in memory. This can be done by adjusting the DB_CACHE_SIZE parameter.

Use Indexes Efficiently:
------------------------
Ensure that indexes are used effectively. Sometimes, creating additional indexes or modifying existing ones can help reduce the number of physical reads.

Partition Large Tables:
-----------------------
Partitioning large tables can help in reducing the amount of data scanned during queries, thus reducing physical reads.

Optimize Data Access Patterns:
-------------------------------
Access data in a way that minimizes the need for physical reads. For example, use bulk operations instead of row-by-row processing. 

Use Materialized Views:
------------------------
Materialized views can precompute and store complex query results, reducing the need for repeated physical reads.

Monitor and Adjust:
--------------------
Regularly monitor AWR reports to identify high physical read operations and take corrective actions. Look at the SQL ordered by Physical Reads section to find queries that are causing high physical reads 1 2.

 

 

****************************************
* 3. SQL ordered by User I/O Wait Time *
**************************************** 

Minimizing SQL statements ordered by User I/O Wait Time involves several strategies to optimize I/O performance in Oracle databases. Here are some effective approaches:
 
Optimize SQL Queries:
---------------------
Index Usage: Ensure that your queries are using indexes efficiently. Check the execution plans to verify index usage and avoid full table scans. 

Query Tuning: Rewrite queries to be more efficient. Use hints if necessary to guide the optimizer.
-------------

Increase Buffer Cache:
----------------------
DB_CACHE_SIZE: Increase the size of the buffer cache to reduce physical I/O. This keeps more data in memory, reducing the need for disk reads.

Partition Large Tables:
------------------------
Table Partitioning: Partition large tables to reduce the amount of data scanned during queries. This can significantly lower I/O wait times.

Use Materialized Views:
-----------------------
Precomputed Results: Materialized views store precomputed query results, reducing the need for repeated I/O operations.

Optimize Storage Configuration:
--------------------------------
Disk Performance: Use faster disks or SSDs to improve I/O performance. Ensure proper configuration of RAID, SAN, or NAS systems.

ASM (Automatic Storage Management): Balance I/O across multiple disks using ASM.
---------------------------------
 
Adjust Instance Parameters:
---------------------------
DB_FILE_MULTIBLOCK_READ_COUNT: Adjust this parameter to optimize the number of blocks read in a single I/O operation.

(
DB_FILE_MULTIBLOCK_READ_COUNT is one of the parameters you can use to minimize I/O during table scans.
The total number of I/Os needed to perform a full table scan depends on such factors as the
size of the table, the multiblock read count, and whether parallel execution is being utilized for the operation 

The default value of this parameter is a value that corresponds to the maximum I/O size that can be performed efficiently. This value is platform-dependent and is 1MB for most platforms.
)

PGA_AGGREGATE_TARGET: Increase the size of the Program Global Area (PGA) to improve sorting and hashing operations.
----------------------

Monitor and Analyze:
---------------------
AWR Reports: Regularly review AWR reports to identify high I/O wait times and take corrective actions. Focus on the SQL ordered by User I/O Wait Time section 1 2 3.



  *******************************DB_FILE_MULTIBLOCK_READ_COUNT*****************************

The **DB_FILE_MULTIBLOCK_READ_COUNT** parameter in Oracle specifies the maximum number of blocks read in one I/O operation during a sequential scan. Here are some key points about this parameter: 

1. **Purpose**:

   - It helps in minimizing I/O during table scans by allowing multiple blocks to be read in a single I/O operation [1](https://docs.oracle.com/en/database/oracle/oracle-database/19/refrn/DB_FILE_MULTIBLOCK_READ_COUNT.html).


2. **Default Value**:

   - The default value is platform-dependent and corresponds to the maximum I/O size that can be efficiently performed. For most platforms, this is 1MB [1](https://docs.oracle.com/en/database/oracle/oracle-database/19/refrn/DB_FILE_MULTIBLOCK_READ_COUNT.html).


3. **Modifiable**:

   - You can modify this parameter using `ALTER SESSION` or `ALTER SYSTEM` commands [1](https://docs.oracle.com/en/database/oracle/oracle-database/19/refrn/DB_FILE_MULTIBLOCK_READ_COUNT.html).

 

4. **Impact on Performance**:

   - Setting this parameter to a higher value can improve the performance of full table scans, especially in data warehouse environments. However, setting it too high can lead to excessive I/O waits if not managed properly [2](https://asktom.oracle.com/ords/f?p=100:11:0::::P11_QUESTION_ID:2664510700346622029).

 

5. **Considerations**:

   - The optimizer may favor full table scans over index scans if this parameter is set to a high value.

   - The actual number of blocks read can be influenced by the block size and the maximum I/O size allowed by the operating system [2](https://asktom.oracle.com/ords/f?p=100:11:0::::P11_QUESTION_ID:2664510700346622029).

 

Would you like to know how to adjust this parameter or need help with a specific performance issue related to it? 
 
---------------------------HIGH DFMRC RESULTS IN------------------------
When the DB_FILE_MULTIBLOCK_READ_COUNT parameter is set too high, it can lead to excessive I/O waits and buffer cache flooding. Heres how this happens:

Excessive I/O Waits:
-------------------
Large I/O Operations: Setting a high value for this parameter means that Oracle will attempt to read a large number of blocks in a single I/O operation. If the underlying storage system cannot handle such large I/O requests efficiently, it can lead to increased I/O wait times 1.

Buffer Cache Flooding:
-----------------------
Cache Overload: A high DB_FILE_MULTIBLOCK_READ_COUNT value can cause large amounts of data to be read into the buffer cache at once. This can displace other useful data from the cache, leading to frequent cache misses and additional physical reads 2.

 
5.3------------------BENEFIT OF INDEX ON LOWERING THE PHYSICAL READS-----------------
 
How can index created on table or any column of the table reduces Physical Reads in Oracle

By creating an index on a table or a particular column, you equip Oracle with a roadmap that enables it to jump directly to the data you need rather than searching through every row. This focused data retrieval process drastically reduces the number of physical reads, conserves system resources, and improves overall query efficiency.
 
Indexes in Oracle work like a well-organized directory. Without an index, when Oracle needs to retrieve rows based on a condition, it often resorts to a full table scan—reading every block from disk. 
Indexes help by creating a smaller, structured lookup that dramatically trims the number of physical blocks that need to be read from disk. Here’s how:


					1. Navigating with a B-Tree Structure
					---------------------------------------
1. How It Works: - Most indexes in Oracle are built using a B-tree structure. When you provide a condition in your query (for 	example, a WHERE clause), Oracle walks the B-tree to quickly locate the key value v r searching for. This search is logarithmic in nature, meaning it requires reading only a few index blocks—much fewer than scanning the entire table.

2. Impact on Physical Reads: Because the B-tree index is much smaller than the full table, fewer disk blocks are read. Once Oracle identifies the matching entries via the index, it only retrieves the corresponding rows (or, in some cases, the row data directly from the index itself). This reduces the number of physical I/O operations and speeds up query performance.


					2. Selective Data Access via Index Range Scans
					-----------------------------------------------
1. How It Works: For queries that filter based on indexed columns, Oracle can perform an index range scan. Instead of 					reading all rows, Oracle uses the index to jump directly to the block where the pertinent data begins and 					then reads only the range of index entries that satisfy the condition.				

2.	Impact on Physical Reads: This means that if you have a highly selective query (one that returns only a few rows), Oracle						 		avoids reading many blocks that do not contain matching rows. The result is a dramatic decrease								 in physical reads, as only the relevant blocks are brought into memory.



						3. Covering Indexes and Index-Only Scans
						------------------------------------------
1. How It Works: A covering index is an index that includes all the columns needed by the query. When such an index is in place, Oracle can satisfy the query using just the index without going to the table at all—a process known as an index-only scan. (Covering Index - is like a composite Index created on cols which can be used - directly to fetch the records using rowid every instead of reaching the tables)
					✅ Reduces disk I/O operations. ✅ Speeds up queries. ✅ Eliminates unnecessary table lookups.
					
2. Impact on Physical Reads: Because the index itself is much smaller, and all data is already in the index, Oracle avoids the extra step of reading the larger table blocks. This further reduces the amount of physical I/O 								required, leading to faster query execution.



							4. Reduced I/O Overhead Through Caching
							------------------------------------------
1. How It Works: Index blocks are typically smaller and can be more efficiently cached in memory (the buffer cache) compared 				 to full data blocks. If the relevant index blocks are already cached, Oracle doesnt need to perform any 				physical reads from disk.

2. Impact on Physical Reads: When frequently accessed indexes are cached, subsequent queries can avoid physical disk I/O 							entirely, relying on much faster memory access instead. This greatly enhances performance, 								especially in high-transaction environments.




