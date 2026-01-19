# Healthcare Analytics SQL Project

A comprehensive SQL database project for managing and analyzing healthcare patient data, including patient information and laboratory test results.

## Project Overview

This project contains a MySQL database with patient records and lab test data for healthcare analytics. It includes SQL scripts to set up the database, populate sample data, and perform various analytical queries.

## Database Structure

### Tables

#### 1. **patients** table
Stores patient demographic and clinical information.

| Column | Type | Description |
|--------|------|-------------|
| patient_id | INT (PK) | Unique patient identifier |
| first_name | VARCHAR(50) | Patient's first name |
| last_name | VARCHAR(50) | Patient's last name |
| age | INT | Patient's age |
| gender | CHAR(1) | Patient's gender (M/F) |
| diagnosis | VARCHAR(100) | Primary diagnosis |
| admission_date | DATE | Date of admission |
| department | VARCHAR(50) | Medical department |

**Sample Data:** 8 patients from various departments (Endocrinology, Cardiology, Pulmonology, etc.)

#### 2. **lab_tests** table
Stores laboratory test results for patients.

| Column | Type | Description |
|--------|------|-------------|
| test_id | INT (PK) | Unique test identifier |
| patient_id | INT (FK) | Reference to patients table |
| test_name | VARCHAR(50) | Name of the test |
| test_code | VARCHAR(20) | Test code (GLU_F, HBA1C, etc.) |
| result_value | DECIMAL(10,2) | Test result value |
| unit | VARCHAR(10) | Unit of measurement |
| reference_low | DECIMAL(10,2) | Normal range - low value |
| reference_high | DECIMAL(10,2) | Normal range - high value |
| test_date | DATE | Date test was performed |
| status | VARCHAR(20) | Test status (Completed/Pending) |

**Sample Data:** 12 lab tests across different test types (Glucose, HbA1c, Cholesterol, etc.)

**Relationships:** Foreign key constraint: patient_id → patients(patient_id)

## Files

- **setup_table.sql** - Creates the database, tables, and inserts sample data
- **healthcare_data.sql** - Contains analytical queries to retrieve and analyze data
- **readme.md** - This documentation file

## Setup Instructions

### Prerequisites
- MySQL Server installed and running
- MySQL command-line client or GUI tool (MySQL Workbench, DBeaver, etc.)
- PowerShell (Windows) or Terminal (Mac/Linux)

### Step 1: Create Database and Tables

Run the setup script:

```powershell
Get-Content setup_table.sql | mysql -u root -p healthcare_db
```

Enter your MySQL password when prompted.

### Step 2: Run Queries

Execute the analytics queries:

```powershell
Get-Content healthcare_data.sql | mysql -u root -p healthcare_db
```

## Sample Queries Included

The `healthcare_data.sql` file contains the following analyses:

1. **View all patients** - Display complete patient roster
2. **View all lab tests** - Display all lab test results
3. **Diabetic patients** - Find patients with diabetes diagnosis
4. **Department breakdown** - View patients by department
5. **Gender distribution** - Count patients by gender
6. **Hypertension patients** - Find patients with hypertension diagnosis
7. **Glucose test averages** - Calculate average glucose values
8. **Abnormal results** - Find tests outside normal ranges
9. **Pending tests** - Find incomplete/pending tests

## Using with VS Code

### Option 1: Database Client Extension
1. Install "Database Client JDBC" extension in VS Code
2. Create MySQL connection:
   - Host: `localhost`
   - Port: `3306`
   - User: `root`
   - Password: (your MySQL password)
   - Database: `healthcare_db`
3. Browse and query tables visually

### Option 2: Command Line
Use PowerShell commands to run SQL files directly (see Setup Instructions above)

## Key Metrics

- **Total Patients:** 8
- **Total Lab Tests:** 12
- **Departments:** 8 (Endocrinology, Cardiology, Primary Care, Pulmonology, Obstetrics)
- **Test Types:** 9 (Glucose, HbA1c, Cholesterol, Blood Pressure, CBC, TSH, Spirometry, Creatinine, Beta-hCG)

## Troubleshooting

### Error: "Access denied for user 'root'@'localhost'"
- Make sure you're providing the correct MySQL password
- Use the `-p` flag followed by your password or `-p` to be prompted

### Error: "Unknown database 'healthcare_db'"
- Run `setup_table.sql` first to create the database
- Verify the script ran successfully

### Tables not visible in VS Code
- Refresh the Database Client connection
- Test the connection using the right-click menu
- Ensure the connection has the correct credentials

## Database Queries Quick Reference

```sql
-- Show all databases
SHOW DATABASES;

-- Select the healthcare database
USE healthcare_db;

-- Show all tables
SHOW TABLES;

-- View table structure
DESCRIBE patients;
DESCRIBE lab_tests;

-- Count records
SELECT COUNT(*) FROM patients;
SELECT COUNT(*) FROM lab_tests;
```

## Future Enhancements

- Add more test types and reference ranges
- Implement patient history tracking
- Add billing/insurance information
- Create views for common analytical queries
- Add indexes for performance optimization
- Implement data validation rules

## Author

Healthcare Analytics Project

## License

MIT License
