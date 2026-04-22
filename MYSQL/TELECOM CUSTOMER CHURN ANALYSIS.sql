-- ============================================================
-- PROJECT: TELECOM CUSTOMER CHURN ANALYSIS
-- TOOL: MYSQL
-- OBJECTIVE: Identify churn patterns & business insights
-- ============================================================

-- =========================
-- 1. CREATE DATABASE
-- =========================
CREATE DATABASE IF NOT EXISTS telecom_churn;
USE telecom_churn;

-- =========================
-- 2. DATA PREVIEW
-- =========================
-- View raw data
SELECT * FROM churn_data 
Limit 5;

-- Count total customers
SELECT COUNT(*) AS total_customers FROM churn_data;

-- =========================
-- 3. DATA EXPLORATION
-- =========================

-- Gender Distribution
SELECT 
    Gender,
    COUNT(*) AS total,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM churn_data),2) AS percentage
FROM churn_data
GROUP BY Gender;

-- Contract Distribution
SELECT 
    Contract,
    COUNT(*) AS total,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM churn_data),2) AS percentage
FROM churn_data
GROUP BY Contract;

-- Customer Status Revenue Contribution
SELECT 
    Customer_Status,
    COUNT(*) AS total_customers,
    SUM(Total_Revenue) AS total_revenue,
    ROUND(SUM(Total_Revenue) * 100.0 / (SELECT SUM(Total_Revenue) FROM churn_data),2) AS revenue_percentage
FROM churn_data
GROUP BY Customer_Status;

-- =========================
-- 4. CHECK MISSING VALUES
-- =========================
-- Includes NULL + empty strings
SELECT 
    SUM(CASE WHEN Customer_ID IS NULL OR Customer_ID = '' THEN 1 ELSE 0 END) AS Customer_ID_nulls,
    SUM(CASE WHEN Value_Deal IS NULL OR TRIM(Value_Deal) = '' THEN 1 ELSE 0 END) AS Value_Deal_nulls,
    SUM(CASE WHEN Internet_Type IS NULL OR TRIM(Internet_Type) = '' THEN 1 ELSE 0 END) AS Internet_Type_nulls,
    SUM(CASE WHEN Churn_Reason IS NULL OR TRIM(Churn_Reason) = '' THEN 1 ELSE 0 END) AS Churn_Reason_nulls
FROM churn_data;

-- =========================
-- 5. DATA CLEANING
-- =========================
-- Create cleaned production table

DROP TABLE IF EXISTS telecom_churn.prod_churn;

CREATE TABLE telecom_churn.prod_churn AS
SELECT 
    Customer_ID,
    Gender,
    Age,
    Married,
    State,
    Number_of_Referrals,
    Tenure_in_Months,

    -- Handle missing values
    IFNULL(NULLIF(TRIM(Value_Deal), ''), 'None') AS Value_Deal,
    Phone_Service,
    IFNULL(NULLIF(TRIM(Multiple_Lines), ''), 'No') AS Multiple_Lines,
    Internet_Service,
    IFNULL(NULLIF(TRIM(Internet_Type), ''), 'None') AS Internet_Type,
    IFNULL(NULLIF(TRIM(Online_Security), ''), 'No') AS Online_Security,
    IFNULL(NULLIF(TRIM(Online_Backup), ''), 'No') AS Online_Backup,
    IFNULL(NULLIF(TRIM(Device_Protection_Plan), ''), 'No') AS Device_Protection_Plan,
    IFNULL(NULLIF(TRIM(Premium_Support), ''), 'No') AS Premium_Support,
    IFNULL(NULLIF(TRIM(Streaming_TV), ''), 'No') AS Streaming_TV,
    IFNULL(NULLIF(TRIM(Streaming_Movies), ''), 'No') AS Streaming_Movies,
    IFNULL(NULLIF(TRIM(Streaming_Music), ''), 'No') AS Streaming_Music,
    IFNULL(NULLIF(TRIM(Unlimited_Data), ''), 'No') AS Unlimited_Data,
    Contract,
    Paperless_Billing,
    Payment_Method,
    Monthly_Charge,
    Total_Charges,
    Total_Refunds,
    Total_Extra_Data_Charges,
    Total_Long_Distance_Charges,
    Total_Revenue,
    Customer_Status,
    IFNULL(NULLIF(TRIM(Churn_Category), ''), 'Others') AS Churn_Category,
    IFNULL(NULLIF(TRIM(Churn_Reason), ''), 'Others') AS Churn_Reason
FROM telecom_churn.churn_data;

-- =========================
-- EDA telecom_churn.churn_data
-- =========================

