CREATE TABLE IF NOT EXISTS supermarketsales ( 
	InvoiceNo VARCHAR(15), 
	StockCode VARCHAR(15),
	Description VARCHAR(100),
	Quantity INT,
	InvoiceDate TIMESTAMP,
	UnitPrice NUMERIC,
	CustomerID NUMERIC,
	Country VARCHAR(100) 
);
