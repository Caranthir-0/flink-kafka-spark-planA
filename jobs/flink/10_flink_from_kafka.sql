-- Read CDC back from Kafka and compute metrics
CREATE TABLE kafka_sales_cdc (
  sale_id INT,
  product_id INT,
  product_name STRING,
  sale_date TIMESTAMP(3),
  sale_amount DECIMAL(10,2),
  PRIMARY KEY (sale_id) NOT ENFORCED
) WITH (
  'connector' = 'upsert-kafka',
  'topic' = 'sales.cdc',
  'properties.bootstrap.servers' = 'kafka:9092',
  'key.format' = 'json',
  'value.format' = 'json'
);

-- Simple rolling metric: total sales (append updates)
CREATE TEMPORARY VIEW totals AS
SELECT SUM(sale_amount) AS total_sales
FROM kafka_sales_cdc;

-- JDBC sink table
CREATE TABLE mariadb_flink_analytics (
  metric_name STRING,
  metric_value DECIMAL(18,2),
  calculated_at TIMESTAMP(3)
) WITH (
  'connector' = 'jdbc',
  'url' = 'jdbc:mariadb://mariadb:3306/sales_database',
  'table-name' = 'flink_analytics',
  'username' = 'root',
  'password' = 'rootpassword'
);

INSERT INTO mariadb_flink_analytics
SELECT 'total_sales' AS metric_name,
       total_sales AS metric_value,
       CURRENT_TIMESTAMP AS calculated_at
FROM totals;
