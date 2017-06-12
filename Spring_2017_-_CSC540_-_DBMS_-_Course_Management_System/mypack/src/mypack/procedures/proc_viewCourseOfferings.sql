CREATE OR REPLACE PROCEDURE proc_ViewCourseOfferings(
    l_return OUT SYS_REFCURSOR
)
IS
	semester_id CourseOffering.semesterID%TYPE := constants.current_semID;
BEGIN
    OPEN l_return FOR 
        SELECT cs.courseOfferingID, cs.deptID, cs.courseID, c.title, to_char(to_date(cs.starttime,'sssss'),'hh24:mi'), to_char(to_date(cs.endtime,'sssss'),'hh24:mi'), cs.totalSeatsOffered, cs.seatsAvailable
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
        SELECT cs.courseOfferingID, cs.deptID, cs.courseID, c.title, to_char(to_date(cs.starttime,'sssss'),'hh24:mi'), to_char(to_date(cs.endtime,'sssss'),'hh24:mi'), cs.totalSeatsOffered, cs.seatsAvailable
        FROM CourseOffering cs, Course c
        where cs.courseID=c.courseID and cs.deptID = c.deptID;
END;
/