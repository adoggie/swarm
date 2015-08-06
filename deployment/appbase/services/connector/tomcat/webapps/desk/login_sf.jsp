<?xml version="1.0" encoding="UTF-8"?> 
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html>
<head>
	<meta charset="utf-8">
	<meta name="format-detection" content="telephone=no"/>
	<title>SFTEST</title>
</head>
<body>
<h1 align="center">获取SalesForce授权过程的测试页面</h1><BR /><BR />
accessToken:${accessToken}<BR />
<c:if test="${accessToken ne null}">
	<a href="<%=request.getContextPath() %>/pages/wx/login_data_sf.jsp">数据获取测试</a>
</c:if>

<BR />
accessToken为空点击链接获取。<BR />
<a href="https://login.salesforce.com/services/oauth2/authorize?response_type=code&client_id=3MVG9ZL0ppGP5UrB2Y_hVvDwIhz11aaTxV2fW7zZQ3cJh8CAKU59YBK_eFlgJSQTzVVGqcgbx_tzPy.KuYHfE&redirect_uri=https%3A%2F%2F172.20.0.192%3A8443%2Fdesk%2Fap%2Fsfcallback.do&state=1">SalesForce账号登陆</a>
<BR />
<BR />
</body>
</html>