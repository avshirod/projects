SET AUTOCOMMIT OFF;

-- UnityUsers
-- Admins = 1, Faculty = 2, Students = 3 (First Grad, then Undergrad)

-- INSERT INTO UnityUsers VALUES(unityID, fname, lname, email, gender, dateOfBirth, address, phone, userType, password)

INSERT INTO UnityUsers VALUES ('admin', 'FNU', 'Admin', 'admin@ncsu.edu', 
'F', TO_DATE('01/01/1960', 'MM/DD/YYYY'), 'Hunt Library', '9876543210', 1, 'admin');
INSERT INTO UnityUsers VALUES ('kmluca', 'Kathy', 'Luca', 'kmluca@ncsu.edu',
'F', TO_DATE('02/01/1970', 'MM/DD/YYYY'), 'EB2', '9191112222', 1, 'kmluca');
INSERT INTO UnityUsers VALUES ('alby', 'Albus', 'Dumbledore', 'alby@ncsu.edu',
'M', TO_DATE('05/26/1984', 'MM/DD/YYYY'), 'Hogwarts', '9199199999', 1, 'hogwarts');

INSERT INTO UnityUsers VALUES ('kogan', 'Kemafor', 'Ogan', 'kogan@ncsu.edu', 
'F', TO_DATE('03/01/1975', 'MM/DD/YYYY'), 'Textiles', '9193332222', 2, 'kogan');
INSERT INTO UnityUsers VALUES ('csavage', 'Carla', 'Savage', 'csavage@ncsu.edu',
'F', TO_DATE('04/01/1965', 'MM/DD/YYYY'), 'EB1', '9195554444', 2, 'csavage');
INSERT INTO UnityUsers VALUES ('grouska', 'George', 'Rouskas', 'grouska@ncsu.edu',
'M', '', 'EB3', '9196665555', 2, 'grouska');

INSERT INTO UnityUsers VALUES ('asupeka', 'Anuja', 'Supekar', 'asupeka@ncsu.edu',
'F', TO_DATE('05/01/1990', 'MM/DD/YYYY'), 'Avery Close', '9196667777', 3, 'asupeka');
INSERT INTO UnityUsers VALUES ('avshirod', 'Aditya', 'Shirode', 'avshirod@ncsu.edu',
'M', TO_DATE('06/01/1990', 'MM/DD/YYYY'), 'KP', '9197778888', 3, 'avshirod');
INSERT INTO UnityUsers VALUES ('garadhy', 'Gaurav', 'Aradhye', 'garadhy@ncsu.edu',
'M', TO_DATE('07/01/1990', 'MM/DD/YYYY'), 'Parkwood', '9195556666', 3, 'garadhy');
INSERT INTO UnityUsers VALUES ('kprabhu', 'Kahan', 'Prabhu', 'kprabhu',
'M', TO_DATE('08/01/1990', 'MM/DD/YYYY'), 'Colonial', '9192221111', 3, 'kprabhu');

INSERT INTO UnityUsers VALUES ('jdoe', 'John', 'Doe', 'jdoe@ncsu.edu',
'M', TO_DATE('10/01/2000', 'MM/DD/YYYY'), 'Western Manor', '9190001111', 3, 'jdoe');
INSERT INTO UnityUsers VALUES ('jdoe1', 'Jane', 'Doe', 'jdoe1@ncsu.edu',
'F', TO_DATE('11/01/2000', 'MM/DD/YYYY'), 'Gorman', '9191234567', 3, 'jdoe1');
INSERT INTO UnityUsers VALUES ('sgarg', 'Shaurya', 'Garg', 'sgard@ncsu.edu', 
'M', TO_DATE('12/01/2000', 'MM/DD/YYYY'), 'Watauga Hall', '9193123141', 3, 'sgarg');

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
INSERT INTO Department VALUES ('TXTL', 'Textiles');
INSERT INTO Department VALUES ('MECH', 'Mechanical');
INSERT INTO Department VALUES ('MA', 'Mathematics');
INSERT INTO Department VALUES ('ST', 'Statistics');

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

