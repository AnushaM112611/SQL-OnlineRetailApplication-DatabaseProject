if exists (select * from sysdatabases where name='MockAppliedProject')
		drop database MockAppliedProject
create database MockAppliedProject
go

use MockAppliedProject
go

if exists (select * from sysobjects where id = object_id('dbo.Customer'))
	drop table "dbo"."Customer"
GO

if exists (select * from sysobjects where id = object_id('dbo.Employee'))
	drop table "dbo"."Employee"
GO

if exists (select * from sysobjects where id = object_id('dbo.Product'))
	drop table "dbo"."Product"
GO

if exists (select * from sysobjects where id = object_id('dbo.Vendor'))
	drop table "dbo"."Vendor"
GO
if exists (select * from sysobjects where id = object_id('dbo.Shipper'))
	drop table "dbo"."Shipper"
GO
if exists (select * from sysobjects where id = object_id('dbo.Department'))
	drop table "dbo"."Department"
GO

if exists (select * from sysobjects where id = object_id('dbo.Invoice'))
	drop table "dbo"."Invoice"
GO

if exists (select * from sysobjects where id = object_id('dbo.InvoiveLineItem'))
	drop table "dbo"."InvoiceLineItem"
GO

if exists (select * from sysobjects where id = object_id('dbo.Transactions'))
	drop table "dbo"."Transactions"
GO

if exists (select * from sysobjects where id = object_id('dbo.RepairService'))
	drop table "dbo"."RepairService"
GO
if exists (select * from sysobjects where id = object_id('dbo.Contracts'))
	drop table "dbo"."Contracts"
GO

CREATE TABLE dbo.Customer(
	CustomerID INT NOT NULL IDENTITY,
	FirstName nvarchar(40) NOT NULL,
	LastName nvarchar(40) NOT NULL,
	CustomerAddress nvarchar(100) NULL,
	CustomerCity nvarchar(40) NULL,
	CustomerState nvarchar(30) NULL,
	CustomerZip nvarchar(10) NOT NULL,
	CustomerEmailID nvarchar(40) NULL,
	CustomerPhone nvarchar(20) NULL,
	CustomerDOB Date NULL,
	CONSTRAINT PK_Customer_CustomerID PRIMARY KEY(CustomerID),
	CONSTRAINT CK_Customer_CustomerZip CHECK(CustomerZip LIKE '[0-9][0-9][0-9][0-9][0-9]'),
	CONSTRAINT CK_Customer_CustomerEmailID CHECK(CustomerEmailID LIKE '_%@_%._%'),
	CONSTRAINT CK_Customer_CustomerPhone CHECK(CustomerPhone LIKE '[0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'),
	CONSTRAINT CK_Customer_CustomerDOB CHECK(YEAR(CustomerDOB) > 1900)
)
GO

CREATE TABLE dbo.Employee(
	EmployeeID INT NOT NULL IDENTITY,
	IdentityProof nvarchar(20) NOT NULL UNIQUE,
	ManagerID INT NULL,
	EmployeeFirstName nvarchar(40) NOT NULL,
	EmployeeLastName nvarchar(40) NOT NULL,
	EmployeeAddressLine nvarchar(100) NULL,
	EmployeeCity nvarchar(40) NULL,
	EmployeeState nvarchar(30) NULL,
	EmployeeZip nvarchar(10) NOT NULL,
	EmployeePhoneNumber nvarchar(20) NULL,
	EmployeeJobTitle nvarchar(25) not null,
	EmployeeSalary money not null,
	EmployeeHireDate DATE NULL,
	CONSTRAINT PK_Employee_EmployeeID PRIMARY KEY(EmployeeID),
	CONSTRAINT FK_Employee_ManagerID FOREIGN KEY(EmployeeID) References dbo.Employee(EmployeeID),
	CONSTRAINT CK_Employee_EmployeeZip CHECK(EmployeeZip LIKE '[0-9][0-9][0-9][0-9][0-9]'),
	CONSTRAINT CK_Employee_EmployeePhoneNumber 
	CHECK(EmployeePhoneNumber LIKE '+[0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]')
)
GO

