--Check Total Transactions
SELECT COUNT(*)
FROM transactions;

--Check Missing Amount Values
SELECT COUNT(*)
FROM transactions
WHERE amount IS NULL;

--Check Fraud Transactions
SELECT COUNT(*)
FROM transactions
WHERE isFraud = 1;

--Check Fraud Merchant Ranking
SELECT *
FROM fraud_category_ranking
LIMIT 10;

--Check Peak Fraud Hours
SELECT *
FROM high_value_transactions
LIMIT 10;
--fraud percentage
SELECT 
    ROUND(
        (SUM(CASE WHEN isFraud = 1 THEN 1 ELSE 0 END)::NUMERIC
        / COUNT(*)) * 100,
        4
    ) AS fraud_percentage
FROM transactions;
