SELECT MIN(DATE(website_sessions.created_at)) AS start_date,
COUNT(CASE WHEN website_sessions.device_type = 'desktop' AND website_sessions.utm_source = 'gsearch' THEN website_sessions.website_session_id ELSE NULL END) AS g_dtop_sessions,
COUNT(CASE WHEN website_sessions.device_type = 'desktop' AND website_sessions.utm_source = 'bsearch' THEN website_sessions.website_session_id ELSE NULL END) AS b_dtop_sessions,
COUNT(CASE WHEN website_sessions.device_type = 'desktop' AND website_sessions.utm_source = 'bsearch' THEN website_sessions.website_session_id ELSE NULL END)
	/COUNT(CASE WHEN website_sessions.device_type = 'desktop' AND website_sessions.utm_source = 'gsearch' THEN website_sessions.website_session_id ELSE NULL END) AS b_pct_g_dtop,
COUNT(CASE WHEN website_sessions.device_type = 'mobile' AND website_sessions.utm_source = 'gsearch' THEN website_sessions.website_session_id ELSE NULL END) AS g_mobile_sessions,
COUNT(CASE WHEN website_sessions.device_type = 'mobile' AND website_sessions.utm_source = 'bsearch' THEN website_sessions.website_session_id ELSE NULL END) AS b_mobile_sessions,
COUNT(CASE WHEN website_sessions.device_type = 'mobile' AND website_sessions.utm_source = 'bsearch' THEN website_sessions.website_session_id ELSE NULL END)
	/COUNT(CASE WHEN website_sessions.device_type = 'mobile' AND website_sessions.utm_source = 'gsearch' THEN website_sessions.website_session_id ELSE NULL END) AS b_pct_g_mobile
FROM website_sessions
WHERE website_sessions.created_at > '2012-11-04' 
AND website_sessions.created_at < '2012-12-22'
AND website_sessions.utm_campaign = 'nonbrand'
AND website_sessions.utm_source IN ('gsearch','bsearch')
GROUP BY WEEK(website_sessions.created_at);
