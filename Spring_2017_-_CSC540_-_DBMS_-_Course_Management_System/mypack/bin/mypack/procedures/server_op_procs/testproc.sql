-- Procedure to display Student information
set serveroutput on;

CREATE OR REPLACE PROCEDURE DisplayStudents(
    studentID IN NUMBER,
    --display_student OUT SYS_REFCURSOR
    dept_ID OUT Students.deptID%type;
    overall_GPA OUT Students.overallGPA%type;
    residency_Level OUT Students.residencyLevel%type;
    participation_Level OUT Students.participationLevel%type;
    year_Enrolled OUT Students.yearEnrolled%type;
)

IS

BEGIN
    --OPEN display_student FOR
    SELECT studentID, deptID, overallGPA, residencyLevel, participationLevel, yearEnrolled INTO student_ID, dept_ID, overall_GPA, residency_Level, participation_Level, year_Enrolled
    FROM Students
    WHERE studentID=200109815
    ;
 
Commit;
END;
/

DECLARE
    student_ID NUMBER(9);
    dept_ID Students.deptID%type;
    overall_GPA Students.overallGPA%type;
    residency_Level Students.residencyLevel%type;
    participation_Level Students.participationLevel%type;
    year_Enrolled Students.yearEnrolled%type;

BEGIN
	DisplayStudents(200109815, dept_ID, overall_GPA, residency_Level, participation_Level, year_Enrolled);

    --DBMS_OUTPUT.PUT_LINE('Student ID: ' || student_ID);
    DBMS_OUTPUT.PUT_LINE('Department: ' || dept_ID);
    DBMS_OUTPUT.PUT_LINE('GPA: ' || overall_GPA);
    DBMS_OUTPUT.PUT_LINE('Residency: ' || residency_Level);
    DBMS_OUTPUT.PUT_LINE('participationLevel: ' || participation_Level);
    DBMS_OUTPUT.PUT_LINE('yearEnrolled: ' || year_Enrolled);
END;/
--variable curs refcursor;

--EXEC DisplayStudents(200109814);

show errors;
