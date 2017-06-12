package mypack;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Scanner;

public class Login {
	public Login(){
	}
	public static void main(String[] args)
	{
		// create a scanner so we can read the command-line input	    
	    try
	    {
	    	ConfigManager.fillUpConfigValues();
	    	boolean is_authenticated=false;
	    	String enteredPassword;
	    	String unityID;
	    	boolean is_user_authenticated=false;
	    	while(!is_authenticated)
	    	{
	    		
	    		Scanner scanner = new Scanner(System.in);
	    		mainMenu(scanner);
			    //  prompt for the user's name
			    System.out.print("Enter your unity ID: ");
		
			    // get their input as a String
			    unityID = scanner.next();
			    
			    //  prompt for the user's name
			    System.out.print("Enter your password: ");
		
			    // get their input as a String
			    enteredPassword = scanner.next();
			    
			    is_user_authenticated = User.authenticate_user(unityID, enteredPassword);
			    if(is_user_authenticated)
			    {
			    	System.out.println("User authenticated!");
			    	System.out.println("");
			    	authenticated_user_menu(unityID);
			    }
			    else
			    {
			    	System.out.println("Invalid credentials, please try again!");
			    }
	    	}
	    }
	    finally {
	    }
	}
	
	private static void CreateNewAccount(Scanner scanner)
	{
		int response;
		while(true)
		{
			System.out.println("----------Create New Unity User / Student Account (Press 0 to go back)----------");
		    //System.out.println("Enter 0 to go back");
		    System.out.println("Enter 1 to Create a Unity User/Student Account");
		    System.out.println("Enter 2 to Create a New Student Record");
		    System.out.println("Enter: ");
		    // get their input as a String
		    
		    try
		    {
		    	response = scanner.nextInt();
		    }
		    catch(Exception e)
		    {
		    	System.out.println("Please enter valid input");
		    	continue;
		    }
		    switch(response){
		    case 1:
		    	User.createNewUnityUser(scanner);
		    	break;
		    case 2:
		    	Student.createNewStudentRecord(scanner);
		    	break;
		    default:
		    	return;
		    }
		}
	}
	
	
	
	private static void ViewAddCourses(Scanner scanner)
	{
		int response;
		while(true)
		{
			System.out.println("----------Create/View Courses (Press 0 to go back)----------");
		    System.out.println("Enter 1 to View all courses");
		    System.out.println("Enter 2 to Create a New Course");
		    System.out.println("Enter: ");
		    // get their input as a String
		    try
		    {
		    	response = scanner.nextInt();
		    }
		    catch(Exception e)
		    {
		    	System.out.println("Please enter valid input");
		    	continue;
		    }
		    switch(response){
		    case 1:
		    	Course.viewAllCourses();
		    	break;
		    case 2:
		    	Course.addNewCourse(scanner);
		    	break;
		    default:
		    	return;
		    }
		}
	}
	
	private static void ViewAddCourseOfferings(Scanner scanner)
	{
		int response;
		while(true)
		{
			System.out.println("----------Create/View Course Offerings (Press 0 to go back)----------");
		    System.out.println("Enter 1 to View all Course Offerings");
		    System.out.println("Enter 2 to View all Course Offerings in Current Semester");
		    System.out.println("Enter 3 to Create a New Course Offering");
		    System.out.println("Enter 4 to View Waitlist for a Course Offering");
		    System.out.println("Enter: ");
		    // get their input as a String
		    try
		    {
		    	response = scanner.nextInt();
		    }
		    catch(Exception e)
		    {
		    	System.out.println("Please enter valid input");
		    	continue;
		    }
		    switch(response){
		    case 1:
		    	Course.viewAllAllCourseOfferings();
		    	break;
		    case 2:
		    	Course.viewAllCourseOfferings();
		    	break;
		    case 3:
		    	Course.addNewCourseOffering(scanner);
		    	break;
		    case 4:
		    	Course.ViewCourseWaitlist(scanner);
		    	break;
		    default:
		    	return;
		    }
		}
	}
	
