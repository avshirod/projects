-- View unityIDs of students wailisted in a CourseOffering
-- EXEC ViewWaitlistedStudents(courseOfferingID);

CREATE OR REPLACE PROCEDURE proc_ViewWaitlistedStudents(
	courseoffering_id 	IN CourseOffering.courseOfferingID%TYPE,
	l_return 			OUT SYS_REFCURSOR
)
IS
BEGIN
	OPEN l_return FOR
		SELECT w.unityID, w.waitlistPosition
		FROM Waitlist w
		where w.courseOfferingID = courseoffering_id;
END;
/