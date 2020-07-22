SELECT 
CASE WHEN (website_pageviews.created_at < '2013-09-25') THEN 'A_Pre_Cross_Sell'
	WHEN (website_pageviews.created_at >= '2013-09-25') THEN 'B_Post_Cross_Sell'
    ELSE NULL END AS time_period,
COUNT(DISTINCT CASE WHEN pageview_url = '/cart' THEN website_pageviews.website_session_id ELSE NULL END) AS cart_sessions,
COUNT(DISTINCT CASE WHEN pageview_url = '/shipping' THEN website_pageviews.website_session_id ELSE NULL END) AS clickthroughs,
COUNT(DISTINCT CASE WHEN pageview_url = '/shipping' THEN website_pageviews.website_session_id ELSE NULL END)
	/COUNT(DISTINCT CASE WHEN pageview_url = '/cart' THEN website_pageviews.website_session_id ELSE NULL END) AS ctr,
COUNT(DISTINCT order_id) AS order_placed,
SUM(CASE WHEN pageview_url='/thank-you-for-your-order' THEN items_purchased ELSE NULL END) AS product_purchased,
SUM(CASE WHEN pageview_url='/thank-you-for-your-order' THEN items_purchased ELSE NULL END)/COUNT(DISTINCT order_id) AS products_per_order,
SUM(CASE WHEN pageview_url='/thank-you-for-your-order' THEN price_usd ELSE NULL END) AS revenue,
AVG(CASE WHEN pageview_url='/thank-you-for-your-order' THEN price_usd ELSE NULL END) AS AOV,
SUM(CASE WHEN pageview_url='/thank-you-for-your-order' THEN price_usd ELSE NULL END)
	/COUNT(DISTINCT CASE WHEN pageview_url = '/cart' THEN website_pageviews.website_session_id ELSE NULL END) AS revenue_per_cart -- ISSUE
FROM website_pageviews
LEFT JOIN orders
ON orders.website_session_id = website_pageviews.website_session_id
WHERE website_pageviews.created_at BETWEEN '2013-08-25' AND '2013-10-25'
GROUP BY 1;


-- Just Check
SELECT *
FROM website_pageviews
LEFT JOIN orders
ON orders.website_session_id = website_pageviews.website_session_id
WHERE website_pageviews.created_at BETWEEN '2013-08-25' AND '2013-10-25';
