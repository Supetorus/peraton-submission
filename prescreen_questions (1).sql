

-- Identify any problems or potential problems with the following code.

DECLARE
    l_description VARCHAR2(30);
BEGIN
    SELECT description
      INTO l_description
      FROM some_table
     WHERE some_table_id = 4;
    -- Do something with the description
EXCEPTION WHEN OTHER THEN
    DBMS_OUTPUT.print_line(SQLERRM);
END;

"
1. OTHER -> OTHERS.
OTHERS is a keyword which will contain any exceptions not caught by previous WHEN clauses.

2. NO_DATA_FOUND exception not handled.
If some_table doesn't have a some_table_id=4 then NO_DATA_FOUND will be raised, which
is a common and expectable error that should be handled explicitly, not caught by the
catchall handler.

3. print_line -> put_line
print_line is incorrect, it should be replaced with put_line.

4. If some_table_id is not unique, it's possible to get multiple records with some_table_id=4,
so TOO_MANY_ROWS exception should be handled explicitly. (some_table_id is probably primary key
so this wouldn't be necessary)

5. Hardcoded value some_table_id=4
This code is inflexible and could be replaced with a parameter/variable.

6. Handle NULL value
It's unknown what is done with l_description, but if the description column is nullable
then null values should be handled.
"

-- user         group        user_group_xref    role         group_role_xref    secret
-- -----------  -----------  -----------------  -----------  -----------------  -----------
-- user_id      group_id     user_id            role_id      group_id           secret_id
-- username     name         group_id           name         role_id            role_id
--                                                                              description

-- Given the above tables, and the instructions, "Select all records from secret relating to 
-- username 'jdoe'.", identify any problems with the following statement (even if subjective).
user -> group -> role -> secret
SELECT *
  FROM secret s
 WHERE username = 'jdoe'
  LEFT JOIN group_role_xref grx ON
  s.role_id = grx.role_id
  LEFT JOIN user_group_xref ugx ON
  grx.group_id = ugx.group_id
  LEFT JOIN user u ON
  u.user_id = ugx.user_id;

"
1. SELECT s.*
The instructions only ask for the records from secret, while this query will currently
get all columns that are joined.

2. WHERE clause should be after all joins.

3. LEFT JOIN may be inefficient. Using left joins will get all rows
from left table, but we only care about the ones that have a match. The where clause
currently filters rows that don't have matches, but since there are extra rows
in the intermediate steps it may be inefficient. Instead regular inner joins should be used.

4. username in where clause may not be clear, use u.username.

5. Use DISTINCT to filter out duplicate rows. If user is tied to a group
that is tied to multiple roles that have access to a secret then that secret
will show up in the list multiple times. DISTINCT will solve this problem.

4. Use better aliases. I'm not a fan of abbreviations. They might save you a few keystrokes
but your brain reads 's' just as quickly as 'secret', but anyone can comprehend what 'secret'
means instantly, while 's' will take a few moments every time you read the script to remember
what it is. The time to comprehend is compounded for more complex abbrevations like 'ugx' and beyond.
"

-- Explain the difference between a package specification and a package body.
"The package specification is the public interface, the package body is the implementation details"

-- Can you have global variables in the package specification?  ...package body?  ...if both, what's the difference?
"You can have global variables in the spec, they are visible and accessible to anyone who uses the package.
You can also have global variables in the body, where they act like private variables."

-- How do you make a type-safe parameter/variable in PL/SQL that references a table column? ...row?
"Using %TYPE to match a column's data type"
v_employee_name employees.employee_name%TYPE;

"Using %ROWTYPE to match an entire row"
v_employee_record employees%ROWTYPE;

-- How do you build and execute a dynamic query in PL/SQL?
DECLARE
  v_table_name VARCHAR2(30) := 'EMPLOYEES';
  v_column_name VARCHAR2(30) := 'SALARY';
  v_condition VARCHAR2(100) := 'DEPARTMENT_ID = 50';
  v_sql VARCHAR2(1000);
  v_avg_salary NUMBER;
BEGIN
  -- Build the dynamic query
  v_sql := 'SELECT AVG(' || v_column_name || ') 
            FROM ' || v_table_name || 
            ' WHERE ' || v_condition;
  
  -- Execute the dynamic query and store result
  EXECUTE IMMEDIATE v_sql INTO v_avg_salary;
  
  -- Display the result
  DBMS_OUTPUT.PUT_LINE('Average salary: ' || v_avg_salary);
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;

    -- ...how do you use parameters with it?
    DECLARE
      v_sql VARCHAR2(4000);
      v_dept_id NUMBER := 10;
    BEGIN
      v_sql := 'SELECT employee_name FROM employees WHERE department_id = :dept_id';
      EXECUTE IMMEDIATE v_sql USING v_dept_id;
    END;

    -- ...how to you handle returning values to variables with it?
    DECLARE
      v_sql VARCHAR2(4000);
      v_dept_id NUMBER := 10;
      v_emp_name VARCHAR2(100);
    BEGIN
      v_sql := 'SELECT employee_name INTO :emp_name FROM employees WHERE department_id = :dept_id AND ROWNUM = 1';
      EXECUTE IMMEDIATE v_sql USING OUT v_emp_name, v_dept_id;
      DBMS_OUTPUT.PUT_LINE('Employee name: ' || v_emp_name);
    END;

-- When executing a loop with DML statements in PL/SQL, should you commit each iteration or at the end?  Why? 
"
Generally, committing at the end of the loop is best for transaction integrity. This ensures that either all changes are applied or none are.
Committing during the loop is acceptable either when the number of records to process is very large and you want to avoid large rollback segments,
or if processing each record independently would be entirely acceptable.
"

    -- Are there any other options?
    "
    - Commit at the end of the loop
    - Commit after each iteration
    - Commit after a batch of iterations
    "

-- Can you execute DDL statements in a stored procedure?
"Yes, you can execute DDL statements in stored procedures using EXECUTE IMMEDIATE."
    -- If so, what is a use-case for doing so?
    "
    Automated schema management (creating temporary tables)
    Dynamic partitioning (adding/dropping partitions based on date)
    Database maintenance operations
    Application installation or upgrade scripts
    "

-- How do you capture the error code if an exception is thrown in PL/SQL?
"
Similar to capturing the error message with SQLERRM
you can capture the error code with SQLCODE
"