/*
MOD LOG
Added DROP and CREATE DATABASE queries 10/4
Added Table and column definitions 10/4
Modified DROP clause to use master, this prevents SQL from throwing a database in use error 10/4
Added diskUserGT 10/4
added DROP LOGIN // DROP USER clause 10/4
Gave diskUserGT permission to read out of database 10/4
Deleted Band table 10/11
Deleted DiskArtist table 10/11
Replaced DiskArtist table with DiskHasArtist table 10/11
Removed references and relationships to deleted variables 10/11
Improved DROP logic 10/11
Added data into various tables 10/11

Added BEGIN and END clause to IF statement 10/18
Changed Artist table to include bands as well as individual artists 10/18
Added various queries + a view to browse database information 10/18

Added INSERT/UPDATE stored procedures for Artist table 10/22
Added INSERT/UPDATE stored procedures for Borrower table 10/23
Added INSERT/UPDATE stored procedures for CD table 10/23
*/

--If database already exists, this will delete and begin the rebuild process
use master;
GO
if DB_ID('disk_inventoryGT') is not null
BEGIN
DROP DATABASE disk_inventoryGT
DROP LOGIN diskUserGT
END
go

CREATE DATABASE disk_inventoryGT;
go

use disk_inventoryGT;
go

--This adds the various tables and their column definitions, the tables are created in order as to avoid errors
CREATE TABLE Inventory(
	Inventory_ID int NOT NULL identity primary key,
	status varchar(20) NOT NULL
	
);

CREATE TABLE Borrower(
	Borrower_ID int NOT NULL identity primary key,
	First_Name varchar(20) NOT NULL,
	Last_Name varchar(20) NOT NULL,
	Borrower_Phone_Number varchar(18) NOT NULL
);

CREATE TABLE Borrow_details(
	Borrow_ID int NOT NULL identity primary key,
	Borrower_ID int NOT NULL foreign key REFERENCES Borrower(Borrower_ID),
	Inventory_ID int NOT NULL foreign key REFERENCES Inventory(Inventory_ID),
	Borrowed_Date date NOT NULL,
	Returned_Date date NULL

);

CREATE TABLE Artist(
	Artist_ID int NOT NULL identity primary key,
	Artist_fname varchar(25) NOT NULL,
	Artist_lname varchar(25) NULL, 
	Artist_type varchar(12) NOT NULL
);


CREATE TABLE Disk_Has_Artist(
	Inventory_ID int NOT NULL foreign key REFERENCES Inventory(Inventory_ID),
	Artist_ID int NOT NULL foreign key REFERENCES Artist(Artist_ID),
	PRIMARY KEY (Inventory_ID, Artist_ID)
);

CREATE TABLE CD(
	CD_ID int NOT NULL  primary key foreign key REFERENCES Inventory(Inventory_ID),
	CD_Name varchar(100) NOT NULL,
	Release_Date date NOT NULL,
	Genre varchar(25) NOT NULL,
	
	
);

CREATE TABLE DVD(
	DVD_ID int NOT NULL primary key foreign key REFERENCES Inventory(Inventory_ID),
	DVD_Name varchar(100) NOT NULL,
	Release_Date date NOT NULL,
	Genre varchar(25) NOT NULL
		
);

--This adds login information and a user to which that information is associated
CREATE LOGIN diskUserGT WITH PASSWORD = 'Pa$$w0rd',
	DEFAULT_DATABASE = disk_inventoryGT;
CREATE USER diskUserGT for LOGIN diskUserGT;

--This allows the diskUserGT to look at the various tables within the disk_inventoryGT db
use disk_inventoryGT
ALTER ROLE db_datareader ADD MEMBER diskUserGT;

