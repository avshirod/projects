-- View My Currently Waitlisted Courses
-- EXEC proc_ViewWaitlistedCourses(unityID);

CREATE OR REPLACE PROCEDURE proc_ViewWaitlistedCourses(
	unity_id 	IN Waitlist.unityID%TYPE,
	l_return 	OUT SYS_REFCURSOR
)
IS
BEGIN
	OPEN l_return FOR
		SELECT w.courseOfferingID, c.title, w.waitlistPosition
		FROM Waitlist w, CourseOffering cs, Course c
		where w.unityID = unity_id and w.courseOfferingID=cs.courseOfferingID and cs.courseID=c.courseID and cs.deptID = c.deptID;
END;
/