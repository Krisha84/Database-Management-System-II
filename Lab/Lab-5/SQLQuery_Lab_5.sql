-- LAB-5 :

-- Creating PersonInfo Table
CREATE TABLE PersonInfo (
	PersonID INT PRIMARY KEY,
	PersonName VARCHAR(100) NOT NULL,
	Salary DECIMAL(8,2) NOT NULL,
	JoiningDate DATETIME NULL,
	City VARCHAR(100) NOT NULL,
	Age INT NULL,
	BirthDate DATETIME NOT NULL
)

-- Creating PersonLog Table
CREATE TABLE PersonLog (
	PLogID INT PRIMARY KEY IDENTITY(1,1),
	PersonID INT NOT NULL,
	PersonName VARCHAR(250) NOT NULL,
	Operation VARCHAR(50) NOT NULL,
	UpdateDate DATETIME NOT NULL
)


-- PART_A :

-- 1. Create a trigger that fires on INSERT, UPDATE and DELETE operation on the PersonInfo table to display 
--    a message “Record is Affected.” 
CREATE TRIGGER TR_PERSONINFO_RECORDAFFECTED
ON PersonInfo
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    PRINT 'Record is Affected'
END

INSERT INTO PersonInfo
VALUES (102, 'AB', 10000, '2021-11-17', 'AHEMDABAD', 21, '2004-08-06')

SELECT * FROM PersonInfo

DROP TRIGGER TR_PERSONINFO_RECORDAFFECTED


-- 2. Create a trigger that fires on INSERT, UPDATE and DELETE operation on the PersonInfo table. For that, 
--    log all operations performed on the person table into PersonLog.

-- INSERT
CREATE TRIGGER TR_PERSONINFO_LOGINSERT
ON PersonInfo
AFTER INSERT
AS
BEGIN
	DECLARE @PersonID INT
	DECLARE @PersonName VARCHAR(250)

	SELECT @PersonID = PersonID FROM inserted
	SELECT @PersonName = PersonName FROM inserted

    INSERT INTO PersonLog
    VALUES (@PersonID, @PersonName, 'INSERT', GETDATE())
END

INSERT INTO PERSONINFO
VALUES (101, 'KB', 100000, '2020-02-20', 'RJK', 11, '2006-05-04')

SELECT * FROM PersonLog

DROP TRIGGER TR_PERSONINFO_LOGINSERT


-- UPDATE
CREATE TRIGGER TR_PERSONINFO_LOGUPDATE
ON PersonInfo
AFTER UPDATE
AS
BEGIN
	DECLARE @PersonID INT
	DECLARE @PersonName VARCHAR(250)

	SELECT @PersonID = PersonID FROM inserted
	SELECT @PersonName = PersonName FROM inserted

    INSERT INTO PersonLog
    VALUES (@PersonID, @PersonName, 'UPDATE', GETDATE())
END

UPDATE PersonInfo
SET PersonID = 100
WHERE PersonName = 'AB'

SELECT * FROM PersonLog
SELECT * FROM PersonInfo
DROP TRIGGER TR_PERSONINFO_LOGUPDATE


-- DELETE 
CREATE TRIGGER TR_PERSONINFO_LOGDELETE
ON PersonInfo
AFTER DELETE
AS
BEGIN
	DECLARE @PersonID INT
	DECLARE @PersonName VARCHAR(250)

	SELECT @PersonID = PersonID FROM deleted
	SELECT @PersonName = PersonName FROM deleted

    INSERT INTO PersonLog
    VALUES (@PersonID, @PersonName, 'DELETE', GETDATE())
END

DELETE FROM PersonInfo
WHERE PersonName = 'KB'

SELECT * FROM PersonLog

DROP TRIGGER TR_PERSONINFO_LOGDELETE


-- 3. Create an INSTEAD OF trigger that fires on INSERT, UPDATE and DELETE operation on the PersonInfo 
--    table. For that, log all operations performed on the person table into PersonLog.

