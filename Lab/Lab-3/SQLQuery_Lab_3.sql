-- LAB-3 : (Advanced Stored Procedure) 

CREATE TABLE Departments ( 
	DepartmentID INT PRIMARY KEY, 
	DepartmentName VARCHAR(100) NOT NULL UNIQUE, 
	ManagerID INT NOT NULL, 
	Location VARCHAR(100) NOT NULL 
); 

CREATE TABLE Employee ( 
	EmployeeID INT PRIMARY KEY, 
	FirstName VARCHAR(100) NOT NULL, 
	LastName VARCHAR(100) NOT NULL, 
	DoB DATETIME NOT NULL, 
	Gender VARCHAR(50) NOT NULL, 
	HireDate DATETIME NOT NULL, 
	DepartmentID INT NOT NULL, 
	Salary DECIMAL(10, 2) NOT NULL, 
	FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID) 
); 

-- Create Projects Table 
CREATE TABLE Projects ( 
	ProjectID INT PRIMARY KEY, 
	ProjectName VARCHAR(100) NOT NULL, 
	StartDate DATETIME NOT NULL, 
	EndDate DATETIME NOT NULL, 
	DepartmentID INT NOT NULL, 
	FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID) 
); 


INSERT INTO Departments (DepartmentID, DepartmentName, ManagerID, Location) 
VALUES  
(1, 'IT', 101, 'New York'), 
(2, 'HR', 102, 'San Francisco'), 
(3, 'Finance', 103, 'Los Angeles'), 
(4, 'Admin', 104, 'Chicago'), 
(5, 'Marketing', 105, 'Miami')


INSERT INTO Employee (EmployeeID, FirstName, LastName, DoB, Gender, HireDate, DepartmentID, 
Salary) 
VALUES  
(101, 'John', 'Doe', '1985-04-12', 'Male', '2010-06-15', 1, 75000.00), 
(102, 'Jane', 'Smith', '1990-08-24', 'Female', '2015-03-10', 2, 60000.00), 
(103, 'Robert', 'Brown', '1982-12-05', 'Male', '2008-09-25', 3, 82000.00), 
(104, 'Emily', 'Davis', '1988-11-11', 'Female', '2012-07-18', 4, 58000.00), 
(105, 'Michael', 'Wilson', '1992-02-02', 'Male', '2018-11-30', 5, 67000.00) 


INSERT INTO Projects (ProjectID, ProjectName, StartDate, EndDate, DepartmentID) 
VALUES  
(201, 'Project Alpha', '2022-01-01', '2022-12-31', 1), 
(202, 'Project Beta', '2023-03-15', '2024-03-14', 2), 
(203, 'Project Gamma', '2021-06-01', '2022-05-31', 3), 
(204, 'Project Delta', '2020-10-10', '2021-10-09', 4), 
(205, 'Project Epsilon', '2024-04-01', '2025-03-31', 5)

SELECT * FROM DEPARTMENTS
SELECT * FROM EMPLOYEE
SELECT * FROM PROJECTS

-- PART_A : 

-- 1. Create Stored Procedure for Employee table As User enters either First Name or Last Name and based 
--   on this you must give EmployeeID, DOB, Gender & Hiredate.
CREATE OR ALTER PROCEDURE PR_EMPLOYEE_GETBYNAME
	@FName VARCHAR(100) = NULL,
	@LName VARCHAR(100) = NULL
AS 
BEGIN 
	SELECT EmployeeID, FirstName, LastName, DoB, Gender, HireDate 
	FROM Employee
	WHERE (FirstName = @FName) OR (LastName = @LName)
END

-- ONLY CORRECTS WAYS ARE DESPLAYED BELOW
EXEC PR_EMPLOYEE_GETBYNAME 'JOHN';
EXEC PR_EMPLOYEE_GETBYNAME @LName = 'BROWN'
EXEC PR_EMPLOYEE_GETBYNAME 'EMILY','DAVIS'
EXEC PR_EMPLOYEE_GETBYNAME 'MICHAEL', NULL


-- 2. Create a Procedure that will accept Department Name and based on that gives employees list who 
--   belongs to that department.
CREATE OR ALTER PROCEDURE PR_DETAILS_GETBYDEPNAME
	@DEPNAME VARCHAR(100)
AS 
BEGIN
	SELECT E.*, D.DEPARTMENTNAME
	FROM Employee E
	INNER JOIN Departments D
	ON E.DepartmentID = D.DepartmentID
	WHERE D.DepartmentName = @DEPNAME
END

EXEC PR_DETAILS_GETBYDEPNAME 'FINANCE'


