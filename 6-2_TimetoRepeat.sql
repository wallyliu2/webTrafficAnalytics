USE mavenfuzzyfactory;

CREATE TEMPORARY TABLE user_first_sessions_2
SELECT user_id, created_at FROM website_sessions 
WHERE created_at < '2014-11-03' AND created_at >= '2014-01-01' AND is_repeat_session=0;

SELECT * FROM user_first_sessions_2;


CREATE TEMPORARY TABLE user_sec_sessions
SELECT user_id, MIN(created_at) AS second_created_at FROM website_sessions 
WHERE is_repeat_session = 1 AND created_at < '2014-11-03' AND created_at >= '2014-01-01'
GROUP BY user_id;

SELECT * FROM user_sec_sessions;

CREATE TEMPORARY TABLE user_sessions
SELECT
user_sec_sessions.user_id,
DATEDIFF(second_created_at,created_at) AS fir_to_sec
FROM user_sec_sessions
LEFT JOIN user_first_sessions_2
ON user_first_sessions_2.user_id = user_sec_sessions.user_id;

SELECT 
AVG(fir_to_sec) AS avg_days_first_to_second,
MIN(fir_to_sec) AS min_days_first_to_second,
MAX(fir_to_sec) AS max_days_first_to_second
FROM user_sessions;

