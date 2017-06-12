SET AUTOCOMMIT OFF;

-- UnityUsers (unityID, fname, lname, email, gender, dateOfBirth, address, phone, userType, password)
-- Admins = 1, Faculty = 2, Students = 3

INSERT INTO UnityUsers VALUES ('alby', 'Albus', 'Dumbledore', 'alby@ncsu.edu',
'M', TO_DATE('05/26/1984', 'MM/DD/YYYY'), 'Hogwarts', '9199199999', 1, 'hogwarts');

INSERT INTO UnityUsers VALUES ('hpotter', 'Harry', 'Potter', 'hpotter@ncsu.edu', 
'M', TO_DATE('01/12/1990', 'MM/DD/YYYY'), 'Hogwarts', '9191115555', 3, 'hpotter');
INSERT INTO UnityUsers VALUES ('hgranger', 'Hermione', 'Granger', 'hgranger@ncsu.edu',
'F', TO_DATE('04/16/1990', 'MM/DD/YYYY'), 'Hogwarts', '9191116666', 3, 'hgranger');
INSERT INTO UnityUsers VALUES ('rweasley', 'Ron', 'Weasley', 'rweasley@ncsu.edu',
'M', TO_DATE('12/19/1991', 'MM/DD/YYYY'), 'Hogwarts', '9191117777', 3, 'rweasley');
INSERT INTO UnityUsers VALUES ('dmalfoy', 'Draco', 'Malfoy', 'dmalfoy@ncsu.edu',
'M', TO_DATE('03/21/1992', 'MM/DD/YYYY'), 'Hogwarts', '9191118888', 3, 'dmalfoy');

COMMIT;


-- Department (deptID, deptName)

INSERT INTO Department VALUES ('CSC', 'Computer Science');
INSERT INTO Department VALUES ('ECE', 'Electrical and Computer Engineering');

COMMIT;


-- CreditRequirements (creditReqID, participationLevel, residencyLevel, maxCreditReq, minCreditReq)

INSERT INTO CreditRequirements VALUES (1, 1, 1, 12, 0);
INSERT INTO CreditRequirements VALUES (2, 1, 2, 12, 0);
INSERT INTO CreditRequirements VALUES (3, 1, 3, 12, 9);
INSERT INTO CreditRequirements VALUES (4, 2, 1, 9, 0);
INSERT INTO CreditRequirements VALUES (5, 2, 2, 9, 0);
INSERT INTO CreditRequirements VALUES (6, 2, 3, 9, 9);

COMMIT;


-- Students (unityID, studentID, deptID, overallGPA, participationLevel, residencyLevel, yearEnrolled, creditReqID)

INSERT INTO Students VALUES ('hpotter', '101', 'ECE', 4.000, 1, 1, 2015, 1);
INSERT INTO Students VALUES ('hgranger', '102', 'CSC', 3.33, 2, 1, 2015, 4);
INSERT INTO Students VALUES ('rweasley', '103', 'CSC', 4.000, 2, 2, 2015, 5);
INSERT INTO Students VALUES ('dmalfoy', '104', 'CSC', 3.91, 2, 3, 2015, 6);

COMMIT;


-- Employee (unityID, ssn)
INSERT INTO Employee VALUES ('alby', '111222338');

-- Admin (unityID, adminID)
INSERT INTO Admin VALUES ('alby', '200500789');

COMMIT;


-- Course (courseID, deptID, title, maxCredits, minCredits, participationLevel)

INSERT INTO Course VALUES (401, 'CSC', 'Intro to Computer Science', 3, 3, 1);
INSERT INTO Course VALUES (510, 'CSC', 'Database', 3, 3, 2);
INSERT INTO Course VALUES (515, 'CSC', 'Software Engineering', 3, 3, 2);
INSERT INTO Course VALUES (520, 'CSC', 'Internet Protocols', 3, 3, 2);
INSERT INTO Course VALUES (525, 'CSC', 'Independent Study', 3, 1, 2);
INSERT INTO Course VALUES (420, 'ECE', 'VLSI', 3, 3, 1);

