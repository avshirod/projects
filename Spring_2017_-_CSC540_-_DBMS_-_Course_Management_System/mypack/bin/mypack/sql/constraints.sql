-- Uniqueness constraints
ALTER TABLE Students
ADD CONSTRAINT unique_studentID             UNIQUE(studentID);

ALTER TABLE Employee
ADD CONSTRAINT unique_ssn                   UNIQUE(ssn);

ALTER TABLE Faculty
ADD CONSTRAINT unique_facultyID             UNIQUE(facultyID);

ALTER TABLE Admin
ADD CONSTRAINT unique_adminID               UNIQUE(adminID);

ALTER TABLE CourseOffering
ADD CONSTRAINT unique_courseOfferingID      UNIQUE(courseOfferingID);

ALTER TABLE CreditRequirements
ADD CONSTRAINT unique_creditRequirements    UNIQUE(creditReqID);

ALTER TABLE Semester
ADD CONSTRAINT unique_semesterID            UNIQUE(semesterID);

-- Foreign Key constraints

ALTER TABLE Students
ADD FOREIGN KEY (unityID)       REFERENCES UnityUsers(unityID) ON DELETE CASCADE;
ALTER TABLE Students    
ADD FOREIGN KEY (deptID)        REFERENCES Department(deptID) ON DELETE SET NULL;
ALTER TABLE Students
ADD FOREIGN KEY (creditReqID)   REFERENCES CreditRequirements(creditReqID) ON DELETE SET NULL;

ALTER TABLE Employee
ADD FOREIGN KEY (unityID)       REFERENCES UnityUsers(unityID) ON DELETE CASCADE;

ALTER TABLE Faculty
ADD FOREIGN KEY (unityID) 	    REFERENCES Employee(unityID) ON DELETE CASCADE;
ALTER TABLE Faculty
ADD FOREIGN KEY (deptID) 	    REFERENCES Department(deptID) ON DELETE SET NULL;

ALTER TABLE Admin
ADD FOREIGN KEY (unityID)       REFERENCES Employee(unityID) ON DELETE CASCADE;

ALTER TABLE Course
ADD FOREIGN KEY (deptID)        REFERENCES Department(deptID) ON DELETE SET NULL;

ALTER TABLE CourseOffering
ADD FOREIGN KEY (courseID, deptID) 	REFERENCES Course(courseID, deptID) ON DELETE SET NULL;
ALTER TABLE CourseOffering
ADD FOREIGN KEY (semesterID)        REFERENCES Semester(semesterID) ON DELETE SET NULL;

ALTER TABLE Billing
ADD FOREIGN KEY (unityID)       REFERENCES Students(unityID) ON DELETE CASCADE;

ALTER TABLE PermissionMapping
ADD FOREIGN KEY (specialPermissionID) 	REFERENCES SpecialPermissions(specialPermissionID) ON DELETE SET NULL;
ALTER TABLE PermissionMapping
ADD FOREIGN KEY (courseOfferingID) 		REFERENCES CourseOffering(courseOfferingID) ON DELETE CASCADE;

ALTER TABLE Transcript
ADD FOREIGN KEY (unityID) 			REFERENCES Students(unityID) ON DELETE CASCADE;
ALTER TABLE Transcript
ADD FOREIGN KEY (courseOfferingID) 	REFERENCES courseOffering(courseOfferingID) ON DELETE SET NULL;

ALTER TABLE Facilitates
ADD FOREIGN KEY (courseOfferingID) 	REFERENCES courseOffering(courseOfferingID) ON DELETE CASCADE;
ALTER TABLE Facilitates
ADD FOREIGN KEY (facultyID) 		REFERENCES Faculty(unityID) ON DELETE CASCADE;

ALTER TABLE Waitlist
ADD FOREIGN KEY (unityID) 			REFERENCES Students(unityID) ON DELETE CASCADE;
ALTER TABLE Waitlist
ADD FOREIGN KEY (courseOfferingID)	REFERENCES CourseOffering(courseOfferingID) ON DELETE CASCADE;
ALTER TABLE Waitlist
ADD FOREIGN KEY (overloadDropCOID)  REFERENCES CourseOffering(courseOfferingID) ON DELETE SET NULL;

ALTER TABLE BillingRate
ADD FOREIGN KEY (semesterID) 	    REFERENCES Semester(semesterID) ON DELETE SET NULL;
ALTER TABLE BillingRate
ADD FOREIGN KEY (creditReqID) 	    REFERENCES CreditRequirements(creditReqID) ON DELETE SET NULL;

