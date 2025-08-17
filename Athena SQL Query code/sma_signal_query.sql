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
