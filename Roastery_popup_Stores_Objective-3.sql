-- To find the top returning customers based on orders placed
CREATE VIEW RegularCustomers 
AS
    SELECT c.cstId AS 'Customer Id', c.cstFirstName + ' ' + c.cstLastName AS 'Customer Full Name', 
			o.cstId AS 'Order Details Customer Id', o.ordId AS 'Order Id',
			o.ordDate AS 'Order Date', c.cstPhoneNumber AS 'Customer Phone Number'
	FROM Customer c, OrderDetail o WHERE c.cstId = o.cstId



SELECT * FROM RegularCustomers


WITH CTE_TopCustomer AS
(
    SELECT [Customer Full Name], [Customer Phone Number], COUNT([Customer Id]) AS [Ordered Frequency],RANK() OVER (ORDER BY COUNT([Customer Id]) DESC) As [Rank]
    FROM RegularCustomers
    GROUP BY [Customer Full Name], [Customer Phone Number], [Customer Id]
)
SELECT [Customer Full Name] AS 'Top Returning Customers', [Customer Phone Number] AS 'Customer Contact Detail', [Ordered Frequency] AS 'Number of times ordered from Terpresso',[Rank]
FROM CTE_TopCustomer
WHERE [Rank] = 1

DROP VIEW IF EXISTS RegularCustomers
