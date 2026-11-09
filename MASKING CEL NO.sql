ISD code for Switzerland - +41 
 Was been assigned task of hiding last 5-digit of cell no which was of Number type...
 
 
Consider Synonym Strategy (Cleaner Approach 🔥)

Instead of changing all code manually:

Rename original table:

RENAME CUSTOMER TO CUSTOMER_BASE;


Create view with original name:

CREATE VIEW CUSTOMER AS
SELECT ID, NAME, SUBSTR(CELL,1,5)||'XXXXX' CELL
FROM CUSTOMER_BASE;


Now:
✔ No code changes required
✔ Applications still use CUSTOMER
✔ Masking applied automatically

This is often the best production approach.


-------------------------------------------------------------------------------------------------------------

1) - Created a new table with the cll number of varcahr2 type

CREATE TABLE CUSTOMER_NEW (
    ID        NUMBER PRIMARY KEY,
    NAME      VARCHAR2(100),
    CELL      VARCHAR2(20),   -- Masked version
    CREATED_DATE DATE
);

2 - Synchronised both the table using Insert.
INSERT INTO CUSTOMER_NEW (ID, NAME, CELL, CREATED_DATE)
SELECT ID,
       NAME,
       SUBSTR(TO_CHAR(CELL),1,LENGTH(TO_CHAR(CELL))-5) || 'XXXXX',
       CREATED_DATE
FROM CUSTOMER;

COMMIT;

3 - Created Trigger on Main table..for keepign both teh tables Upadted automatically

CREATE OR REPLACE TRIGGER TRG_CUSTOMER_SYNC
AFTER INSERT ON CUSTOMER
FOR EACH ROW
BEGIN
   INSERT INTO CUSTOMER_NEW (ID, NAME, CELL, CREATED_DATE)
   VALUES (
       :NEW.ID,
       :NEW.NAME,
       SUBSTR(TO_CHAR(:NEW.CELL),1,LENGTH(TO_CHAR(:NEW.CELL))-5) || 'XXXXX',
       :NEW.CREATED_DATE
   );
END;
/

Now:

Whenever data is inserted into CUSTOMER →
Masked data automatically inserted into CUSTOMER_NEW.

Step 4: Handle UPDATE Also (Important)

If mobile number changes:

CREATE OR REPLACE TRIGGER TRG_CUSTOMER_SYNC_UPD
AFTER UPDATE OF CELL ON CUSTOMER
FOR EACH ROW
BEGIN
   UPDATE CUSTOMER_NEW
   SET CELL = SUBSTR(TO_CHAR(:NEW.CELL),1,LENGTH(TO_CHAR(:NEW.CELL))-5) || 'XXXXX'
   WHERE ID = :NEW.ID;
END;
/

Step 5: Validate Before Switching

Before replacing:

✔ Compare row counts
✔ Validate random samples
✔ Check constraints
✔ Create indexes on new table
✔ Grant privileges
✔ Test performance

Step 6: Switch Application to New Table

ALTER TABLE CUSTOMER RENAME TO CUSTOMER_OLD;
Rename new:

ALTER TABLE CUSTOMER_NEW RENAME TO CUSTOMER;



-----------------------------------------------------------------------------------------


✅ OPTION 1 (BEST FOR PRODUCTION) → Transparent Data Encryption (TDE)

👉 Used in Banking / Enterprise systems
👉 No code change required
👉 Encryption happens at storage level

🔹 Encrypt a Column
ALTER TABLE CUSTOMER 
MODIFY (ACCOUNT_NO VARCHAR2(30) ENCRYPT);


Or stronger:

ALTER TABLE CUSTOMER 
MODIFY (ACCOUNT_NO VARCHAR2(30) 
        ENCRYPT USING 'AES256');


✔ Data stored encrypted in datafiles
✔ Application still sees normal value
✔ No change in queries

🔹 Encrypt Entire Tablespace
CREATE TABLESPACE secure_ts
DATAFILE 'secure01.dbf' SIZE 500M
ENCRYPTION USING 'AES256'
DEFAULT STORAGE (ENCRYPT);


Then move table:

ALTER TABLE CUSTOMER MOVE TABLESPACE secure_ts;


🔥 This is the most secure enterprise-level method.



----------------------------------------------------------------------------------------------------------------------
🔥 If They Ask “What Was the Most Challenging Part?”

Say:

Ensuring data integrity and regulatory compliance was the biggest challenge, as incorrect data in a Life Sciences project can directly impact clinical decisions.

That line is powerful.


✅ 2️⃣ Missing or Incomplete Data
🔹 Problem

External vendors sometimes sent incomplete files.

Example:

Missing patient IDs

Missing lab results

Null dosage values

🔹 Simple Explanation

Some critical fields were missing, which caused report failures and incorrect analysis.

🔹 Solution

Implemented validation checks before loading

Rejected incomplete records

Generated exception reports for business review

Example validation:

WHERE patient_id IS NOT NULL


---------------------------------------------------------------------


Getting records from Hospital & Labs where there patient id was same but the names where different missing middle name, or short of first_name, which causing issue in record count..so had to check teh rcrds & created 
Check before Insert condition in teh prcedure thru whic data was been inserted into teh main table from diff sources...

IF NOT EXISTS (SELECT 1 FROM patients WHERE patient_id = :new_id)
THEN INSERT ...


CREATE OR REPLACE PROCEDURE load_patients
AS
BEGIN
    FOR rec IN (
        SELECT patient_id, name, test_type
        FROM hospital_patients
        UNION
        SELECT patient_id, name, test_type
        FROM lab_patients
    )
    LOOP

        IF NOT EXISTS (
            SELECT 1
            FROM patients_master
            WHERE patient_id = rec.patient_id
        ) THEN

            INSERT INTO patients_master
                (patient_id, name, test_type, created_date)
            VALUES
                (rec.patient_id, rec.name, rec.test_type, SYSDATE);

        END IF;

    END LOOP;

    COMMIT;
END;
/