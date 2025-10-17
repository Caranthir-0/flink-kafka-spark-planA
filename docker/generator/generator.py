import os, time, random
import pymysql
from faker import Faker

host = os.getenv("DB_HOST", "mariadb")
user = os.getenv("DB_USER", "root")
password = os.getenv("DB_PASSWORD", "rootpassword")
db = os.getenv("DB_NAME", "sales_database")
rate = int(os.getenv("RATE_PER_SEC", "10"))

conn = None
while conn is None:
    try:
        conn = pymysql.connect(host=host, user=user, password=password, database=db, autocommit=True)
    except Exception as e:
        print("Waiting for DB...", e)
        time.sleep(2)

fk = Faker()
cursor = conn.cursor()

sale_id = 1000
while True:
    for _ in range(rate):
        sale_id += 1
        product_id = random.randint(1, 50)
        name = fk.word().title()
        amount = round(random.uniform(5.0, 200.0), 2)
        cursor.execute(
            "INSERT INTO sales_records (sale_id, product_id, product_name, sale_date, sale_amount) VALUES (%s,%s,%s,NOW(),%s)",
            (sale_id, product_id, name, amount)
        )
    time.sleep(1)
