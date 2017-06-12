SELECT s.unityID, co.deptID, co.courseID, s.approvalStatus
FROM SpecialPermissionRequests s, CourseOffering co
WHERE s.courseOfferingID = co.courseOfferingID
AND co.semesterID = currentSemID;