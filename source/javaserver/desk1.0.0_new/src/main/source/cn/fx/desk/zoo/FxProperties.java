package cn.fx.desk.zoo;
/**
 * @author sunxy
 * @version 2015-7-13
 * @des 
 **/
public class FxProperties {
	
	/**Desk App信息*/
	public static String DESK_TOKEN = PropProcess.getProperty("desk.token");
	public static String DESK_SECRET = PropProcess.getProperty("desk.secret");
	public static String CALLBACK_DESK = PropProcess.getProperty("desk.callback");
	
	/**Salesforce App信息*/
	public static String SF_CLIENT_ID = PropProcess.getProperty("sf.clientid");
	public static String SF_CLIENT_SECRET = PropProcess.getProperty("sf.clientsecret");
	public static String SF_REDIRECT_URI = PropProcess.getProperty("sf.redirecturi");
	
	//JOB-Server
	public static String JOB_SERVER_URI = PropProcess.getProperty("job_server_uri");
	public static String MOBILE_SERVER_URI = PropProcess.getProperty("mobile_server_uri");
	public static String CONNECTOR_SERVER_URI = PropProcess.getProperty("connector_server_uri");
	
	public static String USER_CHECK = MOBILE_SERVER_URI+"/WEBAPI/auth/restricted/orguser/login/";
	public static String USER_BY_TOKEN = MOBILE_SERVER_URI+"/WEBAPI/auth/accessToken/detail?token=";
	
	public static String INSTANCE_URI = CONNECTOR_SERVER_URI;//+"/WEBAPI/connector";
		
}