-- INSERT
CREATE TRIGGER TR_PERSONINFO_LOGINSERT
ON PersonInfo
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @PersonID INT
    DECLARE @PersonName VARCHAR(250)

    SELECT @PersonID = PersonID FROM inserted
	SELECT @PersonName = PersonName FROM inserted

    INSERT INTO PersonLog
    VALUES (@PersonID, @PersonName, 'INSERT', GETDATE())
END

INSERT INTO PERSONINFO
VALUES (101, 'KB', 100000, '2020-02-20', 'RJK', 18, '2006-05-04')
SELECT * FROM PersonLog

DROP TRIGGER TR_PERSONINFO_LOGINSERT


-- UPDATE
CREATE TRIGGER TR_PERSONINFO_LOGUPDATE
ON PersonInfo
INSTEAD OF UPDATE
AS
BEGIN
    DECLARE @PersonID INT
    DECLARE @PersonName VARCHAR(250)

    SELECT @PersonID = PersonID FROM inserted
	SELECT @PersonName = PersonName FROM inserted

    INSERT INTO PersonLog
    VALUES (@PersonID, @PersonName, 'UPDATE', GETDATE())
END

UPDATE PersonInfo
SET City = 'Rajkot'
WHERE PersonID = 101

SELECT * FROM PersonLog

DROP TRIGGER TR_PERSONINFO_LOGUPDATE


-- DELETE
CREATE TRIGGER TR_PERSONINFO_LOGDALETE
ON PersonInfo
INSTEAD OF DELETE
AS
BEGIN
    DECLARE @PersonID INT
    DECLARE @PersonName VARCHAR(250)

    SELECT @PersonID = PersonID FROM deleted
	SELECT @PersonName = PersonName FROM deleted

    INSERT INTO PersonLog
    VALUES (@PersonID, @PersonName, 'DELETE', GETDATE())
END

DELETE FROM PersonInfo
WHERE PersonID = 101

SELECT * FROM PersonLog

DROP TRIGGER TR_PERSONINFO_LOGDELETE



-- 4. Create a trigger that fires on INSERT operation on the PersonInfo table to convert person name into 
--    uppercase whenever the record is inserted.
CREATE TRIGGER TR_PERSONINFO_UPPERCASE
ON PersonInfo
INSTEAD OF INSERT
AS
BEGIN
	DECLARE @PersonID INT
    DECLARE @PersonName VARCHAR(100)
	DECLARE @Salary DECIMAL(8,2)
	DECLARE @JoiningDate DATETIME
	DECLARE @City VARCHAR(100)
	DECLARE @Age INT
	DECLARE @BirthDate DATETIME

    SELECT @PersonID = PersonID FROM inserted
	SELECT @PersonName = PersonName FROM inserted
	SELECT @Salary = Salary FROM inserted
	SELECT @JoiningDate = JoiningDate FROM inserted
	SELECT @City = City FROM inserted
	SELECT @Age = Age FROM inserted
	SELECT @BirthDate = BirthDate FROM inserted

    INSERT INTO PersonInfo
    VALUES (@PersonID, UPPER(@PersonName), @Salary, @JoiningDate, @City, @Age, @BirthDate)
END

INSERT INTO PERSONINFO
VALUES (237, 'Krisha', 100000, '2020-02-20', 'RJK', 18, '2006-05-04')
SELECT * FROM PersonLog

SELECT * FROM PersonInfo

DROP TRIGGER TR_PERSONINFO_UPPERCASE


-- 5. Create trigger that prevent duplicate entries of person name on PersonInfo table.
CREATE OR ALTER TRIGGER TR_PREVENT_DUPLICAT
ON PersonInfo
INSTEAD OF INSERT
AS
BEGIN
	INSERT INTO PersonInfo(PersonID, PersonName, Salary, JoiningDate, City, Age, BirthDate)
	SELECT PersonID, PersonName, Salary, JoiningDate, City, Age, BirthDate
	FROM inserted
	WHERE PersonName NOT IN (SELECT PersonName FROM PersonInfo)
END

DROP TRIGGER TR_PREVENT_DUPLICAT


