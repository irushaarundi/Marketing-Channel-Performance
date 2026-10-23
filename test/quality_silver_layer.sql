
-- Check the dublicate rows in the sd_spend_table
-- Expected Result: NONE
SELECT DISTINCT(CONCAT([date], '_' ,TRIM(LOWER( channel)), '_', campaign))AS ad_spend_key, COUNT(*) AS COUNT
FROM silver.ad_spend
GROUP BY CONCAT([date], '_' , TRIM(LOWER( channel)), '_', campaign)
HAVING COUNT(*)>1;


-- Check the Mach of the channel in 2 data tables 
-- Expected Result: NONE
SELECT DISTINCT channel
FROM silver.ad_spend
EXcept
SELECT DISTINCT channel
FROM silver.signups
WHERE campaign IS NOT NULL;

-- Check the Mach of the campaign in 2 data tables 
-- Expected Result: NONE
SELECT DISTINCT campaign
FROM silver.ad_spend
EXcept
SELECT DISTINCT campaign
FROM silver.signups
WHERE campaign IS NOT NULL;