INSERT INTO Course VALUES (402, 'CSC', 'Numerical Methods', 3, 3, 1);
INSERT INTO Course VALUES (505, 'CSC', 'Algorithms', 3, 3, 2);
INSERT INTO Course VALUES (521, 'CSC', 'Cloud Computing', 3, 3, 2);
INSERT INTO Course VALUES (530, 'CSC', 'Dev-Ops', 3, 3, 2);
INSERT INTO Course VALUES (421, 'ECE', 'VLSI II', 3, 3, 1);

COMMIT;


-- Semester (semesterID, season, year, addDate, dropDate, semStartDate, semEndDate)

INSERT INTO Semester VALUES (1, 'FALL', 2016, TO_DATE('03/20/2016', 'MM/DD/YYYY'), TO_DATE('08/15/2016', 'MM/DD/YYYY'), TO_DATE('08/01/2016', 'MM/DD/YYYY'), TO_DATE('12/20/2016', 'MM/DD/YYYY'));
INSERT INTO Semester VALUES (2, 'SPRING', 2017, TO_DATE('10/20/2016', 'MM/DD/YYYY'), TO_DATE('01/15/2017', 'MM/DD/YYYY'), TO_DATE('01/01/2017', 'MM/DD/YYYY'), TO_DATE('05/20/2017', 'MM/DD/YYYY'));

COMMIT;


-- CourseOffering (CourseOfferingID, courseID, sectionID, deptID, semesterID, 
-- classDays, startTime, endTime, location, 
-- totalSeatsOffered, seatsAvailable, waitListLimit, gpaRequirement)
-- TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 17:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS'))

INSERT INTO CourseOffering VALUES (1, 401, 001, 'CSC', 1,
6, TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 12:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 13:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), '1234 EB2', 
2, 2, 2, 0.0);
INSERT INTO CourseOffering VALUES (2, 510, 001, 'CSC', 1,
7, TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 13:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 14:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), '1234 EB1', 
5, 5, 2, 0.0);
INSERT INTO CourseOffering VALUES (3, 515, 001, 'CSC', 1,
7, TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 14:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 15:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), '2230 EB1', 
3, 3, 2, 0.0);
INSERT INTO CourseOffering VALUES (4, 520, 001, 'CSC', 1,
6, TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 11:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 12:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), '2231 EB3', 
2, 2, 2, 0.0);
INSERT INTO CourseOffering VALUES (5, 525, 001, 'CSC', 1,
6, TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 15:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 16:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), '', 
2, 2, 0, 0.0);
INSERT INTO CourseOffering VALUES (6, 420, 001, 'ECE', 1,
5, TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 15:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 17:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), 'Hunt Audi', 
4, 4, 2, 0.0);

INSERT INTO CourseOffering VALUES (7, 402, 001, 'CSC', 2,
6, TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 11:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 12:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), '1111 EB2', 
2, 2, 2, 0.0);
INSERT INTO CourseOffering VALUES (8, 510, 001, 'CSC', 2,
7, TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 13:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 14:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), '1111 EB2', 
5, 5, 2, 0.0);
INSERT INTO CourseOffering VALUES (9, 505, 001, 'CSC', 2,
6, TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 11:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 12:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), '1111 EB2', 
2, 2, 2, 0.0);
INSERT INTO CourseOffering VALUES (10, 521, 001, 'CSC', 2,
7, TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 13:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 14:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), '1111 EB2', 
3, 3, 2, 3.5);
INSERT INTO CourseOffering VALUES (11, 525, 001, 'CSC', 2,
6, TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 14:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 15:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), '', 
2, 2, 0, 0.0);
INSERT INTO CourseOffering VALUES (12, 530, 001, 'CSC', 2,
6, TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 11:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 12:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), '1111 EB2', 
2, 2, 2, 0.0);
INSERT INTO CourseOffering VALUES (13, 421, 001, 'ECE', 2,
7, TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 16:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 17:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), '1111 EB2', 
4, 4, 2, 0.0);

