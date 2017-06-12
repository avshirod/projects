-- Procedure to see if a user unityID exists in the system

SET SERVEROUTPUT ON;

-- Returns 0 if user does not exist, else returns 1

CREATE OR REPLACE PROCEDURE proc_ExistUser(
    l_unityID IN UnityUsers.unityID%TYPE,
    userExist OUT NUMBER
)
IS
BEGIN

    SELECT COUNT(*) INTO userExist
    FROM UnityUsers u
    WHERE u.unityID = l_unityID;

    RETURN;
END;
/

-- Prints the result; no value is returned

CREATE OR REPLACE PROCEDURE proc_VerifyUser(
    l_unityID IN UnityUsers.unityID%TYPE
)
IS
    userExist NUMBER;
BEGIN
    proc_ExistUser(l_unityID, userExist);

    IF userExist = 0 THEN
        DBMS_OUTPUT.PUT_LINE(l_unityID || CHR(9) || 'This user does not exist in the system. Contact Admin.');
    ELSE
        DBMS_OUTPUT.PUT_LINE(l_unityID || CHR(9) || 'User Exists.');
    END IF;
END;
/
