-- LAB-2 :

-- Create Department Table
CREATE TABLE Department (
	DepartmentID INT PRIMARY KEY,
	DepartmentName VARCHAR(100) NOT NULL UNIQUE
);

-- Create Designation Table
CREATE TABLE Designation (
	DesignationID INT PRIMARY KEY,
	DesignationName VARCHAR(100) NOT NULL UNIQUE
);

-- Create Person Table
CREATE TABLE Person (
	PersonID INT PRIMARY KEY IDENTITY(101,1),
	FirstName VARCHAR(100) NOT NULL,
	LastName VARCHAR(100) NOT NULL,
	Salary DECIMAL(8, 2) NOT NULL,
	JoiningDate DATETIME NOT NULL,
	DepartmentID INT NULL,
	DesignationID INT NULL,
	FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID),
	FOREIGN KEY (DesignationID) REFERENCES Designation(DesignationID)
);


--PART_A :

--1. Department, Designation & Person Table’s INSERT, UPDATE & DELETE Procedures.
-- DEPARTMENT_INSERT
CREATE OR ALTER PROCEDURE PR_DEPARTMENT_INSERT
@DeptID int,
@DeptName varchar(100)
AS
BEGIN
	INSERT INTO DEPARTMENT 
	VALUES ( @DeptID , @DeptName )
END

EXEC PR_DEPARTMENT_INSERT 1,'Admin'
EXEC PR_DEPARTMENT_INSERT 2,'IT'
EXEC PR_DEPARTMENT_INSERT 3,'HR'
EXEC PR_DEPARTMENT_INSERT 4,'Account'

SELECT * FROM DEPARTMENT

-- DESIGNATION_INSERT
CREATE OR ALTER PROCEDURE PR_DESIGNATION_INSERT
@DesID int,
@DesName varchar(100)
AS
BEGIN
	INSERT INTO DESIGNATION 
	VALUES ( @DesID , @DesName )
END

EXEC PR_DESIGNATION_INSERT 11,'Jobber'
EXEC PR_DESIGNATION_INSERT 12,'Welder'
EXEC PR_DESIGNATION_INSERT 13,'Clerk'
EXEC PR_DESIGNATION_INSERT 14,'Manager'
EXEC PR_DESIGNATION_INSERT 15,'CEO'

SELECT * FROM DESIGNATION

-- PERSON_INSERT
CREATE OR ALTER PROCEDURE PR_PERSON_INSERT
@FName VARCHAR(100),
@LName VARCHAR(100),
@Salary DECIMAL(8,2),
@JDate DATETIME,
@DeptID INT,
@DesID INT
AS
BEGIN
	INSERT INTO PERSON 
	VALUES ( @FName , @LName , @Salary , @JDate , @DeptID , @DesID )
END

EXEC PR_PERSON_INSERT 'Rahul','Anshu',56000,'1990-01-01',1,12
EXEC PR_PERSON_INSERT 'Hardik','Hinsu',18000,'1990-09-025',2,11
EXEC PR_PERSON_INSERT 'Bhavin','Kamani',25000,'1991-05-14',NULL,11
EXEC PR_PERSON_INSERT 'Bhoomi','Patel',39000,'2014-02-20',1,13
EXEC PR_PERSON_INSERT 'Rohit','Rajgor',17000,'1990-07-23',2,15
EXEC PR_PERSON_INSERT 'Priya','Mehta',25000,'1990-10-18',2,NULL
EXEC PR_PERSON_INSERT 'Neha','Trivedi',18000,'2014-02-20',3,15

SELECT * FROM PERSON


-- DEPARTMENT_UPDATE
CREATE OR ALTER PROCEDURE PR_DEPARTMENT_UPDATE
@DeptID INT,
@DeptName VARCHAR(100)
AS
BEGIN
	UPDATE DEPARTMENT
	SET DepartmentName = @DeptName
	WHERE DepartmentID = @DeptID
END

-- DESIGNATION_UPDATE
CREATE OR ALTER PROCEDURE PR_DESIGNATION_UPDATE
@DesID INT,
@DesName VARCHAR(100)
AS
BEGIN
	UPDATE DESIGNATION
	SET DesignationName = @DesName
	WHERE DesignationID = @DesID
END

-- PERSON_UPDATE 
CREATE OR ALTER PROCEDURE PR_PERSON_UPDATE
@PerID INT,
@FName VARCHAR(100),
@LName VARCHAR(100)
AS
BEGIN
	UPDATE PERSON
	SET FirstName = @FName , LastName = @LName
	WHERE PersonID = @PerID
END


-- DEPARTMENT_DELETE
CREATE OR ALTER PROCEDURE PR_DEPARTMENT_DLETE
@DeptID INT
AS
BEGIN
	DELETE FROM DEPARTMENT
	WHERE DepartmentID = @DeptID
