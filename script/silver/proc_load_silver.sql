/*
==================================================================================================

Stored Procedure: Load silver Layer (Bronze -> Silver)

==================================================================================================
Script Purpose:
  This stored procedure performs the ETL (Extract, Transform, Load process to
  populate the 'slver' schema tables from the 'broze' schema.
Action Performed:
	- Truncates Silver tables.
	- Inserts transformed and cleansed data from Bronze into Silver tables.

Parameters:
    None.
  This store procedure doesn't accept any parameters or return any values.
Usage Example:
  EXEC silver.load_silver;
==================================================================================================
*/


EXEC silver.load_silver;

CREATE OR ALTER PROCEDURE silver.load_silver AS 
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME
	DECLARE @pros_start_time DATETIME, @pros_end_time DATETIME
	BEGIN TRY 
		SET @pros_start_time = GETDATE();
		PRINT '======================================================';
			PRINT 'Loading Silver Layer';
			PRINT '======================================================';

			PRINT '------------------------------------------------------';
			PRINT 'Loading ad_spend Tables';
			PRINT '------------------------------------------------------';
	
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.ad_spend'
		TRUNCATE TABLE silver.ad_spend;
		INSERT INTO silver.ad_spend(
			[date],
			channel,
			campaign,
			impressions,
			clicks,
			spend)
		SELECT
			[date],
			TRIM(LOWER(channel)) AS channel,
			campaign,
			impressions,
			clicks,
			spend
			FROM(
				SELECT 
					*,
					ROW_NUMBER() OVER (PARTITION BY CONCAT([date], '_' , channel, '_', campaign) ORDER BY [date] DESC) AS ad_spend_key
					FROM bronze.ad_spend
				)t WHERE ad_spend_key =1
			SET @end_time = GETDATE();
			PRINT '>> Load Duration:' + CAST(DATEDIFF(second, @start_time,@end_time) AS NVARCHAR) + ' seconds';
			PRINT '-------------------------------------------------';

	PRINT '>> Truncating Table: silver.signup'
	TRUNCATE TABLE silver.signups;
	INSERT INTO silver.signups( 
			user_id,
			signup_date,
			channel,
			campaign,
			subscription_start_date,
			[plan],
			revenue_first_90_days)
		SELECT 
			user_id,
			signup_date,
			TRIM(LOWER(REPLACE (channel, '_', ' '))) channel,
			campaign,
			subscription_start_date,
			[plan],
			revenue_first_90_days
		FROM bronze.signups
		SET @end_time = GETDATE();
			PRINT '>> Load Duration:' + CAST(DATEDIFF(second, @start_time,@end_time) AS NVARCHAR) + ' second';
			PRINT '-------------------------------------------------';
	END TRY
	BEGIN CATCH
		PRINT '======================================================';
		PRINT 'ERROR OCCURED DURING LOADING SILVER LAYER';
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '======================================================'
	END CATCH
	SET @pros_end_time = GETDATE();
	PRINT '>> SILVER Layer Load Duration:' + CAST(DATEDIFF(second, @pros_start_time,@pros_end_time) AS NVARCHAR) + ' second';
	PRINT '-------------------------------------------------';
END
