-- TO SELECT TOP RANKS(MOST SELLING) AND LEAST RANKED(LEAST SELLING PRODUCTS)
CREATE VIEW BestAndLeastProduct
AS
	SELECT pl.prdId, pr.prdName
	FROM Place pl, Product pr
	WHERE pr.prdId = pl.prdId 

WITH CTE_RankedProducts AS
(
SELECT b.prdId AS [Product ID], b.prdName AS [Product Name], 
	   COUNT(b.prdId) AS [Frequency Ordered Product], 
	   RANK() OVER (ORDER BY COUNT(b.prdId) DESC) AS [Rank]
FROM BestAndLeastProduct b
GROUP BY b.prdId, b.prdName, b.prdId
)
SELECT * FROM CTE_RankedProducts a, 
      (select TOP 1 RANK
	    from CTE_RankedProducts W 
		order by W.Rank desc) v
WHERE a.Rank <= 3 
OR a.Rank = v.Rank
