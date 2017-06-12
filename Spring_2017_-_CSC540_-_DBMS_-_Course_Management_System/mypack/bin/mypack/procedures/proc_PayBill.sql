-- Pay bill for a given unityID
-- Entry in billing as negative amount

CREATE OR REPLACE PROCEDURE proc_PayBill(
	unity_id 	IN Students.unityID%type,
	bill_amount IN Billing.billAmount%type,
	message OUT VARCHAR2
)

IS
	outstanding_amount 		Billing.outstandingamount%type := 0;
	curr_outstanding_amount number;
	dummy 					number;
	bill					number;

BEGIN

	IF bill_amount < 0 THEN
		message := 'Incorrect bill amount. Please try again.';
		RETURN;
	END IF;

	select count(*) into dummy
	from Billing bi 
	where bi.unityid=unity_id;

	-- Get last bill's outstanding amount (if bill exists)
	if dummy !=0 then
		select outstandingamount into outstanding_amount from (
			select bi.outstandingamount
			from Billing bi 
			where bi.unityid=unity_id
			order by bi.billid desc
		)
		where rownum < 2;
	else
		outstanding_amount:=0;
	end if;
	
	bill := -bill_amount;
	curr_outstanding_amount:= outstanding_amount + bill;

	insert into Billing(billid, unityid, billamount, duedate, outstandingamount) 
	values(1, unity_id, bill, trunc(SYSDATE), curr_outstanding_amount);
	
	message := 'success';

    EXCEPTION 
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Some Exception occured. Try again.');
            DBMS_OUTPUT.PUT_LINE('Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200));
            message := 'Some Exception occured. Try again.' || CHR(10) || 'Error Description = ' || SQLCODE || CHR(9) || SUBSTR(SQLERRM, 1, 200);
        RETURN;
end;
/
-- show err;