--This inserts data into the Inventory table
INSERT INTO Inventory (status)
VALUES ('Returned'),
		('Not Returned'),
		('Returned'),
		('Not Returned'),
		('Not Returned'),
		('Returned'),
		('Not Returned'),
		('Returned'),
		('Not Returned'),
		('Returned'),
		('Not Returned'),
		('Returned'),
		('Not Returned'),
		('Returned'),
		('Not Returned'),
		('Returned'),
		('Not Returned'),
		('Returned'),
		('Broken/Missing'),
		('Returned');

--This inserts data into the Borrower table
INSERT INTO Borrower(First_Name, Last_Name, Borrower_Phone_Number)
VALUES ('Randy', 'Flores', '555-123-4567'),
		('Sandy', 'Flores', '515-123-4567'),
		('Mandy', 'Flores', '525-123-4567'),
		('Candy', 'Flores', '535-123-4567'),
		('Ramsey', 'Flores', '545-123-4567'),
		('Ron', 'Flores', '565-123-4567'),
		('Romeo', 'Flores', '575-123-4567'),
		('Rando', 'Flores', '585-123-4567'),
		('Rhonda', 'Flores', '595-123-4567'),
		('Remy', 'Flores', '505-123-4567'),
		('Raw', 'Flores', '551-123-4567'),
		('Richard', 'Flores', '550-123-4567'),
		('Ronald', 'Flores', '552-123-4567'),
		('Ralph', 'Flores', '553-123-4567'),
		('Tandi', 'Flores', '554-123-4567'),
		('Lando', 'Flores', '556-123-4567'),
		('Luke', 'Flores', '557-123-4567'),
		('Arthur', 'Flores', '558-123-4567'),
		('Rudy', 'Flores', '559-123-4567'),
		('Escobar', 'Flores', '055-123-4567');
--This deletes 1 row using a WHERE clause
DELETE FROM Borrower WHERE Borrower_ID = 20;

--This inserts data into the BorrowDetails table (watch for reqs)
INSERT INTO Borrow_details(Borrower_ID, Inventory_ID, Borrowed_Date, Returned_Date)
VALUES (1, 1, '05/05/1996', '01/23/1997'),
		(1, 1, '05/05/1996', NULL),
		(1, 2, '05/05/1996', '01/23/1997'),
		(1, 2, '05/05/1997', NULL),
		(1, 3, '05/05/1996', '01/23/1997'),
		(1, 3, '05/05/1997', '01/23/1998'),
		(1, 4, '05/05/1996', '01/23/1997'),
		(1, 4, '05/05/1997', '01/23/1998'),
		(1, 4, '05/05/1999', '01/23/2001'),
		(1, 4, '05/05/2001', '01/23/2002'),
		(1, 5, '05/05/1996', '01/23/1997'),
		(1, 5, '05/05/1999', '01/23/2000'),
		(12, 3, '05/05/1999', '01/23/2000'),
		(12, 7, '05/05/1996', '01/23/1997'),
		(12, 8, '05/05/1996', '01/23/1997'),
		(12, 9, '05/05/1996', '01/23/1997'),
		(3, 10, '05/05/1996', '01/23/1997'),
		(3, 11, '05/05/1996', '01/23/1997'),
		(3, 12, '05/05/1996', '01/23/1997'),
		(3, 13, '05/05/1996', '01/23/1997');

--This inserts data into the Artist table
INSERT INTO Artist (Artist_fname, Artist_lname, Artist_type)
VALUES ('Jhonn', 'Balance', 'Individual'),
		('Peter', 'Christopherson', 'Individual'),
		('Chris', 'Carter', 'Individual'),
		('Fanni', 'Cosey', 'Individual'),
		('Genesis', 'P-Orridge', 'Individual'),
		('Monte', 'Cazazza', 'Individual'),
		('William', 'Bennett', 'Individual'),
		('Masami', 'Akita', 'Individual'),
		('Lou', 'Reed', 'Individual'),
		('John', 'Cale', 'Individual'),
		('Sterling', 'Morrison', 'Individual'),
		('Moe', 'Tucker', 'Individual'),
		('Gas', NULL, 'Band'),
		('Queen', NULL, 'Band'),
		('Dominick', 'Fernow', 'Individual'),
		('Aaron', 'Funk', 'Individual'),
		('Richard', 'James', 'Individual'),
		('Thomas', 'Bangalter', 'Individual'),
		('Guy', 'Hommem De Christo', 'Individual'),
		('Brian', 'Eno', 'Individual');