CREATE TABLE dbo.Department (
DepartmentID INT NOT NULL IDENTITY,
DepartmentName nvarchar(40),
DepartmentManagerID INT,
DepartmentManagerStartDate DATE DEFAULT getdate(),
DepartmentManagerEndDate DATE,
CONSTRAINT PK_Department_DepartmentID PRIMARY KEY(DepartmentID),
CONSTRAINT FK_Department_Employee_DepartmentManagerID FOREIGN KEY(DepartmentManagerID) REFERENCES dbo.Employee(EmployeeID),
CONSTRAINT CK_Department_DepartmentManagerEndDate CHECK (YEAR(DepartmentManagerEndDate) <= YEAR(DATEADD(YEAR,3,DepartmentManagerStartDate)))
)
GO

create table dbo.Product(
ProductID int identity not null,
ProductName nvarchar(70) not null,
ProductCategory nvarchar(70) not null,
DepartmentID int not null,
UnitPrice money not null default 0,
ManufacturerName nvarchar(40),
UnitsInStock int not null default 0,
constraint PK_Product_ProductID primary key(ProductID),
constraint FK_Product_Department_DepartmentID foreign key(DepartmentID) references dbo.Department,
constraint CK_Product_Price check (UnitPrice >= 0) )
GO


CREATE TABLE dbo.Vendor
(VendorID INT NOT NULL IDENTITY,
 VendorName nVARCHAR(40) NOT NULL,
 VendorContact nVARCHAR(25) NULL,
 VendorAddressLine nVARCHAR(100) NULL,
 VendorAddressLine2 nVARCHAR(100) NULL,
 VendorCity nVARCHAR(40) NULL,
 VendorState nvarchar(30) NULL,
 VendorZip nvarchar(10) NOT NULL,
 VendorCertification nVARCHAR(10),
 CONSTRAINT PK_Vendor_VendorID PRIMARY KEY(VendorID)
 )
 GO

create table dbo.Shipper(
ShipperId int identity not null,
CompanyName nvarchar(30) not null unique,
CompanyAddress nvarchar(100) not null,
CompanyPhone nvarchar(20) not null unique check(CompanyPhone like '[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'),
constraint PK_Shipper_ShipperID primary key(ShipperID))
GO




create table dbo.Invoice(
InvoiceID int  not null identity,
CustomerID int not null,
EmployeeID int not null,
InvoiceDate smalldatetime not null default getdate(),
PaymentType nvarchar(15) not null,
ShipperID int  ,
constraint PK_Invoice_InvoiceID primary key(InvoiceID),
constraint FK_Invoice_Customer_CustomerID foreign key(CustomerID) references dbo.Customer,
constraint FK_Invoice_Employee_EmployeeID foreign key(EmployeeID) references dbo.Employee )
GO

CREATE TABLE dbo.InvoiceLineItem
( InvoiceID INT NOT NULL,
  ProductID INT NOT NULL,
  Quantity INT NOT NULL,
  CONSTRAINT PK_InvoiceLineItem_CompositeKey PRIMARY KEY(InvoiceID,ProductID),
  CONSTRAINT FK_InvoiceLineItem_Product_ProductID FOREIGN KEY(ProductID) REFERENCES dbo.Product(ProductID),
  CONSTRAINT CK_InvoiceLineItem_Quantity CHECK (Quantity > 0)
)
GO

CREATE TABLE dbo.Transactions(
	TransactionID INT NOT NULL IDENTITY,
	CustomerID INT NOT NULL,
	EmployeeID INT NOT NULL,
	TransactionDate smalldatetime NOT NULL,
	TransactionType nvarchar(50) NOT NULL,
	CONSTRAINT PK_Transaction_TransactionID PRIMARY KEY(TransactionID),
	CONSTRAINT FK_Transaction_Customer_CustomerID FOREIGN KEY(CustomerID) References dbo.Customer(CustomerID),
	CONSTRAINT FK_Transaction_Employee_EmployeeID FOREIGN KEY(EmployeeID) References dbo.Employee(EmployeeID)
)
GO

CREATE TABLE dbo.RepairService(
	RepairServiceID INT NOT NULL IDENTITY,
	EmployeeID int not null,
	CustomerID INT NOT NULL,
	ProductName nvarchar(40) NULL,
	RepairArrivalDate datetime NOT NULL DEFAULT(GETDATE()),
	RepairDeliveryDate datetime NOT NULL,
	RepairServiceCharge money,
	CONSTRAINT PK_RepairService_RepairServiceID PRIMARY KEY(RepairServiceID),
	CONSTRAINT FK_RepairService_Employee_EmployeeID FOREIGN KEY(EmployeeId) References dbo.Employee(EmployeeID),
	CONSTRAINT FK_RepairService_Customer_CustomerID FOREIGN KEY(CustomerID) References dbo.Customer(CustomerID),
	CONSTRAINT CK_RepairService_RepairDeliveryDate CHECK(RepairDeliveryDate >= RepairArrivalDate)
)
GO


