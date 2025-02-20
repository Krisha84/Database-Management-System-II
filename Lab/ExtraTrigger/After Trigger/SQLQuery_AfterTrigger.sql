-- Extra_Trigger :

-- AFTER Trigger :

-- EmployeeDetails :
CREATE TABLE EmployeeDetails
(
	EmployeeID Int Primary Key,
	EmployeeName Varchar(100) Not Null,
	ContactNo Varchar(100) Not Null,
	Department Varchar(100) Not Null,
	Salary Decimal(10,2) Not Null,
	JoiningDate DateTime Null
)


-- EmployeeLogs :
CREATE TABLE EmployeeLogs (
    LogID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeID INT NOT NULL,
    EmployeeName VARCHAR(100) NOT NULL,
    ActionPerformed VARCHAR(100) NOT NULL,
    ActionDate DATETIME NOT NULL
)


-- 1. Create a trigger that fires AFTER INSERT, UPDATE, and DELETE operations on the EmployeeDetails table to 
--    display the message "Employee record inserted", "Employee record updated", "Employee record deleted"

-- INSERT
CREATE OR ALTER TRIGGER TR_Employee_Insert
ON EmployeeDetails
AFTER INSERT
AS
BEGIN
    PRINT 'Employee record inserted'
END

INSERT INTO EmployeeDetails 
VALUES (101, 'ABC', '0123456789', 'IT', 120000, '2024-04-05')

SELECT * FROM EmployeeDetails

DROP TRIGGER TR_Employee_Insert


-- UPDATE
CREATE OR ALTER TRIGGER TR_Employee_Update
ON EmployeeDetails
AFTER UPDATE
AS
BEGIN
    PRINT 'Employee record updated'
END

UPDATE EmployeeDetails
SET Department = 'CS'
WHERE EmployeeID = 101

SELECT * FROM EmployeeDetails

DROP TRIGGER TR_Employee_Update


-- DELETE
CREATE OR ALTER TRIGGER TR_Employee_Delete
ON EmployeeDetails
AFTER DELETE
AS
BEGIN
    PRINT 'Employee record deleted'
END

DELETE FROM EmployeeDetails
WHERE EmployeeID = 101

SELECT * FROM EmployeeDetails

DROP TRIGGER TR_Employee_Delete



-- 2. Create a trigger that fires AFTER INSERT, UPDATE, and DELETE operations on the EmployeeDetails table to 
--    log all operations into the EmployeeLog table.

-- INSERT
CREATE OR ALTER TRIGGER TR_Employee_InsertLog
ON EmployeeDetails
AFTER INSERT
AS
BEGIN
	DECLARE @EmployeeID INT
	DECLARE @EmployeeName VARCHAR(100)

	SELECT @EmployeeID = EmployeeID FROM inserted
	SELECT @EmployeeName = EmployeeName FROM inserted

    INSERT INTO EmployeeLogs
    VALUES (@EmployeeID, @EmployeeName, 'INSERT', GETDATE())
END

INSERT INTO EmployeeDetails 
VALUES (101, 'ABC', '0123456789', 'IT', 120000, NULL)

SELECT * FROM EmployeeDetails
SELECT * FROM EmployeeLogs

DROP TRIGGER TR_Employee_InsertLog


-- UPDATE
CREATE OR ALTER TRIGGER TR_Employee_UpdateLog
ON EmployeeDetails
AFTER UPDATE
AS
BEGIN
	DECLARE @EmployeeID INT
	DECLARE @EmployeeName VARCHAR(100)

	SELECT @EmployeeID = EmployeeID FROM inserted
	SELECT @EmployeeName = EmployeeName FROM inserted

    INSERT INTO EmployeeLogs
    VALUES (@EmployeeID, @EmployeeName, 'UPDATE', GETDATE())
END

UPDATE EmployeeDetails
SET Department = 'CS'
WHERE EmployeeID = 101

SELECT * FROM EmployeeDetails
SELECT * FROM EmployeeLogs

DROP TRIGGER TR_Employee_UpdateLog


-- DELETE
CREATE OR ALTER TRIGGER TR_Employee_DeleteLog
ON EmployeeDetails
AFTER DELETE
AS
BEGIN
	DECLARE @EmployeeID INT
	DECLARE @EmployeeName VARCHAR(100)

	SELECT @EmployeeID = EmployeeID FROM deleted
	SELECT @EmployeeName = EmployeeName FROM deleted

    INSERT INTO EmployeeLogs
    VALUES (@EmployeeID, @EmployeeName, 'DELETE', GETDATE())
