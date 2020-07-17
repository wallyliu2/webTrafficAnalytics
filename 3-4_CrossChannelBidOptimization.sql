SELECT website_sessions.device_type,
website_sessions.utm_source,
COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
COUNT(DISTINCT orders.order_id) AS orders,
COUNT(DISTINCT orders.order_id)/COUNT(DISTINCT website_sessions.website_session_id) AS conv_rate
FROM website_sessions
LEFT JOIN orders
ON orders.website_session_id = website_sessions.website_session_id
WHERE (website_sessions.created_at BETWEEN '2012-08-22' AND '2012-09-18') 
AND website_sessions.utm_source IN ('gsearch','bsearch')
AND website_sessions.utm_campaign = 'nonbrand'
GROUP BY website_sessions.device_type, website_sessions.utm_source