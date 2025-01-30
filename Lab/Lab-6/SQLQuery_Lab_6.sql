-- LAB-6 :

CREATE TABLE Products (
    Product_id INT PRIMARY KEY,
    Product_Name VARCHAR(250) NOT NULL,
    Price DECIMAL(10, 2) NOT NULL
);

INSERT INTO Products (Product_id, Product_Name, Price) VALUES
(1, 'Smartphone', 35000),
(2, 'Laptop', 65000),
(3, 'Headphones', 5500),
(4, 'Television', 85000),
(5, 'Gaming Console', 32000)



-- PART_A :

-- 1. Create a cursor Product_Cursor to fetch all the rows from a products table.
DECLARE @PROID INT, @PRONAME VARCHAR(250), @PROPRICE DECIMAL(10,2)

DECLARE Product_Cursor CURSOR
FOR SELECT *
	FROM Products

OPEN Product_Cursor

FETCH NEXT FROM Product_Cursor
INTO @PROID, @PRONAME, @PROPRICE;

WHILE @@FETCH_STATUS = 0
	BEGIN 
		SELECT @PROID AS PRODUCT_ID, 
			  @PRONAME AS PRODUCT_NAME, 
			  @PROPRICE AS PRODUCT_PRICE

		FETCH NEXT FROM Product_Cursor
		INTO @PROID, @PRONAME, @PROPRICE
	END

CLOSE Product_Cursor

DEALLOCATE Product_Cursor


-- 2. Create a cursor Product_Cursor_Fetch to fetch the records in form of ProductID_ProductName. (Example: 1_Smartphone)
DECLARE @ProductInfo VARCHAR(300)

DECLARE Product_Cursor_Fetch CURSOR
FOR SELECT CAST(PRODUCT_ID AS VARCHAR) + '_' + PRODUCT_NAME AS ProductInfo
	FROM Products

OPEN Product_Cursor_Fetch

FETCH NEXT FROM Product_Cursor_Fetch
INTO @ProductInfo

WHILE @@FETCH_STATUS = 0
	BEGIN 
		PRINT @ProductInfo

		FETCH NEXT FROM Product_Cursor_Fetch
		INTO @ProductInfo
	END

CLOSE Product_Cursor_Fetch

DEALLOCATE Product_Cursor_Fetch


-- 3. Create a Cursor to Find and Display Products Above Price 30,000.
DECLARE @PROID INT, @PRONAME VARCHAR(250), @PROPRICE DECIMAL(10,2)

DECLARE Products_Above_30000 CURSOR
FOR SELECT *
	FROM Products
	WHERE PRICE>30000

OPEN Products_Above_30000

FETCH NEXT FROM Products_Above_30000
INTO @PROID, @PRONAME, @PROPRICE

WHILE @@FETCH_STATUS = 0
	BEGIN 
		PRINT CAST(@PROID AS VARCHAR(250)) + '_' + 
		      CAST(@PRONAME AS VARCHAR(250)) + '_' + 
		      CAST(@PROPRICE AS VARCHAR(250))

		FETCH NEXT FROM Products_Above_30000
		INTO @PROID, @PRONAME, @PROPRICE
	END

CLOSE Products_Above_30000

DEALLOCATE Products_Above_30000


-- 4. Create a cursor Product_CursorDelete that deletes all the data from the Products table.
DECLARE @PROID INT

DECLARE Product_CursorDelete CURSOR
FOR SELECT PRODUCT_ID
	FROM Products

OPEN Product_CursorDelete

FETCH NEXT FROM Product_CursorDelete
INTO @PROID;

WHILE @@FETCH_STATUS = 0
	BEGIN 
		DELETE FROM PRODUCTS 
		WHERE PRODUCT_ID = @PROID

		FETCH NEXT FROM Product_CursorDelete
		INTO @PROID
	END

CLOSE Product_CursorDelete

DEALLOCATE Product_CursorDelete



-- PART_B :

-- 5. Create a cursor Product_CursorUpdate that retrieves all the data from the products table and increases the price by 10%.
DECLARE @PROID INT, @PROPRICE DECIMAL(10,2)

