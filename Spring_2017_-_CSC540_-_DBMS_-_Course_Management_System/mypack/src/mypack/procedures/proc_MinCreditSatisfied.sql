-- One week before enrollment deadline, see if student is satisfying min credit requirement
-- If not, notify that student on email

SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE proc_MinCreditSatisfied
IS
    min_credit_req          number;
    total_cred_enrolled     number;
BEGIN
    FOR student in (
        SELECT * FROM STUDENTS
    )
    LOOP
        -- Find out total credits the student is enrolled for in ongoing semester
        SELECT COUNT(t.creditHoursTaken) INTO total_cred_enrolled
        FROM Transcript t, CourseOffering co
        WHERE t.unityID = student.unityID
        AND t.courseOfferingID = co.courseOfferingID
        AND co.semesterID = currentSemID;

        -- Find out the min required credit hours to be enrolled as a full time student for this student based on credit requirements
        SELECT minCreditReq INTO min_credit_req
        FROM CreditRequirements cr
        WHERE cr.creditReqID = student.creditReqID;

        IF total_cred_enrolled < min_credit_req THEN
            DBMS_OUTPUT.PUT_LINE(student.unityID);
        END IF;

    END LOOP;
END;
/

SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE proc_MinCredSatUser(
    l_unityID   IN  Students.unityID%TYPE,
    l_message   OUT VARCHAR
)
IS
    min_credit_req          number;
    total_cred_enrolled     number;
BEGIN
    -- Find out total credits the student is enrolled for in ongoing semester
    SELECT COUNT(t.creditHoursTaken) INTO total_cred_enrolled
    FROM Transcript t, CourseOffering co
    WHERE t.unityID = l_unityID
    AND t.courseOfferingID = co.courseOfferingID
    AND co.semesterID = currentSemID;

    -- Find out the min required credit hours to be enrolled as a full time student for this student based on credit requirements
    SELECT minCreditReq INTO min_credit_req
    FROM CreditRequirements cr
    WHERE cr.creditReqID = (SELECT creditReqID FROM Students WHERE unityID = l_unityID);

    IF total_cred_enrolled < min_credit_req THEN
        DBMS_OUTPUT.PUT_LINE('You have not enrolled in enough courses. Min Credit not satisfied. Please enroll in courses before deadline or request RCL.');
        l_message := 'You have not enrolled in enough courses. Min Credit not satisfied. Please enroll in courses before deadline or request RCL.';
        RETURN;
    ELSE
        l_message := 'success';
    END IF;

    EXCEPTION 
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Some Exception occured. Try again.');
        DBMS_OUTPUT.PUT_LINE('Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200));
        l_message := 'Some Exception occured. Try again.' || CHR(10) || 'Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200);
    RETURN;
END;
/
