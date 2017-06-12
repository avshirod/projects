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