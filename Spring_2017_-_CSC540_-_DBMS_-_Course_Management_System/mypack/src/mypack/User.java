package mypack;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Types;
import java.text.Format;
import java.text.SimpleDateFormat;
import java.util.Scanner;

import oracle.jdbc.OracleTypes;

public class User {
	protected String _unityID;
	private int _userType;
	private String _fname;
	private String _lname;
	private String _email;
	private String _gender;
	private String _address;
	private String _phno;
	private String _dob;
	
	public User(String unityID){
		this.set_unityID(unityID);
		this._fname = "";
		this._lname = "";
		this._email = "";
		this._gender = "";
	}

	/**
	 * @return the _unityID
	 */
	public String get_unityID() {
		return _unityID;
	}

	/**
	 * @param _unityID the _unityID to set
	 */
	public void set_unityID(String _unityID) {
		this._unityID = _unityID;
	}
	
	public void viewWaitlistedCourses()
	{
		Connection conn = null;
		try 
		{
			String unityID;
			conn = DriverManager.getConnection(ConfigManager.DB_URL, ConfigManager.username,
					 ConfigManager.pwd);
			CallableStatement pstmt = conn.prepareCall("{call proc_ViewWaitlistedCourses(?,?)}");
			unityID = this._unityID;
			pstmt.setString(1, unityID);
			pstmt.registerOutParameter(2, OracleTypes.CURSOR);
			pstmt.executeUpdate();
			 
			ResultSet rs = (ResultSet) pstmt.getObject(2);
			System.out.println("");
			System.out.println("-------- Waitlisted Courses ----------");
			System.out.println("");
			System.out.printf("%-16s %-32s %-16s\n", "Course Off ID", "Course Title", "Waitlist Position");
	        while (rs.next()) {
	               System.out.printf("%-16s %-32s %-16s\n", Integer.toString(rs.getInt(1)), rs.getString(2), Integer.toString(rs.getInt(3)));
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
	
	public void viewTranscript(boolean is_admin, Scanner scanner, String unity_ID)
	{
		Connection conn = null;
		 try 
		 {
			 String unityID;
			 conn = DriverManager.getConnection(ConfigManager.DB_URL, ConfigManager.username,
					 ConfigManager.pwd);
			 CallableStatement pstmt = conn.prepareCall("{call proc_ViewMyTranscript(?,?)}");
			 if (unity_ID.isEmpty())
			 {
				 if (is_admin)
				 {
					 User.getAllStudentDetails();
					 System.out.print("Enter unity ID from above table: ");
					 unityID = scanner.next();
				 }
				 else
				 {
					 unityID = this._unityID;
				 }
			 }
			 else
			 {
				 unityID = unity_ID;
			 }
			 
			 pstmt.setString(1, unityID);
			 pstmt.registerOutParameter(2, OracleTypes.CURSOR);
			 pstmt.executeUpdate();
			 
			 ResultSet rs = (ResultSet) pstmt.getObject(2);
			System.out.println("");
			System.out.println("-------- Transcript ----------");
			System.out.println("");
			 System.out.printf("%-16s %-24s %-8s %-16s\n", "Course ID", "Title", "Credits", "Course Grade");
	         while (rs.next()) {
	                System.out.printf("%-16s %-24s %-8s %-16s\n", rs.getString(1), rs.getString(2), Integer.toString(rs.getInt(3)), rs.getString(4));
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
	
	public void viewBill()
	{
		Connection conn = null;
		 try 
		 {
			conn = DriverManager.getConnection(ConfigManager.DB_URL, ConfigManager.username,
					 ConfigManager.pwd);
			CallableStatement pstmt = conn.prepareCall("{call proc_ViewMyBill(?,?)}");
			pstmt.setString(1, this._unityID);
			pstmt.registerOutParameter(2, OracleTypes.CURSOR);
			pstmt.executeUpdate();
			 
			ResultSet rs = (ResultSet) pstmt.getObject(2);
			System.out.println("");
			System.out.println("-------- Bill Statements ----------");
			System.out.println("");
			System.out.printf("%-16s %-16s %-16s %-16s\n", "Bill ID", "Bill Amount", "Due Date", "Outstanding Amount");
			Format formatter = new SimpleDateFormat("MM-dd-yyyy");
            while (rs.next()) {
                System.out.printf("%-16s %-16s %-16s %-16s\n", Integer.toString(rs.getInt(1)), Integer.toString(rs.getInt(2)), formatter.format(rs.getDate(3)), Integer.toString(rs.getInt(4)));
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

	public void payBill(Scanner scanner)
	{
		int billPaidAmount;
		Connection conn = null;
		try 
		{
			System.out.println("");
			System.out.println("-------- Pay Bill ----------");
			System.out.println("");
			System.out.print("Enter amount: ");
			billPaidAmount = scanner.nextInt();
			conn = DriverManager.getConnection(ConfigManager.DB_URL, ConfigManager.username,
				 ConfigManager.pwd);
			CallableStatement pstmt = conn.prepareCall("{call proc_PayBill(?,?,?)}");
			pstmt.setString(1, this._unityID);
			pstmt.setInt(2, billPaidAmount);
			pstmt.registerOutParameter(3, Types.VARCHAR);
			pstmt.executeUpdate();
			 
			String message = pstmt.getString(3);
             
            System.out.println("");
            System.out.println(message);
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
	
	public static void takeActionEnrollRequests(User user, Scanner scanner)
	{ int specialPermissionID;
	  String unityID;	
	  int approved;  
	
		Connection conn = null;
		try 
		{
			System.out.println("");
			System.out.println("-------- Approve/Reject Special Enrollment Requests ----------");
			System.out.println("");
			User.view_special_enrollment_requests();
			System.out.print("Enter special permission ID from above table: ");
			specialPermissionID = scanner.nextInt();
			//System.out.print("Enter your unity ID");
			unityID = user._unityID;
			System.out.print("Enter the approval status: 1 for Accept/0 for Reject: ");
			approved = scanner.nextInt();
			conn = DriverManager.getConnection(ConfigManager.DB_URL, ConfigManager.username,
					 ConfigManager.pwd);
				CallableStatement pstmt = conn.prepareCall("{call proc_ApproveRequest(?,?,?,?)}");
				pstmt.setInt(1, specialPermissionID);
				pstmt.setString(2, unityID);
				pstmt.setInt(3, approved);
				pstmt.registerOutParameter(4, Types.VARCHAR);
				pstmt.executeUpdate();
				
				String message = pstmt.getString(4);
	             
	            System.out.println("");
	            System.out.println(message);
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
	
	
	public static void enterGradeForStudent(Scanner scanner)
	{
		int courseOfferingID;
		String unityID;
		String grade;
		Connection conn = null;
		try 
		{
			System.out.println("");
			System.out.println("-------- Enter Grade for a Student ----------");
			System.out.println("");
			User.getAllStudentDetails();
			System.out.print("Enter unity ID from above table: ");
			unityID = scanner.next();
			User user = User.get_user_details(unityID);
			user.viewTranscript(false, scanner, unityID);
			System.out.print("Enter Course Offering ID from above table: ");
			courseOfferingID = scanner.nextInt();
			System.out.print("Enter Grade: ");
			grade = scanner.next();
			conn = DriverManager.getConnection(ConfigManager.DB_URL, ConfigManager.username,
				 ConfigManager.pwd);
			CallableStatement pstmt = conn.prepareCall("{call proc_EnterGrade(?,?,?,?)}");
			pstmt.setInt(1, courseOfferingID);
			pstmt.setString(2, unityID);
			pstmt.setString(3, grade);
			pstmt.registerOutParameter(4, Types.VARCHAR);
			pstmt.executeUpdate();
			 
			String message = pstmt.getString(4);
             
            System.out.println("");
            System.out.println(message);
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

	
	public static boolean authenticate_user(String unityID, String password)
	{
		Connection conn = null;
		
		 try 
		 {
			 conn = DriverManager.getConnection(ConfigManager.DB_URL, ConfigManager.username,
					 ConfigManager.pwd);
			 CallableStatement pstmt = conn.prepareCall("{call proc_CheckLogin(?,?,?)}");
			 pstmt.setString(1, unityID);
			 pstmt.setString(2, password);
			 pstmt.registerOutParameter(3, Types.INTEGER);
			 pstmt.executeUpdate();
	
			 int record_count = pstmt.getInt(3);
			 pstmt.close();
			 return (record_count > 0);
		  }
		 catch (SQLException e) {	 
			 System.err.println(e.getMessage());
			 return false;
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
	
	public static User get_user_details(String unityID)
	{
		Connection conn = null;
		
		 try 
		 {
			 conn = DriverManager.getConnection(ConfigManager.DB_URL, ConfigManager.username,
					 ConfigManager.pwd);
			 CallableStatement pstmt = conn.prepareCall("{call proc_GetUnityUserData(?,?,?,?,?,?)}");
			 pstmt.setString(1, unityID);
			 pstmt.registerOutParameter(2, Types.VARCHAR);
			 pstmt.registerOutParameter(3, Types.VARCHAR);
			 pstmt.registerOutParameter(4, Types.VARCHAR);
			 pstmt.registerOutParameter(5, Types.VARCHAR);
			 pstmt.registerOutParameter(6, Types.INTEGER);
			 pstmt.executeUpdate();
			 
			 User user_obj = new User(unityID);
	
			 user_obj._fname = pstmt.getString(2);
			 user_obj._lname = pstmt.getString(3);
			 user_obj._email = pstmt.getString(4);
			 user_obj._gender = pstmt.getString(5);
			 user_obj._userType = pstmt.getInt(6);
			 
			 pstmt.close();
			 return user_obj;
		  }
		 catch (SQLException e) {	 
			 System.err.println(e.getMessage());
			 return null;
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
	
	public static void view_special_enrollment_requests()
	{
		Connection conn = null;
		
		try
		{
			conn = DriverManager.getConnection(ConfigManager.DB_URL, ConfigManager.username,
					 ConfigManager.pwd);
			CallableStatement pstmt = conn.prepareCall("{call proc_ViewPermRequests(?)}");
          	pstmt.registerOutParameter(1, OracleTypes.CURSOR);
          	pstmt.executeUpdate();
          	
          	ResultSet rs = (ResultSet) pstmt.getObject(1);
          	System.out.println("");
          		System.out.println("-------- Special Enrollment Requests ----------");
          		System.out.println("");
          		
          		ResultSetMetaData rsmd = rs.getMetaData();
    			int columnsNumber = rsmd.getColumnCount();
    			System.out.printf("%-16s %-16s %-16s %-16s %-16s\n", "Special Perm. ID", "Unity ID", "Department ID", "Course ID", "Approval Status");
    			while (rs.next()) {
    				System.out.printf("%-16s %-16s %-16s %-16s %-16s\n", Integer.toString(rs.getInt(1)), rs.getString(2), rs.getString(3),
                    		rs.getString(4), rs.getString(5));
    				
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
	
	public static void takeActionEnrollRequests()
	{
		
	}
	
	public static void getAllStudentDetails()
	{
		Connection conn = null;
		
		 try 
		 {
			 conn = DriverManager.getConnection(ConfigManager.DB_URL, ConfigManager.username,
					 ConfigManager.pwd);
			 CallableStatement pstmt = conn.prepareCall("{call proc_ViewStudents(?)}");
			 pstmt.registerOutParameter(1, OracleTypes.CURSOR);
			 pstmt.executeUpdate();
			 
			 ResultSet rs = (ResultSet) pstmt.getObject(1);
			 System.out.println("");
				System.out.println("-------- Students' Details ----------");
				System.out.println("");
			 
			ResultSetMetaData rsmd = rs.getMetaData();
			int columnsNumber = rsmd.getColumnCount();
			System.out.printf("%-16s %-16s %-16s %-16s %-16s %-16s\n", "Unity ID", "Student ID", "First Name", "Last Name", "Gender", "GPA");
			Format formatter = new SimpleDateFormat("MM-dd-yyyy");
            while (rs.next()) {
                System.out.printf("%-16s %-16s %-16s %-16s %-16s %-16s\n", rs.getString(1), rs.getString(2),
                		rs.getString(3), rs.getString(4),
                		rs.getString(5),
                		Float.toString(rs.getFloat(6)));
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
	
	public void viewProfile()
	{
		Connection conn = null;
		
		 try 
		 {
			conn = DriverManager.getConnection(ConfigManager.DB_URL, ConfigManager.username,
					 ConfigManager.pwd);
			CallableStatement pstmt = conn.prepareCall("{call proc_getProfileData(?,?)}");
			pstmt.setString(1, this._unityID);
			pstmt.registerOutParameter(2, OracleTypes.CURSOR);
			pstmt.executeUpdate();
			 
			ResultSet rs = (ResultSet) pstmt.getObject(2);
			System.out.println("");
			System.out.println("-------- Profile Details ----------");
			System.out.println("");
			System.out.printf("%-16s %-16s %-16s %-16s %-16s %-16s %-16s %-16s\n", "Unity ID", "First Name", "Last Name", "Email", "Gender", "Date of Birth", "Address", "Phone");
			Format formatter = new SimpleDateFormat("MM-dd-yyyy");
			while (rs.next()) {
               System.out.printf("%-16s %-16s %-16s %-16s %-16s %-16s %-16s %-16s\n", rs.getString(1), rs.getString(2),
               		rs.getString(3), rs.getString(4),
               		rs.getString(5), formatter.format(rs.getDate(6)), rs.getString(7), rs.getString(8));
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
	
	public static void createNewUnityUser(Scanner scanner)
	{	
		System.out.println("");
		System.out.println("-------- New Unity User Account ----------");
		System.out.println("");
		System.out.print("Enter Unity ID: ");
	    String unityID = scanner.next();
	    User user = new User(unityID);
	    
	    System.out.print("Enter First Name: ");
	    user._fname = scanner.next();
	    System.out.print("Enter Last Name: ");
	    user._lname = scanner.next();
	    System.out.print("Enter email: ");
	    user._email = scanner.next();
	    System.out.print("Enter Gender (M/F): ");
	    user._gender = scanner.next();
	    System.out.print("Enter Date of Birth (MM/DD/YYYY): ");
	    user._dob = scanner.next();
	    scanner.nextLine();
	    System.out.print("Enter Address: ");
	    user._address = scanner.nextLine();
	    System.out.print("Enter Phone number: ");
	    user._phno = scanner.next();
	    System.out.print("Enter User Type (1-admin, 2-faculty, 3-student): ");
	    user._userType = scanner.nextInt();
	    
		Connection conn = null;
		
		try 
		{
			conn = DriverManager.getConnection(ConfigManager.DB_URL, ConfigManager.username,
					 ConfigManager.pwd);
			CallableStatement pstmt = conn.prepareCall("{call proc_NewUser(?,?,?,?,?,?,?,?,?,?)}");
			pstmt.setString(1, user._unityID);
			pstmt.setString(2, user._fname);
			pstmt.setString(3, user._lname);
			pstmt.setString(4, user._email);
			pstmt.setString(5, user._gender);
			pstmt.setString(6, user._dob);
			pstmt.setString(7, user._address);
			pstmt.setString(8, user._phno);
			pstmt.setInt(9, user._userType);
			pstmt.registerOutParameter(10, Types.VARCHAR);
			pstmt.executeUpdate();
			 
            System.out.println("");
            System.out.println("");
            String success = pstmt.getString(10);
            if (success.toLowerCase().contains("success"))
            {
            	System.out.println("Unity User Created Successfully.");
            }
            else
            {
            	System.out.println(success);
            }
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

	/**
	 * @return the is_admin
	 */
	public boolean is_admin() {
		return this._userType == 1;
	}
}
