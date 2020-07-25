SELECT 
is_repeat_session,
COUNT(website_sessions.website_session_id) AS sessions,
COUNT(order_id)/COUNT(website_sessions.website_session_id) AS conv_rate,
SUM(price_usd)/COUNT(website_sessions.website_session_id) AS revenue_per_session
FROM website_sessions
LEFT JOIN orders
ON orders.website_session_id = website_sessions.website_session_id
WHERE website_sessions.created_at < '2014-11-08' AND website_sessions.created_at >= '2014-01-01'
GROUP BY 1;