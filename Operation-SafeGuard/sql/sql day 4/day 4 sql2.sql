--Verify Fraud Records
SELECT COUNT(*)
FROM transactions_clean
WHERE isFraud = 1;

--View Fraud Transactions
SELECT *
FROM transactions_clean
WHERE isFraud = 1
LIMIT 10;

--Fraud Count by Merchant Category
--Which category experiences the most fraud cases?
SELECT
    merchant_category,
    COUNT(*) AS fraud_cases
FROM transactions_clean
WHERE isFraud = 1
GROUP BY merchant_category
ORDER BY fraud_cases DESC;

--Fraud Amount by Merchant Category
--How much money was lost per category?
SELECT
    merchant_category,
    SUM(amount) AS fraud_volume
FROM transactions_clean
WHERE isFraud = 1
GROUP BY merchant_category
ORDER BY fraud_volume DESC;

--Use Window Function (RANK)
--Now create ranking
SELECT
    merchant_category,
    SUM(amount) AS fraud_volume,
    RANK() OVER(
        ORDER BY SUM(amount) DESC
    ) AS fraud_rank
FROM transactions_clean
WHERE isFraud = 1
GROUP BY merchant_category;

--Create Top 10 Fraud Ranking
WITH ranked_categories AS
(
    SELECT
        merchant_category,
        SUM(amount) AS fraud_volume,
        RANK() OVER(
            ORDER BY SUM(amount) DESC
        ) AS fraud_rank
    FROM transactions_clean
    WHERE isFraud = 1
    GROUP BY merchant_category
)

SELECT *
FROM ranked_categories
WHERE fraud_rank <= 10;

--Save Results as View
--Create a reusable view
CREATE VIEW fraud_category_ranking AS
SELECT
    merchant_category,
    SUM(amount) AS fraud_volume,
    RANK() OVER(
        ORDER BY SUM(amount) DESC
    ) AS fraud_rank
FROM transactions_clean
WHERE isFraud = 1
GROUP BY merchant_category;

