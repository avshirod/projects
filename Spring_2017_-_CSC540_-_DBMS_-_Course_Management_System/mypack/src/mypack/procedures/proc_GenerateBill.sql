-- Procedure to generate bills for all students in system

set serveroutput on;

CREATE OR REPLACE PROCEDURE proc_GenerateBill

IS
	total_credits_taken_transcript 	NUMBER:=0;
    total_credits_taken_waitlist 	NUMBER:=0;
	billing_rate 		number:=0;
	total_credits 		number:=0;
	bill_amount 		Billing.billAmount%type;
	course_id 			Course.courseID%TYPE;
	outstanding_amount 	Billing.outstandingAmount%type;
	unity_id 			Students.unityid%type;
	semester_id 		Courseoffering.semesterid%type := constants.current_semid;
	temp_var 			number;
	curr_bill 			number;
	curr_outstanding_amount number;

Begin
	for i in (select unityid from Students) 
	loop
		unity_id:=i.unityid;
		
		-- dbms_output.put_line(unity_id);

		-- get total credits for courses taken this semester (from transcript table)
		select count(*) into temp_var 
		FROM Transcript t, CourseOffering s
		WHERE t.unityID=unity_id and t.courseOfferingID=s.courseOfferingID and s.semesterid=semester_id;

		if temp_var!=0 then
			select SUM(t.creditHoursTaken) into total_credits_taken_transcript
			FROM Transcript t, CourseOffering s
			WHERE t.unityID=unity_id and t.courseOfferingID=s.courseOfferingID and s.semesterid=semester_id;
		else
			total_credits_taken_transcript:=0;
		end if;
		
		-- get total credits for courses on waitlist for this semester (from waitlist table)
		select count(*) into temp_var 
		from Waitlist w, CourseOffering s
		where w.unityID=unity_id and w.courseOfferingID=s.courseOfferingID;
		
		if temp_var!=0 then
			select SUM(c.maxcredits) into total_credits_taken_waitlist
			FROM Waitlist w, CourseOffering s, Course c
			WHERE w.unityID=unity_id and w.courseOfferingID=s.courseOfferingID and c.courseID=s.courseID and c.deptID = s.deptID and s.semesterid=semester_id;
		else 
			total_credits_taken_waitlist:=0;
		end if;
		
		-- get billingrate based on student's creditRequirement
		select billingrate into billing_rate 
		from BillingRate b, students st 
		Where b.semesterid=semester_id and st.unityid=unity_id and st.creditreqid=b.creditreqid;
		

		total_credits := total_credits_taken_transcript + total_credits_taken_waitlist;

		curr_bill := total_credits * billing_rate;

		-- look for last positive entry in billing for student
		select count(*) into temp_var
		from Billing bi 
		where bi.unityid=unity_id and bi.billamount>0;

		if temp_var !=0 then
			select outstandingamount into outstanding_amount  --where bill amt is positive 
			from Billing bi 
			where bi.unityid=unity_id and rownum=1			
			order by bi.billid desc;
		else
			outstanding_amount:=0;
		end if;


		bill_amount:= curr_bill - outstanding_amount;

		-- look for last entry in billing for student
		select count(*) into temp_var
		from Billing bi 
		where bi.unityid=unity_id;

		if temp_var !=0 then
			select outstandingamount into outstanding_amount  --where bill amt is positive/neg 
			from Billing bi 
			where bi.unityid=unity_id and rownum=1			
			order by bi.billid desc; 
		else
			outstanding_amount:=0;
		end if;

		curr_outstanding_amount := outstanding_amount + bill_amount;

		-- create a new billing entry
		insert into Billing(billid, unityid, billamount, duedate, outstandingamount) 
		values(1, unity_id, bill_amount, trunc(SYSDATE), curr_outstanding_amount);
	
	end loop;
	
	EXCEPTION 
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Some Exception occured. Try again.');
            DBMS_OUTPUT.PUT_LINE('Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200));
            -- success := 'Some Exception occured. Try again.' || CHR(10) || 'Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200);
        RETURN;
end;
/
-- show err