SELECT * FROM order_item_refunds; -- order_item_id

SELECT * FROM order_items; -- order_item_id, product_id

SELECT order_item_refunds.created_at AS refund_time,
order_item_refunds.order_item_id;


SELECT
YEAR(order_items.created_at) AS yr,
MONTH(order_items.created_at) AS mo,
COUNT(DISTINCT CASE WHEN order_items.product_id=1 THEN order_items.order_item_id ELSE NULL END) AS p1_orders,
COUNT(DISTINCT CASE WHEN order_items.product_id=1 THEN order_item_refunds.order_id ELSE NULL END)/
	COUNT(CASE WHEN order_items.product_id=1 THEN order_items.order_item_id ELSE NULL END) AS p1_refund_rt,
COUNT(DISTINCT CASE WHEN order_items.product_id=2 THEN order_items.order_item_id ELSE NULL END) AS p2_orders,
COUNT(DISTINCT CASE WHEN order_items.product_id=2 THEN order_item_refunds.order_id ELSE NULL END)/
	COUNT(CASE WHEN order_items.product_id=2 THEN order_items.order_item_id ELSE NULL END) AS p2_refund_rt,
COUNT(DISTINCT CASE WHEN order_items.product_id=3 THEN order_items.order_item_id ELSE NULL END) AS p3_orders,
COUNT(DISTINCT CASE WHEN order_items.product_id=3 THEN order_item_refunds.order_id ELSE NULL END)/
	COUNT(CASE WHEN order_items.product_id=3 THEN order_items.order_item_id ELSE NULL END) AS p3_refund_rt,
COUNT(DISTINCT CASE WHEN order_items.product_id=4 THEN order_items.order_item_id ELSE NULL END) AS p4_orders,
COUNT(DISTINCT CASE WHEN order_items.product_id=4 THEN order_item_refunds.order_id ELSE NULL END)/
	COUNT(CASE WHEN order_items.product_id=4 THEN order_items.order_item_id ELSE NULL END) AS p4_refund_rt
FROM
order_items
LEFT JOIN order_item_refunds
ON order_item_refunds.order_item_id = order_items.order_item_id 
WHERE order_items.created_at < '2014-10-15'
GROUP BY 1,2;

