-- Creating views for easier access.
-- Creating a view warehouse_inventory for the warehouses and product details by joining the tables warehouse and products. 
   
CREATE VIEW warehouse_inventory AS
	SELECT
		w.warehouseName,
		p.productCode,
		p.productLine,
		p.quantityInStock,
		p.buyPrice,
		p.MSRP
	FROM warehouses w
	INNER JOIN products p
		ON w.warehouseCode = p.warehouseCode;
        
-- Creating a view order_details_full for the warehouses and product details by joining the tables orders and order details.
    
CREATE VIEW order_details_full AS
    SELECT 
        w.warehouseName AS warehouseName,
        p.productCode AS productCode,
        p.productLine AS productLine,
        p.quantityInStock AS quantityInStock,
        p.buyPrice AS buyPrice,
        p.MSRP AS MSRP,
        od.orderNumber AS orderNumber,
        od.quantityOrdered AS quantityOrdered,
        od.priceEach AS priceEach,
        o.orderDate AS orderDate,
        o.shippedDate AS shippedDate,
        o.status AS status,
        o.customerNumber AS customerNumber
    FROM warehouses w
	JOIN products p 
		ON w.warehouseCode = p.warehouseCode
	LEFT JOIN orderdetails od 
		ON p.productCode = od.productCode
	LEFT JOIN orders o 
        ON od.orderNumber = o.orderNumber;
        
-- Creating a view for the warehouses performance depending on the status of the orders.

CREATE VIEW warehouse_performance AS
	SELECT status, warehouseName,
		CASE WHEN status = 'Cancelled' THEN count(status)
			WHEN status = 'Shipped' THEN count(status)
			WHEN status = 'Disputed' THEN count(status) 
			WHEN status = 'In Process' THEN count(status) 
			WHEN status = 'On Hold' THEN count(status) 
			WHEN status = 'Resolved' THEN count(status) 
			ELSE 'non' 
		END as status_info
	FROM order_details_full
	WHERE status is not null
	GROUP BY status, warehouseName
	ORDER BY warehouseName, status desc;

-- Product distribution. 
-- Purpose: Is there products stored in multiple warehouses. 
-- Results: The products are distributed by product lines, and there are not products stored in multiple locations.

SELECT *
FROM (
	SELECT productCode,
    warehouseName,
    ROW_NUMBER() OVER(PARTITION BY productCode ORDER BY warehouseName) AS multiple_stored
	FROM warehouse_inventory) AS tt
WHERE multiple_stored > 1;

-- Purpose: What is quantity of every unique product by product line.
-- Results: The Classic Cars product line holds the highest number of unique inventory of 38, and Trains holds only 3 unique products.

SELECT COUNT(productCode), productLine
FROM products
GROUP BY productLine;

-- Purpose: To determine what part of the orders are fullfiled. 
-- Results: There are 303 shipped unique orders of all 326 placed unique orders, and 6 unique orders are cancelled.

SELECT status, COUNT(DISTINCT orderNumber) AS total_orders_placed
FROM orders
GROUP BY status;

 
-- Purpose: What is the inventory distribution across warehouses?
-- Results: From this query we can see that the South warehouse has the least inventory in stock, and East warehouse holds the most.

SELECT warehouseName, SUM(quantityInStock) AS total_in_stock_by_warehouse
FROM warehouse_inventory
GROUP BY warehouseName
ORDER BY total_in_stock_by_warehouse;

-- Purpose: To show how Sales and Inventory are ballenced? Is there products that are overstocked or with low/insufficient stock? 
-- Results: The query shows that there are items with low sales that are overstocked and items with high sales that are with insufficient stock. 

SELECT productCode, 
	totalQuantitySold,
    quantityInStock,
    (quantityInStock - totalQuantitySold) AS currentInventory,
    warehouseName
FROM 
	(
		SELECT w_inv.warehouseName, w_inv.productCode, w_inv.quantityInStock, SUM(od.quantityOrdered) AS totalQuantitySold
		FROM warehouse_inventory w_inv
		JOIN orderdetails od 
			ON w_inv.productCode = od.productCode
		GROUP BY w_inv.warehouseName, w_inv.productCode, w_inv.quantityInStock) AS tt
WHERE (quantityInStock - totalQuantitySold) < 0
ORDER BY warehouseName;
    

-- Purpose: What is the inventory distribution across warehouses by product line?
-- Results: From this query we see that in the South warehouse are stored products FROM 3 main categories: Trucks and Buses, Ships and Trains. 

SELECT productLine, warehouseName, SUM(quantityInStock) AS total_in_stock_by_productLine
FROM warehouse_inventory
GROUP BY warehouseName,  productLine
ORDER BY total_in_stock_by_productLine;

-- Purpose: To calculate the total stock and total sales by warehouse to see which warehouse has the least sales and what persentage of the inventory in stock is sold.
-- Results: South warehouse is with least items sold.

SELECT warehouseName, 
	sum(totalQuantitySold) AS total_quantity_sold, 
    sum(quantityInStock) AS total_quantity_instock, 
    ROUND((sum(totalQuantitySold)/sum(quantityInStock))*100, 0) AS persantage_of_inventory 
FROM 
(
		SELECT w_inv.warehouseName, w_inv.productCode, w_inv.quantityInStock, SUM(od.quantityOrdered) AS totalQuantitySold
		FROM warehouse_inventory w_inv
		JOIN orderdetails od 
			ON w_inv.productCode = od.productCode
		GROUP BY w_inv.warehouseName, w_inv.productCode, w_inv.quantityInStock) AS tt
GROUP BY warehouseName
ORDER BY total_quantity_sold;

