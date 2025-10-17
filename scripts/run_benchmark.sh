#!/usr/bin/env bash
set -euo pipefail

# 1) Start
docker compose up -d --build

# 2) Submit Flink jobs
sleep 5
docker exec jobmanager /opt/flink/bin/sql-client.sh -f /opt/jobs/flink/00_cdc_to_kafka.sql
sleep 2
docker exec jobmanager /opt/flink/bin/sql-client.sh -f /opt/jobs/flink/10_flink_from_kafka.sql

# 3) Start Spark job
docker exec spark-master /opt/bitnami/spark/bin/spark-submit \
  --master spark://spark-master:7077 \
  --packages org.apache.spark:spark-sql-kafka-0-10_2.12:3.5.1,org.mariadb.jdbc:mariadb-java-client:3.4.1 \
  /opt/jobs/spark/structured_streaming_app.py
