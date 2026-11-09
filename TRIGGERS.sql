✈️🐅🐫👍🗼🥇💡🧠🎓🇸🇦✈️🐅🐫👍🗼🥇   💻🎁🎒💣📩🔆🎤🧰️🎭

------------TRIGGER------
A TRIGGER IS A DATABASE OBJECT THAT AUTOMATICALLY EXECUTES IN RESPONSE TO DML, DDL, OR DATABASE EVENTS.

32. How Many Triggers can be Applied to a Table?
A maximum of 12 triggers can be added to a table.

33. What is a Mutating Table Error? (Error occurs in case of Row Level Transaction)
A Mutating table error occurs when a trigger tries to update a row that is currently in use. 
It can be fixed by using views or temporary tables so that the database selects one and updates the other.

A Mutating trigger error (ORA-04091) occurs in Oracle when a row-level trigger tries to query or modify the same table that is currently undergoing an INSERT, UPDATE, or DELETE operation. 
Oracle raises this error to prevent data inconsistency because the tables state is unknown during the in-progress DML statement. 
Example of a Mutating Trigger Error..

This error typically happens when implementing complex business rules that require the trigger to look at other rows in the same table. 
Scenario: Enforce a rule that a managers salary must always be greater than or equal to the salaries of the employees they manage. 
This requires the employees row-level trigger to check the managers salary (another row) in the same EMPLOYEES table. 


CREATE OR REPLACE TRIGGER comp_tr_log_changes
  FOR UPDATE ON EMP_T 
  COMPOUND TRIGGER
 lv_ceo_sal number;



CREATE OR REPLACE TRIGGER log_emp_change
AFTER UPDATE ON employees
FOR EACH ROW
DECLARE
    PRAGMA AUTONOMOUS_TRANSACTION; -- Creates a separate transaction
    v_count NUMBER;
BEGIN


CREATE OR REPLACE TRIGGER instead_of_update_trigger
INSTEAD OF UPDATE ON view_name
BEGIN

-----------------------------------------------------AVOIDING MUTUATING TRIGER ERROR-----------------------------------

CREATE OR REPLACE PACKAGE EMP_PKG
IS
TYPE EMP_TAB IS TABLE OF EMP.EMPNO%TYPE;
G_EMP EMP_TAB;
END EMP_PKG;
/
CREATE OR REPLACE TRIGGER TRG_ROW_EMP
AFTER INSERT OR UPDATE ON EMP
FOR EACH ROW
BEGIN
EMP_PKG.G_EMP(EMP_PKG.G_EMP.COUNT + 1) := :NEW.EMPNO;
end;
/  


CREATE OR REPLACE TRIGGER trg_stmt_emp
AFTER INSERT OR UPDATE ON emp
BEGIN
  -- safe processing here
  DBMS_OUTPUT.PUT_LINE('Processed rows: ' || EMP_PKG.g_emp.COUNT);
END;
/


🥇 6. Compound Triggers
----------------------------------------------------------------------------------------
Use a Compound Trigger: For Oracle 11g and later, the COMPOUND TRIGGER is recommended. It allows collecting data during row-level events and processing it during statement-level events, when the table is not Mutating...

To increase flexibility and effectiveness, this trigger combines row-level and statement-level triggers. It enables you to specify actions at various levels and phases of the triggering event. 
Avoiding Mutating Table Errors: The ability to share state allows you to collect data in the AFTER EACH ROW section and process it in the AFTER STATEMENT section, which is a common way to avoid the ORA-04091 Mutating table error. 

The Strategy:

Row Level: Instead of querying the table, just collect the IDs (:NEW.ID or :OLD.ID) into a collection (array) defined in the declaration section.
Statement Level: After all rows have been processed, loop through the collection and perform the necessary queries or updates on the table.
Example:

CREATE OR REPLACE TRIGGER manage_emp_salary
    FOR UPDATE OF salary ON employees
    COMPOUND TRIGGER

    -- 1. Declare a collection to store IDs
    TYPE t_id_tab IS TABLE OF employees.employee_id%TYPE INDEX BY PLS_INTEGER;
    v_emp_ids t_id_tab;

--BEFORE STATEMENT
    -- 2. Row Section: Collect data
    BEFORE EACH ROW IS
    BEGIN
        IF :NEW.salary <> :OLD.salary THEN
            -- Add the ID to the collection
            v_emp_ids(v_emp_ids.COUNT + 1) := :NEW.employee_id;
        END IF;
    END BEFORE EACH ROW;

--AFTER EACH ROW
    -- 3. Statement Section: Perform updates safely
    AFTER STATEMENT IS
    BEGIN
        -- CORRECTED LOOP: Iterate through the v_emp_ids collection
        -- We use 1..COUNT because we filled it sequentially
        FORALL i IN 1..v_emp_ids.COUNT 
            
            -- CORRECTED UPDATE: Update rows matching the IDs in the collection
            -- NOTE: Updating COMMISSION_PCT to avoid an infinite loop.
            -- If you update SALARY here, the trigger fires again recursively.
            UPDATE employees 
            SET commission_pct = NVL(commission_pct, 0) + 0.01 
            WHERE employee_id = v_emp_ids(i);
            
    END AFTER STATEMENT;

END manage_emp_salary;
/



-----------------------------COMPOUND TRIGGER EXAMPLE------------------
----------

CREATE OR REPLACE TRIGGER TRIG_EMP_TEST1
FOR INSERT OR UPDATE ON EMP_TEST1
COMPOUND TRIGGER
 TYPE COLL_TBL IS TABLE OF EMP_TEST1.EMPNO%TYPE INDEX BY BINARY_INTEGER;
 COLL_EMP COLL_TBL;
 
    BEFORE EACH ROW IS
        BEGIN
      --  IF :NEW.SAL < 7000 AND :NEW.DEPTNO = 50 THEN
        IF :NEW.COMM IS NULL AND :NEW.DEPTNO = 50 THEN
        COLL_EMP(COLL_EMP.COUNT + 1) := :NEW.EMPNO;
        END IF;
    END BEFORE EACH ROW; 
   
   AFTER STATEMENT IS
            BEGIN
            FORALL I IN 1..COLL_EMP.COUNT
            UPDATE EMP_TEST1 SET SAL=SAL+1000, COMM = 0.50, STATUS='INACTIVE'  					----SAL=SAL+1000,
            WHERE EMPNO = COLL_EMP(I);                                                                                  --COMM = 0.50, STATUS='INACTIVE'
    END AFTER STATEMENT;
END;
/ 

SELECT * FROM EMP_TEST1; 
UPDATE EMP_TEST1 SET COMM = 0.50 WHERE EMPNO = 126;
UPDATE EMP_TEST1 SET DEPTNO = 50 WHERE EMPNO=104;          ------< DEPTNO = 60 
UPDATE EMP_TEST1 SET JOB_ID='ST_MAN' WHERE EMPNO=122;          ------> DEPTNO = 50 , SAL - 6500, JOB_ID = ST_MAN
UPDATE EMP_TEST1 SET JOB_ID='ST_CLERK' WHERE EMPNO=124;          ------> DEPTNO = 50 , SAL - 6000, JOB_ID = IT_PROG
UPDATE EMP_TEST1 SET JOB_ID='ST_MAN' WHERE EMPNO=125;  
UPDATE EMP_TEST1 SET JOB_ID='ST_MAN' WHERE EMPNO=104;  

