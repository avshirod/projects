-- View all students enrolled in the system
-- EXEC ViewStudents;

SET SERVEROUTPUT ON;
SET LINESIZE 100 PAGESIZE 50;

CREATE OR REPLACE PROCEDURE proc_ViewStudents
IS
BEGIN

	DBMS_OUTPUT.PUT_LINE('-------------- All Students enrolled in the system -----------------');
	DBMS_OUTPUT.PUT_LINE('P - Participation Level' || CHR(9) || ' (1 = Undergrad, 2 = Grad)');
	DBMS_OUTPUT.PUT_LINE('R - Residency Level' || CHR(9) ||' (1 = In State, 2 = Out of State, 3 = International)');
	DBMS_OUTPUT.PUT_LINE(chr(10));
	DBMS_OUTPUT.PUT_LINE(rpad('Unity ID', 10) || ' ' || rpad('First Name', 10) || ' ' || rpad('Last Name', 10) || ' ' || 'GPA    P R');
	DBMS_OUTPUT.PUT_LINE('---------------------------------------------');

	FOR cursor0 IN (
		SELECT u.unityID, u.fname, u.lname, s.overallGPA, s.participationLevel, s.residencyLevel
		FROM Students s, UnityUsers u
		where s.unityID=u.unityID
	)
	LOOP
		DBMS_OUTPUT.PUT_LINE(rpad(cursor0.unityID, 10) || ' ' || rpad(cursor0.fname, 10) || ' ' || rpad(cursor0.lname, 10) ||
							' ' || rpad(cursor0.overallGPA, 6) || ' ' || cursor0.participationLevel || ' ' || cursor0.residencyLevel);
	END LOOP;
END;
/