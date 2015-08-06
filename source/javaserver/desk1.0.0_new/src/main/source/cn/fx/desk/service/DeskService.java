package cn.fx.desk.service;
/**
 * @author sunxy
 * @version 2015-6-30
 * @des 
 **/
public interface DeskService {
	public void getCaseFromDesk(String batchId,int userId) throws Exception;
	
	public String getStringFromDesk(String token,String secret,String instanceUrl,String apiUrl);
	public String getDeskDataOAuth(String token,String secret,String instanceUrl,String apTableName) throws Exception;
	/**获取desk对象信息*/
	public void getDeskObject(int uid)throws Exception;
	public void getDeskObject(String deskUserId,String token,String secret,String instanceUrl,String apTableName,String curTableName)throws Exception;
}