CREATE OR REPLACE TRIGGER TRIG_COMP_T
FOR INSERT OR UPDATE ON T
COMPOUND TRIGGER

TYPE T_SAL IS TABLE OF T.ID%TYPE INDEX BY PLS_INTEGER;
X_ID T_SAL;                                                                                        
    --BEFORE STATMENT LEVEL    
        BEFORE EACH ROW IS
            BEGIN
            IF :NEW.SAL < 300 THEN
            X_ID(X_ID.COUNT + 1) := :NEW.ID;             -----> INITIALIZATION FOR ASSOCIATIVE TYPE ARRAYS AT LINE - 4
            END IF;
        END BEFORE EACH ROW;
        
        AFTER STATEMENT IS
            BEGIN
            FORALL I IN 1..X_ID.COUNT 
            UPDATE T SET SAL = SAL+100 WHERE ID = X_ID(I);
        END AFTER STATEMENT;
END;
/
 
CREATE OR REPLACE TRIGGER comp_trig_t
FOR INSERT OR UPDATE ON T
COMPOUND TRIGGER

    TYPE id_tab IS TABLE OF T.ID%TYPE;
    v_ids id_tab := id_tab();

    BEFORE EACH ROW IS
    BEGIN
        IF :NEW.SAL < 200 THEN
            v_ids.EXTEND;                               -------> HERE NEED TO USE 'EXTEND' & THEN 'LAST' METHODS OF COLLECTION FO RSORING OF DATA IN CASE OF 
            v_ids(v_ids.LAST) := :NEW.ID;                   ----------> NESTED OR VARRAYS.
        END IF;
    END BEFORE EACH ROW;

    AFTER STATEMENT IS
    BEGIN
        FOR i IN 1 .. v_ids.COUNT LOOP
            UPDATE T SET SAL = SAL + 200
            WHERE ID = v_ids(i);
        END LOOP;
    END AFTER STATEMENT;

END;
/


SELECT * FROM T;
UPDATE T SET SAL=SAL+400 WHERE ID IN (1,2);
INSERT INTO T VALUES (7,190,10);


🔹 HOW does it work internally?

Your trigger has two parts:

1️⃣ BEFORE EACH ROW

This runs for every row affected.
It checks:
IF :NEW.SAL < 200 THEN

Meaning:

👉 If the salary being inserted/updated is less than 200
👉 Then store that ID in collection v_ids

So this part only collects IDs.

It does NOT update yet.

2️⃣ AFTER STATEMENT

This runs once after the entire INSERT/UPDATE finishes.
Then it loops through collected IDs:
FOR i IN 1 .. v_ids.COUNT LOOP

And updates those rows:
UPDATE T
SET SAL = SAL + 200
WHERE ID = v_ids(i);

🟢 Example 1 – INSERT Case
Table before:

ID	SAL
1	500

Now:
INSERT INTO T VALUES (2, 150);

Step-by-step:
BEFORE EACH ROW

SAL = 150
150 < 200 → store ID = 2 in collection

AFTER STATEMENT

Loop through collection

Update ID 2
SAL becomes 350
Final:

ID	SAL
1	500
2	350
🟢 Example 2 – UPDATE Case

Table:

ID	SAL
1	500
2	350

Now:

UPDATE T
SET SAL = 100
WHERE ID = 1;

BEFORE EACH ROW

SAL = 100

100 < 200 → store ID 1

AFTER STATEMENT

Update ID 1

SAL becomes 300

🟢 Example 3 – Multi-Row Update
UPDATE T
SET SAL = 100;

Assume 3 rows exist.

BEFORE EACH ROW runs 3 times
IDs collected: 1,2,3

AFTER STATEMENT runs once

Loop updates all 3 rows.

All become 300.

🔥 Important Behavior

Your trigger works only for:

👉 Rows being inserted or updated
👉 Where new salary < 200

It does NOT:

Check old rows

Update existing rows unless part of the same DML statement

⚠️ Important Edge Case

If someone inserts:

INSERT INTO T VALUES (5, 500);


Nothing happens.

Because:

500 < 200 → FALSE


So ID not stored → AFTER STATEMENT does nothing.

🎯 Simple One-Line Explanation

This trigger works whenever rows are inserted or updated in table T, and it increases salary by 200 only for rows whose new salary is less than 200.

🧠 Interview-Level Explanation

If interviewer asks:

“When will this trigger fire?”

Answer:

It fires on every INSERT or UPDATE on table T. The BEFORE EACH ROW section collects IDs where the new salary is below 200, and the AFTER STATEMENT section updates those rows by increasing salary by 200.

That’s a strong answer.





----------------END COMPOUND TRIGGER EXAMPLE---------------------

Solution 2: The Three-Trigger Approach (Works on older versions)
-------------------------------------------------------------------------------------------

If you are on a version older than 11g, you cannot use Compound Triggers. Instead, you simulate the same behavior using a Package to hold the data and three separate triggers.

The Strategy:

Package: Create a package with a PL/SQL collection (array) to hold the row IDs.
Before Statement Trigger: Initialize (empty) the collection.
After Row Trigger: Add the :NEW.ID to the package collection.
After Statement Trigger: Loop through the collection in the package and perform the logic on the table.
Note: This is functionally the same as the Compound Trigger but requires more objects to manage.

Solution 3: Pragma Autonomous Transaction (Use with Extreme Caution)
------------------------------------------------------------------------------------------------
This tells Oracle to run the trigger code in a completely separate, independent transaction. 
The separate transaction can query the table because it doesnt see the uncommitted changes of the main transaction.

Warning: This is dangerous for business logic. The autonomous transaction might see data that the main transaction hasnt committed yet (or might roll back later), leading to data integrity issues. 
Only use this for logging/auditing purposes.

Example:

sql

---EX1--It works coz of presence of AUTONOMOUS_TRANSACTION, If the same Trigger cud have been taken w/o AUTONOMOUS_TRANSACTION, it couldn't have worked
CREATE OR REPLACE TRIGGER log_emp_change
AFTER UPDATE ON employees
FOR EACH ROW
DECLARE
    PRAGMA AUTONOMOUS_TRANSACTION; -- Creates a separate transaction
    v_count NUMBER;
BEGIN
    -- This query is allowed because its in a separate transaction
    SELECT COUNT(*) INTO v_count FROM employees WHERE salary > 10000;
END;
/
UPDATE EMPLOYEES SET SALARY = SALARY + 100 WHERE EMPLOYEE_ID=101;
/


---EX2---

CREATE OR REPLACE TRIGGER log_emp_change
AFTER UPDATE ON employees
FOR EACH ROW
DECLARE
    PRAGMA AUTONOMOUS_TRANSACTION; -- Creates a separate transaction
    v_count NUMBER;
BEGIN
    -- This query is allowed because its in a separate transaction
    SELECT COUNT(*) INTO v_count FROM employees WHERE salary > 10000;
    
    INSERT INTO audit_log (msg) VALUES (High earners count:  || v_count);
    
    COMMIT; -- You MUST commit in an autonomous transaction
END;
/


