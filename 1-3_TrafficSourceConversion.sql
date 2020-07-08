USE mavenfuzzyfactory;

-- For gsearch nonbrand
-- We want to know if the conversion rate is acceptable (at least 4%) for campaign
SELECT COUNT(DISTINCT w.website_session_id) AS sessions, COUNT(DISTINCT o.order_id) AS orders,
COUNT(DISTINCT o.order_id)/COUNT(DISTINCT w.website_session_id) AS session_to_conv_rate
FROM website_sessions AS w
LEFT JOIN orders AS o
ON o.website_session_id = w.website_session_id
WHERE w.created_at < '2012-4-12' AND w.utm_source ='gsearch' AND w.utm_campaign='nonbrand'
ORDER BY 3 DESC;