-- Drop all tables to be created below to avoid errors
DROP TABLE UnityUsers CASCADE CONSTRAINTS;
DROP TABLE Students CASCADE CONSTRAINTS;
DROP TABLE Employee CASCADE CONSTRAINTS;
DROP TABLE Faculty CASCADE CONSTRAINTS;
DROP TABLE Admin CASCADE CONSTRAINTS;
DROP TABLE Department CASCADE CONSTRAINTS;
DROP TABLE Course CASCADE CONSTRAINTS;
DROP TABLE CourseOffering CASCADE CONSTRAINTS;
DROP TABLE Semester CASCADE CONSTRAINTS;
DROP TABLE CreditRequirements CASCADE CONSTRAINTS;
DROP TABLE Billing CASCADE CONSTRAINTS;
DROP TABLE BillingRate CASCADE CONSTRAINTS;
DROP TABLE PermissionMapping CASCADE CONSTRAINTS;
DROP TABLE SpecialPermissions CASCADE CONSTRAINTS;
DROP TABLE Transcript CASCADE CONSTRAINTS;
DROP TABLE Facilitates CASCADE CONSTRAINTS;
DROP TABLE WaitList CASCADE CONSTRAINTS;
DROP TABLE SpecialPermissionRequests CASCADE CONSTRAINTS;
DROP TABLE Prerequisites CASCADE CONSTRAINTS;

-- UnityUsers Table

CREATE TABLE UnityUsers 
(
    unityID 	VARCHAR2(8), 
    fname 		VARCHAR2(25) NOT NULL,
    lname 		VARCHAR2(25) NOT NULL,
    email 		VARCHAR(30),
    gender 		VARCHAR2(2),
    dateOfBirth DATE,
    address 	VARCHAR2(50),
    phone 		VARCHAR2(10),
    userType 	NUMBER(1) 	 NOT NULL,
    password 	VARCHAR2(15) NOT NULL,
	PRIMARY KEY (unityID)
);

-- Students table

CREATE TABLE Students
(
	unityID 		VARCHAR2(8),
    studentID 		VARCHAR2(9),
    deptID 			VARCHAR2(5),
    overallGPA 		NUMBER(4,3),
    participationLevel NUMBER(1),
    residencyLevel 	NUMBER(1),
    yearEnrolled 	NUMBER(4),
	creditReqID		NUMBER(1),
	PRIMARY KEY (unityID)
);

-- Employee Table

CREATE TABLE Employee
(
	unityID VARCHAR2(8),
	ssn 	VARCHAR2(9),
	PRIMARY KEY (unityID)
);

-- Faculty Table

CREATE TABLE Faculty
(
	unityID 	VARCHAR2(8),
    facultyID 	VARCHAR2(9),
    deptID 		VARCHAR2(5),
	PRIMARY KEY (unityID)
);

-- Admin Table

CREATE TABLE Admin
(
	unityID VARCHAR2(8),
	adminID VARCHAR2(9),
	PRIMARY KEY (unityID)
);

-- Department Table

CREATE TABLE Department
(
	deptID 		VARCHAR2(5),
	deptName 	VARCHAR2(50),
	PRIMARY KEY (deptID)
);

-- Course table

CREATE TABLE Course
(
	courseID 			NUMBER(3),
	deptID				VARCHAR2(5),
	title 				VARCHAR2(50),
    maxCredits  		NUMBER(2),
	minCredits 			NUMBER(1),
	participationLevel 	NUMBER(1),
	PRIMARY KEY (courseID, deptID)
);

-- Course Offering table

CREATE TABLE CourseOffering
(
	courseOfferingID 	NUMBER,
	courseID 			NUMBER(3),
	sectionID 			NUMBER(3),
	deptID				VARCHAR2(5),
	semesterID 			NUMBER(5),
	classDays 			NUMBER(2),
	startTime 			NUMBER(6),
	endTime 			NUMBER(6),
	location 			VARCHAR2(50),
	totalSeatsOffered 	NUMBER(3),
	seatsAvailable 		NUMBER(3),
	waitListLimit 		NUMBER(2),
	gpaRequirement		NUMBER(4,3),
	PRIMARY KEY (courseID, sectionID, deptID, semesterID)
);

-- Semester Table

CREATE TABLE Semester
(
	semesterID 		NUMBER(5),
	season 			VARCHAR2(6),
	year 			NUMBER(4),
	addDate 		DATE,
	dropDate 		DATE,
	semStartDate 	DATE,
	semEndDate 		DATE,
	PRIMARY KEY (season, year)
);

-- Credit Requirements table

CREATE TABLE CreditRequirements
(
	creditReqID 		NUMBER(1),
	participationLevel 	NUMBER(1),
	residencyLevel 		NUMBER(1),
	maxCreditReq 		NUMBER(2),
	minCreditReq 		NUMBER(1),
	PRIMARY KEY (participationLevel, residencyLevel)
);

-- Billing table

CREATE TABLE Billing
(
	billID 				NUMBER,
	unityID 			VARCHAR2(8),
	billAmount 			NUMBER,
	dueDate 			DATE,
	outstandingAmount 	NUMBER,
	PRIMARY KEY (billID)
);

-- Billing Rate attribute table

CREATE TABLE BillingRate
(
	semesterID 	NUMBER(5),
	creditReqID NUMBER(1),
	billingRate NUMBER
);

-- Permission Mapping table

CREATE TABLE PermissionMapping
(
	specialPermissionID NUMBER,
	courseOfferingID 	NUMBER,
	PRIMARY KEY (specialPermissionID, courseOfferingID)
);

-- Special Permissions table

CREATE TABLE SpecialPermissions
(
	specialPermissionID 	NUMBER,
	specialPermissionCodes 	VARCHAR2(30),
	PRIMARY KEY (specialPermissionID)
);

-- Transcript attribute table

CREATE TABLE Transcript
(
	unityID 			VARCHAR2(8),
	courseOfferingID 	NUMBER,
	creditHoursTaken 	NUMBER(1),
	courseGrade 		VARCHAR2(5),
	PRIMARY KEY (unityID, courseOfferingID)
);

-- Facilitates attribute table

CREATE TABLE Facilitates
(
	courseOfferingID 	NUMBER,
	facultyID 			VARCHAR2(8)
);

-- WaitList attribute table

CREATE TABLE Waitlist
(
	unityID				VARCHAR2(8),
	courseOfferingID	NUMBER,
	waitlistPosition	NUMBER,
	overloadDropCOID	NUMBER,
	PRIMARY KEY (unityID, courseOfferingID)
);

-- Special Permission Requests attribute table

CREATE TABLE SpecialPermissionRequests
(
	specialPermReqID	NUMBER,
	specialPermissionID NUMBER,
	courseOfferingID 	NUMBER,
	unityID 			VARCHAR2(8),
	approvalBy 			VARCHAR2(8),
	approvalDate 		DATE,
	numberOfUnits 		NUMBER(1),
	approvalStatus 		VARCHAR2(20),
	comments			VARCHAR2(200),
	PRIMARY KEY (specialPermReqID)
);

-- Prerequisite attribute table

CREATE TABLE Prerequisites
(
	courseOfferingID 	NUMBER,
	courseID 			NUMBER(3),
	deptID 				VARCHAR2(5),
	gpa 				NUMBER(4,3),
	mandatory			NUMBER(1)
);