Solution 4: Refactor Logic (The Correct Fix)
------------------------------------------------------------
Often, mutating triggers happen because developers try to enforce complex rules using triggers that should be handled by the application logic or simple constraints.

Common Refactors:

Avoid the Query: Do you really need to SELECT COUNT(*) from the table inside the trigger?
Example: If you are ensuring the Total Salary doesnt exceed a budget, you shouldnt query the sum of the table.
Instead, store the Current_Budget in a separate table and adjust it incrementally (:NEW.salary - :OLD.salary).
Use Foreign Keys: If the trigger is checking child tables, a declarative Foreign Key constraint is faster and prevents the error.
Use Views: Instead of updating the base table, update a View that uses an INSTEAD OF trigger. INSTEAD OF triggers do not cause mutating table errors because they fire instead of the DML, giving you full control over how the tables are modified.

Summary Recommendation
=====================
First Choice: Refactor the code so you dont need to query the table (Solution 4).
Second Choice: Use a Compound Trigger (Solution 1).
Last Resort: Use Autonomous Transaction (Solution 3) only for writing logs to an audit table, never for modifying business data.


Alternative Approaches
------------------------
Rethink the Design: The need for complex trigger logic might indicate data modeling issues. Consider implementing logic in a stored procedure or API package.

Use Global Temporary Tables (GTTs): Store affected row data in a Global Temporary Table during row-level events and process it in a statement-level trigger. GTTs are transactional and can be useful in complex scenarios.

 🥇 Instead of Triggers
----------------------------
This trigger is used with views and fires instead of the view’s usual DML actions. It enables you to create custom actions for DML activities. 

Example:

CREATE OR REPLACE TRIGGER instead_of_update_trigger
INSTEAD OF UPDATE ON view_name
BEGIN
  -- Perform custom actions instead of the default update operation
  UPDATE actual_table
  SET column1 = :NEW.column1,
      column2 = :NEW.column2
  WHERE id = :OLD.id;
END;

---------------------------------------------------------------------------------------------

USER_TRIGGERS --> t 
------------TRIGGER------
A TRIGGER IN ORACLE DATABASE IS A SPECIAL PL/SQL PROGRAM UNIT THAT AUTOMATICALLY EXECUTES 
(“FIRES”) IN RESPONSE TO A SPECIFIC EVENT ON A TABLE, VIEW, SCHEMA, OR DATABASE.

TRIGGERS ARE MAINLY USED TO 

--i. ENFORCE BUSINESS RULES,    ---apply any business rule like value being insert >, =, < any value
	
		CREATE OR REPLACE TRIGGER trg_no_drop
		BEFORE DROP ON SCHEMA
		BEGIN
		  RAISE_APPLICATION_ERROR(-20002, Table drop not allowed);
		END;
		/
		
--ii. MAINTAIN AUDIT LOGS 		---thru this audit log can get to know who performed the chnages
📘 Example
		CREATE OR REPLACE TRIGGER trg_after_update_emp
		AFTER UPDATE ON emp
		FOR EACH ROW
		BEGIN
		  INSERT INTO emp_audit
		  VALUES (:OLD.empno, :NEW.empno, SYSDATE, USER);
		END;
		/
		
--iii. DERIVE VALUES 			---gett the new values`
AND 

--iv. RESTRICT INVALID OPERATIONS.  ----restrict any condition

WHY USE PLSQL TRIGGERS?
Triggers in PL/SQL are used for a variety of applications. They are commonly employed for the following reasons:

🥇 Triggers can be used to impose sophisticated integrity requirements or business rules that are incomprehensible using normal SQL constraints. They preserve data integrity by ensuring that data entered or edited in the database fits specified requirements.

-------------------------------------------------------

Making sure WRONG DATA 
never enters your table!

Like a SECURITY GUARD who checks everyone before letting them in!

--i. ENFORCE BUSINESS RULES,    ---apply any business rule like value being insert >, =, < any value
	
		CREATE OR REPLACE TRIGGER trg_no_drop
		BEFORE DROP ON SCHEMA
		BEGIN
		  RAISE_APPLICATION_ERROR(-20002, Table drop not allowed);
		END;
		/
-------------------------------------------------

🥇 Triggers automate database processes by performing specified actions in response to predetermined triggers. They reduce the need for manual intervention while ensuring data uniformity and accuracy. A trigger, for example, can update associated data, produce audit logs, or compute derived values.
-------------------------------------------------------
A Trigger is like a WATCHMAN of your table.

When something happens to the table
Trigger AUTOMATICALLY does a job.

No manual work needed!


--ii. MAINTAIN AUDIT LOGS 		---thru this audit log can get to know who performed the chnages
📘 Example
		CREATE OR REPLACE TRIGGER trg_after_update_emp
		AFTER UPDATE ON emp
		FOR EACH ROW
		BEGIN
		  INSERT INTO emp_audit
		  VALUES (:OLD.empno, :NEW.empno, SYSDATE, USER);
		END;
		/
--------------------------------------------------------


🥇 Triggers can be used to track and log changes to the database’s data. They offer an audit trail by documenting who made the modification, what was modified, and when it was updated. This is useful for regulatory compliance, troubleshooting, and historical analysis.

---------------------------------------------------------
Audit Trail means:

KEEPING A RECORD of every change
that happens in your table

Just like a DIARY of your database!

------------------------------------------------------------

🥇 Database triggers enable the implementation of extensive business logic. They can contain complex computations, validations, or workflow operations that must be implemented consistently for data changes.

----------------------------------------------------------
Business Logic means
RULES of your company!

Every company has rules.
Trigger makes sure
rules are ALWAYS followed!

--EX...
RULE 1: BONUS CALCULATION
─────────────────────────
Employee completes 1 year?
→ Trigger adds bonus automatically

RULE 2: STOCK UPDATE
─────────────────────────
Product sold?
→ Trigger reduces stock count

RULE 3: SALARY CALCULATION
─────────────────────────
New employee added?
→ Trigger calculates
   basic + allowance + tax
   automatically

RULE 4: ORDER WORKFLOW
─────────────────────────
Order placed?
→ Trigger updates
   inventory
   billing
   delivery table
   all at once!
   
   ---- RULE: When order is placed
-- automatically reduce stock

CREATE OR REPLACE TRIGGER trg_update_stock
AFTER INSERT ON orders
FOR EACH ROW
BEGIN
    -- Reduce stock automatically
    UPDATE products
    SET stock = stock - :NEW.quantity
    WHERE product_id = :NEW.product_id;

    -- Calculate and save bill amount
    UPDATE orders
    SET total_amount = :NEW.quantity 
                     * :NEW.unit_price
    WHERE order_id = :NEW.order_id;
END;
/

-- Just insert ONE order:
INSERT INTO orders 
VALUES (1, 101, 5, 200);

-- Trigger automatically:
-- 1. Reduced stock by 5
-- 2. Calculated total = 5 x 200 = 1000
-- No manual work needed!
```

---

## Without Trigger vs With Trigger
```
WITHOUT TRIGGER:
──────────────────────────────
Developer must write
extra code every time
for every application
Rules may be missed!
Inconsistent results!

WITH TRIGGER:
──────────────────────────────
Rules written ONCE in trigger
Applied EVERY TIME automatically
No rule is ever missed!
Always consistent!
```

