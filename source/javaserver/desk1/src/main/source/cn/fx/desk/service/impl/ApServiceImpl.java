package cn.fx.desk.service.impl;

import java.util.HashMap;
import java.util.Map;

import net.sf.json.JSONObject;

import org.apache.commons.httpclient.NameValuePair;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cn.fx.desk.entity.OrgUserAppConfig;
import cn.fx.desk.mapper.OrgUserAppConfigMapper;
import cn.fx.desk.service.ApService;
import cn.fx.desk.service.DeskService;
import cn.fx.desk.service.SfService;
import cn.fx.desk.zoo.FxConstant;
import cn.fx.desk.zoo.GeneralMethod;
import cn.fx.desk.zoo.TimeUtil;

/**
 * @author sunxy
 * @version 2015-7-2
 * @des 
 **/
@Service("apService")
public class ApServiceImpl implements ApService {
	private static final int ACTIVE_TIME = 15;
	@Autowired
	private OrgUserAppConfigMapper orgUserAppConfigMapper;
	@Autowired
	private SfService sfService;
	@Autowired
	private DeskService deskService;
	public void addUserAppConfig(int appId,int userId,String accessToken,String refreshToken,String instanceURL,String appUserId,String appUserName){
		OrgUserAppConfig ouac = getAppConfig(userId, appId);
		Map map = new HashMap();
		map.put("app_id", appId);//DeskConstant.AP_SALESFORCE
		map.put("user_id", userId);
		map.put("is_active", true);
		map.put("app_access_token", accessToken);
		map.put("app_refresh_token", refreshToken);
		map.put("app_instance_url", instanceURL);
		map.put("app_user_id", appUserId);
		map.put("app_user_name", appUserName);
		if(ouac != null){
			orgUserAppConfigMapper.updateAppConfig(map);
		}else{
			orgUserAppConfigMapper.addAppConfig(map);
		}
	}
	
	public OrgUserAppConfig getAppConfig(int uid,int appId){
		//cache++
		Map map = new HashMap();
		map.put("userId", uid);
		map.put("appId", appId);
		OrgUserAppConfig ouac = orgUserAppConfigMapper.getAppConfig(map);
		//添加检验token是否有效的方法...
		if(ouac!=null){
			if(appId == FxConstant.AP_SALESFORCE){
				String authTime = ouac.getAppAuthTime();
				int min = TimeUtil.minDiffToNow(authTime);
				if(min >= ACTIVE_TIME){
					String accessToken = sfService.refreshToken(uid, ouac.getAppRefreshToken());
					ouac.setAppAccessToken(accessToken);
				}
			}
		}
		return ouac;
	}
	
	public void connectorTaskInvoke(final JSONObject jsonObj){
		Thread t = new Thread(){
			public void run(){
System.out.println("***********任务调度************"+jsonObj);
				if(jsonObj!=null&&!jsonObj.isNullObject()){
					int serviceId = 1;
					long startTime = System.currentTimeMillis();
					String taskId = jsonObj.getString("task_id");
					String callbackUri = jsonObj.getString("callback_uri");
					try {
						//进行数据采集方法调用
						JSONObject job = jsonObj.getJSONObject("job");
						String userAcct = job.getString("user_acct");
						int userId = job.getInt("user_id");
						int bizModel = job.getInt("biz_model");
						String batchId = GeneralMethod.getBatchId();
						if(FxConstant.BIZ_MODEL_SATIS == bizModel){//根据业务模型判断需要获取的数据源
							//根据userAcct获取用户信息
							//sfService.getSfOpportunity(batchId, sfUserId, instanceURL, accessToken);
							System.out.println("========根据业务模型调用采集的方法sf========");
							//Salesforce平台——获取数据
							//sfService.getSfOpportunity(FxConstant.AP_SALESFORCE, userId);
							sfService.getSalesforceObject(userId);
							System.out.println("========根据业务模型调用采集的方法desk========");
							//desk平台
							//deskService.getCaseFromDesk(batchId, userId);
							deskService.getDeskObject(userId);
						}
						
						//数据采集的过程，往上抛异常，接收到异常也回调一次
						
						long endTime = System.currentTimeMillis();
						long elapsed = endTime - startTime;
						String dataset = "taskinvoke";
						NameValuePair[] param = { new NameValuePair("start_time",startTime+""),  
				                new NameValuePair("task_id",taskId),  
				                new NameValuePair("elapsed",elapsed+""),  
				                new NameValuePair("dataset",dataset),  
				                new NameValuePair("service_id",serviceId+"")}; 
						callbackUri = callbackUri + "/task/finished/";
						try {
							GeneralMethod.postParms(callbackUri, param);//任务执行成功
						} catch (Exception e) {
							e.printStackTrace();
						}
					} catch (Exception e) {
						long endTime = System.currentTimeMillis();
						long elapsed = endTime - startTime;
						callbackUri = callbackUri + "/task/aborted/";
						NameValuePair[] param = { new NameValuePair("start_time",startTime+""),  
				                new NameValuePair("task_id",taskId),  
				                new NameValuePair("elapsed",elapsed+""),  
				                new NameValuePair("reason",e.getMessage()),  
				                new NameValuePair("service_id",serviceId+"")} ;
						GeneralMethod.postParms(callbackUri, param);//任务执行失败
						
						e.printStackTrace();
					} finally{
						
					}
				}
			 }
		};
		t.start();
	}
}
