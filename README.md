#  🚀📈**Real Time Stock Market Analysis**

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

  🟢 **Step 1 : Simulate Real-Time Stock Data :**
   - A Python script continuously generates mock stock data (symbol, price, volume, timestamp).

   - Every second, new stock records are created to simulate a live feed.

🟠 **Step 2: Stream Data to Kafka :**

   - The simulator sends data to a Kafka topic called stock-topic.

   - Kafka acts as a real-time message broker, buffering and distributing data efficiently.

🟡 **Step 3: Push Data to AWS S3 :**

   - A Kafka consumer (or Kafka Connect sink) writes streaming data into S3 as JSON files.

   - Data is stored in a structured path (e.g., s3://your-bucket/stock_data/YYYY/MM/DD/).

🔵 **Step 4: Catalog with AWS Glue :**

   - AWS Glue Crawler scans the S3 bucket and automatically detects schema.

   - It creates or updates a table in Glue Data Catalog, making data queryable.

🟣 **Step 5: Query with AWS Athena :**

   - Athena runs SQL queries on top of S3 via Glue Catalog.

   It calculates:

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



## 👨‍💻 **Author**

### **Sumit Baviskar**  

   🔗 [LinkedIn](https://www.linkedin.com/in/sumit-baviskar/)  

   🔗 [Portfolio](https://nice-web-16a.notion.site/Hello-I-m-Sumit-Baviskar-18e7130b12678024b30fc011c22427b7)

   🔗 [GitHub](https://github.com/Sumit-Baviskar)

   📧 [Gmail](https://mail.google.com/mail/?view=cm&to=st.baviskar43@gmail.com)




    

