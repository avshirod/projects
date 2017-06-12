-- Get details for a unity user with unityID

CREATE OR REPLACE PROCEDURE proc_GetProfileData(
    unity_id    IN UnityUsers.unityID%TYPE,
    l_cursor OUT SYS_REFCURSOR 
)

IS

BEGIN
	OPEN l_cursor for SELECT u.unityID, u.fname, u.lname, u.email, u.gender, u.dateOfBirth, u.address, u.phone
	FROM UnityUsers u
	where u.unityID=unity_id;

    EXCEPTION 
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Some Exception occured. Try again.');
            DBMS_OUTPUT.PUT_LINE('Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200));
            --success := 'Some Exception occured. Try again.' || CHR(10) || 'Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200);
        RETURN;
END;
/