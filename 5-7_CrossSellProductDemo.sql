SELECT primary_product_id,
COUNT(DISTINCT orders.order_id) AS orders,
COUNT(DISTINCT CASE WHEN order_items.product_id = 1 THEN orders.order_id ELSE NULL END) AS x_prod_1,
COUNT(DISTINCT CASE WHEN order_items.product_id = 2 THEN orders.order_id ELSE NULL END) AS x_prod_2,
COUNT(DISTINCT CASE WHEN order_items.product_id = 3 THEN orders.order_id ELSE NULL END) AS x_prod_3,
COUNT(DISTINCT CASE WHEN order_items.product_id = 1 THEN orders.order_id ELSE NULL END)/
	COUNT(DISTINCT orders.order_id) AS x_prod_1_rt,
COUNT(DISTINCT CASE WHEN order_items.product_id = 2 THEN orders.order_id ELSE NULL END)/
	COUNT(DISTINCT orders.order_id) AS x_prod_2_rt,
COUNT(DISTINCT CASE WHEN order_items.product_id = 3 THEN orders.order_id ELSE NULL END)/
	COUNT(DISTINCT orders.order_id) AS x_prod_3_rt 
FROM orders
LEFT JOIN order_items
ON order_items.order_id = orders.order_id 
AND order_items.is_primary_item = 0 -- cross sell only
WHERE orders.order_id BETWEEN 10000 AND 11000
GROUP BY 1;