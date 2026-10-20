*/
=====================================================================================
Create Database and Schemas
=====================================================================================
Script Purpose:
      This scrpt creates a new database named 'MChannel_Performance' after checking if it already exists.
    	If the database exists, it is droped and recreated. Additionaly, the script set up three schemas
    	within the database: 'broze', 'silver', 'gold'.

WARNING:
	Running this script will drop the entire 'MChannel_Performance if it exist.
	All data in the database will be permanently deleted. Proceed with caution.
	and ensure you have backup befor running this script.

*/
--CREATE DDatabase 'MChannel_Performance'
USE master;

-- Drop ad recreate the 'MChannel_Performance' database
IF EXISTS(SELECT 1 FROM sys.databases WHERE name ='MChannel_Performance')
BEGIN 
	ALTER DATABASE MChannel_Performance SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE MChannel_Performance;
END;

GO

-- Create Database 'MChannel_Performance'
CREATE DATABASE MChannel_Performance;
GO

USE MChannel_Performance;
GO
-- Create Shecma
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO
