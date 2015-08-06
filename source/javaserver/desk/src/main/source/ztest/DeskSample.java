package ztest;

import java.io.IOException;
import java.util.*;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpException;
import org.apache.commons.httpclient.methods.GetMethod;
import org.apache.commons.httpclient.util.EncodingUtil;

public class DeskSample {
	/*
	 * # Replace oauth_consumer_key with your consumer key
	 * # Replace oauth_token with your access token
	 * # Replace oauth_signature with "your_consumer_secret%26your_access_token_secret"
	 * # Note that the oauth_nonce must change and be unique for every request
	 * 先测试这个
	 * curl -X GET 'https://yoursite.desk.com/api/v2/users/current' -H
	 * 'Authorization: OAuth
	 * oauth_version="1.0",oauth_timestamp=1321473112,oauth_nonce
	 * =937459123,oauth_signature_method
	 * ="PLAINTEXT",oauth_consumer_key="nMu4u9pLRfDrxhPVK5yn"
	 * ,oauth_token="ivouGxpsJbyIU5viPKOO",oauth_signature=
	 * "vLr9MjzowzVwbvREpWhIVQMJQI0G7Pin6KHCoXak%26igQY0L2bcbwonZTC4kG5ulZxTMTDW0K0zIyceSuF"
	 * '
	 */
	private static String OAUTH_KEY = "Xjr3oCAZJJqXWvpcdL0Y";
	private static String OAUTH_SECRET = "gLHdtyAAdh0lzdM9haLXaTGn5JZ9ZRvtBLr1W2GC";
	private static String ACCESS_TOKEN = "35i9pwdXC6ZXGUhqGjgK";
	private static String ACCESS_TOKEN_SECRET = "eQgQ6B6uGLzC9q1FH5E1gYRvx7K2iEatlP3EcxOb";

	public static String DESK_SITENAME = "hehong.desk.com";

	public static void doRequest() throws HttpException, IOException {
		String url = "https://" + DeskSample.DESK_SITENAME
				+ ".desk.com/api/v1/cases.json?count=10";
		HttpClient hc = new HttpClient();
		GetMethod get = new GetMethod(url);
		hc.executeMethod(get);
		// HttpRequest req = new HttpRequest();
		/*
		 * req.setMethod("GET"); req.setEndpoint("https://" +
		 * DeskSample.DESK_SITENAME + ".desk.com/api/v1/cases.json?count=10");
		 */
		// req.setBody(""); // you can use that in combination with a POST
		// request

		String responseBody = get.getResponseBodyAsString();
		System.out.println("responseBody:" + responseBody);
		// we need to sign the request
		/*
		 * req = DeskSample.signRequest(req);
		 * 
		 * Http client = new Http(); try { // execute the web service call
		 * HttpResponse response = client.send(req);
		 * 
		 * // debug messages System.debug(response.getBody());
		 * System.debug("STATUS: " + response.getStatus());
		 * System.debug("STATUS CODE: " + response.getStatusCode());
		 * 
		 * // process the response
		 * 
		 * // return the response } catch(Exception e) {
		 * System.out.println("EXCEPTION THROWN: " + e.getMessage()); }
		 */
	}

	private static Map<String, String> getParams(String paramString) {
		Map<String, String> params = new HashMap<String, String>();

		if (paramString == null || paramString == "")
			return params;

		for (String s : paramString.split("&")) {
			String[] sl = s.split("=");
			if (sl.length == 2) {
				params.put(sl[0], sl[1]);
			}
		}

		return params;
	}

	public static void main(String[] s) {
		try {
			System.out.println(System.currentTimeMillis());
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/*
	 * private static HttpRequest signRequest(HttpRequest req) { Map<String,
	 * String> params = new HashMap<String, String>(){ {
	 * put("oauth_consumer_key",DeskSample.OAUTH_KEY);
	 * put("oauth_nonce",String.valueOf(Crypto.getRandomLong()));
	 * put("oauth_signature_method","HMAC-SHA1");
	 * put("oauth_timestamp",String.valueOf(DateTime.now().getTime()/1000));
	 * put("oauth_token",DeskSample.ACCESS_TOKEN); put("oauth_version","1.0"); }
	 * };
	 * 
	 * String[] host = req.getEndpoint().split("\\?");
	 * 
	 * // parse get parameters if (host.length == 2) {
	 * params.putAll(DeskSample.getParams(host[1])); }
	 * 
	 * // parse body parameters if (req.getBody() != null && req.getBody() !=
	 * "") { params.putAll(DeskSample.getParams(req.getBody())); }
	 * 
	 * // create the base string String baseString = ""; List<String> keyList =
	 * new ArrayList<String>(params.keySet()); //keyList.sort(); for (String key
	 * : keyList) { baseString += key + "=" + params.get(key) + "&"; }
	 * baseString = req.getMethod().toUpperCase() + "&" +
	 * EncodingUtil.urlEncode(host[0], "UTF-8") + "&" +
	 * EncodingUtil.urlEncode(baseString.substringBeforeLast("&"), "UTF-8");
	 * 
	 * System.out.println("BASE STRING: " + baseString);
	 * 
	 * // create the signature Blob sig = Crypto.generateMac("HmacSHA1",
	 * Blob.valueOf(baseString), Blob.valueOf( DeskSample.OAUTH_SECRET + "&" +
	 * DeskSample.ACCESS_TOKEN_SECRET )); String signature =
	 * EncodingUtil.urlEncode(EncodingUtil.base64encode(sig), "UTF-8");
	 * 
	 * // create the header String header = "OAuth "; for (String key :
	 * params.keySet()) { header += key + "=" + params.get(key) + ", "; } header
	 * += "oauth_signature=" + signature + "";
	 * 
	 * // sign the request System.out.println("Authorization: " + header);
	 * req.setHeader("Authorization", header);
	 * 
	 * return req; }
	 */
}
