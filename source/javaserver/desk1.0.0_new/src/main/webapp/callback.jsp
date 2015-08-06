<?xml version="1.0" encoding="UTF-8"?> 
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="net.sf.json.JSONObject" %>
<!doctype html>
<html>
<head>
	<meta charset="utf-8">
	<meta name="format-detection" content="telephone=no"/>
	<title>SF callback</title>
</head>
<body>
<%String state = request.getParameter("state");
String code = request.getParameter("code"); %>
	state:<%=state %>
	<br/>
	code:<%=code %>
	<br/>
	<%
	String accessToken = null;
		if(code!=null){
			try {
			//3MVG9ZL0ppGP5UrB2Y_hVvDwIhz11aaTxV2fW7zZQ3cJh8CAKU59YBK_eFlgJSQTzVVGqcgbx_tzPy.KuYHfE
			//965006733835029946
				String strurl = "https://login.salesforce.com/services/oauth2/token?grant_type=authorization_code&code="+code+"&client_id=3MVG9ZL0ppGP5UrA07NfMyoSvF.bNw3CKrkHwvwgNPdhXgyAEqaCVxz.mLkW2ABgP5AF6mYbGKC9iUqc6N10R&client_secret=302144514012262193&redirect_uri=https://192.168.36.62:8443/desk/ap/sfcallback.do";
				JSONObject json = null;//PublicServiceImpl.getInstance().getJsonFromUrl(strurl, "POST");
				if(json!=null&&json.containsKey("access_token")){
					accessToken = json.getString("access_token");
					String instance_url = json.getString("instance_url");
					request.getSession().setAttribute("accessToken", accessToken);
					request.getSession().setAttribute("instanceUrl", instance_url);
					//out.print("获取到SalesForce的访问令牌accessToken:"+accessToken);
					%>
					获取到SalesForce的访问令牌accessToken:<%=accessToken %><BR />
					<a href="<%=request.getContextPath() %>/pages/wx/login_sf.jsp">查看</a><BR /><BR />
					所有信息:<%=json %>
					<%
				}
				/*
				String url = "https://login.salesforce.com/services/oauth2/token";
				HttpClient hc = new HttpClient(); 
				PostMethod post = new PostMethod(url);
				post.addParameter("grant_type", "authorization_code");
				post.addParameter("code", code);
				post.addParameter("client_id", "3MVG9ZL0ppGP5UrA07NfMyoSvF.bNw3CKrkHwvwgNPdhXgyAEqaCVxz.mLkW2ABgP5AF6mYbGKC9iUqc6N10R");
				post.addParameter("client_secret", "302144514012262193");
				post.addParameter("redirect_uri", "https://kom.eisoo.com/kom/pages/wx/callback.jsp");
				post.addParameter("format", "json");
				int a = hc.executeMethod(post);
				System.out.println(a);
				String responseBody = post.getResponseBodyAsString(); */
				
			} catch (Exception e) {
				e.printStackTrace();
			}
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