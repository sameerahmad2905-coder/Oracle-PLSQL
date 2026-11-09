
--REVIEWING PROC
VARIBALE DECLARATION, PARAMETERS, DML & DDL, EXCEPTION (PRE-DEFINED/USER DEFINED) WHEN OTHERS HIGHER PRIORITY


--EYE ON A PROCEDURE
SCHEMA QUALIFIED TABLE, SCRIPTS PURPOSE - VERSION UPDATE, PARENT CHILD RELATION 

--QUERIES TAKING LONGER TIME..

EXECUTION TAKING AS ITS WAITING FOR ANY SUCCESSFULL EXECUTION, IF THERES ANY THING INCORRECT THEN IT WOULD HAVE THROWN 
ERROR & STOPPED WORKING.

THIS WAITING COULD BE CAUSED BY ANY LOCK..IF ITS SO THEN I CAN CHECK IT FROM THE DATA DICTIONARY VIEWS
				V$LOCK / V$LOCKED_OBJECTS / ALL_OBJECTS...AND IF IT SO CAN CHECK IN THE AUDIT TABLE CRAETED UPON TABLE
				AFTER CONFIRMING COULD EITHER COMMIT / ROLLABCK IT OR KILL THAT SESSION IF NOT NEEDED.
				


AGILE - BUSINESS REQUIREMENT
								DESIGN 
										DEVELOPMENT
													HIGHER ENVIRONEMNT
9

--------FUNCTIONS SUPPORTING REGEX----



Anchoring Characters are metacharacters that 
affect the position of the search.
----------------------------------------------------
Character 	Class      		Description
		^      Anchor 		The expression to the start of a line
		$      Anchor 		The expression to the end of a line
		 
 
 
Equivalence Classes      
----------------------------------------------------
Character Class     				 Description
	= =      				Oracle supports the equivalence classes through 
							the POSIX '[==]' syntax. A base letter and all of 
							its accented versions constitute an equivalence 
							class. For example, the equivalence class '[=a=]' 
							matches Ã¤ and Ã¢. The equivalence classes are valid 
							only inside the bracketed expression
 
 
Match Options determine if the target is treated checked for 
case-sensitivity and whether or not the target is evaluated 
line by line or as a continuous string. 
----------------------------------------------------
Character Class      		       Description
       c      					Case sensitive matching
       i      					Case insensitive matching
       m      				Treat source string as multi-line activating Anchor chars
       n      				    Allow the period (.) to match any newline character
 
 
 
Posix Characters tend to look very ugly but have the advantage 
that also take into account the 'locale', that is, any variant 
of the local language/coding system.
----------------------------------------------------
Character Class      Description
	[:digit:]            Only the digits 0 to 9
	[:alnum:]          Any alphanumeric character 0 to 9 OR A to Z or a to z.
	[:alpha:]          Any alpha character A to Z or a to z.
	[:blank:]          Space and TAB characters only.
	[:xdigit:]         Hexadecimal notation 0-9, A-F, a-f.
	[:punct:]         Punctuation symbols 
                --------------------------------
              --  % . ,  ' ? ! : # $ & ( ) * ;
                + - / < > = @ [ ] \ ^ _ { } | ~
                --------------------------------
[:print:]        Any printable character.
[:space:]      Any whitespace characters (space, tab, NL, FF, VT, CR). 
                   Many system abbreviate as \s.
[:graph:]       Exclude whitespace (SPACE, TAB). Many system abbreviate as \W.
[:upper:]      Any alpha character A to Z.
[:lower:]      Any alpha character a to z.
[:cntrl:]        Control Characters NL CR LF TAB VT FF NUL SOH STX 
					EXT EOT ENQ ACK SO SI DLE DC1 DC2 DC3 DC4 NAK SYN 
					ETB CAN EM SUB ESC IS1 IS2 IS3 IS4 DEL.
 
 
Quantifier Characters control the number of times a character 
or string is found in a search.
----------------------------------------------------
Character Class      Description
		*      			Match 0 or more times
		?      			Match 0 or 1 time
		+     			Match 1 or more times
		{m}      		Match exactly m times
		{m,}      	Match at least m times
		{m, n}       Match at least m times but no more than n times
		\n             Cause the previous expression to be repeated n times
 
 
 
Alternative Matching And Grouping Characters      
----------------------------------------------------
Character Class      Description
|      Separates alternates, often used with grouping 
        operator ()
 
( )      Groups subexpression into a unit for alternations, for 
        quantifiers, or for backreferencing 
 
[char]      Indicates a character list; most metacharacters inside a
        character list are understood as literals, with the 
        exception of character classes, and the ^ 
        and - metacharacters
 
 
////////////////////////////////////////////////////
Regex Cheat Sheet (non-posix)
////////////////////////////////////////////////////
 
 
Modifiers: 
i   case-insensitive pattern matching. 
 
g   global replace, or replace all 
 
m   Treat string as multiple lines. That is, 
    change ``^'' and ``$'' from matching at only 
    the very start or end of the string to the 
    start or end of any line anywhere within the string 
 
s   Treat string as single line. That is, change ``.'' to 
    match any character whatsoever, even a newline, which 
    it normally would not match. 
 
x   Extend your patterns legibility by permitting 
    whitespace and comments.
 
 
Special Characters:
The following should be escaped if you are trying to 
match that character:
 
 \  ^  .  $  |  (  )  [  ]
 *  +  ?  {  }  ,
 
 
Special Character Definitions:
    \   Quote the next metacharacter
    ^   Match the beginning of the line
    .   Match any character (except newline)
    $   Match the end of the line (or before newline at the end)
    |   Alternation
    ()  Grouping
    []  Character class
    *      Match 0 or more times
    +      Match 1 or more times
    ?      Match 1 or 0 times
    {n}    Match exactly n times
    {n,}   Match at least n times
    {n,m}  Match at least n but not more than m times
 
