/*
===================================================================================
SCRIPT: Financial_analytics_eda.sql
AUTHOR: Khawla Bennaceur
DATE: November 7, 2026
DATASET: Kaggle Healthcare Dataset (Single-Table Alternative)

DESCRIPTION:
This script performs exploratory data analysis (EDA) focusing on hospital revenue cycle
performance, billing variances, cost drivers, and financial risk profiles. 
By evaluating insurance provider metrics, hospital cost-per-day, and patient billing 
percentiles, these queries highlight operational revenue leakage and financial benchmarks

DATABASE : MySQL
=====================================================================================
*/


-- 1. INSURANCE BENCHMARKING: Market Share and Billing Performance by Provider
-- Directly answers which insurance networks carry the heaviest financial burden and revenue share.
SELECT 
    insurance_provider,
    COUNT(*) AS total_claims,
    ROUND(SUM(billing_amount), 2) AS total_gross_billing,
    ROUND(AVG(billing_amount), 2) AS avg_billing_per_claim,
    ROUND(MAX(billing_amount), 2) AS highest_single_bill,
    ROUND((COUNT(*) / SUM(COUNT(*)) OVER()) * 100, 2) AS market_share_pct
FROM clean_data 
GROUP BY insurance_provider
ORDER BY total_gross_billing DESC;


-- 2. HOSPITAL COST COMPARISON: Most Expensive Hospital Profiles

SELECT 
    hospital_name,
    COUNT(*) AS total_admissions,
    ROUND(SUM(billing_amount), 2) AS total_hospital_revenue,
    ROUND(AVG(billing_amount), 2) AS avg_hospital_bill,
    -- Calculates the average financial turnover per bed-day at this specific facility
    ROUND(AVG(billing_amount / NULLIF(length_of_stay, 0)), 2) AS avg_cost_per_day
FROM clean_data
GROUP BY hospital_name
ORDER BY avg_hospital_bill DESC;

-- 3. COST DRIVERS: Correlation Between Length of Stay (LOS) and Financial Impact
-- Determines if longer stays scale linearly or if upfront/fixed admission costs dominate.
WITH los_financial_buckets AS (
    SELECT 
        length_of_stay,
        billing_amount,
        CASE 
            WHEN length_of_stay <= 3 THEN 'Short Stay (1-3 days)'
            WHEN length_of_stay BETWEEN 4 AND 7 THEN 'Medium Stay (4-7 days)'
            ELSE 'Long Stay (8+ days)'
        END AS stay_category
    FROM clean_data
)
SELECT 
    stay_category,
    COUNT(*) AS total_admissions,
    ROUND(SUM(billing_amount), 2) AS total_category_billing,
    ROUND(AVG(billing_amount), 2) AS avg_total_bill,
    ROUND(AVG(billing_amount / NULLIF(length_of_stay, 0)), 2) AS avg_cost_per_day
FROM los_financial_buckets
GROUP BY stay_category
ORDER BY MIN(length_of_stay);

-- 4.PATHOLOGY COST BENCHMARKING (WHICH CONDITION IS MOST EXPENSIVE)

SELECT 
    medical_condition,
    COUNT(*) AS total_cases,
    ROUND(SUM(billing_amount), 2) AS total_condition_spend,
    ROUND(AVG(billing_amount), 2) AS avg_billing_per_condition,
    ROUND(MAX(billing_amount), 2) AS highest_single_condition_bill,
    -- Ranks pathologies from most expensive average to least expensive
    RANK() OVER (ORDER BY AVG(billing_amount) DESC) AS financial_expense_rank
FROM clean_data 
GROUP BY medical_condition
ORDER BY avg_billing_per_condition DESC;

--  UPDATED_VER: PATHOLOGY COST-DRIVER DIAGNOSTICS (LOS VS. INTENSITY)
SELECT 
    medical_condition,
    COUNT(*) AS total_cases,
    ROUND(AVG(length_of_stay), 1) AS avg_length_of_stay,
    ROUND(AVG(billing_amount), 2) AS avg_total_billing,
    
    -- Core Metric: Calculates the financial intensity per day of hospitalization
    ROUND(AVG(billing_amount / NULLIF(length_of_stay, 0)), 2) AS avg_cost_per_day,
    
    -- Clinical Context: % of cases entering with abnormal baselines to measure complexity
    ROUND((SUM(CASE WHEN test_results = 'Abnormal' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2) AS abnormal_admission_rate_pct,
    
    -- Global Rank based on the daily financial intensity
    RANK() OVER (ORDER BY AVG(billing_amount / NULLIF(length_of_stay, 0)) DESC) AS daily_intensity_rank
FROM clean_data
GROUP BY medical_condition
ORDER BY avg_cost_per_day DESC;