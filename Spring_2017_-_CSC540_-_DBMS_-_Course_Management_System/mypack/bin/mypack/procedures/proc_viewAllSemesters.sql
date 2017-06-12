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