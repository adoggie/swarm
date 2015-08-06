package cn.fx.desk.mapper;

import cn.fx.desk.entity.OrgUserLogin;


/**
 * @author sunxy
 * @version 2015-6-9
 * @des 
 **/
public interface YhMapper {
	public int find();
	public void addOrgUserLogin(OrgUserLogin orgUserLogin);
	public OrgUserLogin getOrgUserLogin(int userId);
}
