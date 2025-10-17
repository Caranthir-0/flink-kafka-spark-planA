# Plan A: CDC → Kafka Fan-Out (Flink & Spark)

## Quickstart
```bash
# 0) Prereqs: Docker & Compose installed
# 1) Start services
chmod +x scripts/run_benchmark.sh
./scripts/run_benchmark.sh

# Flink UI: http://localhost:8081
# Spark Master UI: http://localhost:8080
# Kafka broker: localhost:9092
```

## Manual commands
```bash
docker compose up -d --build

# Submit Flink jobs
docker exec jobmanager /opt/flink/bin/sql-client.sh -f /opt/jobs/flink/00_cdc_to_kafka.sql
docker exec jobmanager /opt/flink/bin/sql-client.sh -f /opt/jobs/flink/10_flink_from_kafka.sql

# Spark job
docker exec spark-master /opt/bitnami/spark/bin/spark-submit \
  --master spark://spark-master:7077 \
  --packages org.apache.spark:spark-sql-kafka-0-10_2.12:3.5.1,org.mariadb.jdbc:mariadb-java-client:3.4.1 \
  /opt/jobs/spark/structured_streaming_app.py
```
