package cn.fx.desk.zoo;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URL;
import java.util.Random;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpException;
import org.apache.commons.httpclient.HttpStatus;
import org.apache.commons.httpclient.NameValuePair;
import org.apache.commons.httpclient.methods.GetMethod;
import org.apache.commons.httpclient.methods.PostMethod;
import org.apache.commons.httpclient.methods.PutMethod;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;

import net.sf.json.JSONObject;

/**
 * @author sunxy
 * @version 2015-6-15
 * @des 一些通用的处理方法
 **/
public class GeneralMethod {

	/**
	 * @param urlStr		请求的url地址
	 * @param method 		GET/POST
	 * @param charsetName	编码方式，可以传null--默认为UTF-8
	 * @return 从指定的URL获取返回数据
	 */
	public static String getDataFromUrl(String urlStr,String method,String charsetName){
		StringBuffer res = new StringBuffer(); 
		if(charsetName == null){
			charsetName = FxConstant.CHARSET_DEFAULT;
		}
		java.net.HttpURLConnection conn = null;
		try {
			URL url = new URL(urlStr);
			conn = (java.net.HttpURLConnection)url.openConnection();
			conn.setDoOutput(true);
			conn.setRequestMethod(method);//POST、GET
			java.io.BufferedReader in = new java.io.BufferedReader(new java.io.InputStreamReader(conn.getInputStream(),charsetName));
			String line;
			while ((line = in.readLine()) != null) {
				res.append(line);
			}
			System.out.println("getDataFromUrl:"+urlStr);
			in.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return res.toString();
	}
	/**
	 * @param urlStr
	 * @param method GET/POST
	 * @return 以json格式返回结果
	 */
	public static JSONObject getJsonFromUrl(String urlStr,String method){
		String data = getDataFromUrl(urlStr, method,FxConstant.CHARSET_DEFAULT);
System.out.println("getJsonFromUrl data:"+data);
		try {
			JSONObject datajson = JSONObject.fromObject(data);
			return datajson;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	/**
	 * 
	 * @param apiUrl
	 * @param accessToken
	 * @throws Exception
	 */
	public static String requestHeaderSfAPI(String apiUrl,String accessToken) throws Exception{
		String url = apiUrl;
		HttpClient hc = new HttpClient();
		GetMethod get = new GetMethod(url);
		get.setRequestHeader("Authorization", "OAuth "+accessToken);
		int a = hc.executeMethod(get);
		//String responseBody = get.getResponseBodyAsString();
//		getResponseBodyAsStream
		InputStream is = get.getResponseBodyAsStream();
		BufferedReader br = new BufferedReader(new InputStreamReader(is,FxConstant.CHARSET_DEFAULT));
		StringBuffer stringBuffer = new StringBuffer();
		String str= "";
		while((str = br.readLine()) != null){
			stringBuffer.append(str);
		}
		is.close();
System.out.println("从salesforce获取数据:"+apiUrl);
		return stringBuffer.toString();
	}
	/**
	 * 基于账号密码的方式获取接入平台的信息
	 * @param url
	 * @param username
	 * @param password
	 * @param notiUrl	获取失败通知，通知url,可以为空
	 */
	public static String httbBasicByUsername(String url,String username,String password){
		try {
			byte[] token = (username + ":" + password).getBytes("utf-8");
			String encodedAuthorization = new String(Base64.encodeBase64(token), "utf-8");
			HttpClient hc = new HttpClient();
			GetMethod get = new GetMethod(url);
			get.setRequestHeader("Authorization", "Basic "+ encodedAuthorization);
			int a = hc.executeMethod(get);//200成功,否则需要处理异常
			System.out.println(a);
			
			InputStream is = get.getResponseBodyAsStream();
			BufferedReader br = new BufferedReader(new InputStreamReader(is));
			StringBuffer stringBuffer = new StringBuffer();
			String str= "";
			while((str = br.readLine()) != null){
				stringBuffer.append(str);
			}
			is.close();
	System.out.println("responseBody:"+stringBuffer.toString());
			return stringBuffer.toString();
		} catch(Exception e) {
		    e.printStackTrace();
		}
		return null;
	}
	/** 
	 * @param url
	 * @param username
	 * @param password
	 * @param notiUrl	获取失败通知，通知url,可以为空
	 */
	public static JSONObject httbBasicByUsernameJson(String url,String username,String password){
		String data = httbBasicByUsername(url, username, password);
		try {
			JSONObject datajson = JSONObject.fromObject(data);
			return datajson;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	/**
	 * 返回批次号
	 * @return
	 */
	public static String getBatchId(){
		return getRandomString(6);
	}
	/**
	 * 获取指定长度的随机字符串
	 * @param length
	 * @return
	 */
	public static String getRandomString(int length) {
	    String base = "abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_";
	    int strlength = base.length();
	    Random random = new Random();
	    StringBuffer sb = new StringBuffer();   
	    for (int i = 0; i < length; i++) {
	        int number = random.nextInt(strlength);
	        sb.append(base.charAt(number));
	    }
	    return sb.toString();
	 }
	public static void main(String[] args) {
		String url = "https://login.salesforce.com/services/oauth2/token?grant_type=authorization_code&code=aPrxqJ8A8kLOza9ocxG00W1unl5YZOxBDq7ywy0nYjRglPvWfPrdJq11lRJ0GORrn3pbLZwfjw==&client_id=3MVG9ZL0ppGP5UrB2Y_hVvDwIhz11aaTxV2fW7zZQ3cJh8CAKU59YBK_eFlgJSQTzVVGqcgbx_tzPy.KuYHfE&client_secret=965006733835029946&redirect_uri=https://192.168.36.62:8443/desk/ap/sfcallback.do";
		String taskUrl = "http://172.20.0.192:8800/desk/WEBAPI/connector/task.do";
		/*HttpClient hc = new HttpClient();
		PostMethod post = new PostMethod(taskUrl);*/
		try {
			/*int result = hc.executeMethod(post);
			System.out.println(result);
			System.out.println(post.getResponseBodyAsString());*/
			
			String url1 = "test.com";
		    JSONObject params = new JSONObject();
		    params.put("task_id", "task_id");
		    params.put("callback_uri", "callback_uri");
		    params.put("job", "job");
		    JSONObject param3 = new JSONObject();
		    param3.put("user_acct", "user_acct");
		    param3.put("biz_model", 1);
		    /*JSONArray params2 = new JSONArray();
		    params2.add(param3);
		    params.put("job", params2);*/
		    params.put("job", param3);
		    String ret = doPost(taskUrl, params).toString();
		    System.out.println(ret);
		}catch (Exception e) {
			e.printStackTrace();
		}
	}
	public static JSONObject doPost(String url,JSONObject json){
	    DefaultHttpClient client = new DefaultHttpClient();
	    HttpPost post = new HttpPost(url);
	    JSONObject response = null;
	    try {
	      StringEntity s = new StringEntity(json.toString());
	      s.setContentEncoding("UTF-8");
	      s.setContentType("application/json");//发送json数据需要设置contentType
	      post.setEntity(s);
	      HttpResponse res = client.execute(post);
	      if(res.getStatusLine().getStatusCode() == HttpStatus.SC_OK){
	        HttpEntity entity = res.getEntity();
	        String result = EntityUtils.toString(res.getEntity());// 返回json格式：
	        response = JSONObject.fromObject(result);
	      }
	    } catch (Exception e) {
	      throw new RuntimeException(e);
	    }
	    return response;
	  }
	public static JSONObject postParms(String url,NameValuePair[] param){
		HttpClient hc = new HttpClient();
		PostMethod method = new PostMethod(url);
		method.setRequestHeader("Content-Type","application/x-www-form-urlencoded;charset=utf-8");  
		method.addParameters(param);
		InputStream is = null;
		try {
			int a = hc.executeMethod(method);
			is = method.getResponseBodyAsStream();
			BufferedReader br = new BufferedReader(new InputStreamReader(is));
			StringBuffer stringBuffer = new StringBuffer();
			String str= "";
			while((str = br.readLine()) != null){
				stringBuffer.append(str);
			}
			return JSONObject.fromObject(stringBuffer.toString());
		} catch (HttpException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} finally{
			method.releaseConnection();
		}
	    return null;
	}
}
