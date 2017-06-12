package mypack;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Types;
import java.text.DateFormat;
import java.text.Format;
import java.text.SimpleDateFormat;
import java.time.format.DateTimeFormatter;
import java.util.Scanner;

import oracle.jdbc.OracleTypes;

public class Course {
	
	public static void ViewStudentsRegisteredInCourse(Scanner scanner)
	{
		Connection conn = null;
		try 
		{
			System.out.println("");
			System.out.println("-------- Students Registered in a Course Offering ----------");
			System.out.println("");
			Course.viewAllCourseOfferings();
			System.out.print("Enter Course Offering ID from above table: ");
			int courseOfferingID = scanner.nextInt();
			conn = DriverManager.getConnection(ConfigManager.DB_URL, ConfigManager.username,
					 ConfigManager.pwd);
			CallableStatement pstmt = conn.prepareCall("{call proc_StudentsInCourse(?,?)}");
			pstmt.setInt(1, courseOfferingID);
			pstmt.registerOutParameter(2, OracleTypes.CURSOR);
			pstmt.executeUpdate();
			 
			ResultSet rs = (ResultSet) pstmt.getObject(2);
			if (!rs.isBeforeFirst() ) {    
			    System.out.println("No students registered in this course."); 
			}
			else
			{
				System.out.println("----------- Students registered in this course -------------");
				System.out.printf("%-16s\n", "Unity ID");
		        while (rs.next()) {
		        	System.out.printf("%-16s\n", rs.getString(1));
		        }
			}
	        System.out.println("");
			pstmt.close();
		  }
		 catch (SQLException e) {	 
			 System.err.println(e.getMessage());
			 e.printStackTrace();
		 }
		 finally
		 {
			 try
			 {
				 conn.close();
			 }
			 catch (SQLException e)
			 {
			 }
		 }
	}
	
	public static void ViewCourseWaitlist(Scanner scanner)
	{
		Connection conn = null;
		try 
		{
			System.out.println("");
			System.out.println("-------- Course Waitlist ----------");
			System.out.println("");
			Course.viewAllCourseOfferings();
			System.out.print("Enter Course Offering ID: ");
			int courseOfferingID = scanner.nextInt();
			conn = DriverManager.getConnection(ConfigManager.DB_URL, ConfigManager.username,
					 ConfigManager.pwd);
			CallableStatement pstmt = conn.prepareCall("{call proc_ViewWaitlistedStudents(?,?)}");
			pstmt.setInt(1, courseOfferingID);
			pstmt.registerOutParameter(2, OracleTypes.CURSOR);
			pstmt.executeUpdate();
			 
			ResultSet rs = (ResultSet) pstmt.getObject(2);
			if (!rs.isBeforeFirst() ) {    
			    System.out.println("No students waitlisted this course."); 
			}
			else
			{
				System.out.printf("%-16s %-16s\n", "Unity ID", "Waitlist Position");
		        while (rs.next()) {
		        	System.out.printf("%-16s %-16s\n", rs.getString(1), rs.getInt(2));
		        }
			}
	        System.out.println("");
			pstmt.close();
		  }
		 catch (SQLException e) {	 
			 System.err.println(e.getMessage());
			 e.printStackTrace();
		 }
		 finally
		 {
			 try
			 {
				 conn.close();
			 }
			 catch (SQLException e)
			 {
			 }
		 }
	}
	
