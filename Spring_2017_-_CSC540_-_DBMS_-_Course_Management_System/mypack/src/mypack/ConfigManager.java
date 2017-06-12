/**
 * 
 */
package mypack;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Properties;

/**
 * @author gauravaradhye
 *
 */
public class ConfigManager {

	/**
	 * 
	 */
	
	private static ConfigManager config_manager = new ConfigManager();
	public static String DB_URL;
	public static String username;
	public static String pwd;
	private ConfigManager() {
	}
	
	public static ConfigManager getInstance() {
	      return config_manager;
	}
	
	public static void fillUpConfigValues()
	{		
		ConfigManager.DB_URL = "jdbc:oracle:thin:@//orca.csc.ncsu.edu:1521/orcl.csc.ncsu.edu";
		ConfigManager.username = "garadhy";
		ConfigManager.pwd = "200084098";
	}
	
	public String getValue(String key)
	{
		Properties prop = new Properties();
		InputStream input = null;
		String output = "";
		try {
			input = new FileInputStream("config.properties");
			prop.load(input);
			output = prop.get(key).toString();
			return output;
		} catch (IOException io) {
			io.printStackTrace();
			return output;
		} finally {
			if (input != null) {
				try {
					input.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
	}
	
	public void setValue(String key, String value)
	{
		Properties prop = new Properties();
		OutputStream output = null;
		try {
			output = new FileOutputStream("config.properties");
			//prop.load(output);
			prop.setProperty(key, value);
		} catch (IOException io) {
			io.printStackTrace();
		} finally {
			if (output != null) {
				try {
					output.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
	}
}