create table dbo.Contracts(
ContractsID int identity not null,
DepartmentID int not null,
VendorID int not null,
ContractsStartDate datetime not null default getdate(),
ContractsEndDate datetime not null,
Quantity int default 0,
constraint PK_Contracts_ContractsID primary key(ContractsID),
constraint FK_Contracts_Department_DepartmentID foreign key(DepartmentID) references dbo.Department,
constraint FK_Contracts_Vendor_VendorID foreign key(VendorID) references dbo.Vendor,
Constraint CK_Contracts_ContractsEndDate CHECK(YEAR(ContractsEndDate) <= YEAR(dateadd(year,3,ContractsStartDate)))
)
GO

-- Insert data into Customer Table
INSERT INTO dbo.Customer
VALUES
('Hari' ,'Kumar','2732 Baker Blvd.','Eugene','OR','97403','HariKumar@gmail.com','01-503-555-7555','1978-03-12'),
('Jytte' ,'Petersen','City Center Plaza 516 Main St.','Elgin','OR','97827','Jytte223@hotmail.com','01-503-555-6874','1983-02-14'),
('Art' ,'Braunschweiger','P.O. Box 555','Lander','WY','82520','ArtB@gmail.com','01-307-555-4680','1972-03-09'),
('Liz' ,'Nixon','89 Jefferson Way Suite 2','Portland','OR','97201','Nixon@yahoo.com','01-503-555-3612','1980-06-28'),
('Liu' ,'Wong','55 Grizzly Peak Rd.','Butte','MT','59801','LiuWong@gmail.com','01-406-555-5834','1967-08-25'),
('Karin' ,'Josephs','12 Orchestra Terrace','Walla Walla','WA','99362','Karin@gmail.com','01-509-555-7969','1957-07-25'),
('Miguel','Paolino','87 Polk St. Suite 5','San Francisco','CA','94117','MAngel123@gmail.com','01-415-555-5938','1988-03-02'),
('Helvetius','Nagy','722 DaVinci Blvd.','Kirkland','WA','98034','Nagy@gmail.com','01-206-555-8257','1986-11-01'),
('Palle' ,'Ibsen','89 Chiaroscuro Rd.','Portland','OR','97219','Palle@hotmail.com','01-503-555-9573','1965-12-28'),
('Paul' ,'Henriot','2743 Bering St.','Anchorage','AK','99508','Paul@hotmail.com','01-907-555-7584','1965-04-23'),
('Rita' ,'Müller','187 Suffolk Ln.','Boise','ID','83720','Rita@gmail.com','01-208-555-8097','1978-08-04'),
('Pirkko' ,'Koskitalo','55 Grizzly Peak Rd.','Butte','MT','59801','Pirkko19@gmail.com','01-406-983-6100','1956-04-09'),
('Karl' ,'Jablonski','305 - 14th Ave. S. Suite 3B','Seattle','WA','98128','Karl@hotmail.com','01-206-555-4112','1988-03-09'),
('Matti' ,'Karttunen','17030 N 49th st','Phoenix','AZ','85254','Matti@hotmail.com','01-623-787-9922','1984-03-02'),
('Zbyszek' ,'Piestrzeniewicz','1654 Columbia St','San Diego','CA','92101','Zby007@gmail.com','01-619-427-0121','1979-11-24')