	public static void addNewCourse(Scanner scanner)
	{
		Connection conn = null;
		try 
		{
			System.out.println("");
			System.out.println("-------- Add New Course ----------");
			System.out.println("");
			System.out.print("Enter Course ID: ");
			String courseID = scanner.next();
			Department.viewAllDepartments();
			System.out.print("Enter Dept ID from above table: ");
			String deptID = scanner.next();
			scanner.nextLine();
			System.out.print("Enter Course Title: ");
			String title = scanner.nextLine();
			System.out.print("Enter Min Credits (>0): ");
			int minCredits = scanner.nextInt();
			System.out.print("Enter Max Credits: ");
			int maxCredits = scanner.nextInt();
			System.out.print("Enter Participation Level: (1-undergraduate, 2-graduate)");
			int participationLevel = scanner.nextInt();
			conn = DriverManager.getConnection(ConfigManager.DB_URL, ConfigManager.username,
					 ConfigManager.pwd);
			CallableStatement pstmt = conn.prepareCall("{call proc_NewCourse(?,?,?,?,?,?,?)}");
			pstmt.setString(1, courseID);
			pstmt.setString(2, deptID);
			pstmt.setString(3, title);
			pstmt.setInt(4, maxCredits);
			pstmt.setInt(5, minCredits);
			pstmt.setInt(6, participationLevel);
			pstmt.registerOutParameter(7, Types.VARCHAR);
			pstmt.executeUpdate();
			 
			String message = pstmt.getString(7);
			System.out.println(message);
	        System.out.println("");
			pstmt.close();
		 }
		 catch (SQLException e) {	 
			 System.err.println(e.getMessage());
			 e.printStackTrace();
		 }
		 finally
		 {
			 try
			 {
				 conn.close();
			 }
			 catch (SQLException e)
			 {
			 }
		 }
	}
	
	public static void addNewCourseOffering(Scanner scanner)
	{
		Connection conn = null;
		try 
		{
			System.out.println("");
			System.out.println("-------- Add New Course Offering----------");
			System.out.println("");
			Course.viewAllCourses();
			System.out.print("Enter Course ID from above table: ");
			int courseID = scanner.nextInt();
			Department.viewAllDepartments();
			System.out.print("Enter Dept ID from above table: ");
			String deptID = scanner.next();
			System.out.print("Enter Section ID: (1/2) ");
			int sectionID = scanner.nextInt();
			Semester.viewAllSemesters();
			System.out.print("Enter Semester ID from above table: ");
			int semesterID = scanner.nextInt();
			System.out.print("Enter ClassDays (1-Mon, 2-Tue, 3-Wed, 4-Thu, 5-Fri, 6-Mon-Wed, 7-Tue-Thu, 8-Mon-Wed-Fri, 9-Other): ");
			int classDays = scanner.nextInt();
			scanner.nextLine();
			DateFormat inFormat = new SimpleDateFormat( "yyyy-MM-dd hh:mm");
			System.out.print("Enter Start Time in 24 Hours Format (HH:mm) ");
			String startTime = "01/01/2017 " + scanner.next() + ":00";
			System.out.println(startTime);
			System.out.print("Enter End Time in 24 Hours Format (HH:mm): ");
			String endTime = "01/01/2017 " + scanner.next() + ":00";
			System.out.println(endTime);
			scanner.nextLine();
			System.out.print("Enter Location: ");
			String location = scanner.nextLine();
			System.out.print("Enter Total Seats Offered: ");
			int totalSeats = scanner.nextInt();
			System.out.print("Enter Waitlist limit: ");
			int waitlistLimit = scanner.nextInt();
			System.out.print("Enter minimum GPA requirement if any");
			float gpa = scanner.nextFloat();
			System.out.println(gpa);
			conn = DriverManager.getConnection(ConfigManager.DB_URL, ConfigManager.username,
					 ConfigManager.pwd);
			CallableStatement pstmt = conn.prepareCall("{call proc_NewCourseOffering(?,?,?,?,?,?,?,?,?,?,?,?)}");
			pstmt.setInt(1, courseID);
			pstmt.setString(2, deptID);
			pstmt.setInt(3, sectionID);
			pstmt.setInt(4, semesterID);
			pstmt.setInt(5, classDays);
			pstmt.setString(6, startTime);
			pstmt.setString(7, endTime);
			pstmt.setString(8, location);
			pstmt.setInt(9, totalSeats);
			pstmt.setInt(10, waitlistLimit);
			pstmt.setFloat(11, gpa);
			pstmt.registerOutParameter(12, Types.VARCHAR);
			pstmt.executeUpdate();
			 
			String message = pstmt.getString(12);
			System.out.println(message);
	        System.out.println("");
			pstmt.close();
		 }
		 catch (SQLException e) {	 
			 System.out.println(e.getMessage());
			 e.printStackTrace();
		 }
		 finally
		 {
			 try
			 {
				 conn.close();
			 }
			 catch (SQLException e)
			 {
			 }
		 }
	}
	