--This inserts data into the DiskHasArtist table (watch for reqs)
INSERT INTO Disk_Has_Artist (Inventory_ID, Artist_ID)
VALUES(1, 2),
		(1, 3),
		(1, 4),
		(1, 5),
		(2, 6),
		(3, 7),
		(4, 9),
		(4, 10),
		(4, 11),
		(4, 12),
		(5, 13),
		(6, 14),
		(7, 15),
		(8, 16),
		(9, 17),
		(10, 2),
		(11, 18),
		(11, 19),
		(12, 2),
		(13, 2);
--This inserts data into the CD table
INSERT INTO CD(CD_ID, CD_Name, Genre, Release_Date)
VALUES (1,'20 Jazz Funk Greats', 'Experimental', '12/01/1979'),
		(2,'The Worst Of Monte Cazazza', 'Noise', '01/01/1992'),
		(3,'Birthdeath Experience', 'Noise', '09/01/1980'),
		(4,'The Velvet Underground With Nico', 'Avant-Pop', '03/12/1967'),
		(5,'Pop', 'Ambient', '03/28/2000'),
		(6,'Blue Limbo', 'Electro-Pop', '02/13/2003'),
		(7,'A Simple Mark', 'Noise', '01/01/1998'),
		(8,'My So-Called Life', 'IDM DNB', '08/24/2010'),
		(9,'Richard D. James Album', 'IDM', '11/04/1996'),
		(10,'Discovery', 'House', '02/26/2001'),
		(11,'Soisong', 'Experimental', '01/01/2007'),
		(12,'Fire Of The Mind // The Ape Of Naples', 'Avant Pop', '12/02/2005'),
		(13,'Scatology', 'Industrial', '01/01/1984'),
		(14,'Heathen Earth', 'Industrial', '06/01/1980'),
		(15,'The Second Annual Report', 'Industrial', '11/01/1977'),
		(16,'The Third Annual Report of Throbbing Gristle', 'Industrial', '12/04/1978'),
		(17,'Live at the Highbury Roundhouse', 'Industrial', '01/01/1977'),
		(18,'Live at the Death Factory', 'Industrial', '05/01/1979'),
		(19,'TG NOW', 'Post-Industrial', '05/16/2004'),
		(20,'Ambient 1: Music For Airports', 'Ambient', '03/01/1978');
--This updates 1 row using a WHERE clause
UPDATE CD
SET CD_Name = 'D.O.A: The Third And Final Annual Report of Throbbing Gristle'
WHERE CD_Name = 'The Third Annual Report of Throbbing Gristle';

--Query to list the disks on loan that have not been returned
SELECT *
FROM Borrow_details
WHERE Returned_Date IS NULL;

--3. Show the disks in your database and any associated Individual artists only. Sort by Artist Last Name, First Name & Disk Name.
USE disk_inventoryGT
SELECT CD_Name AS 'Disk Name', CONVERT(varchar(10), Release_Date, 101) AS 'Release Date', Artist_fname AS 'ArtistFirstName', Artist_lname AS 'ArtistLastName'
FROM CD 
JOIN Disk_Has_Artist ON CD.CD_ID = Disk_Has_Artist.Inventory_ID
JOIN Artist ON Disk_Has_Artist.Artist_ID = Artist.Artist_ID
WHERE Artist.Artist_type = 'Individual'
ORDER BY Artist_lname, Artist_fname, 'Disk Name'

--4. Create a view called View_Individual_Artist that shows the artists’ names and not group names. Include the artist id in the view definition but do not display the id in your output
DROP VIEW IF EXISTS View_Individual_Artists;
GO
CREATE VIEW View_Individual_Artists AS
SELECT Artist_ID, Artist_fname, Artist_lname
FROM Artist
WHERE Artist_type = 'Individual';

