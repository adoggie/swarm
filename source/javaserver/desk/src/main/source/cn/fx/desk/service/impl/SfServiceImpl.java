package cn.fx.desk.service.impl;

import java.net.URLEncoder;
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
import cn.fx.desk.entity.ApTables;
import cn.fx.desk.entity.ApTablesTime;
import cn.fx.desk.entity.OrgUserAppConfig;
import cn.fx.desk.mapper.OrgUserAppConfigMapper;
import cn.fx.desk.service.ApService;
import cn.fx.desk.service.ApTablesService;
import cn.fx.desk.service.SfService;
import cn.fx.desk.zoo.FxConstant;
import cn.fx.desk.zoo.FxProperties;
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
	private ApTablesService apTableService;
	@Autowired
	private ApService apService;
	public void getSalesforceObject(int uid)throws Exception{
		OrgUserAppConfig sfUserApp = apService.getAppConfig(uid, FxConstant.AP_SALESFORCE);
		String instanceURL = sfUserApp.getAppInstanceUrl();
		String accessToken = sfUserApp.getAppAccessToken();
		String sfUserId = sfUserApp.getAppUserId();
		List<ApTables> apTables = apTableService.getTablesByAppId(FxConstant.AP_SALESFORCE);
		if(apTables!=null&&apTables.size()>0){
			ApTables apTable = null;
			for(int i=0;i<apTables.size();i++){
				apTable = apTables.get(i);
System.out.println(apTable.getAppTableName()+":"+apTable.getCurTableName());
				getSalesforceObject(sfUserId, instanceURL, accessToken, apTable.getAppTableName(), apTable.getCurTableName());
			}
		}
	}
	public void getSalesforceObject(String sfUserId,String instanceURL,String accessToken,String apTableName,String curTableName)throws Exception{
		//1、当前表是否曾经抓取过数据
		Map ttMap = new HashMap(3);
		ttMap.put("appId", FxConstant.AP_SALESFORCE);
		ttMap.put("appTableName", apTableName);
		ttMap.put("appUserId", sfUserId);
		ApTablesTime apTablesTime = apTableService.getApTablesTime(ttMap);
		
		String end = TimeUtil.getCurTimeFormatTimeZone(FxConstant.SF_TIME_FORMATTER_DB, FxConstant.SF_TIME_ZONE);
		int page = 1;
		int perPage = FxConstant.SF_PER_PAGE_NUM;
		/***需要判断增量更新的情况***/
		if(apTablesTime != null){//曾经抓取过数据,进行增量取数据
			//1、更新.2、删除
			//判断时间差,如果超过30天最好整个重取
			String start = apTablesTime.getUpdateAt();
			int totalNum = sfDao.getSfObjcetCountByTime(instanceURL, accessToken, apTableName, start, end);
			if(totalNum > 0){
				int num = totalNum/perPage;
				int totalPage = (totalNum%perPage>0)?(num+1):num;
				while(page<=totalPage){
					String data = sfDao.getSalesforceObjectByTime(instanceURL, accessToken, apTableName, start, end,page,perPage);
					sfDao.updateSalesForceObject(sfUserId,data, curTableName);
					page++;
				}
			}
			//更新当前表的最后一次数据抓取时间
			apTableService.updateApTablesTime(end,apTablesTime.getId());
		}else{//首次抓取，获取全部数据
			//先查询总共有多少记录
			int totalNum = sfDao.getSfObjcetCountByTime(instanceURL, accessToken, apTableName, null, null);
			if(totalNum > 0){
				int num = totalNum/perPage;
				int totalPage = (totalNum%perPage>0)?(num+1):num;
				while(page<=totalPage){
					String data = sfDao.getSalesforceObjectByTime(instanceURL, accessToken,apTableName,null, null, page,perPage);
					if(data != null){
						JSONObject datajson = JSONObject.fromObject(data);
						if(datajson.containsKey("totalSize")){
							int totalSize = datajson.getInt("totalSize");
							if(totalSize > 0){
								JSONArray recordList = datajson.getJSONArray("records");
								apService.insertApObject(recordList, sfUserId, FxConstant.AP_SALESFORCE, curTableName);
							}
						}
					}
					page++;
				}
			}
			//记录当前表的最后一次数据抓取时间
			apTableService.addApTablesTime(FxConstant.AP_SALESFORCE, apTableName, sfUserId, end);
		}
	}
	/**
	 * 从salesforce获取机会信息，插入到本地数据库中
	 * @param sfUserId 		用salesforce用户id,避免多账号匹配同一sf账号的问题
	 * @param instanceURL	
	 * @param accessToken
	 * @throws Exception
	 */
	public void getSfOpportunity(String batchId,int uid)  throws Exception{
		try {
			OrgUserAppConfig sfUserApp = apService.getAppConfig(uid, FxConstant.AP_SALESFORCE);
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
							map = new HashMap();
							JSONObject json = (JSONObject) recordList.get(i);
							//map.put("fx_ap_object", json);
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
							/*map.put("fx_ap_userid", sfUserId);
							map.put("fx_ap_id", apId);
							map.put("fx_create_at", curTime);*/
							map.put("fx_desk_userid", sfUserId);
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
		strURL.append(FxProperties.SF_CLIENT_ID);
		strURL.append("&client_secret=");
		strURL.append(FxProperties.SF_CLIENT_SECRET);
		strURL.append("&redirect_uri=");
		strURL.append(FxProperties.SF_REDIRECT_URI);
		JSONObject jsonObj = GeneralMethod.getJsonFromUrl(strURL.toString(), FxConstant.METHOD_POST);
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
			apService.addUserAppConfig(FxConstant.AP_SALESFORCE, uid, accessToken, refreshToken, instanceURL, sfUid, appUserName);
		}
	}
	public String refreshToken(int uid,String refreshToken) throws Exception{
System.out.println("=======================refreshToken========================");
		String accessToken = null;
		String apiLogin = "https://login.salesforce.com/services/oauth2/token?grant_type=refresh_token&refresh_token=";
		StringBuffer strURL = new StringBuffer(apiLogin);
		strURL.append(refreshToken);
		strURL.append("&client_id=");
		strURL.append(FxProperties.SF_CLIENT_ID);
		strURL.append("&client_secret=");
		strURL.append(FxProperties.SF_CLIENT_SECRET);
		strURL.append("&redirect_uri=");
		//URLEncoder.encode(FxProperties.SF_REDIRECT_URI, "UTF-8");
		strURL.append(FxProperties.SF_REDIRECT_URI);
		JSONObject jsonObj = GeneralMethod.getJsonFromUrl(strURL.toString(), FxConstant.METHOD_POST);
		if(jsonObj.containsKey("access_token")){
			//1、获取保存accessToken
			accessToken = jsonObj.getString("access_token");
			//2、更新授权信息
			Map map = new HashMap();
			map.put("app_id", FxConstant.AP_SALESFORCE);
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
