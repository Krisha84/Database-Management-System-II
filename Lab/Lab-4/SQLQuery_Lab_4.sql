-- LAB-4 :


-- PART_A :

-- 1. Write a function to print "hello world".
CREATE OR ALTER FUNCTION FN_HELLOWORLD()
RETURNS VARCHAR(50)
AS
BEGIN
	RETURN 'Hello World !!'
END

SELECT dbo.FN_HELLOWORLD()


-- 2. Write a function which returns addition of two numbers.
CREATE OR ALTER FUNCTION FN_ADD_TWO(
@N1 INT,
@N2 INT
)
RETURNS INT
AS 
BEGIN
	DECLARE @ANS INT
	SET @ANS = @N1 + @N2
	RETURN @ANS
END

SELECT dbo.FN_ADD_TWO(2,9)


-- 3. Write a function to check whether the given number is ODD or EVEN.
CREATE OR ALTER FUNCTION FN_ODD_EVEN(
@N INT )
RETURNS VARCHAR(50)
AS
BEGIN
	DECLARE @MSG VARCHAR(50)
	IF @N%2 = 0
		SET @MSG = 'EVEN'
	ELSE
		SET @MSG = 'ODD'

	RETURN @MSG
END

SELECT dbo.FN_ODD_EVEN(11)


-- 4. Write a function which returns a table with details of a person whose first name starts with B.
CREATE OR ALTER FUNCTION FN_PERSON_STARTSWITH_B()
RETURNS TABLE
AS
	RETURN ( SELECT *
			 FROM PERSON
			 WHERE FirstName LIKE 'B%' )

SELECT * FROM dbo.FN_PERSON_STARTSWITH_B()


-- 5. Write a function which returns a table with unique first names from the person table.
CREATE OR ALTER FUNCTION FN_UNIQUE_FNAME()
RETURNS TABLE
AS
	RETURN ( SELECT DISTINCT FirstName
			 FROM PERSON )

SELECT * FROM dbo.FN_UNIQUE_FNAME()


-- 6. Write a function to print number from 1 to N. (Using while loop)
CREATE OR ALTER FUNCTION FN_1TON(
@N INT
)
RETURNS VARCHAR(100)
AS
BEGIN
	DECLARE @ANS VARCHAR(100) = '',
			@I INT = 1

	WHILE @I <= @N
	BEGIN 
		SET @ANS = @ANS + CAST(@I AS VARCHAR) + ' '
		SET @I = @I +1
	END

	RETURN @ANS
END

SELECT dbo.FN_1TON(10)


-- 7. Write a function to find the factorial of a given integer.
CREATE OR ALTER FUNCTION FN_FACT(
@N INT
)
RETURNS INT
AS
BEGIN
	DECLARE @FACT INT = 1,
			@I INT = 1
	WHILE @I <= @N
	BEGIN
		SET @FACT = @FACT * @I
		SET @I = @I + 1
	END

	RETURN @FACT
END

SELECT dbo.FN_FACT(5)



-- PART_B :

-- 8. Write a function to compare two integers and return the comparison result. (Using Case statement)
CREATE OR ALTER FUNCTION FN_CAMPARE_TWO(
@N1 INT,
@N2 INT
)
RETURNS VARCHAR(100)
AS
BEGIN
	RETURN CASE
		WHEN @N1 > @N2 THEN CAST(@N1 AS VARCHAR)+' IS GREATER !!'
		WHEN @N2 > @N1 THEN CAST(@N2 AS VARCHAR)+' IS GREATER !!'
		ELSE CAST(@N1 AS VARCHAR)+' AND '+CAST(@N2 AS VARCHAR)+' BOTH ARE EQUAL !!'
	END
END

SELECT dbo.FN_CAMPARE_TWO(111,120)


