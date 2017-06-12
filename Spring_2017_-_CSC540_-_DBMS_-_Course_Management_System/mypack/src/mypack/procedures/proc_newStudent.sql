SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE newStudent(
	unity_id IN Students.unityID%type,
	student_id IN Students.studentID%type,
	dept_id IN Students.deptID%type,
	residency_level IN Students.residencyLevel%type,
	participation_level IN Students.participationLevel%type,
	year_enrolled IN Students.yearEnrolled%type,
	success OUT VARCHAR2
)

IS
	credit_req_id 	Students.creditReqID%TYPE;
	existsUser 		NUMBER;
	unityUserType 	NUMBER;
BEGIN
	proc_ExistUser(unity_id, existsUser);

	IF existsUser = 0 THEN
		DBMS_OUTPUT.PUT_LINE('This Unity User does not exist. Please create a new Unity User profile first.');
		success := 'This Unity User does not exist. Please create a new Unity User profile first.';
		RETURN;
	END IF;
	
	SELECT creditReqID into credit_req_id
	FROM CreditRequirements
	WHERE participationLevel=participation_level AND residencyLevel=residency_level;

	SELECT userType into unityUserType
	FROM UnityUsers u
	WHERE u.unityID = unity_id;

	IF unityUserType != 3 THEN
		DBMS_OUTPUT.PUT_LINE('This Unity User is not a Student. Please check the UnityID entered.');
		success := 'This Unity User is not a Student. Please check the UnityID entered.';
		RETURN;
	END IF;
	
	INSERT INTO Students(unityID, studentID, deptID, residencyLevel, participationLevel, yearEnrolled, creditReqID)
	VALUES (unity_id, student_id, dept_id, residency_level, participation_level, year_enrolled, credit_req_id);
	
	success:='Student Record Created Successfully.';
commit;

EXCEPTION 
        WHEN OTHERS THEN
            --DBMS_OUTPUT.PUT_LINE('Some Exception occured. Try again.');
            --DBMS_OUTPUT.PUT_LINE('Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200));
            success := 'Some Exception occured. Try again.' || CHR(10) || 'Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200);
        RETURN;
END;
/