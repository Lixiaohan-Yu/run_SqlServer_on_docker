-- Test Chinese character support
USE master;
GO

-- Create a test table with Chinese characters
CREATE TABLE test_chinese (
    id INT IDENTITY(1,1) PRIMARY KEY,
    chinese_text NVARCHAR(100),
    description NVARCHAR(200)
);
GO

-- Insert Chinese text
INSERT INTO test_chinese (chinese_text, description) 
VALUES 
    (N'你好世界', N'基本问候语'),
    (N'数据库', N'数据存储系统'),
    (N'容器化', N'Containerization技术'),
    (N'中文支持', N'Chinese character support');
GO

-- Select and display the Chinese text
SELECT * FROM test_chinese;
GO

-- Create a database with Chinese name
CREATE DATABASE [测试数据库] COLLATE Chinese_PRC_CI_AS;
GO

-- Use the Chinese-named database
USE [测试数据库];
GO

-- Create a table in the Chinese-named database
CREATE TABLE 用户信息 (
    用户ID INT IDENTITY(1,1) PRIMARY KEY,
    姓名 NVARCHAR(50),
    邮箱 NVARCHAR(100)
);
GO

-- Insert Chinese data
INSERT INTO 用户信息 (姓名, 邮箱) 
VALUES 
    (N'张三', N'zhangsan@example.com'),
    (N'李四', N'lisi@example.com'),
    (N'王五', N'wangwu@example.com');
GO

-- Select and display the Chinese data
SELECT * FROM 用户信息;
GO

PRINT 'Chinese character test completed successfully';
