USE mavenfuzzyfactory;

-- Like pivot table

SELECT primary_product_id, 
COUNT(CASE WHEN items_purchased = 1 THEN order_id ELSE NULL END) AS singleitem,
COUNT(CASE WHEN items_purchased = 2 THEN order_id ELSE NULL END) AS twoitems
FROM orders
WHERE order_id BETWEEN 31000 AND 32000
GROUP BY primary_product_id
ORDER BY 1;
