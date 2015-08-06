package cn.fx.desk.service.impl;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cn.fx.desk.entity.OrgUserLogin;
import cn.fx.desk.mapper.YhMapper;
import cn.fx.desk.service.YhService;
/**
 * @author sunxy
 * @version 2015-6-9
 * @des 
 **/
@Service("yhService")
public class YhServiceImpl implements YhService {
	
	@Autowired
	YhMapper yhMapper;
	//user_id,user_name,user_type,domain
	/**
	 * 登陆校验成功后，写入db
	 */
	public OrgUserLogin addOrgUserLogin(int userId,String userName,int userType,String domain,String sid){
		OrgUserLogin o = new OrgUserLogin();
		o.setUserId(userId);
		o.setUserName(userName);
		o.setUserType(userType);
		o.setSid(sid);
		o.setDomain(domain);
		yhMapper.addOrgUserLogin(o);
		return o;
	}
	
	public OrgUserLogin getOrgUserLogin(int userId){
		//cache++
		OrgUserLogin oul = yhMapper.getOrgUserLogin(userId);
		
		return oul;
	}
}
