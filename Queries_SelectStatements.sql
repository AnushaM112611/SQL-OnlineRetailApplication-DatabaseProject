use MockAppliedProject;

/* 1. A select statement to find the first and second most sold products from each department: */

-- select * from Product;
-- select * from InvoiceLineItem;
-- select * from Department;

select SaleRanks.DepartmentID, SaleRanks.DepartmentName, SaleRanks.ProductID,SaleRanks.ProductName, SaleRanks.SaleNumber,SaleRanks.SaleValue, SaleRanks.Product_SaleRank		
from												
(													
	SELECT AllSales.DepartmentID, AllSales.DepartmentName, AllSales.ProductID, AllSales.ProductName, AllSales.SaleNumber, AllSales.SaleValue, 
	       row_number() over( partition by AllSales.DepartmentID order by SaleValue desc ) as Product_SaleRank												
	from												
	(												
	    select  P.DepartmentID, D.DepartmentName, P.ProductID, P.ProductName, sum(quantity) as SaleNumber, sum(I.quantity*P.unitprice) as SaleValue												
		from Product P											
		left join InvoiceLineItem I											
		on P.ProductID=I.ProductID	
		inner join Department D 
		on P.DepartmentID = D.DepartmentID											
		group by  P.DepartmentID, D.DepartmentName, P.ProductID, P.ProductName
	) AllSales						
) as SaleRanks												
where SaleRanks.Product_SaleRank=2 or SaleRanks.Product_SaleRank= 1	;

/*2. A select statement to measure the performance of the employees by calculating the number of transactions and orders undertaken by the employee.*/

-- select * from Transactions;
-- select * from Employee;
-- select * from Invoice;

select Performance.EmployeeID, E.EmployeeFirstName + ' ' + E.EmployeeLastName as EmployeeName, Performance.Performance
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
on Performance.EmployeeID = E.EmployeeID;

/*3. A select statement to find the frequency of purchase of customers by calculating the average of difference in dates visited by the customer */												

-- select * from  Customer;
-- select * from Invoice;

select b.CustomerID, avg(datediff(day, b.InvoiceDate, b.Next_InvoiceDate)) as Customer_Avg_Visit
from
(select  a.CustomerID,  a.InvoiceDate, coalesce(a.Next_TransactionDate,a.InvoiceDate) as Next_InvoiceDate 
from 
    (select CustomerID, InvoiceDate, lead(InvoiceDate) over (partition by CustomerID order by InvoiceID) as Next_TransactionDate 
	 from Invoice) as a
	) as b
where b.InvoiceDate <> b.Next_InvoiceDate
group by b.CustomerID
order by CustomerID;








