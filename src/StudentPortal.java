/* This is the driving engine of the program. It parses the command-line
 * arguments and calls the appropriate methods in the other classes.
 *
 * You should edit this file in two ways:
 * 1) Insert your database username and password in the proper places.
 * 2) Implement the three functions getInformation, registerStudent
 *    and unregisterStudent.
 */

import java.sql.*; // JDBC stuff.
import java.util.ArrayList;
import java.util.Properties;
import java.util.Scanner;
import java.io.*;  // Reading user input.

public class StudentPortal {
    /* TODO Here you should put your database name, username and password */
    static final String USERNAME = "postgres";
    static final String PASSWORD = "nbaerveldt960411";

    /* Print command usage.
     * /!\ you don't need to change this function! */
    public static void usage() {
        System.out.println("Usage:");
        System.out.println("    i[nformation]");
        System.out.println("    r[egister] <course>");
        System.out.println("    u[nregister] <course>");
        System.out.println("    q[uit]");
    }

    /* main: parses the input commands.
     * /!\ You don't need to change this function! */
    public static void main(String[] args) throws Exception {
        try {
            Class.forName("org.postgresql.Driver");
            String url = "jdbc:postgresql://localhost/";
            Properties props = new Properties();
            props.setProperty("user", USERNAME);
            props.setProperty("password", PASSWORD);
            Connection conn = DriverManager.getConnection(url, props);

            String student = args[0]; // This is the identifier for the student.

            Console console = System.console();
            // In Eclipse. System.console() returns null due to a bug (https://bugs.eclipse.org/bugs/show_bug.cgi?id=122429)
            // In that case, use the following line instead:
            // BufferedReader console = new BufferedReader(new InputStreamReader(System.in));
            usage();
            System.out.println("Welcome!");
            while (true) {
                System.out.print("? > ");
                String mode = console.readLine();
                String[] cmd = mode.split(" +");
                cmd[0] = cmd[0].toLowerCase();
                if ("information".startsWith(cmd[0]) && cmd.length == 1) {
                    /* Information mode */
                    getInformation(conn, student);
                } else if ("register".startsWith(cmd[0]) && cmd.length == 2) {
                    /* Register student mode */
                    try {
                        registerStudent(conn, student, cmd[1]);
                    } catch (SQLException e) {
                        System.out.println(e.getMessage());
                    }
                } else if ("unregister".startsWith(cmd[0]) && cmd.length == 2) {
                    /* Unregister student mode */
                    try {
                        unregisterStudent(conn, student, cmd[1]);
                    } catch(SQLException e) {
                        System.out.println(e.getMessage());
                    }
                } else if ("quit".startsWith(cmd[0])) {
                    break;
                } else usage();
            }
            System.out.println("Goodbye!");
            conn.close();
        } catch (SQLException e) {
            System.err.println(e);
            System.exit(2);
        }
    }