---

## Summary
```
┌────────────────────────────────────────┐
│  Business Logic = Company Rules        │
│                                        │
│  Trigger runs these rules              │
│  automatically every time!             │
│                                        │
│  Written ONCE                          │
│  Works ALWAYS                          │
│  No manual work                        │
│  No rules missed                       │
│                                        │
│  Like AUTOPILOT for your database!     │
└────────────────────────────────────────┘

--------------------


🥇 It is easier to manage and ensure consistent execution of logic by centralizing it in triggers.
When specific events occur, triggers enable cascading actions. It is possible to use triggers to automatically delete related entries from other tables upon the destruction of a record, ensuring data consistency and referential integrity.

🥇 Triggers can transform data during insertion, updation, or deletion. You can use triggers to check and alter data values before saving them in the database.

---Changing data into
correct format or value
BEFORE saving it!

Like a FILTER
that cleans data
before it enters database!

-- Transform data BEFORE saving
CREATE OR REPLACE TRIGGER trg_transform
BEFORE INSERT OR UPDATE ON employees
FOR EACH ROW
BEGIN
    -- Convert name to UPPER CASE
    :NEW.emp_name := UPPER(:NEW.emp_name);

    -- Remove extra spaces
    :NEW.emp_name := TRIM(:NEW.emp_name);

    -- If salary is negative make it positive
    IF :NEW.salary < 0 THEN
        :NEW.salary := ABS(:NEW.salary);
    END IF;

    -- Format phone number
    :NEW.phone := SUBSTR(:NEW.phone,1,3)
                  ||'-'||
                  SUBSTR(:NEW.phone,4,3)
                  ||'-'||
                  SUBSTR(:NEW.phone,7,4);
END;
/

-- User inserts messy data:
INSERT INTO employees 
VALUES(101, '  john smith  ', -5000, '9876543210');

-- Trigger automatically fixes and saves:
-- NAME  →  JOHN SMITH
-- SAL   →  5000
-- PHONE →  987-654-3210
```

---

## Before vs After Transformation
```
┌─────────────┬──────────────┬──────────────┐
│   COLUMN    │  USER TYPED  │  SAVED AS    │
├─────────────┼──────────────┼──────────────┤
│ NAME        │ john smith   │ JOHN SMITH   │
│ SALARY      │ -5000        │ 5000         │
│ PHONE       │ 9876543210   │ 987-654-3210 │
│ EMAIL       │ JOHN@ABC.COM │ john@abc.com │
└─────────────┴──────────────┴──────────────┘
```

---

