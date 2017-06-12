-- Update Grade in Transcript
-- EXEC enterGrade(courseOfferingID, unityID, newGrade)

CREATE OR REPLACE PROCEDURE proc_EnterGrade(
	courseoffering_id 	IN Transcript.courseOfferingID%TYPE,
	unity_id 			IN Transcript.unityID%TYPE,
	grade 				IN Transcript.courseGrade%TYPE,
	message             OUT VARCHAR2
)

IS
	temp	NUMBER;
BEGIN
	UPDATE 	Transcript
	SET 	courseGrade=grade
	WHERE 	courseOfferingID=courseoffering_id 
	AND 	unityID=unity_id;
	
	temp := sql%rowcount;
	if temp > 0 then
		message:='Success';
	else
		message := 'No rows were updated. Some problem with input. Try again.';
	end if;

	EXCEPTION 
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Some Exception occured. Try again.');
            DBMS_OUTPUT.PUT_LINE('Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200));
            message := 'Some Exception occured. Try again.' || CHR(10) || 'Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200);
        RETURN;

END;
/