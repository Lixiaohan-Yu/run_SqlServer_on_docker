# SQL Server 2008 R2 Dockerfile
# 
# IMPORTANT: SQL Server 2008 R2 cannot be containerized using this approach
# because Microsoft does not provide official container images for SQL Server 2008 R2.
# SQL Server 2008 R2 is a Windows-only application that reached end of support
# on July 8, 2019, and cannot run on Linux containers.
#
# This Dockerfile demonstrates the approach that would be needed if SQL Server 2008 R2
# could be containerized, but in practice you would need to install SQL Server 2008 R2
# on a Windows Server 2008 R2 machine or VM, not in a container.

FROM mcr.microsoft.com/mssql/server:2019-latest

# Install SQL Server tools (run as root)
USER root
RUN apt-get update && \
    apt-get install -y apt-utils && \
    echo "msodbcsql17 msodbcsql/ACCEPT_EULA boolean true" | debconf-set-selections && \
    echo "mssql-tools mssql-tools/ACCEPT_EULA boolean true" | debconf-set-selections && \
    apt-get install -y mssql-tools && \
    ln -s /opt/mssql-tools/bin/sqlcmd /usr/bin/sqlcmd
USER 10001

# Set environment variables
ENV ACCEPT_EULA=Y
ENV SA_PASSWORD=Lxh991130@sql
ENV MSSQL_PID=Express
ENV MSSQL_COLLATION=Chinese_PRC_CI_AS

# Copy user creation script and test script first
COPY create-user.sql /tmp/create-user.sql
COPY test-chinese.sql /tmp/test-chinese.sql

# Create a startup script that explains the situation and creates the user
RUN echo '#!/bin/bash' > /tmp/start-sqlserver.sh && \
    echo 'echo "***************************************************************************"' >> /tmp/start-sqlserver.sh && \
    echo 'echo "* WARNING: SQL Server 2008 R2 cannot be containerized using this approach *"' >> /tmp/start-sqlserver.sh && \
    echo 'echo "* because Microsoft does not provide official container images for SQL     *"' >> /tmp/start-sqlserver.sh && \
    echo 'echo "* Server 2008 R2. This image is running SQL Server 2019 instead.          *"' >> /tmp/start-sqlserver.sh && \
    echo 'echo "* For SQL Server 2008 R2, you would need to install it on a Windows       *"' >> /tmp/start-sqlserver.sh && \
    echo 'echo "* Server 2008 R2 machine or VM, not in a container.                     *"' >> /tmp/start-sqlserver.sh && \
    echo 'echo "***************************************************************************"' >> /tmp/start-sqlserver.sh && \
    echo 'echo ""' >> /tmp/start-sqlserver.sh && \
    echo 'echo "Starting SQL Server..."' >> /tmp/start-sqlserver.sh && \
    echo '# Start SQL Server in background' >> /tmp/start-sqlserver.sh && \
    echo '/opt/mssql/bin/sqlservr &' >> /tmp/start-sqlserver.sh && \
    echo 'SQL_PID=$!' >> /tmp/start-sqlserver.sh && \
    echo 'echo "SQL Server started with PID: $SQL_PID"' >> /tmp/start-sqlserver.sh && \
    echo '' >> /tmp/start-sqlserver.sh && \
    echo '# Wait for SQL Server to be ready' >> /tmp/start-sqlserver.sh && \
    echo 'echo "Waiting for SQL Server to be ready..."' >> /tmp/start-sqlserver.sh && \
    echo 'for i in {1..30}; do' >> /tmp/start-sqlserver.sh && \
    echo '  if /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "Lxh991130@sql" -Q "SELECT 1" > /dev/null 2>&1; then' >> /tmp/start-sqlserver.sh && \
    echo '    echo "SQL Server is ready!"' >> /tmp/start-sqlserver.sh && \
    echo '    break' >> /tmp/start-sqlserver.sh && \
    echo '  fi' >> /tmp/start-sqlserver.sh && \
    echo '  echo "Waiting for SQL Server... ($i/30)"' >> /tmp/start-sqlserver.sh && \
    echo '  sleep 2' >> /tmp/start-sqlserver.sh && \
    echo 'done' >> /tmp/start-sqlserver.sh && \
    echo '' >> /tmp/start-sqlserver.sh && \
    echo '# Create the custom user' >> /tmp/start-sqlserver.sh && \
    echo 'echo "Creating custom user lxh..."' >> /tmp/start-sqlserver.sh && \
    echo '/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "Lxh991130@sql" -i /tmp/create-user.sql' >> /tmp/start-sqlserver.sh && \
    echo 'echo "Custom user lxh created successfully!"' >> /tmp/start-sqlserver.sh && \
    echo '' >> /tmp/start-sqlserver.sh && \
    echo '# Test Chinese character support' >> /tmp/start-sqlserver.sh && \
    echo 'echo "Testing Chinese character support..."' >> /tmp/start-sqlserver.sh && \
    echo '/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "Lxh991130@sql" -i /tmp/test-chinese.sql' >> /tmp/start-sqlserver.sh && \
    echo 'echo "Chinese character test completed!"' >> /tmp/start-sqlserver.sh && \
    echo '' >> /tmp/start-sqlserver.sh && \
    echo '# Keep the container running' >> /tmp/start-sqlserver.sh && \
    echo 'wait $SQL_PID' >> /tmp/start-sqlserver.sh && \
    chmod +x /tmp/start-sqlserver.sh

# Copy the scripts to the proper location with correct permissions
USER root
RUN mkdir -p /usr/src/app && \
    cp /tmp/start-sqlserver.sh /usr/src/app/start-sqlserver.sh && \
    cp /tmp/create-user.sql /usr/src/app/create-user.sql && \
    cp /tmp/test-chinese.sql /usr/src/app/test-chinese.sql && \
    chown -R 10001:0 /usr/src/app && \
    chmod +x /usr/src/app/start-sqlserver.sh

# Switch back to mssql user (UID 10001)
USER 10001

# Expose SQL Server port
EXPOSE 1433

# Run the startup script
CMD ["/usr/src/app/start-sqlserver.sh"]
