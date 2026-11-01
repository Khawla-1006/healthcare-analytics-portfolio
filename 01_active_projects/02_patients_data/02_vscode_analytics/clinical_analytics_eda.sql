/*
===================================================================================
SCRIPT: clinical_analytics_eda.sql
AUTHOR: Khawla Bennaceur
DATE: November 1, 2026
DATASET: Kaggle Healthcare Dataset (Single-Table Alternative)

DESCRIPTION:
This script performs exploratory data analysis (EDA) focusing on patient outcomes,
treatment efficacy, clinical risk profiles, and hospital resource utilization.
By analyzing patterns across medical conditions, test results, lengths of stay(LOS),
and medications, these queries uncover actionable insights to optimize clinical 
workflows, identify high_risk patient trends and measure care delivery performance.

DATABASE : MySQL
=====================================================================================
*/

USE healthcare_portfolio;

-- 01- CLINICAL TRAFFIC AND CAPACITY: top medical conditions by age and gender
SELECT 
	medical_condition, 
    CASE 
		WHEN age < 18 THEN 'Pediatric (<18)' 
        WHEN age BETWEEN 18 AND 64 THEN 'Adult (>18)'
        ELSE 'Geriatric (+65)'
	END AS age_cohort,
    gender,
    COUNT(*) AS total_cases,
    ROUND(AVG(length_of_stay),1) AS avg_days_stayed
FROM clean_data
GROUP BY  medical_condition, age_cohort, gender
ORDER BY medical_condition, total_cases DESC;