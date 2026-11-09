🔹 WHAT IS A REF CURSOR?

🔹 A REF CURSOR in Oracle PL/SQL is a data type used to declare a cursor variable, 
which essentially acts as a pointer or 
handle queries result set			------> Means the result set obtained from a Query is Handled by it
residing on the database server.
SAME REF CURSOR CAN POINT TO MULTIPLE QUERIES.		--> Any REF ursor ben declared once can be used or dffernt queries, from the 
														--same table or from different tables as at line - 323 to 383
CAN BE PASSED AS A PARAMETER (IN/OUT) TO PROCEDURES/FUNCTIONS															
 
🔹 Unlike a static or explicit cursor, which has its SQL query defined at compile time, REF CURSOR provides flexibility by allowing 
its associated query to be determined or changed dynamically at runtime.

🔹 WHY USE REF CURSOR?

🔹 Dynamic SQL: REF CURSOR variables can be opened for different SELECT statements within the same PL/SQL block, & can be fetched within the 
same procedure in an another block, making them ideal for situations where the exact query structure 
(e.g., the WHERE clause or the tables involved) isnt known until runtime.


---output of ref_cursor

A REF CURSOR in Oracle is a PL/SQL data type that points to a result set in a database.

 DBMS_SQL.return_result(l_cursor);
 
 OPEN L_CURSOR  FOR
 SELECT * FROM EMP;
 DBMS_SQL.return_result(l_cursor);


CREATE OR REPLACE PROCEDURE demo_ref_cursor_blocks
IS
  -- Step 1: Declare REF CURSOR
  TYPE emp_rc IS REF CURSOR;
  l_rc   emp_rc;

  l_empno emp.empno%TYPE;
  l_ename emp.ename%TYPE;
BEGIN
  -- Block 1: OPEN the ref cursor
    OPEN l_rc FOR
      SELECT empno, ename
      FROM emp
      WHERE deptno IN (10,20,30);

  -- Block 2: FETCH the ref cursor
    LOOP
      FETCH l_rc INTO l_empno, l_ename;
      EXIT WHEN l_rc%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE(l_empno ||  -  || l_ename);
    END LOOP;

  -- Block 3: CLOSE the ref cursor
  CLOSE l_rc;

END;
/

🔹 Modularity and Reusability: They can be passed as parameters (IN, OUT, or IN OUT) between stored procedures and functions, or returned from functions, which enables more modular and flexible code design and reduces code duplication.

🔹 Client Communication: REF CURSORs are commonly used to return a result set from a stored procedure or function to a client application (such as Java or .NET), 
which then fetches the data from the database.

🔹 Read-Only & Forward-Only: The result set associated with a REF CURSOR is generally 
read-only (not updatable) and forward-only, meaning you can only access data sequentially.

🔹 TYPES OF REF CURSOR

THERE ARE TWO TYPES:

STRONG REF CURSOR

DECLARED WITH A RETURN TYPE (STRUCTURE OF ROWS IS FIXED).

EXAMPLE:

TYPE EMP_CURSOR IS REF CURSOR RETURN EMP%ROWTYPE;


WEAK REF CURSOR

DECLARED WITHOUT A RETURN TYPE.

CAN BE ASSOCIATED WITH ANY QUERY.

EXAMPLE:

TYPE GENERIC_CURSOR IS REF CURSOR;

🔹 SYNTAX
DECLARE
   TYPE REF_CURSOR_TYPE IS REF CURSOR;  -- WEAK REF CURSOR
   C1 REF_CURSOR_TYPE;
   EMP_RECORD EMP%ROWTYPE;
BEGIN
   OPEN C1 FOR SELECT * FROM EMP;       -- ASSIGN QUERY DYNAMICALLY
   LOOP
      FETCH C1 INTO EMP_RECORD;
      EXIT WHEN C1%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE(EMP_RECORD.EMP_ID ||  -  || EMP_RECORD.EMP_NAME);
   END LOOP;
   CLOSE C1;
END;

🔹 EXAMPLE 1: STRONG REF CURSOR
DECLARE
   TYPE EMP_CURSOR IS REF CURSOR RETURN EMP%ROWTYPE;
   C_EMP EMP_CURSOR;
   R_EMP EMP%ROWTYPE;
BEGIN
   OPEN C_EMP FOR SELECT * FROM EMP;
   LOOP
      FETCH C_EMP INTO R_EMP;
      EXIT WHEN C_EMP%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE(R_EMP.EMPNO ||  -  ||R_EMP.ENAME);
   END LOOP;

   CLOSE C_EMP;
END;

👉 HERE, THE CURSOR CAN ONLY RETURN ROWS OF TYPE EMP%ROWTYPE, MEANING VALUES FROM TEH TABLE EMP ONLY.

🔹 EXAMPLE 2: WEAK REF CURSOR IN A PROCEDURE
CREATE OR REPLACE PROCEDURE GET_EMPS_BY_DEPT (
   P_DEPT_ID IN EMP.DEPT_ID%TYPE,
   P_CURSOR  OUT SYS_REFCURSOR
) AS
BEGIN
   OPEN P_CURSOR FOR
      SELECT EMP_ID, EMP_NAME, SALARY
      FROM EMP
      WHERE DEPT_ID = P_DEPT_ID;
END;


USAGE:

DECLARE
   C1 SYS_REFCURSOR;
   V_EMP_ID EMP.EMP_ID%TYPE;
   V_EMP_NAME EMP.EMP_NAME%TYPE;
   V_SALARY EMP.SALARY%TYPE;
BEGIN
   GET_EMPS_BY_DEPT(10, C1);

   LOOP
      FETCH C1 INTO V_EMP_ID, V_EMP_NAME, V_SALARY;
      EXIT WHEN C1%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE(V_EMP_ID ||  -  || V_EMP_NAME ||  -  || V_SALARY);
   END LOOP;

   CLOSE C1;
END;


👉 VERY COMMON IN REAL PROJECTS, SINCE CLIENT APPLICATIONS (LIKE JAVA, .NET, PYTHON) CAN CONSUME THE SYS_REFCURSOR.

🔹 KEY POINTS TO REMEMBER

NORMAL CURSOR → QUERY IS STATIC, FIXED AT COMPILE TIME.

REF CURSOR → QUERY IS DYNAMIC, DECIDED AT RUNTIME.

STRONG REF CURSOR → BOUND TO A SPECIFIC ROW TYPE.

WEAK REF CURSOR → CAN POINT TO ANY QUERY RESULT SET.

SYS_REFCURSOR → A BUILT-IN WEAK REF CURSOR PROVIDED BY ORACLE.

✅ IN SHORT:
REF CURSORS ARE DYNAMIC CURSORS THAT LET YOU PASS QUERY RESULTS BETWEEN PL/SQL BLOCKS, PROCEDURES, FUNCTIONS, AND CLIENT APPLICATIONS.


--------------------------------------------------------------------------------------------------
WOULD YOU LIKE ME TO ALSO SHOW YOU THE DIFFERENCE BETWEEN REF CURSOR AND NORMAL CURSOR IN A TABULAR FORMAT (WITH USE CASES)?
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

