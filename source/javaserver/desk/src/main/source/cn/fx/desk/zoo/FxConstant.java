package cn.fx.desk.zoo;
/**
 * @author sunxy
 * @version 2015-6-9
 * @des 
 **/
public class FxConstant {
	public static final String METHOD_GET = "GET";
	public static final String METHOD_POST = "POST";
	public static final String CHARSET_DEFAULT = "UTF-8";
	
	//desk分页抓取数据，每次抓取数据的数量
	public static final int DESK_PER_PAGE_NUM = 100;
	//salesforce
	public static final int SF_PER_PAGE_NUM = 500;
	
	public static final String SF_TIME_FORMATTER = "YYYY-MM-dd'T'hh:mm:ss+hh:mm";//ISO 8601 format
	public static final String SF_TIME_FORMATTER_DB = "YYYY-MM-dd'T'hh:mm:ss'.000Z'";//
	public static final String SF_TIME_ZONE = "GMT";
	//接入平台
	public static final int AP_SALESFORCE = 1;
	public static final int AP_DESK = 2;
	//业务模型
	public static final int BIZ_MODEL_SATIS = 1;
	
	public static final String DESK_API_CASE = "/api/v2/cases";
	public static final String DESK_API_ME = "/api/v2/users/me";
	public static final String DESK_API_CUSTOMERS = "/api/v2/customers";
	public static final String DESK_API_FEEDBACKS = "/api/v2/feedbacks";
	
	/**
	 * 对象名常量
	 */
	public static final String OBJ_OPPORTUNITY = "opportunity";
	public static final String OBJ_ACCOUNT = "account";//客户 对应desk的customers
	//public static final String OBJ_CUSTOMERS = "customers";
	public static final String OBJ_CASE = "case";
	public static final String OBJ_FEEDBACKS = "feedbacks";
	
	
	public static final String OBJ_DESK_ME = "me";
}
