import os
from pyspark.sql import SparkSession
from pyspark.sql.functions import col, from_json, sum as _sum
from pyspark.sql.types import StructType, StructField, IntegerType, StringType, TimestampType, DecimalType

bootstrap = os.getenv("KAFKA_BOOTSTRAP", "kafka:9092")
topic = os.getenv("KAFKA_TOPIC", "sales.cdc")

# JDBC config
jdbc_url = "jdbc:mariadb://mariadb:3306/sales_database"
jdbc_props = {
    "user": "root",
    "password": "rootpassword",
    "driver": "org.mariadb.jdbc.Driver"
}

spark = (
    SparkSession.builder
        .appName("spark_cdc_analytics")
        .getOrCreate()
)

# Read upsert-kafka JSON payloads (value holds the row, key holds sale_id)
schema = StructType([
    StructField("sale_id", IntegerType()),
    StructField("product_id", IntegerType()),
    StructField("product_name", StringType()),
    StructField("sale_date", TimestampType()),
    StructField("sale_amount", DecimalType(10, 2))
])

raw = (
    spark.readStream
        .format("kafka")
        .option("kafka.bootstrap.servers", bootstrap)
        .option("subscribe", topic)
        .option("startingOffsets", "earliest")
        .load()
)

# upsert-kafka writes key & value as JSON strings
parsed = raw.select(
    from_json(col("value").cast("string"), schema).alias("v")
).select("v.*")

agg = parsed.agg(_sum(col("sale_amount")).alias("total_sales"))

# Use foreachBatch to upsert into MariaDB periodically

def write_batch(df, batch_id):
    (df.withColumn("metric_name", col("total_sales").isNotNull().cast("string"))
       .selectExpr("'total_sales' as metric_name", "cast(total_sales as decimal(18,2)) as metric_value")
       .withColumn("calculated_at", col("metric_value").cast("timestamp"))
    )
    df.selectExpr("'total_sales' as metric_name",
                  "cast(total_sales as decimal(18,2)) as metric_value",
                  "current_timestamp() as calculated_at") \
      .write \
      .mode("append") \
      .jdbc(url=jdbc_url, table="spark_analytics", properties=jdbc_props)

query = (
    agg.writeStream
       .outputMode("complete")
       .foreachBatch(write_batch)
       .option("checkpointLocation", "/data/spark-checkpoints/sales_cdc")
       .start()
)

query.awaitTermination()
