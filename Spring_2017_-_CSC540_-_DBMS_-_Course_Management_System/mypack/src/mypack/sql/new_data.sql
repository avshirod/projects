SET AUTOCOMMIT OFF;

-- UnityUsers (unityID, fname, lname, email, gender, dateOfBirth, address, phone, userType, password)
-- Admins = 1, Faculty = 2, Students = 3

INSERT INTO UnityUsers VALUES ('lordv', 'Lord', 'Voldemort', 'lordv@ncsu.edu', 
'M', TO_DATE('06/16/1988', 'MM/DD/YYYY'), 'Hogwarts', '9199199999', 3, 'lordv');
INSERT INTO UnityUsers VALUES ('sblack', 'Sirius', 'Black', 'sblack@ncsu.edu', 
'M', TO_DATE('09/04/1987', 'MM/DD/YYYY'), 'Hogwarts', '9046571234', 3, 'sblack');

COMMIT;

-- Students (unityID, studentID, deptID, overallGPA, participationLevel, residencyLevel, yearEnrolled, creditReqID)

INSERT INTO Students VALUES ('lordv', '105', 'CSC', 0.00, 2, 1, 2016, 4);
INSERT INTO Students VALUES ('sblack', '106', 'CSC', 0.00, 2, 1, 2016, 4);
COMMIT;

-- Course (courseID, deptID, title, maxCredits, minCredits, participationLevel)
INSERT INTO Course VALUES (555, 'CSC', 'Data Science', 3, 3, 2);
INSERT INTO Course VALUES (560, 'CSC', 'Real Time OS', 3, 3, 2);
COMMIT;

-- CourseOffering (CourseOfferingID, courseID, sectionID, deptID, semesterID, 
-- classDays, startTime, endTime, location, 
-- totalSeatsOffered, seatsAvailable, waitListLimit, gpaRequirement)
-- TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 17:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS'))

INSERT INTO CourseOffering VALUES (14, 555, 001, 'CSC', 2,
5, TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 16:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 17:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), 'Hunt',
2, 2, 2, 0);
INSERT INTO CourseOffering VALUES (15, 560, 001, 'CSC', 2,
5, TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 13:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 15:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), 'EB2',
2, 2, 2, 0);


-- Transcript (unityID, CourseOfferingID, creditHoursTaken, courseGrade)

INSERT INTO Transcript VALUES ('rweasley', 10, 3, 'PROG');
INSERT INTO Transcript VALUES ('rweasley', 16, 3, 'PROG');
INSERT INTO Transcript VALUES ('rweasley', 17, 3, 'PROG');


SET SERVEROUTPUT ON;
DECLARE
    l_msg varchar2(300);
BEGIN
    FOR stud IN (
        SELECT unityID FROM Students
    )
    LOOP
        proc_EnrollCourse(stud.unityID, 15, 3, null, l_msg);
        DBMS_OUTPUT.PUT_LINE(stud.unityID || CHR(9) || l_msg);
    END LOOP;
END;
/