INSERT INTO Students VALUES ('asupeka', '200111900', 'CSC', 4.000, 2, 3, 2015, 6);
INSERT INTO Students VALUES ('avshirod', '200111901', 'CSC', 3.666, 2, 3, 2016, 6);
INSERT INTO Students VALUES ('garadhy', '200111902', 'ECE', 3.333, 2, 2, 2014, 5);
INSERT INTO Students VALUES ('kprabhu', '200111903', 'TXTL', 3.675, 2, 1, 2017, 4);

INSERT INTO Students VALUES ('jdoe', '200222900', 'CSC', 2.67, 1, 1, 2016, 1);
INSERT INTO Students VALUES ('jdoe1', '200222901', 'MECH', 3.876, 1, 2, 2014, 2);
INSERT INTO Students VALUES ('sgarg', '200222902', 'ECE', 3.4, 1, 3, 2015, 3);

INSERT INTO Students VALUES ('hpotter', '101', 'ECE', 4.000, 1, 1, 2015, 1);
INSERT INTO Students VALUES ('hgranger', '102', 'CSC', 3.33, 2, 1, 2015, 4);
INSERT INTO Students VALUES ('rweasley', '103', 'CSC', 4.000, 2, 2, 2015, 5);
INSERT INTO Students VALUES ('dmalfoy', '104', 'CSC', 3.91, 2, 3, 2015, 6);

COMMIT;

-- Employee (unityID, ssn)

INSERT INTO Employee VALUES ('admin', '111222333');
INSERT INTO Employee VALUES ('kmluca', '111222334');
INSERT INTO Employee VALUES ('alby', '111222338');
INSERT INTO Employee VALUES ('kogan', '111222335');
INSERT INTO Employee VALUES ('csavage', '111222336');
INSERT INTO Employee VALUES ('grouska', '111222337');


-- Faculty (unityID, facultyID, deptID)

INSERT INTO Faculty VALUES ('kogan', '200345123', 'CSC');
INSERT INTO Faculty VALUES ('csavage', '200345125', 'ECE');
INSERT INTO Faculty VALUES ('grouska', '200345126', 'CSC');


-- Admin (unityID, adminID)

INSERT INTO Admin VALUES ('admin', '200500123');
INSERT INTO Admin VALUES ('kmluca', '200500546');
INSERT INTO Admin VALUES ('alby', '200500789');

COMMIT;

-- Course (courseID, deptID, title, maxCredits, minCredits, participationLevel)

INSERT INTO Course VALUES (501, 'CSC', 'Operating Systems', 3, 3, 2);
INSERT INTO Course VALUES (505, 'CSC', 'Algorithms', 3, 3, 2);
INSERT INTO Course VALUES (505, 'MA', 'Algorithms', 3, 3, 2);
INSERT INTO Course VALUES (301, 'CSC', 'Intro to Data Science', 3, 3, 1);
INSERT INTO Course VALUES (540, 'CSC', 'DBMS', 3, 3, 2);
INSERT INTO Course VALUES (591, 'CSC', 'Independent Study', 6, 3, 2);
INSERT INTO Course VALUES (101, 'ST', 'Intro to Stats', 2, 2, 1);
INSERT INTO Course VALUES (520, 'ECE', 'ASIC', 3, 3, 2);
INSERT INTO Course VALUES (491, 'MECH', 'Design Project', 6, 3, 1);
INSERT INTO Course VALUES (491, 'TXTL', 'Design Project', 6, 3, 1);

INSERT INTO Course VALUES (401, 'CSC', 'Intro to Computer Science', 3, 3, 1);
INSERT INTO Course VALUES (510, 'CSC', 'Database', 3, 3, 2);
INSERT INTO Course VALUES (515, 'CSC', 'Software Engineering', 3, 3, 2);
INSERT INTO Course VALUES (520, 'CSC', 'Internet Protocols', 3, 3, 2);
INSERT INTO Course VALUES (525, 'CSC', 'Independent Study', 3, 1, 2);
INSERT INTO Course VALUES (420, 'ECE', 'VLSI', 3, 3, 1);