	public static void cleanupWaitlistCourse(Scanner scanner)
	{
		Connection conn = null;
		try 
		{
			System.out.println("");
			System.out.println("-------- Cleanup Waitlist ----------");
			System.out.println("");
			System.out.print("Enter Course Offering ID: ");
			int courseOfferingID = scanner.nextInt();
			conn = DriverManager.getConnection(ConfigManager.DB_URL, ConfigManager.username,
					 ConfigManager.pwd);
			CallableStatement pstmt = conn.prepareCall("{call proc_ClearWLCourseOff(?,?)}");
			pstmt.setInt(1, courseOfferingID);
			pstmt.registerOutParameter(2, Types.VARCHAR);
			pstmt.executeUpdate();
			 
			String message = pstmt.getString(2);
			System.out.println(message);
	        System.out.println("");
			pstmt.close();
		 }
		 catch (SQLException e) {	 
			 System.err.println(e.getMessage());
			 e.printStackTrace();
		 }
		 finally
		 {
			 try
			 {
				 conn.close();
			 }
			 catch (SQLException e)
			 {
			 }
		 }
	}
	
	public static void cleanupWaitlistSemester()
	{
		Connection conn = null;
		try 
		{
			System.out.println("");
			System.out.println("-------- Cleaning Up Waitlist for Semester ----------");
			System.out.println("");
			conn = DriverManager.getConnection(ConfigManager.DB_URL, ConfigManager.username,
					 ConfigManager.pwd);
			CallableStatement pstmt = conn.prepareCall("{call proc_ClearWLCurrSem(?)}");
			pstmt.registerOutParameter(1, Types.VARCHAR);
			pstmt.executeUpdate();

			String message = pstmt.getString(1);
			System.out.println(message);
	        System.out.println("");
			pstmt.close();
		 }
		 catch (SQLException e) {	 
			 System.err.println(e.getMessage());
			 e.printStackTrace();
		 }
		 finally
		 {
			 try
			 {
				 conn.close();
			 }
			 catch (SQLException e)
			 {
			 }
		 }
	}

	
	public static void cleanupRolls()
	{
		Connection conn = null;
		try 
		{
			System.out.println("");
			System.out.println("-------- Cleaning Up Rolls ----------");
			System.out.println("");
			conn = DriverManager.getConnection(ConfigManager.DB_URL, ConfigManager.username,
					 ConfigManager.pwd);
			CallableStatement pstmt = conn.prepareCall("{call proc_CleanupRolls(?)}");
			pstmt.registerOutParameter(1, Types.VARCHAR);
			pstmt.executeUpdate();

			String message = pstmt.getString(1);
			System.out.println(message);
	        System.out.println("");
			pstmt.close();
		 }
		 catch (SQLException e) {	 
			 System.err.println(e.getMessage());
			 e.printStackTrace();
		 }
		 finally
		 {
			 try
			 {
				 conn.close();
			 }
			 catch (SQLException e)
			 {
			 }
		 }
	}
	