END

DELETE FROM EmployeeDetails
WHERE EmployeeID = 101

SELECT * FROM EmployeeDetails
SELECT * FROM EmployeeLogs

DROP TRIGGER TR_Employee_DeleteLog



-- 3. Create a trigger that fires AFTER INSERT to automatically calculate the joining bonus (10% of the salary) 
--    for new employees and update a bonus column in the EmployeeDetails table.
ALTER TABLE EmployeeDetails ADD Bonus DECIMAL(10,2)

CREATE OR ALTER TRIGGER TR_Employee_AddBonus
ON EmployeeDetails
AFTER INSERT
AS
BEGIN
	DECLARE @Salary DECIMAL(10,2)
	DECLARE @EmployeeID INT

	SELECT @Salary = Salary FROM inserted
	SELECT @EmployeeID = EmployeeID FROM inserted

    UPDATE EmployeeDetails
    SET Bonus = @Salary * 0.10
    WHERE EmployeeID = @EmployeeID
END

INSERT INTO EmployeeDetails (EmployeeID, EmployeeName, ContactNo, Department, Salary, JoiningDate)
VALUES (102, 'XYZ', '9876543210', 'IT', 230000, '2019-11-23')

SELECT * FROM EmployeeDetails 

DROP TRIGGER TR_Employee_AddBonus



-- 4. Create a trigger to ensure that the JoiningDate is automatically set to the current date 
--    if it is NULL during an INSERT operation.
CREATE OR ALTER TRIGGER TR_Set_JoiningDate
ON EmployeeDetails
AFTER INSERT
AS
BEGIN
	DECLARE @EmployeeID INT

	SELECT @EmployeeID = EmployeeID FROM inserted

    UPDATE EmployeeDetails
    SET JoiningDate = GETDATE()
    WHERE EmployeeID = @EmployeeID
    AND JoiningDate IS NULL
END

INSERT INTO EmployeeDetails (EmployeeID, EmployeeName, ContactNo, Department, Salary, JoiningDate)
VALUES (103, 'PQR', '4561230789', 'EC', 50000, NULL)

SELECT * FROM EmployeeDetails

DROP TRIGGER TR_Set_JoiningDate



-- 5. Create a trigger that ensure that ContactNo is valid during insert and update 
--    (Like ContactNo length is 10)

-- UPDATE
CREATE OR ALTER TRIGGER TR_Validate_ContactNo_Update
ON EmployeeDetails
AFTER UPDATE
AS
BEGIN
	DECLARE @EmployeeID INT

	SELECT @EmployeeID = EmployeeID FROM inserted

    UPDATE EmployeeDetails
    SET ContactNo = NULL
    WHERE EmployeeID = @EmployeeID
    AND LEN(ContactNo) <> 10
    
    PRINT 'Invalid ContactNo updated to NULL during UPDATE'
END

INSERT INTO EmployeeDetails (EmployeeID, EmployeeName, ContactNo, Department, Salary, JoiningDate)
VALUES (110, 'abc', '9876543210', 'IT', 60000, '2024-03-10')

UPDATE EmployeeDetails
SET ContactNo = '1234'
WHERE EmployeeID = 110

SELECT * FROM EmployeeDetails 

DROP TRIGGER TR_Validate_ContactNo_Update

-- INSERT
CREATE OR ALTER TRIGGER TR_Validate_ContactNo_Insert
ON EmployeeDetails
AFTER INSERT
AS
BEGIN
	DECLARE @EmployeeID INT

	SELECT @EmployeeID = EmployeeID FROM inserted

    UPDATE EmployeeDetails
    SET ContactNo = NULL
    WHERE EmployeeID = @EmployeeID
    AND LEN(ContactNo) <> 10
    
    PRINT 'Invalid ContactNo updated to NULL during INSERT'
END

-- Invalid Insert (ContactNo will be set to NULL)
INSERT INTO EmployeeDetails (EmployeeID, EmployeeName, ContactNo, Department, Salary, JoiningDate)
VALUES (111, 'xyz', '12345', 'Marketing', 55000, '2024-02-15')

SELECT * FROM EmployeeDetails 

DROP TRIGGER TR_Validate_ContactNo_Insert