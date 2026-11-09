ROOT USER MAIL - SAMEER.AHMAD2095@GMAIL.COM



Enter user-name: conn /as sysdba
Enter password:

Connected to:
Oracle Database 21c Enterprise Edition Release 21.0.0.0.0 - Production
Version 21.3.0.0.0

SQL> alter session set container=orclpdb;

Session altered.

SQL> startup;
Pluggable Database opened.
SQL>


DROP ROLE SELECT_VDOLLAR_ROLE;
CREATE ROLE SELECT_VDOLLAR_ROLE;

BEGIN
    FOR x IN ( SELECT object_name
                 FROM dba_objects
                WHERE object_type = VIEW 
                  AND object_name LIKE V\_$% ESCAPE \ )
    LOOP
        EXECUTE IMMEDIATE grant select on  || x.object_name ||  to SELECT_VDOLLAR_ROLE;
    END LOOP;
END;
/


GRANT SELECT_VDOLLAR_ROLE TO HR;