INSERT INTO Course VALUES (402, 'CSC', 'Numerical Methods', 3, 3, 1);
INSERT INTO Course VALUES (521, 'CSC', 'Cloud Computing', 3, 3, 2);
INSERT INTO Course VALUES (530, 'CSC', 'Dev-Ops', 3, 3, 2);
INSERT INTO Course VALUES (421, 'ECE', 'VLSI II', 3, 3, 1);

COMMIT;


-- Semester (semesterID, season, year, addDate, dropDate, semStartDate, semEndDate)

INSERT INTO Semester VALUES (1, 'FALL', 2015, TO_DATE('03/20/2015', 'MM/DD/YYYY'), TO_DATE('08/15/2015', 'MM/DD/YYYY'), TO_DATE('08/01/2015', 'MM/DD/YYYY'), TO_DATE('12/20/2015', 'MM/DD/YYYY'));
INSERT INTO Semester VALUES (2, 'SPRING', 2016, TO_DATE('10/20/2015', 'MM/DD/YYYY'), TO_DATE('01/15/2016', 'MM/DD/YYYY'), TO_DATE('01/01/2016', 'MM/DD/YYYY'), TO_DATE('05/20/2016', 'MM/DD/YYYY'));
INSERT INTO Semester VALUES (3, 'FALL', 2016, TO_DATE('03/20/2016', 'MM/DD/YYYY'), TO_DATE('08/15/2016', 'MM/DD/YYYY'), TO_DATE('08/01/2016', 'MM/DD/YYYY'), TO_DATE('12/20/2016', 'MM/DD/YYYY'));
INSERT INTO Semester VALUES (4, 'SPRING', 2017, TO_DATE('10/20/2016', 'MM/DD/YYYY'), TO_DATE('01/15/2017', 'MM/DD/YYYY'), TO_DATE('01/01/2017', 'MM/DD/YYYY'), TO_DATE('05/20/2017', 'MM/DD/YYYY'));
INSERT INTO Semester VALUES (5, 'FALL', 2017, TO_DATE('03/20/2017', 'MM/DD/YYYY'), TO_DATE('08/15/2017', 'MM/DD/YYYY'), TO_DATE('08/01/2017', 'MM/DD/YYYY'), TO_DATE('12/20/2017', 'MM/DD/YYYY'));

-- CourseOffering (CourseOfferingID, courseID, sectionID, deptID, semesterID, 
-- classDays, startTime, endTime, location, 
-- totalSeatsOffered, seatsAvailable, waitListLimit, gpaRequirement)
-- TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 08:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS'))

INSERT INTO CourseOffering VALUES (1, 501, 001, 'CSC', 1,
6, TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 11:30:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 12:45:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), '2201 EB3', 
3, 3, 1, 0.0);
INSERT INTO CourseOffering VALUES (2, 501, 002, 'CSC', 1,
7, TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 13:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 14:15:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), '2300 EB2', 
5, 2, 1, 0.0);
INSERT INTO CourseOffering VALUES (3, 501, 601, 'CSC', 1, 
9, null, null, 'DE', 3, 3, 2, 0.0);
INSERT INTO CourseOffering VALUES (4, 501, 001, 'CSC', 2,
6, TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 11:30:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 12:45:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), '2201 EB3', 
2, 1, 2, 0.0);

INSERT INTO CourseOffering VALUES (5, 505, 001, 'CSC', 2,
7, TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 08:30:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 09:45:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), '2320 EB1', 
3, 3, 3, 0.0);
INSERT INTO CourseOffering VALUES (6, 505, 001, 'MA', 2, 
7, TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 08:30:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 09:45:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), '2320 EB1', 
3, 3, 0, 0.0);

INSERT INTO CourseOffering VALUES (7, 540, 001, 'CSC', 1,
6, TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 11:45:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 13:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), '1231 Textiles', 
2, 1, 2, 0.0);
INSERT INTO CourseOffering VALUES (8, 540, 001, 'CSC', 3,
6, TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 11:30:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 12:45:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), '2201 EB3', 
2, 2, 1, 0.0);

INSERT INTO CourseOffering VALUES (9, 401, 001, 'CSC', 1,
6, TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 11:30:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 12:45:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), '2201 EB3', 
2, 1, 1, 0.0);

