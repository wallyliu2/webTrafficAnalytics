USE mavenfuzzyfactory;

SELECT repeat_sessions-1 AS repeat_sessions, COUNT(user_id) AS users
FROM 
(
SELECT DISTINCT user_id, COUNT(user_id) AS repeat_sessions FROM website_sessions 
WHERE created_at < '2014-11-01' AND created_at >= '2014-01-01'
GROUP BY 1
) AS user_sessions
GROUP BY 1
ORDER BY 1;
