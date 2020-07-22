SELECT YEAR(website_sessions.created_at) AS yr,
WEEK(website_sessions.created_at),
MIN(DATE(website_sessions.created_at)) AS start_date,
COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
COUNT(DISTINCT order_id) AS orders,
COUNT(DISTINCT order_id)/COUNT(DISTINCT website_sessions.website_session_id) AS cvr
-- ,RANK() OVER(ORDER BY COUNT(DISTINCT order_id)/COUNT(DISTINCT website_sessions.website_session_id) DESC) AS rnk
FROM website_sessions
LEFT JOIN orders
ON orders.website_session_id = website_sessions.website_session_id
WHERE website_sessions.created_at < '2013-01-02'
GROUP BY 1,2;

