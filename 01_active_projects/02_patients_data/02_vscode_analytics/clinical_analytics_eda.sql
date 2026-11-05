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

-- 02- TREATMENT EFFICIENCY: Medication Performance and recovery Velocity (LOS)
-- ->measures how effective medications are by tracking the average length of stay (LOS) for patients with specific medical conditions.
SELECT 
    medical_condition,
    medication,
    COUNT(*) AS total_prescriptions,
    ROUND(AVG(length_of_stay), 1) AS avg_length_of_stay,
    -- Tracks the % of patients who recover fast on this specific drug
    ROUND((SUM(CASE WHEN length_of_stay <= 3 THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2) AS rapid_discharge_rate_pct
FROM clean_data
GROUP BY medical_condition, medication
HAVING total_prescriptions >= 5
ORDER BY medical_condition, avg_length_of_stay ASC;

-- 03- CLINICAL RISK TREND : GLOBAL CLINICAL RISK PROFILING (MACRO VIEW)
-- -> groups patients into risk categories based on their test results and length of stay (LOS), providing a macro view of clinical risk trends across the patient population.
WITH patient_profiling AS (
    SELECT 
        medical_condition,
        length_of_stay,
        CASE 
            WHEN test_results = 'Abnormal' AND length_of_stay > 7 THEN 'Acute / Severe Case'
            WHEN test_results = 'Abnormal' AND length_of_stay <= 7 THEN 'Acute / Well-Managed Case'
            WHEN test_results = 'Normal' AND length_of_stay <= 3 THEN 'Symptomatic / Acute Preventative Care'
            ELSE 'Routine Management / Stable Chronic'
        END AS clinical_profile
    FROM clean_data
)
SELECT 
    medical_condition,
    clinical_profile,
    COUNT(*) AS total_patients,
    ROUND(AVG(length_of_stay), 1) AS avg_length_of_stay,
    ROUND((COUNT(*) / SUM(COUNT(*)) OVER(PARTITION BY medical_condition)) * 100, 2) AS profile_distribution_pct
FROM patient_profiling
GROUP BY medical_condition, clinical_profile
ORDER BY medical_condition, total_patients DESC;



