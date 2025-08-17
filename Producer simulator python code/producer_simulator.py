# producer_simulator.py
import json
import time
from datetime import datetime
import pytz
from random import uniform, randint
from kafka import KafkaProducer

# ⏰ INDIAN TIMEZONE
india_tz = pytz.timezone('Asia/Kolkata')

# ⚙️ KAFKA PRODUCER CONFIG
producer = KafkaProducer(
    bootstrap_servers=['<YOUR_EC2_PUBLIC_IP>:9092'],  # Replace with your EC2 IP
    value_serializer=lambda v: json.dumps(v, default=str).encode('utf-8')
)

TOPIC_NAME = 'stock-data-stream'

# 🧪 120 SYMBOLS SIMULATION
symbols = [f'SYM{i:03d}' for i in range(1, 121)]  # SYM001 to SYM120

# 🔁 LOOP FOR STREAMING
while True:
    current_time = datetime.now(india_tz).strftime('%Y-%m-%d %H:%M:%S')

    for symbol in symbols:
        close = round(uniform(100, 1500), 2)
        volume = randint(1000, 10000)

        stock_record = {
            "symbol": symbol,
            "Date-Time": current_time,
            "Close": close,
            "Volume": volume
        }

        # 🎯 SEND RECORD
        producer.send(TOPIC_NAME, value=stock_record)

    producer.flush()  # ✅ Ensures all messages are delivered in real time
    print(f"[{current_time}] ✅ Sent batch of {len(symbols)} records.")
    time.sleep(30)
