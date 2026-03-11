# SQL Server 2008 R2 Docker 镜像

本仓库包含用于容器化 SQL Server 2008 R2 的 Dockerfile。请注意，SQL Server 2008 R2 是一个非常旧的版本，微软已经终止了对它的 mainstream 支持。如果可能，请考虑使用更新版本的 SQL Server。

## 要求

1. SQL Server 2008 R2 安装文件（从 ISO 提取）
2. 系统上已安装 Docker
3. Docker 中已启用 Windows 容器支持

## 使用方法

1. 将 SQL Server 2008 R2 安装文件放置在与 Dockerfile 同一目录下的名为 `SQLServer2008R2` 的目录中
2. 构建 Docker 镜像：
```bash
docker build -t sqlserver2008r2 .
```

3. 运行容器：
```bash
docker run -e ACCEPT_EULA=Y -e SA_PASSWORD=YourStrong!Passw0rd -p 1433:1433 -d sqlserver2008r2
```

## 执行步骤

以下是完整的执行步骤，方便下次使用：

### 1. 构建镜像
```bash
docker build -t sqlserver2008r2 .
```

### 2. 运行容器
```bash
docker run -e ACCEPT_EULA=Y -e SA_PASSWORD=Lxh991130@sql -p 1433:1433 -d sqlserver2008r2
```

### 3. 验证容器运行状态
```bash
# 查看运行中的容器
docker ps

# 查看容器日志
docker logs <容器ID>
```

### 4. 进入容器终端（可选）
```bash
docker exec -it <容器ID> bash
```

### 5. 连接数据库
```bash
# 使用 sqlcmd 连接
docker exec -it <容器ID> sqlcmd -S localhost -U SA -P "Lxh991130@sql"
```

## 注意事项

- SA 密码必须满足 SQL Server 2008 R2 的要求（最小长度 8 个字符，包含大写字母、小写字母、数字和特殊字符）
- 此镜像仅用于开发和测试目的
- SQL Server 2008 R2 存在已知的限制和安全漏洞
- 对于新版本，请考虑使用官方的 Microsoft SQL Server 容器镜像
- 中文字符支持：本镜像已配置 Chinese_PRC_CI_AS 排序规则以支持中文字符显示和存储

## 安全警告

此 Dockerfile 为简化操作使用了默认的 SA 密码。在生产环境中，始终使用强且唯一的密码，并考虑使用 Docker secrets 或其他安全方法来管理凭据。

## 中文字符支持说明

为解决中文乱码问题，已进行以下配置：
1. 在 Dockerfile 中设置环境变量 `MSSQL_COLLATION=Chinese_PRC_CI_AS`
2. 在 create-user.sql 中为各系统数据库设置 Chinese_PRC_CI_AS 排序规则
3. 提供 test-chinese.sql 脚本用于验证中文字符支持
