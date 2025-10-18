FROM flink:1.19.1

# Ensure curl is available
USER root
RUN apt-get update && apt-get install -y curl ca-certificates && rm -rf /var/lib/apt/lists/*
USER flink

# ----- Connector versions aligned to Flink 1.19 -----
ARG FLINK_KAFKA_VER=3.2.0-1.19
ARG FLINK_JDBC_VER=3.2.0-1.19
# CDC connector moved to org.apache.flink and is named flink-sql-connector-mysql-cdc
ARG FLINK_CDC_SQL_VER=3.3.0

# Download connectors into /opt/flink/lib
RUN set -eux; \
  cd /opt/flink/lib; \
  # Kafka connector
  curl -fSLo flink-connector-kafka-${FLINK_KAFKA_VER}.jar \
    https://repo1.maven.org/maven2/org/apache/flink/flink-connector-kafka/${FLINK_KAFKA_VER}/flink-connector-kafka-${FLINK_KAFKA_VER}.jar; \
  ln -sf flink-connector-kafka-${FLINK_KAFKA_VER}.jar flink-connector-kafka.jar; \
  # JDBC connector
  curl -fSLo flink-connector-jdbc-${FLINK_JDBC_VER}.jar \
    https://repo1.maven.org/maven2/org/apache/flink/flink-connector-jdbc/${FLINK_JDBC_VER}/flink-connector-jdbc-${FLINK_JDBC_VER}.jar; \
  ln -sf flink-connector-jdbc-${FLINK_JDBC_VER}.jar flink-connector-jdbc.jar; \
  # MySQL CDC (new group/artifact)
  curl -fSLo flink-sql-connector-mysql-cdc-${FLINK_CDC_SQL_VER}.jar \
    https://repo1.maven.org/maven2/org/apache/flink/flink-sql-connector-mysql-cdc/${FLINK_CDC_SQL_VER}/flink-sql-connector-mysql-cdc-${FLINK_CDC_SQL_VER}.jar

# MariaDB JDBC driver for sinks
RUN set -eux; \
  curl -fSLo /opt/flink/lib/mariadb-java-client-3.4.1.jar \
    https://repo1.maven.org/maven2/org/mariadb/jdbc/mariadb-java-client/3.4.1/mariadb-java-client-3.4.1.jar; \
  ln -sf /opt/flink/lib/mariadb-java-client-3.4.1.jar /opt/flink/lib/mariadb-java-client.jar