-- Insert data into Employee Table
INSERT INTO dbo.Employee VALUES
('909-89-7765',13,'Lily','Aldrin','127 Monroe Street Apt # 67','Phoenix','AZ','85009','+1-480-563-7401','Sales Representative',2300,'2012-12-21'),
('879-65-1543',4,'Raymond','Barone','89 Polk Street P.O. Box 508','Phoenix','AZ','85003','+1-480-587-2335','Stockers',1100,'2014-09-29'),
('901-12-3456',4,'Sarah','Chalke','289 W Boston Street Apt # 1090','Chandler','AZ','85225','+1-480-151-6230','Sales Representative',2300,'2012-01-31'),
('234-12-2345',13,'Robert','Coleman','490 E Main Street','Norwich','CT','06360','+1-786-713-8616','Store Manager',2500,'2010-05-27'),
('567-23-3456',4,'John Micheal','Dorian','70 Cliff Avenue','New London','CT','06320','+1-492-709-6392','Sales Representative',2300,'2011-03-27'),
('674-23-2012',13,'Marshall','Eriksen','711-2880 Nulla Street Apt # 56','Mankato','MS','96522','+1-654-393-5734','Stockers',1100,'2014-03-27'),
('270-31-9898',13,'Neil Patrick','Harris','3919 Gravida St. P.O. Box 508','Maricopa','AZ','85138','+1-480-579-1879','Stockers',1100,'2013-12-31'),
('721-09-2213',13,'Deborah','Heaton','7292 Dictum Ave','San Antonio','MI','47096','+1-959-119-8364','Sales Representative',2300,'2011-12-31'),
('783-12-0987',13,'Sophie','Kinsella','2508 Dolor. Av. P.O. Box 887','Muskegon','KY','12482','+1-468-353-2641','Sales Representative',2300,'2012-06-17'),
('450-67-8790',13,'Ted','Mosby','511-5762 At Rd.','Chelsea','MI','67708','+1-939-353-1107','Cashier',1300,'2013-04-05'),
('978-23-1064',13,'Robert','Reid','935-9940 Tortor. Street','Santa Rosa','MN','98804','+1-453-391-4650','Cashier',1300,'2014-08-27'),
('451-03-2458',4,'Elliot','Reid','456 W Pecos Rd.','Chandler','AZ','85225','+1-480-491-9858','Repair Technician',2000,'2012-07-02'),
('054-90-4398',4,'Michael','Reid','313 Pellentesque Ave','Honolulu','HI','96801','+1-387-142-9434','Store Manager',2500,'2010-11-13'),
('378-01-2597',4,'Robin','Scherbatsky','189 48th Street Apt # 8909','Phoenix','AZ','85003','+1-480-843-3419','Repair Technician',2000,'2013-08-19'),
('009-19-8734',4,'Barney','Stinson','3476 Aliquet. Ave','Minot','AZ','95302','+1-480-677-1827','Repair Technician',2000,'2013-11-28');
GO

-- Insert data into Department Table
Insert into Department values ('APPLIANCES','4','2014-05-01','2016-05-01'),
('BATH & FAUCETS','4','2014-05-01','2016-05-01'),
('BLINDS & DECOR','4','2014-05-01','2016-05-01'),
('BUILDING MATERIALS','4','2014-05-01','2016-05-01'),
('DOORS & WINDOWS','13','2013-12-01','2016-12-01'),
('ELECTRICAL','13','2013-12-01','2016-12-01'),
('KITCHEN','13','2013-12-01','2016-12-01'),
('LAWN & GARDEN','13','2013-12-01','2016-12-01'),
('OUTDOOR LIVING','13','2013-12-01','2016-12-01'),
('STORAGE & ORGANIZATION','4','2014-05-01','2016-05-01')
Go

