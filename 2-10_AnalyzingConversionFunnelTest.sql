-- We want to know after setting up /billing-2 and try AB Test between /billing and /billing-2's conversion rate to orders

-- First find the start point of billing-2
SELECT MIN(website_pageviews.website_pageview_id) AS first_pv_id 
FROM website_pageviews
WHERE pageview_url = '/billing-2';
-- 53550

-- First of all, we will look at this without orders, then we will add in orders
CREATE TEMPORARY TABLE order_sessions
SELECT
website_pageviews.website_session_id,
website_pageviews.pageview_url AS billing_version_seen,
orders.order_id
FROM website_pageviews
LEFT JOIN orders
ON orders.website_session_id = website_pageviews.website_session_id
WHERE website_pageviews.website_pageview_id > 53550 AND website_pageviews.created_at < '2012-11-10' 
AND website_pageviews.pageview_url IN ('/billing','/billing-2');

SELECT * FROM order_sessions;

SELECT billing_version_seen,
COUNT(DISTINCT website_session_id) AS sessions,
COUNT(DISTINCT order_id) AS orders,
COUNT(DISTINCT order_id)/COUNT(DISTINCT website_session_id) AS billing_to_order_rt
FROM order_sessions GROUP BY billing_version_seen;
