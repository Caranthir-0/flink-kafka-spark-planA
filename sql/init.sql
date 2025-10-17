CREATE DATABASE IF NOT EXISTS sales_database;
USE sales_database;

CREATE TABLE IF NOT EXISTS sales_records (
  sale_id INT PRIMARY KEY,
  product_id INT,
  product_name VARCHAR(255),
  sale_date DATETIME(3),
  sale_amount DECIMAL(10,2)
);

CREATE TABLE IF NOT EXISTS flink_analytics (
  metric_name VARCHAR(64),
  metric_value DECIMAL(18,2),
  calculated_at DATETIME(3)
);

CREATE TABLE IF NOT EXISTS spark_analytics (
  metric_name VARCHAR(64),
  metric_value DECIMAL(18,2),
  calculated_at DATETIME(3)
);

INSERT INTO sales_records (sale_id, product_id, product_name, sale_date, sale_amount) VALUES
(1, 101, 'Product A', NOW(), 100.00),
(2, 102, 'Product B', NOW(), 200.00),
(3, 103, 'Product C', NOW(), 300.00);