-- 9. Write a function to print the sum of even numbers between 1 to 20.
CREATE OR ALTER FUNCTION FN_ADD_EVEN()
RETURNS INT
AS 
BEGIN
	DECLARE @SUM INT = 0,
			@I INT = 1
	WHILE @I <= 20
	BEGIN
		IF @I%2 = 0
		BEGIN
			SET @SUM = @SUM + @I
		END

		SET @I = @I + 1
	END

	RETURN @SUM
END

SELECT dbo.FN_ADD_EVEN()


-- 10. Write a function that checks if a given string is a palindrome
CREATE OR ALTER FUNCTION FN_PALINDROME(
@N INT
)
RETURNS VARCHAR(100)
AS
BEGIN
    DECLARE @MSG VARCHAR(100) = ''
    DECLARE @R INT  
    DECLARE @OG INT = @N
    DECLARE @ANS INT = 0

    WHILE @N > 0
    BEGIN
        SET @R = @N % 10
        SET @ANS = @ANS * 10 + @R
        SET @N = @N / 10
    END

    IF @OG = @ANS
        SET @MSG = CAST(@OG AS VARCHAR) + ' is Palindrome !!'
    ELSE 
        SET @MSG = CAST(@OG AS VARCHAR) + ' is not Palindrome !!'

    RETURN @MSG
END

SELECT dbo.FN_PALINDROME(12321)



-- PART_C :

-- 11. Write a function to check whether a given number is prime or not.
CREATE OR ALTER FUNCTION FN_PRIME(
@N INT
)
RETURNS VARCHAR(100)
AS 
BEGIN
	DECLARE @MSG VARCHAR(100) = ''
	DECLARE @I INT = 1
	DECLARE @COUNT INT = 0
	
	WHILE @I <= @N
	BEGIN
		IF @N%@I = 0
		BEGIN
			SET @COUNT = @COUNT + 1
		END
		SET @I = @I + 1
	END

	IF @COUNT>2
		SET @MSG = CAST(@N AS VARCHAR)+' is not Prime !!'
	ELSE
		SET @MSG = CAST(@N AS VARCHAR)+' is Prime !!'

	RETURN @MSG
END

SELECT dbo.FN_PRIME(7)


-- 12. Write a function which accepts two parameters start date & end date, and returns a difference in days.
CREATE OR ALTER FUNCTION FN_DATEDIFF_DAYS(
@D1 DATE,
@D2 DATE
)
RETURNS INT
AS 
BEGIN
	RETURN DATEDIFF(DAY,@D1,@D2)
END

SELECT dbo.FN_DATEDIFF_DAYS('2006-04-05',GETDATE())


-- 13. Write a function which accepts two parameters year & month in integer and returns total days each year.
CREATE OR ALTER FUNCTION FN_TOTAL_DAYS(
@YEAR INT,
@MONTH INT
)
RETURNS INT
AS
BEGIN
	DECLARE @ANS VARCHAR(100)
	DECLARE @DATE DATE
	DECLARE @DAY INT

	SET @ANS = CAST(@YEAR AS VARCHAR)+'-'+CAST(@MONTH AS VARCHAR)+'-1'
	SET @DATE = CAST(@ANS AS DATE)

	SET @DAY = DAY(EOMONTH(@DATE))

	RETURN @DAY
END

SELECT dbo.FN_TOTAL_DAYS(2024,4)


-- 14. Write a function which accepts departmentID as a parameter & returns a detail of the persons.
CREATE OR ALTER FUNCTION FN_PERSON_DID(
@DID INT
)
RETURNS TABLE
AS
	RETURN ( SELECT * 
			 FROM PERSON
			 WHERE DepartmentID = @DID )

SELECT * FROM dbo.FN_PERSON_DID(1)


-- 15. Write a function that returns a table with details of all persons who joined after 1-1-1991.
CREATE OR ALTER FUNCTION FN_PERSON_JDATE()
RETURNS TABLE
AS
	RETURN ( SELECT * 
			 FROM PERSON
			 WHERE JoiningDate > '1991-01-01' )

SELECT * FROM dbo.FN_PERSON_JDATE()
