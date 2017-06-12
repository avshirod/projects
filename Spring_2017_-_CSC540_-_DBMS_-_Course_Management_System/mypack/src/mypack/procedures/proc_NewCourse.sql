-- Register a new course
-- Course (courseID, deptID, title, maxCredits, minCredits, participationLevel)

SET SERVEROUTPUT ON;
SET AUTOCOMMIT OFF;

CREATE OR REPLACE PROCEDURE proc_NewCourse(
    l_courseID  IN Course.courseID%TYPE,
    l_deptID    IN Course.deptID%TYPE,
    l_title     IN Course.title%TYPE,
    l_maxCredits IN Course.maxCredits%TYPE,
    l_minCredits IN Course.minCredits%TYPE,
    l_participationLevel IN Course.participationLevel%TYPE,
    success     OUT VARCHAR2
)
IS
BEGIN
    
    INSERT INTO Course(courseID, deptID, title, maxCredits, minCredits, participationLevel)
    VALUES (l_courseID, l_deptID, l_title, l_maxCredits, l_minCredits, l_participationLevel);
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Course ' || l_deptID || ' ' || l_courseID || ' successfully added.');
    success := 'Course ' || l_deptID || ' ' || l_courseID || ' successfully added.';

    EXCEPTION 
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Some Exception occured. Try again.');
            DBMS_OUTPUT.PUT_LINE('Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200));
            success := 'Some Exception occured. Try again.' || CHR(10) || 'Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200);
        RETURN;
END;
/