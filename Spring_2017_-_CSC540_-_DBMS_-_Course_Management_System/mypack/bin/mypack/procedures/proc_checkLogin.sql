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