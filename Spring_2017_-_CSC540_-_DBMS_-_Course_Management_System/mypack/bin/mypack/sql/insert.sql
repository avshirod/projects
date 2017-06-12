----insert into tables
	
insert into Students values(200109814, 'CSC', 3.5, 3, 2, 2015);
insert into Students values(200109815, 'CSC', 3.6, 3, 2, 2015);
--insert into Students values(200109816, 2, 3.76, 3, 2, 2015);

insert into Course values(540,'' ,DBMS, 3, 3, 2);

insert into UnityUsers values('garadhy', 'Gaurav', 'Aradhye','garadhy@ncsu.edu', 'M', TO_DATE('10/03/1990', 'MM/DD/YYYY'), '2518,Avent Ferry Rd, Raleigh, 27606', 9194855845, 3, 'password1');
insert into UnityUsers values('asupeka','Anuja', 'Supekar', 'asupeka@ncsu.edu','F', TO_DATE('07/13/1993', 'MM/DD/YYYY'), '2518,Avent Ferry Rd, Raleigh, 27606', 9198039478, 3, 'password2');
insert into UnityUsers values('ashirod', 'Aditya', 'Shirode', 'ashirod@ncsu.edu', 'M', TO_DATE('10/05/1991', 'MM/DD/YYYY'), '2518,Avent Ferry Rd, Raleigh, 27606', 9193334443, 2, 'password3');

insert into Employee values(123456789);

insert into Faculty values('123456789', '2');

insert into Semester values(22017, 'Spring', '2017', TO_DATE('11/15/2016', 'MM/DD/YYYY'), TO_DATE('03/31/2017', 'MM/DD/YYYY'), TO_DATE('01/06/2017', 'MM/DD/YYYY'), TO_DATE('05/05/2017', 'MM/DD/YYYY'));

insert into Departments values('CSC', 'Computer Science');
insert into Departments values('ECE', 'Electrical and Computer Engineering');

insert into CourseOffering values(1, 540,'' ,22017, 1, '11:45 pm', '1:00 pm', 'EB2 02207', 40, 00, 10);

Insert into Facilitates values(1, '123456789');






















