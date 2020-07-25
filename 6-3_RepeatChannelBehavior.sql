-- Understand the type of source
SELECT DISTINCT utm_source, utm_campaign, utm_content, http_referer FROM website_sessions 
WHERE created_at < '2014-11-05' AND created_at >= '2014-01-01';

SELECT
(CASE
WHEN utm_source IS NULL AND http_referer IS NOT NULL THEN 'organic_search'
WHEN utm_campaign='brand' AND utm_content IS NOT NULL THEN 'paid_brand'
WHEN utm_campaign='nonbrand' AND utm_content IS NOT NULL THEN 'paid_nonbrand'
WHEN utm_source='socialbook' AND utm_content IS NOT NULL THEN 'paid_social'
WHEN http_referer IS NULL  THEN 'direct_tpye_in'
ELSE NULL END) AS channel_group,
COUNT(DISTINCT CASE WHEN is_repeat_session = 0 THEN website_session_id ELSE NULL END) AS new_sessions,
COUNT(DISTINCT CASE WHEN is_repeat_session = 1 THEN website_session_id ELSE NULL END) AS repeat_sessions
FROM website_sessions
WHERE created_at < '2014-11-05' AND created_at >= '2014-01-01'
GROUP BY 1;


