CREATE OR REPLACE VIEW view_CourseOfferings
AS
SELECT cs.courseOfferingID, c.title, cs.starttime, cs.endtime
FROM CourseOffering cs, Course c
WHERE cs.courseID=c.courseID 
AND cs.semesterID=currentSemID;