	public static void viewAllCourseOfferingsForStudent(User user)
	{
		Connection conn = null;
		 try 
		 {
			conn = DriverManager.getConnection(ConfigManager.DB_URL, ConfigManager.username,
					 ConfigManager.pwd);
			CallableStatement pstmt = conn.prepareCall("{call proc_cOfferingsForMe(?,?)}");
			pstmt.setString(1, user._unityID);
			pstmt.registerOutParameter(2, OracleTypes.CURSOR);
			pstmt.executeUpdate();
			 
			ResultSet rs = (ResultSet) pstmt.getObject(2);
			System.out.println("");
			System.out.println("-------- Course Offerings ----------");
			System.out.println("");
			System.out.printf("%-16s %-32s %-16s %-16s %-16s\n", "Course Offer.ID", "Title", "Start time",
					"End Time", "Available Seats");
	        while (rs.next()) {
	        	System.out.printf("%-16s %-32s %-16s %-16s %-16s\n", rs.getString(1), rs.getString(2),
	                		rs.getString(3), rs.getString(4), rs.getString(6) + "/" + rs.getString(5)
	                		);
	        }
	        System.out.println("");
			pstmt.close();
		  }
		 catch (SQLException e) {	 
			 System.err.println(e.getMessage());
			 e.printStackTrace();
		 }
		 finally
		 {
			 try
			 {
				 conn.close();
			 }
			 catch (SQLException e)
			 {
			 }
		 }
	}

	public static void viewAllCourseOfferings()
	{
		Connection conn = null;
		 try 
		 {
			conn = DriverManager.getConnection(ConfigManager.DB_URL, ConfigManager.username,
					 ConfigManager.pwd);
			CallableStatement pstmt = conn.prepareCall("{call proc_ViewCourseOfferings(?)}");
			pstmt.registerOutParameter(1, OracleTypes.CURSOR);
			pstmt.executeUpdate();
			 
			ResultSet rs = (ResultSet) pstmt.getObject(1);
			System.out.println("");
			System.out.println("-------- Course Offerings ----------");
			System.out.println("");
			System.out.printf("%-16s %-32s %-16s %-16s %-16s\n", "Course Offer.ID", "Title", "Start time",
					"End Time", "Available Seats");
	        while (rs.next()) {
	        	System.out.printf("%-16s %-32s %-16s %-16s %-16s\n", rs.getString(1), rs.getString(2),
	                		rs.getString(3), rs.getString(4), rs.getString(6) + "/" + rs.getString(5)
	                		);
	        }
	        System.out.println("");
			pstmt.close();
		  }
		 catch (SQLException e) {	 
			 System.err.println(e.getMessage());
			 e.printStackTrace();
		 }
		 finally
		 {
			 try
			 {
				 conn.close();
			 }
			 catch (SQLException e)
			 {
			 }
		 }
	}
	
	public static void viewAllAllCourseOfferings()
	{
		Connection conn = null;
		 try 
		 {
			conn = DriverManager.getConnection(ConfigManager.DB_URL, ConfigManager.username,
					 ConfigManager.pwd);
			CallableStatement pstmt = conn.prepareCall("{call proc_ViewAllCourseOfferings(?)}");
			pstmt.registerOutParameter(1, OracleTypes.CURSOR);
			pstmt.executeUpdate();
			 
			ResultSet rs = (ResultSet) pstmt.getObject(1);
			System.out.println("");
			System.out.println("-------- Course Offerings ----------");
			System.out.println("");
			System.out.printf("%-16s %-32s %-16s %-16s %-16s\n", "Course Offer.ID", "Title", "Start time",
					"End Time", "Available Seats");
	        while (rs.next()) {
	        	System.out.printf("%-16s %-32s %-16s %-16s %-16s\n", rs.getString(1), rs.getString(2),
	                		rs.getString(3), rs.getString(4), rs.getString(6) + "/" + rs.getString(5)
	                		);
	        }
	        System.out.println("");
			pstmt.close();
		  }
		 catch (SQLException e) {	 
			 System.err.println(e.getMessage());
			 e.printStackTrace();
		 }
		 finally
		 {
			 try
			 {
				 conn.close();
			 }
			 catch (SQLException e)
			 {
			 }
		 }
	}
	
