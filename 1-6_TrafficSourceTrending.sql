USE mavenfuzzyfactory;

-- For gsearch nonbrand
-- Check if we bid down on 2020-4-15 works
SELECT MIN(DATE(created_at)) AS start_date, COUNT(DISTINCT website_session_id) AS sessions
FROM 
website_sessions
WHERE created_at < '2012-05-10' AND utm_source ='gsearch' AND utm_campaign='nonbrand'
GROUP BY WEEK(created_at);

