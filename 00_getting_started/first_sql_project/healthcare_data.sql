USE healthcare_db;

SELECT * FROM patients;
SELECT * FROM lab_tests;



-- GET PATIENTS WITH DIAGNOSIS 'DIABETES'
SELECT first_name, last_name, age 
FROM patients
WHERE diagnosis = 'Diabetes';

-- GET PATIENTS ADMITTED TO 'ENDOCRINOLOGY' DEPARTMENT
SELECT first_name, last_name, diagnosis 
FROM patients
WHERE department = 'Endocrinology';

-- COUNT OF FEMALE AND MALE PATIENTS
SELECT COUNT(*) AS female_patients
FROM patients
WHERE gender = 'F'
ORDER BY age DESC;

SELECT COUNT(*) AS male_patients
FROM patients
WHERE gender = 'M'
ORDER BY age ;

-- GET PATIENTS WITH CHECKUPS
SELECT * 
FROM patients
WHERE diagnosis LIKE '%Checkup%';

-- AVERAGE GLUCOSE LEVEL FOR DIABETIC PATIENTS
SELECT test_code, AVG(result_value) AS avg_result
FROM lab_tests
WHERE test_code = 'GLU_F';

-- COUNT OF GLUCOSE TESTS CONDUCTED
SELECT COUNT(test_code) AS glucose_tests
FROM lab_tests
WHERE test_code = 'GLU_F';

-- PATIENTS WITH ABNORMAL GLUCOSE OR HBA1C LEVELS
SELECT patient_id, test_name, result_value 
FROM lab_tests
WHERE (test_code = 'GLU_F' AND result_value > 140.0) OR (test_code = 'HBA1C' AND result_value > 6.5)
ORDER BY patient_id;

-- PATIENTS WITH TEST RESULTS OUTSIDE REFERENCE RANGES
SELECT patient_id, test_name, result_value
FROM lab_tests
WHERE result_value > reference_high
ORDER BY patient_id;

-- PATIENTS WITH PENDING LAB TESTS
SELECT patient_id
FROM lab_tests
WHERE status = 'Pending';

-- TOTAL NUMBER OF COMPLETED LAB TESTS
SELECT COUNT(*) AS completed_tests
FROM lab_tests
WHERE status = 'Completed';

-- JOIN TO GET TEST NAMES ALONG WITH PATIENT NAMES (PRACTICE ALIASING)
SELECT lab.test_name, p.first_name, p.last_name
FROM lab_tests AS lab, patients AS p
WHERE lab.patient_id = p.patient_id;


-- JOIN TO GET TEST NAMES ALONG WITH PATIENT NAMES (PRACTICE INNER JOIN)
SELECT lab.test_name, p.first_name, p.last_name
FROM lab_tests AS lab
INNER JOIN patients AS p 
ON lab.patient_id = p.patient_id;

-- JOIN TO GET PATIENTS AND THEIR LAB TESTS (LEFT JOIN)
SELECT p.first_name, p.last_name, lab.test_name, lab.result_value
FROM patients AS p
LEFT JOIN lab_tests AS lab
ON p.patient_id = lab.patient_id;


-- LIST OF PATIENTS ORDERED BY GLUCOSE LEVELS DESCENDING
SELECT p.first_name, p.last_name, lab.result_value
FROM patients AS p
LEFT JOIN lab_tests AS lab
ON p.patient_id = lab.patient_id
WHERE lab.test_code = 'GLU_F'
ORDER BY lab.result_value DESC;

-- LIST OF DIAGNOSES WITH THEIR CORRESPONDING LAB TEST NAMES
SELECT p.diagnosis, lab.test_name
FROM patients AS p
INNER JOIN lab_tests AS lab
ON p.patient_id = lab.patient_id
ORDER BY lab.test_name;