INSERT INTO CourseOffering VALUES (10, 301, 002, 'CSC', 2,
8, TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 08:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 08:50:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), '1231 SAS', 
3, 3, 0, 0.0);

INSERT INTO CourseOffering VALUES (11, 591, 000, 'CSC', 2,
9, null, null, '', 100, 100, 0, 0.0);
INSERT INTO CourseOffering VALUES (12, 491, 000, 'MECH', 1,
9, null, null, '', 100, 100, 0, 0.0);
INSERT INTO CourseOffering VALUES (13, 491, 000, 'MECH', 2,
9, null, null, '', 100, 100, 0, 0.0);
INSERT INTO CourseOffering VALUES (14, 491, 000, 'MECH', 3,
9, null, null, '', 100, 100, 0, 0.0);
INSERT INTO CourseOffering VALUES (15, 491, 000, 'TXTL', 1,
9, null, null, '', 100, 100, 0, 0.0);
INSERT INTO CourseOffering VALUES (16, 491, 000, 'TXTL', 3,
9, null, null, '', 100, 100, 0, 0.0);

INSERT INTO CourseOffering VALUES (17, 520, 001, 'ECE', 1,
1, TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 13:30:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 15:30:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), '3230 EB1', 
3, 3, 1, 0.0);

INSERT INTO CourseOffering VALUES (18, 401, 001, 'CSC', 3,
6, TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 11:30:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 12:45:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), '1234 EB2', 
2, 2, 2, 0.0);
INSERT INTO CourseOffering VALUES (19, 510, 001, 'CSC', 3,
7, TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 17:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 18:15:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), '1234 EB1', 
5, 5, 2, 0.0);
INSERT INTO CourseOffering VALUES (20, 515, 001, 'CSC', 3,
6, TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 13:30:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 14:45:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), '2230 EB1', 
3, 3, 2, 0.0);
INSERT INTO CourseOffering VALUES (21, 520, 001, 'CSC', 3,
7, TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 15:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 16:15:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), '2231 EB3', 
2, 2, 2, 0.0);
INSERT INTO CourseOffering VALUES (22, 525, 001, 'CSC', 3,
9, null, null, '', 2, 2, 0, 0.0);
INSERT INTO CourseOffering VALUES (23, 420, 001, 'ECE', 3,
1, TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 11:30:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 12:45:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), 'Hunt Audi', 
4, 4, 2, 0.0);

