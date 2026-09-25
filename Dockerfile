FROM ubuntu:22.04

# Avoid prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies: JDK 21, MySQL Server, wget, curl
RUN apt-get update && apt-get install -y \
    openjdk-21-jdk \
    mysql-server \
    wget \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Download and install Apache Tomcat 10.1.34
RUN wget https://archive.apache.org/dist/tomcat/tomcat-10/v10.1.34/bin/apache-tomcat-10.1.34.tar.gz -O /tmp/tomcat.tar.gz \
    && mkdir /opt/tomcat \
    && tar -xf /tmp/tomcat.tar.gz -C /opt/tomcat --strip-components=1 \
    && rm /tmp/tomcat.tar.gz

# Disable Tomcat shutdown port to prevent cloud health checkers from sending requests to it
RUN sed -i 's/<Server port="8005" shutdown="SHUTDOWN">/<Server port="-1" shutdown="SHUTDOWN">/g' /opt/tomcat/conf/server.xml

# Remove default Tomcat apps
RUN rm -rf /opt/tomcat/webapps/*

# Set up app directory
WORKDIR /app

# Copy all source code and static webapp files to the container
COPY src /app/src
COPY schema.sql /app/schema.sql
COPY entrypoint.sh /app/entrypoint.sh

# Set up Tomcat deployment ROOT and copy public webapp assets
RUN mkdir -p /opt/tomcat/webapps/ROOT
RUN cp -R /app/src/main/webapp/* /opt/tomcat/webapps/ROOT/

# Compile Java source code directly inside the container
RUN mkdir -p /opt/tomcat/webapps/ROOT/WEB-INF/classes
RUN javac -d /opt/tomcat/webapps/ROOT/WEB-INF/classes \
    -cp "/opt/tomcat/lib/*:/opt/tomcat/webapps/ROOT/WEB-INF/lib/*" \
    /app/src/main/java/com/instafoo/connection/*.java \
    /app/src/main/java/com/instafoo/Model/*.java \
    /app/src/main/java/com/instafoo/dao/*.java \
    /app/src/main/java/com/instafoo/daoImp/*.java \
    /app/src/main/java/com/instafoo/servlets/*.java

# Give execution permissions to the script
RUN chmod +x /app/entrypoint.sh

# Expose Tomcat port
EXPOSE 8080

# Run entrypoint script
CMD ["/app/entrypoint.sh"]