-- ==========================
-- Business Metrics: 1. CHURN RATE
-- ==========================
SELECT 
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Customer_Status = 'Churned' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN Customer_Status = 'Churned' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS churn_rate_percent
FROM telecom_churn.prod_churn;

-- =========================
-- 2. DEMOGRAPHIC ANALYSIS
-- =========================

-- Gender vs Churn
SELECT 
    Gender,
    COUNT(*) AS total,
    SUM(CASE WHEN Customer_Status = 'Churned' THEN 1 ELSE 0 END) AS churned,
    ROUND(SUM(CASE WHEN Customer_Status = 'Churned' THEN 1 ELSE 0 END)*100/COUNT(*),2) AS churn_rate
FROM telecom_churn.prod_churn
GROUP BY Gender;

-- Age Group Analysis
SELECT 
    CASE 
        WHEN Age < 30 THEN 'Young'
        WHEN Age BETWEEN 30 AND 50 THEN 'Middle Age'
        ELSE 'Senior'
    END AS age_group,
    COUNT(*) AS total,
    SUM(CASE WHEN Customer_Status='Churned' THEN 1 ELSE 0 END) AS churned
FROM telecom_churn.prod_churn
GROUP BY age_group;

-- =========================
-- 3. GEOGRAPHIC ANALYSIS
-- =========================
SELECT 
    State,
    COUNT(*) AS total,
    SUM(CASE WHEN Customer_Status='Churned' THEN 1 ELSE 0 END) AS churned
FROM telecom_churn.prod_churn
GROUP BY State
ORDER BY churned DESC;

-- =========================
-- 4. SERVICE ANALYSIS
-- =========================

-- Internet Type
SELECT 
    Internet_Type,
    COUNT(*) AS total,
    SUM(CASE WHEN Customer_Status='Churned' THEN 1 ELSE 0 END) AS churned,
    ROUND(SUM(CASE WHEN Customer_Status='Churned' THEN 1 ELSE 0 END)*100/COUNT(*),2) AS churn_rate
FROM telecom_churn.prod_churn
GROUP BY Internet_Type;

-- Online Security Impact
SELECT 
    Online_Security,
    COUNT(*) AS total,
    SUM(CASE WHEN Customer_Status='Churned' THEN 1 ELSE 0 END) AS churned
FROM telecom_churn.prod_churn
GROUP BY Online_Security;

-- =========================
-- 5. CONTRACT ANALYSIS
-- =========================
SELECT 
    Contract,
    COUNT(*) AS total,
    SUM(CASE WHEN Customer_Status='Churned' THEN 1 ELSE 0 END) AS churned,
    ROUND(SUM(CASE WHEN Customer_Status='Churned' THEN 1 ELSE 0 END)*100/COUNT(*),2) AS churn_rate
FROM telecom_churn.prod_churn
GROUP BY Contract;

-- =========================
-- 6. PAYMENT ANALYSIS
-- =========================
SELECT 
    Payment_Method,
    COUNT(*) AS total,
    SUM(CASE WHEN Customer_Status='Churned' THEN 1 ELSE 0 END) AS churned
FROM telecom_churn.prod_churn
GROUP BY Payment_Method;

-- =========================
-- 7. REVENUE ANALYSIS
-- =========================
SELECT 
    Customer_Status,
    ROUND(AVG(Monthly_Charge),2) AS avg_monthly_charge,
    ROUND(AVG(Total_Revenue),2) AS avg_revenue
FROM telecom_churn.prod_churn
GROUP BY Customer_Status;

-- =========================
-- 8. TENURE ANALYSIS
-- =========================
SELECT 
    CASE 
        WHEN Tenure_in_Months <= 6 THEN '0-6 Months'
        WHEN Tenure_in_Months <= 12 THEN '6-12 Months'
        ELSE '1+ Year'
    END AS tenure_group,
    COUNT(*) AS total,
    SUM(CASE WHEN Customer_Status='Churned' THEN 1 ELSE 0 END) AS churned
FROM telecom_churn.prod_churn
GROUP BY tenure_group;

-- =========================
-- 9. CHURN REASON ANALYSIS
-- =========================

-- Category
SELECT 
    Churn_Category,
    COUNT(*) AS total
FROM telecom_churn.prod_churn
WHERE Customer_Status = 'Churned'
GROUP BY Churn_Category
ORDER BY total DESC;

-- Detailed Reason
SELECT 
    Churn_Reason,
    COUNT(*) AS total
FROM telecom_churn.prod_churn
WHERE Customer_Status = 'Churned'
GROUP BY Churn_Reason
ORDER BY total DESC;