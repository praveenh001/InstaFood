#!/bin/bash

# Ensure directory for sockets exists and permissions are correct
mkdir -p /var/run/mysqld
chown -R mysql:mysql /var/run/mysqld /var/lib/mysql

# Initialize MySQL data directory if not already done
if [ ! -d "/var/lib/mysql/mysql" ]; then
  echo "Initializing MySQL database..."
  /usr/sbin/mysqld --initialize-insecure --user=mysql
fi

# Start MySQL daemon directly in the background with LOW MEMORY settings
echo "Starting MySQL daemon (low memory mode)..."
/usr/sbin/mysqld --user=mysql \
  --key-buffer-size=16M \
  --max-connections=10 \
  --innodb-buffer-pool-size=16M \
  --innodb-log-buffer-size=1M \
  --performance-schema=OFF &

# Wait for MySQL to be ready
until mysqladmin -u root ping >/dev/null 2>&1; do
  echo "Waiting for MySQL daemon to start..."
  sleep 1
done

# Initialize database and import schema
echo "Initializing instafoods database..."
mysql -e "CREATE DATABASE IF NOT EXISTS instafoods;"
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'newpassword123'; FLUSH PRIVILEGES;"
mysql -u root -p'newpassword123' instafoods < /app/schema.sql

# Set Tomcat Java environment options for low memory limits
export CATALINA_OPTS="-Xms64M -Xmx192M -XX:+UseSerialGC"

# Start Tomcat in the foreground
echo "Starting Apache Tomcat..."
/opt/tomcat/bin/catalina.sh run
