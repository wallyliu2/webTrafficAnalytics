USE mavenfuzzyfactory;

-- Showing by year, month, and week

SELECT
YEAR(created_at) year,
WEEK(created_at) week,
MIN(DATE(created_at)) start_date,
COUNT(DISTINCT website_session_id) sessions
FROM website_sessions
WHERE website_session_id BETWEEN 100000 AND 200000
GROUP BY 1, 2
ORDER BY 1 ASC, 2 ASC;