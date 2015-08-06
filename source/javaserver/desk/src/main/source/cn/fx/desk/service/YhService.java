package cn.fx.desk.service;

import cn.fx.desk.entity.OrgUserLogin;

/**
 * @author sunxy
 * @version 2015-6-9
 * @des 
 **/
public interface YhService {
	
	public OrgUserLogin addOrgUserLogin(int userId,String userName,int userType,String domain,String sid);
	
	public OrgUserLogin getOrgUserLogin(int userId);
}