END

-- DESIGNATION_DELETE
CREATE OR ALTER PROCEDURE PR_DESIGNATION_DELETE
@DesID INT
AS
BEGIN
	DELETE FROM DESIGNATION
	WHERE DesignationID = @DesID
END

-- PERSON_DELETE
CREATE OR ALTER PROCEDURE PR_PERSON_DELETE
@PerID INT
AS
BEGIN
	DELETE FROM PERSON
	WHERE PersonID = @PerID
END


--2. Department, Designation & Person Table’s SELECTBYPRIMARYKEY

-- DEPARTMENT_SELECTBY_PRIMARYKEY
CREATE OR ALTER PROCEDURE PR_DEPARTMENT_SELECTBY_PK
@DeptID INT
AS
BEGIN
	SELECT * FROM DEPARTMENT
	WHERE DepartmentID = @DeptID
END

EXEC PR_DEPARTMENT_SELECTBY_PK 1

-- DESIGNATION_SELECTBY_PRIMARYKEY
CREATE OR ALTER PROCEDURE PR_DESIGNATION_SELECTBY_PK
@DesID INT
AS
BEGIN
	SELECT * FROM DESIGNATION
	WHERE DesignationID = @DesID
END

EXEC PR_DESIGNATION_SELECTBY_PK 11

-- PERSON_SELECTBY_PRIMARYKEY
CREATE OR ALTER PROCEDURE PR_PERSON_SELECTBY_PK
@PerID INT
AS
BEGIN
	SELECT * FROM PERSON
	WHERE PersonID = @PerID
END

EXEC PR_PERSON_SELECTBY_PK 101


--3. Department, Designation & Person Table’s (If foreign key is available then do write join and take columns on select list)

-- DEPARTMENT_SELECTALL
CREATE OR ALTER PROCEDURE PR_DEPARTMENT_SELECTALL
AS
BEGIN
	SELECT * FROM DEPARTMENT
END

EXEC PR_DEPARTMENT_SELECTALL

-- DESIGNATION_SELECTALL
CREATE OR ALTER PROCEDURE PR_DESIGNATION_SELECTALL
AS
BEGIN
	SELECT * FROM DESIGNATION
END

EXEC PR_DESIGNATION_SELECTALL

-- PERSON_SELECTALL
CREATE OR ALTER PROCEDURE PR_PERSON_SELECTALL
AS
BEGIN
	SELECT P.PersonID , P.FirstName , P.LastName , P.Salary , P.JoiningDate , 
		   D.DepartmentName , DE.DesignationName
	FROM PERSON P
	JOIN Department D 
	ON P.DepartmentID = D.DepartmentID
	JOIN DESIGNATION DE
	ON P.DesignationID = DE.DesignationID
END

EXEC PR_PERSON_SELECTALL


--4. Create a Procedure that shows details of the first 3 persons.
CREATE OR ALTER PROCEDURE PR_PERSON_TOP3
AS
BEGIN
	SELECT TOP 3 * 
	FROM PERSON
END

EXEC PR_PERSON_TOP3


-- PART_B :

--5. Create a Procedure that takes the department name as input and returns a table with all workers 
--   working in that department.
CREATE OR ALTER PROCEDURE PR_PD_DETAIL
@DeptName VARCHAR(100)
AS
BEGIN 
	SELECT P.FirstName , D.DepartmentName
	FROM PERSON P
	JOIN DEPARTMENT D
	ON P.DepartmentID = D.DepartmentID
	WHERE D.DepartmentName = @DeptName
END

EXEC PR_PD_DETAIL 'HR'


--6. Create Procedure that takes department name & designation name as input and returns a table with 
--   worker’s first name, salary, joining date & department name.
CREATE OR ALTER PROCEDURE PR_PDDE_DETAIL
@DeptName VARCHAR(100),
@DesName VARCHAR(100)
AS
BEGIN
	SELECT P.FirstName , P.Salary , P.JoiningDate , D.DepartmentName
	FROM PERSON P
	JOIN DEPARTMENT D
	ON P.DepartmentID = D.DepartmentID
	JOIN DESIGNATION DE
	ON P.DesignationID = DE.DesignationID
	WHERE D.DepartmentName = @DeptName 
	AND DE.DesignationName = @DesName
END

EXEC PR_PDDE_DETAIL 'Admin','Clerk'


--7. Create a Procedure that takes the first name as an input parameter and display all the details of the 
--   worker with their department & designation name.
CREATE OR ALTER PROCEDURE PR_PERSON_DETAIL
@FName VARCHAR(100)
AS
BEGIN
	SELECT P.* , D.DepartmentName , DE.DesignationName
	FROM PERSON P
	JOIN DEPARTMENT D
	ON P.DepartmentID = D.DepartmentID
	JOIN DESIGNATION DE
	ON P.DesignationID = DE.DesignationID
	WHERE P.FirstName = @FName 
