EXEC DBMS_MVIEW.REFRESH(MV_TEST2,FAST);

EXEC DBMS_MVIEW.REFRESH(MV_TEST1,FORCE);

SELECT * FROM MV_TEST2;

UPDATE LOCATIONS SET CITY=South San Francisco WHERE LOCATION_ID=1500;   --  Las Vegas
UPDATE LOCATIONS SET CITY=Las Vegas WHERE LOCATION_ID=1500;   --  Las Vegas
/*

MV_TEST2 - BUILD IMMEDIATE  ---> MEANS GETS CREATED IMMEADIATELY 
            REFRESH FAST ON DEMAND  --> MEANS WOULD GET RESFRESHED FAST BUT ON DEMAND NOT OWN.
                            EXAMPLE - EXEC DBMS_MVIEW.REFRESH(MV_TEST2, F);


*/

CREATE MATERIALIZED VIEW MV_TEST2
  BUILD DEFERRED USING INDEX 
  REFRESH COMPLETE ON COMMIT
  --USING DEFAULT LOCAL ROLLBACK SEGMENT
  --USING ENFORCED CONSTRAINTS 
  --ENABLE ON QUERY COMPUTATION 
  --ENABLE QUERY REWRITE
  AS SELECT EMP.EMPLOYEE_ID, 
									EMP.FIRST_NAME|| ||EMP.LAST_NAME, 
                                    DEPT.DEPARTMENT_NAME, 
                                    DEPT.LOCATION_ID,
                                    LOCATIONS.CITY,
                                    LOCATIONS.STATE_PROVINCE,
                                    EMP.ROWID AS EMP_ID, 
                                    DEPT.ROWID AS DEP_ID,
                                    LOCATIONS.ROWID AS LOC_ID
                               FROM EMP, DEPT, LOCATIONS
                              WHERE EMP.DEPARTMENT_ID = DEPT.DEPARTMENT_ID
                              AND DEPT.LOCATION_ID = LOCATIONS.LOCATION_ID;
                              /
                              
select * from MV_TEST2;
DROP MATERIALIZED VIEW MV_TEST1;

SELECT * FROM MLOG$_DEPARTMENTS;



-------------------------------------08-MAY--------------------------------------

DROP MATERIALIZED VIEW LOG ON LOCATIONS;
DROP MATERIALIZED VIEW MV_TEST1;

CREATE MATERIALIZED VIEW MV_TEST1
BUILD IMMEDIATE
REFRESH COMPLETE ON COMMIT
AS
SELECT E.EMPLOYEE_ID, 
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
D.LOCATION_ID,
L.CITY,
L.STATE_PROVINCE
FROM EMP E, DEPARTMENTS D, LOCATIONS L
WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID
AND D.LOCATION_ID = L.LOCATION_ID;

SELECT * FROM LOCATIONS;
DROP MATERIALIZED VIEW MV_TEST1;

SELECT * FROM MV_TEST1;

EXEC DBMS_MVIEW.REFRESH(MV_TEST1,C);
UPDATE EMP SET MANAGER_ID=123 WHERE EMPLOYEE_ID=199;
SELECT * FROM EMP WHERE EMPLOYEE_ID=199;

----------------------------------------------------------------

  BUILD DEFERRED USING INDEX 
  REFRESH COMPLETE ON COMMIT


DROP MATERIALIZED VIEW MV_TEST2;

CREATE MATERIALIZED VIEW MV_TEST2
NOLOGGING
  CACHE
 BUILD IMMEDIATE --USING INDEX 
  REFRESH FAST-- ON COMMIT
--BUILD IMMEDIATE
--REFRESH FAST ON COMMIT--DEMAND
AS
SELECT EMP.EMPLOYEE_ID, 
EMP.FIRST_NAME|| ||EMP.LAST_NAME AS EMP_NAME,  
EMP.SALARY,
EMP.EMAIL,
EMP.PHONE_NUMBER,
EMP.HIRE_DATE,
EMP.JOB_ID,
EMP.COMMISSION_PCT,
EMP.MANAGER_ID,
DEPARTMENTS.DEPARTMENT_ID,
DEPARTMENTS.DEPARTMENT_NAME,
DEPARTMENTS.LOCATION_ID,
LOCATIONS.CITY,
LOCATIONS.STATE_PROVINCE,
EMP.ROWID AS EMP_ID,
DEPARTMENTS.ROWID AS DEP_ID
LOCATIONS.ROWID AS LOC_ID
FROM EMP, DEPARTMENTS, LOCATIONS 
WHERE EMP.DEPARTMENT_ID = DEPARTMENTS.DEPARTMENT_ID
AND DEPARTMENTS.LOCATION_ID = LOCATIONS.LOCATION_ID;

