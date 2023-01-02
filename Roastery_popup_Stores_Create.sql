CREATE TABLE Customer(
    cstKey INT IDENTITY(10,1),
	cstId AS 'CST' + RIGHT('00' + CAST(cstKey AS VARCHAR(10)),7)PERSISTED NOT NULL, 
	cstFirstName VARCHAR(20), 
	cstLastName VARCHAR(20), 
	cstPhoneNumber CHAR(10),
	CONSTRAINT pk_Customer_cstId  PRIMARY KEY (cstId))

CREATE TABLE Store(
    strKey INT IDENTITY(10,1),
    strId AS 'STR' + RIGHT('00' + CAST(strKey AS VARCHAR(10)),7)PERSISTED NOT NULL, 
    strName VARCHAR(50), 
    strLocation VARCHAR(50), 
    strRevenue DECIMAL(7,2), 
    strOperationCost DECIMAL(7,2),
    CONSTRAINT pk_Store_strId  PRIMARY KEY (strId))

CREATE TABLE OrderDetail(
    ordKey INT IDENTITY(10,1),
    ordId AS 'ORD' + RIGHT('00' + CAST(ordKey AS VARCHAR(10)),7)PERSISTED NOT NULL, 
    cstId VARCHAR(10) NOT NULL, 
    strId VARCHAR(10) NOT NULL, 
    ordDate DATE, 
    ordUnitPrice DECIMAL(5,2), 
    CONSTRAINT pk_OrderDetail_ordId  PRIMARY KEY (ordId),
    CONSTRAINT fk_OrderDetail_cstId FOREIGN KEY (cstId)
		REFERENCES Customer(cstId)
		ON DELETE NO ACTION ON UPDATE CASCADE,
    CONSTRAINT fk_OrderDetail_strId  FOREIGN KEY (strId)
		REFERENCES Store (strId)
		ON DELETE CASCADE ON UPDATE CASCADE)

CREATE TABLE Product (
    prdKey INT IDENTITY(10,1),
    prdId AS 'PRD' + RIGHT('00' + CAST(prdKey AS VARCHAR(10)),7)PERSISTED NOT NULL, 
    prdName VARCHAR(50), 
    prdPrice DECIMAL(5,2),  
    prdCategory VARCHAR(20),
    CONSTRAINT pk_Product_prdId  PRIMARY KEY (prdId))

CREATE TABLE Supplier(
    splKey INT IDENTITY(10,1),
    splId AS 'SPL' + RIGHT('00' + CAST(splKey AS VARCHAR(10)),7)PERSISTED NOT NULL, 
    splName VARCHAR(50), 
    CONSTRAINT pk_Supplier_splId  PRIMARY KEY (splId))

CREATE TABLE Place (
    ordId VARCHAR (10) NOT NULL,
	prdId VARCHAR (10) NOT NULL,
	ordQty INT,
	CONSTRAINT pk_Place_ordId_prdId 
		PRIMARY KEY (ordId ,prdId),
	CONSTRAINT fk_Place_ordId FOREIGN KEY (ordId) 
		REFERENCES OrderDetail(ordId)
		ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_Place_prdId FOREIGN KEY (prdId )
		REFERENCES Product(prdId )
		ON DELETE CASCADE ON UPDATE CASCADE )

CREATE TABLE ProductIngredient(
    prdIngKey INT IDENTITY(10,1),
	prdIngId AS 'PIN' + RIGHT('00' + CAST(prdIngKey AS VARCHAR(10)),7)PERSISTED NOT NULL, 
	prdIngName VARCHAR(50), 
	CONSTRAINT pk_ProductIngredient_prdIngId  PRIMARY KEY (prdIngId))

CREATE TABLE Prepare (
    prdIngId VARCHAR(10) NOT NULL,
    prdId VARCHAR(10) NOT NULL,
	qtyIngPerPrd DECIMAL(5,2),
	CONSTRAINT pk_Prepare_prdIngId_prdId 
		PRIMARY KEY (prdIngId ,prdId),
	CONSTRAINT fk_Prepare_prdIngId  FOREIGN KEY (prdIngId ) 
		REFERENCES ProductIngredient(prdIngId)
		ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_Prepare_prdId FOREIGN KEY (prdId )
		REFERENCES Product(prdId )
		ON DELETE CASCADE ON UPDATE CASCADE )

CREATE TABLE Supply (
    splId VARCHAR (10) NOT NULL, 
    prdIngId VARCHAR (10) NOT NULL, 
    strId VARCHAR (10) NOT NULL,
	splUnitPrice DECIMAL(6,2), 
    splQuantity INT, 
    splOrderDate DATE,
    CONSTRAINT pk_Supply__splId_prdId_strId 
		PRIMARY KEY (splId , prdIngId, strId),
    CONSTRAINT fk_Supply_splId FOREIGN KEY (splId) 
		REFERENCES Supplier(splId )
		ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_Supply_prdIngId FOREIGN KEY (prdIngId)
		REFERENCES ProductIngredient(prdIngId )
		ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_Supply_strId FOREIGN KEY (strId)
		REFERENCES Store(strId)
		ON DELETE CASCADE ON UPDATE CASCADE)