ALTER TABLE SpecialPermissionRequests
ADD FOREIGN KEY (specialPermissionID, courseOfferingID) 	REFERENCES PermissionMapping(specialPermissionID, courseOfferingID) ON DELETE CASCADE;
ALTER TABLE SpecialPermissionRequests
ADD FOREIGN KEY (unityID)				REFERENCES Students(unityID) ON DELETE CASCADE;
ALTER TABLE SpecialPermissionRequests
ADD FOREIGN KEY (approvalBy)			REFERENCES Admin(unityID) ON DELETE SET NULL;

ALTER TABLE Prerequisites
ADD FOREIGN KEY (courseOfferingID)      REFERENCES CourseOffering(courseOfferingID) ON DELETE CASCADE;
ALTER TABLE Prerequisites
ADD FOREIGN KEY (courseID, deptID)      REFERENCES Course(courseID, deptID) ON DELETE SET NULL;


-- Data entry constraints

ALTER TABLE Students
ADD CONSTRAINT val_StudReslvl CHECK (residencyLevel IN (1,2,3));
ALTER TABLE Students
ADD CONSTRAINT val_StudPartLvl CHECK (participationLevel IN (1,2)); -- 1=Undergraduate 2=Graduate

ALTER TABLE Course
ADD CONSTRAINT chk_credit CHECK (minCredits >= 1 AND (maxCredits >= minCredits));
ALTER TABLE Course
ADD CONSTRAINT val_CrsPartiLvl CHECK (participationLevel IN (1,2));

ALTER TABLE CourseOffering
ADD CONSTRAINT val_classDays CHECK (classDays BETWEEN 1 AND 9); 
ALTER TABLE CourseOffering
ADD CONSTRAINT chk_seatsAvlbl CHECK (seatsAvailable <= totalSeatsOffered);

ALTER TABLE CreditRequirements
ADD CONSTRAINT chk_CredReq_credit CHECK (minCreditReq >= 0 AND maxCreditReq >= minCreditReq);
ALTER TABLE CreditRequirements
ADD CONSTRAINT val_CredReqPartiLvl CHECK (participationLevel IN (1,2));
ALTER TABLE CreditRequirements
ADD CONSTRAINT val_CredReqResiLvl CHECK (residencyLevel IN (1,2,3));

ALTER TABLE Semester
ADD CONSTRAINT chk_dates CHECK ((dropDate >= addDate) AND (semEndDate >= semStartDate));

ALTER TABLE Transcript
ADD CONSTRAINT val_Transc_grade CHECK (courseGrade IN ('A+', 'A', 'A-', 'B+', 'B', 'B-', 'C+', 'C', 'C-', 'F', 'S', 'U', 'AU', 'INC', 'PROG'));
ALTER TABLE Transcript
ADD CONSTRAINT val_creditHoursTaken CHECK (creditHoursTaken >= 1);

ALTER TABLE Prerequisites
ADD CONSTRAINT val_PreReq_grade CHECK (gpa BETWEEN 0.00 AND 4.334);


-- Sequences (Auto Increments)

CREATE SEQUENCE seq_courseOffering;
CREATE OR REPLACE TRIGGER insert_courseOffering
BEFORE INSERT ON CourseOffering
FOR EACH ROW
BEGIN
    SELECT seq_courseOffering.NEXTVAL INTO :new.courseOfferingID from dual;
END;
/

CREATE SEQUENCE seq_billing;
CREATE OR REPLACE TRIGGER insert_billing
BEFORE INSERT ON Billing
FOR EACH ROW
BEGIN
    SELECT seq_billing.NEXTVAL INTO :new.billID from dual;
END;
/

CREATE SEQUENCE seq_semesterID;
CREATE OR REPLACE TRIGGER insert_semester
BEFORE INSERT ON Semester
FOR EACH ROW
BEGIN
    SELECT seq_semesterID.NEXTVAL INTO :new.semesterID from dual;
END;
/

CREATE SEQUENCE seq_spPermReq;
CREATE OR REPLACE TRIGGER insert_spPermReq
BEFORE INSERT ON SpecialPermissionRequests
FOR EACH ROW
BEGIN
    SELECT seq_spPermReq.NEXTVAL INTO :new.specialPermReqID from dual;
END;
/


-- Static variables for the database
CREATE OR REPLACE PACKAGE constants
AS
PROCEDURE get_constants;
current_semID NUMBER := 3;
END constants;
/

CREATE OR REPLACE FUNCTION currentSemID
RETURN NUMBER
IS
BEGIN
RETURN constants.current_semID;
END;
/

-- Output Formatting

SET SERVEROUTPUT ON;
SET LINESIZE 200;
SET PAGESIZE 50;