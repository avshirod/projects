## [ER Diagram](/er_diagram_v2.png) Explained
#### CSC 540 - Project 1 - Spring 2017

[comment]: # (ER Diagram along with the listing of entity and relationship types and a sentence description for each and list of key, participation constraints and other constraints represented in the ER model, along with a sentence description for each)

### Entities
1. **UnityUsers**: Stores users of the system. Is classified into Employees (further classified as Faculty and Admins), and Students.
2. **Course**: Stores details about a courses that have been offered. (Not to be confused with a particular CourseOffering).
3. **Department**: Stores the departmentID (Codes such as 'CSC', 'ECE',etc.) and deptName.
4. **Semester**: Stores details for a particular semester (Seasons can be Fall, Spring, Summer), Add-Drop Dates, Semester Start-End Dates.
5. **Credit Requirements**: Stores the Min and Max Credits required corresponding to a combination between Participation Level (Undergraduate/ Graduate) and Residency Level (In-state/ Out-state/ International).
6. **Special Permissions**: Stores details about special permission codes ('PREREQ', 'SPPERM').

We also have two weak entities - **Billing** and **Permission Mapping**.
Billing stores the details about students and their bills as they are generated (and updated).
Permission mapping stores the special permissions required for a particular course offering (such as prerequisites, GPA requirements).



### Relationships

(1) All the users of the system are classified as *UnityUsers*.
This has a **'ISA'** relationship with *Employee* and *Students*. Employees have a further *ISA* classification into *Faculty* and *Admin*.
A full participation for all of these is necessary, meaning a UnityUser has to be classified into either of the three types - Student, Faculty, or Admin Staff.

(2) *Courses* are **offered under** *Departments*. (One-to-One mapping)
*Courses* are **offered during** *Semesters* which results in a *CourseOffering*. (We have represented CourseOffering as a separate Relationship Table, to avoid a complex quaternary relationship between tables.)

(3) *Students* **have** a Bill in *Billing* table, based on *Course Offerings* for that student **in** *Transcript* and *Waitlist*. (One-to-Many mappings)

(4) *Faculty* is a **member of** a particular *Department*. He/ she also **facilitates** a *CourseOffering*. (One-to-one mapping for both)

(5) *CourseOfferings* have *Courses* as **Prerequisites**. (One-to-Many mapping)
They also **require** *special permissions* mapped in *Permission Mapping*. (One-to-Many mapping)
*Students* can **request** these permissions for a particular Course Offering. (One-to-One mapping)

(6) Based on *Credit Requirement*, there are **Billing Rates** defined per *Semester*. (One-to-Many mapping)


