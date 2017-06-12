--students table

CREATE TABLE Students
( 
studentID NUMBER(9),
deptID NUMBER(),
overallGPA NUMBER(4,3),
residencyLevel NUMBER(1),
participationLevel NUMBER(1),
yearEnrolled NUMBER(4)
);

--course table	

CREATE TABLE Course
(
	courseID NUMBER(3),
	sectionID NUMBER(3),
	title VARCHAR(5),
maxCredits  NUMBER(1),
	minCredits NUMBER(1),
	particpationLevel NUMBER(1)
);

--billing table

CREATE TABLE Billing
(
	billID NUMBER(),
	studentID NUMBER(9),
	billAmount NUMBER(),
	dueDate DATE(),
	outstandingAmount VARCHAR()
);

--credit requirements table

CREATE TABLE creditRequirements
(
	creditReqID NUMBER(1),
	particpationLevel NUMBER(1),
	residenceLevel NUMBER(1),
	maxCreditReq NUMBER(2),
	minCreditReq NUMBER(1)
);

-- UnityUsers Table

CREATE TABLE UnityUsers 
(
unityID VARCHAR2(8), 
fname VARCHAR2(25) NOT NULL,
lname VARCHAR2(25) NOT NULL,
email VARCHAR(30),
gender VARCHAR2(2),
dateOfBirth DATE,
address VARCHAR2(50),
phone NUMBER(10),
userType NUMBER(1),
Password VARCHAR2(15)
);

-- Employee Table

CREATE TABLE Employee
(
	ssn NUMBER(9)
);

-- Faculty Table

CREATE TABLE Faculty
(
facultyID VARCHAR2(10),
deptID VARCHAR2(5)
);

-- Admin Table

CREATE TABLE Admin
(
	adminID VARCHAR2(10)
);

-- Semester Table

CREATE TABLE Semester
(
	semesterID NUMBER(5),
	season VARCHAR2(6),
	year NUMBER(4),
	addDate DATE,
	dropDate DATE,
	semStartDate DATE,
	semEndDate DATE
);

-- Department Table

CREATE TABLE Departments
(
	deptID VARCHAR2(5),
	deptName VARCHAR(20)
);

--permission mapping table

CREATE TABLE permissionMapping
(
	specialPermissionID NUMBER(),
	courseOfferingID NUMBER()	
);

--special permissions table

CREATE TABLE specialPermissions
(
	specialPermissionID NUMBER(),
	specialPermissionCodes VARCHAR()
);

--course offering table

CREATE TABLE courseOffering
(
	courseOfferingID NUMBER(),
	courseID NUMBER(3),
	sectionID NUMBER(1),
	semesterID NUMBER(5),
	classDays NUMBER(2),
	startTime VARCHAR(4),
	endTime VARCHAR(4),
	location VARCHAR(9),
	totalSeatsOffered NUMBER(2),
	seatsAvailable NUMBER(2),
	waitListLimit NUMBER(2)
);

CREATE TABLE Transcript
(
	studentID NUMBER(9),
	courseOfferingID NUMBER(),
	creditHoursTaken NUMBER(1),
	courseGrade VARCHAR(2)
);

CREATE TABLE Facilitates
(
	courseOfferingID NUMBER(),
	facultyID VARCHAR2(10)
);

CREATE TABLE Billing_Rate
(
	semesterID NUMBER(5),
	billingRate NUMBER()
);

CREATE TABLE Special_Permission_Requests
(
	specialPermissionID NUMBER(),
	courseOfferingID NUMBER(),
	studentID NUMBER(9),
	approvalBy VARCHAR2(25),
	approvalDate DATE,
	numberOfUnits NUMBER(1),
	approvalStatus VARCHAR2(20)
);

CREATE TABLE Prerequisites
(
	courseOfferingID NUMBER(),
	courseID NUMBER(3),
	grade NUMBER(4,3)
);
