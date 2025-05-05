/*
* HOSPITAL MANAGEMENT DATABASE SCHEMA
* 
* This script creates a complete hospital management database with:
* - Doctors table (medical professionals)
* - Patients table (patient records)
* - Appointments table (scheduling system)
* 
* Includes sample data for testing and demonstration purposes
*/

-- =============================================
-- DATABASE CREATION
-- =============================================
CREATE DATABASE IF NOT EXISTS hospital_management;
USE hospital_management;

-- =============================================
-- TABLE DEFINITIONS
-- =============================================

-- DOCTORS TABLE
-- Stores information about medical professionals
CREATE TABLE IF NOT EXISTS doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,               -- Full name of doctor
    specialization VARCHAR(100) NOT NULL      -- Medical specialty (e.g., Cardiology)
);

-- PATIENTS TABLE
-- Stores core patient medical records
CREATE TABLE IF NOT EXISTS patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,               -- Patient full name
    age INT CHECK (age > 0),                  -- Must be positive
    gender VARCHAR(10),                       -- Male/Female/Other
    diagnosis VARCHAR(255),                   -- Medical diagnosis
    doctor_id INT,                            -- Attending physician
    admission_date DATE NOT NULL,             -- When patient was admitted
    discharge_date DATE,                      -- When patient was discharged (NULL if still admitted)
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id) ON UPDATE CASCADE
);

-- APPOINTMENTS TABLE
-- Manages scheduling between patients and doctors
CREATE TABLE IF NOT EXISTS appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_date DATE NOT NULL,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id) ON UPDATE CASCADE,
    INDEX (appointment_date)  -- Improves performance for date-based queries
);

-- =============================================
-- DATA INITIALIZATION
-- =============================================

-- Temporarily disable foreign key checks for clean data reset
SET FOREIGN_KEY_CHECKS = 0;

-- Clear all existing data (if any) in reverse dependency order
TRUNCATE TABLE appointments;
TRUNCATE TABLE patients;
TRUNCATE TABLE doctors;

-- Re-enable foreign key constraints
SET FOREIGN_KEY_CHECKS = 1;

-- =============================================
-- SAMPLE DOCTOR DATA
-- =============================================
INSERT INTO doctors (name, specialization) VALUES
('Dr. Krishna Menon', 'Cardiology'),          -- ID 1
('Dr. Ram Iyer', 'Neurology'),                -- ID 2
('Dr. Dharani Nair', 'Pediatrics'),           -- ID 3
('Dr. Gokul Srinivasan', 'Orthopedics'),      -- ID 4
('Dr. Kishore Kumar', 'General Surgery');     -- ID 5

-- =============================================
-- SAMPLE PATIENT DATA
-- =============================================
INSERT INTO patients (name, age, gender, diagnosis, doctor_id, admission_date, discharge_date) VALUES
('Krishna', 42, 'Male', 'Coronary Artery Disease', 1, '2023-11-01', '2023-11-05'),       -- Treated by Dr. Menon (Cardiology)
('Ram', 35, 'Male', 'Chronic Migraines', 2, '2023-11-02', '2023-11-03'),                  -- Treated by Dr. Iyer (Neurology)
('Dharani', 28, 'Female', 'Prenatal Checkup', 3, '2023-11-03', NULL),                     -- Ongoing pregnancy care
('Gokul', 19, 'Male', 'Fractured Femur (Football Injury)', 4, '2023-11-04', '2023-11-10'),-- Orthopedic case
('Kishore', 55, 'Male', 'Gallbladder Removal', 5, '2023-11-05', '2023-11-08'),            -- General surgery
('Puza', 24, 'Female', 'Appendicitis', 5, '2023-11-06', '2023-11-09'),                    -- Another surgery case
('Rohit', 30, 'Male', 'Concussion', 2, '2023-11-07', '2023-11-08'),                       -- Neurological case
('Rahul', 50, 'Male', 'Diabetes Management', 1, '2023-11-08', '2023-11-09'),              -- Cardiology follow-up
('Sanjay', 47, 'Male', 'Knee Replacement', 4, '2023-11-09', '2023-11-15'),                -- Orthopedic surgery
('Kanish', 8, 'Male', 'Asthma Treatment', 3, '2023-11-10', '2023-11-12');                 -- Pediatric case

-- =============================================
-- SAMPLE APPOINTMENT DATA
-- =============================================
INSERT INTO appointments (patient_id, doctor_id, appointment_date) VALUES
(1, 1, '2023-12-01'),  -- Krishna's cardiac follow-up
(2, 2, '2023-12-05'),  -- Ram's neurology check
(3, 3, '2023-12-10'),  -- Dharani's next prenatal visit
(4, 4, '2023-12-15'),  -- Gokul's fracture follow-up
(5, 5, '2023-12-20');  -- Kishore's post-surgery check

/*
* DATABASE SCHEMA NOTES:
* 1. All tables use InnoDB engine (default) for FK support
* 2. ON DELETE CASCADE ensures appointments are removed when patients are deleted
* 3. ON UPDATE CASCADE propagates doctor ID changes automatically
* 4. CHECK constraint validates age is positive
* 5. Index on appointment_date improves scheduling queries
*/