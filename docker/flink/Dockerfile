FROM flink:1.19.1

# Add connectors (Kafka, JDBC, MySQL-CDC)
# These URLs are version-aligned with Flink 1.19.x; adjust if needed.
# They are downloaded at build-time on your machine.
RUN set -eux; \
    cd /opt/flink/lib; \
    curl -fSLo flink-connector-kafka.jar \
      https://repo1.maven.org/maven2/org/apache/flink/flink-connector-kafka/3.2.0-1.19/flink-connector-kafka-3.2.0-1.19.jar; \
    curl -fSLo flink-connector-jdbc.jar \
      https://repo1.maven.org/maven2/org/apache/flink/flink-connector-jdbc/3.2.0-1.19/flink-connector-jdbc-3.2.0-1.19.jar; \
    curl -fSLo mysql-cdc.jar \
      https://repo1.maven.org/maven2/com/ververica/flink-connector-mysql-cdc/3.1.1/flink-connector-mysql-cdc-3.1.1.jar

# (Optional) Add mariadb JDBC driver if needed by JDBC sink
RUN curl -fSLo /opt/flink/lib/mariadb-java-client.jar \
      https://repo1.maven.org/maven2/org/mariadb/jdbc/mariadb-java-client/3.4.1/mariadb-java-client-3.4.1.jar