INSERT INTO CourseOffering VALUES (24, 402, 001, 'CSC', 4,
6, TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 12:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 01:15:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), '1111 EB2', 
2, 2, 2, 0.0);
INSERT INTO CourseOffering VALUES (25, 510, 001, 'CSC', 4,
7, TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 12:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 01:15:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), '1111 EB2', 
5, 5, 2, 0.0);
INSERT INTO CourseOffering VALUES (26, 505, 001, 'CSC', 4,
6, TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 12:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 01:15:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), '1111 EB2', 
2, 2, 2, 0.0);
INSERT INTO CourseOffering VALUES (27, 521, 001, 'CSC', 4,
6, TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 12:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 01:15:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), '1111 EB2', 
3, 3, 2, 0.0);
INSERT INTO CourseOffering VALUES (28, 525, 001, 'CSC', 4,
8, null, null, '', 2, 2, 0, 0.0);
INSERT INTO CourseOffering VALUES (29, 530, 001, 'CSC', 4,
7, TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 12:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 01:15:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), '1111 EB2', 
2, 2, 2, 0.0);
INSERT INTO CourseOffering VALUES (30, 421, 001, 'ECE', 4,
6, TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 12:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), TO_NUMBER(TO_CHAR(TO_DATE('01/01/2017 01:15:00', 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), '1111 EB2', 
4, 4, 2, 0.0);

COMMIT;

-- Billing (billID, unityID, billAmount, dueDate, outstandingAmount)

INSERT INTO Billing VALUES (1, 'asupeka', 14000, TO_DATE('03/31/2017', 'MM/DD/YYYY'), 14000);
INSERT INTO Billing VALUES (1, 'avshirod', 15000, TO_DATE('03/31/2017', 'MM/DD/YYYY'), 15000);
INSERT INTO Billing VALUES (1, 'avshirod', -5000, TO_DATE('03/31/2017', 'MM/DD/YYYY'), 10000);
INSERT INTO Billing VALUES (1, 'garadhy', 10, TO_DATE('03/31/2017', 'MM/DD/YYYY'), 10);
INSERT INTO Billing VALUES (1, 'jdoe1', 11000, TO_DATE('03/31/2017', 'MM/DD/YYYY'), 31000);

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
INSERT INTO BillingRate VALUES (2, 1, 500);
INSERT INTO BillingRate VALUES (2, 2, 1250);
INSERT INTO BillingRate VALUES (2, 3, 2500);
INSERT INTO BillingRate VALUES (2, 4, 1500);
INSERT INTO BillingRate VALUES (2, 5, 2000);
INSERT INTO BillingRate VALUES (2, 6, 4000);
INSERT INTO BillingRate VALUES (3, 1, 400);
INSERT INTO BillingRate VALUES (3, 2, 700);
INSERT INTO BillingRate VALUES (3, 3, 900);
INSERT INTO BillingRate VALUES (3, 4, 500);
INSERT INTO BillingRate VALUES (3, 5, 800);
INSERT INTO BillingRate VALUES (3, 6, 1000);
INSERT INTO BillingRate VALUES (4, 1, 400);
INSERT INTO BillingRate VALUES (4, 2, 700);
INSERT INTO BillingRate VALUES (4, 3, 900);
INSERT INTO BillingRate VALUES (4, 4, 500);
INSERT INTO BillingRate VALUES (4, 5, 800);
INSERT INTO BillingRate VALUES (4, 6, 1000);
INSERT INTO BillingRate VALUES (5, 1, 400);
INSERT INTO BillingRate VALUES (5, 2, 700);
INSERT INTO BillingRate VALUES (5, 3, 900);
INSERT INTO BillingRate VALUES (5, 4, 500);
INSERT INTO BillingRate VALUES (5, 5, 800);
INSERT INTO BillingRate VALUES (5, 6, 1000);

COMMIT;


-- SpecialPermissions (specialPermissionID, specialPermissionCodes)

-- INSERT INTO SpecialPermissions VALUES (1, 'MatchReqLevel');
INSERT INTO SpecialPermissions VALUES (1, 'PREREQ');
INSERT INTO SpecialPermissions VALUES (2, 'SPPERM');
-- INSERT INTO SpecialPermissions VALUES (4, 'GPAREQD');

COMMIT;

-- PermissionMapping (specialPermissionID, CourseOfferingID)

INSERT INTO PermissionMapping VALUES (1, 1);
INSERT INTO PermissionMapping VALUES (1, 2);

INSERT INTO PermissionMapping VALUES (2, 1);
INSERT INTO PermissionMapping VALUES (2, 2);
INSERT INTO PermissionMapping VALUES (2, 3);
INSERT INTO PermissionMapping VALUES (2, 8);
INSERT INTO PermissionMapping VALUES (2, 12);
INSERT INTO PermissionMapping VALUES (2, 16);
INSERT INTO PermissionMapping VALUES (2, 20);

COMMIT;

-- Transcript (unityID, CourseOfferingID, creditHoursTaken, courseGrade)

INSERT INTO Transcript VALUES ('asupeka', 1, 3, 'A+');
INSERT INTO Transcript VALUES ('asupeka', 5, 3, 'PROG');
INSERT INTO Transcript VALUES ('asupeka', 11, 6, 'PROG');
INSERT INTO Transcript VALUES ('avshirod', 2, 3, 'A-');
INSERT INTO Transcript VALUES ('avshirod', 5, 3, 'PROG');
INSERT INTO Transcript VALUES ('avshirod', 11, 3, 'PROG');
INSERT INTO Transcript VALUES ('garadhy', 3, 3, 'B-');
INSERT INTO Transcript VALUES ('garadhy', 6, 3, 'A');

INSERT INTO Transcript VALUES ('asupeka', 7, 6, 'PROG');
INSERT INTO Transcript VALUES ('avshirod', 7, 6, 'PROG');

INSERT INTO Transcript VALUES ('jdoe', 9, 3, 'A');
INSERT INTO Transcript VALUES ('jdoe', 10, 3, 'A-');

INSERT INTO Transcript VALUES ('jdoe1', 12, 3, 'S');
INSERT INTO Transcript VALUES ('jdoe1', 13, 6, 'PROG');

INSERT INTO Transcript VALUES ('hpotter', 23, 3, 'A');
INSERT INTO Transcript VALUES ('hgranger', 19, 3, 'B+');
INSERT INTO Transcript VALUES ('hgranger', 20, 3, 'B+');
INSERT INTO Transcript VALUES ('rweasley', 20, 3, 'A');
INSERT INTO Transcript VALUES ('rweasley', 21, 3, 'A-');
INSERT INTO Transcript VALUES ('rweasley', 18, 3, 'A+');
INSERT INTO Transcript VALUES ('dmalfoy', 19, 3, 'A');
INSERT INTO Transcript VALUES ('dmalfoy', 20, 3, 'B+');
INSERT INTO Transcript VALUES ('dmalfoy', 22, 3, 'A+');

COMMIT;

-- Facilitates (CourseOfferingID, facultyID)

INSERT INTO Facilitates VALUES (1, 'grouska');
INSERT INTO Facilitates VALUES (2, 'grouska');
INSERT INTO Facilitates VALUES (3, 'grouska');
INSERT INTO Facilitates VALUES (4, 'grouska');
INSERT INTO Facilitates VALUES (4, 'kogan');
INSERT INTO Facilitates VALUES (5, 'csavage');
INSERT INTO Facilitates VALUES (6, 'csavage');
INSERT INTO Facilitates VALUES (7, 'kogan');
INSERT INTO Facilitates VALUES (8, 'kogan');
INSERT INTO Facilitates VALUES (9, 'kogan');
INSERT INTO Facilitates VALUES (10, 'csavage');

INSERT INTO Facilitates VALUES (11, 'kogan');
INSERT INTO Facilitates VALUES (11, 'csavage');
INSERT INTO Facilitates VALUES (11, 'grouska');

COMMIT;


-- Waitlist (unityID, CourseOfferingID, waitlistPosition, overloadDropCOID)

INSERT INTO Waitlist VALUES ('kprabhu', 7, 1, null);
INSERT INTO Waitlist VALUES ('garadhy', 7, 2, null);


-- SpecialPermissionRequests (specialPermissionID, CourseOfferingID, unityID, approvalBy, approvalDate, numberOfUnits, approvalStatus, comments)

INSERT INTO SpecialPermissionRequests VALUES (2, 1, 'avshirod', 'kmluca', '', 3, 'Approved', '');
INSERT INTO SpecialPermissionRequests VALUES (2, 2, 'avshirod', 'kmluca', '', 3, 'Rejected', '');
INSERT INTO SpecialPermissionRequests VALUES (2, 12, 'jdoe', 'admin', TO_DATE('01/01/2016', 'MM/DD/YYYY'), 6, 'Approved', '');
INSERT INTO SpecialPermissionRequests VALUES (2, 8, 'garadhy', 'admin', '', 3, 'In Process', '');
INSERT INTO SpecialPermissionRequests VALUES (2, 16, 'kprabhu', 'admin', '', 6, 'Rejected', '');
INSERT INTO SpecialPermissionRequests VALUES (2, 20, 'asupeka', 'kmluca', TO_DATE('01/12/2016', 'MM/DD/YYYY'), 3, 'Approved', '');


-- Prerequisites (CourseOfferingID, courseID, deptID, gpa, mandatory)

INSERT INTO Prerequisites VALUES (1, 505, 'CSC', 0.00, 0);
INSERT INTO Prerequisites VALUES (11, NULL, '', 3.00, 0);

INSERT INTO Prerequisites VALUES (24, 401, 'CSC', 0.00, 0);
INSERT INTO Prerequisites VALUES (27, 520, 'CSC', 3.5, 0);
INSERT INTO Prerequisites VALUES (29, 515, 'CSC', 0.00, 0);
INSERT INTO Prerequisites VALUES (30, 420, 'ECE', 0.00, 0);

COMMIT;