## Summary
```
┌─────────────────────────────────────────┐
│  Trigger checks data BEFORE saving      │
│                                         │
│  Wrong format?  → Trigger fixes it      │
│  Negative value?→ Trigger corrects it   │
│  Extra spaces?  → Trigger removes them  │
│                                         │
│  User enters raw data                   │
│  Trigger cleans it                      │
│  Database saves correct data            │
│                                         │
│  Like AUTOCORRECT for your database!    │
└─────────────────────────────────────────┘


--------------------------------------------------

🥇 WHY ARE TRIGGERS REQUIRED IN PL SQL?
Triggers are required in PL/SQL as they allow developers to create automated actions that are executed when a specific event occurs, such as when a table is modified or a record is inserted or deleted. This helps enforce data integrity and can be used to automate complex tasks.

2. WHAT IS A ROW-LEVEL TRIGGER IN PL SQL?
A row-level trigger is a type of database trigger in PL/SQL fired for each row affected 
by the triggering event, such as an INSERT, UPDATE, or DELETE.

3. HOW MANY TYPES OF TRIGGERS EXIST IN PL SQL?
There are two types of triggers in PL/SQL.
a. Row-level triggers 
b. Statement-level trigger

4. WHICH TYPE OF TRIGGER USES THE OLD AND NEW QUALIFIERS?
The row-level triggers use the old and new qualifiers.

5. WHAT ARE THE 3 PARTS OF A TRIGGER?
The following are the three parts of a trigger: 
a) A triggering event or statement
b) A trigger restriction
c) A trigger action

6. WHAT ARE THE BENEFITS OF TRIGGERS?
Some of the benefits of triggers include the following: 
a) Enforces referential integrity.
b) Allows synchronized replication of tables.
c) Generates derived column values automatically.
d) Prevents invalid transactions





1️⃣  DML TRIGGERS (MOST COMMON)
🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆

Triggered by INSERT, UPDATE, DELETE operations.

	🔹 1.1 BEFORE DML TRIGGER
	--------------------------
📌 When it fires
Before the DML operation is executed.

✅ Use cases
Validate data
Modify :NEW values
Prevent invalid inserts/updates/delete

		📘 Example
		CREATE OR REPLACE TRIGGER trg_before_insert_emp
		BEFORE INSERT ON emp
		FOR EACH ROW
		BEGIN
		  IF :NEW.sal < 0 THEN
			RAISE_APPLICATION_ERROR(-20001, Salary cannot be negative);
		  END IF;
		END;
		/
		
		CREATE OR REPLACE TRIGGER trg_before_insert_emp
		BEFORE INSERT OR UPDATE OR DELETE ON empp
		FOR EACH ROW
		BEGIN
		 -- IF :NEW.sal < 1000 THEN
         IF :OLD.EMPNO = 101 THEN
			RAISE_APPLICATION_ERROR(-20001, Cannot delete/update this value);
		  END IF;
		END;
		/   
	🔹 1.2 AFTER DML Trigger
	-------------------------
📌 When it fires
After the DML operation is completed.
✅ Use cases
Auditing
Logging changes
Sending notifications

		📘 Example
		CREATE OR REPLACE TRIGGER trg_after_update_emp
		AFTER UPDATE ON emp
		FOR EACH ROW
		BEGIN
		  INSERT INTO emp_audit
		  VALUES (:OLD.empno, :NEW.empno, SYSDATE, USER);
		END;
		/
✔ Fires after update
✔ Cannot change :NEW values


	🔹 1.3 INSTEAD OF Trigger
THIS TRIGGER IS USED WITH VIEWS AND FIRES INSTEAD OF THE VIEW’S USUAL DML ACTIONS. IT ENABLES YOU TO CREATE CUSTOM ACTIONS FOR DML ACTIVITIES. 

AN INSTEAD OF TRIGGER IN PL SQL IS A TRIGGER USED INSTEAD OF AN UPDATE, DELETE, OR INSERT STATEMENT. 
THESE TRIGGERS CONTROL INSERT, UPDATE, DELETE, AND MERGE OPERATIONS ON VIEWS RATHER THAN TABLES. 
THEY ARE USED TO MAKE NON-UPDATABLE VIEWS UPDATABLE. 

What is an INSTEAD OF Trigger?
An INSTEAD OF trigger is used specifically on Views.

Normally, a view based on a join of multiple tables is read-only. If you try to INSERT, UPDATE, or DELETE from such a view, Oracle throws an error because it doesnt know which underlying table to modify.

The INSTEAD OF trigger tells Oracle: Dont try to update the view directly. Instead, run this PL/SQL code I wrote to update the base tables manually.


	
📌 Used on
Views (especially complex views)

	CREATE VIEW v_emp_full_details AS
SELECT 
    d.dept_id, 
    d.dept_name, 
    e.emp_id, 
    e.emp_name, 
    s.salary
FROM departments d
JOIN employees e ON d.dept_id = e.dept_id
JOIN salary_history s ON e.emp_id = s.emp_id;

✔ Allows DML on non-updatable views

Example:

	CREATE OR REPLACE TRIGGER trg_io_v_emp_full_details
INSTEAD OF INSERT ON v_emp_full_details
FOR EACH ROW
BEGIN
    -- Step 1: Insert into Departments (Parent)
    BEGIN
        INSERT INTO departments (dept_id, dept_name)
        VALUES (:NEW.dept_id, :NEW.dept_name);
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN NULL; -- Handle if Dept already exists
    END;

    -- Step 2: Insert into Employees (Child)
    BEGIN
        INSERT INTO employees (emp_id, emp_name, dept_id)
        VALUES (:NEW.emp_id, :NEW.emp_name, :NEW.dept_id);
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN NULL; -- Handle if Emp already exists
    END;

    -- Step 3: Insert into Salary History (Child/Grandchild)
    INSERT INTO salary_history (history_id, emp_id, salary)
    VALUES (SEQ_HISTORY.NEXTVAL, :NEW.emp_id, :NEW.salary);
    
    DBMS_OUTPUT.PUT_LINE('Inserted data across 3 tables successfully.');
END;
/


INSERT INTO v_emp_full_details (dept_id, dept_name, emp_id, emp_name, salary)
VALUES (10, 'IT', 101, 'John Doe', 5000);
		
📌 Key Rules to Remember
Rule				        Explanation
Works only on				Views
Row-level only				FOR EACH ROW is mandatory
BEFORE/AFTER not allowed	Only INSTEAD OF
Uses						:NEW and :OLD
Enables DML on				Non-updatable views		
		
----------------------------------------------------------------------------------

2️⃣  TRIGGER LEVELS
🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆

	🔹 2.1 Row-Level Trigger

	Fires once for each row
	Uses :NEW and :OLD FOR EACH ROW

		Example
		BEFORE UPDATE ON emp
		FOR EACH ROW

	🔹 2.2 Statement-Level Trigger

	Fires once per statement
	No :NEW or :OLD

		CREATE OR REPLACE TRIGGER trg_stmt
		AFTER DELETE ON emp
		BEGIN
		  DBMS_OUTPUT.PUT_LINE(Delete executed);
		END;
	/


----------------------------------------------------------------------

4 ️⃣ DDL Triggers

Triggered by CREATE, ALTER, DROP, TRUNCATE

		📘 Example – Prevent table drop
		CREATE OR REPLACE TRIGGER trg_no_drop
		BEFORE DROP ON SCHEMA
		BEGIN
		  RAISE_APPLICATION_ERROR(-20002, Table drop not allowed);
		END;
		/
✔ Fires for any DROP in schema

--------------------------------------------------------------------------

5 ️⃣ Database Event Triggers

Triggered by LOGON, LOGOFF, STARTUP, SHUTDOWN

		📘 Example – Log user login
		CREATE OR REPLACE TRIGGER trg_logon
		AFTER LOGON ON DATABASE
		BEGIN
		  INSERT INTO login_log VALUES (USER, SYSDATE);
		END;
		/


--------------------------------------------------------------------------

https://www.youtube.com/watch?v=8URfUvi3O8w

7 ️⃣  Mutating TRIGGER IN ORACLE — Complete Explanation

A Mutating Trigger error is one of the most important and commonly asked topics in Oracle PL/SQL interviews.

📌 What is a Mutating Trigger?
In Oracle Database, a Mutating table is a table that is currently being modified by a DML statement and cannot be read from or modified again inside a row-level trigger on that same table.

❗ Typical Error
ORA-04091: table is Mutating, trigger/function may not see it

🧠 Why Does Mutating Trigger Occur?
Oracle prevents this to avoid inconsistent data and infinite loops.

🔥 Root Cause
A ROW-LEVEL trigger
Trigger tries to SELECT / INSERT / UPDATE / DELETE On the same table that fired the trigger

❌ Example That Causes Mutating Trigger
Table
CREATE TABLE emp (
  empno NUMBER,
  deptno NUMBER,
  sal NUMBER
);

Trigger (WRONG)
CREATE OR REPLACE TRIGGER trg_Mutating
BEFORE INSERT OR UPDATE ON emp_test
FOR EACH ROW
DECLARE
  v_count NUMBER;
BEGIN
  UPDATE EMP_TEST SET SAL=1000
  WHERE deptno = 101;

  IF v_count > 5 THEN
    RAISE_APPLICATION_ERROR(-20001, Too many employees in department);
  END IF;
END;
/

INSERT INTO emp_test VALUES (1,101,100);

❌ Result
Mutuating Trigger Error
SQL Error: ORA-04091: table HR.EMP_TEST is Mutating, trigger/function may not see it

✔ Because the trigger is reading EMP while EMP is being modified

✅ How to Identify a Mutating Trigger
Condition	Result
Row-level trigger	✅
Accessing same table	✅
DML on same table	❌ Error


✅ SOLUTIONS TO Mutating TRIGGER PROBLEM

🥇 Solution 1: Use a Compound Trigger (Best & Modern)
-----------------------------------------------------
✔ Available from Oracle 11g+

Example
CREATE OR REPLACE TRIGGER trg_compound_emp
FOR INSERT OR UPDATE ON emp
COMPOUND TRIGGER

  TYPE dept_count_tab IS TABLE OF NUMBER INDEX BY NUMBER;
  g_dept_count dept_count_tab;

  BEFORE STATEMENT IS
  BEGIN
    FOR r IN (SELECT deptno, COUNT(*) cnt FROM emp GROUP BY deptno) LOOP
      g_dept_count(r.deptno) := r.cnt;
    END LOOP;
  END BEFORE STATEMENT;

  BEFORE EACH ROW IS
  BEGIN
    IF g_dept_count(:NEW.deptno) >= 5 THEN
      RAISE_APPLICATION_ERROR(-20001, Department limit exceeded);
    END IF;

    g_dept_count(:NEW.deptno) := g_dept_count(:NEW.deptno) + 1;
  END BEFORE EACH ROW;

END;
/
✔ No Mutating error
✔ Clean and efficient

🥈 SOLUTION 2: USE A STATEMENT-LEVEL TRIGGER + PACKAGE VARIABLE
------------------------------------------------------------------
Step 1: Package
CREATE OR REPLACE PACKAGE EMP_PKG
IS
TYPE EMP_TAB IS TABLE OF EMP%ROWTYPE;
G_EMP EMP_TAB;
END EMP_PKG;
/

CREATE OR REPLACE TRIGGER TRG_ROW_EMP
AFTER INSERT OR UPDATE ON EMP
FOR EACH ROW
DECLARE
V_ROW EMP%ROWTYPE;
BEGIN
EMP_PKG.G_EMP(EMP_PKG.G_EMP.COUNT + 1) := V_ROW;
end;
/  

CREATE OR REPLACE TRIGGER trg_stmt_emp
AFTER INSERT OR UPDATE ON emp
BEGIN
  -- safe processing here
  DBMS_OUTPUT.PUT_LINE('Processed rows: ' || EMP_PKG.g_emp.COUNT);
END;
/

✔ Avoids direct table access
✔ Older but effective approach




🥉 SOLUTION 3: USE TEMPORARY TABLE
----------------------------------
Idea

Store values in a Global Temporary Table
Process later outside the trigger

✔ Useful for bulk processing
❌ Extra overhead

🟡 SOLUTION 4: MOVE LOGIC OUTSIDE TRIGGER (BEST PRACTICE)
-----------------------------------------------------------

Instead of trigger:
Use stored procedure
Or handle logic in application layer

✔ Better performance
✔ Easier debugging


❌ What Does NOT Work
Approach	Result
SELECT from same table in row trigger	❌
Using autonomous transaction	❌
Cursor on same table	❌
📊 When Mutating Error Does NOT Occur
Scenario	Allowed
Statement-level trigger	✅
Accessing different table	✅
Using compound trigger	✅
🧪 Interview One-Liner

A Mutating trigger error occurs when a row-level trigger attempts to read or modify the same table that caused the trigger to fire. Oracle prevents this to maintain data consistency.

🧠 Real-Time Use Case

Banking / Insurance

Enforcing limits per account

Auditing changes without corrupt reads

Avoiding recursive updates

If you want next:

Mutating vs Constraining triggers

Real interview questions on Mutating triggers

Step-by-step debugging example

Difference between Mutating and recursive triggers



-----------------------------------SIVA ACAEMEY


drop trigger trig_validate_sal;
drop trigger trig_before_up_sal;
drop trigger comp_tr_log_changes;
drop package pkg1;

drop table emp_t;
drop table emp_sal_log;

create table emp_t(empno number primary key, ename varchar2(100),deptno number, job varchar2(10),sal number);
create table emp_sal_log(empno number, update_log varchar2(1000));


insert into emp_t values(1000, KING,10,CEO,150000);

insert into emp_t values(1001, RAVI,10,DIRECTOR,80000);
insert into emp_t values(1002, SURYA,10,SR MANAGER,70000);
insert into emp_t values(1003, RAGHU,10,MANAGER,60000);
insert into emp_t values(1004, SCOTT,10,LEAD,50000);
insert into emp_t values(1005, SMITH,10,DEVELOPER,40000);
insert into emp_t values(1006, VARUN,10,QA,40000);

commit;

----------------
-- Trigger to check if the sal greater than 100000, if yes, log the error message, else update sucessfully


create or replace trigger trig_validate_sal
before update of sal on emp_t
for each row
declare
lv_max_sal number := 100000;
begin

if :new.sal < lv_max_sal then
 insert into emp_sal_log values(:new.empno,
    Salary Updates successfully : 
    || OLD SAL = ||:old.sal||, NEW SAL = ||:new.sal);
else
 :new.sal := :old.sal;
 insert into emp_sal_log values(:new.empno,
    Salary NOT UPDATED : Employee salary cannot be more than 
    ||lv_max_sal);
end if;
end;
/

update emp_t set sal = 45000 where empno = 1005;

select * from emp_sal_log;


update emp_t set sal = 150000 where empno = 1006;

select * from emp_sal_log;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Trigger to check if the sal greater than sal of CEO, if yes, log the error message, else update successfully., but for CEO update should go through.

create or replace trigger trig_validate_sal
before update of sal on emp_t
for each row
declare
lv_ceo_sal number;
begin

select sal into lv_ceo_sal
from emp_t
where job = CEO
and deptno= :new.deptno;

if (:new.sal < lv_ceo_sal and :old.job <> CEO) or (:old.job = CEO) then
 insert into emp_sal_log values(:new.empno,
        Salary Updates successfully : 
     || OLD SAL = ||:old.sal||, NEW SAL = ||:new.sal);
else
 :new.sal := :old.sal;
 insert into emp_sal_log values(:new.empno,
      Salary NOT UPDATED : Employee salary cannot be more than 
   ||lv_ceo_sal);
end if;

end;
/


update emp_t set sal = 45000 where empno = 1005;

select * from emp_sal_log;


update emp_t set sal = 150000 where empno = 1006;

select * from emp_sal_log;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Lets see how to avoid Mutating error using packaged global variable


drop trigger trig_validate_sal;

create or replace package pkg1 as
lv_ceo_sal number;
end;
/

create or replace trigger trig_before_up_sal
before update of sal on emp_t
declare
lv_max_sal number;
begin

select sal into pkg1.lv_ceo_sal
from emp_t
where job = CEO;

end;
/

 create or replace trigger trig_validate_sal
 before update of sal on emp_t
 for each row
 declare
 begin

 if (:new.sal < pkg1.lv_ceo_sal and :old.job <> CEO)
    or (:old.job = CEO) then
  insert into emp_sal_log values(:new.empno,
     Salary Updates successfully : 
     || OLD SAL = ||:old.sal||, NEW SAL = ||:new.sal);
 else
  :new.sal := :old.sal;
  insert into emp_sal_log values(:new.empno,
     Salary NOT UPDATED : Employee salary cannot be more than 
     ||pkg1.lv_ceo_sal);  
 end if;
 end;
 /

update emp_t set sal = 45000 where empno = 1005;

select * from emp_sal_log;


update emp_t set sal = 150000 where empno = 1006;

select * from emp_sal_log;

update emp_t set sal = 160000 where empno = 1000;

select * from emp_sal_log;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Lets see how to avoid Mutating error using compound trigger

drop trigger trig_validate_sal;
drop trigger trig_before_up_sal;
drop package pkg1;

CREATE OR REPLACE TRIGGER comp_tr_log_changes
  FOR UPDATE ON EMP_T 
  COMPOUND TRIGGER
 lv_ceo_sal number;
  BEFORE STATEMENT IS
  BEGIN
 select sal
 into lv_ceo_sal
 from emp_t
 where job = CEO;
  END BEFORE STATEMENT;
 

  BEFORE EACH ROW IS
  BEGIN
  if (:new.sal < lv_ceo_sal and :old.job <> CEO) or (:old.job = CEO)  then
   insert into emp_sal_log values(:new.empno,
   Salary Updates successfully : || OLD SAL = ||:old.sal||, NEW SAL = ||:new.sal);
  else
   :new.sal := :old.sal;
   insert into emp_sal_log values(:new.empno,
   Salary NOT UPDATED : Employee salary cannot be more than ||lv_ceo_sal);           
  end if;
  END BEFORE EACH ROW;

END comp_tr_log_changes;
/


select * from emp_t;

update emp_t set sal = 45000 where empno = 1005;

select * from emp_sal_log;


update emp_t set sal = 150000 where empno = 1006;

select * from emp_sal_log;

update emp_t set sal = 160000 where empno = 1000;

select * from emp_sal_log;



---------------------------------------------------------------------

Some Restriction/Catches to note
The body of a compound trigger must be a compound trigger block.
A compound trigger must be a DML trigger.
A compound trigger must be defined on either a table or a view.
The declarative part cannot include PRAGMA AUTONOMOUS_TRANSACTION.
A compound trigger body cannot have an initialization block; therefore, it cannot have an exception section. 
This is not a problem, because the BEFORE STATEMENT section always executes exactly once before any other timing-point section executes.

An exception that occurs in one section must be handled in that section. It cannot transfer control to another section.

If a section includes a GOTO statement, the target of the GOTO statement must be in the same section.
OLD, :NEW, and :PARENT cannot appear in the declarative part, the BEFORE STATEMENT section, or the AFTER STATEMENT section.
Only the BEFORE EACH ROW section can change the value of :NEW.
If, after the compound trigger fires, the triggering statement rolls back due to a DML exception:
Local variables declared in the compound trigger sections are re-initialised, and any values computed thus far are lost.
Side effects from firing the compound trigger are not rolled back.

The firing order of compound triggers is not guaranteed. Their firing can be interleaved with the firing of simple triggers.

If compound triggers are ordered using the FOLLOWS option, and if the target of FOLLOWS does not contain the corresponding section as source code, the ordering is ignored.


Great question 👍
Let me explain HOW we can perform UPDATE on the SAME table using a COMPOUND TRIGGER, step-by-step, with a very simple and practical example.

🔴 Problem First (Why normal trigger fails)

If you try to UPDATE the same table inside a row-level trigger, Oracle throws:

ORA-04091: table is Mutating

That’s because Oracle doesn’t allow reading/updating a table while it’s being modified row by row.

👉 Solution: Use a COMPOUND TRIGGER.

✅ Why COMPOUND TRIGGER Works

A compound trigger has multiple sections that share data:

BEFORE STATEMENT

BEFORE EACH ROW

AFTER EACH ROW

AFTER STATEMENT ✅ (SAFE place to update same table)

👉 We collect data row-by-row,
👉 then update the table once at the statement level.

🧱 Sample Table
CREATE TABLE emp (
    emp_id     NUMBER,
    salary     NUMBER,
    bonus      NUMBER
);

🎯 Requirement

When salary is updated, automatically calculate
bonus = 10% of salary

❌ Wrong Way (Normal Trigger – causes Mutating error)
-- ❌ DO NOT DO THIS
CREATE OR REPLACE TRIGGER trg_emp
AFTER UPDATE OF salary ON emp
FOR EACH ROW
BEGIN
   UPDATE emp
   SET bonus = :NEW.salary * 0.10
   WHERE emp_id = :NEW.emp_id;
END;


⛔ This fails with Mutating trigger error.

✅ Correct Way – COMPOUND TRIGGER
Step 1️⃣ Create Compound Trigger
CREATE OR REPLACE TRIGGER trg_emp_bonus
FOR UPDATE OF salary ON emp
COMPOUND TRIGGER

Step 2️⃣ Declare a collection (shared memory)
TYPE emp_id_tab IS TABLE OF emp.emp_id%TYPE;
g_emp_ids emp_id_tab := emp_id_tab();

Step 3️⃣ Collect affected rows (row level – SAFE)
AFTER EACH ROW IS
BEGIN
   g_emp_ids.EXTEND;
   g_emp_ids(g_emp_ids.COUNT) := :NEW.emp_id;
END AFTER EACH ROW;


✔ No UPDATE here
✔ Only collecting keys

Step 4️⃣ Update same table (statement level – SAFE)
AFTER STATEMENT IS
BEGIN
   FOR i IN 1 .. g_emp_ids.COUNT LOOP
      UPDATE emp
      SET bonus = salary * 0.10
      WHERE emp_id = g_emp_ids(i);
   END LOOP;
END AFTER STATEMENT;
END trg_emp_bonus;
/

🧪 Test It
UPDATE emp
SET salary = 50000
WHERE emp_id = 101;


✔ Salary updated
✔ Bonus auto-updated
✔ ❌ No Mutating trigger error

🔑 Key Rules (Very Important)
Section	Can access :NEW/:OLD	Can UPDATE same table
BEFORE EACH ROW	✅ Yes	❌ No
AFTER EACH ROW	✅ Yes	❌ No
AFTER STATEMENT	❌ No	✅ YES
🧠 Easy Way to Remember

👉 Row sections = Collect data
👉 Statement section = Do DML

✅ When to use this pattern

Salary / bonus calculation

Audit updates

Aggregate updates

Parent-child synchronization

Any logic that touches the same table

If you want, I can also show:

🔁 INSERT + UPDATE in compound trigger

📊 Aggregation example

🚫 Comparison with Mutating trigger workaround using package

📘 Interview-ready explanation

Just tell me 👍



-----------------------------------------------------------------------------------------------------------------



Compound trigger behaviour
Rajesh, October 30, 2019 - 7:20 am UTC

Database detail:
Oracle Database 11g Express Edition Release 11.2.0.2.0 - 64bit Production
PL/SQL Release 11.2.0.2.0 - Production
CORE 11.2.0.2.0 Production
TNS for 64-bit Windows: Version 11.2.0.2.0 - Production
NLSRTL Version 11.2.0.2.0 - Production


TABLE SCRIPT:
 create table employees 
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
   );

TRIGGER CODE:
create or replace TRIGGER emp_ct FOR
INSERT ON employees
COMPOUND TRIGGER
TYPE emp_t IS TABLE OF employees%rowtype INDEX BY BINARY_INTEGER;
emps emp_t;
ind SIMPLE_INTEGER := 0;
BEFORE STATEMENT IS BEGIN
NULL;
END BEFORE STATEMENT;
BEFORE EACH ROW IS BEGIN
NULL;
END BEFORE EACH ROW;
AFTER EACH ROW IS BEGIN
ind := ind + 1;
emps(ind).employee_id :=:NEW.employee_id;
emps(ind).first_name :=:NEW.first_name;
DBMS_OUTPUT.PUT_LINE(AFTER EACH ROW emps.COUNT=|| emps.COUNT);
END AFTER EACH ROW;
AFTER STATEMENT IS BEGIN
DBMS_OUTPUT.PUT_LINE(AFTER STATEMENT emps.COUNT=|| emps.COUNT);
END AFTER STATEMENT;
END;

Test CASE-1:
---------------

When I insert data into EMPLOYEES using construct insert into EMPLOYEES () values () as given below why the trigger statement trigger fire for each row. I am not able to achieve bulk insert. For testing purpose, I am not actually inserting data into table just outputting.
REM INSERTING into EMPLOYEES
SET DEFINE OFF;
Insert into EMPLOYEES (EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE_NUMBER,HIRE_DATE,JOB_ID,SALARY,COMMISSION_PCT,MANAGER_ID,DEPARTMENT_ID) values (198,Donald,OConnell,DOCONNEL,650.507.9833,to_date(21-JUN-07,DD-MON-RR),SH_CLERK,2600,null,124,50);
Insert into EMPLOYEES (EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE_NUMBER,HIRE_DATE,JOB_ID,SALARY,COMMISSION_PCT,MANAGER_ID,DEPARTMENT_ID) values (199,Douglas,Grant,DGRANT,650.507.9844,to_date(13-JAN-08,DD-MON-RR),SH_CLERK,2600,null,124,50);
Insert into EMPLOYEES (EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE_NUMBER,HIRE_DATE,JOB_ID,SALARY,COMMISSION_PCT,MANAGER_ID,DEPARTMENT_ID) values (200,Jennifer,Whalen,JWHALEN,515.123.4444,to_date(17-SEP-03,DD-MON-RR),AD_ASST,4400,null,101,10);
Insert into EMPLOYEES (EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE_NUMBER,HIRE_DATE,JOB_ID,SALARY,COMMISSION_PCT,MANAGER_ID,DEPARTMENT_ID) values (201,Michael,Hartstein,MHARTSTE,515.123.5555,to_date(17-FEB-04,DD-MON-RR),MK_MAN,13000,null,100,20);
Insert into EMPLOYEES (EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE_NUMBER,HIRE_DATE,JOB_ID,SALARY,COMMISSION_PCT,MANAGER_ID,DEPARTMENT_ID) values (202,Pat,Fay,PFAY,603.123.6666,to_date(17-AUG-05,DD-MON-RR),MK_REP,6000,null,201,20);
Insert into EMPLOYEES (EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE_NUMBER,HIRE_DATE,JOB_ID,SALARY,COMMISSION_PCT,MANAGER_ID,DEPARTMENT_ID) values (203,Susan,Mavris,SMAVRIS,515.123.7777,to_date(07-JUN-02,DD-MON-RR),HR_REP,6500,null,101,40);
Insert into EMPLOYEES (EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE_NUMBER,HIRE_DATE,JOB_ID,SALARY,COMMISSION_PCT,MANAGER_ID,DEPARTMENT_ID) values (204,Hermann,Baer,HBAER,515.123.8888,to_date(07-JUN-02,DD-MON-RR),PR_REP,10000,null,101,70);
Insert into EMPLOYEES (EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE_NUMBER,HIRE_DATE,JOB_ID,SALARY,COMMISSION_PCT,MANAGER_ID,DEPARTMENT_ID) values (205,Shelley,Higgins,SHIGGINS,515.123.8080,to_date(07-JUN-02,DD-MON-RR),AC_MGR,12008,null,101,110);
Insert into EMPLOYEES (EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE_NUMBER,HIRE_DATE,JOB_ID,SALARY,COMMISSION_PCT,MANAGER_ID,DEPARTMENT_ID) values (206,William,Gietz,WGIETZ,515.123.8181,to_date(07-JUN-02,DD-MON-RR),AC_ACCOUNT,8300,null,205,110);
Insert into EMPLOYEES (EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE_NUMBER,HIRE_DATE,JOB_ID,SALARY,COMMISSION_PCT,MANAGER_ID,DEPARTMENT_ID) values (100,Steven,King,SKING,515.123.4567,to_date(17-JUN-03,DD-MON-RR),AD_PRES,24000,0.4,null,90);

OUTPUT:
AFTER EACH ROW emps.COUNT=1
AFTER STATEMENT emps.COUNT=1
AFTER EACH ROW emps.COUNT=1
AFTER STATEMENT emps.COUNT=1
AFTER EACH ROW emps.COUNT=1
AFTER STATEMENT emps.COUNT=1
AFTER EACH ROW emps.COUNT=1
AFTER STATEMENT emps.COUNT=1
AFTER EACH ROW emps.COUNT=1
AFTER STATEMENT emps.COUNT=1
AFTER EACH ROW emps.COUNT=1
AFTER STATEMENT emps.COUNT=1
AFTER EACH ROW emps.COUNT=1
AFTER STATEMENT emps.COUNT=1
AFTER EACH ROW emps.COUNT=1
AFTER STATEMENT emps.COUNT=1
....
Test CASE-2:
------------

When I perform the insert operation using construct: INSERT INTO ... SELECT
I can see for each insert, rows are accumulated in array and the statement level trigger fires only once.
I am trying to understand this behavior. Could you please explain me.
INSERT INTO employees (
  employee_id, first_name, last_name, email, hire_date, job_id
) 
  SELECT 1000+ROWNUM, Emp||ROWNUM, Emp||ROWNUM, emp||ROWNUM||@abc.com, sysdate, 1
  FROM   dual 
  CONNECT BY LEVEL <= 10;

OUTPUT

AFTER EACH ROW emps.COUNT=1
AFTER EACH ROW emps.COUNT=2
AFTER EACH ROW emps.COUNT=3
AFTER EACH ROW emps.COUNT=4
AFTER EACH ROW emps.COUNT=5
AFTER EACH ROW emps.COUNT=6
AFTER EACH ROW emps.COUNT=7
AFTER EACH ROW emps.COUNT=8
AFTER EACH ROW emps.COUNT=9
AFTER EACH ROW emps.COUNT=10
AFTER STATEMENT emps.COUNT=10

Chris Saxon
November 01, 2019 - 9:06 am UTC
In the first example you have TEN STATEMENTS each inserting one row.

In the second there is ONE STATEMENT inserting ten rows.

The trigger fires once per statement.


https://oracle-base.com/articles/11g/trigger-enhancements-11gr1#compound_triggers




/*
TRIGGER comp_tr_log_changes
FOR INSERT OR UPDATE OF sal ON emp
COMPOUND TRIGGER

    lv_ad_sal NUMBER;

    BEFORE STATEMENT IS
    BEGIN
        SELECT MAX(sal)
        INTO   lv_ad_sal
        FROM   emp
        WHERE  job_id = 'AD_PRESS';
    END BEFORE STATEMENT;

    BEFORE EACH ROW IS
    BEGIN
        -- Allow President always
        IF :old.job_id = 'AD_PRESS'  OR :new.sal <= lv_ad_sal THEN

            INSERT INTO emp_sal_log(NEW_EMPNO, SYNTAX)
            VALUES ( :new.empno, 'Salary Updated. OLD=' || :old.sal || ' NEW=' || :new.sal);

        ELSE
            RAISE_APPLICATION_ERROR(
                -20001,
                'Salary cannot exceed President salary'
            );
        END IF;
    END BEFORE EACH ROW;

END comp_tr_log_changes;

--------------------------------------------------------------------

TRIGGER TRIG_EMP_SAL
FOR INSERT OR UPDATE ON EMP
COMPOUND TRIGGER

TYPE T IS TABLE OF EMP.EMPNO%TYPE INDEX BY PLS_INTEGER;
V_T T;

V_EMPNO EMP.EMPNO%TYPE;

BEFORE EACH ROW IS
BEGIN
    IF :NEW.SAL < 8000 THEN
        V_T(V_T.COUNT + 1) := :NEW.EMPNO;
    END IF;    
 END BEFORE EACH ROW;

 AFTER STATEMENT IS
 BEGIN
    FOR I IN 1..V_T.COUNT LOOP
    UPDATE EMP SET SAL = SAL + 1500 WHERE EMPNO = V_T(I);
    END LOOP;
END AFTER STATEMENT;
END;

--------------------------------------------------------------------

TRIGGER TRIG_EMP
AFTER INSERT OR UPDATE OR DELETE ON EMP
FOR EACH ROW
DECLARE
V_ACTION VARCHAR2(20);
BEGIN
IF INSERTING THEN
V_ACTION := 'INSERT';
ELSIF UPDATING THEN
V_ACTION := 'UPDATE';
ELSIF DELETING THEN
V_ACTION := 'DELETE';
END IF;
INSERT INTO EMP_AUDIT VALUES (:OLD.EMPNO, :NEW.EMPNO, V_ACTION, USER, SYSDATE);
END;


*/

