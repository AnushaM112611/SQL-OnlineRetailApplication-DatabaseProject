/* DML: This query is used to update the quantity of contracts using VendorCertification*/

 SELECT * FROM Vendor
 SELECT * FROM Contracts

UPDATE Contracts
SET Quantity = Quantity - 20
WHERE VendorID IN
	(SELECT VendorID
	FROM Vendor
	WHERE VendorCertification = 'C110223903');

SELECT * FROM Contracts;
 SELECT * FROM Vendor;



/* This DDL statement uses ALTER 
   This ALTER Adds 2 new Columns Bonus and EmployeeNewSalary which is a computed one that uses values of Bonus and EmployeeSalary. */

USE MockAppliedProject
ALTER TABLE Employee  
ADD     Bonus FLOAT,
		EmployeeNewSalary AS (EmployeeSalary + ((Bonus/100) * EmployeeSalary))	 


select * from Employee


/* Inorder to update the values of Bonus and EmployeeNewSalary, 
   UPDATE statement uses a CTE to populate the values in those columns based on the value of Performance*/

WITH Evaluation AS
(select Performance.EmployeeID, E.EmployeeFirstName + ' ' + E.EmployeeLastName as EmployeeName, Performance.Performance
from
(select a.EmployeeID, sum(a.Number_Transactions) as Performance from
(select EmployeeID,count(TransactionID) as Number_Transactions
from Transactions 
group by EmployeeID
Union
select EmployeeID, count(InvoiceID)as Number_Transactions
from Invoice
group by EmployeeID) as a
group by a.EmployeeID) as Performance 
inner join Employee E
on Performance.EmployeeID = E.EmployeeID
)
UPDATE Employee
SET Bonus = 10
FROM Employee 
INNER JOIN Evaluation
ON Employee.EmployeeID = Evaluation.EmployeeID and
   Evaluation.Performance > 5

SELECT * FROM Employee
