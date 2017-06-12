-- View unityIDs of students wailisted in a CourseOffering
-- EXEC ViewWaitlistedStudents(courseOfferingID);

SET SERVEROUTPUT ON;
SET LINESIZE 100 PAGESIZE 50;

CREATE OR REPLACE PROCEDURE proc_ViewWaitlistedStudents(
	courseoffering_id IN CourseOffering.courseOfferingID%TYPE
)

IS

BEGIN
	FOR cursor0 IN (
		SELECT co.courseID, co.deptID, c.title
		FROM CourseOffering co, Course c
		WHERE co.courseOfferingID = courseoffering_id
		AND c.courseID = co.courseID
		AND c.deptID = co.deptID
	)
	LOOP
		DBMS_OUTPUT.PUT_LINE('Students waitlisted in Course - ' || cursor0.deptID 
							|| ' ' || cursor0.courseID || ' ' || cursor0.title);
	END LOOP;

	FOR cursor1 IN (
		SELECT w.unityID, w.waitlistPosition
		FROM Waitlist w
		where w.courseOfferingID = courseoffering_id
	)
	LOOP
		DBMS_OUTPUT.PUT_LINE(cursor1.waitlistPosition || ' ' || rpad(cursor1.unityID, 10));
	END LOOP;
END;
/