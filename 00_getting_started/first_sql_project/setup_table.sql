CREATE DATABASE IF NOT EXISTS healthcare_db;
USE healthcare_db;

CREATE TABLE patients (
    patient_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    age INT,
    gender CHAR(1),
    diagnosis VARCHAR(100),
    admission_date DATE,
    department VARCHAR(50)
);

CREATE TABLE lab_tests (
    test_id INT PRIMARY KEY,
    patient_id INT,
    test_name VARCHAR(50),
    test_code VARCHAR(20),
    result_value DECIMAL(10,2),
    unit VARCHAR (10),
    reference_low DECIMAL(10,2),
    reference_high DECIMAL(10,2),
    test_date DATE,
    status VARCHAR(20),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);

INSERT INTO patients VALUES
(1,'John','Smith',45,'M','Type 2 Diabetes','2024-01-10','Endocrinology'),
(2,'Maria','Garcia',62,'F','Hypertension Stage 2','2024-01-12','Cardiology'),
(3,'David','Chen',38,'M','Annual Checkup','2024-01-15','Primary Care'),
(4,'Sarah','Johnson',71,'F','Type 2 Diabetes','2024-01-18','Endocrinology'),
(5,'Robert','Kim',55,'M','Hyperlipidemia','2024-01-20','Cardiology'),
(6,'Lisa','Wang',42,'F','Hypothyroidism','2024-01-22','Endocrinology'),
(7,'James','Brown',68,'M','COPD','2024-01-25','Pulmonology'),
(8,'Emily','Davis',33,'F','Pregnancy','2024-01-28','Obstetrics');

INSERT INTO lab_tests VALUES

-- Patient 1 (Diabetes)
(101,1,'Glucose Fasting','GLU_F',180.5,'mg/dL',70,100,'2024-01-15','Completed'),
(102,1,'HbA1c','HBA1C',7.8,'%',4.0,5.6,'2024-01-15','Completed'),
(103,1,'Cholesterol Total','CHOL_T',210.0,'mg/dL',125,200,'2024-01-15','Completed'),

-- Patient 2 (Hypertension)
(201,2,'Blood Pressure','BP',145.0,'mmHg',90,120,'2024-01-15','Completed'),
(202,2,'Sodium','NA',142.0,'mmol/L',135,145,'2024-01-16','Completed'),

-- Patient 3 (Healthy)
(301,3,'Glucose Fasting','GLU_F',95.0,'mg/dL',70,100,'2024-01-17','Completed'),
(302,3,'CBC','CBC',NULL,NULL,NULL,NULL,'2024-01-17','Pending'),

-- Patient 4 (Diabetes) 
(401,4,'Glucose Fasting','GLU_F',210.0,'mg/dL',70,100,'2024-01-18','Completed'),
(402,4,'Creatinine','CREAT',1.2,'mg/dL',0.6,1.1,'2024-01-18','Completed'),

-- Patient 6 (Hypothyroidism)
(601,6,'TSH','TSH',5.8,'mIU/L',0.4,4.0,'2024-01-22','Completed'),

-- Patient 7 (COPD)
(701,7,'Spirometry','SPIRO',65.0,'%',80,120,'2024-01-25','Completed'),

-- Patient 8 (Pregnancy)
(801,8,'Beta-hCG','BHCG',15000.0,'',70,100,'2024-01-15','Completed');


SELECT CONCAT('Patients: ', COUNT(*)) FROM patients;
SELECT CONCAT('Lab Tests: ', COUNT(*)) FROM lab_tests;


   



