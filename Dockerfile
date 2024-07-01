FROM confluentinc/cp-server-connect:7.6.0
USER root

# Install unzip using yum
RUN yum install -y unzip wget tar

# Downloading Debezium postgres Connector
RUN echo "Downloading Debezium postgres Connector..." && \
    wget -O debezium-connector-postgres-plugin.tar.gz https://repo1.maven.org/maven2/io/debezium/debezium-connector-postgres/2.5.0.Final/debezium-connector-postgres-2.5.0.Final-plugin.tar.gz && \
    wget -O debezium-scripting.tar.gz https://repo1.maven.org/maven2/io/debezium/debezium-scripting/2.5.0.Final/debezium-scripting-2.5.0.Final.tar.gz


# Downloading Groovy SDK
RUN echo "Downloading Groovy SDK ..." && \
    wget https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-sdk-4.0.17.zip -P /tmp/groovy/

# Extracting the archives
RUN echo "Extracting the archive..." && \
    tar -xzvf debezium-connector-postgres-plugin.tar.gz -C /usr/share/java/ && \
    tar -xzvf debezium-scripting.tar.gz -C /usr/share/java/debezium-connector-postgres/ --strip-components=1 && \
    unzip /tmp/groovy/apache-groovy-sdk-4.0.17.zip */*/groovy-4.0.17.jar */*/groovy-jsr223-4.0.17.jar */*/groovy-json-4.0.17.jar -d /tmp/groovy/

# Copying the archives
RUN echo "Copying the archives..." && \
    cp /tmp/groovy/*/*/*.jar /usr/share/java/debezium-connector-postgres/

# Copying TimestampConverter JAR
ADD ./TimestampConverter.jar /usr/share/java/debezium-connector-postgres/

# Copying Optional JAR
ADD ./OptionalConverter.jar /usr/share/java/debezium-connector-postgres/

# Copying GoldenGateSMT JAR
ADD ./GoldenGateSMT.jar /usr/share/java/

# Ensure correct permissions
RUN chmod -R 755 /usr/share/java/

# Ensure correct permissions
RUN chmod -R 755 /usr/share/java/debezium-connector-postgres

# Verify the files in the Debezium connector directory
RUN ls -l /usr/share/java/debezium-connector-postgres/

USER 1001