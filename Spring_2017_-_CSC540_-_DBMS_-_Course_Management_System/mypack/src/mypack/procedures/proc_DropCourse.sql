-- Drop Course 'courseOfferingID' for 'unityID'
-- EXEC DropCourse(unityID, courseOfferingID)

SET SERVEROUTPUT ON;
SET AUTOCOMMIT OFF;

CREATE OR REPLACE PROCEDURE proc_DropCourse(
	student_id 			IN Students.unityID%type,
	courseoffering_id 	IN Courseoffering.courseOfferingID%type,
	success 			OUT VARCHAR2
)
IS
 	l_dropDate 			DATE;
	l_todaysDate 		DATE := trunc(SYSDATE);
	temp 				number;
	temp_op_string		varchar2(100);
	l_waitlist_unityID 	Waitlist.UnityID%TYPE;
	l_maxcred			number;
	l_waitlist_dropCOID Waitlist.overloadDropCOID%TYPE;

BEGIN
	-- Find out Drop Date for current semester (will be last entry in Semester table)
	select dropDate into l_dropDate
	from ( select * from semester order by semesterID desc)
	where rownum = 1;

	-- If DropDate has not passed
	IF (l_dropDate >= l_todaysDate)	THEN

		-- Find if the student is enrolled in that course
		SELECT count(*) into temp FROM Transcript 
		WHERE courseoffering_id = Transcript.courseOfferingID 
		AND student_id = Transcript.unityID;

		if (temp=0)
		then
			-- Student is not enrolled in mentioned course in ongoing semester
			DBMS_output.put_line('Course not found');
			success := 'Course not found';
		else
	
			Delete from Transcript
			where courseoffering_id = Transcript.courseOfferingID 
			AND student_id = Transcript.unityID;
			
			DBMS_output.put_line('Course dropped.');
			success := 'Course dropped.';
			
			update courseoffering
			set seatsAvailable = least(seatsAvailable + 1, totalSeatsOffered)
			where courseofferingID = courseoffering_id;

			commit;

			-- Update waitlist positions
			update waitlist
			set waitlistPosition = waitlistPosition - 1
			where courseOfferingID = courseoffering_id;

			select count(*) into temp 
			from Waitlist w
			where w.waitlistPosition = 0
			and w.courseOfferingID = courseoffering_id;

			-- If there is a student on waitlist for this course on position 0, enroll that student
			if temp=1 then

				-- Get maxCredits for this course
				SELECT maxCredits into l_maxcred 
				from Course c, CourseOffering co
				where co.courseOfferingID = courseoffering_id 
				and c.courseID = co.courseID and c.deptID = co.deptID;

				SELECT w.unityID, w.overloadDropCOID 
				into l_waitlist_unityID ,l_waitlist_dropCOID
				FROM Waitlist w
				WHERE w.courseOfferingID = courseoffering_id
				and w.waitlistposition = 0;

				-- Drop the courseOffering mentioned in wailisted student in case of overload
				IF l_waitlist_dropCOID <> null THEN
					proc_DropCourse(l_waitlist_unityID, l_waitlist_dropCOID, temp_op_string);
				END IF;

				-- Update transcript of this waitlisted student
				-- We do not need to check if all the requirements are satisfied, as that was done when the student was added onto waitlist
				INSERT into transcript(unityID, courseOfferingID, creditHoursTaken) 
				values (l_waitlist_unityID, courseoffering_id, l_maxcred);

				-- Remove this enrolled student from waitlist		
				delete from Waitlist w 
				where waitlistPosition = 0 
				AND w.courseOfferingID =courseoffering_id ;
				
				commit;

				DBMS_output.put_line('Enrolled a student from waitlist.');

			end if;

		end if;

	else
		DBMS_output.put_line('Drop date has passed. Cannot drop course.');
		success := 'Drop date has passed. Cannot drop course.';
	end if;
	
	EXCEPTION 
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE('Some Exception occured. Try again.');
			DBMS_OUTPUT.PUT_LINE('Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200));
			success := 'Some Exception occured. Try again.' || CHR(10) || 'Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200);
        RETURN;
end;
/