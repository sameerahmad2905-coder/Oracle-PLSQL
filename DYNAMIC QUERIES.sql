DROP TABLE EMP1;
CREATE TABLE EMP1 AS SELECT * FROM EMP;
/
--DROP TABLE EMP1;
DECLARE
    v_exists VARCHAR2(10);
	v_sql CLOB;
BEGIN
    -- 1) Verify if table EMP1 exists
    BEGIN
        SELECT 'Y' INTO v_exists
        FROM all_tables
        WHERE table_name = 'EMP1';

        DBMS_OUTPUT.PUT_LINE('Table EMP1 exists.');

        -- 2) Drop the table
        EXECUTE IMMEDIATE 'DROP TABLE EMP1';
        DBMS_OUTPUT.PUT_LINE('Table EMP1 dropped.');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Table EMP1 does not exist.');
    END;

    -- 3) Verify again if table EMP1 exists
    BEGIN
        SELECT 'Y' INTO v_exists
        FROM all_tables
        WHERE table_name = 'EMP1';

        DBMS_OUTPUT.PUT_LINE('Table EMP1 still exists.');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Table EMP1 does not exist. Proceeding to recreate.');

            -- 4) Recreate table with two columns
            EXECUTE IMMEDIATE 'CREATE TABLE EMP1 (
                                  c1 NUMBER,
                                  c2 NUMBER
                               )';
            DBMS_OUTPUT.PUT_LINE('Table EMP1 created.');

            -- 5) Insertion to fixed declared table_name (EXECUTE IMMEDIATE needed for fixed table)
            v_sql := 'INSERT INTO EMP1 (c1, c2) VALUES (1, 100)';
			EXECUTE IMMEDIATE v_sql;
           --- INSERT INTO EMP1 (c1, c2) VALUES (2, 200);

            DBMS_OUTPUT.PUT_LINE('Sample records inserted into EMP1.');
            COMMIT;
    END;
END;
/

DECLARE
V_SQL CLOB;
BEGIN
    -- Drop if exists
    BEGIN
        EXECUTE IMMEDIATE 'DROP TABLE EMP1';
        DBMS_OUTPUT.PUT_LINE('Table EMP1 dropped.');
    EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('Table EMP1 did not exist.');
    END;

    BEGIN
    -- Recreate with both columns
    EXECUTE IMMEDIATE 'CREATE TABLE EMP1 (
                          c1 NUMBER,
                          c2 NUMBER
                       )';
  DBMS_OUTPUT.PUT_LINE('Table EMP1 created.');
    END;
  -- Insert rows
   V_SQL := 'INSERT INTO EMP1 (C1, C2) VALUES (1,2)';
     EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('Rows inserted.');
    COMMIT;
END;
/

SELECT * FROM EMP1;


------------------------------------------------------------------------


DECLARE
    v_exists VARCHAR2(10);
	v_sql CLOB;
BEGIN
    -- 1) Verify if table EMP1 exists
    BEGIN
        SELECT 'Y' INTO v_exists
        FROM all_tables
        WHERE table_name = 'EMP1';

        DBMS_OUTPUT.PUT_LINE('Table EMP1 exists.');

        -- 2) Drop the table
        EXECUTE IMMEDIATE 'DROP TABLE EMP1';
        DBMS_OUTPUT.PUT_LINE('Table EMP1 dropped.');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Table EMP1 does not exist.');
    END;

    -- 3) Verify again if table EMP1 exists
    BEGIN
        SELECT 'Y' INTO v_exists
        FROM all_tables
        WHERE table_name = 'EMP1';

        DBMS_OUTPUT.PUT_LINE('Table EMP1 still exists.');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Table EMP1 does not exist. Proceeding to recreate.');

            -- 4) Recreate table with two columns
            EXECUTE IMMEDIATE 'CREATE TABLE EMP1 (
                                  c1 NUMBER,
                                  c2 NUMBER
                               )';
            DBMS_OUTPUT.PUT_LINE('Table EMP1 created.');

            -- 5) Insertion to fixed declared table_name (EXECUTE IMMEDIATE needed for fixed table)
            v_sql := 'INSERT INTO EMP1 (c1, c2) VALUES (1, 100)';
			EXECUTE IMMEDIATE v_sql;
           --- INSERT INTO EMP1 (c1, c2) VALUES (2, 200);

            DBMS_OUTPUT.PUT_LINE('Sample records inserted into EMP1.');
            COMMIT;
    END;
