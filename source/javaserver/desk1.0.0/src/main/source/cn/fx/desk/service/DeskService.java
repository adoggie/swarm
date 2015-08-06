package cn.fx.desk.service;
/**
 * @author sunxy
 * @version 2015-6-30
 * @des 
 **/
public interface DeskService {
	public void getCaseFromDesk(String batchId,int userId);
	
	public String getStringFromDesk(String token,String secret,String instanceUrl,String apiUrl);
}
