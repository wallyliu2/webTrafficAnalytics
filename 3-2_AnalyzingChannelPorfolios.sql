SELECT MIN(DATE(website_sessions.created_at)) AS week_start_date,
COUNT(DISTINCT website_sessions.website_session_id) AS total_sessions,
COUNT(CASE WHEN website_sessions.utm_source = 'gsearch' THEN website_sessions.website_session_id ELSE NULL END) AS gsearch_sessions,
COUNT(CASE WHEN website_sessions.utm_source = 'bsearch' THEN website_sessions.website_session_id ELSE NULL END) AS search_sessions
FROM website_sessions 
WHERE website_sessions.utm_source IN ('gsearch','bsearch') 
	AND website_sessions.utm_campaign = 'nonbrand'
    AND website_sessions.created_at > '2012-08-22'
    AND website_sessions.created_at < '2012-11-29'
GROUP BY WEEK(website_sessions.created_at);