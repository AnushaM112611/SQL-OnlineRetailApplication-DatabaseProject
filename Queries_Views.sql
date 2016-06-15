use MockAppliedProject;

if exists (select * from sysobjects where id = object_id('dbo.Store_Products_Value'))
	drop view "dbo"."Store_Products_Value"

GO
if exists (select * from sysobjects where id = object_id('dbo.RepairServices_Status') )
	drop view "dbo"."RepairServices_Status"

GO
if exists (select * from sysobjects where id = object_id('dbo.Sales_By_Month'))
	drop view "dbo"."Sales_By_Month"

GO

/* 1. A View to find the cost of all products in the Home Depot store which are grouped by Department and Product Category*/

-- select * from Product;
-- select * from Department;

create view Store_Products_Value as
SELECT 
 CASE when GROUPING(DepartmentName) = 1 then 'Store_ Products_Value'
 else DepartmentName
 end DepartmentName,
 case when grouping(ProductCategory) = 1 and grouping(DepartmentName)=0 then lower(DepartmentName)+'_Value'
 when grouping(DepartmentName) = 1 and grouping(ProductCategory) = 1 then 'Store_ Products_Value'
 else P.Productcategory
 end Productcategory,
 sum(UnitPrice * UnitsInStock) as Products_Cost
from Department D
inner join Product P
on D.DepartmentID = P.DepartmentID
group by rollup(DepartmentName, ProductCategory);

select * from Store_Products_Value;


/*2. A view to inform customers about the status of the Repair Service */

-- select * from Customer
-- select * from RepairService

create view RepairServices_Status as
select C.FirstName, C.LastName, C.CustomerPhone, ProductName, 
case
when RepairDeliveryDate > GetDate() then 'Requires '+cast(datediff(day, GetDate(),RepairDeliveryDate) as varchar)+' more days to service' 
when RepairDeliveryDate < GetDate() then 'Service Completed & Ready to Collect '
when RepairDeliveryDate = GetDate() then 'Ready to Collect'
end ServiceStatus, RepairServiceCharge
from Customer C 
inner join RepairService R 
on C.CustomerID = R.CustomerID

select * from RepairServices_Status
where ServiceStatus = 'Ready to Collect';



/* 3. A view Statement to calculate the sales per month from Invoices */

-- select * from Invoice;
-- select * from InvoiceLineItem;
-- select * from Product;

CREATE view  Sales_By_Month as
SELECT 
case when grouping(DATENAME(month,InvoiceDate)) = 1 then  'Total' else DATENAME(month,InvoiceDate) end Month_Of_Sales,
COUNT(LineItem.InvoiceID) AS 'Number of Sales',SUM(Quantity*UnitPrice) AS 'Sale Amount'
FROM Invoice As Inv
INNER JOIN InvoiceLineItem as LineItem
ON Inv.InvoiceID = LineItem.InvoiceID
INNER JOIN Product AS Prod
ON LineItem.ProductID = Prod.ProductID
GROUP BY ROLLUP(DATENAME(month,InvoiceDate))

select * from Sales_By_Month;





