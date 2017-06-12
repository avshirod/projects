-- View all students enrolled in the system
-- EXEC ViewStudents;

CREATE OR REPLACE PROCEDURE proc_ViewStudents(
	l_return OUT SYS_REFCURSOR
)
IS
BEGIN
	OPEN l_return FOR
		SELECT u.unityID, s.studentID, u.fname, u.lname, u.gender, s.overallGPA, u.dateOfBirth, u.phone, u.address
		FROM Students s, UnityUsers u
		where s.unityID=u.unityID;
END;
/