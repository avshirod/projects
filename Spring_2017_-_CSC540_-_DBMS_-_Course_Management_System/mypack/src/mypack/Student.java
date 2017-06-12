package mypack;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Scanner;

import oracle.jdbc.OracleTypes;

public class Student extends User{
	public Student(String unityID) {
		super(unityID);
	}
	
	private String _studentID;
	private String _deptID;
	private int _participationLevel;
	private int _residencyLevel;
	private String _yearEnrolled;
	
	
	public static boolean ExistUser(String unityID){
		Connection conn = null;
		CallableStatement pstmt = null;
		
		 try 
		 {
			 conn = DriverManager.getConnection(ConfigManager.DB_URL, ConfigManager.username,
					 ConfigManager.pwd);
			 pstmt = conn.prepareCall("{call proc_ExistUser(?,?)}");
			 pstmt.setString(1, unityID);
			 pstmt.registerOutParameter(2, Types.NUMERIC);
			 pstmt.executeUpdate();
			 System.out.println("");
			 int userFound = pstmt.getInt(2);
			 if (userFound == 1)
			 {
				 return true;
			 }
			 else
			 {
				 //System.out.println(successMessage);
				 return false;
			 }
		  }
		 catch (SQLException e) {	 
			 System.err.println(e.getMessage());
			 e.printStackTrace();
		 }
		 finally
		 {
			 try
			 {
				 pstmt.close();
				 conn.close();
			 }
			 catch (SQLException e)
			 {
			 }
		 }
		 return false;
	}

	
	public static void createNewStudentRecord(Scanner scanner)
	{
		System.out.print("Enter unity ID: ");
	    String unityID = scanner.next();
	    if (ExistUser(unityID) == false){
	    	System.out.println("Unity ID does not exist. Please check input.");
	    	return;
	    }
	    Student student = new Student(unityID);
	    
	    System.out.print("Enter Student ID (Any number): ");
	    student._studentID = scanner.next();
	    Department.viewAllDepartments();
	    System.out.print("Enter Department ID from above table: ");
	    student._deptID = scanner.next().toUpperCase();
	    System.out.print("Enter Participation Level(1-UnderGraduate / 2-Graduate): ");
	    student._participationLevel = scanner.nextInt();
	    System.out.print("Enter Residency Level:(1-in-state / 2-out-state / 3-International ");
	    student._residencyLevel = scanner.nextInt();
	    System.out.print("Enter Year Enrolled: ");
	    student._yearEnrolled = scanner.next();
	    
		Connection conn = null;
		
		 try 
		 {
			 conn = DriverManager.getConnection(ConfigManager.DB_URL, ConfigManager.username,
					 ConfigManager.pwd);
			 CallableStatement pstmt = conn.prepareCall("{call newStudent(?,?,?,?,?,?,?)}");
			 pstmt.setString(1, student._unityID);
			 pstmt.setString(2, student._studentID);
			 pstmt.setString(3, student._deptID);
			 pstmt.setInt(4, student._residencyLevel);
			 pstmt.setInt(5, student._participationLevel);
			 pstmt.setString(6, student._yearEnrolled);
			 pstmt.registerOutParameter(7, Types.VARCHAR);
			 pstmt.executeUpdate();
			 System.out.println("");
			 String successMessage = pstmt.getString(7);
			 if (successMessage.toLowerCase().contains("parent key not found"))
			 {
				 System.out.println("Please add unity user first with the unity ID: " + student._unityID);
			 }
			 else
			 {
				 System.out.println(successMessage);
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
}
