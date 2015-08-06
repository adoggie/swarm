module.exports={
	host:'http://192.168.36.62:8800',
	successcode:0,
	errorcode:1,
	uid:sessionStorage.getItem("uid"),
	sid:sessionStorage.getItem("sid"),
	sfurl:"https://login.salesforce.com/services/oauth2/authorize?response_type=code&client_id=3MVG9ZL0ppGP5UrB2Y_hVvDwIhz11aaTxV2fW7zZQ3cJh8CAKU59YBK_eFlgJSQTzVVGqcgbx_tzPy.KuYHfE&redirect_uri=https%3A%2F%2F192.168.36.62%3A8443%2Fdesk%2Fap%2Fsfcallback.do&state=",
	deskurl:"../src/pages/desklogin.html",
	errormsg:{
		required:"This field is required;",
		email:"Please enter a valid email address.",
	},
	pageSize:5, //每页显示条数
	pageCount:5, //默认显示 几个页数
};