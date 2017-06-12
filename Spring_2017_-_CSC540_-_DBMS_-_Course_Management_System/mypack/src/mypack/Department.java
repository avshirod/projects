package mypack;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;

import oracle.jdbc.OracleTypes;

public class Department {
	
	public static void viewAllDepartments()
	{
		Connection conn = null;
		ConfigManager config_manager = ConfigManager.getInstance();
		String DB_URL = config_manager.getValue("DB_URL");
		String user = config_manager.getValue("username");
		String pwd = config_manager.getValue("password");
		
		 try 
		 {
			 conn = DriverManager.getConnection(DB_URL, user, pwd);
			 CallableStatement pstmt = conn.prepareCall("{call proc_viewDepartments(?)}");
			 pstmt.registerOutParameter(1, OracleTypes.CURSOR);
			 pstmt.executeUpdate();
			 
			 ResultSet rs = (ResultSet) pstmt.getObject(1);
			System.out.println("");
			System.out.println("-------- Departments ----------");
			System.out.println("");
			 System.out.printf("%-16s %-16s\n", "Dept ID", "Name");
			 while (rs.next()) {
				 System.out.printf("%-16s %-16s\n", rs.getString(1), rs.getString(2)
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