    /* Given a student identification number, ths function should print
     * - the name of the student, the students national identification number
     *   and their issued login name (something similar to a CID)
     * - the programme and branch (if any) that the student is following.
     * - the courses that the student has read, along with the grade.
     * - the courses that the student is registered to. (queue position if the student is waiting for the course)
     * - the number of mandatory courses that the student has yet to read.
     * - whether or not the student fulfills the requirements for graduation
     */
    static void getInformation(Connection conn, String student) throws SQLException {
        ArrayList<String> resultSets = new ArrayList<>();
        System.out.println("Information for student " + student);
        System.out.println("-------------------------------------------------------");
        // TODO: Your implementation here
        resultSets.add("Name: " + prepareStatement(1, "SELECT name FROM student WHERE ssn = ?", conn, student));
        resultSets.add("Student ID: " + prepareStatement(1, "SELECT login FROM student WHERE ssn = ?", conn, student));
        resultSets.add("Line: " + prepareStatement(1, "SELECT program FROM student WHERE ssn = ?", conn, student));
        resultSets.add("Branch: " + prepareStatement(1, "SELECT branch FROM StudentsFollowing WHERE student = ?", conn, student));
        resultSets.add("");
        resultSets.add("Read courses (name code credits grade): ");
        resultSets.add(prepareStatement(4, "SELECT name, course, FinishedCourses.credits, grade FROM FinishedCourses, Course WHERE student = ? AND code = course", conn, student));
        resultSets.add("Registered courses (name code status):");
        resultSets.add(prepareStatement(3, "SELECT name, course, status FROM Course, Registrations WHERE student = ? AND status = 'registered' AND code = course", conn, student));
        resultSets.add(prepareStatement(4, "SELECT name, r.course, 'waiting as nr.' AS status, place FROM Course co, Registrations r, CourseQueuePositions c WHERE r.student = ? AND r.course = c.course AND r.course = code AND status = 'waiting'", conn, student));
        resultSets.add("Seminar courses taken: " + prepareStatement(1,"SELECT seminarcourses FROM PathToGraduation WHERE student = ?",conn,student));
        resultSets.add("Math credits taken: " + prepareStatement(1,"SELECT mathcredits FROM PathToGraduation WHERE student = ?",conn,student));
        resultSets.add("Research credits taken: " + prepareStatement(1,"SELECT researchcredits FROM PathToGraduation WHERE student = ?",conn,student));
        resultSets.add("Total credits taken: " + prepareStatement(1,"SELECT totalcredits FROM PathToGraduation WHERE student = ?",conn,student));
        //resultSets.add("Fulfills the requirements for graduation: " + prepareStatement(1,"SELECT 'yes' AS status FROM PathToGraduation WHERE student = ? AND status = TRUE",conn,student));
        resultSets.add("Fulfills the requirements for graduation: " + prepareStatement(1,"SELECT 'no' AS status FROM PathToGraduation WHERE student = ? AND status = FALSE",conn,student) +
                prepareStatement(1,"SELECT 'yes' AS status FROM PathToGraduation WHERE student = ? AND status = TRUE",conn,student));
        for (String s : resultSets) {
            System.out.println(s);
        }
        System.out.println("-------------------------------------------------------");
        //if (rs.next())
        //    System.out.println("Name:" + rs.getString(1)) ;
        //rs.close() ;
        //st.close() ;

    }

    private static String prepareStatement(int colNum, String sqlStatement, Connection conn, String... toString) throws SQLException {
        PreparedStatement st;
        st = conn.prepareStatement(sqlStatement);
        for (int i = 0; i < toString.length; i++) {
            st.setString(i + 1, toString[i]);
        }
        ResultSet rs = st.executeQuery();
        StringBuilder result = new StringBuilder();
        while (rs.next()) {
            for (int i = 1; i <= colNum; i++)
            {
                result.append(rs.getString(i));
                result.append(' ');
            }
            if(colNum > 1)
                result.append('\n');
        }
        rs.close();
        st.close();
        return result.toString();
    }

    /* Register: Given a student id number and a course code, this function
     * should try to register the student for that course.
     */
    static void registerStudent(Connection conn, String student, String course)
            throws SQLException {
        PreparedStatement st = conn.prepareStatement("INSERT INTO Registrations VALUES(?, ?)");
        st.setString(1, student);
        st.setString(2, course);
        st.executeUpdate();
        st.close();
        String status = prepareStatement(1, "SELECT status FROM Registrations WHERE student = ? AND course = ?", conn, student, course);
        String courseName = prepareStatement(1,"SELECT name FROM course WHERE code = ?", conn, course);
        if(status.contains("registered"))
            System.out.println("Successfully added student " + student + " to course " + course + " " + courseName + ".");
        else
            System.out.println("Course " + course + " " + courseName + " is full. Student " + student + " added to waiting list.");
    }

    /* Unregister: Given a student id number and a course code, this function
     * should unregister the student from that course.
     */
    static void unregisterStudent(Connection conn, String student, String course)
            throws SQLException {
        String studentName = prepareStatement(1,"SELECT student FROM Registrations WHERE student = ? AND course = ?", conn, student, course);
        String courseName = prepareStatement(1,"SELECT code FROM course WHERE code = ?", conn, course);
        if(!courseName.contains(course))
            System.out.println("Course " + course + " does not exist!");
        else if (!studentName.contains(student))
            System.out.println("Student " + student + " has not applied for course " + course + "!");
        else {
            PreparedStatement st = conn.prepareStatement("DELETE FROM Registrations WHERE student = ? AND course = ?");
            st.setString(1, student);
            st.setString(2, course);
            st.executeUpdate();
            st.close();
            System.out.println("Student " + student + " has been removed from registrations for course " + course + ".");
        }
    }
}
