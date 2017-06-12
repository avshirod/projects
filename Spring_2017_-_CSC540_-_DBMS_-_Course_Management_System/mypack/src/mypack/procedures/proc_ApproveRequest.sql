-- Approve a special permission request
-- EXEC proc_ApproveCourse(specialPermissionID, out_cursor);

set serveroutput ON;

CREATE OR REPLACE PROCEDURE proc_ApproveRequest(
	specialPermReq_id 	IN SpecialPermissionRequests.specialPermReqID%TYPE,
	approver_unityID		IN Admin.unityID%TYPE,
	l_approved				IN NUMBER,
	success 				OUT VARCHAR2
)

IS
	approval_status 	SpecialPermissionRequests.approvalStatus%TYPE;
	courseoffering_id 	SpecialPermissionRequests.courseOfferingID%TYPE;
	credits 			SpecialPermissionRequests.numberOfUnits%TYPE;
	unity_id 			SpecialPermissionRequests.unityID%TYPE;

BEGIN

	SELECT approvalStatus, courseOfferingID, numberOfUnits, unityID INTO approval_status, courseoffering_id, credits, unity_id
	FROM SpecialPermissionRequests
	where specialPermReqID=specialPermReq_id;
	
	-- l_approved = 1 means request was approved; l_approved = 0 is Rejected
	IF l_approved = 1 THEN
		UPDATE SpecialPermissionRequests
		SET approvalStatus = 'Approved', approvalBy = approver_unityID, approvalDate = TRUNC(SYSDATE)
		WHERE specialPermReqID=specialPermReq_id;
		proc_EnrollCourse(unity_id, courseoffering_id, credits, null, success);
		DBMS_OUTPUT.PUT_LINE(success);
	ELSE
		UPDATE SpecialPermissionRequests
		SET approvalStatus = 'Rejected', approvalBy = approver_unityID, approvalDate = TRUNC(SYSDATE)
		WHERE specialPermReqID=specialPermReq_id;
		DBMS_OUTPUT.PUT_LINE('The request has been rejected.');
		success := 'The request has been rejected.';
	END IF;

	EXCEPTION 
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Some Exception occured. Try again.');
            DBMS_OUTPUT.PUT_LINE('Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200));
            success := 'Some Exception occured. Try again.' || CHR(10) || 'Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200);
        RETURN;
END;
/