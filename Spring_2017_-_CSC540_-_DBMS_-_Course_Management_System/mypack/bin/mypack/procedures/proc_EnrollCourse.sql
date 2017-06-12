set serveroutput ON;

CREATE OR REPLACE PROCEDURE proc_EnrollCourse(
    unity_id            IN Students.unityID%TYPE,
    courseOffering_id   IN CourseOffering.courseOfferingID%TYPE,
    credit_hours        IN TRANSCRIPT.creditHoursTaken%TYPE,
    overload_dropcourse IN Waitlist.overloadDropCOID%TYPE,
    success             OUT VARCHAR2
    -- add_waitlist     IN NUMBER(1),
)

IS
    already_registered          NUMBER(1) := 0;
    participation_level_student Students.participationLevel%TYPE;
    participation_level_course  Students.participationLevel%TYPE;
    student_gpa                 Students.overallGPA%TYPE;
    min_credits                 Course.minCredits%TYPE;
    max_credits                 Course.maxCredits%TYPE;
    course_availability         CourseOffering.seatsAvailable%TYPE;
    gpa_requirement             CourseOffering.gpaRequirement%TYPE;
    course_id                   Course.courseID%TYPE;
    dept_id                     Course.deptID%TYPE;
    waitlist_limit              CourseOffering.waitListLimit%TYPE;
    waitlisted_students         NUMBER;
    semester_id                 CourseOffering.semesterID%TYPE;
    class_days                  CourseOffering.classDays%TYPE;
    class_startTime             CourseOffering.startTime%TYPE;
    class_endTime               CourseOffering.endTime%TYPE;
    total_credits_taken_transcript NUMBER := 0;
    total_credits_taken_waitlist NUMBER := 0;
    residency_level             Students.residencyLevel%TYPE;
    max_allowed_credit          NUMBER;
    current_semID               NUMBER := constants.current_semID;
    special_permission_req      NUMBER := 0;
    prerequisite_satisfied      NUMBER;
    other_special_perms         NUMBER := 0;
    temp_var                    NUMBER;
    existUser                   NUMBER;
    temp_gpa                    NUMBER;

