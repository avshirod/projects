# CSC 540 - Project 1 - Spring 2017
## Course Management System

*Course: Database Management Concepts and Systems (Dr. Kemafor Ogan)* 


### Team Members

| Member Name | Unity ID |
| :---------- | :------: |
| Anuja Supekar | *asupeka* |
| Aditya Shirode | *avshirod* |
| Gaurav Aradhye | *garadhye* |
| Kahan Prabhu | *kprabhu* |

### How to run this project?  

1. The **sql** files (table creation, population) for the project are stored in [this](https://github.ncsu.edu/garadhy/CSC-540-project/tree/master/mypack/src/mypack/sql) folder.
The procedures are in [this](https://github.ncsu.edu/garadhy/CSC-540-project/tree/master/mypack/src/mypack/procedures) folder.  
2. To initially create the project (table creation and population), run the **['run_script.sql'](https://github.ncsu.edu/garadhy/CSC-540-project/tree/master/mypack/src/mypack/run_script.sql)** file (which should be outside both of the '/sql' and '/procedures' folders. If it is not, copy the *run_script.sql* file from */sql* folder and put it in the parent directory of both '/sql' and '/procedures' folders.)  
This script (as you can see in the script) calls the required *sql* files for database schema creation.
3. After you successfully run the **run_script.sql**, the database will be populated with initial values. And is ready to be worked/ tested upon.

This is the recommended method to easily setup the schema.  
Although, as requested in the project document, *two* separate *sql* files have been provided in the */sql* folder - **database_creation.sql** for Schema creation (includes table creation, constraints, procedures, triggers) and **database_population.sql** for Table Population.

### Project Description
The goal of the project is to design a relational database application for supporting course registration at a university (similar to *MyPack* for *NC State*).  
The application manages different kinds of data about students and courses, subject to a variety of application requirements that are given in use cases. 
More details can be found here [Problem Statement](/docs/problem_statement.pdf).

### Related Documents
[Problem Statement](/docs/problem_statement.pdf)  
[Worksheet.MD](/docs/WORKSHEET.md)  
[ER Diagram](/docs/er_diagram_v2.png)  
[ER Diagram Details](/docs/ER_Diagram.md)  
[Relational Model](/docs/Relational_Model.md)  
[System Constraints](/docs/Constraints.md)  
[SQL Files](/mypack/src/mypack/sql)  
[Final Application Executable](db_project1.jar)  
[README.txt](/docs/README.txt)  