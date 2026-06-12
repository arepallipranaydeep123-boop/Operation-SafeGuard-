--Fraud Transactions by Hour
SELECT
    step,
    COUNT(*) AS fraud_count
FROM transactions_clean
WHERE isFraud = 1
GROUP BY step
ORDER BY fraud_count DESC;


--Top 10 Fraud Hours
SELECT
    step,
    COUNT(*) AS fraud_count
FROM transactions_clean
WHERE isFraud = 1
GROUP BY step
ORDER BY fraud_count DESC
LIMIT 10;


--Total Transaction Volume by Hour
SELECT
    step,
    COUNT(*) AS total_transactions
FROM transactions_clean
GROUP BY step
ORDER BY step;


--Fraud Rate Per Hour
SELECT
    step,
    COUNT(*) AS total_transactions,
    SUM(isFraud) AS fraud_transactions,
    ROUND(
        100.0 * SUM(isFraud) / COUNT(*),
        4
    ) AS fraud_rate
FROM transactions_clean
GROUP BY step
ORDER BY fraud_rate DESC;


--Create Peak Fraud View
CREATE OR REPLACE VIEW peak_fraud_hours AS
SELECT
    step,
    COUNT(*) AS fraud_count
FROM transactions_clean
WHERE isFraud = 1
GROUP BY step;


--Verify View
SELECT *
FROM peak_fraud_hours
ORDER BY fraud_count DESC;


--High Value Corridor Filtering
SELECT
    PERCENTILE_CONT(0.95)
    WITHIN GROUP (
        ORDER BY amount
    ) AS p95_amount
FROM transactions_clean;


--Find Transactions Above P95
WITH threshold AS
(
    SELECT
        PERCENTILE_CONT(0.95)
        WITHIN GROUP (
            ORDER BY amount
        ) AS p95
    FROM transactions_clean
)

SELECT *
FROM transactions_clean t
CROSS JOIN threshold th
WHERE t.amount > th.p95;


--Count High Value Transactions
WITH threshold AS
(
    SELECT
        PERCENTILE_CONT(0.95)
        WITHIN GROUP (
            ORDER BY amount
        ) AS p95
    FROM transactions_clean
)

SELECT
    COUNT(*) AS high_value_transactions
FROM transactions_clean t
CROSS JOIN threshold th
WHERE t.amount > th.p95;


--High Value Fraud Count
WITH threshold AS
(
    SELECT
        PERCENTILE_CONT(0.95)
        WITHIN GROUP (
            ORDER BY amount
        ) AS p95
    FROM transactions_clean
)

SELECT
    COUNT(*) AS high_value_fraud_cases
FROM transactions_clean t
CROSS JOIN threshold th
WHERE t.amount > th.p95
AND isFraud = 1;


--Calculate Value at Risk (VaR)
WITH threshold AS
(
    SELECT
        PERCENTILE_CONT(0.95)
        WITHIN GROUP (
            ORDER BY amount
        ) AS p95
    FROM transactions_clean
)

SELECT
    ROUND(
        SUM(amount),
        2
    ) AS value_at_risk
FROM transactions_clean t
CROSS JOIN threshold th
WHERE amount > th.p95
AND isFraud = 1;


--Highest Fraud Transactions
SELECT
    amount,
    type,
    merchant_category,
    step
FROM transactions_clean
WHERE isFraud = 1
ORDER BY amount DESC
LIMIT 20;


--Create High Value View
CREATE OR REPLACE VIEW high_value_transactions AS
WITH threshold AS
(
    SELECT
        PERCENTILE_CONT(0.95)
        WITHIN GROUP (
            ORDER BY amount
        ) AS p95
    FROM transactions_clean
)
SELECT *
FROM transactions_clean t
CROSS JOIN threshold th
WHERE amount > th.p95;


--Verify View
SELECT COUNT(*)
FROM high_value_transactions;