BEGIN

    DBMS_OUTPUT.PUT_LINE(CHR(9));

    FOR cursor0 IN (
        SELECT co.deptID, co.courseID, s.season, s.year, c.title
        FROM CourseOffering co, Semester s, course c
		WHERE co.courseOfferingID = courseOffering_id
		AND co.semesterID = s.semesterID
		AND c.courseID = co.courseID AND c.deptID = co.deptID
    )
    LOOP
		DBMS_OUTPUT.PUT_LINE('Trying to enroll ' || unity_id || ' into ' || cursor0.courseID || ' ' || cursor0.deptID ||
							' (' || cursor0.season || ' ' || cursor0.year || ') - ' || cursor0.title);
	END LOOP;

    proc_ExistUser(unity_id, existUser);
    IF existUser = 0 THEN
        DBMS_OUTPUT.PUT_LINE('"' || unity_id || '" does not exist in the system. Contact Admin.');
        success := 'Student does not exist in the system. Contact Admin.';
        RETURN;
    END IF;

    -- See if student is already enrolled ( or has taken previously) into the course
    SELECT count(*) INTO already_registered
    FROM Transcript t
    WHERE t.unityID=unity_id AND t.courseOfferingID=courseOffering_id;

    IF (already_registered < 1) THEN

        SELECT co.courseID, co.deptID, co.seatsAvailable, co.waitListLimit, co.semesterID , co.gpaRequirement, co.classDays, co.startTime, co.endTime
        into course_id, dept_id, course_availability, waitlist_limit, semester_id, gpa_requirement, class_days, class_startTime, class_endTime
        FROM CourseOffering co
        WHERE co.courseOfferingID = courseOffering_id;

        -- Trying to enroll into a course from previous semester
        IF semester_id < current_semID THEN
            DBMS_OUTPUT.PUT_LINE('Course from previous semesters.');
            success := 'Course from previous semesters.';
            RETURN;
        END IF;

        SELECT participationLevel, residencyLevel, overallGPA INTO participation_level_student, residency_level, student_gpa
        FROM Students
        WHERE unityID=unity_id;

        SELECT participationLevel, minCredits, maxCredits INTO participation_level_course, min_credits, max_credits
        FROM Course
        WHERE courseID=course_id and deptID = dept_id;


        select count(*) into temp_var
        FROM Transcript t, CourseOffering s
        WHERE t.unityID=unity_id and t.courseOfferingID=s.courseOfferingID and s.semesterid=semester_id;

        if temp_var != 0 then        
            select SUM(t.creditHoursTaken) into total_credits_taken_transcript
            FROM Transcript t, CourseOffering s
            WHERE t.unityID=unity_id and t.courseOfferingID=s.courseOfferingID and s.semesterID=semester_id;
        else
            total_credits_taken_transcript := 0;
        end if;


        select count(*) into temp_var
        from Waitlist w, CourseOffering s
        where w.unityID=unity_id and w.courseOfferingID=s.courseOfferingID;
        
        if temp_var != 0 then
            select SUM(c.maxcredits) into total_credits_taken_waitlist
            FROM Waitlist w, CourseOffering s, Course c
            WHERE w.unityID=unity_id and w.courseOfferingID=s.courseOfferingID and s.semesterID=semester_id
            and c.courseID=s.courseID and c.deptID = s.deptID;
        else
            total_credits_taken_waitlist := 0;
        end if;


        select maxCreditReq into max_allowed_credit
        FROM CreditRequirements
        WHERE participation_level_student=participationLevel and residency_level=residencyLevel;

        SELECT COUNT(*) INTO special_permission_req
        FROM PermissionMapping pm
        WHERE pm.courseOfferingID = courseOffering_id;

        
        -- If participationLevel of student is different fromt the course
        IF (participation_level_student != participation_level_course) THEN
            DBMS_OUTPUT.PUT_LINE('Participation level mismatched.');
            success := 'Participation level mismatched.';
            RETURN;
        END IF;

        -- If creditHours requested are not within [minCredits, maxCredits], can't enroll
        IF ((credit_hours < min_credits) OR (credit_hours > max_credits)) THEN
            DBMS_OUTPUT.PUT_LINE('Incorrect credit hours.');
            success := 'Incorrect credit hours.';
            RETURN;
        END IF;

        -- If Special Permissions are required for the courseOffering, see if they are satisfied; if not then can't enroll
        IF special_permission_req > 0 THEN
            -- Check if Special Permission is PREREQ; if PREREQ is Satisfied, then continue; else can't enroll
            FOR prereq_course IN (
                SELECT p.courseID, p.deptID, p.mandatory, p.gpa
                FROM Prerequisites p
                WHERE p.courseOfferingID = courseOffering_id
            )
            LOOP
                IF prereq_course.mandatory = 1 THEN
                    SELECT COUNT(*) INTO prerequisite_satisfied
                    FROM Transcript t, CourseOffering co
                    WHERE t.unityID = unity_id
                    AND t.courseOfferingID = co.courseOfferingID
                    AND co.courseID = prereq_course.courseID
                    AND co.deptID = prereq_course.deptID;
                    -- AND gpa_mapping(t.courseGrade, temp_gpa) >= p.gpa;
                ELSE
                    prerequisite_satisfied := 1;
                    -- If Student GPA is below the required GPA, can't enroll
                    IF (student_gpa < gpa_requirement) THEN
                        DBMS_OUTPUT.PUT_LINE('Student GPA Below ' || gpa_requirement || '. Cannot enroll.');
                        success := 'Student GPA Below ' || gpa_requirement || '. Cannot enroll.';
                        RETURN;
                    END IF;
                END IF;

                -- prerequisite_satisfied = 0 means no course found in transcript, hence prereq not satisfied
                IF prerequisite_satisfied = 0 THEN
                    DBMS_OUTPUT.PUT_LINE('Prerequisites not satisfied.');
                    success := 'Prerequisites not satisfied.';
                    RETURN;
                END IF;
            END LOOP;

            -- If other Special Permissions are required, can't enroll
            SELECT COUNT(*) INTO other_special_perms
            FROM PermissionMapping pm, SpecialPermissions sp
            WHERE pm.specialPermissionID = sp.specialPermissionID
            AND sp.specialPermissionCodes <> 'PREREQ'
            AND sp.specialPermissionCodes <> 'MatchReqLevel'
            AND pm.courseOfferingID = courseOffering_id;

            IF other_special_perms > 0 THEN
                DBMS_OUTPUT.PUT_LINE('Special Permissions Required.');
                success := 'Special Permissions Required.';
                RETURN;
            END IF;

        END IF;
        
        -- If course clashes with another course previously enrolled for, then can't enroll
        FOR curr_course IN (
            SELECT t.courseOfferingID, co.classDays, co.startTime, co.endTime
            FROM Transcript t, CourseOffering co
            WHERE t.unityID = unity_id
            AND t.courseOfferingID = co.courseOfferingID
            AND co.semesterID = semester_id
        )
        LOOP
            -- TO_NUMBER(TO_CHAR(DATE_1, 'SSSSS'))
            IF curr_course.classDays = class_days THEN
                IF ((class_startTime BETWEEN curr_course.startTime AND curr_course.endTime) OR (class_endTime BETWEEN curr_course.startTime AND curr_course.endTime)) THEN
                    DBMS_OUTPUT.PUT_LINE('Scheduling conflict. This class clashes with another class. Cannot enroll. Please see schedule.');
                    success := 'Scheduling conflict. This class clashes with another class. Cannot enroll. Please see schedule.';
                    RETURN;
                END IF;
            END IF;
        END LOOP;

        -- If course if full,
        IF (course_availability = 0) THEN
        	/* 
            IF add_waitlist = 0 THEN
                DBMS_OUTPUT.PUT_LINE('Course is full. Do you want to be added to waitlist?');
                success := 'Course is full. Do you want to be added to waitlist?';
                RETURN;
            END IF;
            */
        	SELECT count(*) into waitlisted_students
        	FROM Waitlist
        	WHERE courseOfferingID=courseOffering_id;
        	
            -- Waitlist is full
        	IF (waitlisted_students >= waitlist_limit)
        	THEN
                DBMS_OUTPUT.PUT_LINE('Course and waitlist full. Keep checking to see if seats open up.');
        		success := 'Course and waitlist full. Keep checking to see if seats open up.';
        		RETURN;
        	ELSE
                -- Waitlist is not full, check crietria, and enroll into waiting list
		        IF (participation_level_student=participation_level_course and credit_hours >= min_credits and credit_hours <= max_credits)
		        THEN
                    IF ((total_credits_taken_transcript + total_credits_taken_waitlist + credit_hours) > max_allowed_credit) THEN
	        		    INSERT INTO Waitlist VALUES(unity_id, courseOffering_id, waitlisted_students+1, overload_dropcourse);
                    ELSE
                        INSERT INTO Waitlist VALUES(unity_id, courseOffering_id, waitlisted_students+1, null);
                        /*
                            DBMS_OUTPUT.PUT_LINE('Enrolling in this course puts you over maxCredits. Please mention a course to drop in case of overload.');
                            success := 'Enrolling in this course puts you over maxCredits. Please mention a course to drop in case of overload.';
                            RETURN;
                        */
                    END IF;
                    DBMS_OUTPUT.PUT_LINE('Waitlist Position = ' || (waitlisted_students+1) || '/' || waitlist_limit);
	        		success := 'Added to waitlist.' || CHR(10) || 'Waitlist Position = ' || (waitlisted_students+1) || '/' || waitlist_limit;
	        		RETURN;
	        	END IF;

        	END IF;

        END IF;

        -- DBMS_OUTPUT.PUT_LINE(total_credits_taken_transcript || ' ' ||  total_credits_taken_waitlist || ' ' || credit_hours || ' ' || max_allowed_credit);
        -- If enrolling in the course makes you go over max_allowed_credit, can't enroll
        IF ((total_credits_taken_transcript + total_credits_taken_waitlist + credit_hours) > max_allowed_credit) THEN
            DBMS_OUTPUT.PUT_LINE('Max Credits Exceeded.');
            success := 'Max Credits Exceeded.';
            RETURN;
        END IF;
        
        -- Course is open, seats are available, participationLevels match, creditHours requested are within bounds
        IF (participation_level_student=participation_level_course and credit_hours >= min_credits and credit_hours <= max_credits)
        THEN
            -- Update Transcript
            INSERT INTO TRANSCRIPT(unityID, courseOfferingID, creditHoursTaken, courseGrade)
            VALUES (unity_id, courseOffering_id, credit_hours, 'PROG');

            -- Update CourseOffering, decrease available seats by 1
            UPDATE CourseOffering
            SET seatsAvailable = seatsAvailable - 1
            WHERE courseOfferingID=courseOffering_id;
            
            DBMS_OUTPUT.PUT_LINE('Successfully registered!');
            success := 'Successfully registered!';
            COMMIT;
            RETURN;

        END IF;
    
    ELSE
        -- Already enrolled or previous taken course
        DBMS_OUTPUT.PUT_LINE('Already registered/ previously taken.');
        success := 'Already registered/ previously taken.';
        RETURN;
    
    END IF;
    
    EXCEPTION 
        WHEN OTHERS THEN
            -- err_code := SQLCODE;
            -- err_msg := SUBSTR(SQLERRM, 1, 200);
            DBMS_OUTPUT.PUT_LINE('Some Exception occured. Try again.');
            DBMS_OUTPUT.PUT_LINE('Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200));
            success := 'Some Exception occured. Try again.' || CHR(10) || 'Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200);
        RETURN;
END;
/