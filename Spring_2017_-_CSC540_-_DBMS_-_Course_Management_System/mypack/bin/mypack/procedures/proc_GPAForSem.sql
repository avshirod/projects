-- Calculate GPA for a student with unityID for a semesterID

set serveroutput on;

CREATE OR REPLACE PROCEDURE proc_GPAForSem(
	unity_id 	IN Students.unityid%type,
	semester_id IN CourseOffering.semesterid%type,
	overall_gpa OUT students.overallGpa%type
)
IS
	overall_grade 	number := 0;
	mapped_val 		number;
	courses_taken 	number;
BEGIN
	-- See if student has taken any courses in this semester 
	select count(*) into courses_taken
	FROM Transcript t, CourseOffering co
	WHERE t.unityID=unity_id and t.courseOfferingID=co.courseOfferingID and co.semesterID = semester_id;

	if courses_taken != 0 then
		for cursor0 in (
			select t.coursegrade
			from transcript t, CourseOffering co
			WHERE t.unityID=unity_id and t.courseOfferingID=co.courseOfferingID and co.semesterid=semester_id
		)
		loop
			if cursor0.coursegrade NOT IN ('S', 'U', 'AU', 'PROG') then
				GPA_MAPPING(cursor0.coursegrade, mapped_val);
				overall_grade := overall_grade + mapped_val;
			else
				courses_taken := courses_taken - 1;
			end if;
		end loop;

		overall_gpa := overall_grade / courses_taken;
	
	end if;

	EXCEPTION 
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Some Exception occured. Try again.');
            DBMS_OUTPUT.PUT_LINE('Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200));
END;
/

CREATE OR REPLACE PROCEDURE proc_GPAForSem1(
	unity_id IN Students.unityid%type,
	semester_id IN CourseOffering.semesterid%type
)
IS
	gpaForSem students.overallGpa%type;
BEGIN
	proc_GPAForSem(unity_id, semester_id, gpaForSem);
	DBMS_OUTPUT.PUT_LINE('GPA in semesterID ' || semester_id || ' for ' || unity_id || ' = ' || gpaForSem);
END;
/