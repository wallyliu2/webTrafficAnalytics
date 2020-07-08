-- CREATE A TABLE INCLUDING THE FIRST PAGEVIEW BEFORE JUNE 14 2012

CREATE TEMPORARY TABLE first_pageview_table
SELECT website_pageviews.website_session_id, MIN(website_pageviews.website_pageview_id) AS first_pageview
FROM website_pageviews
WHERE website_pageviews.created_at < '2012-06-14'
GROUP BY website_pageviews.website_session_id;

SELECT COUNT(website_session_id) FROM first_pageview_table;
SELECT * FROM first_pageview_table;

-- CREATE TEMP TABLE bounced_sesssions_only
CREATE TEMPORARY TABLE only_bounced_sesssions
SELECT first_pageview_table.website_session_id, COUNT(website_pageviews.website_pageview_id) AS count_of_page_viewed
FROM first_pageview_table
LEFT JOIN website_pageviews
ON website_pageviews.website_session_id  = first_pageview_table.website_session_id
GROUP BY first_pageview_table.website_session_id
HAVING COUNT(website_pageviews.website_pageview_id)=1;

SELECT * FROM only_bounced_sesssions;
SELECT COUNT(website_session_id) FROM only_bounced_sesssions;

-- Calculate bounce rate
SELECT COUNT(first_pageview_table.website_session_id) AS sessions,
COUNT(only_bounced_sesssions.website_session_id) AS bounced_sessions,
COUNT(only_bounced_sesssions.website_session_id)/COUNT(first_pageview_table.website_session_id) AS bounce_rate
FROM first_pageview_table
LEFT JOIN only_bounced_sesssions
ON first_pageview_table.website_session_id = only_bounced_sesssions.website_session_id;