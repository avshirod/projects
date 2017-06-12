-- Prints unityIDs of Students registered in a CourseOffering 
-- EXEC StudentsRegisteredInCourse(3);

CREATE OR REPLACE PROCEDURE proc_StudentsInCourse(
	courseoffering_id 	IN CourseOffering.courseOfferingID%TYPE,
	l_return 			OUT SYS_REFCURSOR
)
IS
BEGIN
	OPEN l_return FOR
		SELECT t.unityID
		FROM Transcript t
		WHERE t.courseOfferingID = courseoffering_id;
END;
/