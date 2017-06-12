-- View My Bill Statements
-- EXEC proc_ViewMyBill(unityID);

CREATE OR REPLACE PROCEDURE proc_ViewMyBill(
	unity_id 	IN Transcript.unityID%TYPE,
	l_return 			OUT SYS_REFCURSOR
)
IS
BEGIN
	OPEN l_return FOR
		SELECT billID, billAmount, dueDate, outstandingAmount
		FROM Billing
		where unityID = unity_id
		ORDER BY billID desc;
END;
/