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


-- 01- Remove Duplicates id there are any
-- 02- Standardize the data 
-- 03- Null values or blanks in the data

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