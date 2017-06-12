-- List Special Permission Requests for ongoing Semester
-- EXEC ViewPermRequests;

SET SERVEROUTPUT ON;
SET LINESIZE 100 PAGESIZE 50;

CREATE OR REPLACE PROCEDURE proc_ViewPermRequests
IS
	l_semesterID Semester.semesterID%TYPE := constants.current_semID;
BEGIN
	DBMS_OUTPUT.PUT_LINE(CHR(10));

	FOR cursor0 IN (		
		SELECT s.season, s.year
		FROM Semester s
		WHERE s.semesterID = l_semesterID
	)
	LOOP
		DBMS_OUTPUT.PUT_LINE('Special Permission Requests for Semester - ' || cursor0.season || ' ' || cursor0.year);
	END LOOP;

	DBMS_OUTPUT.PUT_LINE(CHR(10));
	DBMS_OUTPUT.PUT_LINE(rpad('Unity ID', 10) || rpad(' Course', 13) || 'Status');
	DBMS_OUTPUT.PUT_LINE('-----------------------------------');

	FOR cursor1 IN (
		SELECT s.unityID, co.deptID, co.courseID, s.approvalStatus
		FROM SpecialPermissionRequests s, CourseOffering co
		WHERE s.courseOfferingID = co.courseOfferingID
		AND co.semesterID = l_semesterID
	)
	LOOP
		DBMS_OUTPUT.PUT_LINE(rpad(cursor1.unityID,10) || ' ' || rpad(cursor1.deptID,5) || ' ' || cursor1.courseID ||
							CHR(9) || cursor1.approvalStatus);
	END LOOP;

END;
/