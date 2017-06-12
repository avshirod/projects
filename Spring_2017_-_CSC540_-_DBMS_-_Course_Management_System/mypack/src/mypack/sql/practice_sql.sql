-- Execute a sql from command line in SQL by:
-- sqlplus user_name/password @sql_file;
-- e.g.: sqlplus avshirod@orcl/123456 table_creation;

SELECT table_name FROM user_tables;

-- CONSTRAINT constraint_name PRIMARY KEY (primary_key)
-- CONSTRAINT constraint_name FOREIGN KEY (foreign_key) REFERENCES table_name(foreign_key)

-- SET SERVEROUTPUT ON;
-- DBMS_OUTPUT.PUT_LINE('message');


-- Printing Hello World via a Procedure

CREATE or REPLACE PROCEDURE 
hello_world (msg IN VARCHAR2)
IS
    message VARCHAR2(30); -- := "Hello World!";
BEGIN
    message := msg || '!';
    DBMS_OUTPUT.PUT_LINE(message);
END hello_world;
/


-- Procedure to display Student information

CREATE or REPLACE PROCEDURE DisplayStudents(
    unity_id IN NUMBER,
    display_student OUT SYS_REFCURSOR
)
IS
    -- unity_id VARCHAR2(10);
    studentID NUMBER(10);
    fname VARCHAR2(25);
    lname VARCHAR2(25);
    deptID VARCHAR2(10);
    overallGPA NUMBER(4,3);

BEGIN
    OPEN display_student FOR
    SELECT studentID, fname, lname, deptID, overallGPA
    FROM Students
    WHERE studentID LIKE unity_id
    ;

    DBMS_OUTPUT.PUT_LINE('Student ID: ' || studentID);
    DBMS_OUTPUT.PUT_LINE('Name: ' || fname || lname);
    DBMS_OUTPUT.PUT_LINE('Department: ' || deptID);
    DBMS_OUTPUT.PUT_LINE('GPA: ' || overallGPA);

COMMIT;
END;

EXEC DisplayStudents(200109814);
/