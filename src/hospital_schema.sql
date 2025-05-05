-- Create the database
CREATE DATABASE IF NOT EXISTS hospital_management;
USE hospital_management;

-- Create doctors table first since other tables reference it
CREATE TABLE IF NOT EXISTS doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    specialization VARCHAR(100)
);

-- Create patients table with proper foreign key
CREATE TABLE IF NOT EXISTS patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    age INT,
    gender VARCHAR(10),
    diagnosis VARCHAR(255),
    doctor_id INT,
    admission_date DATE,
    discharge_date DATE,
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);

-- Create appointments table with proper foreign keys
CREATE TABLE IF NOT EXISTS appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    appointment_date DATE,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);

-- Clear existing data in correct order (if any exists)
SET FOREIGN_KEY_CHECKS = 0; -- Temporarily disable foreign key checks
TRUNCATE TABLE appointments;
TRUNCATE TABLE patients;
TRUNCATE TABLE doctors;
SET FOREIGN_KEY_CHECKS = 1; -- Re-enable foreign key checks

-- Insert doctors first
INSERT INTO doctors (name, specialization) VALUES
('Dr. Krishna Menon', 'Cardiology'),
('Dr. Ram Iyer', 'Neurology'),
('Dr. Dharani Nair', 'Pediatrics'),
('Dr. Gokul Srinivasan', 'Orthopedics'),
('Dr. Kishore Kumar', 'General Surgery');

-- Now insert patients with valid doctor_id references
INSERT INTO patients (name, age, gender, diagnosis, doctor_id, admission_date, discharge_date) VALUES
('Krishna', 42, 'Male', 'Coronary Artery Disease', 1, '2023-11-01', '2023-11-05'),
('Ram', 35, 'Male', 'Chronic Migraines', 2, '2023-11-02', '2023-11-03'),
('Dharani', 28, 'Female', 'Prenatal Checkup', 3, '2023-11-03', NULL),
('Gokul', 19, 'Male', 'Fractured Femur (Football Injury)', 4, '2023-11-04', '2023-11-10'),
('Kishore', 55, 'Male', 'Gallbladder Removal', 5, '2023-11-05', '2023-11-08'),
('Puza', 24, 'Female', 'Appendicitis', 5, '2023-11-06', '2023-11-09'),
('Rohit', 30, 'Male', 'Concussion', 2, '2023-11-07', '2023-11-08'),
('Rahul', 50, 'Male', 'Diabetes Management', 1, '2023-11-08', '2023-11-09'),
('Sanjay', 47, 'Male', 'Knee Replacement', 4, '2023-11-09', '2023-11-15'),
('Kanish', 8, 'Male', 'Asthma Treatment', 3, '2023-11-10', '2023-11-12');

-- Optionally insert some appointments
INSERT INTO appointments (patient_id, doctor_id, appointment_date) VALUES
(1, 1, '2023-12-01'), -- Krishna follow-up
(2, 2, '2023-12-05'), -- Ram neurology check
(3, 3, '2023-12-10'), -- Dharani prenatal visit
(4, 4, '2023-12-15'), -- Gokul fracture follow-up
(5, 5, '2023-12-20'); -- Kishore post-surgery check