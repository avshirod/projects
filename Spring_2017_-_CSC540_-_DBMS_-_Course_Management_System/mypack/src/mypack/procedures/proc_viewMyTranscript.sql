-- View My Current Transcript
-- EXEC proc_ViewMyTranscript(unityID);

CREATE OR REPLACE PROCEDURE proc_ViewMyTranscript(
	unity_id 	IN Transcript.unityID%TYPE,
	l_return 	OUT SYS_REFCURSOR
)
IS
BEGIN
	OPEN l_return FOR
		SELECT cs.courseOfferingID, c.title, t.creditHoursTaken, t.courseGrade
		FROM Transcript t, CourseOffering cs, Course c
		where t.unityID = unity_id and t.courseOfferingID=cs.courseOfferingID and cs.courseID=c.courseID and cs.deptID = c.deptID;
END;
/