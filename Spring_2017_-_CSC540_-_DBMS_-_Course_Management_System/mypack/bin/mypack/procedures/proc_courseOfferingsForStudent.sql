-- Print out Courses in Semester identified by semesterID
-- EXEC courseOfferingsInSemester(semesterID);

CREATE OR REPLACE PROCEDURE proc_cOfferingsForMe(
    l_unityID IN UnityUsers.unityID%TYPE,
    l_return        OUT SYS_REFCURSOR
)
IS
    semester_id CourseOffering.semesterID%TYPE := constants.current_semID;
    participation_level Students.participationLevel%TYPE;
BEGIN
    SELECT participationLevel into participation_level
    FROM STUDENTS
    WHERE unityID=l_unityID;

    OPEN l_return FOR
        SELECT cs.courseOfferingID, c.deptID, c.courseID, c.title, cs.startTime, cs.endTime
        FROM Course c, CourseOffering cs
        where cs.semesterID = semester_id and c.courseID = cs.courseID and c.deptID = cs.deptID and
        c.participationLevel=participation_level;
END;
/