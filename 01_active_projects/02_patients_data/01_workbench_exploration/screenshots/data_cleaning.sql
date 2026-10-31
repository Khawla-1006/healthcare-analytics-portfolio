/*
================================================================================
SCRIPT: 02_import_and_schema.sql
AUTHOR: Khawla Bennaceur
DATE: October 31, 2026
DATASET: Kaggle Healthcare Dataset (Single-Table Alternative)

DESCRIPTION:
This script defines the official, structured target schema for the healthcare 
portfolio database. It handles the explicit data definition (DDL) using optimized 
data types (e.g., INT, DECIMAL, DATE) and populates the clean table by filtering 
out logical anomalies identified during the initial data quality check phase.
================================================================================
*/

USE healthcare_portfolio;


DROP TABLE IF EXISTS clean_data;

CREATE TABLE clean_data (
    patient_id INT AUTO_INCREMENT,
    patient_name VARCHAR(100),
    age INT,
    gender VARCHAR(10),
    blood_type VARCHAR(5),
    medical_condition VARCHAR(100),
    date_of_admission DATE,
    discharge_date DATE,
    length_of_stay INT,                    
    doctor_name VARCHAR(100),
    hospital_name VARCHAR(100),
    insurance_provider VARCHAR(50),
    billing_amount DECIMAL(10, 2),
    room_number INT,
    medication VARCHAR(100),
    test_results VARCHAR(20),
    PRIMARY KEY (patient_id)
);


INSERT INTO clean_data (
    patient_name, age, gender, blood_type, medical_condition, date_of_admission, 
    discharge_date, length_of_stay, doctor_name, hospital_name, insurance_provider, 
    billing_amount, room_number, medication, test_results
)
WITH ranked_encounters AS (
    SELECT *,
        ROW_NUMBER() OVER(
            PARTITION BY name, age, gender, blood_type, medical_condition, date_of_admission, doctor, hospital
            ORDER BY billing_amount DESC
        ) AS row_num
    FROM data_backup
)
SELECT 
    name AS patient_name,
    age, 
    gender, 
    blood_type, 
    medical_condition, 
    date_of_admission, 
    discharge_date,
    length_of_stay,                        
    doctor AS doctor_name,
    hospital AS hospital_name,
    insurance_provider, 
    ROUND(billing_amount, 2) AS billing_amount, 
    room_number, 
    medication, 
    test_results
FROM ranked_encounters
WHERE row_num = 1;

SELECT * 
FROM clean_data;