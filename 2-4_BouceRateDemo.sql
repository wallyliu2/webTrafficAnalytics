-- Business context: we want to see landing performance for a certain period

-- Step 1: Find the first website_pageview_id for relevant sessions
-- Step 2: Identify the landing page of each session
-- Step 3: Counting pageviews for each session, to identify "bounces"
-- Step 4: Summarizing total sessions and bouced sessions, by LP

-- Find the minimum web pageview id assoicated with each session we care about

CREATE TEMPORARY TABLE first_pageviews_demo
SELECT website_pageviews.website_session_id, MIN(website_pageviews.website_pageview_id) AS min_pageview_id
FROM website_pageviews
INNER JOIN website_sessions
ON website_sessions.website_session_id = website_pageviews.website_session_id
AND website_sessions.created_at BETWEEN '2014-01-01' AND '2014-02-01'
GROUP BY website_pageviews.website_session_id;

SELECT * FROM first_pageviews_demo;

-- Next, we will bring in the landing page to each session
CREATE TEMPORARY TABLE sessions_w_landing_page_demo
SELECT first_pageviews_demo.website_session_id, website_pageviews.pageview_url AS landing_page
FROM first_pageviews_demo
LEFT JOIN website_pageviews
ON website_pageviews.website_pageview_id = first_pageviews_demo.min_pageview_id;


SELECT * FROM sessions_w_landing_page_demo;
-- Next, we will make a table including a count of pageviews per session
-- First, I'll show you all of sessions. Then, we will limit to bounced sessions and create a temp table

-- CREATE TEMP TABLE bounced_sesssions_only
CREATE TEMPORARY TABLE bounced_sessions_only
SELECT sessions_w_landing_page_demo.website_session_id, sessions_w_landing_page_demo.landing_page,
COUNT(website_pageviews.website_pageview_id) AS count_of_page_viewed
FROM sessions_w_landing_page_demo
LEFT JOIN website_pageviews
ON website_pageviews.website_session_id = sessions_w_landing_page_demo.website_session_id
GROUP BY sessions_w_landing_page_demo.website_session_id, sessions_w_landing_page_demo.landing_page
HAVING COUNT(website_pageviews.website_pageview_id)=1;

SELECT * FROM bounced_sessions_only;
-- We will do this first, then we will summarize with a count filter

SELECT sessions_w_landing_page_demo.landing_page, sessions_w_landing_page_demo.website_session_id,
bounced_sessions_only.website_session_id AS bounced_website_session_id
FROM sessions_w_landing_page_demo
LEFT JOIN bounced_sessions_only
ON sessions_w_landing_page_demo.website_session_id = bounced_sessions_only.website_session_id
ORDER BY sessions_w_landing_page_demo.website_session_id;

-- Final output
-- We will use the same query we previously ran, and run a count of records
-- We will group by landing page, and then we will add a bounce rate column

SELECT  sessions_w_landing_page_demo.landing_page,
COUNT(DISTINCT sessions_w_landing_page_demo.website_session_id) AS sessions,
COUNT(DISTINCT bounced_sessions_only.website_session_id) AS bounced_sessions,
COUNT(DISTINCT bounced_sessions_only.website_session_id)/COUNT(DISTINCT sessions_w_landing_page_demo.website_session_id) as 
FROM sessions_w_landing_page_demo
LEFT JOIN bounced_sessions_only
ON sessions_w_landing_page_demo.website_session_id = bounced_sessions_only.website_session_id
GROUP BY sessions_w_landing_page_demo.landing_page;

