-- Trigger to update GPA of a student after a grade is updated in the transcript
set serveroutput on;
CREATE OR REPLACE TRIGGER update_gpa
AFTER INSERT OR UPDATE ON Transcript
FOR EACH ROW
DECLARE
    temp_unityID Transcript.unityID%TYPE;
    pragma autonomous_transaction;  -- To avoid the 'table is being updated error'
BEGIN
    SELECT :new.unityID INTO temp_unityID FROM dual;
    IF (:new.courseGrade IN ('A+', 'A', 'A-', 'B+', 'B', 'B-', 'C+', 'C', 'C-', 'F', 'S', 'U', 'AU', 'INC', 'PROG')) THEN
        proc_calcGPA1(temp_unityID);
    END IF;
END;
/