-- Purpose: What count of overall orders did not meet the 24 hour shipping window.
-- Results: The query results provide insights into shipping efficiency. 
-- Out of all 326 orders only 60 orders are shipped within 24 hours and the rest 266 are not. 

SELECT count(distinct orderNumber) FROM
	(SELECT distinct orderNumber, orderDate, shippedDate, (shippedDate - orderDate) as days_to_ship
	FROM orders_full
	WHERE shippedDate IS NOT NULL
	ORDER BY days_to_ship) AS tt2
WHERE days_to_ship > 1;

-- Purpose: Shipping times by order.
-- Results: Days that are required the order to be shipped and the corresponding warehouse where the ordered products are stored.
-- There are orders with products from multiple warehouses.

SELECT distinct tt2.orderNumber, tt2.daysToShip, odf.warehouseName, odf.productLine
FROM
	(SELECT distinct orderNumber, orderDate, shippedDate, (shippedDate - orderDate) as daysToShip, productCode
	FROM orders_full
	WHERE shippedDate IS NOT NULL
	ORDER BY daysToShip) AS tt2
JOIN order_details_full odf
	ON tt2.productCode = odf.productCode
ORDER BY tt2.orderNumber;

-- Purpose: Revenue by product.
-- Results: Shows the products with most sales and the least sold items.

SELECT productCode, orderNumber, quantityOrdered, priceEach, (quantityOrdered*priceEach) AS revenueByProduct, warehouseName
FROM order_details_full
WHERE quantityOrdered IS NOT NULL
ORDER BY revenueByProduct DESC;

-- Purpose: Profit by product considering only the cost of buy price.
-- Results: Shows the products that delivered the most profit for the company and those with the least.

SELECT productCode, quantityOrdered, priceEach, (quantityOrdered*priceEach)-buyPrice AS profitByProduct, (quantityOrdered*priceEach) AS revenueByProduct, warehouseName
FROM order_details_full
WHERE quantityOrdered IS NOT NULL
ORDER BY profitByProduct DESC;

-- Purpose: Calculating the total revenue by warehouse.
-- Results: Shows the warehouse with the high revenue (East) and those with the lowest (West)

SELECT warehouseName, SUM(revenueByProduct) AS totalRevenue
FROM
	(
	SELECT productCode, quantityOrdered, priceEach, (quantityOrdered*priceEach)-buyPrice AS profitByProduct, 
		(quantityOrdered*priceEach) AS revenueByProduct, warehouseName
	FROM order_details_full
	WHERE quantityOrdered IS NOT NULL
	ORDER BY revenueByProduct DESC) AS tt3
GROUP BY warehouseName
ORDER BY totalRevenue DESC;

-- Purpose: What is the warehouse with the lowest revenue. We consider only the orders that are with status 'Shipped' for copmleted.
-- Results: From the results the top 2 warehouses with the lowest revenue are West and South with a difference between them around 2.25%.

SELECT warehouseName, SUM(revenueByProduct) AS totalRevenue 
FROM
(
	SELECT productCode, quantityOrdered, priceEach, (quantityOrdered*priceEach)-buyPrice AS profitByProduct, 
		(quantityOrdered*priceEach) AS revenueByProduct, warehouseName, status
	FROM order_details_full
	WHERE quantityOrdered IS NOT NULL
	ORDER BY revenueByProduct DESC) AS tt3
WHERE status = 'Shipped'
GROUP BY warehouseName
ORDER BY totalRevenue;


-- Purpose: Unsold Products with Inventory 
-- Results: This query identifies products that haven't registered any sales. It aids in pinpointing potential dead stock.
-- There is 1 product with 0 sales in stock in East warehouse with productCode = S18_3233. 

SELECT od.quantityOrdered, w_inv.productCode, w_inv.productLine, w_inv.quantityInStock, w_inv.warehouseName
FROM warehouse_inventory w_inv
LEFT JOIN orderdetails od
	ON w_inv.productCode = od.productCode
WHERE od.quantityOrdered IS NULL
ORDER BY od.quantityOrdered;

-- Purpose: Ranking products by units ordered.
-- Result: This query ranks products based on their sales figures. It helps in identifying top-selling products and those that might need promotional efforts.

SELECT SUM(od.quantityOrdered) AS totalOrdered, w_inv.productCode, w_inv.productLine, w_inv.warehouseName
FROM warehouse_inventory w_inv
JOIN orderdetails od
	ON w_inv.productCode = od.productCode
GROUP BY w_inv.productCode
ORDER BY totalOrdered
LIMIT 5;

SELECT SUM(od.quantityOrdered) AS totalOrdered, w_inv.productCode, w_inv.productLine, w_inv.warehouseName
FROM warehouse_inventory w_inv
JOIN orderdetails od
	ON w_inv.productCode = od.productCode
GROUP BY w_inv.productCode
ORDER BY totalOrdered DESC
LIMIT 5;

-- Purpose: Indentifying the Top 5 products with low stock and high sales.
-- Result:  This indicates the needs of restocking.

SELECT productCode, quantityInStock, COALESCE(SUM(quantityOrdered)) AS totalOrders
FROM order_details_full
GROUP BY productCode, quantityInStock
HAVING quantityInStock < COALESCE(SUM(quantityOrdered))
ORDER BY quantityInStock
LIMIT 5;

-- Purpose: Sale Trends and seasinality.
-- Result: This query gives a yearly breakdown of the number of orders. It helps in understanding yearly sales trends.

SELECT
    YEAR(orderDate) AS year,
    MONTHNAME(orderDate) AS month,
    COUNT(*) AS totalOrders,
    ROW_NUMBER() OVER(PARTITION BY YEAR(orderDate) ORDER BY COUNT(*) desc) AS ordersRank
FROM orders
GROUP BY year, month
ORDER BY year DESC;





























