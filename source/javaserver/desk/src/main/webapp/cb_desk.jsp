<?xml version="1.0" encoding="UTF-8"?> 
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="oauth.signpost.*" %>
<%@ page import="oauth.signpost.basic.*" %>
<!doctype html>
<html>
<head>
	<meta charset="utf-8">
	<meta name="format-detection" content="telephone=no"/>
	<title>Desk callback</title>
</head>
<body>
<%
String oauth_verifier = request.getParameter("oauth_verifier");
String oauth_token = request.getParameter("oauth_token");
 %>
	<br/>
	<br/>
	<%
		System.out.println("oauth_verifier:"+oauth_verifier);
		
		try {
			OAuthProvider provider = (OAuthProvider) session.getAttribute("provider");
			OAuthConsumer consumer = (OAuthConsumer) session.getAttribute("consumer");
			System.out.println("***************444444444************");
			provider.retrieveAccessToken(consumer, oauth_verifier);
			System.out.println("Access token: " + consumer.getToken());
	        System.out.println("Token secret: " + consumer.getTokenSecret());
	        
	        
	        URL url = new URL("https://yy001.desk.com/api/v2/cases");
	        HttpURLConnection request2 = (HttpURLConnection) url.openConnection();

	        consumer.sign(request2);

	        System.out.println("Sending request to Twitter...");
	        request2.connect();

	        System.out.println("Response: " + request2.getResponseCode() + " " + request2.getResponseMessage());
	        
	        StringBuffer res = new StringBuffer(); 
	        java.io.BufferedReader in = new java.io.BufferedReader(new java.io.InputStreamReader(request2.getInputStream(),"UTF-8"));
			String line;
			while ((line = in.readLine()) != null) {
				res.append(line);
			}
			out.print("cases:");
			%>
			<%=res.toString() %>
			<%
			System.out.println("res:"+res.toString());
			in.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	%>
	<br/>
	<br/>
	<br/>
	<br/>
	**************测试显示所有请求参数**********************<br/>
	<% Map map = request.getParameterMap();
		if(map!=null&&map.size()>0){
			Set<String> s = map.keySet() ;
			Iterator<String> it = s.iterator();
			while(it.hasNext()){
				String key = it.next();
				String value = map.get(key).toString();
	%>
				<%=key %>
				<%=request.getParameter(key) %>
				<br/>
	<%
			}
		}else{
			%>
			map 为空
			<%
		}
		
	%>
	
</body>
</html>