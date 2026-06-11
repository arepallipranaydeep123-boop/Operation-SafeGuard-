--Check Table Structure
SELECT column_name,
       data_type
FROM information_schema.columns
WHERE table_name='transactions_clean';

--Check Missing Values
SELECT COUNT(*) AS missing_amount
FROM transactions_clean
WHERE amount IS NULL;

--sender
SELECT COUNT(*) AS missing_sender
FROM transactions_clean
WHERE nameOrig IS NULL;

--Receiver
SELECT COUNT(*) AS missing_receiver
FROM transactions_clean
WHERE nameDest IS NULL;

--Fraud Flag
SELECT COUNT(*) AS missing_fraud
FROM transactions_clean
WHERE isFraud IS NULL;

--Check Invalid Amounts
SELECT COUNT(*)
FROM transactions_clean
WHERE amount <= 0;

--Minimum and Maximum Amount
SELECT
MIN(amount) AS min_amount,
MAX(amount) AS max_amount,
AVG(amount) AS avg_amount
FROM transactions_clean;

--Check Fraud Labels
SELECT
isFraud,
COUNT(*) AS total
FROM transactions_clean
GROUP BY isFraud;

-- Calculate Fraud Percentage
SELECT
    ROUND(
        100.0 * SUM(isFraud) / COUNT(*),
        4
    ) AS fraud_percentage
FROM transactions_clean;

--Check Transaction Types
SELECT
type,
COUNT(*) AS total_transactions
FROM transactions_clean
GROUP BY type
ORDER BY total_transactions DESC;

--Check Duplicate Transactions
SELECT
step,
nameOrig,
nameDest,
amount,
COUNT(*) AS duplicate_count
FROM transactions_clean
GROUP BY
step,
nameOrig,
nameDest,
amount
HAVING COUNT(*) > 1;


--Count duplicates:
SELECT COUNT(*)
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

--Create Merchant Category
ALTER TABLE transactions_clean
ADD COLUMN merchant_category VARCHAR(20);

SELECT COUNT(*) AS total_transactions
FROM transactions_clean;