CREATE MATERIALIZED VIEW MV_TEST2
  NOLOGGING
  CACHE
  BUILD IMMEDIATE
  REFRESH FAST ON COMMIT  AS SELECT EMP.EMPLOYEE_ID, 
									EMP.FIRST_NAME|| ||EMP.LAST_NAME AS EMP_NAME, 
                                    DEPARTMENTS.DEPARTMENT_NAME, 
                                    DEPARTMENTS.LOCATION_ID, 
                                    LOCATIONS.CITY,
                                    LOCATIONS.STATE_PROVINCE,
                                    EMP.ROWID AS EMP_ID, 
                                    DEPARTMENTS.ROWID AS DEP_ID,
                                    LOCATIONS.ROWID AS LOC_ID
                               FROM EMP, DEPARTMENTS, LOCATIONS
                              WHERE EMP.DEPARTMENT_ID = DEPARTMENTS.DEPARTMENT_ID
                              AND DEPARTMENTS.LOCATION_ID = LOCATIONS.LOCATION_ID;
                              /
                              SELECT * FROM LOCATIONS;


SELECT * FROM DEPARTMENTS;
SELECT * FROM MV_TEST2;

CREATE MATERIALIZED VIEW LOG ON EMP
WITH PRIMARY KEY, ROWID
INCLUDING NEW VALUES;

CREATE MATERIALIZED VIEW LOG ON DEPT
WITH ROWID--PRIMARY KEY, ROWID
INCLUDING NEW VALUES;

CREATE MATERIALIZED VIEW LOG ON LOCATIONS
WITH PRIMARY KEY, ROWID
INCLUDING NEW VALUES;
--COMMIT;-- SCN;


CREATE MATERIALIZED VIEW LOG ON DEPARTMENTS
WITH PRIMARY KEY, ROWID
INCLUDING NEW VALUES;

SELECT * FROM LOCATIONS;
DROP MATERIALIZED VIEW MV_TEST2;

SELECT * FROM MV_TEST1;

EXEC DBMS_MVIEW.REFRESH(MV_TEST1,C);
UPDATE EMP SET MANAGER_ID=123 WHERE EMPLOYEE_ID=199;
SELECT * FROM EMP WHERE EMPLOYEE_ID=199;

DROP MATERIALIZED VIEW MV_TEST2;

CREATE MATERIALIZED VIEW MV_TEST2
--NOLOGGING
 -- CACHE
 BUILD IMMEDIATE
  --REFRESH FAST ---ON COMMIT
AS
SELECT EMP.EMPLOYEE_ID, 
EMP.FIRST_NAME|| ||EMP.LAST_NAME AS EMP_NAME,  
EMP.SALARY,
EMP.EMAIL,
EMP.PHONE_NUMBER,
EMP.HIRE_DATE,
EMP.JOB_ID,
EMP.COMMISSION_PCT,
EMP.MANAGER_ID,
DEPT.DEPARTMENT_ID,
DEPT.DEPARTMENT_NAME,
DEPT.LOCATION_ID,
LOCATIONS.CITY,
LOCATIONS.STATE_PROVINCE,
EMP.ROWID AS EMP_ID,
DEPT.ROWID AS DEP_ID,
LOCATIONS.ROWID AS LOC_ID
FROM EMP, DEPT, LOCATIONS 
WHERE EMP.DEPARTMENT_ID = DEPT.DEPARTMENT_ID
AND DEPT.LOCATION_ID = LOCATIONS.LOCATION_ID;

CREATE MATERIALIZED VIEW MV_TEST2
  NOLOGGING
  CACHE
  BUILD IMMEDIATE
  REFRESH FAST ON COMMIT  AS SELECT EMP.EMPLOYEE_ID, 
									EMP.FIRST_NAME|| ||EMP.LAST_NAME AS EMP_NAME, 
                                    EMP.SALARY,
EMP.EMAIL,
EMP.PHONE_NUMBER,
EMP.HIRE_DATE,
EMP.JOB_ID,
EMP.COMMISSION_PCT,
EMP.MANAGER_ID,
DEPARTMENTS.DEPARTMENT_NAME, 
                                    DEPARTMENTS.LOCATION_ID, 
                                    LOCATIONS.CITY,
                                    LOCATIONS.STATE_PROVINCE,
                                    EMP.ROWID AS EMP_ID, 
                                    DEPARTMENTS.ROWID AS DEP_ID,
                                    LOCATIONS.ROWID AS LOC_ID
                               FROM EMP, DEPARTMENTS, LOCATIONS
                              WHERE EMP.DEPARTMENT_ID = DEPARTMENTS.DEPARTMENT_ID
                              AND DEPARTMENTS.LOCATION_ID = LOCATIONS.LOCATION_ID;
                              /
                              SELECT * FROM MV_TEST2;
SELECT * FROM MLOG$_LOCATIONS;    
SELECT * FROM MLOG$_EMP; 
SELECT * FROM MLOG$_DEPT; 


UPDATE LOCATIONS SET CITY=Algeria WHERE LOCATION_ID=1500;

SELECT * FROM ALL_MVIEWS WHERE MVIEW_NAME = MV_TEST2;

SELECT * FROM MV_TEST2;

SELECT * FROM EMP;

EXEC DBMS_MVIEW.REFRESH(MV_TEST2,C);

SELECT * FROM LOCATIONS WHERE LOCATION_ID=1500;





***********************************************************************************************


