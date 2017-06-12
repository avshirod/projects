-- Get details for a unity user with unityID

CREATE OR REPLACE PROCEDURE proc_GetUnityUserData(
    unity_id    IN UnityUsers.unityID%TYPE,
    f_name      OUT UnityUsers.fname%TYPE,
    l_name      OUT UnityUsers.lname%TYPE,
    e_mail      OUT UnityUsers.email%TYPE,
    gender_     OUT UnityUsers.gender%TYPE,
    user_type   OUT UnityUsers.userType%TYPE
)

IS

BEGIN
	SELECT u.fname, u.lname, u.email, u.gender, u.userType into f_name, l_name, e_mail, gender_, user_type
	FROM UnityUsers u
	where u.unityID=unity_id;

    EXCEPTION 
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Some Exception occured. Try again.');
            DBMS_OUTPUT.PUT_LINE('Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200));
            -- success := 'Some Exception occured. Try again.' || CHR(10) || 'Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200);
        RETURN;
END;
/