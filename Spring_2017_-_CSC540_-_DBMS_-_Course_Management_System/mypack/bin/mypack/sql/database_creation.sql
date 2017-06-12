-- Delete all user objects using this procedure

BEGIN
    FOR cur_rec IN (
        SELECT object_name, object_type
        FROM user_objects
        WHERE object_type IN ('TABLE', 'VIEW', 'PACKAGE', 'PROCEDURE', 'FUNCTION', 'SEQUENCE')
    )
    LOOP
    BEGIN
        IF cur_rec.object_type = 'TABLE' THEN
            EXECUTE IMMEDIATE 'DROP ' || cur_rec.object_type || ' "' || cur_rec.object_name || '" CASCADE CONSTRAINTS';
        ELSE
            EXECUTE IMMEDIATE 'DROP ' || cur_rec.object_type || ' "' || cur_rec.object_name || '"';
        END IF;
        EXCEPTION
        WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('FAILED: DROP ' || cur_rec.object_type || ' "' || cur_rec.object_name || '"' );
    END;
    END LOOP;
END;
/

/*
BEGIN
    -- Dropping Tables
    FOR i in (select 'DROP TABLE ' || table_name || ' CASCADE CONSTRAINTS' tbl from user_tables) 
    loop
        EXECUTE immediate i.tbl;
    END loop;
    
    -- Dropping Sequences
    FOR i in (select 'DROP SEQUENCE ' || sequence_name || '' seq from user_sequences) 
    loop
        EXECUTE immediate i.seq;
    END loop;

    -- Dropping Triggers
    FOR i in (select 'DROP TRIGGER ' || trigger_name || '' trig from user_triggers) 
    loop
        EXECUTE immediate i.trig;
    END loop;

    -- Dropping Procedures
    FOR i in (select 'DROP PROCEDURE ' || object_name || '' proc from user_procedures) 
    loop
        EXECUTE immediate i.proc;
    END loop;
END;
/
*/



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
	specialPermissionID NUMBER,
	courseOfferingID 	NUMBER,
	unityID 			VARCHAR2(8),
	approvalBy 			VARCHAR2(8),
	approvalDate 		DATE,
	numberOfUnits 		NUMBER(1),
	approvalStatus 		VARCHAR2(20),
	comments			VARCHAR2(200)
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

-- Mapping Grade to GPA

set serveroutput on;

CREATE OR REPLACE PROCEDURE GPA_MAPPING(
	grade IN Transcript.coursegrade%type,
	mapped_val OUT number
)
IS
	type map_varchar is table of number index by varchar2(30);
	l map_varchar;
begin
	l('A+') := 4.33;
	l('A') 	:= 4.00;
	l('A-') := 3.67;
	l('B+') := 3.33;
	l('B') 	:= 3.00;
	l('B-') := 2.67;
	l('C+') := 2.33;
	l('C') 	:= 2.00;
	l('C-') := 1.67;
	l('S')	:= 4.00;
	l('U')  := 0.00;
	l('AU') := 4.00;
	l('PROG') := 0.00;
	mapped_val:=l(grade);
end;
/
-- show err

-- Procedure to see if a user unityID exists in the system

SET SERVEROUTPUT ON;

-- Returns 0 if user does not exist, else returns 1

CREATE OR REPLACE PROCEDURE proc_ExistUser(
    l_unityID IN UnityUsers.unityID%TYPE,
    userExist OUT NUMBER
)
IS
BEGIN

    SELECT COUNT(*) INTO userExist
    FROM UnityUsers u
    WHERE u.unityID = l_unityID;

    RETURN;
END;
/

-- Prints the result; no value is returned

CREATE OR REPLACE PROCEDURE proc_VerifyUser(
    l_unityID IN UnityUsers.unityID%TYPE
)
IS
    userExist NUMBER;
BEGIN
    proc_ExistUser(l_unityID, userExist);

    IF userExist = 0 THEN
        DBMS_OUTPUT.PUT_LINE(l_unityID || CHR(9) || 'This user does not exist in the system. Contact Admin.');
    ELSE
        DBMS_OUTPUT.PUT_LINE(l_unityID || CHR(9) || 'User Exists.');
    END IF;
END;
/

-- See if user exists, and password matches

