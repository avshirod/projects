-- Clear Waitlist for a CourseOffering
-- EXEC proc_ClearWLCourseOff(courseOfferingID);

SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE proc_ClearWLCourseOff(
	courseoffering_id IN Waitlist.courseOfferingID%TYPE,
	message OUT VARCHAR2
)
IS
BEGIN
	DELETE FROM Waitlist
	WHERE courseOfferingID=courseoffering_id;
	message := 'Waitlist cleaned up';
	EXCEPTION 
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Some Exception occured. Try again.');
            DBMS_OUTPUT.PUT_LINE('Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200));
            message := 'Some Exception occured. Try again.' || CHR(10) || 'Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200);
        RETURN;
END;
/


-- Clear Waitlist for a Semester
-- EXEC proc_ClearWLSem(semesterID);

SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE proc_ClearWLSem(
	l_semesterID 	IN Semester.semesterID%TYPE,
	l_message		OUT VARCHAR2
)
IS
BEGIN
	FOR i in (
		SELECT 	courseOfferingID
		FROM 	CourseOffering
		WHERE 	CourseOffering.semesterID = l_semesterID
	)
	loop
		proc_ClearWLCourseOff(i.courseOfferingID, l_message);
	END loop;

	DBMS_OUTPUT.PUT_LINE('Waitlists cleared successfully.');
	l_message := 'Waitlists cleared successfully.';
	
	EXCEPTION 
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Some Exception occured. Try again.');
            DBMS_OUTPUT.PUT_LINE('Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200));
            l_message := 'Some Exception occured. Try again.' || CHR(10) || 'Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200);
        RETURN;
END;
/

SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE proc_ClearWLCurrSem(
	l_message OUT VARCHAR2
)
IS
	l_currentSemID NUMBER := currentSemID;
BEGIN
	proc_ClearWLSem(l_currentSemID, l_message);
	EXCEPTION 
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Some Exception occured. Try again.');
            DBMS_OUTPUT.PUT_LINE('Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200));
            l_message := 'Some Exception occured. Try again.' || CHR(10) || 'Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200);
        RETURN;
END;
/