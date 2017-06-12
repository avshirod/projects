-- Register a new course offering
-- Display list of existing courses; then either select a previously existing (courseID, deptID) combination 
-- Or register a new course using proc_NewCourse, then register a CourseOffering
-- CourseOffering (courseOfferingID, courseID, sectionID, deptID, semesterID, 
-- classDays, startTime, endTime, location, totalSeatsOffered, seatsAvailable, waitListLimit, gpaRequirement)

SET SERVEROUTPUT ON;
SET AUTOCOMMIT OFF;

CREATE OR REPLACE PROCEDURE proc_NewCourseOffering(
    -- l_courseOfferingID      IN CourseOffering.courseOfferingID%TYPE,
    l_courseID              IN CourseOffering.courseID%TYPE,
    l_deptID                IN CourseOffering.deptID%TYPE,
    l_sectionID             IN CourseOffering.sectionID%TYPE,
    l_semesterID            IN CourseOffering.semesterID%TYPE,
    l_classDays             IN CourseOffering.classDays%TYPE,
    l_startTime             IN VARCHAR2,
    l_endTime               IN VARCHAR2,
    l_location              IN CourseOffering.location%TYPE,
    l_totalSeatsOffered     IN CourseOffering.totalSeatsOffered%TYPE,
    l_waitListLimit         IN CourseOffering.waitListLimit%TYPE,
    l_gpaReq                IN CourseOffering.gpaRequirement%TYPE,
    success                 OUT VARCHAR2
)
IS
    temp_var    number;
BEGIN

    SELECT COUNT(*) INTO temp_var
    FROM Course c
    WHERE c.courseID = l_courseID
    AND c.deptID = l_deptID;

    -- Register a course first
    IF temp_var = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Please register a course first in the database. Execute proc_NewCourse.');
        success := 'Please register a course first in the database. Execute proc_NewCourse.';
        RETURN;
    ELSE
        INSERT INTO CourseOffering (courseID, deptID, sectionID, semesterID, classDays, startTime, endTime, location
        , totalSeatsOffered, seatsAvailable, waitlistLimit, gpaRequirement)
        VALUES (l_courseID, l_deptID, l_sectionID, l_semesterID,
        l_classDays, TO_NUMBER(TO_CHAR(TO_DATE(l_startTime, 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), TO_NUMBER(TO_CHAR(TO_DATE(l_endTime, 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), l_location, l_totalSeatsOffered, l_totalSeatsOffered, l_waitListLimit, l_gpaReq);
        COMMIT;

        DBMS_OUTPUT.PUT_LINE('CourseOffering created.');
        success := 'CourseOffering created.';
        RETURN;
    END IF;

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Some Exception occured. Try again.');
            DBMS_OUTPUT.PUT_LINE('Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200));
            success := 'Some Exception occured. Try again.' || CHR(10) || 'Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200);
        RETURN;

END;
/