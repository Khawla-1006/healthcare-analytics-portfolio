/*
======================================================================================
SCRIPT: 01_data_quality_check.sql
AUTHOR: KHAWLA BENNACEUR
DATE: October 26, 2026
DATASET: Kaggle Healthcare Dataset (single table alternative)
DESCRIPTION: This script performs the initial data quality check on a flat table 
    containing 55083 rows and 16 columns. The objective is to identify missing values,
    duplicates encounters, chronological date errors, and text inconsistences across
    clinical and financial dimensions before initiating advanced analytics.
======================================================================================
*/

-- changed the database to healthcare_portfolio to ensure the script runs in the correct context
USE healthcare_portfolio;

-- Data quality check process is divided into three main steps:
-- 01- Remove Duplicates if there are any
-- 02- Standardize the data 
-- 03- Check for chronological date errors

-- First of all, i create a backup staging table of the raw data before starting the cleaning process
CREATE TABLE data_backup AS
SELECT * 
FROM hospital_data;

SELECT *
FROM data_backup; 
-- now we can start the data quality check process


-- 01- Remove Duplicates if there are any
WITH duplicate_cte AS
(
SELECT * ,
ROW_NUMBER() OVER(
PARTITION BY `Name`, Age, Gender, `Blood Type`, `Medical Condition`, `Date of Admission`, Doctor, Hospital) AS row_num
FROM data_backup
)


SELECT *
FROM duplicate_cte
WHERE row_num > 1;

/*
LOGICAL ANOMALY DETECTED:
i find a duplicate record for the patient "Kathy Butler" same admission date, same room, but different discharge date and medication.
==> Logically impossible for a single patient to occupy same bed concurrently under distinct clinical encounters.
VERIDICT: Keeping flagged to show data auditing capabilities, but will remove duplicates in the next step to ensure data integrity for analysis. 
*/

-- 02- Standardize the data

-- ================================================================================
-- DATA SCHEMA STANDARDIZATION: Column Renaming
-- RATIONALE: The raw dataset contains column names with spaces and uppercase letters,
-- which forces the system to require persistent backticks (``). 
-- Action: Refactoring the schema to standard lowercase 'snake_case' formatting 
-- to optimize query readability, prevent syntax errors, and streamline future code.
-- ================================================================================


ALTER TABLE data_backup RENAME COLUMN `Medical Condition` TO medical_condition;
ALTER TABLE data_backup RENAME COLUMN `Blood Type` TO blood_type;
ALTER TABLE data_backup RENAME COLUMN `Date of Admission` TO date_of_admission;
ALTER TABLE data_backup RENAME COLUMN `Insurance Provider` TO insurance_provider;
ALTER TABLE data_backup RENAME COLUMN `Billing Amount` TO billing_amount;
ALTER TABLE data_backup RENAME COLUMN `Room Number` TO room_number;
ALTER TABLE data_backup RENAME COLUMN `Admission Type` TO admission_type;
ALTER TABLE data_backup RENAME COLUMN `Discharge Date` TO discharge_date;
ALTER TABLE data_backup RENAME COLUMN `Test Results` TO test_results;
ALTER TABLE data_backup RENAME COLUMN `Length of Stay` TO length_of_stay;

-- [DATA QUALITY ANOMALY DETECTED]: Structural text encoding issue observed in medical conditions.
-- 'Alzheimer' contains corrupted symbols/typos impacting text standardization.
-- Resolution Path: Will apply a targeted UPDATE/REPLACE statement during the transformation phase.

SELECT  medical_condition, COUNT(medical_condition) AS case_volume
FROM data_backup
WHERE medical_condition LIKE "%Alz%"
GROUP BY medical_condition;

-- ================================================================================
-- DATA TRANSFORMATION: Text Encoding & Safe Mode Override
-- PROBLEM: The 'medical_condition' column contains corrupted character strings 
-- ('â€™s') due to an ASCII/UTF-8 encoding failure during raw data generation. 
-- RATIONALE: MySQL blocks mass updates by default under 'Safe Update Mode' 
-- when a primary key is not used in the WHERE clause. 
-- ACTION: Temporarily disabling SQL_SAFE_UPDATES to perform column-wide text 
-- standardization, removing encoding artifacts, and re-enabling safety protocols.
-- ================================================================================

SET SQL_SAFE_UPDATES = 0;

UPDATE data_backup
SET medical_condition = REPLACE(medical_condition, 'â€™s', 's')
WHERE medical_condition LIKE '%Alz%';

SET SQL_SAFE_UPDATES = 1;


-- 03- Check for chronological date errors:

-- validating mathematical accuracy of the system calculated length_of_stay against the actual difference between discharge_date and date_of_admission.
SELECT 
date_of_admission,
discharge_date,
length_of_stay AS system_los,
DATEDIFF(discharge_date, date_of_admission) AS calculated_los,
(length_of_stay - DATEDIFF(discharge_date, date_of_admission)) AS los_variation
FROM data_backup
WHERE date_of_admission > discharge_date
		OR length_of_stay <> DATEDIFF(discharge_date, date_of_admission);

-- 0 rows returned: integrity verified :)