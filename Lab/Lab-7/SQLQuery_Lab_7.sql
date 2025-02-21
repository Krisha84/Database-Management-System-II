-- LAB-7 :

-- Create the Customers table
CREATE TABLE Customers (
	Customer_id INT PRIMARY KEY, 
	Customer_Name VARCHAR(250) NOT NULL, 
	Email VARCHAR(50) UNIQUE 
)

-- Create the Orders table
CREATE TABLE Orders (
	Order_id INT PRIMARY KEY, 
	Customer_id INT, 
	Order_date DATE NOT NULL, 
	FOREIGN KEY (Customer_id) REFERENCES Customers(Customer_id) 
)


-- PART_A :

-- 1. Handle Divide by Zero Error and Print message like: Error occurs that is - Divide by zero error.
BEGIN TRY
    DECLARE @n1 INT = 10
	DECLARE @n2 INT = 0
	DECLARE @result INT

    SET @result = @n1 / @n2
END TRY

BEGIN CATCH
    PRINT 'Error occurs that is - Divide by zero error.'
END CATCH

-- sp
CREATE OR ALTER PROCEDURE PR_Handle_DivideByZero
	@N1 INT,
	@N2 INT
AS
BEGIN
    BEGIN TRY
		DECLARE @result INT

        SET @result = @N1 / @N2

		PRINT @result
    END TRY
    BEGIN CATCH
        PRINT 'Error occurs that is - Divide by zero error.'
    END CATCH
END

EXEC PR_Handle_DivideByZero 11, 0
EXEC PR_Handle_DivideByZero 22, 2


-- 2. Try to convert string to integer and handle the error using try…catch block.
BEGIN TRY
    DECLARE @s1 NVARCHAR(50) = 'abc'
    DECLARE @n INT

    SET @n = CAST(@s1 AS INT)
END TRY
BEGIN CATCH
    PRINT 'Error occurs during conversion from string to integer.'
END CATCH

-- sp
CREATE OR ALTER PROCEDURE PR_Handle_StringToIntConversion
    @s1 NVARCHAR(50)
AS
BEGIN
    BEGIN TRY
        DECLARE @N INT
        SET @N = CAST(@s1 AS INT)
        PRINT 'Conversion successful. Integer value: ' + CAST(@N AS NVARCHAR(50))
    END TRY
    BEGIN CATCH
        PRINT 'Error occurs during conversion from string to integer.'
    END CATCH
END

EXEC PR_Handle_StringToIntConversion '123'
EXEC PR_Handle_StringToIntConversion 'ABC'



-- 3. Create a procedure that prints the sum of two numbers: take both numbers as integer & handle 
--    exception with all error functions if any one enters string value in numbers otherwise print result.
CREATE OR ALTER PROCEDURE PR_SumTwoNumbersWithException
    @N1 NVARCHAR(50),
    @N2 NVARCHAR(50)
AS
BEGIN
    BEGIN TRY
        DECLARE @result INT
        SET @result = CAST(@N1 AS INT) + CAST(@N2 AS INT)
        PRINT 'Sum of the two numbers is: ' + CAST(@result AS NVARCHAR(50))
    END TRY
    BEGIN CATCH
        PRINT 'Error Message :' + ERROR_MESSAGE()
		PRINT 'Error Number :' + CAST(ERROR_NUMBER() AS NVARCHAR(10))
		PRINT 'State :' + CAST(ERROR_STATE() AS NVARCHAR(10))
		PRINT 'Line :' + CAST(ERROR_LINE() AS NVARCHAR(10))
		PRINT 'Severity :' + CAST(ERROR_SEVERITY() AS NVARCHAR(10))
    END CATCH
END

EXEC PR_SumTwoNumbersWithException 20, 10
EXEC PR_SumTwoNumbersWithException 44, 'xyz'


-- 4. Handle a Primary Key Violation while inserting data into customers table and print the error details 
--    such as the error message, error number, severity, and state.
CREATE OR ALTER PROCEDURE PR_Customers_Insert
    @Customer_id INT,
    @Customer_Name NVARCHAR(250),
    @Email NVARCHAR(50)
AS
BEGIN
    BEGIN TRY
        INSERT INTO Customers (Customer_id, Customer_Name, Email)
        VALUES (@Customer_id, @Customer_Name, @Email);
    END TRY
    BEGIN CATCH
        PRINT 'Error occurred: Primary Key Violation.'
        PRINT 'Error Message: ' + ERROR_MESSAGE()
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR(10))
        PRINT 'Severity: ' + CAST(ERROR_SEVERITY() AS NVARCHAR(10))
        PRINT 'State: ' + CAST(ERROR_STATE() AS NVARCHAR(10))
    END CATCH
END

EXEC PR_Customers_Insert 101, 'Customer1', 'customer1@gmail.com'
EXEC PR_Customers_Insert 101, 'Customer2', 'customer2@gmail.com'


-- 5. Throw custom exception using stored procedure which accepts Customer_id as input & that throws 
--    Error like no Customer_id is available in database.
CREATE OR ALTER PROCEDURE PR_CustomerS_CheckCustomerID
	@Customer_id INT
AS
BEGIN
	IF NOT EXISTS (SELECT 1 FROM Customers WHERE Customer_id = @Customer_id)
	BEGIN
		THROW 50001, 'No Customer ID is available in database.', 1
	END 
	ELSE
	BEGIN
		PRINT 'Customer ID is exists.'
	END
END

SELECT * FROM Customers
EXEC PR_CustomerS_CheckCustomerID 101



-- PART_B :

-- 6. Handle a Foreign Key Violation while inserting data into Orders table and print appropriate error 
--    message.
CREATE OR ALTER PROCEDURE PR_Orders_Insert
    @Order_id INT,
    @Customer_id INT,
    @Order_date DATE
AS
BEGIN
    BEGIN TRY
        INSERT INTO Orders (Order_id, Customer_id, Order_date)
        VALUES (@Order_id, @Customer_id, @Order_date)
    END TRY
    BEGIN CATCH
            PRINT 'An unexpected error occurred.';
            PRINT 'Error Message: ' + ERROR_MESSAGE()
            PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR(10))
            PRINT 'Severity: ' + CAST(ERROR_SEVERITY() AS NVARCHAR(10))
            PRINT 'State: ' + CAST(ERROR_STATE() AS NVARCHAR(10))
    END CATCH
END

EXEC PR_Orders_Insert 3, 101, '2025-01-11'
EXEC PR_Orders_Insert 1, 101, '2025-02-21'
EXEC PR_Orders_Insert 2, 111, '2025-02-13'


-- 7. Throw custom exception that throws error if the data is invalid.
CREATE OR ALTER PROCEDURE PR_Customers_CheckValidCustomerId
    @Customer_id INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Customers WHERE Customer_id = @Customer_id)
    BEGIN
        RAISERROR ('Invalid Customer_id. No Customer ID is available in database.', 16, 1)
    END
    ELSE
    BEGIN
        PRINT 'Valid Customer_id.'
    END
END
EXEC PR_Customers_CheckValidCustomerId 101EXEC PR_Customers_CheckValidCustomerId 111-- 8. Create a Procedure to Update Customer’s Email with Error HandlingCREATE OR ALTER PROCEDURE PR_Customers_UpdateEmailWithErrorHandling	@Customer_id INT,	@NewEmail VARCHAR(50)ASBEGIN	IF @NewEmail NOT LIKE '_%@_%._%'	BEGIN		THROW 50001, 'Error: Invalid email format', 1	END	BEGIN TRY		UPDATE Customers		SET Email = @NewEmail		WHERE Customer_id = @Customer_id	END TRY	BEGIN CATCH		PRINT 'Error occurred while updating email.';
            PRINT 'Error Message: ' + ERROR_MESSAGE()
            PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR(10))	END CATCHENDEXEC PR_Customers_UpdateEmailWithErrorHandling 101, 'newcustomer1@gmail.com'EXEC PR_Customers_UpdateEmailWithErrorHandling 101, 'customer1-email'-- PART_C :-- 9. Create a procedure which prints the error message that “The Customer_id is already taken. Try another 
--    one”.
CREATE OR ALTER PROCEDURE PR_Customers_HandleDuplicateCustomerId
    @Customer_id INT,
    @Customer_Name NVARCHAR(250),
    @Email NVARCHAR(50)
AS
BEGIN
    BEGIN TRY
        INSERT INTO Customers (Customer_id, Customer_Name, Email)
        VALUES (@Customer_id, @Customer_Name, @Email)

        PRINT 'Customer inserted successfully.'
    END TRY
    BEGIN CATCH
        PRINT 'Error: The Customer_id is already taken. Try another one.'
    END CATCH
END

EXEC PR_Customers_HandleDuplicateCustomerId 104, 'NewCustomer', 'customer4@gmail.com'


-- 10. Handle Duplicate Email Insertion in Customers Table.CREATE OR ALTER PROCEDURE PR_Customers_HandleDuplicateEmailInsertion
    @Customer_id INT,
    @Customer_Name NVARCHAR(250),
    @Email NVARCHAR(50)
AS
BEGIN
    BEGIN TRY
        INSERT INTO Customers (Customer_id, Customer_Name, Email)
        VALUES (@Customer_id, @Customer_Name, @Email)

        PRINT 'Customer inserted successfully.'
    END TRY
    BEGIN CATCH
        PRINT 'Error: The email is already in use. Please use a different email.'
    END CATCH
END

EXEC PR_Customers_HandleDuplicateEmailInsertion 107, 'Customer7', 'customer7@gmail.com'
EXEC PR_Customers_HandleDuplicateEmailInsertion 108, 'Customer8', 'customer7@gmail.com'