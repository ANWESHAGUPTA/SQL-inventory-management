-- To find the top returning customers based on orders placed
CREATE VIEW RegularCustomers 
AS
    SELECT c.cstId AS 'Customer Id', c.cstFirstName + ' ' + c.cstLastName AS 'Customer Full Name', 
			o.cstId AS 'Order Details Customer Id', o.ordId AS 'Order Id',
			o.ordDate AS 'Order Date', c.cstPhoneNumber AS 'Customer Phone Number'
	FROM Customer c, OrderDetail o WHERE c.cstId = o.cstId
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
-- To find the count and names of Best and Least selling products
CREATE VIEW BestAndLeastProduct
AS
	SELECT pl.prdId, pr.prdName
	FROM Place pl, Product pr
	WHERE pr.prdId = pl.prdId 