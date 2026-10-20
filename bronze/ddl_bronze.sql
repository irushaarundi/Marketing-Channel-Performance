/*
==============================================================================
DDL Script: Create Bronze Tables
==============================================================================

Script Purpose 
  This script create tables in the 'bronze' schema, dropping existing tables
  if they already exist.
Run this script to re-define the DDL structure of 'bronze' Table

==============================================================================
*/
IF OBJECT_ID ('bronze.ad_spend','U') IS NOT NULL
	DROP TABLE bronze.ad_spend
CREATE TABLE bronze.ad_spend(
 date date,
 channel NVARCHAR(50),
 campaign NVARCHAR(50),
 impressions INT,
 clicks INT,
 spend DECIMAL(10,2)
);

IF OBJECT_ID ('bronze.signups', 'U') IS NOT NULL
	DROP TABLE bronze.signups
CREATE TABLE bronze.signups(
	user_id INT,
	signup_date date,
	channel NVARCHAR(50),
	campaign NVARCHAR(50),
	subscription_start_date date,
	[plan] NVARCHAR(50),
	revenue_first_90_days DECIMAL(10,2)
);
