USE mavenfuzzyfactory;

-- We want to see how many traffics by source and by campaign
SELECT utm_source, utm_campaign, http_referer, COUNT(DISTINCT website_session_id) AS sessions
FROM website_sessions
WHERE created_at < '2012-4-12'
GROUP BY utm_source, utm_campaign, http_referer
ORDER BY sessions DESC;