-- 3. Create a Procedure that accepts Project Name & Department Name and based on that you must give 
--    all the project related details.  
CREATE OR ALTER PROCEDURE PR_DETAILS_DEPPRO
	@PRONAME VARCHAR(100),
	@DEPNAME VARCHAR(100)
AS 
BEGIN
	SELECT P.*, D.DEPARTMENTNAME
	FROM Projects P
	INNER JOIN Departments D
	ON P.DepartmentID = D.DepartmentID
	WHERE (D.DepartmentName = @DEPNAME) 
	AND (P.ProjectName = @PRONAME)
END

EXEC PR_DETAILS_DEPPRO 'Project Beta', 'HR'

-- 4. Create a procedure that will accepts any integer and if salary is between provided integer, then those 
--   employee list comes in output.  
CREATE OR ALTER PROCEDURE PR_EMP_SALARY
	@MAX_SAL INT,
	@MIN_SAL INT
AS 
BEGIN 
	SELECT EmployeeID, FirstName, LastName, DoB, Gender, HireDate 
	FROM Employee
	WHERE Salary>@MIN_SAL 
	AND Salary<@MAX_SAL
END

EXEC PR_EMP_SALARY 90000,70000


-- 5. Create a Procedure that will accepts a date and gives all the employees who all are hired on that date.  
CREATE OR ALTER PROCEDURE PR_EMP_HIREDATE
	@HD DATETIME
AS 
BEGIN 
	SELECT EmployeeID, FirstName, LastName, DoB, Gender, HireDate 
	FROM Employee
	WHERE HireDate = @HD
END

EXEC PR_EMP_HIREDATE '2008-09-25'



--PART_B : 

-- 6. Create a Procedure that accepts Gender�s first letter only and based on that employee details will be served.  
CREATE OR ALTER PROCEDURE PR_EMP_GENDER
	@GEN VARCHAR(1)
AS 
BEGIN 
	SELECT EmployeeID, FirstName, LastName, DoB, Gender, HireDate 
	FROM Employee
	WHERE Gender LIKE @GEN+'%'
END

EXEC PR_EMP_GENDER 'F'


-- 7. Create a Procedure that accepts First Name or Department Name as input and based on that employee 
--   data will come.  
CREATE OR ALTER PROCEDURE PR_EMPLOYEE_GETBYNAME
	@FName VARCHAR(100) = NULL,
	@DepName VARCHAR(100)= NULL
AS 
BEGIN 
	SELECT E.*, D.DEPARTMENTNAME
	FROM Employee E
	INNER JOIN Departments D
	ON E.DepartmentID = D.DepartmentID
	WHERE (FirstName = @FName) 
	OR (D.DepartmentName = @DEPNAME)
END

EXEC PR_EMPLOYEE_GETBYNAME 'JOHN'
EXEC PR_EMPLOYEE_GETBYNAME NULL, 'MARKETING'


-- 8. Create a procedure that will accepts location, if user enters a location any characters, then he/she will 
--   get all the departments with all data.  
CREATE OR ALTER PROCEDURE PR_DEP_LOCATION
	@Location VARCHAR(100)
AS 
BEGIN 
	SELECT *
	FROM Departments 
	WHERE Location = @Location
END

EXEC PR_DEP_LOCATION 'Chicago'



-- PART_C : 

-- 9. Create a procedure that will accepts From Date & To Date and based on that he/she will retrieve Project 
--   related data.  
CREATE OR ALTER PROCEDURE PR_PROJ_DATES
	@SDATE DATETIME,
	@EDATE DATETIME
AS 
BEGIN 
	SELECT *
	FROM Projects 
	WHERE StartDate = @SDATE 
	AND EndDate = @EDATE
END

EXEC PR_PROJ_DATES '2021-06-01','2022-05-31'


-- 10. Create a procedure in which user will enter project name & location and based on that you must 
--     provide all data with Department Name, Manager Name with Project Name & Starting Ending Dates. 
CREATE OR ALTER PROCEDURE PR_DETAILS_PROLOC
	@PRONAME VARCHAR(100),
	@LOCNAME VARCHAR(100)
AS 
BEGIN
	SELECT D.DEPARTMENTNAME,D.ManagerID, P.ProjectName, P.StartDate,P.EndDate
	FROM Projects P
	INNER JOIN Departments D
	ON P.DepartmentID = D.DepartmentID
	WHERE (P.ProjectName = @PRONAME) 
	AND (D.Location = @LOCNAME)
END

EXEC PR_DETAILS_PROLOC 'Project Gamma', 'Los Angeles'