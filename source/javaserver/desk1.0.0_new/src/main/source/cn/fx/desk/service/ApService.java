package cn.fx.desk.service;

import cn.fx.desk.entity.OrgUserAppConfig;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**
 * @author sunxy
 * @version 2015-7-2
 * @des 
 **/
public interface ApService {
	public OrgUserAppConfig getAppConfig(int userId,int ap);
	public OrgUserAppConfig checkAppConfig(int uid,int appId);
	public void addUserAppConfig(int ap,int userId,String accessToken,String refreshToken,String instanceURL,String appUserId,String appUserName);
	public void connectorTaskInvoke(final JSONObject jsonObj);
	public void insertApObject(JSONArray recordList,String apUserId,int apId,String collection) throws Exception;
}