	private static void ViewAddSpecialEnrollmentRequests(User user, Scanner scanner)
	{
		int response;
		while(true)
		{
			System.out.println("----------View Special Enrollment requests / Take action (Press 0 to go back)---------");
			System.out.println("Enter 1 to view the list of special enrollment requests");
			System.out.println("Enter 2 to Approve/Reject Special Enrollment requests");
			System.out.println("Enter option: ");
			// get their input as a String
			try
			{
				response = scanner.nextInt();
			}
			catch(Exception e)
			{
				System.out.println("Please enter valid input");
		    	continue;
			}
			switch(response){
			case 1:
				User.view_special_enrollment_requests();
				break;
			case 2:
				User.takeActionEnrollRequests(user, scanner);
				break;
			default:
				return;
			}
		}
	}
	
	
	private static void ViewStudentsDetails(User user, Scanner scanner)
	{
		int response;
		while(true)
		{
			System.out.println("----------View Students Details / Take action (Press 0 to go back)----------");
			System.out.println("Enter 1 to view all Students' details");
		    System.out.println("Enter 2 to View Students Registered in a Course");
		    System.out.println("Enter 3 to View Transcript of a Student");
		    System.out.println("Enter 4 to Enter Grade for Student");
		    System.out.println("Enter: ");
		    // get their input as a String
		    try
		    {
		    	response = scanner.nextInt();
		    }
		    catch(Exception e)
		    {
		    	System.out.println("Please enter valid input");
		    	continue;
		    }
		    switch(response){
		    case 1:
		    	User.getAllStudentDetails();
		    	break;
		    case 2:
		    	Course.ViewStudentsRegisteredInCourse(scanner);
		    	break;
		    case 3:
		    	user.viewTranscript(true, scanner, "");
		    	break;
		    case 4:
		    	User.enterGradeForStudent(scanner);
		    	break;
		    default:
		    	return;
		    }
		}
	}
	
	private static void EnforceDeadline(Scanner scanner){
		int response;
		while(true){
			System.out.println("-------- Enforce Add/Drop Deadline (Press 0 to go back) --------");
			System.out.println("Enter 1 to Enforce Add/Drop Deadline");
			System.out.println("*** Remember that this cannot be undone. ***");
			System.out.println();
			System.out.println("Enter: ");
		    // get their input as a String
		    try
		    {
		    	response = scanner.nextInt();
		    }
		    catch(Exception e)
		    {
		    	System.out.println("Please enter valid input");
		    	continue;
		    }
		    switch(response){
		    case 1:
		    	Course.cleanupWaitlistSemester();
		    	Course.cleanupRolls();
		    	return;
		    default:
		    	return;
		    }
		}
	}
	
	private static void ViewEnrollDropCourse(User user, Scanner scanner)
	{
		int response;
		while(true)
		{
			System.out.println("----------View / Enroll / Drop Course (Press 0 to go back)----------");
			System.out.println("Enter 1 to View Course Offerings");
		    System.out.println("Enter 2 to Enroll for a Course Offering");
		    System.out.println("Enter 3 to Drop Course");
		    System.out.println("Enter: ");
		    // get their input as a String
		    try
		    {
		    	response = scanner.nextInt();
		    }
		    catch(Exception e)
		    {
		    	System.out.println("Please enter valid input");
		    	continue;
		    }
		    switch(response){
		    case 1:
		    	Course.viewAllCourseOfferings();
		    	break;
		    case 2:
		    	Course.registerForCourse(scanner, user);
		    	break;
		    case 3:
		    	Course.dropCourse(scanner, user);
		    	break;
		    default:
		    	return;
		    }
		}
	}
	
	private static void ViewPendingCourses(User user, Scanner scanner)
	{
		int response;
		while(true)
		{
			System.out.println("----------View Pending Courses (Press 0 to go back)----------");
			System.out.println("Enter 1 to View Waitlisted Courses");
		    System.out.println("Enter: ");
		    // get their input as a String
		    try
		    {
		    	response = scanner.nextInt();
		    }
		    catch(Exception e)
		    {
		    	System.out.println("Please enter valid input");
		    	continue;
		    }
		    switch(response){
		    case 1:
		    	user.viewWaitlistedCourses();
		    	break;
		    default:
		    	return;
		    }
		}
	}
	
	private static void ViewTranscript(User user, Scanner scanner)
	{
		int response;
		while(true)
		{
			System.out.println("----------View Transcript / Grades (Press 0 to go back)----------");
			System.out.println("Enter 1 to View Transcript");
		    System.out.println("Enter: ");
		    // get their input as a String
		    try
		    {
		    	response = scanner.nextInt();
		    }
		    catch(Exception e)
		    {
		    	System.out.println("Please enter valid input");
		    	continue;
		    }
		    switch(response){
		    case 1:
		    	user.viewTranscript(false, scanner, "");
		    	break;
		    default:
		    	return;
		    }
		}
	}
	