GO
SELECT Artist_fname AS FirstName, Artist_lname AS LastName
FROM View_Individual_Artists

--5. Show the disks in your database and any associated Group artists only. Use the View_Individual_Artist view. Sort by Group Name & Disk Name.
SELECT CD_Name as 'Disk Name', CONVERT(varchar(10), Release_Date, 101) AS 'Release Date', Artist_fname AS 'Group Name'
FROM CD
JOIN Disk_Has_Artist ON CD.CD_ID = Disk_Has_Artist.Inventory_ID
JOIN Artist ON Disk_Has_Artist.Artist_ID = Artist.Artist_ID
WHERE Artist_type = 'Band'
ORDER BY Artist_fname, 'Disk Name'
GO

--6. Show which disks have been borrowed and who borrowed them. Sort by Borrower’s Last Name, then First Name, then Disk Name, then Borrowed Date, then Returned Date.
SELECT First_Name AS 'First', Last_Name AS 'Last', CD_Name AS 'Disk Name', Borrowed_Date AS 'Borrowed Date', Returned_Date AS 'Returned Date'
FROM Borrower
JOIN Borrow_details ON Borrower.Borrower_ID = Borrow_details.Borrow_ID
JOIN Inventory ON Borrow_details.Inventory_ID = Inventory. Inventory_ID
JOIN CD ON Inventory.Inventory_ID = CD.CD_ID
WHERE Inventory.status = 'Not Returned'
ORDER BY Last_Name, First_Name, CD_Name, Borrowed_Date, Returned_Date
--7. In disk_id order, show the number of times each disk has been borrowed.
SELECT CD_ID AS 'DiskId', CD_Name AS 'Disk Name', COUNT(*) AS 'Times Borrowed'
FROM CD
JOIN Inventory ON CD.CD_ID = Inventory.Inventory_ID
JOIN Borrow_details ON Inventory.Inventory_ID = Borrow_details.Inventory_ID
GROUP BY CD.CD_ID, CD_Name
ORDER BY CD_ID
--8. Show the disks outstanding or on-loan and who has each disk. Sort by disk name.
SELECT CD_Name AS 'Disk Name', Borrowed_Date AS 'Borrowed', Returned_Date AS 'Returned', Last_Name AS 'Last Name'
FROM Borrower
JOIN Borrow_details ON Borrower.Borrower_ID = Borrow_details.Borrow_ID
JOIN Inventory ON Borrow_details.Inventory_ID = Inventory. Inventory_ID
JOIN CD ON Inventory.Inventory_ID = CD.CD_ID
WHERE Borrow_details.Returned_Date IS NULL
ORDER BY CD_Name

--PROJECT 5
--2.
--Create Insert, Update, and Delete stored procedures for the artist table. Update procedure accepts a primary key value and the artist’s names for update. Insert accepts all columns as input parameters except for identity fields. Delete accepts a primary key value for delete.
USE disk_inventoryGT;
GO
--INSERT artist stored procedure
DROP PROC IF EXISTS sp_InsArtist;
GO

CREATE PROC sp_InsArtist
	@Artist_fname nvarchar(25),
	@Artist_type nvarchar(12),
	@Artist_lname nvarchar(25) = NULL
AS
--Error handling
BEGIN TRY
	INSERT INTO [dbo].[Artist]
			   ([Artist_fname]
			   ,[Artist_type]
			   ,[Artist_lname])
		 VALUES
			   (@Artist_fname
			   ,@Artist_type
			   ,@Artist_lname)
END TRY

BEGIN CATCH
		PRINT 'An error occurred. Row was not inserted.';
		PRINT 'Error number: ' +
        CONVERT(varchar(100), ERROR_NUMBER());
		PRINT 'Error message: ' +
        CONVERT(varchar(1000), ERROR_MESSAGE());
