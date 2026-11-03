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
-- ->measures how effective medications are by tracking how long patients stay based on their test results.
SELECT 
	medical_condition,
    medication,
    test_results,
    COUNT(*) AS total_patients,
    ROUND(AVG(length_of_stay),1) AS avg_length_of_stay,
    ROUND((SUM(CASE WHEN test_results = 'Normal' THEN 1 ELSE 0 END)/ COUNT(*))*100,2) AS normal_outcome_rate_pct
FROM clean_data
GROUP BY medical_condition, medication, test_results
ORDER BY medical_condition, normal_outcome_rate_pct DESC; 

-- 03- CLINICAL RISK TREND : Patients Health Stratification and risk flagging
-- -> Flags clinical risk trends by looking at vulnerable demographics with severe/abnormal profiles.
SELECT 
	medical_condition,
    CASE
		WHEN age >= 65 AND test_results = 'Abnormal' THEN 'High Risk (Geriatric + Abnormal)'
        WHEN test_results = 'Abnormal' THEN 'Medium Risk (Abnormal Result)'
        ELSE 'Low Risk (Normal/Inconclusive)'
    END AS clinical_risk_tier,
    COUNT(*) AS patient_count,
    ROUND(AVG(length_of_stay),1) AS avg_los,
    GROUP_CONCAT(DISTINCT blood_type ORDER BY blood_type SEPARATOR ', ') AS observed_blood_types
FROM clean_data
GROUP BY medical_condition, clinical_risk_tier
ORDER BY medical_condition, patient_count DESC; 