
Oracle REGEXP - Complete Guide with Examples
1. Basic REGEXP Functions
REGEXP_LIKE - Pattern Matching (WHERE clause)
sql
-- Check if string matches pattern
SELECT * FROM employees 
WHERE REGEXP_LIKE(first_name, ^J);

-- Equivalent to: WHERE first_name LIKE J%
REGEXP_SUBSTR - Extract substring
sql
-- Extract first sequence of digits
SELECT REGEXP_SUBSTR(Order #12345-AB, \d+) 
FROM dual;  -- Returns: 12345
REGEXP_REPLACE - Search and replace
sql
-- Remove all non-digits
SELECT REGEXP_REPLACE(Phone: (123) 456-7890, [^0-9], ) 
FROM dual;  -- Returns: 1234567890
REGEXP_INSTR - Find position
sql
-- Find position of first digit
SELECT REGEXP_INSTR(ABC123XYZ, \d) 
FROM dual;  -- Returns: 4
REGEXP_COUNT - Count occurrences
sql
-- Count vowels in string
SELECT REGEXP_COUNT(Hello World, [aeiou], 1, i) 
FROM dual;  -- Returns: 3
2. Core Parameters (Available in Most Functions)
Parameters Pattern:
sql
REGEXP_FUNCTION(source_string, pattern 
               [, position 
               [, occurrence 
               [, match_parameter 
               [, subexpression]]]])
Parameter Details:
1. source_string - The text to search
sql
SELECT REGEXP_SUBSTR(Email: john@example.com, \S+@\S+\.\S+) 
FROM dual;  -- Returns: john@example.com
2. pattern - Regular expression pattern
sql
-- Common patterns:
^A        -- Starts with A
Z$        -- Ends with Z
.         -- Any single character
A|B       -- A or B
[ABC]     -- A, B, or C
[A-Z]     -- Any uppercase letter
[0-9]     -- Any digit
\d        -- Digit (same as [0-9])
\D        -- Non-digit
\w        -- Word character [A-Za-z0-9_]
\W        -- Non-word character
\s        -- Whitespace
\S        -- Non-whitespace
3. position (default: 1) - Where to start search
sql
-- Start from position 3
SELECT REGEXP_SUBSTR(AB12CD34, \d+, 3) 
FROM dual;  -- Returns: 34 (not 12)

-- Negative position: count from end
SELECT REGEXP_SUBSTR(AB12CD34, \d+, -6) 
FROM dual;  -- Returns: 12
4. occurrence (default: 1) - Which match to return
sql
-- Get second number
SELECT REGEXP_SUBSTR(12 apples, 34 oranges, 56 bananas, \d+, 1, 2) 
FROM dual;  -- Returns: 34

-- Get last occurrence
SELECT REGEXP_SUBSTR(a1 b2 c3 d4, \d, 1, 
       REGEXP_COUNT(a1 b2 c3 d4, \d)) 
FROM dual;  -- Returns: 4
5. match_parameter - Single-letter flags
sql
-- Multiple flags can be combined
i  -- Case-insensitive (default: case-sensitive)
c  -- Case-sensitive
n  -- Period(.) matches newline
m  -- Multiline mode (^/$ match start/end of lines)
x  -- Ignore whitespace in pattern
sql
-- Case-insensitive search
SELECT REGEXP_SUBSTR(Hello WORLD, world, 1, 1, i) 
FROM dual;  -- Returns: WORLD

-- Multiline example
SELECT REGEXP_SUBSTR(Line1 || CHR(10) || Line2, ^Line, 1, 2, m) 
FROM dual;  -- Returns: Line2
6. subexpression (REGEXP_SUBSTR only) - Which group to return
sql
-- Extract area code from phone number
SELECT REGEXP_SUBSTR(Phone: (123) 456-7890, 
                     \((\d{3})\) (\d{3})-(\d{4}), 
                     1, 1, NULL, 1) 
FROM dual;  -- Returns: 123 (first group)

SELECT REGEXP_SUBSTR(Phone: (123) 456-7890, 
                     \((\d{3})\) (\d{3})-(\d{4}), 
                     1, 1, NULL, 2) 
FROM dual;  -- Returns: 456 (second group)
3. Complete Examples by Function
REGEXP_LIKE - Filtering Rows
sql
-- Emails ending with .com or .org
SELECT email FROM users 
WHERE REGEXP_LIKE(email, \.(com|org)$);

-- Valid phone numbers
SELECT phone FROM contacts 
WHERE REGEXP_LIKE(phone, ^\(\d{3}\) \d{3}-\d{4}$);

-- Contains at least 2 digits
SELECT description FROM products 
WHERE REGEXP_LIKE(description, \d.*\d);

-- US Zip codes (5 digits or 5+4)
SELECT zip FROM addresses 
WHERE REGEXP_LIKE(zip, ^\d{5}(-\d{4})?$);
REGEXP_SUBSTR - Extraction
sql
-- Get domain from email
SELECT email,
       REGEXP_SUBSTR(email, @([^@]+)$, 1, 1, NULL, 1) AS domain
FROM users;

-- Extract all numbers from text (with recursion)
WITH sample AS (
    SELECT Order 123 for item 456, total $789 AS text FROM dual
)
SELECT 
    REGEXP_SUBSTR(text, \d+, 1, 1) AS num1,  -- 123
    REGEXP_SUBSTR(text, \d+, 1, 2) AS num2,  -- 456
    REGEXP_SUBSTR(text, \d+, 1, 3) AS num3   -- 789
FROM sample;

-- Get text between parentheses
SELECT REGEXP_SUBSTR(Hello (World) Test, \((.*?)\), 1, 1, NULL, 1)
FROM dual;  -- Returns: World
REGEXP_REPLACE - Transformation
sql
-- Format phone number
SELECT REGEXP_REPLACE(1234567890, 
                     (\d{3})(\d{3})(\d{4}), 
                     (\1) \2-\3) 
FROM dual;  -- Returns: (123) 456-7890

-- Remove extra spaces
SELECT REGEXP_REPLACE(Hello   World   !!, \s+,  ) 
FROM dual;  -- Returns: Hello World !!

-- Mask credit card (show last 4 digits)
SELECT REGEXP_REPLACE(4111-1111-1111-1111, 
                     \d{4}-\d{4}-\d{4}-, 
                     ****-****-****-) 
FROM dual;  -- Returns: ****-****-****-1111

-- Convert to sentence case
SELECT REGEXP_REPLACE(hello world. how are you?, 
                     ([.!?]\s*|^)(\w), 
                     \1\U\2) 
FROM dual;  -- Returns: Hello world. How are you?
REGEXP_INSTR - Position Finding
sql
-- Find position of 3rd vowel
SELECT REGEXP_INSTR(Hello World, [aeiou], 1, 3, 0, i) 
FROM dual;  -- Returns: 8 (position of o in World)

-- Find position before domain in email
SELECT email,
       REGEXP_INSTR(email, @, 1, 1, 0) AS at_position
FROM users;

-- Check if pattern appears at least N times
SELECT 
    CASE WHEN REGEXP_INSTR(text, \d, 1, 3) > 0 
         THEN Has 3+ digits 
         ELSE Less than 3 digits 
    END
FROM data;
REGEXP_COUNT - Pattern Counting
sql
-- Count words in string
SELECT REGEXP_COUNT(Hello beautiful world, \w+) 
FROM dual;  -- Returns: 3

-- Count vowels
SELECT name, 
       REGEXP_COUNT(name, [aeiou], 1, i) AS vowel_count
FROM employees;

-- Check if string has at least 2 uppercase letters
SELECT text,
       CASE WHEN REGEXP_COUNT(text, [A-Z]) >= 2 
            THEN Valid 
            ELSE Invalid 
       END
FROM documents;
4. Quantifiers - How Many Times?
sql
-- Quantifier examples:
A?       -- 0 or 1 A
A*       -- 0 or more As
A+       -- 1 or more As
A{3}     -- Exactly 3 As
A{3,}    -- 3 or more As
A{2,4}   -- 2 to 4 As

-- Examples:
SELECT REGEXP_SUBSTR(AAAABBB, A{2,4}) FROM dual;  -- AAAA
SELECT REGEXP_SUBSTR(AB123CD, \d{3,}) FROM dual; -- 123
5. Groups and Backreferences
sql
-- Swap first and last name
SELECT REGEXP_REPLACE(John Smith, 
                     ^(\w+)\s+(\w+)$, 
                     \2, \1) 
FROM dual;  -- Returns: Smith, John

-- Find repeated words
SELECT text
FROM documents
WHERE REGEXP_LIKE(text, \b(\w+)\s+\1\b, i);

-- Validate date format and rearrange
SELECT REGEXP_REPLACE(31-12-2023, 
                     ^(\d{2})-(\d{2})-(\d{4})$, 
                     \3-\2-\1) 
FROM dual;  -- Returns: 2023-12-31
6. Common Real-World Patterns
Email Validation
sql
SELECT email,
       CASE 
         WHEN REGEXP_LIKE(email, ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$)
         THEN Valid
         ELSE Invalid
       END AS status
FROM users;
SSN Formatting
sql
-- Format as XXX-XX-XXXX
SELECT REGEXP_REPLACE(ssn, ^(\d{3})(\d{2})(\d{4})$, \1-\2-\3)
FROM employees;
URL Parsing
sql
SELECT url,
       REGEXP_SUBSTR(url, https?://([^/]+)) AS full_domain,
       REGEXP_SUBSTR(url, https?://([^/]+), 1, 1, NULL, 1) AS domain
FROM links;
Log File Analysis
sql
-- Apache log pattern
SELECT log_line,
       REGEXP_SUBSTR(log_line, ^(\S+)) AS ip_address,
       REGEXP_SUBSTR(log_line, \[([^\]]+)\]) AS timestamp,
       REGEXP_SUBSTR(log_line, (\w+)\s+([^]+)) AS request
FROM logs;
7. Performance Tips
sql
-- 1. Use simple LIKE when possible
-- Faster:
WHERE phone LIKE (123)%
-- Slower:
WHERE REGEXP_LIKE(phone, ^\(123\))

-- 2. Avoid leading wildcards in pattern
-- Slow:
WHERE REGEXP_LIKE(name, .*Smith)
-- Better:
WHERE name LIKE %Smith

-- 3. Use non-capturing groups (?:) when backreference not needed
-- Better performance:
SELECT REGEXP_SUBSTR(text, (?:\d{3})-(\d{4}), 1, 1, NULL, 1)

-- 4. Be specific with patterns
-- Vague:
WHERE REGEXP_LIKE(text, \d)
-- Specific:
WHERE REGEXP_LIKE(text, ^\d{10}$)
8. Common Mistakes
sql
-- WRONG: Forgetting to escape special characters
SELECT REGEXP_SUBSTR(Test (123), (123)) FROM dual;  -- Error!

-- CORRECT: Escape parentheses
SELECT REGEXP_SUBSTR(Test (123), \(123\)) FROM dual;  -- (123)

-- WRONG: Greedy vs lazy quantifiers
SELECT REGEXP_SUBSTR(<div>Hello</div><div>World</div>, 
                     <div>.*</div>) 
FROM dual;  -- Returns entire string (greedy)

-- CORRECT: Use lazy quantifier
SELECT REGEXP_SUBSTR(<div>Hello</div><div>World</div>, 
                     <div>.*?</div>) 
FROM dual;  -- Returns: <div>Hello</div>
9. Practice Exercises
sql
-- 1. Extract price from string
SELECT REGEXP_SUBSTR(Price: $123.45 USD, \$\d+(\.\d{2})?) 
FROM dual;  -- $123.45

-- 2. Validate strong password (8+ chars, upper, lower, digit, special)
SELECT password,
       CASE 
         WHEN REGEXP_LIKE(password, ^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[\W_]).{8,}$)
         THEN Strong
         ELSE Weak
       END
FROM users;

-- 3. Parse CSV values
WITH csv AS (SELECT John,Doe,30,New York AS data FROM dual)
SELECT 
    REGEXP_SUBSTR(data, [^,]+, 1, 1) AS first_name,
    REGEXP_SUBSTR(data, [^,]+, 1, 2) AS last_name,
    REGEXP_SUBSTR(data, [^,]+, 1, 3) AS age,
    REGEXP_SUBSTR(data, [^,]+, 1, 4) AS city
FROM csv;
Key Takeaways:
REGEXP_LIKE - Filter in WHERE (replaces LIKE for complex patterns)

REGEXP_SUBSTR - Extract parts of strings (most commonly used)

REGEXP_REPLACE - Find and replace with patterns

REGEXP_INSTR - Find positions (like INSTR but with regex)

REGEXP_COUNT - Count pattern occurrences

Always escape special characters: . * + ? [ ] ( ) { } ^ $ | \

Use i flag for case-insensitive searches

Quantifiers: ? (0/1), * (0+), + (1+), {n,m} (range)

Groups: () for capturing, (?:) for non-capturing

Start simple - use basic string functions when possible, regex when needed





SELECT * FROM EMP;

UPDATE EMP SET EMAIL=EMAIL||@GMAIL.COM WHERE SALARY >=8000 AND SALARY <10000;

UPDATE EMP SET EMAIL=EMAIL||@REDIFFMAIL.COM WHERE SALARY >=10000;

SELECT DISTINCT(REGEXP_SUBSTR(FIRST_NAME,^N.%y$)) FROM EMP;

SELECT REGEXP_SUBSTR(Hello Cat World, World, Hello, Hello World, \w+,1,2) AS Second_word FROM dual;

SELECT UPPER(FIRST_NAME|| ||LAST_NAME),REPLACE(REGEXP_SUBSTR(EMAIL,@.*COM$),@,) FROM EMP;

SELECT REGEXP_SUBSTR(EMAIL, @[^.]+, 1, 1) AS domain FROM EMP;

/*
ab* - A follewed by zero or more number of bs
ab+ - A followed by one or more number of bs
ab? - A followed by zero or one b
ab{n} - A followed by n times of b ex... abb if n=2
ab{m,n} - A followed by any count of b between m & n...ex ab{2,5}  -> a having b followed by count of b between 2 & 5
*/

SELECT * FROM (
SELECT FIRST_NAME, REGEXP_SUBSTR(FIRST_NAME,Ne*)RX FROM EMP) WHERE RX IS NOT NULL;
UPDATE EMP SET FIRST_NAME=Saaammmmmeeeeeeerr WHERE EMPLOYEE_ID=212;
SET SERVEROUTPUT ON;

SELECT * FROM (
SELECT FIRST_NAME, REGEXP_SUBSTR(FIRST_NAME,am{1,6})RX FROM EMP) WHERE RX IS NOT NULL;