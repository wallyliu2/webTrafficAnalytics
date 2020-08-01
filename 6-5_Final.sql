USE mavenfuzzyfactory;

-- Q1&Q2: Show the volume growth based on the overall sessions and orders by quarter

SELECT YEAR(website_sessions.created_at) AS yr,
QUARTER(website_sessions.created_at) AS qtr,
COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
COUNT(DISTINCT orders.order_id) AS orders,
COUNT(DISTINCT orders.order_id)/COUNT(DISTINCT website_sessions.website_session_id) AS session_to_order_cvr,
SUM(price_usd)/COUNT(DISTINCT orders.order_id) AS revenue_per_order,
SUM(price_usd)/COUNT(DISTINCT website_sessions.website_session_id) AS revenue_per_session
FROM website_sessions
LEFT JOIN orders
ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.created_at < '2015-03-20'
GROUP BY 1,2;


SELECT DISTINCT utm_source, utm_campaign, utm_content, http_referer FROM website_sessions;


-- Q3&Q4: Check the quarterly number of orders by channels (gsearch-nonbrand,bsearch-nonbrand,brand-overall,organic-search, and direct-type-in)
SELECT YEAR(website_sessions.created_at) AS yr,
QUARTER(website_sessions.created_at) AS qtr,
COUNT(CASE WHEN utm_source='gsearch' AND utm_campaign='nonbrand' THEN order_id ELSE NULL END) AS 'gsearch_nonbrand',
COUNT(CASE WHEN utm_source='gsearch' AND utm_campaign='nonbrand' THEN order_id ELSE NULL END)/
	COUNT(CASE WHEN utm_source='gsearch' AND utm_campaign='nonbrand' THEN website_sessions.website_session_id ELSE NULL END) 
    AS 'gsearch_nonbrand_to_session_cvr',
COUNT(CASE WHEN utm_source='bsearch' AND utm_campaign='nonbrand' THEN order_id ELSE NULL END) AS 'bsearch_nonbrand',
COUNT(CASE WHEN utm_source='bsearch' AND utm_campaign='nonbrand' THEN order_id ELSE NULL END)/
	COUNT(CASE WHEN utm_source='bsearch' AND utm_campaign='nonbrand' THEN website_sessions.website_session_id ELSE NULL END)
    AS 'bsearch_nonbrand_to_session_cvr',
COUNT(CASE WHEN utm_campaign='brand' THEN order_id ELSE NULL END) AS 'brand',
COUNT(CASE WHEN utm_campaign='brand' THEN order_id ELSE NULL END)/
	COUNT(CASE WHEN  utm_campaign='brand' THEN website_sessions.website_session_id ELSE NULL END) 
    AS 'brand_to_session_cvr',
COUNT(CASE WHEN utm_source IS NULL AND http_referer IS NOT NULL THEN order_id ELSE NULL END) AS 'organic_search',
COUNT(CASE WHEN utm_source IS NULL AND http_referer IS NOT NULL THEN order_id ELSE NULL END)/
	COUNT(CASE WHEN utm_source IS NULL AND http_referer IS NOT NULL THEN website_sessions.website_session_id ELSE NULL END) 
    AS 'organic_search_to_session_cvr',
COUNT(CASE WHEN http_referer IS NULL THEN order_id ELSE NULL END) AS 'direct_tpye_in',
COUNT(CASE WHEN http_referer IS NULL THEN order_id ELSE NULL END)/
	COUNT(CASE WHEN http_referer IS NULL THEN website_sessions.website_session_id ELSE NULL END) 
    AS 'direct_to_Session_cvr'
FROM website_sessions
LEFT JOIN orders
ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.created_at < '2015-03-20'
GROUP BY 1,2;

SELECT * FROM order_items;

-- Q5: monthly trending for revenue and margin by product and total sales and reveneue
CREATE TEMPORARY TABLE sessions_to_order
SELECT website_sessions.website_session_id, website_sessions.created_at, orders.order_id
FROM website_sessions 
LEFT JOIN orders
ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.created_at < '2015-03-20';

SELECT YEAR(sessions_to_order.created_at) AS yr,
MONTH(sessions_to_order.created_at) AS qtr,
SUM(CASE WHEN product_id=1 THEN price_usd ELSE NULL END) AS p1_revenue,
SUM(CASE WHEN product_id=1 THEN price_usd-cogs_usd ELSE NULL END) AS p1_margin,
SUM(CASE WHEN product_id=2 THEN price_usd ELSE NULL END) AS p2_revenue,
SUM(CASE WHEN product_id=3 THEN price_usd ELSE NULL END) AS p3_revenue,
SUM(CASE WHEN product_id=4 THEN price_usd ELSE NULL END) AS p4_revenue,
SUM(price_usd) AS total_revenue,
SUM(price_usd)-SUM(cogs_usd) AS total_profit
FROM sessions_to_order
LEFT JOIN order_items
ON sessions_to_order.order_id = order_items.order_id
GROUP BY 1,2;

-- Q6: sessions to the product page / total sessions, conversion_rates
SELECT DISTINCT pageview_url FROM website_pageviews WHERE created_at < '2015-03-20';

SELECT 
YEAR(website_pageviews.created_at) AS yr,
MONTH(website_pageviews.created_at) AS mo,
COUNT(DISTINCT CASE WHEN pageview_url = '/products' THEN website_pageviews.website_session_id ELSE NULL END) AS product_sessions,
COUNT(DISTINCT CASE WHEN pageview_url = '/the-original-mr-fuzzy' THEN website_pageviews.website_session_id ELSE NULL END)/
	COUNT(DISTINCT CASE WHEN pageview_url = '/products' THEN website_pageviews.website_session_id ELSE NULL END) AS mrfuzzy_sessions,
COUNT(DISTINCT order_id)/
	COUNT(DISTINCT CASE WHEN pageview_url = '/products' THEN website_pageviews.website_session_id ELSE NULL END) 
	AS product_cvr
FROM website_pageviews
LEFT JOIN orders
ON orders.website_session_id = website_pageviews.website_session_id
WHERE website_pageviews.created_at < '2015-03-20' GROUP BY 1,2; 

-- Q7: See how cross-sells perform
SELECT YEAR(created_at) AS yr,
MONTH(created_at) AS mo,
COUNT(DISTINCT CASE WHEN product_id=1 AND is_primary_item=0 THEN order_id ELSE NULL END)/
	COUNT(DISTINCT order_id) AS p1_cross,
COUNT(DISTINCT CASE WHEN product_id=2 AND is_primary_item=0 THEN order_id ELSE NULL END)/
	COUNT(DISTINCT order_id) AS p2_cross,
COUNT(DISTINCT CASE WHEN product_id=3 AND is_primary_item=0 THEN order_id ELSE NULL END)/
	COUNT(DISTINCT order_id) AS p3_cross,
COUNT(DISTINCT CASE WHEN product_id=4 AND is_primary_item=0 THEN order_id ELSE NULL END)/
	COUNT(DISTINCT order_id) AS p4_cross
FROM order_items 
WHERE created_at BETWEEN '2014-12-05' AND '2015-03-20' GROUP BY 1,2;

-- Q8:

