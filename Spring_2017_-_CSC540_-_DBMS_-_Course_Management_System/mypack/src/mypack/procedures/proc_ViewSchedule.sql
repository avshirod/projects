-- View the current schedule for a student with given unityID

SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE proc_ViewSchedule(
    l_unityID   IN Transcript.unityID%TYPE,
    l_return    OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN l_return FOR
        SELECT t.courseOfferingID, co.deptID, co.courseID, co.classDays, co.startTime, co.endTime, co.location
        FROM Transcript t, CourseOffering co
        WHERE t.unityID = l_unityID
        AND t.courseOfferingID = co.courseOfferingID
        AND co.semesterID = currentSemID;
    EXCEPTION 
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Some Exception occured. Try again.');
            DBMS_OUTPUT.PUT_LINE('Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200));
END;
/

SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE proc_ViewSchedule1(
    l_unityID   IN Transcript.unityID%TYPE
)
IS
BEGIN
    DBMS_OUTPUT.PUT_LINE(CHR(10) || 'Schedule for Student ' || l_unityID || ' for current semester - ' || CHR(10));

    FOR cursor0 IN (
        SELECT t.courseOfferingID, co.deptID, co.courseID, co.classDays, co.startTime, co.endTime, co.location
        FROM Transcript t, CourseOffering co
        WHERE t.unityID = l_unityID
        AND t.courseOfferingID = co.courseOfferingID
        AND co.semesterID = currentSemID
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE(cursor0.courseOfferingID || ' ' || rpad(cursor0.deptID, 5) || ' ' || cursor0.courseID || ' ' ||
                            cursor0.classDays || ' ' || cursor0.startTime || '-' || cursor0.endTime || ' ' || cursor0.location);
    END LOOP;

    EXCEPTION 
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Some Exception occured. Try again.');
            DBMS_OUTPUT.PUT_LINE('Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200));
END;
/