USE mavenfuzzyfactory;

-- For gsearch nonbrand
-- We increased the bid for Desktop device on 2012-05-19, now we are looking for the trend by device

SELECT MIN(DATE(created_at)) start_date,
COUNT(DISTINCT CASE WHEN device_type = 'desktop' THEN website_session_id ELSE NULL END) desktop_session,
COUNT(DISTINCT CASE WHEN device_type = 'mobile' THEN website_session_id ELSE NULL END) mobile_session
FROM website_sessions
WHERE created_at < '2020-06-09' AND utm_source ='gsearch' AND utm_campaign='nonbrand'
GROUP BY YEAR(created_at), WEEK(created_at);