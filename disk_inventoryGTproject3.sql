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
Added data into Inventory, 
*/

--If database already exists, this will delete and begin the rebuild process
use master;
if DB_ID('disk_inventoryGT') is not null
DROP DATABASE disk_inventoryGT
DROP LOGIN diskUserGT

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
	Artist_lname varchar(25) NOT NULL
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
INSERT INTO Artist (Artist_fname, Artist_lname)
VALUES ('Jhonn', 'Balance'),
		('Peter', 'Christopherson'),
		('Chris', 'Carter'),
		('Fanni', 'Cosey'),
		('Genesis', 'P-Orridge'),
		('Monte', 'Cazazza'),
		('William', 'Bennett'),
		('Masami', 'Akita'),
		('Lou', 'Reed'),
		('John', 'Cale'),
		('Sterling', 'Morrison'),
		('Moe', 'Tucker'),
		('Wolfgang', 'Voigt'),
		('Susumu', 'Hirasawa'),
		('Dominick', 'Fernow'),
		('Aaron', 'Funk'),
		('Richard', 'James'),
		('Thomas', 'Bangalter'),
		('Guy', 'Hommem De Christo'),
		('Brian', 'Eno');

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
