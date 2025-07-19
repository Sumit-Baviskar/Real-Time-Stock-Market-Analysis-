
WITH sma_calculated AS (
    SELECT
        "Date-Time",
        "symbol",
        "Close",
        "Volume",

        -- Calculate 9-period Simple Moving Average (SMA)
        AVG("Close") OVER (
            PARTITION BY "symbol"
            ORDER BY "Date-Time"
            ROWS BETWEEN 8 PRECEDING AND CURRENT ROW
        ) AS sma_9,

        -- Calculate 21-period Simple Moving Average (SMA)
        AVG("Close") OVER (
            PARTITION BY "symbol"
            ORDER BY "Date-Time"
            ROWS BETWEEN 20 PRECEDING AND CURRENT ROW
        ) AS sma_21,

        -- Previous volume to compare for signal
        LAG("Volume", 1) OVER (
            PARTITION BY "symbol"
            ORDER BY "Date-Time"
        ) AS prev_volume

    FROM your_table_name
)

SELECT
    "Date-Time",
    "symbol",
    "Close",
    "Volume",
    ROUND(sma_9, 2) AS sma_9,
    ROUND(sma_21, 2) AS sma_21,

    -- Signal Logic
    CASE
        WHEN sma_9 > sma_21 AND "Volume" > prev_volume THEN 'Buy'
        WHEN sma_9 < sma_21 AND "Volume" > prev_volume THEN 'Sell'
        ELSE 'Hold'
    END AS signal

FROM sma_calculated

-- Show latest signals first
ORDER BY
    "symbol", "Date-Time" DESC;