-- Insert data into Product Table
INSERT INTO dbo.Product
VALUES
('French Door Refrigerator','REFRIGERATORS',1,1978.2,'Samsung',20),
('Side By Side Refrigerator','REFRIGERATORS',1,1979,'Samsung',15),
('Top Freezer Refrigerator','REFRIGERATORS',1,1245.5,'Whirlpool',20),
('Bottom Freezer Refrigerator','REFRIGERATORS',1,1480.5,'GE',20),
('Bathroom Faucet','BATH FAUCETS & SHOWER HEADS',2,90,'Kohler',15),
('Shower Faucet','BATH FAUCETS & SHOWER HEADS',2,120,'Kraus',15),
('Shower Head','BATH FAUCETS & SHOWER HEADS',2,150,'Kraus',14),
('Bath Lighting','BATH & FAUCETS DECORS',2,300,'Kraus',13),
('Blinds & Shades','BLINDS & WINDOW TREATMENTS',3,60,'QuickShip',15),
('Faux Wood Blinds','BLINDS & WINDOW TREATMENTS',3,75,'QuickShip',11),
('Cellular Shades','BLINDS & WINDOW TREATMENTS',3,50,'DEZ Furnishing',11),
('Window Film','BLINDS & WINDOW TREATMENTS',3,95,'DEZ Furnishing',18),
('Wood Fencing','FENCING',4,10,'Prime Line',10),
('Vinyl Fencing','FENCING',4,20,'Prime Line',10),
('Fiberglass Insulation','INSULATION',4,25,'Prime Line',10),
('Rigid Insulation','INSULATION',4,20,'Tiger brand',5),
('Patio Doors','ENTRY DOORS',5,450,'Crown Bolt',9),
('Screen Doors','ENTRY DOORS',5,500,'Tiger brand',10),
('Garage Doors','GARAGE DOORS & ACCESSORIES',5,350,'Tiger brand',10),
('Garage Doors Openers','GARAGE DOORS & ACCESSORIES',5,100,'Pittsburgh Corning',10),
('TVs','HOME ELECTRONICS',6,1250,'Samsung',11),
('Home Audio','HOME ELECTRONICS',6,750,'Samsung',12),
('LED Light Bulbs','LIGHT BULBS',6,80,'Philips',12),
('CFL Light Bulbs','LIGHT BULBS',6,85,'Philips',12),
('Stainless Steel Sinks','KITCHEN SINKS',7,125,'Kitchen Aid',13),
('Apron Front Sinks','KITCHEN SINKS',7,150,'Kitchen Aid',13),
('Cabinet Hardware','CABINETS & CABINET HARDWARE',7,150,'Tiger brand',14),
('Water Filters','KITCHEN ACCESSORIES',7,90,'Cuisinite',14),
('Grass Seed','LAWN CARE',8,100,'MS International',20),
('Lawn Fertilizers','LAWN CARE',8,90,'MS International',20),
('Pavers & Step Stones','LANDSCAPING',8,95,'Pave Stone',20),
('Retaining Wall Blocks','LANDSCAPING',8,45,'Classic Stone',20),
('Seating Sets','PATIO FURNITURE',9,400,'MS International',15),
('Chairs & Stools','PATIO FURNITURE',9,200,'MS International',4),
('Chaise Lounges','PATIO FURNITURE',9,350,'MS International',4),
('Sofas & Loveseats','PATIO FURNITURE',9,200,'MS International',5),
('Garment Racks','CLOSET STORAGE',10,250,'ClosetMaid',8),
('Shoe Storage','CLOSET STORAGE',10,225,'ClosetMaid',8),
('Wood Closet Organizers','CLOSET STORAGE',10,100,'ClosetMaid',9),
('Decorative Shelving','SHELVES & SHELF BRACKETS',10,600,'Honey-Can-Do',9)
GO

-- Insert data into Vendor Table
INSERT INTO dbo.Vendor
VALUES
('Federal Express Corporation','(800) 555-4091','Employment Development Dept','PO Box 826276','Sacramento','CA','94230','C110223903'),
('United Parcel Service','(800) 555-0855','P.O. Box 505820',NULL,'Reno','NV','88905','C110445222'),
('Unocal','(415) 555-7600','P.O. Box 860070',NULL,'Pasadena','CA','91186','C156224753'),
('Coffee Break Service','(559) 555-8700','PO Box 1091',NULL,'Fresno','CA','93714','C123567468'),
('Towne Advertiser Mailing Svcs','(800) 555-5123','Kevin Minder','3441 W Macarthur Blvd','Santa Ana','CA','92704','C117589004')

-- Insert data into Shipper Table
Insert into Shipper values('UPS',' 1628 E Southern Ave, Tempe AZ','602-897-1875') ,
('USPS','522 N Central Ave, Phoenix AZ','602-253-9648') ,
('FedEx','1437 E Main St, Mesa AZ','480-833-0036') ,
('Speedy Express','STE 100, Phoenix AZ','602-325-8460') 
GO



-- Insert data into Invoice Table
Insert into Invoice values(1,11,'2015-03-01','Cash',1),
(2,10,'2015-03-01','Cash',1),
(3,10,'2015-03-01','Credit Card',4),
(4,11,'2015-03-02','Credit Card',4),
(5,11,'2015-03-02','Debit Card',null),
(6,11,'2015-03-10','Cash',3),
(7,11,'2015-03-15','Cheque',3),
(8,11,'2015-03-18','Cheque',null),
(9,10,'2015-03-20','Cash',2),
(10,11,'2015-04-07','Cash',2),
(1,11,'2015-04-09','Credit Card',2),
(3,10,'2015-04-10','Debit Card',1),
(3,11,'2015-04-10','Debit Card',1),
(11,11,'2015-04-10','Credit Card',null),
(12,11,'2015-04-15','Credit Card',null),
(13,10,'2015-04-15','Cash',null),
(14,10,'2015-04-18','Cash',1),
(15,10,'2015-04-18','Cash',2),
(11,10,'2015-04-20','Credit Card',null),
(14,10,'2015-04-20','Cash',4)
GO


