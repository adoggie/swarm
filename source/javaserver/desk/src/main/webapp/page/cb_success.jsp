<?xml version="1.0" encoding="UTF-8"?> 
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<!doctype html>
<html>
<head>
	<meta charset="utf-8">
	<meta name="format-detection" content="telephone=no"/>
	<title>OAuth success</title>
</head>

<body>
<script>
	var sendparams={
		status:0
	}
	window.location.href=encodeURI("objc://sfoauthsuccess/"+JSON.stringify(sendparams));
</script>
</body>
</html>