🔹 DIFFERENCE BETWEEN REF CURSOR AND NORMAL CURSOR

FEATUR NORMAL 							(EXPLICIT) CURSOR																										REF CURSOR
-------------------								----------------------																										-----------------
👉DEFINITION					A STATIC CURSOR DEFINED WITH A FIXED SQL QUERY.									A CURSOR VARIABLE (POINTER) THAT CAN BE 								DYNAMICALLY ASSOCIATED WITH DIFFERENT QUERIES AT RUNTIME.
👉QUERY TYPE				QUERY IS FIXED AT COMPILE TIME.																      QUERY IS DYNAMIC, CHOSEN AT RUNTIME.
👉FLEXIBILITY				CANNOT BE REUSED FOR DIFFERENT QUERIES.												SAME REF CURSOR CAN POINT TO MULTIPLE 																																												QUERIES.
👉PASSING BETWEEN 		CANNOT BE PASSED FROM ONE PROCEDURE/FUNCTION TO ANOTHER.			CAN BE PASSED AS A PARAMETER (IN/OUT) TO 																																												PROCEDURES/FUNCTIONS/PACKAGES.
																																																	PROGRAMS									
👉DATA TYPE BINDING	BOUND TO A SPECIFIC QUERY/COLUMNS.													CAN BE STRONG (FIXED ROW TYPE) OR WEAK (ANY																																																 QUERY).
👉USE CASE					ITERATING OVER A SPECIFIC QUERY RESULT SET WITHIN PL/SQL.			RETURNING RESULT SETS TO CLIENT APPLICATIONS (																																									JAVA, .NET, PYTHON,ETC.) OR SHARING BETWEEN 																																														PL/SQL PROGRAMS.
👉PERFORMANCE			SLIGHTLY FASTER FOR FIXED QUERIES.														ADDS A SMALL OVERHEAD, BUT VERY FLEXIBLE.
👉EXAMPLES					CURSOR FOR EMP TABLE ONLY.																CURSOR THAT CAN FETCH FROM EMP, DEPT, OR ANY OTHER TABLE DYNAMICALLY


🔹 EXAMPLE OF NORMAL CURSOR
DECLARE
   CURSOR C_EMP IS
      SELECT EMP_ID, EMP_NAME FROM EMP WHERE DEPT_ID = 10;
   V_EMP_ID EMP.EMP_ID%TYPE;
   V_EMP_NAME EMP.EMP_NAME%TYPE;
BEGIN
   OPEN C_EMP;
   LOOP
      FETCH C_EMP INTO V_EMP_ID, V_EMP_NAME;
      EXIT WHEN C_EMP%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE(V_EMP_ID ||  -  || V_EMP_NAME);
   END LOOP;
   CLOSE C_EMP;
END;


👉 FIXED QUERY → ALWAYS FOR DEPT_ID = 10.

🔹 EXAMPLE OF REF CURSOR
DECLARE
   TYPE REF_CURSOR IS REF CURSOR;
   C1 REF_CURSOR;
   V_EMP_ID EMP.EMP_ID%TYPE;
   V_EMP_NAME EMP.EMP_NAME%TYPE;
BEGIN
   -- QUERY DECIDED AT RUNTIME
   OPEN C1 FOR SELECT EMP_ID, EMP_NAME FROM EMP WHERE DEPT_ID = 20;

   LOOP
      FETCH C1 INTO V_EMP_ID, V_EMP_NAME;
      EXIT WHEN C1%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE(V_EMP_ID ||  -  || V_EMP_NAME);
   END LOOP;

   CLOSE C1;
END;


👉 QUERY IS DYNAMIC, COULD BE FOR DEPT_ID=20, DEPT_ID=30, ETC.

🔹 QUICK SUMMARY

USE NORMAL CURSOR → WHEN QUERY IS FIXED AND USED ONLY INSIDE ONE PL/SQL BLOCK.

USE REF CURSOR → WHEN QUERY IS DYNAMIC OR NEEDS TO BE PASSED TO PROCEDURES/FUNCTIONS OR RETURNED TO APPLICATIONS.

✅ WOULD YOU LIKE ME TO ALSO GIVE YOU A REAL-WORLD USE CASE WHERE REF CURSOR IS NECESSARY (E.G., RETURNING QUERY RESULTS FROM ORACLE TO A FRONT-END APPLICATION LIKE JAVA)?

YES




🔑 Key Idea (Very Simple Words)

REF CURSOR = pointer to SELECT result
Procedure opens cursor
Caller fetches data
One execution → many rows

---------------REF_CURSOR------------
SET SERVEROUTPUT ON;

DECLARE
R_CUR SYS_REFCURSOR;
V_NAME VARCHAR2(50);
V_CELL NUMBER(20);
BEGIN
OPEN R_CUR FOR SELECT NAME INTO V_NAME FROM EMPP WHERE D_ID=50;
LOOP
FETCH R_CUR INTO V_NAME;
EXIT WHEN R_CUR%NOTFOUND;
DBMS_OUTPUT.PUT_LINE(V_NAME);
END LOOP;
END;
/


-------------------------------17-DEC----------------------------

CREATE TABLE t2 (
    id   NUMBER,
    name VARCHAR2(20)
);

INSERT ALL
INTO T2 (ID, NAME) VALUES (1,A)
INTO T2 (ID, NAME) VALUES (2,B)
INTO T2 (ID, NAME) VALUES (3,C)
SELECT * FROM DUAL;


