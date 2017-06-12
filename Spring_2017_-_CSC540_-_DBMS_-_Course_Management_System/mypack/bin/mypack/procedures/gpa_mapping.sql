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