https://www.google.com/search?q=requirement+for+materialized+view+in+oracle+for+fast+REFRESH&rlz=1C1VDKB_en-GBIN1198IN1198&sca_esv=2392647f5fe98383&sxsrf=ANbL-n7XC5TQfw8uzhbdeTw5kr6uRpR3Aw%3A1769540559711&ei=zwt5abqbK5KwseMP38bXoAg&ved=0ahUKEwj6vuijtKySAxUSWGwGHV_jFYQQ4dUDCBE&uact=5&oq=requirement+for+materialized+view+in+oracle+for+fast+REFRESH&gs_lp=Egxnd3Mtd2l6LXNlcnAiPHJlcXVpcmVtZW50IGZvciBtYXRlcmlhbGl6ZWQgdmlldyBpbiBvcmFjbGUgZm9yIGZhc3QgUkVGUkVTSDIFECEYoAEyBRAhGJ8FMgUQIRifBTIFECEYnwUyBRAhGJ8FSPAQUMIIWMgOcAF4AZABAJgBvQGgAYMJqgEDMC43uAEDyAEA-AEBmAIIoALiCcICChAAGLADGNYEGEeYAwCIBgGQBgiSBwUxLjYuMaAH21myBwUwLjYuMbgH2AnCBwUyLTYuMsgHQYAIAA&sclient=gws-wiz-serp

Core Requirements
Materialized View Logs: A materialized view log must exist on every base (master) table referenced in the materialized views defining query. 

This log records DML changes (INSERT, UPDATE, DELETE) to the master table(s) incrementally.

MV Log Contents: The materialized view logs must include specific information:

WITH ROWID: Required for most materialized join views to track physical row identifiers.

WITH PRIMARY KEY: The default and recommended method for single-table MVs, allowing fast refresh even after master table reorganizations.

INCLUDING NEW VALUES: Necessary for fast refresh of materialized aggregate views.

WITH SEQUENCE: Recommended if the table is expected to have a mix of inserts, updates, and deletes, or direct loads.

Materialized View Definition: The materialized view itself must be created with the REFRESH FAST or REFRESH FORCE clause. Oracle will verify if the query is eligible for fast refresh at creation time if REFRESH FAST is specified.

Query Eligibility: The defining query must not contain constructs that prevent incremental calculation of changes. Ineligible constructs include, but are not limited to:


Analytic functions (e.g., RANK())

ROWNUM or SYSDATE (non-repeatable expressions)

Subqueries in the SELECT list

HAVING clauses with subqueries
CONNECT BY clauses 

Specific Requirements by MV Type
The requirements for fast refresh depend on the type of materialized view: 
Materialized Join Views (No Aggregates): The ROWID of all master tables must be included in the SELECT list of the MV definition query, and materialized view logs on all master tables must be created with the WITH ROWID clause. For an example SQL statement, please refer to the referenced document.
Materialized Aggregate Views (with GROUP BY): The SELECT list must contain all GROUP BY columns, COUNT(*), and for certain aggregate functions like AVG() or SUM(), the corresponding COUNT(column). Materialized view logs are required on all master tables with WITH ROWID, SEQUENCE, and INCLUDING NEW VALUES. An example SQL statement can be found in the referenced document. 
Tools for Verification
Oracle provides tools to help verify fast refresh eligibility: 
DBMS_MVIEW.EXPLAIN_MVIEW: Analyzes an MV and reports on its fast-refresh capabilities and restrictions.
DBMS_ADVISOR.TUNE_MVIEW: Can generate a script to make an MV fast refreshable. 




******


✅ 1. Materialized View Logs MUST exist on ALL base tables

✅ 2. JOIN must be Equi-Join only
									e.department_id = d.department_id
									
✅ 3. INNER JOIN Only (Mostly)
							EMPLOYEES e
										JOIN DEPARTMENTS d
										ON e.department_id = d.department_id

✅ 4. JOIN columns must be NOT NULL
									ALTER TABLE employees
										MODIFY department_id NOT NULL;

✅ 5. Primary Key / ROWID Support is Mandatory

						At least one must exist:
						Primary key on join columns
						OR ROWID logs
						
✅ 6. No Unsupported SQL in SELECT

							❌ These break FAST refresh:
							DISTINCT
							GROUP BY
							HAVING
							UNION / UNION ALL
							Subqueries
							CONNECT BY
							SYSDATE
							NVL() on join column
							Functions on join columns
							✔ Simple SELECT only.						
							
✅ 7. Columns in SELECT must come from base tables directly
									SELECT e.employee_id, e.salary, d.department_name



5️⃣ HOW TO CHECK IF FAST REFRESH IS POSSIBLE

	EXEC DBMS_MVIEW.EXPLAIN_MVIEW(HR.MV_EMP_DEPT);

		SELECT capability_name, possible, related_text
		FROM mv_capabilities_table;

6️⃣ INTERVIEW ONE-LINE ANSWER ⭐

“Join Materialized Views in Oracle can be FAST refreshed only if all base tables have MV logs, the join is a simple inner equi-join on NOT NULL columns, and the SELECT does not contain aggregates, outer joins, subqueries, or functions.”