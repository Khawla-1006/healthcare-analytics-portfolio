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