END

EXEC PR_PERSON_DETAIL 'Bhoomi'


--8. Create Procedure which displays department wise maximum, minimum & total salaries.
CREATE OR ALTER PROCEDURE PR_PERSON_SALARY
AS
BEGIN
	SELECT D.DepartmentName , MAX(P.Salary) AS Max_Salary ,  
		   MIN(P.Salary) AS Min_Salary , SUM(P.Salary) AS Total_Salary
	FROM PERSON P
	JOIN DEPARTMENT D
	ON P.DepartmentID = D.DepartmentID
	GROUP BY DepartmentName
END

EXEC PR_PERSON_SALARY


--9. Create Procedure which displays designation wise average & total salaries.
CREATE OR ALTER PROCEDURE PR_PDE_SALARY
AS
BEGIN
	SELECT DE.DesignationName , AVG(P.Salary) AS Avg_Salary , SUM(P.Salary) AS Total_Salary
	FROM PERSON P
	JOIN DESIGNATION DE
	ON P.DesignationID = DE.DesignationID
	GROUP BY DesignationName
END

EXEC PR_PDE_SALARY



--PART_C :

--10. Create Procedure that Accepts Department Name and Returns Person Count.
CREATE OR ALTER PROCEDURE PR_DP_COUNT
@DeptName VARCHAR(100)
AS
BEGIN 
	SELECT D.DepartmentName , COUNT(P.PersonID) AS Count_Person
	FROM PERSON P 
	JOIN DEPARTMENT D
	ON P.DepartmentID = D.DepartmentID
	WHERE D.DepartmentName = @DeptName
	GROUP BY D.DepartmentName
END

EXEC PR_DP_COUNT 'IT'


--11. Create a procedure that takes a salary value as input and returns all workers with a salary greater than 
--    input salary value along with their department and designation details.
CREATE OR ALTER PROCEDURE PR_B_11
@Salary DECIMAL(8,2)
AS
BEGIN
	SELECT P.FirstName , P.Salary , D.DepartmentName , DE.DesignationName
	FROM PERSON P
	JOIN DEPARTMENT D
	ON P.DepartmentID = D.DepartmentID
	JOIN DESIGNATION DE
	ON P.DesignationID = DE.DesignationID
	WHERE P.Salary > @Salary
END

EXEC PR_B_11 25000


--12. Create a procedure to find the department(s) with the highest total salary among all departments.
CREATE OR ALTER PROCEDURE PR_DEPT_HIGHEST_SALARY
AS
BEGIN
    SELECT TOP 1 D.DepartmentName, SUM(P.Salary) AS TotalSalary
    FROM Person P
    JOIN Department D 
	ON P.DepartmentID = D.DepartmentID
    GROUP BY D.DepartmentName
    ORDER BY TotalSalary DESC
END

EXEC PR_DEPT_HIGHEST_SALARY

--13. Create a procedure that takes a designation name as input and returns a list of all workers under that 
--    designation who joined within the last 10 years, along with their department.
CREATE OR ALTER PROCEDURE PR_WORKERS_LAST_10_YEARS
    @DesignationName VARCHAR(100)
AS
BEGIN
    SELECT P.FirstName, P.LastName, D.DepartmentName
    FROM Person P
    JOIN Department D 
	ON P.DepartmentID = D.DepartmentID
    JOIN Designation DE 
	ON P.DesignationID = DE.DesignationID
    WHERE DE.DesignationName = @DesignationName
    AND P.JoiningDate >= DATEADD(year, -10, GETDATE())
END

EXEC PR_WORKERS_LAST_10_YEARS 'CEO'


--14. Create a procedure to list the number of workers in each department who do not have a designation 
--    assigned.
CREATE OR ALTER PROCEDURE PR_WORKERS_WITHOUT_DESIGNATION
AS
BEGIN
    SELECT D.DepartmentName, COUNT(P.PersonID) AS Count_Without_Designation
    FROM Department D
    LEFT JOIN Person P 
	ON D.DepartmentID = P.DepartmentID
    WHERE P.DesignationID IS NULL
    GROUP BY D.DepartmentName
END

EXEC PR_WORKERS_WITHOUT_DESIGNATION


--15. Create a procedure to retrieve the details of workers in departments where the average salary is above 
--    12000.
CREATE OR ALTER PROCEDURE PR_DEPT_AVG_SALARY_ABOVE_12000
AS
BEGIN
    SELECT D.DepartmentName, AVG(P.Salary) AS AvgSalary
    FROM Department D
    JOIN Person P 
	ON D.DepartmentID = P.DepartmentID
    GROUP BY D.DepartmentName
    HAVING AVG(P.Salary) > 12000
END

EXEC PR_DEPT_AVG_SALARY_ABOVE_12000