CREATE OR REPLACE PROCEDURE p_get_t2 (
    p_cur OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_cur FOR
        SELECT * FROM t2;
END;
/



VAR c REFCURSOR
EXEC p_get_t2(:c)
PRINT c

VARIABLE REF_CUR REFCURSOR						------< REF_CUR 	--> SYS_REFCURSOR VARIABLE (CREATE OR REPLACE PROCEDURE PROC_EMP_RCUR  (D_NO IN NUMBER, REF_CUR OUT SYS_REFCURSOR)
EXEC PROC_EMP_RCUR(50, :REF_CUR);



--------------------USING REF CURSOR AS OUT PARAMETER--IN PROCEDURE------------


CREATE OR REPLACE PROCEDURE PROC_RCUR (
DEP_ID IN NUMBER,
R_CUR IN OUT SYS_REFCURSOR)
IS
BEGIN
OPEN R_CUR
FOR
SELECT E.NAME, E.ID, D.DEPARTMENT_NAME 
FROM  EMPP E, DEPARTMENTS D
WHERE E.D_ID = D.DEPARTMENT_ID
AND D_ID = DEP_ID;
END;
/


VAR c REFCURSOR
EXEC PROC_RCUR(40, :c)
PRINT c



CREATE OR REPLACE PROCEDURE PROC_RCUR (
DEP_ID IN NUMBER,
R_CUR IN OUT SYS_REFCURSOR)
IS
BEGIN
OPEN R_CUR
FOR
SELECT E.ENAME, E.EMPNO, D.DEPARTMENT_NAME 
FROM  EMP E, DEPARTMENTS D
WHERE E.DEPTNO = D.DEPARTMENT_ID
AND E.DEPTNO = DEP_ID;
DBMS_SQL.RETURN_RESULT(R_CUR);
END;
/

DECLARE
REF_CUR SYS_REFCURSOR;
BEGIN
PROC_RCUR(10,REF_CUR);
END;
/

--------------SAME QUERIES FOR FETCHING DATA FROM DIFF TABLES-------------

CREATE OR REPLACE PROCEDURE get_joined_data_safe (
    p_cursor OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN p_cursor FOR
        SELECT 
            e.EMPLOYEE_ID,
            e.FIRST_NAME,
            e.salary,
            e.DEPARTMENT_ID AS emp_dept_id,  -- Alias to avoid conflict
            e.hire_date,
            d.DEPARTMENT_ID AS dept_dept_id,  -- Alias to avoid conflict
            d.DEPARTMENT_NAME,
            d.LOCATION_ID
        FROM employees e
        JOIN departments d ON e.DEPARTMENT_ID = d.DEPARTMENT_ID
        ORDER BY e.EMPLOYEE_ID;
         DBMS_SQL.return_result(p_cursor);
END get_joined_data_safe;
/

-- Paste this into SQL Developer and hit F5 (Run Script)
DECLARE
    v_my_cursor SYS_REFCURSOR;
BEGIN
    get_joined_data_safe(v_my_cursor);
END;
/


-- 1. Declare a bind variable to accept the OUT parameter
VARIABLE rc REFCURSOR;

-- 2. Execute the procedure
EXEC get_joined_data_safe(:rc);

-----------------------------------------------ALTERNATIVE LIKE--------------

CREATE OR REPLACE PROCEDURE get_joined_data_safe
IS
 p_cursor SYS_REFCURSOR;
BEGIN
    OPEN p_cursor FOR
        SELECT 
            e.EMPLOYEE_ID,
            e.FIRST_NAME,
            e.salary,
            e.DEPARTMENT_ID AS emp_dept_id,  -- Alias to avoid conflict
            e.hire_date,
            d.DEPARTMENT_ID AS dept_dept_id,  -- Alias to avoid conflict
            d.DEPARTMENT_NAME,
            d.LOCATION_ID
        FROM employees e
        JOIN departments d ON e.DEPARTMENT_ID = d.DEPARTMENT_ID
        ORDER BY e.EMPLOYEE_ID;
         DBMS_SQL.return_result(p_cursor);                                  --------USING THIS REF CUSOR TO0L
END get_joined_data_safe;
/

BEGIN
    get_joined_data_safe;
END;
/

--EX-1----------

 
 CREATE OR REPLACE PROCEDURE PROC_EMP_RCUR  (D_NO IN NUMBER, REF_CUR OUT SYS_REFCURSOR)
 AS
V_NAME VARCHAR2(50);        
V_SAL NUMBER;      
BEGIN
OPEN REF_CUR FOR
SELECT ENAME, SAL FROM EMP WHERE DEPTNO = D_NO;
LOOP
FETCH REF_CUR INTO V_NAME, V_SAL;
EXIT WHEN REF_CUR%NOTFOUND;
DBMS_OUTPUT.PUT_LINE(V_NAME||' '||V_SAL);
END LOOP;
END;
/


VARIABLE REF_CUR REFCURSOR
EXEC PROC_EMP_RCUR(50, :REF_CUR);


DECLARE
    v_cursor SYS_REFCURSOR;
BEGIN
    PROC_EMP_RCUR(10,v_cursor);
END;
/

--EX-2----------

 CREATE OR REPLACE PROCEDURE PROC_EMP_RCUR_TOOL  (D_NO IN NUMBER, REF_CUR OUT SYS_REFCURSOR)			---> W/O LOOP, FETCH, EXIT USING - "DBMS_SQL.RETURN_RESULT(REF_CUR)";
 AS
BEGIN
OPEN REF_CUR FOR
SELECT ENAME, SAL FROM EMP WHERE DEPTNO = D_NO;
DBMS_SQL.RETURN_RESULT(REF_CUR);
END;
/

DECLARE
V_CUR SYS_REFCURSOR;
BEGIN
PROC_EMP_RCUR_TOOL(10,V_CUR);
END;
/


--EX-3------------------

CREATE OR REPLACE PROCEDURE PROC_EMP_RCUR_TOOL  (D_NO IN NUMBER)
 AS
REF_CUR  SYS_REFCURSOR;
BEGIN
OPEN REF_CUR FOR
SELECT ENAME, SAL FROM EMP WHERE DEPTNO = D_NO;
DBMS_SQL.RETURN_RESULT(REF_CUR);
END;
/

DECLARE
V_CUR SYS_REFCURSOR;
BEGIN
PROC_EMP_RCUR_TOOL(10);
END;
/

----DIFFERENT QUERIES FROM TEH SAME TABLE-------------------------

DECLARE
   TYPE EMP_CURSOR IS REF CURSOR RETURN EMP%ROWTYPE;
   C_EMP EMP_CURSOR;
   R_EMP EMP%ROWTYPE;
BEGIN
   OPEN C_EMP FOR SELECT * FROM EMP where SAL < 10000;
   LOOP
      FETCH C_EMP INTO R_EMP;
      EXIT WHEN C_EMP%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE(R_EMP.EMPNO ||  -  ||R_EMP.ENAME||  ||R_EMP.SAL);
   END LOOP;
   CLOSE C_EMP;
      DBMS_OUTPUT.PUT_LINE(--------------------------------------------);
    OPEN C_EMP FOR SELECT * FROM EMP where deptno IN (10,20,30);
   LOOP
      FETCH C_EMP INTO R_EMP;
      EXIT WHEN C_EMP%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE(EMPLOYEES IN DEP 10,20,30 - ||R_EMP.EMPNO ||  -  ||R_EMP.ENAME|| ||R_EMP.DEPTNO);
   END LOOP;
   CLOSE C_EMP;
END;
/
---------------------FUNCTION-WITH REF CURSOR-----------

CREATE OR REPLACE FUNCTION FUNC_RCUR (
DEP_ID IN NUMBER)
RETURN SYS_REFCURSOR
IS
    L_CURSOR SYS_REFCURSOR;
BEGIN
    OPEN L_CURSOR
                              FOR
                                    SELECT E.NAME, E.ID, D.DEPARTMENT_NAME 
                                    FROM  EMPP E, DEPARTMENTS D
                                    WHERE E.D_ID = D.DEPARTMENT_ID
                                    AND D_ID = DEP_ID;
                         RETURN L_CURSOR;
END;
/

VAR rc REFCURSOR
EXEC :rc := FUNC_RCUR(50)
PRINT rc


----EX--2--------------------


CREATE OR REPLACE FUNCTION FUNC_EMP(E_ID IN NUMBER)
RETURN SYS_REFCURSOR
AS
REF_CUR SYS_REFCURSOR;
BEGIN
OPEN REF_CUR FOR
SELECT ENAME  FROM EMP WHERE EMPNO = E_ID;
RETURN REF_CUR;
END;
/
--

DECLARE
V_REF_CUR SYS_REFCURSOR;
V_ENAME VARCHAR2(40);
BEGIN
--CALL
V_REF_CUR:=FUNC_EMP(101);
        LOOP
        --FETCH
        FETCH V_REF_CUR INTO V_ENAME;
        EXIT WHEN V_REF_CUR%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(V_ENAME);
        END LOOP;
END;
/

VAR V_REF_CUR REFCURSOR
EXEC :V_REF_CUR := FUNC_EMP(102)
PRINT V_REF_CUR



-----ex-3--------------------------


CREATE OR REPLACE FUNCTION FUNC_EMP(E_ID IN NUMBER)
RETURN SYS_REFCURSOR
AS
REF_CUR SYS_REFCURSOR;
BEGIN
OPEN REF_CUR FOR
SELECT ENAME, SAL, DEPTNO  FROM EMP WHERE EMPNO = E_ID;
RETURN REF_CUR;
END;
/
--

DECLARE
V_REF_CUR SYS_REFCURSOR;
V_ENAME VARCHAR2(40);
V_SAL NUMBER;
V_DEP NUMBER;
BEGIN
--CALL
V_REF_CUR:=FUNC_EMP(101);
        LOOP
        --FETCH
        FETCH V_REF_CUR INTO V_ENAME, V_SAL, V_DEP;
        EXIT WHEN V_REF_CUR%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(V_ENAME||' is having a salary of - '||V_SAL||' while working in Department No - '||V_DEP);
        END LOOP;
END;
/

VAR V_REF_CUR REFCURSOR
EXEC :V_REF_CUR := FUNC_EMP(102)
PRINT V_REF_CUR


DBMS_SQL.RETURN_RESULT is a procedure that:

Sends a REF CURSOR result directly to the client (like SQL Developer) without needing FETCH or LOOP.

-------------------------------------------------------

--------------------------------ANONYMOUS BLOCK OF REF_CURSOR-------------

DECLARE
V_REF_CUR SYS_REFCURSOR;
V_NAME VARCHAR2(40);
V_ID NUMBER;
V_DEP_NAME VARCHAR2(40);
BEGIN
    OPEN V_REF_CUR
                FOR SELECT E.ID, E.NAME, D.DEPARTMENT_NAME
                FROM EMPP E, DEPARTMENTS D
                WHERE E.D_ID = D.DEPARTMENT_ID;
    LOOP
            FETCH V_REF_CUR INTO V_ID, V_NAME, V_DEP_NAME;
            EXIT WHEN V_REF_CUR%NOTFOUND;
           DBMS_OUTPUT.PUT_LINE(V_ID|| || V_NAME|| || V_DEP_NAME);
    END LOOP;
END;
        
   

------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------

													FUNTION					PROCEDURE
IN PARAMETER						LOOP IN DEFINITION		LOOP IN DEFINITION
											OPEN IN EXECUTION		 OPEN IN EXECUTION (734)
	
OUT PARAMETER					OPEN IN DECLARTION		OPEN IN DECLARTION (702)
RETURN SYS_REFCURSOR 			LOOP IN EXECUTION 		LOOP IN EXECUTION
							

A REF CURSOR IN parameter means:
the cursor is opened outside, and the procedure only reads from it.

✔ Procedure does not OPEN the cursor
✔ It only FETCHES from it
✔ Caller is responsible for opening & closing the cursor   



| Mode   | Who opens | Who reads | Who closes |
| ------ | --------- | --------- | ---------- |
| IN     | Caller    | Procedure | Caller     |
| OUT    | Procedure | Caller    | Caller     |
| IN OUT | Either    | Either    | Caller     |


----------------------REF CURSOR AS IN PARAMETER--------------------
--1. PROCEDURE
/*
* CURSOR OPEN OUTSIDE OF THE PROC OR FUNC
*/
SELECT * FROM T2;

CREATE OR REPLACE PROCEDURE OUT_REF_CUR (
REF_CUR IN SYS_REFCURSOR
) 
IS
--V_ID T2.ID%TYPE;
--V_NAME T2.NAME%TYPE;
V_T T2%ROWTYPE;
BEGIN
        LOOP
            FETCH REF_CUR INTO V_T;--V_ID, V_NAME;
            EXIT WHEN REF_CUR%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(V_T.ID|| || V_T.NAME);
        END LOOP;
END;
/

----OPENING PART

DECLARE
C SYS_REFCURSOR;
BEGIN
OPEN C FOR SELECT ID, NAME FROM T2;
OUT_REF_CUR(C);
CLOSE C;
END;
/

------------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE SAMEER_EMP (DEPTNO IN EMP.DEPTNO%TYPE)
AS
L_CURSOR SYS_REFCURSOR;
BEGIN
OPEN L_CURSOR FOR 
SELECT 
EMPNO, ENAME, SAL FROM EMP WHERE DEPTNO=30;
--DBMS_SQL.RETURN_RESULT(L_CURSOR);
END;
/

SET SERVEROUTPUT ON;
EXEC SAMEER_EMP(30);


-------------------------DEC-16-----------------------



CREATE TABLE t1 (id NUMBER, description VARCHAR2(30));
INSERT INTO t1 VALUES (1, First result);
INSERT INTO t1 VALUES (2, Second result);
COMMIT;

CREATE OR REPLACE
PROCEDURE RETURN_RESULT (rc IN OUT SYS_REFCURSOR,
                         to_client IN BOOLEAN DEFAULT TRUE);
                         BEGIN
                         END;
CREATE OR REPLACE
PROCEDURE RETURN_RESULT (rc IN OUT INTEGER,
                         to_client IN BOOLEAN DEFAULT TRUE);
                         
                         
                         PROCEDURE RETURN_RESULT (rc IN OUT SYS_REFCURSOR,
                         to_client IN BOOLEAN DEFAULT TRUE);

PROCEDURE RETURN_RESULT (rc IN OUT INTEGER,
                         to_client IN BOOLEAN DEFAULT TRUE);



CREATE OR REPLACE PROCEDURE get_data
AS
    c1 SYS_REFCURSOR;
    c2 SYS_REFCURSOR;
BEGIN
    -- Open the first cursor for the first result set
    OPEN c1 FOR SELECT id, description FROM t1 WHERE id = 1;
    -- Return the first result set
    DBMS_SQL.RETURN_RESULT(c1);

    -- Open the second cursor for the second result set
    OPEN c2 FOR SELECT description, id FROM t1 WHERE id = 2;
    -- Return the second result set
    DBMS_SQL.RETURN_RESULT(c2);
END;
/


CREATE OR REPLACE PROCEDURE get_customer_by_credit(
    min_credit NUMBER
)
AS 
    c_customers SYS_REFCURSOR;
BEGIN
    -- open the cursor
    OPEN c_customers FOR
        SELECT ID, SAL, name
        FROM EMPP
        WHERE SAL > min_credit
        ORDER BY SAL;
    -- return the result set
    dbms_sql.return_result(c_customers);
END;


DECLARE
L_CURSOR SYS_REFCURSOR;
BEGIN
OPEN L_CURSOR FOR 
SELECT 
ID, NAME, SAL FROM EMPP WHERE D_ID=30;
DBMS_SQL.RETURN_RESULT(L_CURSOR);
END;
/


CREATE OR REPLACE PROCEDURE SAMEER_EMP (DEPARTMENT_ID IN EMP.DEPARTMENT_ID%TYPE)
AS
  l_cursor  SYS_REFCURSOR;
BEGIN
  OPEN l_cursor FOR SELECT employee_id, first_name, last_name FROM EMP;
  DBMS_SQL.RETURN_RESULT(l_cursor);
END;
/


------------------------------------------------------------


CREATE OR REPLACE PROCEDURE SAMEER_EMP
AS
 c1 SYS_REFCURSOR;
  c2 SYS_REFCURSOR;
BEGIN
  OPEN c1 FOR
    SELECT first_name, last_name
    FROM employees
    WHERE employee_id = 176;
 
  --DBMS_SQL.RETURN_RESULT (c1);
  -- Now p cannot access the result.
 
  OPEN c2 FOR
    SELECT city, state_province
    FROM locations
    WHERE country_id = AU;
 
  --DBMS_SQL.RETURN_RESULT (c2);
  -- Now p cannot access the result.
END;
/

DBMS_SQL.RETURN_RESULT(
   C1           IN OUT      SYS_REFCURSOR, 
   to_client    IN          BOOLEAN           DEFAULT TRUE);

DBMS_SQL.RETURN_RESULT(
   c2           IN OUT      INTEGER, 
   to_client    IN          BOOLEAN           DEFAULT TRUE);
   
   
------------------------------------------------------------------

---------------USING DBMS_SQL.RETURN_RESULT(CURSOR_NAME) FROM 12C VERSION--------------------------

CREATE OR REPLACE PROCEDURE SAMEER_EMP (DEPTNO IN EMP.DEPTNO%TYPE)
AS
L_CURSOR SYS_REFCURSOR;
BEGIN
OPEN L_CURSOR FOR 
SELECT NAME, ID, SAL FROM EMPP WHERE D_ID=50;
--DBMS_SQL.RETURN_RESULT(L_CURSOR);
END;
/

SET SERVEROUTPUT ON;
EXEC SAMEER_EMP(30);

DECLARE
   TYPE REF_CURSOR IS REF CURSOR;
   C1 REF_CURSOR;
   V_EMP_ID EMP.EMPLOYEE_ID%TYPE;
   V_EMP_NAME EMP.FIRST_NAME%TYPE;
BEGIN
   -- QUERY DECIDED AT RUNTIME
   OPEN C1 FOR SELECT EMPLOYEE_ID, FIRST_NAME FROM EMP WHERE DEPARTMENT_ID = 50;

   LOOP
      FETCH C1 INTO V_EMP_ID, V_EMP_NAME;
      EXIT WHEN C1%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE(V_EMP_ID ||  -  || V_EMP_NAME);
     -- DBMS_SQL.RETURN_RESULT (C1);
   END LOOP;

   CLOSE C1;
END;


---------------------TIPS n TRICKS-------------

Strong REF CURSOR is Bound to a fixed return structure
Weak REF CURSOR	Not bound to any return structure

------PROC WITH AN OUT PARAMETER -> GETTING THE VALUES FROM TABLES THEN FETCHING INTO TEH DECLARE variables
------LEADS TO UNDERSTANDING THAT WENER WE NEED TO DISPLAY THE OUTPUT OF TABLE VALUES NEED TO DECLARE THE REF CUROSR AS OUT PARAEMTER OF 
------- PROCEDURE & THEN NEED TO CALL IT WITH THE EXECUTION BLOCK WHILE GIVIGN ITS NAME.

🔹 EXAMPLE 1: WEAK REF CURSOR
DECLARE
   TYPE REF_CURSOR_TYPE IS REF CURSOR;  -- WEAK REF CURSOR
   C1 REF_CURSOR_TYPE;
   EMP_RECORD EMP%ROWTYPE;
BEGIN
   OPEN C1 FOR SELECT * FROM EMP;       -- ASSIGN QUERY DYNAMICALLY
   LOOP
      FETCH C1 INTO EMP_RECORD;
      EXIT WHEN C1%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE(EMP_RECORD.EMP_ID ||  -  || EMP_RECORD.EMP_NAME);
   END LOOP;
   CLOSE C1;
END;

🔹 EXAMPLE 2: STRONG REF CURSOR
-------------------------------
DECLARE
   TYPE EMP_CURSOR IS REF CURSOR RETURN EMP%ROWTYPE;
   C_EMP EMP_CURSOR;
   R_EMP EMP%ROWTYPE;
BEGIN
   OPEN C_EMP FOR SELECT * FROM EMP WHERE DEPT_ID = 10;

   LOOP
      FETCH C_EMP INTO R_EMP;
      EXIT WHEN C_EMP%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE(R_EMP.EMP_ID ||  -  || R_EMP.EMP_NAME);
   END LOOP;

   CLOSE C_EMP;
END;


🔹 EXAMPLE 3: PROC WITH OUT PARAMERER AS WEAK REF CURSOR
---------------------------------------------------------
------REF CURSOR AS OUT PARAMETER------------------------

** REF CURSOR IN PROCEDURE IS CALLED AFTER OPEN & BEFORE LOOP n FETCH IN THE CALLING STATEMENT

CREATE OR REPLACE PROCEDURE PROC_RCUR11
(
R_CUR OUT SYS_REFCURSOR			-------> DISPLAY THE OUTPUT OF TABLE VALUES NEED TO DECLARE THE REF CUROSR AS OUT PARAEMTER OF PROCEDURE
)
IS
BEGIN
OPEN R_CUR
FOR
SELECT E.ENAME, E.EMPNO, D.DEPARTMENT_NAME 
FROM  EMPP E, DEPARTMENTS D
WHERE E.DEPTNO = D.DEPARTMENT_ID
AND E.DEPTNO = 30;
END;
/

DECLARE
R_CUR SYS_REFCURSOR;
E_NAME EMPP.ENAME%TYPE;
E_NO EMPP.EMPNO%TYPE;
D_NAME DEPARTMENTS.DEPARTMENT_NAME%TYPE;
BEGIN
PROC_RCUR11(R_CUR);						------> THEN NEED TO CALL IT WITH THE EXECUTION BLOCK WHILE GIVIGN ITS NAME.
LOOP
FETCH R_CUR INTO E_NAME, E_NO, D_NAME;
EXIT WHEN R_CUR%NOTFOUND;
DBMS_OUTPUT.PUT_LINE(E_NAME|| || E_NO|| || D_NAME);
END LOOP;
CLOSE R_CUR;
END;
/


🔹 EXAMPLE 4: PROC WITH IN PARAMERER AS WEAK REF CURSOR
--------------------------------------------------------
------REF CURSOR AS IN PARAMETER------------------------

CREATE OR REPLACE PROCEDURE PROC_RCUR11(
R_CUR IN  SYS_REFCURSOR)		------->  DECLARE THE REF CUROSR AS IN PARAEMTER OF PROCEDURE
AS
E_NAME EMPP.ENAME%TYPE;
E_NO EMPP.EMPNO%TYPE;
D_NAME DEPARTMENTS.DEPARTMENT_NAME%TYPE;
BEGIN
LOOP
FETCH R_CUR INTO E_NAME, E_NO, D_NAME;
EXIT WHEN R_CUR%NOTFOUND;
DBMS_OUTPUT.PUT_LINE(E_NAME|| || E_NO|| || D_NAME);
END LOOP;
END;
/

DECLARE									-------> EXECUTION
R_CUR SYS_REFCURSOR;
BEGIN
OPEN R_CUR
FOR
SELECT E.ENAME, E.EMPNO, D.DEPARTMENT_NAME 
FROM  EMPP E, DEPARTMENTS D
WHERE E.DEPTNO = D.DEPARTMENT_ID
AND E.DEPTNO = 30;
PROC_RCUR11(R_CUR);
close R_CUR;
END;                                                                        
/



🔹 EXAMPLE 5: DECLARING & UTILIZING TEH DECLARED REF CURSOR INTO A SINGLE PROCEDURE ITSELF--------------
--------------------------------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE demo_ref_cursor_blocks
IS
  -- Step 1: Declare REF CURSOR  --- BELOW IS THE MODE OF DECLARING A REFCURSOR (WEAK/STRONG)
  TYPE emp_rc IS REF CURSOR;
  l_rc   emp_rc;

  l_empno empp.empno%TYPE;
  l_ename empp.ename%TYPE;
BEGIN
  -- Block 1: OPEN the ref cursor
  BEGIN
    OPEN l_rc FOR
      SELECT empno, ename
      FROM empp
      WHERE deptno = 10;
  END;

  -- Block 2: FETCH the ref cursor
  BEGIN
    LOOP
      FETCH l_rc INTO l_empno, l_ename;
      EXIT WHEN l_rc%NOTFOUND;

      DBMS_OUTPUT.PUT_LINE(l_empno ||  -  || l_ename);
    END LOOP;
  END;

  -- Block 3: CLOSE the ref cursor
  CLOSE l_rc;

END;
/

exec DEMO_REF_CURSOR_BLOCKS			-------HERE AFER GETTING COMPILED EXECUTING IT......

-------------------------------------------------------------------------
-----------FUNC WITH IN/OUT PARAMERER AS WEAK REF CURSOR----------------
---------------------------------------------------------------------------

One-line interview answer:

** A function can return table data using a REF CURSOR, but the output must be consumed in PL/SQL, not directly in SQL.

** REF CURSOR IN FUNCTION IS CALLED AFTER OPEN & BEFORE LOOP n FETCH IN THE CALLING STATEMENT


🔹 EXAMPLE 6: FUNC WITH IN PARAMERER AS WEAK REF CURSOR
---------------------------------------------------------
------REF CURSOR AS IN PARAMETER------------------------

CREATE OR REPLACE FUNCTION fn_print_emps
(
  p_rc IN SYS_REFCURSOR
)
RETURN NUMBER
IS
  v_empno emp.empno%TYPE;
  v_ename emp.ename%TYPE;
  v_count NUMBER := 0;
BEGIN
  LOOP
    FETCH p_rc INTO v_empno, v_ename;
    EXIT WHEN p_rc%NOTFOUND;

    DBMS_OUTPUT.PUT_LINE(v_empno ||   || v_ename);
    v_count := v_count + 1;
  END LOOP;

  RETURN v_count;
END;
/


DECLARE
  v_rc    SYS_REFCURSOR;
  v_total NUMBER;
BEGIN
  OPEN v_rc FOR
    SELECT empno, ename FROM emp WHERE deptno = 10;

  v_total := fn_print_emps(v_rc);

  CLOSE v_rc;

  DBMS_OUTPUT.PUT_LINE(Rows processed:  || v_total);
END;
/

🔹 EXAMPLE 7: FUNC WITH OUT PARAMERER AS WEAK REF CURSOR
---------------------------------------------------------
------REF CURSOR AS OUT PARAMETER------------------------


CREATE OR REPLACE FUNCTION fn_get_emps
(
  p_deptno IN empp.deptno%TYPE,
  p_rc     OUT SYS_REFCURSOR
)
RETURN VARCHAR2
IS
BEGIN
  OPEN p_rc FOR
    SELECT empno, ename, sal
    FROM empp
    WHERE deptno = p_deptno;

  RETURN SUCCESS;
END;
/


DECLARE
  v_rc    SYS_REFCURSOR;
  v_empno empp.empno%TYPE;
  v_ename empp.ename%TYPE;
  v_sal   empp.sal%TYPE;
  v_msg   VARCHAR2(20);
BEGIN
  v_msg := fn_get_emps(10, v_rc);

  DBMS_OUTPUT.PUT_LINE(Status:  || v_msg);

  LOOP
    FETCH v_rc INTO v_empno, v_ename, v_sal;
    EXIT WHEN v_rc%NOTFOUND;

    DBMS_OUTPUT.PUT_LINE(
      v_empno ||   || v_ename ||   || v_sal
    );
  END LOOP;

  CLOSE v_rc;
END;
/

🔹 EXAMPLE 8: FUNC WITHOUT PARAMERER DECLARED AS WEAK REF CURSOR---------
-------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION FN_GET_EMPLOYEES -- (d_id in empp%type)
RETURN SYS_REFCURSOR
IS
  V_RC SYS_REFCURSOR;
BEGIN
  OPEN V_RC FOR
    SELECT EMPNO, ENAME, SAL
    FROM EMPP
    WHERE DEPTNO = 30;		---d_id
  RETURN V_RC;
END;
/

DECLARE
  V_RC    SYS_REFCURSOR;
  V_EMPNO EMPP.EMPNO%TYPE;
  V_ENAME EMPP.ENAME%TYPE;
  V_SAL   EMPP.SAL%TYPE;
BEGIN
  V_RC := FN_GET_EMPLOYEES();		---FN_GET_EMPLOYEES(d_id)

  LOOP
    FETCH V_RC INTO V_EMPNO, V_ENAME, V_SAL;
    EXIT WHEN V_RC%NOTFOUND;

    DBMS_OUTPUT.PUT_LINE(
      V_EMPNO ||   || V_ENAME ||   || V_SAL
    );

  END LOOP;
  CLOSE V_RC;
END;
/

--------------------------------------------------------------------------------------
🔹 EXAMPLE 9: FUNC WITH IN PARAMERER AS WEAK REF CURSOR FOR GETTING TEH COUNT OF ROWS
--------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION FN_COUNT_ROWS (
    P_CUR IN SYS_REFCURSOR
)
RETURN NUMBER
IS
    V_ID   NUMBER;
    V_NAME VARCHAR2(30);
    V_CNT  NUMBER := 0;
BEGIN
    LOOP
        FETCH P_CUR INTO V_ID, V_NAME;
        EXIT WHEN P_CUR%NOTFOUND;
        V_CNT := V_CNT + 1;
    END LOOP;

    RETURN V_CNT;
END;
/


---CALLING

DECLARE
    C SYS_REFCURSOR;
    V_COUNT NUMBER;
BEGIN
    OPEN C FOR
        SELECT EMPNO, ENAME
        FROM EMPP;

    V_COUNT := FN_COUNT_ROWS(C);

    DBMS_OUTPUT.PUT_LINE(ROWS =  || V_COUNT);

    CLOSE C;
END;
/



								FUNTION					PROCEDURE
IN PARAMETER				LOOP IN DEFINITION		LOOP IN DEFINITION
							OPEN IN EXECUTION		 OPEN IN EXECUTION (734)
	
OUT PARAMETER				OPEN IN DECLARTION		OPEN IN DECLARTION (702)
RETURN SYS_REFCURSOR 		LOOP IN EXECUTION 		LOOP IN EXECUTION
							
	
---------------------------------------PRACTICE 2-FEB----------------------------------	
RETURN SYS_REFCURSOR 		LOOP IN EXECUTION 		LOOP IN EXECUTION
---------------------------------------PRACTICE 2-FEB---------------

-------------------------REF CURSOR---------------------

CREATE OR REPLACE PROCEDURE demo_ref_cursor_blocks
IS
  -- Step 1: Declare REF CURSOR
  TYPE emp_rc IS REF CURSOR;
  l_rc   emp_rc;

  l_empno emp.empno%TYPE;
  l_ename emp.ename%TYPE;
BEGIN
  -- Block 1: OPEN the ref cursor
    OPEN l_rc FOR
      SELECT empno, ename
      FROM emp
      WHERE deptno IN (10,20,30);

  -- Block 2: FETCH the ref cursor
    LOOP
      FETCH l_rc INTO l_empno, l_ename;
      EXIT WHEN l_rc%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE(l_empno ||  -  || l_ename);
    END LOOP;

  -- Block 3: CLOSE the ref cursor
  CLOSE l_rc;

END;
/

EXEC demo_ref_cursor_blocks;
--SET SERVEROUTPUT ON;


---WEAK REF CURSOR----------
DECLARE
TYPE T IS REF CURSOR;
V_EMP T;
V_NAME EMP.ENAME%TYPE;
V_SAL EMP.SAL%TYPE;
V_DEP EMP.DEPTNO%TYPE;
BEGIN
OPEN V_EMP FOR SELECT ENAME, SAL, DEPTNO FROM EMP;
LOOP
FETCH V_EMP INTO V_NAME, V_SAL, V_DEP;
EXIT WHEN V_EMP%NOTFOUND;
DBMS_OUTPUT.PUT_LINE(V_NAME|| - ||V_SAL|| - ||V_DEP);
END LOOP;
END;
/



DECLARE
TYPE EMP_CUR IS REF CURSOR;
TYPE DEP_CUR IS REF CURSOR;
V_EMP EMP_CUR;
V_DEP DEP_CUR;

V_EMP_COL EMP%ROWTYPE;
V_DEP_COL DEPT%ROWTYPE;
BEGIN
        OPEN V_EMP FOR SELECT * FROM EMP;
        LOOP
        FETCH V_EMP INTO V_EMP_COL;
        EXIT WHEN V_EMP%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(V_EMP_COL.ENAME|| - ||V_EMP_COL.SAL|| - ||V_EMP_COL.DEPTNO);
        END LOOP;
        
        OPEN V_DEP FOR SELECT * FROM DEPT;
        LOOP
        FETCH V_DEP INTO V_DEP_COL;
        EXIT WHEN V_DEP%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(V_DEP_COL.DEPARTMENT_ID|| - ||V_DEP_COL.LOCATION_ID|| - ||V_DEP_COL.DEPARTMENT_NAME);
        END LOOP;
        
END;
/


DECLARE
    TYPE EMP_CUR IS REF CURSOR;
    V_EMP EMP_CUR;
    V_EMP_COL EMP%ROWTYPE; -- Expects ALL columns
BEGIN
    -- Change 1: Select * instead of specific columns
    OPEN V_EMP FOR SELECT * FROM EMP;
    LOOP
        FETCH V_EMP INTO V_EMP_COL;
        EXIT WHEN V_EMP%NOTFOUND;
        -- Now you can access any column (e.g., EMPNO)
        DBMS_OUTPUT.PUT_LINE(V_EMP_COL.EMPNO ||  -  || V_EMP_COL.ENAME ||  -  || V_EMP_COL.SAL);
    END LOOP;
    CLOSE V_EMP; -- Good practice to close the cursor
END;
/

---STONG REF CURSOR----------

DECLARE
   TYPE EMP_CURSOR IS REF CURSOR RETURN EMP%ROWTYPE;
   C_EMP EMP_CURSOR;
   R_EMP EMP%ROWTYPE;
BEGIN
   OPEN C_EMP FOR SELECT * FROM EMP where SAL < 10000;
   LOOP
      FETCH C_EMP INTO R_EMP;
      EXIT WHEN C_EMP%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE(R_EMP.EMPNO ||  -  ||R_EMP.ENAME||  ||R_EMP.SAL);
   END LOOP;
   CLOSE C_EMP;
      DBMS_OUTPUT.PUT_LINE(--------------------------------------------);
    OPEN C_EMP FOR SELECT * FROM EMP where deptno IN (10,20,30);
   LOOP
      FETCH C_EMP INTO R_EMP;
      EXIT WHEN C_EMP%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE(EMPLOYEES IN DEP 10,20,30 - ||R_EMP.EMPNO ||  -  ||R_EMP.ENAME|| ||R_EMP.DEPTNO);
   END LOOP;
   CLOSE C_EMP;
END;
/
 -----------PROCEDURE----------
 
 CREATE OR REPLACE PROCEDURE get_joined_data_safe (
    p_cursor OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN p_cursor FOR
        SELECT 
            e.EMPLOYEE_ID,
            e.FIRST_NAME,
            e.salary,
            e.DEPARTMENT_ID AS emp_dept_id,  -- Alias to avoid conflict
            e.hire_date,
            d.DEPARTMENT_ID AS dept_dept_id,  -- Alias to avoid conflict
            d.DEPARTMENT_NAME,
            d.LOCATION_ID
        FROM employees e
        JOIN departments d ON e.DEPARTMENT_ID = d.DEPARTMENT_ID
        ORDER BY e.EMPLOYEE_ID;
         DBMS_SQL.return_result(p_cursor);
END get_joined_data_safe;
/

-- Paste this into SQL Developer and hit F5 (Run Script)
DECLARE
    v_my_cursor SYS_REFCURSOR;
BEGIN
    get_joined_data_safe(v_my_cursor);
END;
/


-- 1. Declare a bind variable to accept the OUT parameter
VARIABLE rc REFCURSOR;

-- 2. Execute the procedure
EXEC get_joined_data_safe(:rc);

-- Output will appear here automatically starting in Oracle 12c
-- If the data doesnt appear automatically, you can run:
-- PRINT rc;
/
 							
--------------------------------------------------18-FEB----------------------------------

DECLARE
REF_CUR SYS_REFCURSOR;           ----RETURN EMP%ROWTYPE  -----< FOR STRONG REF CURSOR
V_NAME VARCHAR2(50);        --EMP.ENAME%TYPE;
V_SAL NUMBER;                       --EMP.SAL%TYPE;
BEGIN
OPEN REF_CUR FOR
SELECT ENAME, SAL INTO V_NAME, V_SAL FROM EMP WHERE DEPTNO = 50;
    LOOP
    FETCH REF_CUR INTO V_NAME, V_SAL;
    EXIT WHEN REF_CUR%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(V_NAME||' has a salary of - '||V_SAL||' being in the department 50');
    END LOOP;
    
BEGIN
    OPEN REF_CUR FOR
    SELECT FIRST_NAME||' '||LAST_NAME, SALARY INTO V_NAME, V_SAL FROM EMPLOYEES WHERE DEPARTMENT_ID=60; 
    LOOP
    FETCH REF_CUR INTO V_NAME, V_SAL;
    EXIT WHEN REF_CUR%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(V_NAME||' has a salary of - '||V_SAL||' being in the department 60 of Table - Employees');
    END LOOP;
END;
END;
/

 OPEN C  FOR
 SELECT * FROM DEPT;
 
 ------------------WEAK REF CURSOR IN PROCDEURE-------Procedure should only OPEN the cursor.
 
 CREATE OR REPLACE PROCEDURE PROC_EMP_RCUR  (D_NO IN NUMBER, REF_CUR OUT SYS_REFCURSOR)
 AS
V_NAME VARCHAR2(50);        
V_SAL NUMBER;      
BEGIN
OPEN REF_CUR FOR
SELECT ENAME, SAL FROM EMP WHERE DEPTNO = D_NO;
LOOP
FETCH REF_CUR INTO V_NAME, V_SAL;
EXIT WHEN REF_CUR%NOTFOUND;
DBMS_OUTPUT.PUT_LINE(V_NAME||' '||V_SAL);
END LOOP;
END;
/


VARIABLE REF_CUR REFCURSOR
EXEC PROC_EMP_RCUR(50, :REF_CUR);


DECLARE
    v_cursor SYS_REFCURSOR;
BEGIN
    PROC_EMP_RCUR(10,v_cursor);
END;
/



CREATE OR REPLACE PROCEDURE get_joined_data_safe
--(p_cursor OUT SYS_REFCURSOR)
IS
 p_cursor SYS_REFCURSOR;
BEGIN
    OPEN p_cursor FOR
        SELECT 
            e.EMPLOYEE_ID,
            e.FIRST_NAME,
            e.salary,
            e.DEPARTMENT_ID AS emp_dept_id,  -- Alias to avoid conflict
            e.hire_date,
            d.DEPARTMENT_ID AS dept_dept_id,  -- Alias to avoid conflict
            d.DEPARTMENT_NAME,
            d.LOCATION_ID
        FROM employees e
        JOIN departments d ON e.DEPARTMENT_ID = d.DEPARTMENT_ID
        ORDER BY e.EMPLOYEE_ID;
         DBMS_SQL.return_result(p_cursor);                                  --------USING THIS RETURN REF CUSOR TO0L USED INSTEAD OF RETURN SYS_REFCURSOR
END get_joined_data_safe;
/

BEGIN
    get_joined_data_safe;
END;
/



 CREATE OR REPLACE PROCEDURE PROC_EMP_RCUR_TOOL  (D_NO IN NUMBER)
 AS
REF_CUR  SYS_REFCURSOR;
BEGIN
OPEN REF_CUR FOR
SELECT ENAME, SAL FROM EMP WHERE DEPTNO = D_NO;
DBMS_SQL.RETURN_RESULT(REF_CUR);
END;
/

DECLARE
V_CUR SYS_REFCURSOR;
BEGIN
PROC_EMP_RCUR_TOOL(10);
END;
/



CREATE OR REPLACE PROCEDURE get_joined_data_safe (
    p_cursor OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN p_cursor FOR
        SELECT 
            e.EMPLOYEE_ID,
            e.FIRST_NAME,
            e.salary,
            e.DEPARTMENT_ID AS emp_dept_id,  -- Alias to avoid conflict
            e.hire_date,
            d.DEPARTMENT_ID AS dept_dept_id,  -- Alias to avoid conflict
            d.DEPARTMENT_NAME,
            d.LOCATION_ID
        FROM employees e
        JOIN departments d ON e.DEPARTMENT_ID = d.DEPARTMENT_ID
        ORDER BY e.EMPLOYEE_ID;
         DBMS_SQL.return_result(p_cursor);
END get_joined_data_safe;
/

-- Paste this into SQL Developer and hit F5 (Run Script)
DECLARE
    v_my_cursor SYS_REFCURSOR;
BEGIN
    get_joined_data_safe(v_my_cursor);
END;
/




CREATE OR REPLACE PROCEDURE PROC_RCUR (
DEP_ID IN NUMBER,
R_CUR IN OUT SYS_REFCURSOR)
IS
BEGIN
OPEN R_CUR
FOR
SELECT E.ENAME, E.EMPNO, D.DEPARTMENT_NAME 
FROM  EMP E, DEPARTMENTS D
WHERE E.DEPTNO = D.DEPARTMENT_ID
AND E.DEPTNO = DEP_ID;
DBMS_SQL.RETURN_RESULT(R_CUR);
END;
/

DECLARE
REF_CUR SYS_REFCURSOR;
BEGIN
PROC_RCUR(10,REF_CUR);
END;
/



SELECT * FROM DEPARTMENTS;


CREATE OR REPLACE FUNCTION FUNC_EMP(E_ID IN NUMBER)
RETURN SYS_REFCURSOR
AS
REF_CUR SYS_REFCURSOR;
BEGIN
OPEN REF_CUR FOR
SELECT ENAME, SAL, DEPTNO  FROM EMP WHERE EMPNO = E_ID;
RETURN REF_CUR;
END;
/
--

DECLARE
V_REF_CUR SYS_REFCURSOR;
V_ENAME VARCHAR2(40);
V_SAL NUMBER;
V_DEP NUMBER;
BEGIN
--CALL
V_REF_CUR:=FUNC_EMP(101);
        LOOP
        --FETCH
        FETCH V_REF_CUR INTO V_ENAME, V_SAL, V_DEP;
        EXIT WHEN V_REF_CUR%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(V_ENAME||' is having a salary of - '||V_SAL||' while working in Department No - '||V_DEP);
        END LOOP;
END;
/

VAR V_REF_CUR REFCURSOR
EXEC :V_REF_CUR := FUNC_EMP(102)
PRINT V_REF_CUR
							-