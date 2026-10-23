/*
==============================================================================
DDL Script: Create Silver Tables
==============================================================================

Script Purpose 
  This script create tables in the 'silver' schema, dropping existing tables
  if they already exist.
Run this script to re-define the DDL structure of 'silver' Table

==============================================================================
*/
IF OBJECT_ID ('silver.ad_spend', 'U') IS NOT NULL
	DROP TABLE silver.ad_spend
CREATE TABLE silver.ad_spend(
	ad_spend_key NVARCHAR(50),
	[date] date,
	channel NVARCHAR(50),
	campaign NVARCHAR(50),
	impressions INT,
	clicks INT,
	spend DECIMAL(10,2),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID('silver.signups', 'U') IS NOT NULL
	DROP TABLE silver.signups
CREATE TABLE silver.signups(
	user_id INT,
	signup_date DATE,
	channel NVARCHAR(50),
	campaign NVARCHAR(50),
	subscription_start_date date,
	[plan] NVARCHAR(50),
	revenue_first_90_days DECIMAL(10,2),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
