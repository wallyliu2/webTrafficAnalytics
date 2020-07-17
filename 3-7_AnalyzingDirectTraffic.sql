SELECT DISTINCT utm_campaign, utm_source, http_referer FROM website_sessions;

SELECT YEAR(created_at) AS yr,
MONTH(created_at) AS mo,
COUNT(CASE WHEN utm_campaign = 'nonbrand' THEN website_session_id ELSE NULL END) AS nonbrand,
COUNT(CASE WHEN utm_campaign = 'brand' THEN website_session_id ELSE NULL END) AS brand,
COUNT(CASE WHEN utm_campaign = 'brand' THEN website_session_id ELSE NULL END)/COUNT(CASE WHEN utm_campaign = 'nonbrand' THEN website_session_id ELSE NULL END) AS brand_pct_of_nonbrand,
COUNT(CASE WHEN utm_source IS NULL AND http_referer IS NULL THEN website_session_id ELSE NULL END) AS direct,
COUNT(CASE WHEN utm_source IS NULL AND http_referer IS NULL THEN website_session_id ELSE NULL END)/COUNT(CASE WHEN utm_campaign = 'nonbrand' THEN website_session_id ELSE NULL END) AS direct_pct_of_nonbrand,
COUNT(CASE WHEN (utm_campaign IS NULL AND http_referer IS NOT NULL) THEN website_session_id ELSE NULL END) AS organic,
COUNT(CASE WHEN (utm_campaign IS NULL AND http_referer IS NOT NULL) THEN website_session_id ELSE NULL END)/COUNT(CASE WHEN utm_campaign = 'nonbrand' THEN website_session_id ELSE NULL END) AS organic_pct_of_nonbrand
FROM website_sessions
WHERE created_at < '2012-12-23'
GROUP BY 1,2;

