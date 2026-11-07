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