More Special Characters: 
    \t          tab                   (HT, TAB)
    \n          newline               (LF, NL)
    \r          return                (CR)
    \f          form feed             (FF)
    \a          alarm (bell)          (BEL)
    \e          escape (think troff)  (ESC)
    \033        octal char (think of a PDP-11)
    \x1B        hex char
    \c[         control char
    \l          lowercase next char (think vi)
    \u          uppercase next char (think vi)
    \L          lowercase till \E (think vi)
    \U          uppercase till \E (think vi)
    \E          end case modification (think vi)
    \Q          quote (disable) pattern metacharacters till \E
 
Even More Special Characters:
    \w  Match a word character (alphanumeric plus _)
    \W  Match a non-word character
    \s  Match a whitespace character
    \S  Match a non-whitespace character
    \d  Match a digit character
    \D  Match a non-digit character
    \b  Match a word boundary
    \B  Match a non-(word boundary)
    \A  Match only at beginning of string
    \Z  Match only at end of string, or before newline at the end
    \z  Match only at end of string
    \G  Match only where previous m//g left off (works only with /g)
 
 

METACHARACTERS - WHIHC ARE OPERATORS THAT SPECIFY SEARCH ALGORITHM

* - 
LITERALS - CHARACERS FOR WHIC HWE ARE SEARCHING


REGEXP_LIKE
REGEXP_COUNT
REGEXP_INSTR
REGEXP_REPLACE
REGEXP_SUBSTR



 select  regexp_substr('SAMEER,AHMAD,KHAN','[^,]+',1,LEVEL) as tableName
   from dual
   connect by LEVEL <= 3;

REGEXP_LIKE(SEARCH_STRING, PATTERN[,MATCH_OPTION]);
/

SELECT REGEXP_LIKE('ORACLE','^[[:ALPHA:]]{6}$') FROM DUAL;


SELECT * FROM EMP WHERE REGEXP_LIKE(EMAIL,'*CGI.com$');



desc EMP;

UPDATE EMP SET CELL = 8700132537 WHERE ENAME=('Saneer Ahmad');

SELECT * FROM EMP WHERE REGEXP_LIKE(CELL,'^[0-9]{10,12}$');

UPDATE EMP SET CELL = REPLACE(CELL,'+','');
SELECT * FROM EMP;

STARTING WITH (*) MEANS ANYTHING B4...
^ SPECIFIES THE ONLY VALUES THAT SGHUD B THERE
[0-9] AFTER CARAT (^)SPECIFIES THAT IT SHOULD SYTART WITH ANY OF THESE
{} NO IN CURLY BRACKET SPECIFIES ITS LENGTH THAT SHUD BE
$ EVERY SEARCH SHUD END WITH $

create table tbl1 (
   id number,
   value varchar2(50)
);

insert into tbl1 values (1, 'AA, UT, BT, SK, SX');
insert into tbl1 values (2, 'AA, UT, SX');
insert into tbl1 values (3, 'UT, SK, SX, ZF');


SELECT * FROM TBL1;


SELECT DISTINCT(TRIM(REGEXP_SUBSTR(VALUE, '[^,]+',1,LEVEL))) VALUE FROM TBL1 WHERE ID=1
CONNECT BY REGEXP_SUBSTR(VALUE, '[^,]+',1,LEVEL) IS NOT NULL;



SELECT * FROM TBL1;
INSERT INTO TBL1 VALUES (4,'SAMEER.AHMAD@GMAIL.COM');

SELECT DEPTNO, LISTAGG(ENAME,' , ') WITHIN GROUP (ORDER BY ENAME) FROM EMP
GROUP BY DEPTNO;





SELECT ENAME, EMPNO, SAL, DEPARTMENT_NAME FROM EMP LEFT JOIN DEPT
ON (EMP.DEPTNO = DEPT.DEPARTMENT_ID);

CREATE OR REPLACE FUNCTION FUNC_TEST (A IN NUMBER, B OUT NUMBER)
AS
V_B NUMBER;
RETURN VARCHAR;
BEGIN
SELECT SAL FROM EMP WHERE EMPNO=A;
RETURN V_B;
/
REGEXP_LIKE(SEARCH_STRING, PATTERN[,MATCH_OPTION]);
/

SELECT REGEXP_LIKE('ORACLE','^[[:ALPHA:]]{6}$') FROM DUAL;


SELECT * FROM EMP WHERE REGEXP_LIKE(EMAIL,'*CGI.com$');



desc EMP;

UPDATE EMP SET CELL = 8700132537 WHERE ENAME=('Saneer Ahmad');

SELECT * FROM EMP WHERE REGEXP_LIKE(CELL,'^[0-9]{10,12}$');

UPDATE EMP SET CELL = REPLACE(CELL,'+','');
SELECT * FROM EMP;
/*
STARTING WITH (*) MEANS ANYTHING B4...
^ SPECIFIES THE ONLY VALUES THAT SGHUD B THERE, STARTING WITH
[0-9] AFTER CARAT (^)SPECIFIES THAT IT SHOULD SYTART WITH ANY OF THESE
{} NO IN CURLY BRACKET SPECIFIES ITS LENGTH THAT SHUD BE
$ EVERY SEARCH SHUD END WITH $
[^] CARET SYMBOL INSIDE BRACKET SPECIFIES T SKIP THE 

*/


CREATE TABLE REX_EMP AS SELECT * FROM EMP WHERE SAL < 5000;

SELECT * FROM REX_EMP;
DROP TABLE REX_EMP;

CREATE TABLE EMP_REX (ENAME VARCHAR(30), EMAIL VARCHAR(30), PHONE VARCHAR(30));


INSERT INTO EMP_REX VALUES ('ADAM','ADAM@GMAIL.COM','8700132537');
INSERT INTO EMP_REX VALUES ('STEVE','STEVE@YAHOO.COM','654654');
INSERT INTO EMP_REX VALUES ('MIKE','MIKE@GMAIL.COM','2222222222');
INSERT INTO EMP_REX VALUES ('JOHN','JOHN@REDIFFMAIL.COM','555 555 5555');
INSERT INTO EMP_REX VALUES ('KATE','KATE@GMAIL.COM','333-333-3333');




SELECT * FROM EMP_REX;

SELECT * FROM EMP_REX WHERE REGEXP_LIKE(PHONE,'^[0-9]{3} [0-9]{3 [0-9]{4}$');  --555 555 5555
SELECT * FROM EMP_REX WHERE REGEXP_LIKE(PHONE,'^[0-9]{3}[-][0-9]{3}[-][0-9]{4}$');  --333-333-3333

SELECT * FROM EMP_REX WHERE REGEXP_LIKE(PHONE,'^[0-9]{10}$');


CREATE TABLE TEMP_REX (EMAIL VARCHAR2(30), CHECK(REGEXP_LIKE(EMAIL,'*@*.COM$'))
                        );
                        
                        SELECT * FROM TEMP_REX;
                        
INSERT INTO TEMP_REX VALUES ('SAMEER.AHMAD@GMAIL.COM');                        
INSERT INTO TEMP_REX VALUES ('LIVE@CO.IN');  


----------------REGEXP_SUBSTR---------

REGEXP_SUBSTR(source_char, pattern [, position [, occurrence [, match_param [, subexpr ]]]]])[
       
 select  regexp_substr('SAMEER,AHMAD,KHAN','[^,]+',1,LEVEL) as tableName
   from dual
   connect by LEVEL <= 3; --REGEXP_COUNT('SAMEER,AHMAD,KHAN' ,'[,]');
   

In Oracle SQL, when used with CONNECT BY, the LEVEL pseudocolumn, combined with functions like REGEXP_SUBSTR, 
allows you to extract substrings from a string based on a regular expression, effectively splitting a string 
into multiple rows. Heres how it works:

CONNECT BY:
This clause is used to create hierarchical queries, and the LEVEL pseudocolumn increments with each level of the hierarchy. 

REGEXP_SUBSTR:
This function extracts a substring from a string based on a regular expression. 

LEVEL as Occurrence:
The LEVEL pseudocolumn is used as the fourth parameter of REGEXP_SUBSTR, which specifies the occurrence of the substring to extract. 


Example:
To split a comma-separated string into rows, you can use REGEXP_SUBSTR with LEVEL to extract each comma-separated value, where LEVEL iterates through each occurrence. 
Example:
Code

WITH
  t AS (SELECT 'apple,banana,cherry' AS my_string FROM DUAL)
SELECT
  REGEXP_SUBSTR(my_string, '[^,]+', 1, LEVEL) AS fruit
FROM
  t
CONNECT BY
  LEVEL <= REGEXP_COUNT(my_string, ',') + 1;
Explanation:
The WITH clause creates a temporary table t with a string apple,banana,cherry.
The REGEXP_SUBSTR function extracts substrings that are not commas ([^,]) from the my_string column.
The LEVEL pseudocolumn, used as the occurrence parameter, starts at 1 and increments with each row, extracting the first, second, and third substrings (apple, banana, cherry).
The CONNECT BY clause ensures that the query iterates through each level, up to the number of occurrences of the comma plus 1 (to include the last substring).
The REGEXP_COUNT function counts the occurrences of the comma in the string to determine the maximum level. 

	   

SELECT REPLACE(REGEXP_SUBSTR('SAMEER.AHMAD@GMAIL.COM','[^@]+'),'.',' ') FROM DUAL;

SELECT REGEXP_SUBSTR(EMAIL,'[^@]+') FROM EMP_REX;

SELECT REGEXP_SUBSTR('123$@/8957/XYZ','[^[:digit:]]+$') FROM DUAL;

--SELECT REGEXP_SUBSTR('123$@/8957/XYZ/\/\','[^[:alnum:]]+$') FROM DUAL;


----------------REGEXP_INSTR---------

--(SEARCH_STRING, PATTERN[,POSITION [,OCCURENCE [,RETURN_OPTION [,MATCH_OPTION]]]]

SELECT REGEXP_INSTR('Oracle','a|e|i|o|u',1,3,0,'i') FROM DUAL;


SELECT REGEXP_INSTR('DATABASE','a|e|i|o|u',1,4,0,'i') FROM DUAL; --STARTING FROM 1 POSITION OCCURENCE OF ANY OF THE PAATTERN CHARACTER 4TH TIME
                                                                    ----WHICH VUD BE 'E' AND ITS POSITION IS 8 
                                                                    
                                                                    
----------------------REGEXP_REPLACE---------  

--(SEARCH_STRING, PATTERN[,REPKACE_STRING [,POSITION [,OCCURENCE [,MATCH_OPTION]]]]

SELECT REGEXP_REPLACE('I  AM  A   BOY','[[:blank:]]{2,5}',' ') FROM DUAL; 


--8700132537     (870) 013-2537
SELECT REGEXP_REPLACE('8700132537','([[:digit:]]{3})([[:digit:]]{3})([[:digit:]]{3})','(\1) \2-\3') FROM DUAL;


----------------------REGEXP_COUNT---------  


SELECT REGEXP_COUNT('ORACLE DATABASE','A') FROM DUAL;/



----------------------------------------------------

STRING, PATTERN [,START_POSITION [,MATCH_OPTION]]]


create table tbl1 (
   id number,
   value varchar2(50)
);

insert into tbl1 values (1, 'AA, UT, BT, SK, SX');
insert into tbl1 values (2, 'AA, UT, SX');
insert into tbl1 values (3, 'UT, SK, SX, ZF');


SELECT * FROM TBL1;


SELECT DISTINCT(TRIM(REGEXP_SUBSTR(VALUE, '[^,]+',1,LEVEL))) VALUE FROM TBL1 WHERE ID=1
CONNECT BY REGEXP_SUBSTR(VALUE, '[^,]+',1,LEVEL) IS NOT NULL;



SELECT * FROM TBL1;
INSERT INTO TBL1 VALUES (4,'SAMEER.AHMAD@GMAIL.COM');

SELECT DEPTNO, LISTAGG(ENAME,' , ') WITHIN GROUP (ORDER BY ENAME) FROM EMP
GROUP BY DEPTNO;





SELECT ENAME, EMPNO, SAL, DEPARTMENT_NAME FROM EMP LEFT JOIN DEPT
ON (EMP.DEPTNO = DEPT.DEPARTMENT_ID);

CREATE OR REPLACE FUNCTION FUNC_TEST (A IN NUMBER, B OUT NUMBER)
AS
V_B NUMBER;
RETURN VARCHAR;
BEGIN
SELECT SAL FROM EMP WHERE EMPNO=A;
RETURN V_B;
/


Anchoring Characters are metacharacters that 
affect the position of the search.
----------------------------------------------------
Character Class      Description
^      Anchor the expression to the start of a line
$      Anchor the expression to the end of a line
 
 
 
Equivalence Classes      
----------------------------------------------------
Character Class      Description
= =      Oracle supports the equivalence classes through 
        the POSIX '[==]' syntax. A base letter and all of 
        its accented versions constitute an equivalence 
        class. For example, the equivalence class '[=a=]' 
        matches Ã¤ and Ã¢. The equivalence classes are valid 
        only inside the bracketed expression
 
 
Match Options determine if the target is treated checked for 
case-sensitivity and whether or not the target is evaluated 
line by line or as a continuous string. 
----------------------------------------------------
Character Class      Description
c      Case sensitive matching
i      Case insensitive matching
m      Treat source string as multi-line activating Anchor chars
n      Allow the period (.) to match any newline character
 
 
 
Posix Characters tend to look very ugly but have the advantage 
that also take into account the 'locale', that is, any variant 
of the local language/coding system.
----------------------------------------------------
Character Class      Description
[:digit:]      Only the digits 0 to 9
[:alnum:]      Any alphanumeric character 0 to 9 OR A to Z or a to z.
[:alpha:]      Any alpha character A to Z or a to z.
[:blank:]      Space and TAB characters only.
[:xdigit:]     Hexadecimal notation 0-9, A-F, a-f.
[:punct:]      Punctuation symbols 
                --------------------------------
              --  % . ,  ' ? ! : # $ & ( ) * ;
                + - / < > = @ [ ] \ ^ _ { } | ~
                --------------------------------
[:print:]      Any printable character.
[:space:]      Any whitespace characters (space, tab, NL, FF, VT, CR). 
                Many system abbreviate as \s.
[:graph:]      Exclude whitespace (SPACE, TAB). Many system abbreviate as \W.
[:upper:]      Any alpha character A to Z.
[:lower:]      Any alpha character a to z.
[:cntrl:]      Control Characters NL CR LF TAB VT FF NUL SOH STX 
                EXT EOT ENQ ACK SO SI DLE DC1 DC2 DC3 DC4 NAK SYN 
                ETB CAN EM SUB ESC IS1 IS2 IS3 IS4 DEL.
 
 
Quantifier Characters control the number of times a character 
or string is found in a search.
----------------------------------------------------
Character Class      Description
*      Match 0 or more times
?      Match 0 or 1 time
+      Match 1 or more times
{m}      Match exactly m times
{m,}      Match at least m times
{m, n}      Match at least m times but no more than n times
\n      Cause the previous expression to be repeated n times
 
 
 
Alternative Matching And Grouping Characters      
----------------------------------------------------
Character Class      Description
|      Separates alternates, often used with grouping 
        operator ()
 
( )      Groups subexpression into a unit for alternations, for 
        quantifiers, or for backreferencing 
 
[char]      Indicates a character list; most metacharacters inside a
        character list are understood as literals, with the 
        exception of character classes, and the ^ 
        and - metacharacters
 
 
////////////////////////////////////////////////////
Regex Cheat Sheet (non-posix)
////////////////////////////////////////////////////
 
 
Modifiers: 
i   case-insensitive pattern matching. 
 
g   global replace, or replace all 
 
m   Treat string as multiple lines. That is, 
    change ``^'' and ``$'' from matching at only 
    the very start or end of the string to the 
    start or end of any line anywhere within the string 
 
s   Treat string as single line. That is, change ``.'' to 
    match any character whatsoever, even a newline, which 
    it normally would not match. 
 
x   Extend your patterns legibility by permitting 
    whitespace and comments.
 
 
Special Characters:
The following should be escaped if you are trying to 
match that character:
 
 \  ^  .  $  |  (  )  [  ]
 *  +  ?  {  }  ,
 
 
Special Character Definitions:
    \   Quote the next metacharacter
    ^   Match the beginning of the line
    .   Match any character (except newline)
    $   Match the end of the line (or before newline at the end)
    |   Alternation
    ()  Grouping
    []  Character class
    *      Match 0 or more times
    +      Match 1 or more times
    ?      Match 1 or 0 times
    {n}    Match exactly n times
    {n,}   Match at least n times
    {n,m}  Match at least n but not more than m times
 
More Special Characters: 
    \t          tab                   (HT, TAB)
    \n          newline               (LF, NL)
    \r          return                (CR)
    \f          form feed             (FF)
    \a          alarm (bell)          (BEL)
    \e          escape (think troff)  (ESC)
    \033        octal char (think of a PDP-11)
    \x1B        hex char
    \c[         control char
    \l          lowercase next char (think vi)
    \u          uppercase next char (think vi)
    \L          lowercase till \E (think vi)
    \U          uppercase till \E (think vi)
    \E          end case modification (think vi)
    \Q          quote (disable) pattern metacharacters till \E
 
Even More Special Characters:
    \w  Match a word character (alphanumeric plus _)
    \W  Match a non-word character
    \s  Match a whitespace character
    \S  Match a non-whitespace character
    \d  Match a digit character
    \D  Match a non-digit character
    \b  Match a word boundary
    \B  Match a non-(word boundary)
    \A  Match only at beginning of string
    \Z  Match only at end of string, or before newline at the end
    \z  Match only at end of string
    \G  Match only where previous m//g left off (works only with /g)
 
 
 --------------------------------------------------------------------------------
 
 
 
create table tbl1 (
   id number,
   value varchar2(50)
);

insert into tbl1 values (1, 'AA, UT, BT, SK, SX');
insert into tbl1 values (2, 'AA, UT, SX');
insert into tbl1 values (3, 'UT, SK, SX, ZF');


SELECT * FROM TBL1;


SELECT DISTINCT(TRIM(REGEXP_SUBSTR(VALUE, '[^,]+',1,LEVEL))) VALUE FROM TBL1 WHERE ID=1
CONNECT BY REGEXP_SUBSTR(VALUE, '[^,]+',1,LEVEL) IS NOT NULL;



SELECT * FROM TBL1;
INSERT INTO TBL1 VALUES (4,'SAMEER.AHMAD@GMAIL.COM');

SELECT DEPTNO, LISTAGG(ENAME,' , ') WITHIN GROUP (ORDER BY ENAME) FROM EMP
GROUP BY DEPTNO;





SELECT ENAME, EMPNO, SAL, DEPARTMENT_NAME FROM EMP LEFT JOIN DEPT
ON (EMP.DEPTNO = DEPT.DEPARTMENT_ID);

CREATE OR REPLACE FUNCTION FUNC_TEST (A IN NUMBER, B OUT NUMBER)
AS
V_B NUMBER;
RETURN VARCHAR;
BEGIN
SELECT SAL FROM EMP WHERE EMPNO=A;
RETURN V_B;
/




--REVIEWING PROC
VARIBALE DECLARATION, PARAMETERS, DML & DDL, EXCEPTION (PRE-DEFINED/USER DEFINED) WHEN OTHERS HIGHER PRIORITY


--EYE ON A PROCEDURE
SCHEMA QUALIFIED TABLE, SCRIPTS PURPOSE - VERSION UPDATE, PARENT CHILD RELATION 

--QUERIES TAKING LONGER TIME..

EXECUTION TAKING AS ITS WAITING FOR ANY SUCCESSFULL EXECUTION, IF THERES ANY THING INCORRECT THEN IT WOULD HAVE THROWN 
ERROR & STOPPED WORKING.

THIS WAITING COULD BE CAUSED BY ANY LOCK..IF ITS SO THEN I CAN CHECK IT FROM THE DATA DICTIONARY VIEWS
				V$LOCK / V$LOCKED_OBJECTS / ALL_OBJECTS...AND IF IT SO CAN CHECK IN THE AUDIT TABLE CRAETED UPON TABLE
				AFTER CONFIRMING COULD EITHER COMMIT / ROLLABCK IT OR KILL THAT SESSION IF NOT NEEDED.
				


AGILE - BUSINESS REQUIREMENT
								DESIGN 
										DEVELOPMENT
													HIGHER ENVIRONEMNT
9

--------FUNCTIONS SUPPORTING REGEX----


METACHARACTERS - WHIHC ARE OPERATORS THAT SPECIFY SEARCH ALGORITHM

* - 
LITERALS - CHARACERS FOR WHIC HWE ARE SEARCHING


REGEXP_LIKE
REGEXP_COUNT
REGEXP_INSTR
REGEXP_REPLACE
REGEXP_SUBSTR


REGEXP_LIKE(SEARCH_STRING, PATTERN[,MATCH_OPTION]);
/

SELECT REGEXP_LIKE('ORACLE','^[[:ALPHA:]]{6}$') FROM DUAL;


SELECT * FROM EMP WHERE REGEXP_LIKE(EMAIL,'*CGI.com$');



desc EMP;

UPDATE EMP SET CELL = 8700132537 WHERE ENAME=('Saneer Ahmad');

SELECT * FROM EMP WHERE REGEXP_LIKE(CELL,'^[0-9]{10,12}$');

UPDATE EMP SET CELL = REPLACE(CELL,'+','');
SELECT * FROM EMP;

STARTING WITH (*) MEANS ANYTHING B4...
^ SPECIFIES THE ONLY VALUES THAT SGHUD B THERE
[0-9] AFTER CARAT (^)SPECIFIES THAT IT SHOULD SYTART WITH ANY OF THESE
{} NO IN CURLY BRACKET SPECIFIES ITS LENGTH THAT SHUD BE
$ EVERY SEARCH SHUD END WITH $

create table tbl1 (
   id number,
   value varchar2(50)
);

insert into tbl1 values (1, 'AA, UT, BT, SK, SX');
insert into tbl1 values (2, 'AA, UT, SX');
insert into tbl1 values (3, 'UT, SK, SX, ZF');


SELECT * FROM TBL1;


SELECT DISTINCT(TRIM(REGEXP_SUBSTR(VALUE, '[^,]+',1,LEVEL))) VALUE FROM TBL1 WHERE ID=1
CONNECT BY REGEXP_SUBSTR(VALUE, '[^,]+',1,LEVEL) IS NOT NULL;


 select  regexp_substr('SAMEER,AHMAD,KHAN','[^,]+',1,LEVEL) as tableName
   from dual
   connect by LEVEL <= 3; --REGEXP_COUNT('SAMEER,AHMAD,KHAN' ,'[,]');
   
   SELECT REGEXP_COUNT('SAMEER,AHMAD,KHAN' ,'[,]')+1 FROM DUAL;
   
   SELECT LEVEL FROM DUAL  connect by LEVEL <=5;

SELECT REPLACE(REGEXP_SUBSTR('SAMEER.AHMAD@GMAIL.COM','[^@]+'),'.',' ') FROM DUAL;

SELECT REPLACE(REGEXP_SUBSTR('SAMEER.AHMAD@GMAIL.COM','[^@]+'),'.',' ') FROM DUAL

SELECT * FROM TBL1;
INSERT INTO TBL1 VALUES (4,'SAMEER.AHMAD@GMAIL.COM');

SELECT DEPTNO, LISTAGG(ENAME,' , ') WITHIN GROUP (ORDER BY ENAME) FROM EMP
GROUP BY DEPTNO;





SELECT ENAME, EMPNO, SAL, DEPARTMENT_NAME FROM EMP LEFT JOIN DEPT
ON (EMP.DEPTNO = DEPT.DEPARTMENT_ID);

CREATE OR REPLACE FUNCTION FUNC_TEST (A IN NUMBER, B OUT NUMBER)
AS
V_B NUMBER;
RETURN VARCHAR;
BEGIN
SELECT SAL FROM EMP WHERE EMPNO=A;
RETURN V_B;
/
REGEXP_LIKE(SEARCH_STRING, PATTERN[,MATCH_OPTION]);
/

SELECT REGEXP_LIKE('ORACLE','^[[:ALPHA:]]{6}$') FROM DUAL;


SELECT * FROM EMP WHERE REGEXP_LIKE(EMAIL,'*CGI.com$');



desc EMP;

UPDATE EMP SET CELL = 8700132537 WHERE ENAME=('Saneer Ahmad');

SELECT * FROM EMP WHERE REGEXP_LIKE(CELL,'^[0-9]{10,12}$');

UPDATE EMP SET CELL = REPLACE(CELL,'+','');
SELECT * FROM EMP;
/*
STARTING WITH (*) MEANS ANYTHING B4...
^ SPECIFIES THE ONLY VALUES THAT SGHUD B THERE, STARTING WITH
[0-9] AFTER CARAT (^)SPECIFIES THAT IT SHOULD SYTART WITH ANY OF THESE
{} NO IN CURLY BRACKET SPECIFIES ITS LENGTH THAT SHUD BE
$ EVERY SEARCH SHUD END WITH $
[^] CARET SYMBOL INSIDE BRACKET SPECIFIES T SKIP THE 
\1 - REPRESNET THE THE SUBGROUP 1, \2 - SUBGROUP -2

*/


CREATE TABLE REX_EMP AS SELECT * FROM EMP WHERE SAL < 5000;

SELECT * FROM REX_EMP;
DROP TABLE REX_EMP;

CREATE TABLE EMP_REX (ENAME VARCHAR(30), EMAIL VARCHAR(30), PHONE VARCHAR(30));


INSERT INTO EMP_REX VALUES ('ADAM','ADAM@GMAIL.COM','8700132537');
INSERT INTO EMP_REX VALUES ('STEVE','STEVE@YAHOO.COM','654654');
INSERT INTO EMP_REX VALUES ('MIKE','MIKE@GMAIL.COM','2222222222');
INSERT INTO EMP_REX VALUES ('JOHN','JOHN@REDIFFMAIL.COM','555 555 5555');
INSERT INTO EMP_REX VALUES ('KATE','KATE@GMAIL.COM','333-333-3333');




SELECT * FROM EMP_REX;

SELECT * FROM EMP_REX WHERE REGEXP_LIKE(PHONE,'^[0-9]{3} [0-9]{3 [0-9]{4}$');  --555 555 5555
SELECT * FROM EMP_REX WHERE REGEXP_LIKE(PHONE,'^[0-9]{3}[-][0-9]{3}[-][0-9]{4}$');  --333-333-3333

SELECT * FROM EMP_REX WHERE REGEXP_LIKE(PHONE,'^[0-9]{10}$');


CREATE TABLE TEMP_REX (EMAIL VARCHAR2(30), CHECK(REGEXP_LIKE(EMAIL,'*@*.COM$'))
                        );
                        
                        SELECT * FROM TEMP_REX;
                        
INSERT INTO TEMP_REX VALUES ('SAMEER.AHMAD@GMAIL.COM');                        
INSERT INTO TEMP_REX VALUES ('LIVE@CO.IN');  


----------------REGEXP_SUBSTR---------

SELECT REPLACE(REGEXP_SUBSTR('SAMEER.AHMAD@GMAIL.COM','[^@]+'),'.',' ') FROM DUAL;

SELECT REGEXP_SUBSTR(EMAIL,'[^@]+') FROM EMP_REX;

SELECT REGEXP_SUBSTR('123$@/8957/XYZ','[^[:digit:]]+$') FROM DUAL;

--SELECT REGEXP_SUBSTR('123$@/8957/XYZ/\/\','[^[:alnum:]]+$') FROM DUAL;


----------------REGEXP_INSTR---------

--(SEARCH_STRING, PATTERN[,POSITION [,OCCURENCE [,RETURN_OPTION [,MATCH_OPTION]]]]

SELECT REGEXP_INSTR('Oracle','a|e|i|o|u',1,3,0,'i') FROM DUAL;


SELECT REGEXP_INSTR('DATABASE','a|e|i|o|u',1,4,0,'i') FROM DUAL; --STARTING FROM 1 POSITION OCCURENCE OF ANY OF THE PAATTERN CHARACTER 4TH TIME
                                                                    ----WHICH VUD BE 'E' AND ITS POSITION IS 8 
                                                                    
                                                                    
----------------------REGEXP_REPLACE---------  

--(SEARCH_STRING, PATTERN[,REPKACE_STRING [,POSITION [,OCCURENCE [,MATCH_OPTION]]]]

SELECT REGEXP_REPLACE('I  AM  A   BOY','[[:blank:]]{2,5}',' ') FROM DUAL; 
/


--8700132537     (870) 013-2537
--SELECT REGEXP_REPLACE('8700132537','([[:digit:]]{3})([[:digit:]]{3})([[:digit:]]{3})','(\1) \2-\3') FROM DUAL;

SELECT REGEXP_REPLACE('8700132537','(\d{3})(\d{3})(\d{3})','(\1) \2-\3') FROM DUAL;
/

-----------------------------REG_COUNT-----------------------

SELECT REGEXP_COUNT('ORACLE DATABASE','A') FROM DUAL;

----------PIVOT
SELECT * FROM EMP;
SELECT * FROM (
SELECT DEPTNO, SAL FROM EMP)
PIVOT(SUM(SAL) FOR DEPTNO IN (40 AS DEPT_40,50 AS DEPTNO_50,60 AS DEPTNO_60)
);

--PIVOT (AGGREGATE_FUNC FOR COL_NAME (Y AXIS)

SELECT * FROM 
( 
SELECT DEPTNO,JOB_ID, SAL FROM EMP)
PIVOT (COUNT(DEPTNO) FOR JOB_ID IN ('IT_PROG','FI_ACCOUNT')
);
--

-------------------------------------------CO-PILOT------------------------------------


Regex in Oracle and its different examples
Regular expressions (Regex) in Oracle are powerful tools for pattern matching and text processing. Oracle provides several functions to work with Regex, such as:

REGEXP_LIKE: Similar to the LIKE operator but allows for complex pattern matching.
------------
Example: Find employees whose names start with A and end with R:

		SELECT * FROM employees WHERE REGEXP_LIKE(name, '^A.*R$');
		
REGEXP_INSTR: Returns the position of a pattern in a string.

Example: Find the position of the first digit in a string:

SELECT REGEXP_INSTR('abc123', '\d') FROM dual;


REGEXP_SUBSTR: Extracts a substring that matches a pattern.

Example: Extract the first word from a sentence:

sql
SELECT REGEXP_SUBSTR('Hello World', '\w+') FROM dual;
REGEXP_REPLACE: Replaces parts of a string that match a pattern.

Example: Replace all digits with asterisks:

sql
SELECT REGEXP_REPLACE('abc123', '\d', '*') FROM dual;
REGEXP_COUNT: Counts occurrences of a pattern in a string.

Example: Count the number of vowels in a string:

sql
SELECT REGEXP_COUNT('Oracle Regex', '[aeiou]', 1, 'i') FROM dual;
These functions are versatile and can be used for tasks like data validation, formatting, and searching. You can explore more details here or here. Let me know if youd like further examples or explanations!

Can you provide more advanced Regex examples in Oracle?
Certainly! Here are some advanced examples of using Regex in Oracle:

Extracting Email Domains: Extract the domain part of email addresses:

sql
SELECT REGEXP_SUBSTR(email, '@[^.]+') AS domain FROM users;
Validating Phone Numbers: Check if a phone number matches the format (XXX) XXX-XXXX:

sql
SELECT phone_number FROM contacts WHERE REGEXP_LIKE(phone_number, '\(\d{3}\) \d{3}-\d{4}');
Finding Duplicate Words: Identify rows with duplicate consecutive words:

sql
SELECT text_column FROM documents WHERE REGEXP_LIKE(text_column, '\b(\w+)\s+\1\b');
Extracting Specific Patterns: Extract the first occurrence of a date in the format YYYY-MM-DD:

sql
SELECT REGEXP_SUBSTR(text_column, '\d{4}-\d{2}-\d{2}') AS extracted_date FROM logs;
Replacing Multiple Spaces: Replace multiple spaces with a single space:

sql
SELECT REGEXP_REPLACE(text_column, '\s+', ' ') AS cleaned_text FROM paragraphs;
Counting Specific Patterns: Count the number of occurrences of a specific word in a text:

sql
SELECT REGEXP_COUNT(text_column, '\bword\b') AS word_count FROM articles;
These examples showcase the versatility of Regex in Oracle for text processing, validation, and pattern matching. You can explore more advanced use cases here or here. Let me know if youd like further assistance!

Can you explain how regex functions in Oracle?
Sure! In Oracle, regular expressions (Regex) are used for advanced string pattern matching and manipulation within SQL and PL/SQL. Oracle supports Regex through a set of built-in functions that allow you to search, extract, replace, and validate text patterns efficiently.

How Regex Functions Work in Oracle:
Regex Patterns:

Patterns are combinations of characters that represent specific text structures. For example, \d matches any digit, \w matches any word character, ^ indicates the start of a string, and $ indicates the end.

Supported Regex Functions: Oracle provides the following main Regex functions:

REGEXP_LIKE: Tests if a string matches a pattern (similar to LIKE, but more powerful).

REGEXP_INSTR: Finds the position of a pattern within a string.

REGEXP_SUBSTR: Extracts the substring that matches a pattern.

REGEXP_REPLACE: Replaces parts of a string that match a pattern.

REGEXP_COUNT: Counts occurrences of a pattern in a string.

Syntax: All Regex functions use the following general syntax:

sql
FUNCTION_NAME(string, pattern [, position [, occurrence [, match_option]]])
string: The input text or column to search.

pattern: The Regex pattern to match.

position (optional): The starting position for the search (default is 1).

occurrence (optional): Which match to return (e.g., the 1st, 2nd, etc.).

match_option (optional): Modifiers like 'i' for case-insensitive matching.

Regex Modifiers:

i: Case-insensitive matching.

c: Case-sensitive matching.

n: Allows the . to match newline characters.

Example: Here’s how each function works with an example:

REGEXP_LIKE: Check if names start with A:

				SELECT * FROM employees WHERE REGEXP_LIKE(name, '^A');

REGEXP_INSTR: Find the position of the first vowel in a name:

				SELECT REGEXP_INSTR(name, '[aeiou]') AS vowel_position FROM employees;

REGEXP_SUBSTR: Extract the first word in a sentence:

	FUNCTION_NAME(string, pattern [, position [, occurrence [, match_option]]])
	
				SELECT REGEXP_SUBSTR('Hello World, World, Hello, Hello World', '\w+',1,2) AS first_word FROM dual;

REGEXP_REPLACE: Replace digits with asterisks:

				SELECT REGEXP_REPLACE('abc123', '\d', '*') AS obfuscated_text FROM dual;

REGEXP_COUNT: Count vowels in a name:

				SELECT REGEXP_COUNT(name, '[aeiou]') AS vowel_count FROM employees;

WHY USE REGEX?
				Regex in Oracle is incredibly versatile for:
				Validating user input (like email or phone formats).
				Searching for patterns within text columns.
				Cleaning and transforming data.
				Advanced reporting and analytics.

Would you like more details about any specific function or pattern? Let me know!

Can you explain REGEXP_SUBSTR with more examples?
Certainly! The REGEXP_SUBSTR function in Oracle is used to extract a substring from a string based on a regular expression pattern. It is highly versatile and can handle complex text processing tasks. Here are some detailed examples:

Examples of REGEXP_SUBSTR:
Extracting the First Word: Extract the first word from a sentence:

SELECT REGEXP_SUBSTR('Hello World from Oracle', '\w+', 1, 1) AS first_word FROM dual;
Output: Hello

Extracting Email Domains: Extract the domain part of email addresses:

SELECT REGEXP_SUBSTR('user@example.com', '@[^.]+', 1, 1) AS domain FROM dual;
Output: @example

Extracting Dates: Extract the first occurrence of a date in the format YYYY-MM-DD:

sql
SELECT REGEXP_SUBSTR('The event is on 2025-04-21.', '\d{4}-\d{2}-\d{2}', 1, 1) AS extracted_date FROM dual;
Output: 2025-04-21

Extracting Specific Occurrences: Extract the second word in a sentence:

sql
SELECT REGEXP_SUBSTR('Hello World from Oracle', '\w+', 1, 2) AS second_word FROM dual;
Output: World

Extracting Phone Numbers: Extract phone numbers in the format (XXX) XXX-XXXX:

sql
SELECT REGEXP_SUBSTR('Contact: (123) 456-7890', '\(\d{3}\) \d{3}-\d{4}', 1, 1) AS phone_number FROM dual;
Output: (123) 456-7890

Extracting URLs: Extract the first URL from a string:

sql
SELECT REGEXP_SUBSTR('Visit https://example.com for details.', 'https?://\S+', 1, 1) AS url FROM dual;
Output: https://example.com

Key Parameters:
Source String: The input text or column to search.

Pattern: The regular expression defining the substring to extract.

Position: The starting position for the search (default is 1).

Occurrence: Specifies which match to return (e.g., the 1st, 2nd, etc.).

Match Parameter: Modifiers like 'i' for case-insensitive matching.

These examples demonstrate the flexibility of REGEXP_SUBSTR for extracting and processing text. You can explore more details here or here. Let me know if youd like further clarification!

What are common use cases for REGEXP_SUBSTR in real applications?
REGEXP_SUBSTR is incredibly useful in real-world applications where extracting specific patterns or substrings is needed. Here are some common use cases:

Data Validation and Cleaning:

Email Processing: Extracting the domain part of email addresses from a dataset for validation or categorization.

sql
SELECT REGEXP_SUBSTR(email, '@[^.]+') AS domain FROM users;
Phone Number Standardization: Extracting valid phone numbers in a specific format from unstructured text data.

sql
SELECT REGEXP_SUBSTR(phone_number, '\(\d{3}\) \d{3}-\d{4}') AS formatted_number FROM contacts;
Extracting Information from Logs:

Error Codes: Extracting error codes from application logs for debugging or analytics.

sql
SELECT REGEXP_SUBSTR(log_text, 'ERROR-\d+', 1, 1) AS error_code FROM log_table;
IP Address Extraction: Extracting IP addresses for network analysis or security monitoring.

sql
SELECT REGEXP_SUBSTR(log_entry, '\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b') AS ip_address FROM server_logs;
Analyzing Customer Reviews:

Keyword Extraction: Identifying specific words or phrases (e.g., excellent, poor) in customer feedback to measure sentiment.

sql
SELECT REGEXP_SUBSTR(review_text, '\b(excellent|poor)\b', 1, 1) AS sentiment_keyword FROM reviews;
Financial Transactions:

Invoice Number Extraction: Extracting invoice numbers from transaction descriptions for reconciliation.

sql
SELECT REGEXP_SUBSTR(description, 'INV-\d+', 1, 1) AS invoice_number FROM transactions;
Web Data Scraping:

URL Extraction: Extracting website URLs from textual data for crawling or analytics.

sql
SELECT REGEXP_SUBSTR(web_text, 'https?://[^ ]+', 1, 1) AS url FROM web_pages;
Date Extraction: Extracting dates from web content for further processing.

sql
SELECT REGEXP_SUBSTR(content, '\d{4}-\d{2}-\d{2}', 1, 1) AS extracted_date FROM pages;
Security and Fraud Detection:

Sensitive Data Identification: Detecting patterns like credit card numbers or sensitive data in unstructured text for security audits.

sql
SELECT REGEXP_SUBSTR(data, '\b\d{4}-\d{4}-\d{4}-\d{4}\b') AS credit_card FROM data_table;
Text Data Analysis:

Extracting Tags: Extracting hashtags or keywords from social media posts for trends analysis.

sql
SELECT REGEXP_SUBSTR(post_content, '#\w+', 1, 1) AS hashtag FROM social_posts;
Word Count: Extracting and analyzing words in textual data for linguistic studies.

sql
SELECT REGEXP_SUBSTR(text, '\b\w+\b', 1, 1) AS first_word FROM texts;
These examples highlight how REGEXP_SUBSTR can streamline data extraction, validation, and analysis in diverse domains. Let me know if you d like tailored examples for a specific scenario!

Some more advance exmaples of Regex_substr in oracle
Here are some advanced examples of using REGEXP_SUBSTR in Oracle for complex scenarios:

Extracting Subdomains from URLs: Extract the subdomain from a URL:

sql
SELECT REGEXP_SUBSTR('https://subdomain.example.com', 'https?://([^/]+)', 1, 1, NULL, 1) AS subdomain FROM dual;
Output: subdomain.example.com

Extracting Nested Parentheses Content: Extract the innermost content within parentheses:

sql
SELECT REGEXP_SUBSTR('Outer (Inner (Innermost))', '\([^()]*\)', 1, 1) AS innermost_content FROM dual;
Output: (Innermost)

Extracting Specific Words Based on Length: Extract words with exactly 5 characters:

sql
SELECT REGEXP_SUBSTR('Oracle Regex Examples', '\b\w{5}\b', 1, 1) AS five_char_word FROM dual;
Output: Regex

Extracting Hexadecimal Values: Extract hexadecimal numbers from a string:

sql
SELECT REGEXP_SUBSTR('Color codes: #FF5733, #C70039', '#[A-Fa-f0-9]+', 1, 1) AS hex_value FROM dual;
Output: #FF5733

Extracting File Extensions: Extract the file extension from a filename:

sql
SELECT REGEXP_SUBSTR('document.pdf', '\.[a-zA-Z0-9]+$', 1, 1) AS file_extension FROM dual;
Output: .pdf

Extracting Multiple Matches: Extract all occurrences of numbers from a string:

sql
SELECT REGEXP_SUBSTR('123, 456, 789', '\d+', 1, LEVEL) AS number
FROM dual
CONNECT BY LEVEL <= REGEXP_COUNT('123, 456, 789', '\d+');
Output: 123, 456, 789 (one per row)

These examples demonstrate how REGEXP_SUBSTR can handle intricate text patterns and extract meaningful data. You can explore more details here or here. Let me know if youd like further assistance!



-----------------------------------PRACTICE------------------------



SELECT * FROM EMP;

UPDATE EMP SET EMAIL=EMAIL||'@GMAIL.COM' WHERE SALARY >=8000 AND SALARY <10000;

UPDATE EMP SET EMAIL=EMAIL||'@REDIFFMAIL.COM' WHERE SALARY >=10000;

SELECT REGEXP_SUBSTR(FIRST_NAME,'^S.%r$',1) FROM EMP;

SELECT REGEXP_SUBSTR('Hello Cat World, World, Hello, Hello World', '\w+',1,2) AS Second_word FROM dual;

SELECT UPPER(FIRST_NAME||' '||LAST_NAME),REPLACE(REGEXP_SUBSTR(EMAIL,'@.*COM$'),'@','') FROM EMP;

SELECT REGEXP_SUBSTR(EMAIL, '@[^.]+', 1, 1) AS domain FROM EMP;

