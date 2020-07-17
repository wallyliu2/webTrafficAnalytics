SELECT website_sessions.utm_source,
COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
COUNT(CASE WHEN website_sessions.device_type = 'mobile' THEN website_sessions.website_session_id ELSE NULL END) AS mobile_sessions,
COUNT(CASE WHEN website_sessions.device_type = 'mobile' THEN website_sessions.website_session_id ELSE NULL END)/COUNT(DISTINCT website_sessions.website_session_id) AS pct_mobile
FROM website_sessions
WHERE website_sessions.created_at > '2012-08-22' AND website_sessions.created_at < '2012-11-30'
AND website_sessions.utm_source IN ('gsearch','bsearch')
GROUP BY website_sessions.utm_source;