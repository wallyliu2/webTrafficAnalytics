-- Find when we would start /lander-1 as landing page
SELECT MIN(created_at) AS start_date, MAX(created_at) AS end_date, MIN(website_pageview_id) AS min_pageid FROM website_pageviews
WHERE pageview_url = '/lander-1';

CREATE TEMPORARY TABLE first_pageviews
SELECT website_pageviews.website_session_id, MIN(website_pageviews.website_pageview_id) AS first_pageview
FROM website_pageviews
WHERE website_pageviews.created_at BETWEEN '2012-06-19' AND '2012-07-28' AND website_pageviews.website_pageview_id > 23504
GROUP BY website_pageviews.website_session_id; 

SELECT * FROM first_pageviews;

-- Find the landing page 
CREATE TEMPORARY TABLE sessions_w_landing_page
SELECT first_pageviews.website_session_id, website_pageviews.pageview_url AS landing_page
FROM first_pageviews
LEFT JOIN website_pageviews
ON website_pageviews.website_pageview_id = first_pageviews.first_pageview;

SELECT * FROM sessions_w_landing_page;

SELECT landing_page, COUNT(DISTINCT website_session_id)
FROM sessions_w_landing_page
GROUP BY landing_page;

-- Find the bounced session
CREATE TEMPORARY TABLE bounced_sesssions_one
SELECT first_pageviews.website_session_id, COUNT(website_pageviews.website_pageview_id) AS count_of_page_viewed
FROM first_pageviews
LEFT JOIN website_pageviews
ON website_pageviews.website_session_id  = first_pageviews.website_session_id
WHERE website_pageviews.created_at BETWEEN '2012-06-19' AND '2012-07-28' AND website_pageviews.website_pageview_id > 23504
GROUP BY first_pageviews.website_session_id
HAVING COUNT(website_pageviews.website_pageview_id)=1;

SELECT COUNT(*) FROM bounced_sesssions_one;
SELECT * FROM bounced_sesssions_one;

SELECT bounced_sesssions_one.website_session_id, website_pageviews.pageview_url AS landing_page
FROM bounced_sesssions_one
LEFT JOIN website_pageviews
ON website_pageviews.website_session_id = bounced_sesssions_one.website_session_id;

-- Calculate bounce rate
SELECT sessions_w_landing_page.landing_page,
COUNT(sessions_w_landing_page.website_session_id) AS total_sessions,
COUNT(bounced_sesssions_one.website_session_id) AS bounced_sessions,
COUNT(bounced_sesssions_one.website_session_id)/COUNT(sessions_w_landing_page.website_session_id) AS bounce_rate
FROM sessions_w_landing_page
LEFT JOIN bounced_sesssions_one
ON bounced_sesssions_one.website_session_id = sessions_w_landing_page.website_session_id
GROUP BY sessions_w_landing_page.landing_page;
