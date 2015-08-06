<?xml version="1.0" encoding="UTF-8"?> 
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.*" %>
<!doctype html>
<html>
<body>
<h1 align="center">OAuth</h1>
<!-- <a href="https://login.salesforce.com/services/oauth2/authorize?response_type=code&client_id=3MVG9ZL0ppGP5UrB2Y_hVvDwIhz11aaTxV2fW7zZQ3cJh8CAKU59YBK_eFlgJSQTzVVGqcgbx_tzPy.KuYHfE&redirect_uri=https%3A%2F%2F172.20.0.181%3A8443%2Fdesk%2Fap%2Fsfcallback.do&state=1">SalesForce账号登陆</a>
<br/>
<br/>
<a href="https://172.20.0.181:8443/desk/desklogin.do">Desk账号授权登陆</a>
 -->
<br/>
<FORM action="<%=request.getContextPath() %>/ap/sflogin.do" method="get">
	uid:
	<INPUT type="text" name="uid" value="1"/><br/>
	<INPUT type="submit" value="Salesforce授权登陆"/>
</FORM>
<FORM action="<%=request.getContextPath() %>/ap/desklogin.do" method="get">
	uid:
	<INPUT type="text" name="uid" value="1"/><br/>
	site:
	<INPUT type="text" name="site" value="yy002"/><br/>
	<INPUT type="submit" value="Desk授权登陆"/>
</FORM>
<br/>
${success}
<br/>
<FORM action="<%=request.getContextPath() %>/WEBAPI/connector/task2.do" method="get">
	user_id:
	<INPUT type="text" name="user_id" value="1"/><br/>
	biz_model:
	<INPUT type="text" name="biz_model" value="1"/><br/>
	<INPUT type="submit" value="调用任务开始抓取数据"/>
</FORM>
<br/><br/>
测试账号desk：<br/>
yy002.desk.com<br/>
sunxy1216@163.com<br/>
Sunxinyou1234<br/>
<br/><br/>
测试账号Salesforce：<br/>
1378661788@qq.com<br/>
Sunxinyou1234<br/>
</body>
</html>