create or replace procedure proc_CheckLogin
(
    p_username IN UnityUsers.unityID%type,
    p_password IN UnityUsers.Password%type,
    p_message out NUMBER
)
is
begin
    select count(*) into p_message 
    from UnityUsers 
    where unityID=p_username and Password=p_password;
    
    EXCEPTION 
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Some Exception occured. Try again.');
            DBMS_OUTPUT.PUT_LINE('Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200));
            p_message := 'Some Exception occured. Try again.' || CHR(10) || 'Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200);
    RETURN;
end;
/

-----------newstudent------------------

SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE newStudent(
	unity_id IN Students.unityID%type,
	student_id IN Students.studentID%type,
	dept_id IN Students.deptID%type,
	residency_level IN Students.residencyLevel%type,
	participation_level IN Students.participationLevel%type,
	year_enrolled IN Students.yearEnrolled%type,
	success OUT VARCHAR2
)

IS
	credit_req_id 	Students.creditReqID%TYPE;
	existsUser 		NUMBER;
	unityUserType 	NUMBER;
BEGIN
	proc_ExistUser(unity_id, existsUser);

	IF existsUser = 0 THEN
		DBMS_OUTPUT.PUT_LINE('This Unity User does not exist. Please create a new Unity User profile first.');
		success := 'This Unity User does not exist. Please create a new Unity User profile first.';
		RETURN;
	END IF;
	
	SELECT creditReqID into credit_req_id
	FROM CreditRequirements
	WHERE participationLevel=participation_level AND residencyLevel=residency_level;

	SELECT userType into unityUserType
	FROM UnityUsers u
	WHERE u.unityID = unity_id;

	IF unityUserType != 3 THEN
		DBMS_OUTPUT.PUT_LINE('This Unity User is not a Student. Please check the UnityID entered.');
		success := 'This Unity User is not a Student. Please check the UnityID entered.';
		RETURN;
	END IF;
	
	INSERT INTO Students(unityID, studentID, deptID, residencyLevel, participationLevel, yearEnrolled, creditReqID)
	VALUES (unity_id, student_id, dept_id, residency_level, participation_level, year_enrolled, credit_req_id);
	
	success:='Student Record Created Successfully.';
commit;

EXCEPTION 
        WHEN OTHERS THEN
            --DBMS_OUTPUT.PUT_LINE('Some Exception occured. Try again.');
            --DBMS_OUTPUT.PUT_LINE('Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200));
            success := 'Some Exception occured. Try again.' || CHR(10) || 'Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200);
        RETURN;
END;
/

----------------------

-- Drop Course 'courseOfferingID' for 'unityID'
-- EXEC DropCourse(unityID, courseOfferingID)

SET SERVEROUTPUT ON;
SET AUTOCOMMIT OFF;

CREATE OR REPLACE PROCEDURE proc_DropCourse(
	student_id 			IN Students.unityID%type,
	courseoffering_id 	IN Courseoffering.courseOfferingID%type,
	success 			OUT VARCHAR2
)
IS
 	l_dropDate 			DATE;
	l_todaysDate 		DATE := trunc(SYSDATE);
	temp 				number;
	temp_op_string		varchar2(100);
	l_waitlist_unityID 	Waitlist.UnityID%TYPE;
	l_maxcred			number;
	l_waitlist_dropCOID Waitlist.overloadDropCOID%TYPE;

BEGIN
	-- Find out Drop Date for current semester (will be last entry in Semester table)
	select dropDate into l_dropDate
	from ( select * from semester order by semesterID desc)
	where rownum = 1;

	-- If DropDate has not passed
	IF (l_dropDate >= l_todaysDate)	THEN

		-- Find if the student is enrolled in that course
		SELECT count(*) into temp FROM Transcript 
		WHERE courseoffering_id = Transcript.courseOfferingID 
		AND student_id = Transcript.unityID;

		if (temp=0)
		then
			-- Student is not enrolled in mentioned course in ongoing semester
			DBMS_output.put_line('Course not found');
			success := 'Course not found';
		else
	
			Delete from Transcript
			where courseoffering_id = Transcript.courseOfferingID 
			AND student_id = Transcript.unityID;
			
			DBMS_output.put_line('Course dropped.');
			success := 'Course dropped.';
			
			update courseoffering
			set seatsAvailable = least(seatsAvailable + 1, totalSeatsOffered)
			where courseofferingID = courseoffering_id;

			commit;

			-- Update waitlist positions
			update waitlist
			set waitlistPosition = waitlistPosition - 1
			where courseOfferingID = courseoffering_id;

			select count(*) into temp 
			from Waitlist w
			where w.waitlistPosition = 0
			and w.courseOfferingID = courseoffering_id;

			-- If there is a student on waitlist for this course on position 0, enroll that student
			if temp=1 then

				-- Get maxCredits for this course
				SELECT maxCredits into l_maxcred 
				from Course c, CourseOffering co
				where co.courseOfferingID = courseoffering_id 
				and c.courseID = co.courseID and c.deptID = co.deptID;

				SELECT w.unityID, w.overloadDropCOID 
				into l_waitlist_unityID ,l_waitlist_dropCOID
				FROM Waitlist w
				WHERE w.courseOfferingID = courseoffering_id
				and w.waitlistposition = 0;

				-- Drop the courseOffering mentioned in wailisted student in case of overload
				IF l_waitlist_dropCOID <> null THEN
					proc_DropCourse(l_waitlist_unityID, l_waitlist_dropCOID, temp_op_string);
				END IF;

				-- Update transcript of this waitlisted student
				-- We do not need to check if all the requirements are satisfied, as that was done when the student was added onto waitlist
				INSERT into transcript(unityID, courseOfferingID, creditHoursTaken) 
				values (l_waitlist_unityID, courseoffering_id, l_maxcred);

				-- Remove this enrolled student from waitlist		
				delete from Waitlist w 
				where waitlistPosition = 0 
				AND w.courseOfferingID =courseoffering_id ;
				
				commit;

				DBMS_output.put_line('Enrolled a student from waitlist.');

			end if;

		end if;

	else
		DBMS_output.put_line('Drop date has passed. Cannot drop course.');
		success := 'Drop date has passed. Cannot drop course.';
	end if;
	
	EXCEPTION 
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE('Some Exception occured. Try again.');
			DBMS_OUTPUT.PUT_LINE('Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200));
			success := 'Some Exception occured. Try again.' || CHR(10) || 'Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200);
        RETURN;
end;
/

------------

CREATE OR REPLACE PROCEDURE proc_ViewCourseOfferings(
    l_return OUT SYS_REFCURSOR
)
IS
	semester_id CourseOffering.semesterID%TYPE := constants.current_semID;
BEGIN
    OPEN l_return FOR 
        SELECT cs.courseOfferingID, c.title, to_char(to_date(cs.starttime,'sssss'),'hh24:mi'), to_char(to_date(cs.endtime,'sssss'),'hh24:mi'), cs.totalSeatsOffered, cs.seatsAvailable
        FROM CourseOffering cs, Course c
        where cs.courseID=c.courseID and cs.deptID = c.deptID and cs.semesterID=semester_id;
END;
/

CREATE OR REPLACE PROCEDURE proc_ViewAllCourseOfferings(
    l_return OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN l_return FOR 
        SELECT cs.courseOfferingID, c.title, to_char(to_date(cs.starttime,'sssss'),'hh24:mi'), to_char(to_date(cs.endtime,'sssss'),'hh24:mi'), cs.totalSeatsOffered, cs.seatsAvailable
        FROM CourseOffering cs, Course c
        where cs.courseID=c.courseID and cs.deptID = c.deptID;
END;
/

------------

CREATE OR REPLACE PROCEDURE proc_ViewCourses(
    l_return OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN l_return FOR SELECT *
    FROM Course c;
END;
/

--------------

-- Get details for a unity user with unityID

CREATE OR REPLACE PROCEDURE proc_GetProfileData(
    unity_id    IN UnityUsers.unityID%TYPE,
    l_cursor OUT SYS_REFCURSOR 
)

IS

BEGIN
	OPEN l_cursor for SELECT u.unityID, u.fname, u.lname, u.email, u.gender, u.dateOfBirth, u.address, u.phone
	FROM UnityUsers u
	where u.unityID=unity_id;

    EXCEPTION 
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Some Exception occured. Try again.');
            DBMS_OUTPUT.PUT_LINE('Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200));
            --success := 'Some Exception occured. Try again.' || CHR(10) || 'Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200);
        RETURN;
END;
/

--------------

set serveroutput ON;

CREATE OR REPLACE PROCEDURE proc_EnrollCourse(
    unity_id            IN Students.unityID%TYPE,
    courseOffering_id   IN CourseOffering.courseOfferingID%TYPE,
    credit_hours        IN TRANSCRIPT.creditHoursTaken%TYPE,
    overload_dropcourse IN Waitlist.overloadDropCOID%TYPE,
    success             OUT VARCHAR2
    -- add_waitlist     IN NUMBER(1),
)

IS
    already_registered          NUMBER(1) := 0;
    participation_level_student Students.participationLevel%TYPE;
    participation_level_course  Students.participationLevel%TYPE;
    student_gpa                 Students.overallGPA%TYPE;
    min_credits                 Course.minCredits%TYPE;
    max_credits                 Course.maxCredits%TYPE;
    course_availability         CourseOffering.seatsAvailable%TYPE;
    gpa_requirement             CourseOffering.gpaRequirement%TYPE;
    course_id                   Course.courseID%TYPE;
    dept_id                     Course.deptID%TYPE;
    waitlist_limit              CourseOffering.waitListLimit%TYPE;
    waitlisted_students         NUMBER;
    semester_id                 CourseOffering.semesterID%TYPE;
    class_days                  CourseOffering.classDays%TYPE;
    class_startTime             CourseOffering.startTime%TYPE;
    class_endTime               CourseOffering.endTime%TYPE;
    total_credits_taken_transcript NUMBER := 0;
    total_credits_taken_waitlist NUMBER := 0;
    residency_level             Students.residencyLevel%TYPE;
    max_allowed_credit          NUMBER;
    current_semID               NUMBER := constants.current_semID;
    special_permission_req      NUMBER := 0;
    prerequisite_satisfied      NUMBER;
    other_special_perms         NUMBER := 0;
    temp_var                    NUMBER;
    existUser                   NUMBER;
    temp_gpa                    NUMBER;

BEGIN

    DBMS_OUTPUT.PUT_LINE(CHR(9));

    FOR cursor0 IN (
        SELECT co.deptID, co.courseID, s.season, s.year, c.title
        FROM CourseOffering co, Semester s, course c
		WHERE co.courseOfferingID = courseOffering_id
		AND co.semesterID = s.semesterID
		AND c.courseID = co.courseID AND c.deptID = co.deptID
    )
    LOOP
		DBMS_OUTPUT.PUT_LINE('Trying to enroll ' || unity_id || ' into ' || cursor0.courseID || ' ' || cursor0.deptID ||
							' (' || cursor0.season || ' ' || cursor0.year || ') - ' || cursor0.title);
	END LOOP;

    proc_ExistUser(unity_id, existUser);
    IF existUser = 0 THEN
        DBMS_OUTPUT.PUT_LINE('"' || unity_id || '" does not exist in the system. Contact Admin.');
        success := 'Student does not exist in the system. Contact Admin.';
        RETURN;
    END IF;

    -- See if student is already enrolled ( or has taken previously) into the course
    SELECT count(*) INTO already_registered
    FROM Transcript t
    WHERE t.unityID=unity_id AND t.courseOfferingID=courseOffering_id;

    IF (already_registered < 1) THEN

        SELECT co.courseID, co.deptID, co.seatsAvailable, co.waitListLimit, co.semesterID , co.gpaRequirement, co.classDays, co.startTime, co.endTime
        into course_id, dept_id, course_availability, waitlist_limit, semester_id, gpa_requirement, class_days, class_startTime, class_endTime
        FROM CourseOffering co
        WHERE co.courseOfferingID = courseOffering_id;

        -- Trying to enroll into a course from previous semester
        IF semester_id < current_semID THEN
            DBMS_OUTPUT.PUT_LINE('Course from previous semesters.');
            success := 'Course from previous semesters.';
            RETURN;
        END IF;

        SELECT participationLevel, residencyLevel, overallGPA INTO participation_level_student, residency_level, student_gpa
        FROM Students
        WHERE unityID=unity_id;

        SELECT participationLevel, minCredits, maxCredits INTO participation_level_course, min_credits, max_credits
        FROM Course
        WHERE courseID=course_id and deptID = dept_id;


        select count(*) into temp_var
        FROM Transcript t, CourseOffering s
        WHERE t.unityID=unity_id and t.courseOfferingID=s.courseOfferingID and s.semesterid=semester_id;

        if temp_var != 0 then        
            select SUM(t.creditHoursTaken) into total_credits_taken_transcript
            FROM Transcript t, CourseOffering s
            WHERE t.unityID=unity_id and t.courseOfferingID=s.courseOfferingID and s.semesterID=semester_id;
        else
            total_credits_taken_transcript := 0;
        end if;


        select count(*) into temp_var
        from Waitlist w, CourseOffering s
        where w.unityID=unity_id and w.courseOfferingID=s.courseOfferingID;
        
        if temp_var != 0 then
            select SUM(c.maxcredits) into total_credits_taken_waitlist
            FROM Waitlist w, CourseOffering s, Course c
            WHERE w.unityID=unity_id and w.courseOfferingID=s.courseOfferingID and s.semesterID=semester_id
            and c.courseID=s.courseID and c.deptID = s.deptID;
        else
            total_credits_taken_waitlist := 0;
        end if;


        select maxCreditReq into max_allowed_credit
        FROM CreditRequirements
        WHERE participation_level_student=participationLevel and residency_level=residencyLevel;

        SELECT COUNT(*) INTO special_permission_req
        FROM PermissionMapping pm
        WHERE pm.courseOfferingID = courseOffering_id;

        
        -- If participationLevel of student is different fromt the course
        IF (participation_level_student != participation_level_course) THEN
            DBMS_OUTPUT.PUT_LINE('Participation level mismatched.');
            success := 'Participation level mismatched.';
            RETURN;
        END IF;

        -- If creditHours requested are not within [minCredits, maxCredits], can't enroll
        IF ((credit_hours < min_credits) OR (credit_hours > max_credits)) THEN
            DBMS_OUTPUT.PUT_LINE('Incorrect credit hours.');
            success := 'Incorrect credit hours.';
            RETURN;
        END IF;

        -- If Special Permissions are required for the courseOffering, see if they are satisfied; if not then can't enroll
        IF special_permission_req > 0 THEN
            -- Check if Special Permission is PREREQ; if PREREQ is Satisfied, then continue; else can't enroll
            FOR prereq_course IN (
                SELECT p.courseID, p.deptID, p.mandatory, p.gpa
                FROM Prerequisites p
                WHERE p.courseOfferingID = courseOffering_id
            )
            LOOP
                IF prereq_course.mandatory = 1 THEN
                    SELECT COUNT(*) INTO prerequisite_satisfied
                    FROM Transcript t, CourseOffering co
                    WHERE t.unityID = unity_id
                    AND t.courseOfferingID = co.courseOfferingID
                    AND co.courseID = prereq_course.courseID
                    AND co.deptID = prereq_course.deptID;
                    -- AND gpa_mapping(t.courseGrade, temp_gpa) >= p.gpa;
                ELSE
                    prerequisite_satisfied := 1;
                    -- If Student GPA is below the required GPA, can't enroll
                    IF (student_gpa < gpa_requirement) THEN
                        DBMS_OUTPUT.PUT_LINE('Student GPA Below ' || gpa_requirement || '. Cannot enroll.');
                        success := 'Student GPA Below ' || gpa_requirement || '. Cannot enroll.';
                        RETURN;
                    END IF;
                END IF;

                -- prerequisite_satisfied = 0 means no course found in transcript, hence prereq not satisfied
                IF prerequisite_satisfied = 0 THEN
                    DBMS_OUTPUT.PUT_LINE('Prerequisites not satisfied.');
                    success := 'Prerequisites not satisfied.';
                    RETURN;
                END IF;
            END LOOP;

            -- If other Special Permissions are required, can't enroll
            SELECT COUNT(*) INTO other_special_perms
            FROM PermissionMapping pm, SpecialPermissions sp
            WHERE pm.specialPermissionID = sp.specialPermissionID
            AND sp.specialPermissionCodes <> 'PREREQ'
            AND sp.specialPermissionCodes <> 'MatchReqLevel'
            AND pm.courseOfferingID = courseOffering_id;

            IF other_special_perms > 0 THEN
                DBMS_OUTPUT.PUT_LINE('Special Permissions Required.');
                success := 'Special Permissions Required.';
                RETURN;
            END IF;

        END IF;
        
        -- If course clashes with another course previously enrolled for, then can't enroll
        FOR curr_course IN (
            SELECT t.courseOfferingID, co.classDays, co.startTime, co.endTime
            FROM Transcript t, CourseOffering co
            WHERE t.unityID = unity_id
            AND t.courseOfferingID = co.courseOfferingID
            AND co.semesterID = semester_id
        )
        LOOP
            -- TO_NUMBER(TO_CHAR(DATE_1, 'SSSSS'))
            IF curr_course.classDays = class_days THEN
                IF ((class_startTime BETWEEN curr_course.startTime AND curr_course.endTime) OR (class_endTime BETWEEN curr_course.startTime AND curr_course.endTime)) THEN
                    DBMS_OUTPUT.PUT_LINE('Scheduling conflict. This class clashes with another class. Cannot enroll. Please see schedule.');
                    success := 'Scheduling conflict. This class clashes with another class. Cannot enroll. Please see schedule.';
                    RETURN;
                END IF;
            END IF;
        END LOOP;

        -- If course if full,
        IF (course_availability = 0) THEN
        	/* 
            IF add_waitlist = 0 THEN
                DBMS_OUTPUT.PUT_LINE('Course is full. Do you want to be added to waitlist?');
                success := 'Course is full. Do you want to be added to waitlist?';
                RETURN;
            END IF;
            */
        	SELECT count(*) into waitlisted_students
        	FROM Waitlist
        	WHERE courseOfferingID=courseOffering_id;
        	
            -- Waitlist is full
        	IF (waitlisted_students >= waitlist_limit)
        	THEN
                DBMS_OUTPUT.PUT_LINE('Course and waitlist full. Keep checking to see if seats open up.');
        		success := 'Course and waitlist full. Keep checking to see if seats open up.';
        		RETURN;
        	ELSE
                -- Waitlist is not full, check crietria, and enroll into waiting list
		        IF (participation_level_student=participation_level_course and credit_hours >= min_credits and credit_hours <= max_credits)
		        THEN
                    IF ((total_credits_taken_transcript + total_credits_taken_waitlist + credit_hours) > max_allowed_credit) THEN
	        		    INSERT INTO Waitlist VALUES(unity_id, courseOffering_id, waitlisted_students+1, overload_dropcourse);
                    ELSE
                        INSERT INTO Waitlist VALUES(unity_id, courseOffering_id, waitlisted_students+1, null);
                        /*
                            DBMS_OUTPUT.PUT_LINE('Enrolling in this course puts you over maxCredits. Please mention a course to drop in case of overload.');
                            success := 'Enrolling in this course puts you over maxCredits. Please mention a course to drop in case of overload.';
                            RETURN;
                        */
                    END IF;
                    DBMS_OUTPUT.PUT_LINE('Waitlist Position = ' || (waitlisted_students+1) || '/' || waitlist_limit);
	        		success := 'Added to waitlist.' || CHR(10) || 'Waitlist Position = ' || (waitlisted_students+1) || '/' || waitlist_limit;
	        		RETURN;
	        	END IF;

        	END IF;

        END IF;

        -- DBMS_OUTPUT.PUT_LINE(total_credits_taken_transcript || ' ' ||  total_credits_taken_waitlist || ' ' || credit_hours || ' ' || max_allowed_credit);
        -- If enrolling in the course makes you go over max_allowed_credit, can't enroll
        IF ((total_credits_taken_transcript + total_credits_taken_waitlist + credit_hours) > max_allowed_credit) THEN
            DBMS_OUTPUT.PUT_LINE('Max Credits Exceeded.');
            success := 'Max Credits Exceeded.';
            RETURN;
        END IF;
        
        -- Course is open, seats are available, participationLevels match, creditHours requested are within bounds
        IF (participation_level_student=participation_level_course and credit_hours >= min_credits and credit_hours <= max_credits)
        THEN
            -- Update Transcript
            INSERT INTO TRANSCRIPT(unityID, courseOfferingID, creditHoursTaken, courseGrade)
            VALUES (unity_id, courseOffering_id, credit_hours, 'PROG');

            -- Update CourseOffering, decrease available seats by 1
            UPDATE CourseOffering
            SET seatsAvailable = seatsAvailable - 1
            WHERE courseOfferingID=courseOffering_id;
            
            DBMS_OUTPUT.PUT_LINE('Successfully registered!');
            success := 'Successfully registered!';
            COMMIT;
            RETURN;

        END IF;
    
    ELSE
        -- Already enrolled or previous taken course
        DBMS_OUTPUT.PUT_LINE('Already registered/ previously taken.');
        success := 'Already registered/ previously taken.';
        RETURN;
    
    END IF;
    
    EXCEPTION 
        WHEN OTHERS THEN
            -- err_code := SQLCODE;
            -- err_msg := SUBSTR(SQLERRM, 1, 200);
            DBMS_OUTPUT.PUT_LINE('Some Exception occured. Try again.');
            DBMS_OUTPUT.PUT_LINE('Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200));
            success := 'Some Exception occured. Try again.' || CHR(10) || 'Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200);
        RETURN;
END;
/

-----------------

-- Approve a special permission request
-- EXEC proc_ApproveCourse(specialPermissionID, out_cursor);

set serveroutput ON;

CREATE OR REPLACE PROCEDURE proc_ApproveRequest(
	specialpermission_id 	IN SpecialPermissionRequests.specialPermissionID%TYPE,
	approver_unityID		IN Admin.unityID%TYPE,
	l_approved				IN NUMBER,
	success 				OUT VARCHAR2
)

IS
	approval_status 	SpecialPermissionRequests.approvalStatus%TYPE;
	courseoffering_id 	SpecialPermissionRequests.courseOfferingID%TYPE;
	credits 			SpecialPermissionRequests.numberOfUnits%TYPE;
	unity_id 			SpecialPermissionRequests.unityID%TYPE;

BEGIN

	SELECT approvalStatus, courseOfferingID, numberOfUnits, unityID INTO approval_status, courseoffering_id, credits, unity_id
	FROM SpecialPermissionRequests
	where specialPermissionID=specialpermission_id;
	
	-- l_approved = 1 means request was approved; l_approved = 0 is Rejected
	IF l_approved = 1 THEN
		UPDATE SpecialPermissionRequests
		SET approvalStatus = 'Approved', approvalBy = approver_unityID, approvalDate = TRUNC(SYSDATE)
		WHERE specialPermissionID=specialpermission_id;
		
		proc_EnrollCourse(unity_id, courseoffering_id, credits, null, success);

		DBMS_OUTPUT.PUT_LINE(success);
	ELSE
		UPDATE SpecialPermissionRequests
		SET approvalStatus = 'Rejected', approvalBy = approver_unityID, approvalDate = TRUNC(SYSDATE)
		WHERE specialPermissionID=specialpermission_id;
		DBMS_OUTPUT.PUT_LINE('The request has been rejected.');
		success := 'The request has been rejected.';
	END IF;

	EXCEPTION 
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Some Exception occured. Try again.');
            DBMS_OUTPUT.PUT_LINE('Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200));
            success := 'Some Exception occured. Try again.' || CHR(10) || 'Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200);
        RETURN;
END;
/

---------------

-- At end of last day for bill payment date,
-- drop courses of students who have an unpaid bill against their name

SET SERVEROUTPUT ON;
SET AUTOCOMMIT OFF;

CREATE OR REPLACE PROCEDURE proc_CleanupRolls(
    success OUT VARCHAR2
)
IS
    outstanding_amount 	Billing.outstandingAmount%TYPE;
    temp_var            NUMBER;
BEGIN
    -- For each student, get that student's last bill from billing and see if there is a positive outstanding amount

    FOR student IN (
        SELECT * FROM STUDENTS
    )
    LOOP
        -- look for last entry in billing for student
		select count(*) into temp_var
		from Billing bi 
		where bi.unityid = student.unityID;

		if temp_var !=0 then
			select outstandingAmount into outstanding_amount
			from Billing bi 
			where bi.unityid = student.unityID and rownum = 1			
			order by bi.billid desc; 
		else
			outstanding_amount:=0;
		end if;

        -- If outstanding amount is positive, drop all enrolled courses from current semester
        IF outstanding_amount > 0 THEN

            DBMS_OUTPUT.PUT_LINE('Student ' || student.unityID || ' has an outstading bill.');

            -- See if student is enrolled in any courses this semester (to avoid error in next query)
            SELECT Count(*) INTO temp_var
            FROM Transcript t, CourseOffering co
            WHERE t.unityID = student.unityID
            AND t.courseOfferingID = co.courseOfferingID
            AND co.semesterID = currentSemID;

            IF temp_var > 0 THEN
                FOR curr_course IN (
                    SELECT t.courseOfferingID
                    FROM Transcript t, CourseOffering co
                    WHERE t.unityID = student.unityID
                    AND t.courseOfferingID = co.courseOfferingID
                    AND co.semesterID = currentSemID
                )
                LOOP
                    proc_DropCourse(student.unityID, curr_course.courseOfferingID, success);
                END LOOP;
            END IF;


            -- See if student is wailisted in any courses this semester (to avoid error in next query)
            SELECT Count(*) INTO temp_var
            FROM Waitlist w, CourseOffering co
            WHERE w.unityID = student.unityID
            AND w.courseOfferingID = co.courseOfferingID
            AND co.semesterID = currentSemID;

            IF temp_var > 0 THEN
                FOR curr_course IN (
                    SELECT w.courseOfferingID
                    FROM Waitlist w, CourseOffering co
                    WHERE w.unityID = student.unityID
                    AND w.courseOfferingID = co.courseOfferingID
                    AND co.semesterID = currentSemID
                )
                LOOP
                    proc_DropCourse(student.unityID, curr_course.courseOfferingID, success);
                END LOOP;
            END IF;

            COMMIT;

            DBMS_OUTPUT.PUT_LINE('All courses dropped for student ' || student.unityID || ' due to outstading bill of ' || outstanding_amount);
            success := 'All courses dropped for student ' || student.unityID || ' due to outstading bill of ' || outstanding_amount;

        END IF;

        success := 'Rolls have been cleaned up';

    END LOOP;

    EXCEPTION 
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE('Some Exception occured. Try again.');
			DBMS_OUTPUT.PUT_LINE('Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200));
			success := 'Some Exception occured. Try again.' || CHR(10) || 'Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200);
        RETURN;
END;
/

SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE proc_CleanupRolls1
IS
    l_message VARCHAR2(300);
BEGIN
    proc_CleanupRolls(l_message);
    DBMS_OUTPUT.PUT_LINE(l_message);
END;
/

---------------------------

-- View My Currently Waitlisted Courses
-- EXEC proc_ViewWaitlistedCourses(unityID);

CREATE OR REPLACE PROCEDURE proc_ViewWaitlistedCourses(
	unity_id 	IN Waitlist.unityID%TYPE,
	l_return 	OUT SYS_REFCURSOR
)
IS
BEGIN
	OPEN l_return FOR
		SELECT w.courseOfferingID, c.title, w.waitlistPosition
		FROM Waitlist w, CourseOffering cs, Course c
		where w.unityID = unity_id and w.courseOfferingID=cs.courseOfferingID and cs.courseID=c.courseID and cs.deptID = c.deptID;
END;
/

-------------------------

-- Clear Waitlist for a CourseOffering
-- EXEC proc_ClearWLCourseOff(courseOfferingID);

SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE proc_ClearWLCourseOff(
	courseoffering_id IN Waitlist.courseOfferingID%TYPE,
	message OUT VARCHAR2
)
IS
BEGIN
	DELETE FROM Waitlist
	WHERE courseOfferingID=courseoffering_id;
	message := 'Waitlist cleaned up';
	EXCEPTION 
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Some Exception occured. Try again.');
            DBMS_OUTPUT.PUT_LINE('Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200));
            message := 'Some Exception occured. Try again.' || CHR(10) || 'Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200);
        RETURN;
END;
/


-- Clear Waitlist for a Semester
-- EXEC proc_ClearWLSem(semesterID);

SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE proc_ClearWLSem(
	l_semesterID 	IN Semester.semesterID%TYPE,
	l_message		OUT VARCHAR2
)
IS
BEGIN
	FOR i in (
		SELECT 	courseOfferingID
		FROM 	CourseOffering
		WHERE 	CourseOffering.semesterID = l_semesterID
	)
	loop
		proc_ClearWLCourseOff(i.courseOfferingID, l_message);
	END loop;

	DBMS_OUTPUT.PUT_LINE('Waitlists cleared successfully.');
	l_message := 'Waitlists cleared successfully.';
	
	EXCEPTION 
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Some Exception occured. Try again.');
            DBMS_OUTPUT.PUT_LINE('Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200));
            l_message := 'Some Exception occured. Try again.' || CHR(10) || 'Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200);
        RETURN;
END;
/

SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE proc_ClearWLCurrSem(
	l_message OUT VARCHAR2
)
IS
	l_currentSemID NUMBER := currentSemID;
BEGIN
	proc_ClearWLSem(l_currentSemID, l_message);
	EXCEPTION 
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Some Exception occured. Try again.');
            DBMS_OUTPUT.PUT_LINE('Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200));
            l_message := 'Some Exception occured. Try again.' || CHR(10) || 'Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200);
        RETURN;
END;
/

--------------------------------------

-- Print out Courses in Semester identified by semesterID
-- EXEC courseOfferingsInSemester(semesterID);

CREATE OR REPLACE PROCEDURE proc_CourseOfferingsInSemester(
    l_semesterID 	IN CourseOffering.semesterID%TYPE,
	l_return 		OUT SYS_REFCURSOR
)
IS
BEGIN
	OPEN l_return FOR
		SELECT cs.courseOfferingID, c.deptID, c.courseID, c.title, cs.startTime, cs.endTime
		FROM Course c, CourseOffering cs
		where cs.semesterID = l_semesterID and c.courseID = cs.courseID and c.deptID = cs.deptID;
END;
/

-----------------------------

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

-------------------------------

-- Procedure to generate bills for all students in system

set serveroutput on;

CREATE OR REPLACE PROCEDURE proc_GenerateBill

IS
	total_credits_taken_transcript 	NUMBER:=0;
    total_credits_taken_waitlist 	NUMBER:=0;
	billing_rate 		number:=0;
	total_credits 		number:=0;
	bill_amount 		Billing.billAmount%type;
	course_id 			Course.courseID%TYPE;
	outstanding_amount 	Billing.outstandingAmount%type;
	unity_id 			Students.unityid%type;
	semester_id 		Courseoffering.semesterid%type := constants.current_semid;
	temp_var 			number;
	curr_bill 			number;
	curr_outstanding_amount number;

Begin
	for i in (select unityid from Students) 
	loop
		unity_id:=i.unityid;
		
		-- dbms_output.put_line(unity_id);

		-- get total credits for courses taken this semester (from transcript table)
		select count(*) into temp_var 
		FROM Transcript t, CourseOffering s
		WHERE t.unityID=unity_id and t.courseOfferingID=s.courseOfferingID and s.semesterid=semester_id;

		if temp_var!=0 then
			select SUM(t.creditHoursTaken) into total_credits_taken_transcript
			FROM Transcript t, CourseOffering s
			WHERE t.unityID=unity_id and t.courseOfferingID=s.courseOfferingID and s.semesterid=semester_id;
		else
			total_credits_taken_transcript:=0;
		end if;
		
		-- get total credits for courses on waitlist for this semester (from waitlist table)
		select count(*) into temp_var 
		from Waitlist w, CourseOffering s
		where w.unityID=unity_id and w.courseOfferingID=s.courseOfferingID;
		
		if temp_var!=0 then
			select SUM(c.maxcredits) into total_credits_taken_waitlist
			FROM Waitlist w, CourseOffering s, Course c
			WHERE w.unityID=unity_id and w.courseOfferingID=s.courseOfferingID and c.courseID=s.courseID and c.deptID = s.deptID and s.semesterid=semester_id;
		else 
			total_credits_taken_waitlist:=0;
		end if;
		
		-- get billingrate based on student's creditRequirement
		select billingrate into billing_rate 
		from BillingRate b, students st 
		Where b.semesterid=semester_id and st.unityid=unity_id and st.creditreqid=b.creditreqid;
		

		total_credits := total_credits_taken_transcript + total_credits_taken_waitlist;

		curr_bill := total_credits * billing_rate;

		-- look for last positive entry in billing for student
		select count(*) into temp_var
		from Billing bi 
		where bi.unityid=unity_id and bi.billamount>0;

		if temp_var !=0 then
			select outstandingamount into outstanding_amount  --where bill amt is positive 
			from Billing bi 
			where bi.unityid=unity_id and rownum=1			
			order by bi.billid desc;
		else
			outstanding_amount:=0;
		end if;


		bill_amount:= curr_bill - outstanding_amount;

		-- look for last entry in billing for student
		select count(*) into temp_var
		from Billing bi 
		where bi.unityid=unity_id;

		if temp_var !=0 then
			select outstandingamount into outstanding_amount  --where bill amt is positive/neg 
			from Billing bi 
			where bi.unityid=unity_id and rownum=1			
			order by bi.billid desc; 
		else
			outstanding_amount:=0;
		end if;

		curr_outstanding_amount := outstanding_amount + bill_amount;

		-- create a new billing entry
		insert into Billing(billid, unityid, billamount, duedate, outstandingamount) 
		values(1, unity_id, bill_amount, trunc(SYSDATE), curr_outstanding_amount);
	
	end loop;
	
	EXCEPTION 
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Some Exception occured. Try again.');
            DBMS_OUTPUT.PUT_LINE('Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200));
            -- success := 'Some Exception occured. Try again.' || CHR(10) || 'Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200);
        RETURN;
end;
/
-- show err

-----------------------------------

-- Get details for a unity user with unityID

CREATE OR REPLACE PROCEDURE proc_GetUnityUserData(
    unity_id    IN UnityUsers.unityID%TYPE,
    f_name      OUT UnityUsers.fname%TYPE,
    l_name      OUT UnityUsers.lname%TYPE,
    e_mail      OUT UnityUsers.email%TYPE,
    gender_     OUT UnityUsers.gender%TYPE,
    user_type   OUT UnityUsers.userType%TYPE
)

IS

BEGIN
	SELECT u.fname, u.lname, u.email, u.gender, u.userType into f_name, l_name, e_mail, gender_, user_type
	FROM UnityUsers u
	where u.unityID=unity_id;

    EXCEPTION 
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Some Exception occured. Try again.');
            DBMS_OUTPUT.PUT_LINE('Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200));
            -- success := 'Some Exception occured. Try again.' || CHR(10) || 'Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200);
        RETURN;
END;
/

------------------------------

-- Get details for a unity user with unityID

CREATE OR REPLACE PROCEDURE proc_GetProfileData(
    unity_id    IN UnityUsers.unityID%TYPE,
    l_cursor OUT SYS_REFCURSOR 
)

IS

BEGIN
	OPEN l_cursor for SELECT u.unityID, u.fname, u.lname, u.email, u.gender, u.dateOfBirth, u.address, u.phone
	FROM UnityUsers u
	where u.unityID=unity_id;

    EXCEPTION 
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Some Exception occured. Try again.');
            DBMS_OUTPUT.PUT_LINE('Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200));
            --success := 'Some Exception occured. Try again.' || CHR(10) || 'Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200);
        RETURN;
END;
/

------------------

-- Calculate GPA for a student with unityID for a semesterID

set serveroutput on;

CREATE OR REPLACE PROCEDURE proc_GPAForSem(
	unity_id 	IN Students.unityid%type,
	semester_id IN CourseOffering.semesterid%type,
	overall_gpa OUT students.overallGpa%type
)
IS
	overall_grade 	number := 0;
	mapped_val 		number;
	courses_taken 	number;
BEGIN
	-- See if student has taken any courses in this semester 
	select count(*) into courses_taken
	FROM Transcript t, CourseOffering co
	WHERE t.unityID=unity_id and t.courseOfferingID=co.courseOfferingID and co.semesterID = semester_id;

	if courses_taken != 0 then
		for cursor0 in (
			select t.coursegrade
			from transcript t, CourseOffering co
			WHERE t.unityID=unity_id and t.courseOfferingID=co.courseOfferingID and co.semesterid=semester_id
		)
		loop
			if cursor0.coursegrade NOT IN ('S', 'U', 'AU', 'PROG') then
				GPA_MAPPING(cursor0.coursegrade, mapped_val);
				overall_grade := overall_grade + mapped_val;
			else
				courses_taken := courses_taken - 1;
			end if;
		end loop;

		overall_gpa := overall_grade / courses_taken;
	
	end if;

	EXCEPTION 
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Some Exception occured. Try again.');
            DBMS_OUTPUT.PUT_LINE('Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200));
END;
/

CREATE OR REPLACE PROCEDURE proc_GPAForSem1(
	unity_id IN Students.unityid%type,
	semester_id IN CourseOffering.semesterid%type
)
IS
	gpaForSem students.overallGpa%type;
BEGIN
	proc_GPAForSem(unity_id, semester_id, gpaForSem);
	DBMS_OUTPUT.PUT_LINE('GPA in semesterID ' || semester_id || ' for ' || unity_id || ' = ' || gpaForSem);
END;
/

-------------------------

-- Calculating GPA for a student

set serveroutput ON;
set autocommit off;

CREATE OR replace PROCEDURE proc_calcGPA(
    unity_id    IN students.unityid%TYPE,
    success     OUT varchar2
)
IS 
    grade         transcript.coursegrade%TYPE;
    gpa           students.overallgpa%TYPE;
    semester_id   courseoffering.semesterid%TYPE;
    temp          NUMBER;
    mapped_val    NUMBER;
    overall_gpa   NUMBER := 0; 
    overall_grade NUMBER := 0;
    cum_gpa       NUMBER := 0;
    sumofallsems  NUMBER := 0;
    total_courses NUMBER := 0;
    currentsemgpa NUMBER := 0;
    gpatilllastsem NUMBER := 0;
    coursesincurrsem NUMBER := 0;
    current_semid NUMBER := constants.current_semid;
BEGIN
    dbms_output.Put_line('Calculating GPA for -- ' || unity_id); 

    -- For each semester, from current to past
    FOR j IN (
        SELECT semesterid 
        FROM semester
        order by semesterid desc
    )
    LOOP 
        semester_id := j.semesterid; 

        -- See if student has taken any courses in this semester (semester_id)
        SELECT Count(*) 
        INTO   temp 
        FROM   transcript t, 
                courseoffering s 
        WHERE  t.unityid = unity_id 
        AND t.courseofferingid = s.courseofferingid 
        AND s.semesterid = semester_id; 

        IF temp != 0 THEN 
            total_courses := total_courses + temp;
            -- If courses in this semester_id, then covert grades to gpa, and calc gpa
            FOR cursor0 IN (
                SELECT t.coursegrade 
                FROM   transcript t, 
                        courseoffering s 
                WHERE  t.unityid = unity_id 
                AND t.courseofferingid = s.courseofferingid 
                AND s.semesterid = semester_id
            ) 
            LOOP
                if (cursor0.coursegrade NOT IN ('S', 'U', 'AU', 'PROG')) then
                    Gpa_mapping(cursor0.coursegrade, mapped_val); 
                    overall_gpa := overall_gpa + mapped_val; 
                else 
                    total_courses := total_courses -1;
                end if;
            END LOOP; 
                
            if semester_id = current_semid then
                currentsemgpa := overall_gpa;
                -- dbms_output.Put_line('current sem gpa :' || (currentsemgpa/temp));
                coursesincurrsem := temp;
            end if;
        END IF; 

        overall_grade := overall_gpa; 

    END LOOP;

    if total_courses != 0 then
        cum_gpa := trunc(overall_gpa / total_courses, 3); 
    end if;

    update Students
    set overallGPA = cum_gpa
    where unityid= unity_id;
    commit;

    dbms_output.Put_line('Cumulative GPA after this sem = ' || cum_gpa); 

    if (total_courses != coursesincurrsem)  then 
        gpatilllastsem := trunc((overall_gpa - currentsemgpa) / (total_courses - coursesincurrsem), 3);
    end if;

    dbms_output.Put_line('GPA till last sem = ' || gpatilllastsem); 

    success := 'Cumulative GPA = ' || cum_gpa; 
    if cum_gpa < gpatilllastsem then
        dbms_output.Put_line('GPA has decreased for ' || unity_id);
        success := success || ' GPA has decreased for ' || unity_id;
    end if;

    overall_grade := 0;
    overall_gpa := 0; 
    coursesincurrsem := 0;
    currentsemgpa :=0;
    gpatilllastsem := 0;
    cum_gpa := 0; 
    sumofallsems := 0; 
    total_courses := 0; 

    EXCEPTION 
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Some Exception occured. Try again.');
        DBMS_OUTPUT.PUT_LINE('Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200));
        success := 'Some Exception occured. Try again.' || CHR(10) || 'Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200);
    RETURN;
END; 
/ 
-- show err 

set serveroutput on;

CREATE OR REPLACE PROCEDURE proc_calcGPA1(
    l_unityID IN Students.unityID%TYPE
)
IS
    l_gpa varchar2(300);
BEGIN
    proc_calcGPA(l_unityID, l_gpa);
    dbms_output.Put_line(l_gpa);
END;
/

set serveroutput on;

CREATE OR REPLACE PROCEDURE proc_updateAllGPAs
IS
    l_message   varchar2(300);
    unity_id    students.unityid%TYPE;
BEGIN
    -- For all students
    FOR i IN (
      SELECT unityid FROM students
    ) 
    LOOP 
        unity_id := i.unityid;
        proc_calcGPA(unity_id, l_message);
    END LOOP;
    dbms_output.Put_line('All GPAs successfully updated.');
END;
/

-------------------------

-- One week before enrollment deadline, see if student is satisfying min credit requirement
-- If not, notify that student on email

SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE proc_MinCreditSatisfied
IS
    min_credit_req          number;
    total_cred_enrolled     number;
BEGIN
    FOR student in (
        SELECT * FROM STUDENTS
    )
    LOOP
        -- Find out total credits the student is enrolled for in ongoing semester
        SELECT COUNT(t.creditHoursTaken) INTO total_cred_enrolled
        FROM Transcript t, CourseOffering co
        WHERE t.unityID = student.unityID
        AND t.courseOfferingID = co.courseOfferingID
        AND co.semesterID = currentSemID;

        -- Find out the min required credit hours to be enrolled as a full time student for this student based on credit requirements
        SELECT minCreditReq INTO min_credit_req
        FROM CreditRequirements cr
        WHERE cr.creditReqID = student.creditReqID;

        IF total_cred_enrolled < min_credit_req THEN
            DBMS_OUTPUT.PUT_LINE(student.unityID);
        END IF;

    END LOOP;
END;
/

SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE proc_MinCredSatUser(
    l_unityID   IN  Students.unityID%TYPE,
    l_message   OUT VARCHAR
)
IS
    min_credit_req          number;
    total_cred_enrolled     number;
BEGIN
    -- Find out total credits the student is enrolled for in ongoing semester
    SELECT COUNT(t.creditHoursTaken) INTO total_cred_enrolled
    FROM Transcript t, CourseOffering co
    WHERE t.unityID = l_unityID
    AND t.courseOfferingID = co.courseOfferingID
    AND co.semesterID = currentSemID;

    -- Find out the min required credit hours to be enrolled as a full time student for this student based on credit requirements
    SELECT minCreditReq INTO min_credit_req
    FROM CreditRequirements cr
    WHERE cr.creditReqID = (SELECT creditReqID FROM Students WHERE unityID = l_unityID);

    IF total_cred_enrolled < min_credit_req THEN
        DBMS_OUTPUT.PUT_LINE('You have not enrolled in enough courses. Min Credit not satisfied. Please enroll in courses before deadline or request RCL.');
        l_message := 'You have not enrolled in enough courses. Min Credit not satisfied. Please enroll in courses before deadline or request RCL.';
        RETURN;
    ELSE
        l_message := 'success';
    END IF;

    EXCEPTION 
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Some Exception occured. Try again.');
        DBMS_OUTPUT.PUT_LINE('Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200));
        l_message := 'Some Exception occured. Try again.' || CHR(10) || 'Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200);
    RETURN;
END;
/

-----------------------

-- Register a new course
-- Course (courseID, deptID, title, maxCredits, minCredits, participationLevel)

SET SERVEROUTPUT ON;
SET AUTOCOMMIT OFF;

CREATE OR REPLACE PROCEDURE proc_NewCourse(
    l_courseID  IN Course.courseID%TYPE,
    l_deptID    IN Course.deptID%TYPE,
    l_title     IN Course.title%TYPE,
    l_maxCredits IN Course.maxCredits%TYPE,
    l_minCredits IN Course.minCredits%TYPE,
    l_participationLevel IN Course.participationLevel%TYPE,
    success     OUT VARCHAR2
)
IS
BEGIN
    
    INSERT INTO Course(courseID, deptID, title, maxCredits, minCredits, participationLevel)
    VALUES (l_courseID, l_deptID, l_title, l_maxCredits, l_minCredits, l_participationLevel);
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Course ' || l_deptID || ' ' || l_courseID || ' successfully added.');
    success := 'Course ' || l_deptID || ' ' || l_courseID || ' successfully added.';

    EXCEPTION 
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Some Exception occured. Try again.');
            DBMS_OUTPUT.PUT_LINE('Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200));
            success := 'Some Exception occured. Try again.' || CHR(10) || 'Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200);
        RETURN;
END;
/

------------------------

-- Register a new course offering
-- Display list of existing courses; then either select a previously existing (courseID, deptID) combination 
-- Or register a new course using proc_NewCourse, then register a CourseOffering
-- CourseOffering (courseOfferingID, courseID, sectionID, deptID, semesterID, 
-- classDays, startTime, endTime, location, totalSeatsOffered, seatsAvailable, waitListLimit, gpaRequirement)

SET SERVEROUTPUT ON;
SET AUTOCOMMIT OFF;

CREATE OR REPLACE PROCEDURE proc_NewCourseOffering(
    -- l_courseOfferingID      IN CourseOffering.courseOfferingID%TYPE,
    l_courseID              IN CourseOffering.courseID%TYPE,
    l_deptID                IN CourseOffering.deptID%TYPE,
    l_sectionID             IN CourseOffering.sectionID%TYPE,
    l_semesterID            IN CourseOffering.semesterID%TYPE,
    l_classDays             IN CourseOffering.classDays%TYPE,
    l_startTime             IN VARCHAR2,
    l_endTime               IN VARCHAR2,
    l_location              IN CourseOffering.location%TYPE,
    l_totalSeatsOffered     IN CourseOffering.totalSeatsOffered%TYPE,
    l_waitListLimit         IN CourseOffering.waitListLimit%TYPE,
    l_gpaReq                IN CourseOffering.gpaRequirement%TYPE,
    success                 OUT VARCHAR2
)
IS
    temp_var    number;
BEGIN

    SELECT COUNT(*) INTO temp_var
    FROM Course c
    WHERE c.courseID = l_courseID
    AND c.deptID = l_deptID;

    -- Register a course first
    IF temp_var = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Please register a course first in the database. Execute proc_NewCourse.');
        success := 'Please register a course first in the database. Execute proc_NewCourse.';
        RETURN;
    ELSE
        INSERT INTO CourseOffering (courseID, deptID, sectionID, semesterID, classDays, startTime, endTime, location
        , totalSeatsOffered, seatsAvailable, waitlistLimit, gpaRequirement)
        VALUES (l_courseID, l_deptID, l_sectionID, l_semesterID,
        l_classDays, TO_NUMBER(TO_CHAR(TO_DATE(l_startTime, 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), TO_NUMBER(TO_CHAR(TO_DATE(l_endTime, 'MM/DD/YYYY HH24:MI:SS'), 'SSSSS')), l_location, l_totalSeatsOffered, l_totalSeatsOffered, l_waitListLimit, l_gpaReq);
        COMMIT;

        DBMS_OUTPUT.PUT_LINE('CourseOffering created.');
        success := 'CourseOffering created.';
        RETURN;
    END IF;

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Some Exception occured. Try again.');
            DBMS_OUTPUT.PUT_LINE('Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200));
            success := 'Some Exception occured. Try again.' || CHR(10) || 'Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200);
        RETURN;

END;
/

--------------------------

-- Submit a special permission request for admin to approve

SET SERVEROUTPUT ON;
SET AUTOCOMMIT OFF;

CREATE OR REPLACE PROCEDURE proc_NewSpPermReq(
    l_unityID           IN SpecialPermissionRequests.unityID%TYPE,
    l_courseOfferingID  IN SpecialPermissionRequests.courseOfferingID%TYPE,
    l_numberOfUnits     IN SpecialPermissionRequests.numberOfUnits%TYPE,
    l_comments          IN SpecialPermissionRequests.comments%TYPE,
    success             OUT VARCHAR2
)
IS
BEGIN
    INSERT INTO SpecialPermissionRequests (unityID, courseOfferingID, numberOfUnits, comments, approvalStatus)
    VALUES (l_unityID, l_courseOfferingID, l_numberOfUnits, l_comments, 'NEW');
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Request submitted succesfully.');
    success := 'Request submitted succesfully.';

    EXCEPTION 
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Some Exception occured. Try again.');
            DBMS_OUTPUT.PUT_LINE('Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200));
            success := 'Some Exception occured. Try again.' || CHR(10) || 'Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200);
END;
/

--------------------

CREATE OR REPLACE PROCEDURE proc_NewUser(
	unity_ID IN UnityUsers.unityID%type,
	f_name IN UnityUsers.fname%type,
	l_name IN UnityUsers.lname%type,
	e_mail IN UnityUsers.email%type,
	gender IN UnityUsers.gender%type,
	dob IN UnityUsers.fname%type,
	addr IN UnityUsers.address%type,
	phno IN UnityUsers.phone%type,
	typeofuser IN UnityUsers.userType%type,
	message OUT VARCHAR2
)
IS
	userExist NUMBER := 0;
BEGIN
	proc_ExistUser(unity_ID, userExist);

	IF userExist = 1 THEN
		message := 'Another user with this unityID exists in the system. Please enter a new UnityID';
		RETURN;
	END IF;

	INSERT INTO UnityUsers(unityID, fname, lname, email, gender, dateOfBirth, address, phone, userType, Password)
	VALUES (unity_ID, f_name,l_name, e_mail, gender, TO_DATE(dob, 'MM/DD/YYYY'), addr, phno, typeofuser, 'password');
	commit;
	
	message := 'success';
	EXCEPTION
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('Some Exception occured. Try again.');
		DBMS_OUTPUT.PUT_LINE('Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200));
		message := 'Some Exception occured. Try again.' || CHR(10) || 'Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200);
END;
/

-----------------------------

-- Pay bill for a given unityID
-- Entry in billing as negative amount

CREATE OR REPLACE PROCEDURE proc_PayBill(
	unity_id 	IN Students.unityID%type,
	bill_amount IN Billing.billAmount%type,
	message OUT VARCHAR2
)

IS
	outstanding_amount 		Billing.outstandingamount%type := 0;
	curr_outstanding_amount number;
	dummy 					number;
	bill					number;

BEGIN

	IF bill_amount < 0 THEN
		message := 'Incorrect bill amount. Please try again.';
		RETURN;
	END IF;

	select count(*) into dummy
	from Billing bi 
	where bi.unityid=unity_id;

	-- Get last bill's outstanding amount (if bill exists)
	if dummy !=0 then
		select outstandingamount into outstanding_amount from (
			select bi.outstandingamount
			from Billing bi 
			where bi.unityid=unity_id
			order by bi.billid desc
		)
		where rownum < 2;
	else
		outstanding_amount:=0;
	end if;
	
	bill := -bill_amount;
	curr_outstanding_amount:= outstanding_amount + bill;

	insert into Billing(billid, unityid, billamount, duedate, outstandingamount) 
	values(1, unity_id, bill, trunc(SYSDATE), curr_outstanding_amount);
	
	message := 'success';

    EXCEPTION 
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Some Exception occured. Try again.');
            DBMS_OUTPUT.PUT_LINE('Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200));
            message := 'Some Exception occured. Try again.' || CHR(10) || 'Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200);
        RETURN;
end;
/
-- show err;-- Pay bill for a given unityID
-- Entry in billing as negative amount

CREATE OR REPLACE PROCEDURE proc_PayBill(
	unity_id 	IN Students.unityID%type,
	bill_amount IN Billing.billAmount%type,
	message OUT VARCHAR2
)

IS
	outstanding_amount 		Billing.outstandingamount%type := 0;
	curr_outstanding_amount number;
	dummy 					number;
	bill					number;

BEGIN

	IF bill_amount < 0 THEN
		message := 'Incorrect bill amount. Please try again.';
		RETURN;
	END IF;

	select count(*) into dummy
	from Billing bi 
	where bi.unityid=unity_id;

	-- Get last bill's outstanding amount (if bill exists)
	if dummy !=0 then
		select outstandingamount into outstanding_amount from (
			select bi.outstandingamount
			from Billing bi 
			where bi.unityid=unity_id
			order by bi.billid desc
		)
		where rownum < 2;
	else
		outstanding_amount:=0;
	end if;
	
	bill := -bill_amount;
	curr_outstanding_amount:= outstanding_amount + bill;

	insert into Billing(billid, unityid, billamount, duedate, outstandingamount) 
	values(1, unity_id, bill, trunc(SYSDATE), curr_outstanding_amount);
	
	message := 'success';

    EXCEPTION 
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Some Exception occured. Try again.');
            DBMS_OUTPUT.PUT_LINE('Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200));
            message := 'Some Exception occured. Try again.' || CHR(10) || 'Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200);
        RETURN;
end;
/
-- show err;

--------------------

-- Prints unityIDs of Students registered in a CourseOffering 
-- EXEC StudentsRegisteredInCourse(3);

CREATE OR REPLACE PROCEDURE proc_StudentsInCourse(
	courseoffering_id 	IN CourseOffering.courseOfferingID%TYPE,
	l_return 			OUT SYS_REFCURSOR
)
IS
BEGIN
	OPEN l_return FOR
		SELECT t.unityID
		FROM Transcript t
		WHERE t.courseOfferingID = courseoffering_id;
END;
/

-----------------

CREATE OR REPLACE PROCEDURE proc_ViewCourseOfferings(
    l_return OUT SYS_REFCURSOR
)
IS
	semester_id CourseOffering.semesterID%TYPE := constants.current_semID;
BEGIN
    OPEN l_return FOR 
        SELECT cs.courseOfferingID, c.title, to_char(to_date(cs.starttime,'sssss'),'hh24:mi'), to_char(to_date(cs.endtime,'sssss'),'hh24:mi'), cs.totalSeatsOffered, cs.seatsAvailable
        FROM CourseOffering cs, Course c
        where cs.courseID=c.courseID and cs.deptID = c.deptID and cs.semesterID=semester_id;
END;
/

CREATE OR REPLACE PROCEDURE proc_ViewAllCourseOfferings(
    l_return OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN l_return FOR 
        SELECT cs.courseOfferingID, c.title, to_char(to_date(cs.starttime,'sssss'),'hh24:mi'), to_char(to_date(cs.endtime,'sssss'),'hh24:mi'), cs.totalSeatsOffered, cs.seatsAvailable
        FROM CourseOffering cs, Course c
        where cs.courseID=c.courseID and cs.deptID = c.deptID;
END;
/

-------------------------

-- View all departments
CREATE OR REPLACE PROCEDURE proc_ViewDepartments(
	l_return OUT SYS_REFCURSOR)
IS
BEGIN
	OPEN l_return FOR
		SELECT *
		FROM Department;
END;
/

--------------------

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

-------------------

-- View My Current Transcript
-- EXEC proc_ViewMyTranscript(unityID);

CREATE OR REPLACE PROCEDURE proc_ViewMyTranscript(
	unity_id 	IN Transcript.unityID%TYPE,
	l_return 	OUT SYS_REFCURSOR
)
IS
BEGIN
	OPEN l_return FOR
		SELECT c.courseID, c.title, t.creditHoursTaken, t.courseGrade
		FROM Transcript t, CourseOffering cs, Course c
		where t.unityID = unity_id and t.courseOfferingID=cs.courseOfferingID and cs.courseID=c.courseID and cs.deptID = c.deptID;
END;
/

-------------------

CREATE OR REPLACE PROCEDURE proc_viewAllSemesters(
    l_return OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN l_return FOR 
        SELECT *
        FROM Semester s;
END;
/

-------------------------

-- List Special Permission Requests for ongoing Semester
-- EXEC ViewPermRequests;

CREATE OR REPLACE PROCEDURE proc_ViewPermRequests(
	l_return OUT SYS_REFCURSOR
)
IS
	l_semesterID Semester.semesterID%TYPE := constants.current_semID;
BEGIN
	OPEN l_return FOR
		SELECT s.specialPermissionID, s.unityID, co.deptID, co.courseID, s.approvalStatus
		FROM SpecialPermissionRequests s, CourseOffering co
		WHERE s.courseOfferingID = co.courseOfferingID
		AND co.semesterID = l_semesterID;
END;
/

------------------

-- View the current schedule for a student with given unityID

SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE proc_ViewSchedule(
    l_unityID   IN Transcript.unityID%TYPE,
    l_return    OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN l_return FOR
        SELECT t.courseOfferingID, co.deptID, co.courseID, co.classDays, co.startTime, co.endTime, co.location
        FROM Transcript t, CourseOffering co
        WHERE t.unityID = l_unityID
        AND t.courseOfferingID = co.courseOfferingID
        AND co.semesterID = currentSemID;
    EXCEPTION 
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Some Exception occured. Try again.');
            DBMS_OUTPUT.PUT_LINE('Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200));
END;
/

SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE proc_ViewSchedule1(
    l_unityID   IN Transcript.unityID%TYPE
)
IS
BEGIN
    DBMS_OUTPUT.PUT_LINE(CHR(10) || 'Schedule for Student ' || l_unityID || ' for current semester - ' || CHR(10));

    FOR cursor0 IN (
        SELECT t.courseOfferingID, co.deptID, co.courseID, co.classDays, co.startTime, co.endTime, co.location
        FROM Transcript t, CourseOffering co
        WHERE t.unityID = l_unityID
        AND t.courseOfferingID = co.courseOfferingID
        AND co.semesterID = currentSemID
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE(cursor0.courseOfferingID || ' ' || rpad(cursor0.deptID, 5) || ' ' || cursor0.courseID || ' ' ||
                            cursor0.classDays || ' ' || cursor0.startTime || '-' || cursor0.endTime || ' ' || cursor0.location);
    END LOOP;

    EXCEPTION 
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Some Exception occured. Try again.');
            DBMS_OUTPUT.PUT_LINE('Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200));
END;
/

---------------------------

-- View all students enrolled in the system
-- EXEC ViewStudents;

CREATE OR REPLACE PROCEDURE proc_ViewStudents(
	l_return OUT SYS_REFCURSOR
)
IS
BEGIN
	OPEN l_return FOR
		SELECT u.unityID, s.studentID, u.fname, u.lname, u.gender, s.overallGPA, u.dateOfBirth, u.phone, u.address
		FROM Students s, UnityUsers u
		where s.unityID=u.unityID;
END;
/

------------------------

-- View unityIDs of students wailisted in a CourseOffering
-- EXEC ViewWaitlistedStudents(courseOfferingID);

CREATE OR REPLACE PROCEDURE proc_ViewWaitlistedStudents(
	courseoffering_id 	IN CourseOffering.courseOfferingID%TYPE,
	l_return 			OUT SYS_REFCURSOR
)
IS
BEGIN
	OPEN l_return FOR
		SELECT w.unityID, w.waitlistPosition
		FROM Waitlist w
		where w.courseOfferingID = courseoffering_id;
END;
/

-------------------

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

