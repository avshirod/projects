-- List Special Permission Requests for ongoing Semester
-- EXEC ViewPermRequests;

CREATE OR REPLACE PROCEDURE proc_ViewPermRequests(
	l_return OUT SYS_REFCURSOR
)
IS
	l_semesterID Semester.semesterID%TYPE := constants.current_semID;
BEGIN
	OPEN l_return FOR
		SELECT s.specialPermissionID, s.unityID, co.deptID, co.courseID, s.approvalStatus
		FROM SpecialPermissionRequests s, CourseOffering co
		WHERE s.courseOfferingID = co.courseOfferingID
		AND co.semesterID = l_semesterID;
END;
/