-- 6. Create trigger that prevent Age below 18 years.
CREATE TRIGGER TR_PERSONINFO_PREVENTUNDERAGE
ON PersonInfo
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @PersonID INT
    DECLARE @PersonName VARCHAR(100)
	DECLARE @Salary DECIMAL(8,2)
	DECLARE @JoiningDate DATETIME
	DECLARE @City VARCHAR(100)
	DECLARE @Age INT
	DECLARE @BirthDate DATETIME

    SELECT @PersonID = PersonID FROM inserted
	SELECT @PersonName = PersonName FROM inserted
	SELECT @Salary = Salary FROM inserted
	SELECT @JoiningDate = JoiningDate FROM inserted
	SELECT @City = City FROM inserted
	SELECT @Age = Age FROM inserted
	SELECT @BirthDate = BirthDate FROM inserted

    IF @Age < 18
    BEGIN
        INSERT INTO PersonInfo
		VALUES (@PersonID, @PersonName, @Salary, @JoiningDate, @City, @Age, @BirthDate)
    END
    ELSE
    BEGIN
         PRINT 'Age must be 18 or above !!'
    END
END

INSERT INTO PERSONINFO
VALUES (102, 'ABC', 50000, '2019-11-23', 'SURAT', 9, '20015-12-07')

DROP TRIGGER TR_PERSONINFO_PREVENTUNDERAGE



-- PART_B :

-- 7. Create a trigger that fires on INSERT operation on person table, which calculates the age and update 
--    that age in Person table.
CREATE OR ALTER TRIGGER TR_UPDATE_AGE
ON PersonInfo
AFTER INSERT
AS
BEGIN
	DECLARE @AGE INT
	DECLARE @BOD DATETIME
	DECLARE @PID INT

	SELECT @pid=personid from inserted
	SELECT @BOD=BIRTHDATE FROM inserted

	SET @AGE = DATEDIFF(YEAR, @BOD, GETDATE())

	UPDATE PersonInfo
	SET Age = @AGE
	WHERE PersonID = @PID
END

DROP TRIGGER TR_UPDATE_AGE


-- 8. Create a Trigger to Limit Salary Decrease by a 10%.
CREATE OR ALTER TRIGGER TR_SALARY_LIMIT
ON PersonInfo
AFTER INSERT
AS
BEGIN
	DECLARE @SAL DECIMAL(8,2)
	DECLARE @PID INT

	SELECT @PID = PersonID FROM inserted
	SELECT @SAL = Salary FROM inserted
	SET @SAL = @SAL - (@SAL * 0.1)

	UPDATE PersonInfo
	SET Salary = @SAL
	WHERE PersonID=  @PID
END

INSERT INTO PersonInfo VALUES
(8,'MIHIR',20000,'2024-05-21','RAJKOT',5,'2010-09-13')

SELECT * FROM PersonInfo

DROP TRIGGER TR_SALARY_LIMIT



-- PART_C :

-- 9. Create Trigger to Automatically Update JoiningDate to Current Date on INSERT if JoiningDate is NULL 
--    during an INSERT.
CREATE OR ALTER TRIGGER TR_UPDATE_DATE
ON PersonInfo
AFTER INSERT
AS
BEGIN
	DECLARE @PID INT
	DECLARE @DATE DATETIME

	SELECT @PID = PersonID FROM inserted
	SELECT @DATE = JoiningDate FROM inserted

	UPDATE PersonInfo
	SET @DATE = GETDATE()
	WHERE PersonID = @PID AND @DATE IS NULL
END

INSERT INTO PersonInfo VALUES
(13,'ALICE',20000,NULL,'RAJKOT',5,'2010-09-13')

DROP TRIGGER TR_UPDATE_DATE


-- 10. Create DELETE trigger on PersonLog table, when we delete any record of PersonLog table it prints 
--     ‘Record deleted successfully from PersonLog’.
CREATE TRIGGER TR_DeletePersonLog
ON PersonLog
AFTER DELETE
AS
BEGIN
    PRINT 'Record deleted successfully from PersonLog'
END

DELETE FROM PersonLog 
WHERE PersonID = 101

DROP TRIGGER TR_DeletePersonLog