END CATCH
GO
--stored procedure execution
EXEC sp_InsArtist 'Cher', 'Individual'
GO

--UPDATE artist stored procedure
DROP PROC IF EXISTS sp_UpdArtist;
GO

CREATE PROC sp_UpdArtist
	@Artist_ID int,
	@Artist_fname nvarchar(25),
	@Artist_type nvarchar(12),
	@Artist_lname nvarchar(25) = NULL
AS
--error handling
BEGIN TRY
	UPDATE [dbo].[Artist]
	   SET [Artist_fname] = @Artist_fname
		  ,[Artist_type] = @Artist_type
		  ,[Artist_lname] = @Artist_lname
	 WHERE Artist_ID = @Artist_ID
END TRY

BEGIN CATCH
		PRINT 'An error occurred. Row was not updated.';
		PRINT 'Error number: ' +
        CONVERT(varchar(100), ERROR_NUMBER());
		PRINT 'Error message: ' +
        CONVERT(varchar(1000), ERROR_MESSAGE());
END CATCH
GO
--stored procedure execution
EXEC sp_UpdArtist 21, 'Bruno', 'Individual', 'Mars'
GO
--DELETE artist stored procedure
DROP PROC IF EXISTS sp_DelArtist;
GO
CREATE PROC sp_DelArtist
	@Artist_ID int
AS
--error handling
BEGIN TRY
	DELETE FROM [dbo].[Artist]
	WHERE Artist_ID = @Artist_ID
END TRY
BEGIN CATCH
PRINT 'An error occurred. Row was not deleted.';
		PRINT 'Error number: ' +
        CONVERT(varchar(100), ERROR_NUMBER());
		PRINT 'Error message: ' +
        CONVERT(varchar(1000), ERROR_MESSAGE());
END CATCH
GO
--stored procedure execution
EXEC sp_DelArtist 21
GO

--Create Insert, Update, and Delete stored procedures for the borrower table. Update procedure accepts a primary key value and the borrower’s names for update. Insert accepts all columns as input parameters except for identity fields. Delete accepts a primary key value for delete.
USE disk_inventoryGT;
GO
--INSERT to borrower stored procedure
DROP PROC IF EXISTS sp_InsBorrower;
GO

CREATE PROC sp_InsBorrower
	@First_Name nvarchar(20),
	@Last_Name nvarchar(20),
	@Borrower_Phone_Number nvarchar(18)
AS
--error handling
BEGIN TRY
	INSERT INTO [dbo].[Borrower]
			   ([First_Name]
			   ,[Last_Name]
			   ,[Borrower_Phone_Number])
		 VALUES
			   (@First_Name
			   ,@Last_Name
			   ,@Borrower_Phone_Number)
END TRY

BEGIN CATCH
		PRINT 'An error occurred. Row was not inserted.';
		PRINT 'Error number: ' +
        CONVERT(varchar(100), ERROR_NUMBER());
		PRINT 'Error message: ' +
        CONVERT(varchar(1000), ERROR_MESSAGE());
END CATCH
GO
--stored procedure execution
EXEC sp_InsBorrower'Cher', 'the musician', '(123)456-6780'
GO

-- UPDATE to borrower stored procedure

DROP PROC IF EXISTS sp_UpdBorrower;
GO

CREATE PROC sp_UpdBorrower
	@Borrower_ID int,
	@First_Name nvarchar(20),
	@Last_Name nvarchar(20),
	@Borrower_Phone_Number nvarchar(18)
AS
--error handling
BEGIN TRY
	UPDATE [dbo].[Borrower]
	   SET [First_Name] = @First_Name
		  ,[Last_Name] = @Last_Name
		  ,[Borrower_Phone_Number] = @Borrower_Phone_Number
	 WHERE Borrower_ID = @Borrower_ID
END TRY

