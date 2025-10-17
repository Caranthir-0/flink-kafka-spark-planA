-- 1) Source: MySQL CDC table reading MariaDB sales_records
CREATE TABLE sales_records_src (
  sale_id INT PRIMARY KEY NOT ENFORCED,
  product_id INT,
  product_name STRING,
  sale_date TIMESTAMP(3),
  sale_amount DECIMAL(10,2),
  WATERMARK FOR sale_date AS sale_date - INTERVAL '5' SECOND
) WITH (
  'connector' = 'mysql-cdc',
  'hostname' = 'mariadb',
  'port' = '3306',
  'username' = 'root',
  'password' = 'rootpassword',
  'database-name' = 'sales_database',
  'table-name' = 'sales_records',
  'server-time-zone' = 'UTC'
);

-- 2) Sink: Kafka upsert topic carrying CDC (keyed by sale_id)
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

-- 3) Pipe CDC stream to Kafka
INSERT INTO kafka_sales_cdc
SELECT * FROM sales_records_src;
