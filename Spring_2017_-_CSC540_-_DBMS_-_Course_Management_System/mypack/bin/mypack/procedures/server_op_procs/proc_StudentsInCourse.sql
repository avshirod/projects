-- Prints unityIDs of Students registered in a CourseOffering 
-- EXEC StudentsRegisteredInCourse(3);

SET SERVEROUTPUT ON;
SET LINESIZE 100 PAGESIZE 50;

CREATE OR REPLACE PROCEDURE proc_StudentsInCourse(
	courseoffering_id IN CourseOffering.courseOfferingID%TYPE
)
IS
BEGIN
	DBMS_OUTPUT.PUT_LINE(CHR(9));

	FOR cursor0 IN (
		SELECT co.courseID, co.deptID, s.season, s.year, c.title
		FROM CourseOffering co, Semester s, course c
		WHERE co.courseOfferingID = courseoffering_id
		AND co.semesterID = s.semesterID
		AND c.courseID = co.courseID AND c.deptID = co.deptID
	)
	LOOP
		DBMS_OUTPUT.PUT_LINE('Students enrolled in Course - ' || cursor0.courseID || ' ' || cursor0.deptID ||
							' (' || cursor0.season || ' ' || cursor0.year || ') - ' || cursor0.title);
	END LOOP;

	FOR cursor1 IN (
		SELECT t.unityID
		FROM Transcript t
		WHERE t.courseOfferingID = courseoffering_id
	)
	LOOP
		DBMS_OUTPUT.PUT_LINE(cursor1.unityID);
	END LOOP;

END;
/