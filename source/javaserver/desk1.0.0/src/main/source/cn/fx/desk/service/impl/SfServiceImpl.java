package cn.fx.desk.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.methods.GetMethod;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cn.fx.desk.dao.SfDao;
import cn.fx.desk.entity.OrgUserAppConfig;
import cn.fx.desk.mapper.OrgUserAppConfigMapper;
import cn.fx.desk.service.ApService;
import cn.fx.desk.service.SfService;
import cn.fx.desk.zoo.DeskConstant;
import cn.fx.desk.zoo.DeskProperties;
import cn.fx.desk.zoo.GeneralMethod;
import cn.fx.desk.zoo.SfConstant;
import cn.fx.desk.zoo.TimeUtil;
/**
 * @author sunxy
 * @version 2015-6-9
 * @des uid
 **/
@Service("sfService")
public class SfServiceImpl implements SfService {
	@Autowired
	private SfDao sfDao;
	@Autowired
	private OrgUserAppConfigMapper orgUserAppConfigMapper;
	@Autowired
	private ApService apService;
	
	/**
	 * 从salesforce获取机会信息，插入到本地数据库中
	 * @param sfUserId 		用salesforce用户id,避免多账号匹配同一sf账号的问题
	 * @param instanceURL	
	 * @param accessToken
	 * @throws Exception
	 */
	public void getSfOpportunity(String batchId,int uid)  throws Exception{
		try {
			OrgUserAppConfig sfUserApp = apService.getAppConfig(uid, DeskConstant.AP_SALESFORCE);
			String instanceURL = sfUserApp.getAppInstanceUrl();
			String accessToken = sfUserApp.getAppAccessToken();
			String sfUserId = sfUserApp.getAppUserId();
			
			String data = sfDao.getOpportunityFromSf(instanceURL,accessToken);
System.out.println("SfServiceImpl getSfOpportunity data:"+data);
			try {
				JSONObject datajson = JSONObject.fromObject(data);
				if(datajson.containsKey("totalSize")){
					int totalSize = datajson.getInt("totalSize");
					if(totalSize > 0){
						JSONArray recordList = datajson.getJSONArray("records");
						List<Map> list = new ArrayList<Map>(totalSize);
						Map map = null;
						String curTime = TimeUtil.getCurTimeFormat();
						for(int i=0;i<totalSize;i++){
							JSONObject json = (JSONObject) recordList.get(i);
							Set<String> set = json.keySet();
							Iterator<String> it = set.iterator();
							map = new HashMap();
							while(it.hasNext()){
								String key = it.next();
								if("Account".equals(key)){
									map.put(key, json.getJSONObject(key));
								}else if(!"attributes".equals(key)){
									map.put(key, json.getString(key));
								}
							}
							map.put("fx_sf_userid", sfUserId);
							map.put("fx_batch_id", batchId);
							map.put("fx_batch_time", curTime);
							list.add(map);
						}
						sfDao.addOpportunity(list);
					}
				}
				System.out.println("===========getSfOpportunity 完成============");
			} catch (Exception e) {
				e.printStackTrace();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	public void addSfOpportunity(int uid){
		try {
			requestHeaderSfAPI(uid, SfConstant.API_CHATTER_USERS+"/00528000000ImzzAAC");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	public void loginGetAccessToken(int uid,String code){
		String apiLogin = "https://login.salesforce.com/services/oauth2/token?grant_type=authorization_code&code=";
		StringBuffer strURL = new StringBuffer(apiLogin);
		strURL.append(code);
		strURL.append("&client_id=");
		strURL.append(DeskProperties.SF_CLIENT_ID);
		strURL.append("&client_secret=");
		strURL.append(DeskProperties.SF_CLIENT_SECRET);
		strURL.append("&redirect_uri=");
		strURL.append(DeskProperties.SF_REDIRECT_URI);
		JSONObject jsonObj = GeneralMethod.getJsonFromUrl(strURL.toString(), DeskConstant.METHOD_POST);
		if(jsonObj.containsKey("access_token")){
			//1、获取保存accessToken
			String accessToken = jsonObj.getString("access_token");
			String instanceURL = jsonObj.getString("instance_url");
			String refreshToken = jsonObj.getString("refresh_token");
			String id = jsonObj.getString("id");
			String[] tmp = id.split("/");
			String sfUid = tmp[tmp.length-1];
			//2、根据accessToken获取app_username
			String appUserName = sfDao.getSfUserAccount(sfUid, instanceURL, accessToken);
			//3、保存本次登陆信息
			apService.addUserAppConfig(DeskConstant.AP_SALESFORCE, uid, accessToken, refreshToken, instanceURL, sfUid, appUserName);
		}
	}
	public String refreshToken(int uid,String refreshToken){
System.out.println("=======================refreshToken========================");
		String accessToken = null;
		String apiLogin = "https://login.salesforce.com/services/oauth2/token?grant_type=refresh_token&refresh_token=";
		StringBuffer strURL = new StringBuffer(apiLogin);
		strURL.append(refreshToken);
		strURL.append("&client_id=");
		strURL.append(DeskProperties.SF_CLIENT_ID);
		strURL.append("&client_secret=");
		strURL.append(DeskProperties.SF_CLIENT_SECRET);
		strURL.append("&redirect_uri=");
		strURL.append(DeskProperties.SF_REDIRECT_URI);
		JSONObject jsonObj = GeneralMethod.getJsonFromUrl(strURL.toString(), DeskConstant.METHOD_POST);
		if(jsonObj.containsKey("access_token")){
			//1、获取保存accessToken
			accessToken = jsonObj.getString("access_token");
			//2、更新授权信息
			Map map = new HashMap();
			map.put("app_id", DeskConstant.AP_SALESFORCE);
			map.put("user_id", uid);
			map.put("app_access_token", accessToken);
			orgUserAppConfigMapper.updateAppConfig(map);
		}
		return accessToken;
	}
	
	public String requestHeaderSfAPI(int uid,String apiUrl) throws Exception{
		String url = getSfInstanceURL(uid) + apiUrl;
		HttpClient hc = new HttpClient(); 
		GetMethod get = new GetMethod(url);
		get.setRequestHeader("Authorization", "OAuth "+getSfAccessToken(uid));
		int a = hc.executeMethod(get);
		String responseBody = get.getResponseBodyAsString();
System.out.println("responseBody:"+responseBody);
		return responseBody;
	}
	public String getSfInstanceURL(int uid){
		String url = "https://ap2.salesforce.com";
		
		return url;
	}
	public String getSfAccessToken(int uid){
		String accessToken = "00D28000000KcB7!AQkAQLmtLqETLRd8HfXEOZx.SV1DwgHB6Cu7IGrE2mtKcNH0mCQOMtkEvF5jFNnjroobeCNEViylocd1omDBJgm9mHIRmT73";
		
		return accessToken;
	}
	public String getSfUserId(int uid){
		String sfUserId = "00528000000ImzzAAC";
		
		return sfUserId;
	}
}
