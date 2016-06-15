USE MockAppliedProject;
GO

--Create Login
CREATE LOGIN AnushaM 
	WITH PASSWORD = 'Anusham@2015' MUST_CHANGE,
	DEFAULT_DATABASE = MockAppliedProject, 
	DEFAULT_LANGUAGE = English,
	CHECK_EXPIRATION = ON,
	CHECK_POLICY = ON;

CREATE LOGIN ChandineeDas
	WITH PASSWORD = 'ChandineeDas@2015' MUST_CHANGE,
	DEFAULT_DATABASE = MockAppliedProject, 
	DEFAULT_LANGUAGE = English,
	CHECK_EXPIRATION = ON,
	CHECK_POLICY = ON;

CREATE LOGIN RamaRavichandran
	WITH PASSWORD = 'Rravich4$%' MUST_CHANGE,
	DEFAULT_DATABASE = MockAppliedProject,
	DEFAULT_LANGUAGE = English,
	CHECK_EXPIRATION = ON,
	CHECK_POLICY = ON;

CREATE LOGIN UshaJagannathan
	WITH PASSWORD = 'UshaJagannathan@2015' MUST_CHANGE,
	DEFAULT_DATABASE = MockAppliedProject,
	DEFAULT_LANGUAGE = English,
	CHECK_EXPIRATION = ON,
	CHECK_POLICY = ON;

--Create User
CREATE USER AnushaM
	FOR LOGIN AnushaM
	WITH DEFAULT_SCHEMA = dbo;

CREATE USER ChandineeDas
	FOR LOGIN ChandineeDas
	WITH DEFAULT_SCHEMA = dbo;

CREATE USER RamaRavichandran
	FOR LOGIN RamaRavichandran
	WITH DEFAULT_SCHEMA = dbo;

CREATE USER UshaJagannathan
	FOR LOGIN UshaJagannathan
	WITH DEFAULT_SCHEMA = dbo;

--We have used the same schema: dbo

--Roles: Collection of permissions
--Create Fixed Server Role - Built-in, users who manage system
ALTER SERVER ROLE sysadmin --system administrator
	ADD MEMBER RamaRavichandran;

ALTER SERVER ROLE securityadmin --security administrator: 
	ADD MEMBER RamaRavichandran;--manage loginIDs, pwds, can grant, deny, revoke permission

ALTER SERVER ROLE dbcreator
	ADD MEMBER AnushaM;

--Create Fixed Database Role
ALTER ROLE db_owner 
	ADD MEMBER AnushaM;
	
--Create User-defined Server Role
CREATE SERVER ROLE DBConsultant;

--Create User-defined Database Role
CREATE ROLE BusinessAnalyst;

--Grant permissions to Roles
--1)User-defined Server Role
ALTER SERVER ROLE DBConsultant ADD MEMBER UshaJagannathan;
ALTER SERVER ROLE DBConsultant ADD MEMBER ChandineeDas;

--Permissions at the server scope can only be granted when the current database is master
GRANT ALTER ANY LOGIN
TO DBConsultant;
-----------------------------
GRANT SELECT
TO BusinessAnalyst;

--2)User-defined Database role
ALTER ROLE BusinessAnalyst ADD MEMBER ChandineeDas;

GRANT SELECT, INSERT, UPDATE, DELETE
ON Contracts
TO BusinessAnalyst;

GRANT SELECT
ON Shipper
TO BusinessAnalyst;

GRANT SELECT, INSERT, UPDATE, DELETE
ON Transactions
TO BusinessAnalyst;

GRANT SELECT
ON Vendor
TO BusinessAnalyst;


