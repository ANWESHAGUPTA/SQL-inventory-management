-- To find the sales profit of a  specific store and to check whether the operation cost vs revenue cost generates a profit or not
CREATE VIEW TopPerformingStore 
AS
	SELECT pl.prdId AS 'Product ID', p.prdName AS 'Product Name', p.prdCategory AS 'Product Category',
			( p.prdPrice*pl.ordQty) AS 'Total Product Price ', s.strId AS 'Store ID' ,s.strName AS 'Store Name' , 
			s.strLocation AS 'Store Location', s.strOperationCost AS 'Store Operation Cost', s.strRevenue AS'Store Revenue(Other Services)'
    FROM Place pl, Product p, OrderDetail o, Store s
	WHERE pl.ordId = o.ordId 
			AND o.strId = s.strId
			AND pl.prdId = p.prdId


SELECT	[Store Name],[Store Location],
		(([Store Revenue(Other Services)] + b.PrdRevenue) - [Store Operation Cost] )AS 'Total Store Sales Profit'
FROM TopPerformingStore tp 
LEFT JOIN
(
SELECT [Store ID], SUM([Total Product Price ]) AS PrdRevenue 
FROM TopPerformingStore 
GROUP BY [Store ID]
) b
ON tp.[Store ID] = b.[Store ID]
GROUP BY tp.[Store ID], [Store Name],
		[Store Location],
		(([Store Revenue(Other Services)] + b.PrdRevenue) - [Store Operation Cost] )

DROP VIEW IF EXISTS TopPerformingProducts
