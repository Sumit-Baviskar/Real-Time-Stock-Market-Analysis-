# **Real Time Stock Market Analysis :**

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






    