COMMIT;

-- Billing (billID, unityID, billAmount, dueDate, outstandingAmount)
INSERT INTO Billing VALUES (1, 'hpotter', 1200, TO_DATE('09/01/2016', 'MM/DD/YYYY'), 1200);
INSERT INTO Billing VALUES (1, 'hgranger', 0, TO_DATE('09/01/2016', 'MM/DD/YYYY'), 0);
INSERT INTO Billing VALUES (1, 'rweasley', 0, TO_DATE('09/01/2016', 'MM/DD/YYYY'), 0);
INSERT INTO Billing VALUES (1, 'dmalfoy', 0, TO_DATE('09/01/2016', 'MM/DD/YYYY'), 0);

COMMIT;


-- BillingRate (semesterID, creditReqID, billingRate)

INSERT INTO BillingRate VALUES (1, 1, 400);
INSERT INTO BillingRate VALUES (1, 2, 700);
INSERT INTO BillingRate VALUES (1, 3, 900);
INSERT INTO BillingRate VALUES (1, 4, 500);
INSERT INTO BillingRate VALUES (1, 5, 800);
INSERT INTO BillingRate VALUES (1, 6, 1000);

COMMIT;


-- SpecialPermissions (specialPermissionID, specialPermissionCodes)

INSERT INTO SpecialPermissions VALUES (1, 'PREREQ');
INSERT INTO SpecialPermissions VALUES (2, 'SPPERM');

COMMIT;


-- PermissionMapping (specialPermissionID, CourseOfferingID)

INSERT INTO PermissionMapping VALUES (2, 5);
INSERT INTO PermissionMapping VALUES (1, 10);
INSERT INTO PermissionMapping VALUES (2, 11);


-- Transcript (unityID, CourseOfferingID, creditHoursTaken, courseGrade)

INSERT INTO Transcript VALUES ('hpotter', 6, 3, 'A');
INSERT INTO Transcript VALUES ('hgranger', 2, 3, 'B+');
INSERT INTO Transcript VALUES ('hgranger', 3, 3, 'B+');
INSERT INTO Transcript VALUES ('rweasley', 3, 3, 'A');
INSERT INTO Transcript VALUES ('rweasley', 4, 3, 'A-');
INSERT INTO Transcript VALUES ('rweasley', 12, 3, 'A+');
INSERT INTO Transcript VALUES ('dmalfoy', 2, 3, 'A');
INSERT INTO Transcript VALUES ('dmalfoy', 3, 3, 'B+');
INSERT INTO Transcript VALUES ('dmalfoy', 5, 3, 'A+');

COMMIT;


-- Facilitates (CourseOfferingID, facultyID)
-- Waitlist (unityID, CourseOfferingID, waitlistPosition, overloadDropCOID)
-- SpecialPermissionRequests (specialPermReqID, specialPermissionID, CourseOfferingID, unityID, approvalBy, approvalDate, numberOfUnits, approvalStatus)


-- Prerequisites (CourseOfferingID, courseID, deptID, gpa, mandatory)

INSERT INTO Prerequisites VALUES (7, 401, 'CSC', 0.00, 1);
INSERT INTO Prerequisites VALUES (10, 520, 'CSC', 0.00, 1);
INSERT INTO Prerequisites VALUES (12, 515, 'CSC', 0.00, 1);
INSERT INTO Prerequisites VALUES (13, 420, 'ECE', 0.00, 1);

COMMIT;


-- Static variables for the database
CREATE OR REPLACE PACKAGE constants
AS
PROCEDURE get_constants;
current_semID NUMBER := 1;
END constants;
/