-- Create custom login for lxh
CREATE LOGIN lxh WITH PASSWORD = 'yourpassword', CHECK_POLICY = OFF;
GO

-- Create user in master database
USE master;
CREATE USER lxh FOR LOGIN lxh;
GO

-- Set database collation to support Chinese characters
ALTER DATABASE master COLLATE Chinese_PRC_CI_AS;
GO

-- Add user to sysadmin role
ALTER SERVER ROLE sysadmin ADD MEMBER lxh;
GO

-- Create user in tempdb database
USE tempdb;
CREATE USER lxh FOR LOGIN lxh;
GO

-- Set database collation to support Chinese characters
ALTER DATABASE tempdb COLLATE Chinese_PRC_CI_AS;
GO

-- Create user in model database
USE model;
CREATE USER lxh FOR LOGIN lxh;
GO

-- Set database collation to support Chinese characters
ALTER DATABASE model COLLATE Chinese_PRC_CI_AS;
GO

-- Create user in msdb database
USE msdb;
CREATE USER lxh FOR LOGIN lxh;
GO

-- Set database collation to support Chinese characters
ALTER DATABASE msdb COLLATE Chinese_PRC_CI_AS;
GO

PRINT 'User lxh created successfully with sysadmin privileges';