DECLARE Product_CursorUpdate CURSOR
FOR SELECT Product_id, Price
	FROM Products

OPEN Product_CursorUpdate

FETCH NEXT FROM Product_CursorUpdate
INTO @PROID, @PROPRICE

WHILE @@FETCH_STATUS = 0
	BEGIN 
		UPDATE PRODUCTS
		SET @PROPRICE = (@PROPRICE * 0.1) + @PROPRICE
		WHERE Product_id = @PROID

		FETCH NEXT FROM Product_CursorUpdate
		INTO @PROID, @PROPRICE
	END

CLOSE Product_CursorUpdate

DEALLOCATE Product_CursorUpdate


-- 6. Create a Cursor to Rounds the price of each product to the nearest whole number.
DECLARE @PROID INT, @PROPRICE DECIMAL(10,2)

DECLARE Product_CursorUpdate_Round CURSOR
FOR SELECT Product_id, Price
	FROM Products

OPEN Product_CursorUpdate_Round

FETCH NEXT FROM Product_CursorUpdate_Round
INTO @PROID, @PROPRICE

WHILE @@FETCH_STATUS = 0
	BEGIN 
		UPDATE PRODUCTS
		SET Price = CEILING(Price)
		WHERE Product_id = @PROID

		FETCH NEXT FROM Product_CursorUpdate_Round
		INTO @PROID, @PROPRICE
	END

CLOSE Product_CursorUpdate_Round

DEALLOCATE Product_CursorUpdate_Round



-- PART_C :

-- 7. Create a cursor to insert details of Products into the NewProducts table if the product is “Laptop” 
-- (Note: Create NewProducts table first with same fields as Products table)
CREATE TABLE NewProducts ( 
	Product_id INT PRIMARY KEY, 
	Product_Name VARCHAR(250) NOT NULL, 
	Price DECIMAL(10, 2) NOT NULL 
)


DECLARE @PROID INT, @PRONAME VARCHAR(250) ,@PROPRICE DECIMAL(10,2) 

DECLARE Product_Insert CURSOR

FOR SELECT Product_id, Product_Name, Price
	FROM Products
	WHERE Product_Name = 'Laptop'

OPEN Product_Insert

FETCH NEXT FROM Product_Insert
INTO @PROID, @PRONAME, @PROPRICE

WHILE @@FETCH_STATUS = 0
	BEGIN 
		INSERT INTO NewProducts(Product_id,Product_Name,Price)
		VALUES (@PROID, @PRONAME, @PROPRICE)

		FETCH NEXT FROM Product_Insert
		INTO @PROID, @PRONAME, @PROPRICE
	END

CLOSE Product_Insert

DEALLOCATE Product_Insert


-- 8. Create a Cursor to Archive High-Price Products in a New Table (ArchivedProducts), Moves products 
-- with a price above 50000 to an archive table, removing them from the original Products table.
CREATE TABLE Archieved_Products ( 
	Product_id INT PRIMARY KEY, 
	Product_Name VARCHAR(250) NOT NULL, 
	Price DECIMAL(10, 2) NOT NULL 
)

DECLARE @PROID INT, @PRONAME VARCHAR(250) ,@PROPRICE DECIMAL(10,2) 

DECLARE Product_Archieve CURSOR

FOR SELECT Product_id, Product_Name, Price
	FROM Products
	WHERE Price>50000

OPEN Product_Archieve

FETCH NEXT FROM Product_Archieve
INTO @PROID, @PRONAME, @PROPRICE

WHILE @@FETCH_STATUS = 0
	BEGIN 
		INSERT INTO Archieved_Products(Product_id,Product_Name,Price)
		VALUES (@PROID, @PRONAME, @PROPRICE)

		DELETE FROM Products WHERE Product_id = @PROID

		FETCH NEXT FROM Product_Archieve
		INTO @PROID, @PRONAME, @PROPRICE
	END

CLOSE Product_Archieve

DEALLOCATE Product_Archieve