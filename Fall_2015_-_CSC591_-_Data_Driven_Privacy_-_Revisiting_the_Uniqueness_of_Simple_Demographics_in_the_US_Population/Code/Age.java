import java.util.Arrays;
import java.math.*;

public class Age{
	int val[];
	int pos;
	int total;
	int median;
	int median9;
	int median1;
	Age(){
		val=new int[33178*2];//3219
		pos=0;
		total=0;
	}
	void add(int n){
		val[pos]=n;
		total+=n;
		pos++;
	}
	void median(){
		Arrays.sort(val);
		int mid = this.total/2;
		int runningsum=0;
		int i=0;
		while(runningsum<mid){
			runningsum+=val[i++];
		}
		median=val[i-1];
		
		mid = (int)((double)this.total * 0.1);
		runningsum=0;
		i=0;
		while(runningsum<mid){
			runningsum+=val[i++];
		}
		median1=val[i-1];
		
		mid = (int)((double)this.total * 0.9);
		runningsum=0;
		i=0;
		while(runningsum<mid){
			runningsum+=val[i++];
		}
		median9=val[i-1];
	}
	double percentK(int k){
		double sum=0;
		for(int i=0;i<pos;i++)
			sum+=threshold(val[i], k);
//			if(val[i]>0 && val[i]<=threshold(val[i], k))
//				sum+=val[i];
		return (sum/(double)total)*100;
	}
	double nonpercentK(int k){
		double sum=0;
		for(int i=0;i<pos;i++)
			sum+=threshold(val[i], k);
//			if(val[i]>0 && val[i]<=threshold(val[i], k))
//				sum+=val[i];
		return sum;
	}
	double threshold(int n,int k){
		if(k<1)
			return 0;
		MathContext mc=new MathContext(20);//precision 
		BigDecimal result=new BigDecimal(1);
		for(int i=0;i<k;i++)
			result=result.multiply(new BigDecimal(n-i), mc);
		result=result.divide(new BigDecimal(factorial(k)), mc);
		result=result.multiply(new BigDecimal(364).pow(n-k, mc),mc);
		result=result.divide(new BigDecimal(365).pow(n-1, mc),mc);
		return result.doubleValue()+threshold(n,k-1);
	}
	int factorial(int n){
		int fact=1;
		for(int i=2;i<=n;i++)
			fact*=i;
		return fact;
	}
}