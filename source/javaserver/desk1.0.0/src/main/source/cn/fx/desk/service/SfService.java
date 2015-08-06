package cn.fx.desk.service;


/**
 * @author sunxy
 * @version 2015-6-9
 * @des SalesForce服务接口
 **/
public interface SfService {
	
	public void loginGetAccessToken(int userId,String code);
	public void getSfOpportunity(String batchId,int userId)  throws Exception;
	public String requestHeaderSfAPI(int uid,String apiUrl) throws Exception;
	public String refreshToken(int uid,String refreshToken);
	public String getSfInstanceURL(int uid);
	
	public String getSfAccessToken(int uid);
}
