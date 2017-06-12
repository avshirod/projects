-- At end of last day for bill payment date,
-- drop courses of students who have an unpaid bill against their name

SET SERVEROUTPUT ON;
SET AUTOCOMMIT OFF;

CREATE OR REPLACE PROCEDURE proc_CleanupRolls(
    success OUT VARCHAR2
)
IS
    outstanding_amount 	Billing.outstandingAmount%TYPE;
    temp_var            NUMBER;
BEGIN
    -- For each student, get that student's last bill from billing and see if there is a positive outstanding amount

    FOR student IN (
        SELECT * FROM STUDENTS
    )
    LOOP
        -- look for last entry in billing for student
		select count(*) into temp_var
		from Billing bi 
		where bi.unityid = student.unityID;

		if temp_var !=0 then
			select outstandingAmount into outstanding_amount
			from Billing bi 
			where bi.unityid = student.unityID and rownum = 1			
			order by bi.billid desc; 
		else
			outstanding_amount:=0;
		end if;

        -- If outstanding amount is positive, drop all enrolled courses from current semester
        IF outstanding_amount > 0 THEN

            DBMS_OUTPUT.PUT_LINE('Student ' || student.unityID || ' has an outstading bill.');

            -- See if student is enrolled in any courses this semester (to avoid error in next query)
            SELECT Count(*) INTO temp_var
            FROM Transcript t, CourseOffering co
            WHERE t.unityID = student.unityID
            AND t.courseOfferingID = co.courseOfferingID
            AND co.semesterID = currentSemID;

            IF temp_var > 0 THEN
                FOR curr_course IN (
                    SELECT t.courseOfferingID
                    FROM Transcript t, CourseOffering co
                    WHERE t.unityID = student.unityID
                    AND t.courseOfferingID = co.courseOfferingID
                    AND co.semesterID = currentSemID
                )
                LOOP
                    proc_DropCourse(student.unityID, curr_course.courseOfferingID, success);
                END LOOP;
            END IF;


            -- See if student is wailisted in any courses this semester (to avoid error in next query)
            SELECT Count(*) INTO temp_var
            FROM Waitlist w, CourseOffering co
            WHERE w.unityID = student.unityID
            AND w.courseOfferingID = co.courseOfferingID
            AND co.semesterID = currentSemID;

            IF temp_var > 0 THEN
                FOR curr_course IN (
                    SELECT w.courseOfferingID
                    FROM Waitlist w, CourseOffering co
                    WHERE w.unityID = student.unityID
                    AND w.courseOfferingID = co.courseOfferingID
                    AND co.semesterID = currentSemID
                )
                LOOP
                    proc_DropCourse(student.unityID, curr_course.courseOfferingID, success);
                END LOOP;
            END IF;

            COMMIT;

            DBMS_OUTPUT.PUT_LINE('All courses dropped for student ' || student.unityID || ' due to outstading bill of ' || outstanding_amount);
            success := 'All courses dropped for student ' || student.unityID || ' due to outstading bill of ' || outstanding_amount;

        END IF;

        success := 'Rolls have been cleaned up';

    END LOOP;

    EXCEPTION 
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE('Some Exception occured. Try again.');
			DBMS_OUTPUT.PUT_LINE('Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200));
			success := 'Some Exception occured. Try again.' || CHR(10) || 'Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200);
        RETURN;
END;
/

SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE proc_CleanupRolls1
IS
    l_message VARCHAR2(300);
BEGIN
    proc_CleanupRolls(l_message);
    DBMS_OUTPUT.PUT_LINE(l_message);
END;
/