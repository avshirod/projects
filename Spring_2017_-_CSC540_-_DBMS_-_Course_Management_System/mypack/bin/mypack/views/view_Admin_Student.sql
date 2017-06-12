CREATE OR REPLACE VIEW admin_studentinfo
AS
SELECT s.unityID, u.fname, u.lname, u.gender, u.dateOfBirth, u.address, u.phone, s.deptID, s.overallGPA, s.participationLevel, s.residencyLevel
FROM Students s, UnityUsers u
WHERE s.unityID = u.unityID;