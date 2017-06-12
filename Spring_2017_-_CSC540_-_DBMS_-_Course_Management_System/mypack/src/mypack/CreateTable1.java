package mypack;

import java.sql.*;

public class CreateTable1 {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		
		ConfigManager config_manager = ConfigManager.getInstance();
		Connection conn = null;
		Statement query1 = null;
		PreparedStatement query2 = null;
		Statement query3 = null;
		String JDBC_Driver = config_manager.getValue("JDBC_Driver");
		String DB_URL = config_manager.getValue("DB_URL");
		String user = config_manager.getValue("username");
		String pwd = config_manager.getValue("password");
		
		try{
			// Registering JDBC Driver
			Class.forName(JDBC_Driver);
			
			// Opening a Connection
			conn = DriverManager.getConnection(DB_URL, user, pwd);
			
			// Creating Statement Object
			query1 = conn.createStatement();
			
			// Setting Auto-commit to False
			conn.setAutoCommit(false);
			
			// Creating SQL Statements
			String sql = 	"CREATE TABLE Students3 (unityID CHAR(8), fname VARCHAR(255), lname VARCHAR(255)," + 
							"PRIMARY KEY(unityID))";
			
			// Add SQL to the batch
			query1.addBatch(sql);
			query1.executeBatch();
			
			// Prepared Statement Example
			String sql2 = 	"INSERT INTO Students3 (unityID, fname, lname) " + 
							"VALUES(?,?,?)";
			query2 = conn.prepareStatement(sql2);
			
			// Set the variables
			query2.setString(1, "avshirod");
			query2.setString(2, "Aditya");
			query2.setString(3, "Shirode");
			query2.addBatch();
			
			query2.setString(1, "garadhy");
			query2.setString(2, "Gaurav");
			query2.setString(3, "Aradhye");
			query2.addBatch();
			
			query2.setString(1, "asupeka");
			query2.setString(2, "Anuja");
			query2.setString(3, "Supekar");
			query2.addBatch();
			
			query2.executeBatch();
			
			// query1.executeUpdate(sql1);
			conn.commit();
			
			System.out.println("Executed Query");
			
			// Printing the data
			query3 = conn.createStatement();
			
			String sql3 = "SELECT * FROM Students";
			ResultSet rs = query3.executeQuery(sql3);
			
			while (rs.next()){
				String unityID = rs.getString("unityID");
				String name = rs.getString("fname") + " " + rs.getString("lname");
				
				System.out.println(unityID + "\t" + name);
			}
			rs.close();
			
			/*
			 * 	Statement createTables = null;

				createTables = conn.createStatement();
				conn.setAutoCommit(false);
				
				String query_createStudent = "";
				createTables.addBatch(query_createStudent);
				
				createTables.executeBatch();
				

			 */
		}
		catch (SQLException | ClassNotFoundException se){
			se.printStackTrace();
		}
		finally{
			try{
				if (query1 != null)
					query1.close();
				if (query2 != null)
					query2.close();
				if (query3 != null)
					query3.close();
			}
			catch (SQLException se){}
			try{
				if (conn != null)
					conn.close();
			}
			catch (SQLException se){}
		}
		System.out.println("Successful");
	}

}
