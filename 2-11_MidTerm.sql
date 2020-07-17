SELECT * FROM website_sessions;

-- websessions of gsearch
CREATE TEMPORARY TABLE gsearch_web
SELECT * FROM website_sessions WHERE utm_source = 'gsearch' AND created_at > '2012-01-01'  AND created_at < '2012-11-27';

SELECT * FROM gsearch_web;

-- gsearch sessions an orders by monthly trend
SELECT MONTH(gsearch_web.created_at),
COUNT(DISTINCT gsearch_web.website_session_id) AS sessions,
COUNT(DISTINCT orders.order_id) AS orders,
COUNT(DISTINCT orders.order_id)/COUNT(DISTINCT gsearch_web.website_session_id) AS billing_to_order_rt
FROM gsearch_web 
LEFT JOIN orders
ON orders.website_session_id = gsearch_web.website_session_id
GROUP BY MONTH(gsearch_web.created_at);

-- splitting brand and nonbrand campaigns seperately
SELECT MONTH(gsearch_web.created_at),
gsearch_web.utm_campaign,
COUNT(DISTINCT gsearch_web.website_session_id) AS sessions,
COUNT(DISTINCT orders.order_id) AS orders,
COUNT(DISTINCT orders.order_id)/COUNT(DISTINCT gsearch_web.website_session_id) AS billing_to_order_rt
FROM gsearch_web 
LEFT JOIN orders
ON orders.website_session_id = gsearch_web.website_session_id
GROUP BY MONTH(gsearch_web.created_at), gsearch_web.utm_campaign
ORDER BY gsearch_web.utm_campaign;

-- monthly sessions and orders split by device-type
SELECT MONTH(gsearch_web.created_at),
gsearch_web.device_type,
COUNT(DISTINCT gsearch_web.website_session_id) AS sessions,
COUNT(DISTINCT orders.order_id) AS orders,
COUNT(DISTINCT orders.order_id)/COUNT(DISTINCT gsearch_web.website_session_id) AS billing_to_order_rt
FROM gsearch_web 
LEFT JOIN orders
ON orders.website_session_id = gsearch_web.website_session_id
WHERE gsearch_web.utm_campaign = 'nonbrand'
GROUP BY MONTH(gsearch_web.created_at), gsearch_web.device_type
ORDER BY gsearch_web.device_type;

-- device type from tutor's answer
SELECT YEAR(website_sessions.created_at) AS yr,
MONTH(website_sessions.created_at) AS mo,
COUNT(DISTINCT CASE WHEN website_sessions.device_type = 'desktop' THEN website_sessions.website_session_id ELSE NULL END) AS desktop_sessions,
COUNT(DISTINCT CASE WHEN website_sessions.device_type = 'desktop' THEN orders.order_id ELSE NULL END) AS desktop_orders,
COUNT(DISTINCT CASE WHEN website_sessions.device_type = 'mobile' THEN website_sessions.website_session_id ELSE NULL END) AS mobile_sessions,
COUNT(DISTINCT CASE WHEN website_sessions.device_type = 'mobile' THEN orders.order_id ELSE NULL END) AS mobile_orders
FROM website_sessions
LEFT JOIN orders
ON orders.website_session_id = website_sessions.website_session_id
WHERE website_sessions.created_at < '2012-11-27'
AND website_sessions.utm_source = 'gsearch'
AND website_sessions.utm_campaign = 'nonbrand'
GROUP BY YEAR(website_sessions.created_at),MONTH(website_sessions.created_at);



-- show the traffics by each channel source
SELECT website_sessions.utm_source,
MONTH(website_sessions.created_at),
COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
COUNT(DISTINCT orders.order_id) AS orders,
COUNT(DISTINCT orders.order_id)/COUNT(DISTINCT website_sessions.website_session_id) AS billing_to_order_rt
FROM website_sessions
LEFT JOIN orders
ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.created_at > '2012-01-01'  AND website_sessions.created_at < '2012-11-27'
GROUP BY website_sessions.utm_source, MONTH(website_sessions.created_at);

-- first pageview with websessions
CREATE TEMPORARY TABLE fpv_sessions_1
SELECT website_sessions.website_session_id,
MIN(website_pageviews.website_pageview_id) AS first_pageview
FROM website_sessions
LEFT JOIN website_pageviews
ON website_pageviews.website_session_id = website_sessions.website_session_id
WHERE website_sessions.created_at > '2012-06-19' AND website_sessions.created_at < '2012-07-28' AND website_sessions.utm_campaign = 'nonbrand'
GROUP BY website_sessions.website_session_id;

SELECT * FROM fpv_sessions_1;

-- combine the url info
CREATE TEMPORARY TABLE fpv_sessions_url_1
SELECT fpv_sessions_1.website_session_id,
fpv_sessions_1.first_pageview,
website_pageviews.pageview_url
FROM fpv_sessions_1
INNER JOIN website_pageviews
ON website_pageviews.website_pageview_id = fpv_sessions_1.first_pageview;

SELECT * FROM fpv_sessions_url_1;

SELECT 
-- fpv_sessions_url_1.first_pageview, 
fpv_sessions_url_1.pageview_url,
COUNT(DISTINCT fpv_sessions_url_1.website_session_id) AS sessions,
COUNT(DISTINCT orders.order_id) AS orders, 
COUNT(DISTINCT orders.order_id)/COUNT(DISTINCT fpv_sessions_url_1.website_session_id) AS billing_to_order_rt,
SUM(orders.price_usd) AS total_revenue
FROM fpv_sessions_url_1
LEFT JOIN orders
ON orders.website_session_id = fpv_sessions_url_1. website_session_id
GROUP BY fpv_sessions_url_1.pageview_url;

-- 8. revenue per billing page session 9/10/2012 - 11/10/2012 by month
SELECT
website_pageviews.pageview_url,
COUNT(DISTINCT website_pageviews.website_session_id) AS billing_sessions, 
SUM(price_usd) AS total_revenue,
SUM(price_usd)/COUNT(DISTINCT website_pageviews.website_session_id) AS revenue_per_page
FROM website_pageviews 
LEFT JOIN orders
ON orders.website_session_id = website_pageviews.website_session_id
WHERE website_pageviews.created_at > '2012-09-10' AND website_pageviews.created_at < '2012-11-20' 
AND (website_pageviews.pageview_url = '/billing' OR website_pageviews.pageview_url = '/billing-2')
GROUP BY website_pageviews.pageview_url;


