--====================================================================

-- Revenue details of the customers who came because of the campaings

--====================================================================
IF OBJECT_ID ('gold.campaign', 'V') IS NOT NULL
	DROP VIEW gold.campaign
GO
CREATE VIEW gold.campaign AS 
WITH s AS (
    SELECT
        signup_date,
        channel,
        campaign,
        SUM(revenue_first_90_days) AS revenue,
        COUNT(*) AS user_count
    FROM silver.signups
    WHERE campaign IS NOT NULL
    GROUP BY signup_date, channel, campaign
)
SELECT
    sp.date,
    sp.channel,
    sp.campaign,
    SUM(sp.spend)                  AS spend,
    COALESCE(MAX(s.user_count), 0) AS user_count,
    COALESCE(MAX(s.revenue), 0)    AS revenue
FROM silver.ad_spend sp
LEFT JOIN s
    ON  sp.date     = s.signup_date
    AND sp.channel  = s.channel
    AND sp.campaign = s.campaign
GROUP BY sp.date, sp.channel, sp.campaign
GO
--====================================================================

-- Create Revenue & User countof all channel

--====================================================================
IF OBJECT_ID ('gold.revenue_of_channel','V') IS NOT NULL
	DROP VIEW gold.revenue_of_channel
GO   
CREATE VIEW gold.revenue_of_channel AS
SELECT
        signup_date,
        channel,
        SUM(revenue_first_90_days) AS revenue,
        COUNT(*) AS user_count
    FROM silver.signups
    GROUP BY signup_date, channel;

