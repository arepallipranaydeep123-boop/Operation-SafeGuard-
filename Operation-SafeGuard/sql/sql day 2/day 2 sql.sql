--verify import
SELECT COUNT(*)
FROM transactions;
--sample data view
SELECT *
FROM transactions
LIMIT 10;
--Explore Transaction Types
SELECT DISTINCT type
FROM transactions;
--Count Each Transaction Type
SELECT
type,
COUNT(*) AS total_transactions
FROM transactions
GROUP BY type
ORDER BY total_transactions DESC;
--Check Fraud Distribution
SELECT
isFraud,
COUNT(*) AS total
FROM transactions
GROUP BY isFraud;
--Calculate fraud percentage:
SELECT
ROUND(
100.0 * SUM(isFraud) / COUNT(*),
4
) AS fraud_percentage
FROM transactions;
--Inspect Amount Values
SELECT
MIN(amount),
MAX(amount),
AVG(amount)
FROM transactions;