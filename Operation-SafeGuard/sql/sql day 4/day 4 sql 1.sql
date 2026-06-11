SELECT COUNT(*) AS total_transactions
FROM transactions_clean;
SELECT COUNT(*) AS missing_amount
FROM transactions_clean
WHERE amount IS NULL;
SELECT COUNT(*) AS missing_sender
FROM transactions_clean
WHERE nameOrig IS NULL;
SELECT COUNT(*) AS missing_receiver
FROM transactions_clean
WHERE nameDest IS NULL;
SELECT COUNT(*) AS fraud_transactions
FROM transactions_clean
WHERE isFraud = 1;
SELECT
    ROUND(
        100.0 * SUM(isFraud) / COUNT(*),
        4
    ) AS fraud_percentage
FROM transactions_clean;
SELECT COUNT(*) AS duplicate_records
FROM (
    SELECT
        step,
        nameOrig,
        nameDest,
        amount,
        COUNT(*)
    FROM transactions_clean
    GROUP BY
        step,
        nameOrig,
        nameDest,
        amount
    HAVING COUNT(*) > 1
) d;
SELECT
    type,
    COUNT(*) AS total_transactions
FROM transactions_clean
GROUP BY type
ORDER BY total_transactions DESC;