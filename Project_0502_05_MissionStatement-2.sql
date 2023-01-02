-- Mapping the Product ingredient prices as per the supplier unit prices
CREATE VIEW IngredientPrice
AS
	SELECT DISTINCT pr.prdIngId, pr.prdId, pr.qtyIngPerPrd, spl.splUnitPrice,
					(pr.qtyIngPerPrd*spl.splUnitPrice) AS ProductIngredientPrices
	FROM Supply spl , Prepare pr
    WHERE pr.prdIngId = spl.prdIngId
-- Calculating the quantity sold per product
CREATE VIEW QuantitySold
AS 
  SELECT pl.prdId, Sum(pl.ordQty) AS TotalQtyOrdered
  FROM place pl, OrderDetail pre
  WHERE pre.ordId = pl.ordId
  GROUP  BY pl.prdId
-- Calculationg the cost of one drink based on the quantity of ingredients used in it
CREATE VIEW CostOfOneDrink 
AS 
  SELECT inpr.prdId, sum(inpr.ProductIngredientPrices) AS CostPerProduct
  FROM IngredientPrice inpr
  GROUP BY inpr.prdId
-- calculating the total cost price per product based on the ordered quantity
CREATE VIEW Costing
AS  
   SELECT cstdr.prdId, cstdr.CostPerProduct, qs.TotalQtyOrdered,
		(cstdr.CostPerProduct*qs.TotalQtyOrdered) AS CostPrice
   FROM CostOfOneDrink  cstdr , QuantitySold qs
   WHERE cstdr.prdId =  qs.prdId
--Calculating the selling price per product based on the ordered quantity
CREATE VIEW SellingPriceOfOneDrink 
AS 
  SELECT qs.prdId, sp.prdPrice, qs.TotalQtyOrdered, 
		(sp.prdPrice*qs.TotalQtyOrdered) AS SellingPrice
  FROM Product sp, QuantitySold qs
  WHERE sp.prdId = qs.prdId
  GROUP BY qs.prdId, sp.prdPrice,qs.TotalQtyOrdered
--Calculating the profit per product based on the ordered quantity
CREATE VIEW ProfitGenerated
AS 
  SELECT cs.prdId, cs.CostPrice , r.SellingPrice, (r.SellingPrice - cs.CostPrice) AS Profit
  FROM SellingPriceOfOneDrink r , Costing cs
  WHERE cs.prdID = r.prdId
--Displaying the top 3 profitable and loss making products
 SELECT * FROM (
	 SELECT TOP 3  p.prdName AS 'Product Name',  pt.prdId AS 'Product ID', 
			CAST(pt.CostPrice AS DECIMAL(5, 2)) AS 'Cost Price Of Product',
			pt.SellingPrice  AS 'Product SellingPrice',CAST(pt.Profit AS DECIMAL(5, 2)) AS 'Profit Per Product'
	FROM ProfitGenerated pt, Product p 
	WHERE pt.prdId = p.prdId
	ORDER BY Profit DESC
				) TopProfitableProducts
UNION
SELECT * FROM(
	SELECT TOP 3  p.prdName AS 'Product Name',  pt.prdId AS 'Product ID', 
			CAST(pt.CostPrice AS DECIMAL(5, 2)) AS 'Cost Price Of Product',
			pt.SellingPrice  AS 'Product SellingPrice',CAST(pt.Profit AS DECIMAL(5, 2)) AS 'Profit Per Product'
	FROM ProfitGenerated pt, Product p 
	WHERE pt.prdId = p.prdId
	ORDER BY Profit ASC
			) LeastProfitableProducts
ORDER BY [Profit Per Product] DESC
