CREATE OR REPLACE PROCEDURE proc_NewUser(
	unity_ID IN UnityUsers.unityID%type,
	f_name IN UnityUsers.fname%type,
	l_name IN UnityUsers.lname%type,
	e_mail IN UnityUsers.email%type,
	gender IN UnityUsers.gender%type,
	dob IN UnityUsers.fname%type,
	addr IN UnityUsers.address%type,
	phno IN UnityUsers.phone%type,
	typeofuser IN UnityUsers.userType%type,
	message OUT VARCHAR2
)
IS
	userExist NUMBER := 0;
BEGIN
	proc_ExistUser(unity_ID, userExist);

	IF userExist = 1 THEN
		message := 'Another user with this unityID exists in the system. Please enter a new UnityID';
		RETURN;
	END IF;

	INSERT INTO UnityUsers(unityID, fname, lname, email, gender, dateOfBirth, address, phone, userType, Password)
	VALUES (unity_ID, f_name,l_name, e_mail, gender, TO_DATE(dob, 'MM/DD/YYYY'), addr, phno, typeofuser, 'password');
	commit;
	
	message := 'success';
	EXCEPTION
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('Some Exception occured. Try again.');
		DBMS_OUTPUT.PUT_LINE('Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200));
		message := 'Some Exception occured. Try again.' || CHR(10) || 'Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200);
END;
/