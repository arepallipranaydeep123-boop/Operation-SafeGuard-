--Test the View
SELECT *
FROM fraud_category_ranking;

--Fraud Cases by Transaction Type
SELECT
    type,
    COUNT(*) AS fraud_cases
FROM transactions_clean
WHERE isFraud = 1
GROUP BY type
ORDER BY fraud_cases DESC;

--Fraud Percentage by Type
--Which transaction type is most dangerous?
SELECT
    type,
    COUNT(*) AS total_transactions,
    SUM(isFraud) AS fraud_transactions,
    ROUND(
        100.0 * SUM(isFraud) / COUNT(*),
        4
    ) AS fraud_rate
FROM transactions_clean
GROUP BY type
ORDER BY fraud_rate DESC;

--Highest Fraud Transaction
SELECT *
FROM transactions_clean
WHERE isFraud = 1
ORDER BY amount DESC
LIMIT 10;

--Total Fraud Loss
SELECT
    ROUND(
        SUM(amount),
        2
    ) AS total_fraud_loss
FROM transactions_clean
WHERE isFraud = 1;