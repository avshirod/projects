CREATE OR REPLACE PROCEDURE proc_ViewCourses(
    l_return OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN l_return FOR SELECT *
    FROM Course c;
END;
/