<?xml version="1.0" encoding="UTF-8"?> 
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.*" %>
<!doctype html>
<html>
<body>
<h2>My Desk!</h2>

<a href="https://login.salesforce.com/services/oauth2/authorize?response_type=code&client_id=3MVG9ZL0ppGP5UrA07NfMyoSvF.bNw3CKrkHwvwgNPdhXgyAEqaCVxz.mLkW2ABgP5AF6mYbGKC9iUqc6N10R&redirect_uri=https%3A%2F%2Fkom.eisoo.com%2Fkom%2Fpages%2Fwx%2Fcallback.jsp&state=kom">SalesForce账号登陆</a>
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
