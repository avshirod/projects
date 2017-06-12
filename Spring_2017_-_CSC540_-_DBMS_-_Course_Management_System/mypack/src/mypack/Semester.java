package mypack;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.Format;
import java.text.SimpleDateFormat;

import oracle.jdbc.OracleTypes;

public class Semester {
	public static void viewAllSemesters()
	{
		Connection conn = null;
		ConfigManager config_manager = ConfigManager.getInstance();
		String DB_URL = config_manager.getValue("DB_URL");
		String user = config_manager.getValue("username");
		String pwd = config_manager.getValue("password");
		
		 try 
		 {
			 conn = DriverManager.getConnection(DB_URL, user, pwd);
			 CallableStatement pstmt = conn.prepareCall("{call proc_viewAllSemesters(?)}");
			 pstmt.registerOutParameter(1, OracleTypes.CURSOR);
			 pstmt.executeUpdate();
			 
			 ResultSet rs = (ResultSet) pstmt.getObject(1);
			System.out.println("");
			System.out.println("-------- Semesters ----------");
			System.out.println("");
			 System.out.printf("%-16s %-16s %-16s %-16s %-16s %-16s %-16s\n", "Semester ID", "Season", "Year", "Add Date", "Drop Date", "Start Date", "End Date");
			 Format formatter = new SimpleDateFormat("MM-dd-yyyy");
			 while (rs.next()) {
				 System.out.printf("%-16s %-16s %-16s %-16s %-16s %-16s %-16s\n", rs.getInt(1), rs.getString(2),
						 rs.getInt(3), formatter.format(rs.getDate(4)), formatter.format(rs.getDate(5)), formatter.format(rs.getDate(6)),
						 formatter.format(rs.getDate(7))
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
}
