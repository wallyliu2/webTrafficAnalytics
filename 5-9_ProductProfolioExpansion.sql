SELECT DISTINCT primary_product_id
FROM website_pageviews
LEFT JOIN orders
ON orders.website_session_id = website_pageviews.website_session_id
WHERE website_pageviews.created_at BETWEEN '2013-11-13' AND '2014-1-12';

SELECT
CASE WHEN (website_pageviews.created_at < '2013-12-12') THEN 'A_Pre_Birthday_Bear'
	WHEN (website_pageviews.created_at >= '2013-12-12') THEN 'B_Post_Birthday_Bear'
    ELSE NULL END AS time_period,
COUNT(DISTINCT order_id)/COUNT(DISTINCT website_pageviews.website_session_id) AS CVR,
AVG(CASE WHEN pageview_url='/thank-you-for-your-order' THEN price_usd ELSE NULL END) AS AOV,
SUM(CASE WHEN pageview_url='/thank-you-for-your-order' THEN items_purchased ELSE NULL END)/COUNT(DISTINCT order_id) AS products_per_order,
SUM(CASE WHEN pageview_url='/thank-you-for-your-order' THEN price_usd ELSE NULL END)
	/COUNT(DISTINCT website_pageviews.website_session_id) AS revenue_per_session
FROM website_pageviews
LEFT JOIN orders
ON orders.website_session_id = website_pageviews.website_session_id
WHERE website_pageviews.created_at BETWEEN '2013-11-12' AND '2014-1-12'
GROUP BY 1;