END;
/


BEGIN
    -- Drop EMP1 if it exists
    BEGIN
        EXECUTE IMMEDIATE 'DROP TABLE EMP1';
        DBMS_OUTPUT.PUT_LINE('Table EMP1 dropped.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Table EMP1 did not exist.');
    END;

    BEGIN
    -- Recreate EMP1 with c1 and c2
    EXECUTE IMMEDIATE 'CREATE TABLE EMP11 (
                          c1 NUMBER,
                          c2 NUMBER
                       )';
     END;
     
    DBMS_OUTPUT.PUT_LINE('Table EMP1 created with columns c1 and c2.');

    -- Insert sample rows
    INSERT INTO EMP11 (c1, c2) VALUES (1, 100);
    INSERT INTO EMP11 (c1, c2) VALUES (2, 200);
    DBMS_OUTPUT.PUT_LINE('Rows inserted into EMP1.');
    COMMIT;
END;
/
SELECT * FROM EMP1;
DROP TABLE EMP11;

-------------------------------------

--DROP TABLE EMP1;
--SELECT * FROM EMP1;
CREATE TABLE EMP1 AS SELECT * FROM EMP;
/
DECLARE
    v_exists VARCHAR2(10);
	v_sql CLOB;
BEGIN
    -- 1) Verify if table EMP1 exists
    BEGIN
        SELECT TABLE_NAME INTO v_exists
        FROM all_tables
        WHERE table_name = 'EMP1';
        
        IF V_EXISTS = 'EMP1' THEN
        DBMS_OUTPUT.PUT_LINE('Table EMP1 exists.');
        EXECUTE IMMEDIATE 'DROP TABLE EMP1';
        DBMS_OUTPUT.PUT_LINE('Table EMP1 dropped.');
        END IF;
        

        SELECT 'Y' INTO V_EXISTS FROM ALL_TABLES 
        WHERE TABLE_NAME = 'EMP1';
        EXCEPTION 
        WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('TABLE NOT EXISTS');
        EXECUTE IMMEDIATE 'CREATE TABLE EMP1 (ID NUMBER)';
        DBMS_OUTPUT.PUT_LINE('Table EMP1 CREATED.');
    

            -- 5) Insertion to fixed declared table_name (EXECUTE IMMEDIATE needed for fixed table)
            v_sql := 'INSERT INTO EMP1 (ID) VALUES (1)';
			EXECUTE IMMEDIATE v_sql;
           --- INSERT INTO EMP1 (c1, c2) VALUES (2, 200);

            DBMS_OUTPUT.PUT_LINE('Sample records inserted into EMP1.');
            COMMIT;
    END;
END;
/

SELECT * FROM EMP1;

SELECT dbms_metadata.get_ddl('TABLE','EMP1') FROM dual;
/



DECLARE
    v_exists VARCHAR2(10);
	v_sql CLOB;
BEGIN
    -- 1) Verify if table EMP1 exists
    BEGIN
        SELECT 'Y' INTO v_exists
        FROM all_tables
        WHERE table_name = 'EMP1';

        DBMS_OUTPUT.PUT_LINE(v_exists);
end;
end;
/
        -- 2) Drop the table
        EXECUTE IMMEDIATE 'DROP TABLE EMP1';
        DBMS_OUTPUT.PUT_LINE('Table EMP1 dropped.');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Table EMP1 does not exist.');
    END;
END;
/