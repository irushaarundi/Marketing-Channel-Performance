/*
==================================================================================================

Stored Procedure: Load Bronze Layer (Source -> Bronze)

==================================================================================================
Script Purpose:
  This stored procedure loads date into the 'bronze' schema from external CSV files.
  It performs the bronze tables befor loading data.
  - Truncates the bronze tables befor loading data.
  - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None.
  This store procedure doesn't accept any parameters or return any values.
Usage Example:
  EXEC bronze.load_bronze;
==================================================================================================
*/

EXEC  bronze.load_broze;
CREATE OR ALTER PROCEDURE bronze.load_broze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME
	DECLARE @proc_start DATETIME, @proc_end DATETIME
	BEGIN TRY
		SET @proc_start = GETDATE();
		PRINT '========================================================='
		PRINT 'Loading Bronze Layer';
		PRINT '========================================================='

		PRINT '---------------------------------------------------------'
		PRINT 'Loading ad_spend Table'
		PRINT '---------------------------------------------------------'

		SET @start_time = GETDATE();
		PRINT '>> Truncation Table bronze.ad_spend';

		TRUNCATE TABLE bronze.ad_spend;

		PRINT '>> Inserting data into: bronze.ad_spend'
		BULK INSERT bronze.ad_spend
		FROM 'D:\Marketing_Channel_Performance\ad_spend.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR=',',
			ROWTERMINATOR = '0x0a',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration:' + CAST(DATEDIFF(second, @start_time,@end_time) AS NVARCHAR) + ' seconds';
		PRINT '------------------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncation Table bronze.signups';
		TRUNCATE TABLE bronze.signups;

		PRINT 'Inserting data into: bronze.signups'
		BULK INSERT bronze.signups
			FROM 'D:\Marketing_Channel_Performance\signups.csv'
			WITH (
				FIRSTROW = 2,
				FIELDTERMINATOR = ',',
				ROWTERMINATOR = '0x0a',
				TABLOCK
			);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration:' + CAST(DATEDIFF(second, @start_time,@end_time) AS NVARCHAR) + ' seconds';
		PRINT '------------------------------------------------------------';

	END TRY
	BEGIN CATCH
		PRINT '======================================================';
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER';
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '======================================================'
	END CATCH
	SET @proc_end = GETDATE();
		PRINT '>> Bronze Layer Load Duration:' + CAST(DATEDIFF(second, @proc_start,@proc_end) AS NVARCHAR) + ' second';
		PRINT '-------------------------------------------------';
END
