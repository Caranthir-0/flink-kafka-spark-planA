FROM python:3.11-slim
RUN pip install pymysql faker
WORKDIR /app
COPY generator.py /app/generator.py
CMD ["python", "generator.py"]