-- Insert data into InvoiceLineItem Table
INSERT INTO dbo.InvoiceLineItem
VALUES
(1,1,2),
(1,5,2),
(1,3,1),
(2,8,1),
(2,9,1),
(2,10,1),
(3,20,2),
(3,13,1),
(3,21,3),
(4,11,2),
(4,15,1),
(4,18,10),
(5,16,3),
(5,17,1),
(5,1,1),
(6,33,1),
(7,13,1),
(7,40,1),
(8,29,1),
(8,27,2),
(8,18,1),
(9,39,1),
(9,38,1),
(10,16,2),
(11,19,2),
(11,18,2),
(12,11,1),
(12,10,1),
(12,12,2),
(13,14,2),
(14,4,1),
(14,7,2),
(15,8,2),
(15,9,3),
(15,14,1),
(16,17,2),
(16,26,2),
(17,37,1),
(18,27,2),
(19,18,2),
(19,17,2),
(20,35,3),
(20,22,1),
(20,12,2)
GO

-- Insert data into Transactions Table
INSERT INTO dbo.Transactions VALUES
(2,5,'2015-04-01','PurchaseInfo'),
(4,5,'2015-04-01','RepairServiceInfo'),
(4,2,'2015-04-01','ProductInfo'),
(9,2,'2015-04-01','ProductInfo'),
(10,1,'2015-04-02','ShipmentInfo'),
(10,4,'2015-04-03','ProductInfo'),
(6,3,'2015-04-04','ReturnPolicy'),
(1,3,'2015-04-05','PurchaseInfo'),
(8,3,'2015-04-06','RepairServiceInfo'),
(13,1,'2015-04-06','ReplacementPolicy'),
(13,1,'2015-04-06','ShipmentInfo'),
(11,9,'2015-04-07','ReturnPolicy'),
(3,7,'2015-04-08','PurchaseInfo'),
(5,10,'2015-04-09','RepairServiceInfo'),
(7,6,'2015-04-10','PurchaseInfo'),
(12,15,'2015-04-10','ReturnPolicy'),
(1,12,'2015-04-11','ReturnPolicy'),
(2,7,'2015-04-12','ReplacementPolicy'),
(3,7,'2015-04-12','ReplacementPolicy'),
(3,6,'2015-04-13','ReturnPolicy');
GO


-- Insert data into RepairService
INSERT INTO dbo.RepairService VALUES
(12,2,'Dehumidifier','2015-04-10','2015-04-21',30),
(12,3,'Toasters','2015-04-01','2015-04-12',8),
(14,4,'Microwave','2015-04-07','2015-04-22',10),
(14,10,'Cooktop','2015-04-14','2015-04-29',40),
(14,15,'Wall Oven','2015-04-19','2015-05-03',5),
(15,1,'Shoe Storage','2015-04-15','2015-05-01',5),
(15,2,'Shoe Storage','2015-04-10','2015-04-21',5),
(12,5,'Microwave','2015-04-08','2015-04-23',10),
(14,6,'Cabinet Hardware','2015-04-07','2015-04-22',null),
(14,3,'Refrigerator','2015-04-30','2015-05-15',null),
(12,3,'AC','2015-04-30','2015-05-15',null),
(14,3,'ENTRY DOOR','2015-04-30','2015-05-15',40),
(12,3,'TV','2015-04-30','2015-05-15',null),
(15,11,'TV','2015-04-07','2015-04-22',null),
(14,7,'Wall Oven',DEFAULT,'2015-07-22',5);
GO


-- Insert data into Contract Table
INSERT INTO dbo.Contracts
VALUES
(2,1,'2014-09-12','2016-04-13',150),
(5,2,'2013-01-01','2015-01-01',200),
(6,3,'2014-11-24','2016-01-13',100),
(1,4,'2013-03-12','2015-04-20',225),
(8,5,'2013-12-21','2016-06-01',250)
GO