import java.io.*;
import java.util.Arrays;
import java.math.*;

public class CountyYear {
	public static void main(String args[])throws IOException{
		BufferedReader br = new BufferedReader(new FileReader("county.csv"));
		int ctr=0,i,k=0;
		String line=br.readLine();
		String ip[]=null;
		line=br.readLine();		
		Age ages[]=new Age[103];
		for(i=0;i<103;i++)
			ages[i]=new Age();
		
		/**
		 * Parse dataset
		 */
		while((line=br.readLine()) != null){
			ip=line.split(",");	
			k=0;
			for(i=6;i<109;i++){
				ages[k++].add(Integer.parseInt(ip[i]));
			}
			i++;
			k=0;
			for(;i<213;i++){
				ages[k++].add(Integer.parseInt(ip[i]));
			}
		}
		
		/**
		 * Calculate percentile and median
		 */
//		int medians[]=new int[103];
//		PrintWriter writer = new PrintWriter("outputCounty.csv", "UTF-8");
//		for(i=0;i<103;i++){
//			ages[i].median();
//			medians[i] = ages[i].median;
//			writer.println(i+","+ages[i].median+","+ages[i].median1+","+ages[i].median9);
//			System.out.println(ages[i].median);
//		}
//		writer.close();
		
		/**
		 * Calculate overall median (~2515)
		 */
//		Arrays.sort(medians);
//		double median;
//		median = (double) medians[medians.length/2];
//		System.out.println(median);
		
		/**
		 * K-annonymity by birthdate
		 */
//		PrintWriter writer = new PrintWriter("outputCounty.csv", "UTF-8");
//		for(i=0;i<103;i++){
//			writer.println(i+","+ages[i].percentK(1)+","+ages[i].percentK(5)+","+ages[i].percentK(10));
//		}
//		writer.close();
		
		/**
		 * Overall unique
		 */
//		BigDecimal total=new BigDecimal(0),sum=new BigDecimal(0);
//		for(i=0;i<103;i++){
//			total=total.add(new BigDecimal(ages[i].total));
//			sum=sum.add(new BigDecimal(ages[i].nonpercentK(1)));
//		}
//		MathContext mc= new MathContext(20);
//		System.out.println(total+" stuff "+sum);
//		double percent = (sum.divide(total,mc).doubleValue())*100;
//		System.out.println(percent);
	}
}