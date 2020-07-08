USE mavenfuzzyfactory;

-- For gsearch nonbrand
-- Understand the conversion rate by device
SELECT w.device_type, COUNT(DISTINCT w.website_session_id) AS sessions,
COUNT(DISTINCT o.order_id) AS orders,
COUNT(DISTINCT o.order_id)/COUNT(DISTINCT w.website_session_id) AS conversion_rate
FROM website_sessions w
LEFT JOIN orders o
ON o.website_session_id = w.website_session_id
WHERE w.created_at < '2012-05-11' AND utm_source ='gsearch' AND utm_campaign='nonbrand'
GROUP BY w.device_type;