-- Print out Courses in Semester identified by semesterID
-- EXEC courseOfferingsInSemester(semesterID);

SET SERVEROUTPUT ON;
SET LINESIZE 100 PAGESIZE 50;

CREATE OR REPLACE PROCEDURE proc_CourseOfferingsInSemester(
    l_semesterID IN CourseOffering.semesterID%TYPE
)
IS
BEGIN

	FOR cursor0 IN (
		SELECT s.season, s.year
		FROM Semester s
		WHERE s.semesterID = l_semesterID
	)
	LOOP
		DBMS_OUTPUT.PUT_LINE('Courses in Semester of ' || cursor0.season || ' ' || cursor0.year);
	END LOOP;

	FOR cursor1 IN(
		SELECT cs.courseOfferingID, c.deptID, c.courseID, c.title, cs.startTime, cs.endTime
		FROM Course c, CourseOffering cs
		where cs.semesterID = l_semesterID and c.courseID = cs.courseID
	)
	LOOP
		DBMS_OUTPUT.PUT_LINE(rpad(cursor1.courseOfferingID,3) || ' ' || rpad(cursor1.deptID,5) || ' ' || cursor1.courseID || CHR(9) || rpad(cursor1.title,25) || 
							CHR(9) || cursor1.startTime || CHR(9) || cursor1.endTime);
	END LOOP;
END;
/