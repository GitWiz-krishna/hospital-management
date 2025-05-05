import java.sql.*;
import java.util.Scanner;

public class HospitalManagementSystem {
    private static final String URL = "jdbc:mysql://localhost:3306/hospital_management";
    private static final String USER = "root";
    private static final String PASSWORD = "root";

    private static Connection connect() {
        try {
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (SQLException e) {
            System.out.println("Database connection error: " + e.getMessage());
            return null;
        }
    }

    private static void addPatient(Connection conn, Scanner scanner) {
        try {
            System.out.println("Enter Patient Name: ");
            String name = scanner.nextLine();
            
            System.out.println("Enter Patient Age: ");
            int age;
            try {
                age = Integer.parseInt(scanner.nextLine());
                if (age <= 0) throw new IllegalArgumentException("Age must be positive");
            } catch (NumberFormatException e) {
                System.out.println("Invalid age format. Please enter a number.");
                return;
            }
            
            System.out.println("Enter Patient Gender: ");
            String gender = scanner.nextLine();
            
            System.out.println("Enter Diagnosis: ");
            String diagnosis = scanner.nextLine();

            System.out.println("Enter Doctor ID for the patient: ");
            int doctorId;
            try {
                doctorId = Integer.parseInt(scanner.nextLine());
                if (!doctorExists(conn, doctorId)) {
                    System.out.println("Doctor with ID " + doctorId + " does not exist.");
                    return;
                }
            } catch (NumberFormatException e) {
                System.out.println("Invalid doctor ID format. Please enter a number.");
                return;
            }

            System.out.println("Enter Admission Date (yyyy-mm-dd): ");
            Date admissionDate = parseDate(scanner.nextLine());
            if (admissionDate == null) return;

            System.out.println("Enter Discharge Date (yyyy-mm-dd): ");
            Date dischargeDate = parseDate(scanner.nextLine());
            if (dischargeDate == null) return;

            if (dischargeDate.before(admissionDate)) {
                System.out.println("Discharge date cannot be before admission date.");
                return;
            }

            String query = "INSERT INTO patients (name, age, gender, diagnosis, doctor_id, admission_date, discharge_date) VALUES (?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(query)) {
                stmt.setString(1, name);
                stmt.setInt(2, age);
                stmt.setString(3, gender);
                stmt.setString(4, diagnosis);
                stmt.setInt(5, doctorId);
                stmt.setDate(6, admissionDate);
                stmt.setDate(7, dischargeDate);

                int rowsAffected = stmt.executeUpdate();
                if (rowsAffected > 0) {
                    System.out.println("Patient added successfully.");
                }
            }
        } catch (SQLException e) {
            System.out.println("Error adding patient: " + e.getMessage());
        }
    }

    private static boolean doctorExists(Connection conn, int doctorId) throws SQLException {
        String query = "SELECT 1 FROM doctors WHERE doctor_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, doctorId);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        }
    }

    private static Date parseDate(String dateStr) {
        try {
            return Date.valueOf(dateStr);
        } catch (IllegalArgumentException e) {
            System.out.println("Invalid date format. Please use yyyy-mm-dd format.");
            return null;
        }
    }

    private static void addDoctor(Connection conn, Scanner scanner) {
        try {
            System.out.println("Enter Doctor Name: ");
            String name = scanner.nextLine();
            System.out.println("Enter Specialization: ");
            String specialization = scanner.nextLine();

            String query = "INSERT INTO doctors (name, specialization) VALUES (?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(query)) {
                stmt.setString(1, name);
                stmt.setString(2, specialization);

                int rowsAffected = stmt.executeUpdate();
                if (rowsAffected > 0) {
                    System.out.println("Doctor added successfully.");
                }
            }
        } catch (SQLException e) {
            System.out.println("Error adding doctor: " + e.getMessage());
        }
    }

    private static void viewPatients(Connection conn) {
        try {
            String query = "SELECT p.*, d.name as doctor_name FROM patients p LEFT JOIN doctors d ON p.doctor_id = d.doctor_id";
            try (Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery(query)) {

                System.out.println("\nPatient Details:");
                System.out.println("--------------------------------------------------------------------------------------------------");
                System.out.printf("| %-5s | %-20s | %-3s | %-6s | %-20s | %-20s | %-12s | %-12s |\n",
                        "ID", "Name", "Age", "Gender", "Diagnosis", "Doctor", "Admission", "Discharge");
                System.out.println("--------------------------------------------------------------------------------------------------");

                while (rs.next()) {
                    System.out.printf("| %-5d | %-20s | %-3d | %-6s | %-20s | %-20s | %-12s | %-12s |\n",
                            rs.getInt("patient_id"),
                            rs.getString("name"),
                            rs.getInt("age"),
                            rs.getString("gender"),
                            rs.getString("diagnosis"),
                            rs.getString("doctor_name"),
                            rs.getDate("admission_date"),
                            rs.getDate("discharge_date"));
                }
                System.out.println("--------------------------------------------------------------------------------------------------");
            }
        } catch (SQLException e) {
            System.out.println("Error fetching patient details: " + e.getMessage());
        }
    }

    private static void viewDoctors(Connection conn) {
        try {
            String query = "SELECT * FROM doctors";
            try (Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery(query)) {

                System.out.println("\nDoctor Details:");
                System.out.println("------------------------------------------");
                System.out.printf("| %-5s | %-20s | %-15s |\n", "ID", "Name", "Specialization");
                System.out.println("------------------------------------------");

                while (rs.next()) {
                    System.out.printf("| %-5d | %-20s | %-15s |\n",
                            rs.getInt("doctor_id"),
                            rs.getString("name"),
                            rs.getString("specialization"));
                }
                System.out.println("------------------------------------------");
            }
        } catch (SQLException e) {
            System.out.println("Error fetching doctor details: " + e.getMessage());
        }
    }

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        try (Connection conn = connect()) {
            if (conn == null) return;

            while (true) {
                System.out.println("\nHospital Management System");
                System.out.println("1. Add Patient");
                System.out.println("2. Add Doctor");
                System.out.println("3. View All Patients");
                System.out.println("4. View All Doctors");
                System.out.println("5. Exit");

                System.out.print("Choose an option: ");
                try {
                    int choice = Integer.parseInt(scanner.nextLine());

                    switch (choice) {
                        case 1 -> addPatient(conn, scanner);
                        case 2 -> addDoctor(conn, scanner);
                        case 3 -> viewPatients(conn);
                        case 4 -> viewDoctors(conn);
                        case 5 -> {
                            System.out.println("Exiting system...");
                            return;
                        }
                        default -> System.out.println("Invalid option. Try again.");
                    }
                } catch (NumberFormatException e) {
                    System.out.println("Please enter a valid number (1-5)");
                }
            }
        } catch (SQLException e) {
            System.out.println("Database error: " + e.getMessage());
        }
    }
}