-- Submit a special permission request for admin to approve

SET SERVEROUTPUT ON;
SET AUTOCOMMIT OFF;

CREATE OR REPLACE PROCEDURE proc_NewSpPermReq(
    l_unityID           IN SpecialPermissionRequests.unityID%TYPE,
    l_courseOfferingID  IN SpecialPermissionRequests.courseOfferingID%TYPE,
    l_numberOfUnits     IN SpecialPermissionRequests.numberOfUnits%TYPE,
    l_comments          IN SpecialPermissionRequests.comments%TYPE,
    success             OUT VARCHAR2
)
IS
BEGIN
    INSERT INTO SpecialPermissionRequests (unityID, courseOfferingID, numberOfUnits, comments, approvalStatus)
    VALUES (l_unityID, l_courseOfferingID, l_numberOfUnits, l_comments, 'NEW');
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Request submitted succesfully.');
    success := 'Request submitted succesfully.';

    EXCEPTION 
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Some Exception occured. Try again.');
            DBMS_OUTPUT.PUT_LINE('Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200));
            success := 'Some Exception occured. Try again.' || CHR(10) || 'Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200);
END;
/