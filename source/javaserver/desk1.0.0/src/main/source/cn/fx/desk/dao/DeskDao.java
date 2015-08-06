package cn.fx.desk.dao;

import java.util.List;

/**
 * @author sunxy
 * @version 2015-6-29
 * @des 
 **/
public interface DeskDao {
	public String deskCases(String username,String password,String instanceUrl);
	public String getStringFromDesk(String username,String password,String instanceUrl,String apiUrl);
	public void addDeskCaseInfo(List list);
	public void findDeskCase();
	
	public String getDeskData(String token,String secret,String instanceUrl,String apiUrl) throws Exception;
}
