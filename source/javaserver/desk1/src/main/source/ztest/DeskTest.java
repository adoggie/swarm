package ztest;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpException;
import org.apache.commons.httpclient.methods.GetMethod;

/**
 * @author sunxy
 * @version 2015-6-19
 * @des 
 **/
public class DeskTest {

	public static void main(String[] args) {
		try {
			String url = "https://hehong.desk.com";
			HttpClient hc = new HttpClient();
			GetMethod get = new GetMethod(url);
			get.setRequestHeader("API_CONSUMER_KEY", "35i9pwdXC6ZXGUhqGjgK");
			get.setRequestHeader("API_CONSUMER_SECRET", "eQgQ6B6uGLzC9q1FH5E1gYRvx7K2iEatlP3EcxOb");
			System.out.println("1111111111");
			int a = hc.executeMethod(get);
			System.out.println("2222222222:"+a);
			//String responseBody = get.getResponseBodyAsString();
//		getResponseBodyAsStream
			InputStream is = get.getResponseBodyAsStream();
			BufferedReader br = new BufferedReader(new InputStreamReader(is));
			StringBuffer stringBuffer = new StringBuffer();
			String str= "";
			while((str = br.readLine()) != null){
				stringBuffer.append(str);
			}
			System.out.println(a+":"+stringBuffer.toString());
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