	public static void viewAllCourses()
	{
		Connection conn = null;
		 try 
		 {
			conn = DriverManager.getConnection(ConfigManager.DB_URL, ConfigManager.username,
					 ConfigManager.pwd);
			CallableStatement pstmt = conn.prepareCall("{call proc_ViewCourses(?)}");
			pstmt.registerOutParameter(1, OracleTypes.CURSOR);
			pstmt.executeUpdate();
			 
			ResultSet rs = (ResultSet) pstmt.getObject(1);
			System.out.println("");
			System.out.println("-------- Courses ----------");
			System.out.println("");
			System.out.printf("%-10s %-8s %-32s %-16s %-16s %-8s\n", "Course ID", "Dept ID", "title",
					"Min Credits", "Max Credits", "participationLevel");
	        while (rs.next()) {
	        	System.out.printf("%-10s %-8s %-32s %-16s %-16s %-8s\n", rs.getInt(1), rs.getString(2),
	                		rs.getString(3), rs.getInt(5), rs.getInt(4), rs.getInt(6)
	                		);
	        }
	        System.out.println("");
			pstmt.close();
		  }
		 catch (SQLException e) {	 
			 System.err.println(e.getMessage());
			 e.printStackTrace();
		 }
		 finally
		 {
			 try
			 {
				 conn.close();
			 }
			 catch (SQLException e)
			 {
			 }
		 }
	}
	
	public static void registerForCourse(Scanner scanner, User user)
	{
		Connection conn = null;	
		try 
		{
			System.out.println("");
			System.out.println("-------- Register for a Course Offering ----------");
			System.out.println("");
			Course.viewAllCourseOfferingsForStudent(user);
		    System.out.print("Enter Course Offering ID from above table: ");
		    String courseOfferingID = scanner.next();
		    System.out.print("Enter number of Credits: ");
		    int credits_number = scanner.nextInt();
		    System.out.println("");
            System.out.println("");
		    
			conn = DriverManager.getConnection(ConfigManager.DB_URL, ConfigManager.username,
					 ConfigManager.pwd);
			CallableStatement pstmt = conn.prepareCall("{call proc_EnrollCourse(?,?,?,?,?)}");
			pstmt.setString(1, user._unityID);
			pstmt.setString(2, courseOfferingID);
			pstmt.setInt(3, credits_number);
			pstmt.setNull(4, Types.NULL);
			pstmt.registerOutParameter(5, Types.VARCHAR);
			
			pstmt.executeUpdate();
			
			String success = pstmt.getString(5);
			System.out.println("Success message is: " + success);

			pstmt.close();
		}
		catch (SQLException e){	 
			System.err.println(e.getMessage());
			e.printStackTrace();
		}
		finally
		{
			try
			{
				conn.close();
			}
			catch (SQLException e)
			{
			}
		}
	}

	public static void dropCourse(Scanner scanner, User user)
	{
		Connection conn = null;	
		try 
		{
			System.out.println("");
			System.out.println("-------- Drop a Course----------");
			System.out.println("");
			//Course.viewAllCourseOfferingsForStudent(user);
		    System.out.print("Enter Course Offering ID: ");
		    int courseOfferingID = scanner.nextInt();
		    System.out.println("");
		    
			conn = DriverManager.getConnection(ConfigManager.DB_URL, ConfigManager.username,
					 ConfigManager.pwd);
			CallableStatement pstmt = conn.prepareCall("{call proc_DropCourse(?,?,?)}");
			pstmt.setString(2, user._unityID);
			pstmt.setInt(1, courseOfferingID);
			pstmt.registerOutParameter(3, Types.VARCHAR);
			
			pstmt.executeUpdate();
			
			String success = pstmt.getString(3);
			System.out.println("Success message is: " + success);
	
			pstmt.close();
		}
		catch (SQLException e){	 
			System.err.println(e.getMessage());
			e.printStackTrace();
		}
		finally
		{
			try
			{
				conn.close();
			}
			catch (SQLException e)
			{
			}
		}
	}
}