	private static void ViewPayBill(User user, Scanner scanner)
	{
		int response;
		while(true)
		{
			System.out.println("----------View/Pay Bill (Press 0 to go back)----------");
			System.out.println("Enter 1 to View Bill Statements");
		    System.out.println("Enter 2 to Pay Bill");
		    System.out.println("Enter: ");
		    // get their input as a String
		    try
		    {
		    	response = scanner.nextInt();
		    }
		    catch(Exception e)
		    {
		    	System.out.println("Please enter valid input");
		    	continue;
		    }
		    switch(response){
		    case 1:
		    	user.viewBill();
		    	break;
		    case 2:
		    	user.payBill(scanner);
		    	break;
		    default:
		    	return;
		    }
		}
	}
	
	private static void mainMenu(Scanner scanner)
	{
		int response;
		while(true)
		{
			System.out.println("---------- Main Menu ----------");
			System.out.println("Enter 1 to Login");
		    System.out.println("Enter 2 to Exit");
		    System.out.println("Enter: ");
		    // get their input as a String
		    try
		    {
		    	response = scanner.nextInt();
		    }
		    catch(Exception e)
		    {
		    	System.out.println("Please enter valid input");
		    	continue;
		    }
		    switch(response){
		    case 1:
		    	return;
		    case 2:
		    	System.out.println("Exiting Program!");
		    	System.exit(0);
		    default:
		    	System.exit(0);
		    }
		}
	}
		
	private static void authenticated_user_menu(String unityID)
	{
		User authenticated_user = User.get_user_details(unityID);
		Scanner scanner = new Scanner(System.in);
		int response;
		boolean breakout = false;
		try
	    {
			if (authenticated_user.is_admin())
			{			    
				while(true)
				{
					System.out.println("---------- Main Admin Menu (Press 0 to logout)-----------");
				    System.out.println("Enter 1 to View Profile");
				    System.out.println("Enter 2 to Enroll a new Student");
				    System.out.println("Enter 3 to View Student's Details");
				    System.out.println("Enter 4 to View/Add Courses");
				    System.out.println("Enter 5 to View/Add Course Offerings");
				    System.out.println("Enter 6 to View/Add Special Enrollment Requests");
				    System.out.println("Enter 7 to Enforce Add/Drop Deadline");
				    
				    
			
				    System.out.println("Enter: ");
				    // get their input as a String
				    response = scanner.nextInt();
				    
				    switch(response){
				    case 1:
				    	authenticated_user.viewProfile();
				    	break;
				    case 2:
				    	CreateNewAccount(scanner);
				    	break;
				    case 3:
				    	ViewStudentsDetails(authenticated_user, scanner);
				    	break;
				    case 4:
				    	ViewAddCourses(scanner);
				    	break;
				    case 5:
				    	ViewAddCourseOfferings(scanner);
				    	break;
				    case 6:
				    	ViewAddSpecialEnrollmentRequests(authenticated_user, scanner);
				    	break;
				    case 7:
				    	EnforceDeadline(scanner);
				    	break;
				    default:
				    	System.out.println("");
				    	System.out.println("You are now logged out.");
				    	System.out.println("");
				    	breakout = true; 
				    	break;
				    }
				    if (breakout) break;
				}
				if (breakout) return;
			}
			else
			{
				while(true)
				{
					System.out.println("---------- Student Menu (Press 0 to logout)-----------");
					System.out.println("Enter 1 to View Profile");
					System.out.println("Enter 2 to View/Enroll/Drop Course");
					System.out.println("Enter 3 to Pending Courses");			    
				    System.out.println("Enter 4 to View Grades");
				    System.out.println("Enter 5 to View/Pay Bill");
			
				    System.out.println("Enter: ");
				    // get their input as a String
				    response = scanner.nextInt();
				    
				    switch(response){
				    case 1:
				    	authenticated_user.viewProfile();
				    	break;
				    case 2:
				    	ViewEnrollDropCourse(authenticated_user, scanner);
				    	break;
				    case 3:
				    	ViewPendingCourses(authenticated_user, scanner);
				    	break;
				    case 4:
				    	ViewTranscript(authenticated_user, scanner);
				    	break;
				    case 5:
				    	ViewPayBill(authenticated_user, scanner);
				    	break;
				    default:
				    	System.out.println("");
				    	System.out.println("You are now logged out.");
				    	System.out.println("");
				    	breakout = true;
				    	break;
				    }
				    if (breakout) break;
				}
				if (breakout) return;
			}
	    }
	    finally {
	    }
	}
}
