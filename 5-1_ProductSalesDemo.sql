SELECT primary_product_id,
COUNT(order_id) AS orders,
SUM(price_usd) AS revenue,
SUM(price_usd-cogs_usd) AS margin,
SUM(price_usd-cogs_usd)/SUM(price_usd) AS margin_pct,
AVG(price_usd) AS avg_sold_price
FROM orders
WHERE order_id BETWEEN 10000 AND 11000
GROUP BY 1
ORDER BY 2 DESC;