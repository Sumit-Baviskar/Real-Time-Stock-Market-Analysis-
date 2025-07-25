#  🚀📈**Real Time Stock Market Analysis and Signal System**

## **Introduction :**

This project simulates real-time stock data and performs live analysis to generate buy/sell/hold signals. It uses a Python-based simulator, Kafka for streaming, AWS S3 for storage, AWS Glue for cataloging, and AWS Athena for querying.

The signals are based on SMA(9), SMA(21) crossovers and volume comparison logic — commonly used techniques in technical trading strategies.


## **💥 Problem Statement :**
Many traders and analysts struggle to make fast, data-driven decisions in the stock market due to the massive volume of real-time data coming in every second. Traditional systems either process data in batches or lack proper signal generation logic, making them slow and reactive rather than proactive.

**This project addresses that problem by building an end-to-end real-time stock analysis pipeline that :**

 - **Simulates live stock data.**

 - **Processes data in real-time.**

 - **Calculates technical indicators (SMA 9, SMA 21) and volume trends.**

 - **Generates immediate buy, sell, or hold signals.**

 - **Enables fast and flexible querying using serverless tools.**

 ## **⚙️ Architecture :**

 ![Image](https://github.com/user-attachments/assets/1e189968-1de6-446c-bee6-e10f3d8a5e64)

  - **Python simulator :** Generates stock price, volume, and timestamp.

  - **Kafka :** Streams data in real time.

  - **S3 :** Stores raw data as a data lake.

  - **AWS Glue :** Crawls and catalogs the data.

  - **Athena :** Runs SQL queries to generate signals.

## **🚩 Features :**

  - **Real-time data simulation and ingestion.**


  - **SMA(9) and SMA(21) crossover detection.**


  - **Volume comparison for stronger signal confirmation.**


  - **Fully serverless querying with Athena.**

## **🧰 Tech Stack :**
  
###  **💻 Programming & Data Streaming :**

   - **Python :** For data simulation and signal logic.

   - **Kafka :** For real-time data streaming.


 ### **☁️ Cloud & Storage :**

   - **AWS S3 :** Data lake to store raw stock data.

   - **AWS Glue :** Schema discovery and data cataloging.

   - **AWS Athena :** Serverless SQL-based analysis on top of S3.


  ### **📦 Libraries & Tools :**

   - **kafka-python :** Kafka producer and consumer.

   - **boto3 :** AWS service integration.

   - **Pandas :** Data processing and basic calculations.

   - **SQL :** For final analysis in Athena.




## **⚙️ How It Works :**

### 🧰 **Step 1: Install Java (Kafka Dependency)**
    
   - Kafka requires Java to run. Install it using:

    sudo apt update
    sudo apt install default-jdk -y
    java -version


### 📦 **Step 2: Download & Extract Kafka**

    wget https://downloads.apache.org/kafka/3.6.0/kafka_2.13-3.6.0.tgz
    tar -xzf kafka_2.13-3.6.0.tgz
    cd kafka_2.13-3.6.0



### ⚙️ **Step 3: Start Zookeeper**

- Kafka needs Zookeeper to manage its brokers. You can start it in the foreground (for debugging) or background.

  
       bin/zookeeper-server-start.sh config/zookeeper.properties



### 🧠 **Step 4: Start Kafka Broker**


- Start Kafka after Zookeeper is running:

      bin/kafka-server-start.sh config/server.properties

 
### 🔐 **Step 5: Configure EC2 Security Group**


In your AWS Console:

  - Navigate to Security Groups attached to your EC2

  - Add Inbound Rules for the following:

     - Port 22 (SSH)

     - Port 9092 (Kafka)

     - Port 2181 (Zookeeper)

This allows external tools or machines (like your local machine or S3) to communicate with Kafka.


### 🧪 **Step 6: Create Kafka Topic**

     bin/kafka-topics.sh --create \
    --topic stock-data-stream \
    --bootstrap-server localhost:9092 \
    --partitions 1 \
    --replication-factor 1

### 🐍 **Step 7: Python Environment Setup**


- Install required Python libraries:

      sudo apt install python3-pip -y
      pip install kafka-python boto3 pandas pytz

- Use an IAM Role with proper permissions if running inside the EC2 instance.


### 📤 **Step 8: Run Your Producer Script**

 - Your producer script simulates real-time stock market data every 30 seconds. Run it like:

 - Code Link Here [python3 producer_simulator.py](https://github.com/Sumit-Baviskar/Real-Time-Stock-Market-Analysis-/blob/main/producer_simulator.py)

 - If you’re using time.sleep(30), there’s NO NEED to use flush() forcibly unless you notice data is not being pushed in real-time.


### 📥 **Step 9: Run Consumer Script (Saves to S3)**

Your consumer script receives messages and writes them to a CSV or Parquet file, uploading them to S3:

 - Code Link Here [python3 consumer_to_s3.py](https://github.com/Sumit-Baviskar/Real-Time-Stock-Market-Analysis-/blob/main/kafka_consumer_to_s3.py)

 - **Ensure this script:**

   - Batches or collects messages

   - Writes to a file

   - Uploads to a defined S3 bucket



### 🔵 **Step 10: Catalog with AWS Glue :**

   - AWS Glue Crawler scans the S3 bucket and automatically detects schema.

   - It creates or updates a table in Glue Data Catalog, making data queryable.


### 🟣 **Step 11: Query with AWS Athena :**

   - Athena runs SQL queries on top of S3 via Glue Catalog.

  -  It calculates:

      - SMA 9 & SMA 21 using window functions.

      - Volume comparison logic for signal confirmation.

      - Generates Buy, Sell, or Hold signals based on SMA crossovers and volume spikes.

### **SQL Code in AWS Athena :**

    WITH sma_calculated AS (
        SELECT
            parse_datetime("Date-Time", 'yyyy-MM-dd HH:mm:ss') AS ts,
            "symbol",
            "Close",
            "Volume",

            -- Calculate 9-period SMA
            AVG("Close") OVER (
                PARTITION BY "symbol"
                ORDER BY parse_datetime("Date-Time", 'yyyy-MM-dd HH:mm:ss')
                ROWS BETWEEN 8 PRECEDING AND CURRENT ROW
            ) AS sma_9,

            -- 21-period SMA
            AVG("Close") OVER (
                PARTITION BY "symbol"
                ORDER BY parse_datetime("Date-Time", 'yyyy-MM-dd HH:mm:ss')
                ROWS BETWEEN 20 PRECEDING AND CURRENT ROW
            ) AS sma_21,

            -- Previous Volume
            LAG("Volume", 1) OVER (
                PARTITION BY "symbol"
                ORDER BY parse_datetime("Date-Time", 'yyyy-MM-dd HH:mm:ss')
            ) AS prev_volume
    
        FROM your_table_name
    )

    SELECT
        ts AS "Date-Time",
        "symbol",
        "Close",
        "Volume",
        ROUND(sma_9, 2) AS sma_9,
        ROUND(sma_21, 2) AS sma_21,
        CASE
            WHEN sma_9 > sma_21 AND "Volume" > prev_volume THEN 'Buy'
            WHEN sma_9 < sma_21 AND "Volume" > prev_volume THEN 'Sell'
            ELSE 'Hold'
        END AS signal

    FROM sma_calculated
    ORDER BY
        "symbol", ts DESC;


  ### - [Output Athena Download CSV file](https://github.com/Sumit-Baviskar/Real-Time-Stock-Market-Analysis-/blob/main/ATHENA%20stock_signal_output%20.csv) 

## 👨‍💻 **Author**

### **Sumit Baviskar**  

   🔗 [LinkedIn](https://www.linkedin.com/in/sumit-baviskar/)  

   🔗 [Portfolio](https://nice-web-16a.notion.site/Hello-I-m-Sumit-Baviskar-18e7130b12678024b30fc011c22427b7)

   🔗 [GitHub](https://github.com/Sumit-Baviskar)

   📧 [Gmail](https://mail.google.com/mail/?view=cm&to=st.baviskar43@gmail.com)




    