BEGIN CATCH
		PRINT 'An error occurred. Row was not updated.';
		PRINT 'Error number: ' +
        CONVERT(varchar(100), ERROR_NUMBER());
		PRINT 'Error message: ' +
        CONVERT(varchar(1000), ERROR_MESSAGE());
END CATCH
GO
--stored procedure execution
EXEC sp_UpdBorrower 21, 'Bruno', 'Mars', '(765)123-3456'
GO

--DELETE from borrower stored procedure
DROP PROC IF EXISTS sp_DelBorrower;
GO
CREATE PROC sp_DelBorrower
	@Borrower_ID int
AS
--error handling
BEGIN TRY
	DELETE FROM [dbo].[Borrower]
	WHERE Borrower_ID = @Borrower_ID
END TRY
BEGIN CATCH
PRINT 'An error occurred. Row was not deleted.';
		PRINT 'Error number: ' +
        CONVERT(varchar(100), ERROR_NUMBER());
		PRINT 'Error message: ' +
        CONVERT(varchar(1000), ERROR_MESSAGE());
END CATCH
GO
--stored procedure execution
EXEC sp_DelBorrower 21
GO

--Create Insert, Update, and Delete stored procedures for the disk table. Update procedure accepts a primary key value and the disk information for update. Insert accepts all columns as input parameters except for identity fields. Delete accepts a primary key value for delete.
USE disk_inventoryGT;
GO
--INSERT to CD stored procedure
DROP PROC IF EXISTS sp_InsCD;
GO

CREATE PROC sp_InsCD
	@CD_Name nvarchar(100),
	@Release_Date date,
	@Genre nvarchar(25)
AS
--error handling
BEGIN TRY
	INSERT INTO [dbo].[CD]
			   ([CD_Name]
			   ,[Release_Date]
			   ,[Genre])
		 VALUES
			   (@CD_Name
			   ,@Release_Date
			   ,@Genre)
END TRY
BEGIN CATCH
		PRINT 'An error occurred. Row was not inserted.';
		PRINT 'Error number: ' +
        CONVERT(varchar(100), ERROR_NUMBER());
		PRINT 'Error message: ' +
        CONVERT(varchar(1000), ERROR_MESSAGE());
END CATCH
GO
--stored procedure execution
EXEC sp_InsCD 'The Kick Inside', '02/17/1978', 'Pop'
GO

--UPDATE to CD stored procedure
DROP PROC IF EXISTS sp_UpdCD;
GO
CREATE PROC sp_UpdCD
	@CD_ID int,
	@CD_Name nvarchar(100),
	@Release_Date date,
	@Genre nvarchar(25)
AS
--error handling
BEGIN TRY
	UPDATE [dbo].[CD]
	   SET [CD_Name] = @CD_Name
		  ,[Release_Date] = @Release_Date
		  ,[Genre] = @Genre
	 WHERE CD_ID = @CD_ID
END TRY
BEGIN CATCH
		PRINT 'An error occurred. Row was not updated.';
		PRINT 'Error number: ' +
        CONVERT(varchar(100), ERROR_NUMBER());
		PRINT 'Error message: ' +
        CONVERT(varchar(1000), ERROR_MESSAGE());
END CATCH
GO
--stored procedure execution
EXEC sp_UpdCD 21, 'Filth', '01/01/1983', 'Experimental Rock'
GO
--DELETE from CD stored procedure
DROP PROC IF EXISTS sp_DelCD;
GO
CREATE PROC sp_DelCD
	@CD_ID int
AS
--error handling
BEGIN TRY
	DELETE FROM [dbo].[CD]
	WHERE CD_ID = @CD_ID
END TRY
BEGIN CATCH
PRINT 'An error occurred. Row was not deleted.';
		PRINT 'Error number: ' +
        CONVERT(varchar(100), ERROR_NUMBER());
		PRINT 'Error message: ' +
        CONVERT(varchar(1000), ERROR_MESSAGE());
END CATCH
GO
--stored procedure execution
EXEC sp_DelCD 21
GO