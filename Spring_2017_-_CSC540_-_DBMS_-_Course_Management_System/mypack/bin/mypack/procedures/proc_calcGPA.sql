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