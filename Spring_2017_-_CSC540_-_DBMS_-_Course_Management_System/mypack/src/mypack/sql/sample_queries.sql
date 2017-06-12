-- Find names of all students that are eligible to enroll for CSC 521 in Spring semester.(Based on prerequisites)
-- Spring 2017 : semID = 2      CSC 521 : courseOfferingID = 10


SET SERVEROUTPUT ON;

DECLARE
    success VARCHAR2(500);
BEGIN
    FOR student IN (
        SELECT unityID
        FROM Students
        ORDER BY studentID
    )
    LOOP
        proc_EnrollCourse(student.unityID, 10, 3, null, success);

        IF success = 'Successfully registered!' THEN
            DBMS_OUTPUT.PUT_LINE(student.unityID);
            proc_DropCourse(student.unityID, 10, success);
        END IF;

    END LOOP;
END;
/

-- Give list of students whose GPA decreased after the current semester

SET SERVEROUTPUT ON;

BEGIN
    proc_updateAllGPAs;
END;
/



-- List all courses and number of students enrolled per semester

SET SERVEROUTPUT ON;

DECLARE
    num_enrolled number := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE(CHR(10) || 'Courses offered and corresponding enrolled students in this semester' || CHR(10));
    FOR course IN (
        SELECT co.courseOfferingID, co.courseID, co.deptID
        FROM CourseOffering co
        WHERE co.semesterID = constants.current_semID
    )
    LOOP
        /*
        DBMS_OUTPUT.PUT_LINE('Students enrolled in ' || course.deptID || ' ' || course.courseID);
        FOR enrolled_student IN (
            SELECT t.unityID
            FROM Transcript t
            WHERE t.courseOfferingID = course.courseOfferingID
        )
        LOOP
            DBMS_OUTPUT.PUT_LINE(enrolled_student.unityID);
        END LOOP;*/
        -- DBMS_OUTPUT.PUT_LINE(CHR(10));

        SELECT COUNT(*) INTO num_enrolled
        FROM Transcript t
        WHERE t.courseOfferingID = course.courseOfferingID;
        
        DBMS_OUTPUT.PUT_LINE(course.deptID || ' ' || course.courseID || ' = ' || num_enrolled);
    END LOOP;
END;
/