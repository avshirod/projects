-- Trigger to update GPA of a student after a grade is updated in the transcript
CREATE OR REPLACE TRIGGER update_gpa
BEFORE INSERT ON Transcript
FOR EACH ROW
DECLARE
    temp_unityID Transcript.unityID%TYPE;
BEGIN
    SELECT :new.unityID INTO temp_unityID FROM dual;
    IF (:new.courseGrade IN ('A+', 'A', 'A-', 'B+', 'B', 'B-', 'C+', 'C', 'C-', 'F', 'S', 'U', 'AU', 'INC', 'PROG')) THEN
        proc_calcGPA1(temp_unityID);
    END IF;
END;
/