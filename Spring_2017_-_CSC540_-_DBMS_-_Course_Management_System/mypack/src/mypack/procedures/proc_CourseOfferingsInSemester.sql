-- Print out Courses in Semester identified by semesterID
-- EXEC courseOfferingsInSemester(semesterID);

CREATE OR REPLACE PROCEDURE proc_CourseOfferingsInSemester(
    l_semesterID 	IN CourseOffering.semesterID%TYPE,
	l_return 		OUT SYS_REFCURSOR
)
IS
BEGIN
	OPEN l_return FOR
		SELECT cs.courseOfferingID, c.deptID, c.courseID, c.title, cs.startTime, cs.endTime
		FROM Course c, CourseOffering cs
		where cs.semesterID = l_semesterID and c.courseID = cs.courseID and c.deptID = cs.deptID;
END;
/