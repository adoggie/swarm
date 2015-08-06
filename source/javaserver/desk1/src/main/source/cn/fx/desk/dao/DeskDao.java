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
	public void insert(List list,String object);
	
	public String getDeskData(String token,String secret,String instanceUrl,String apiUrl) throws Exception;
	
	/**
	 * 根据指定的对象获取desk信息
	 * apTableName在desk指对应api地址
	 * */
	public String getDeskObject(String token, String secret, String instanceUrl,String apTableName)throws Exception;
}
