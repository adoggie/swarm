package cn.fx.desk.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cn.fx.desk.dao.DeskDao;
import cn.fx.desk.entity.OrgUserAppConfig;
import cn.fx.desk.service.ApService;
import cn.fx.desk.service.DeskService;
import cn.fx.desk.zoo.DeskConstant;
import cn.fx.desk.zoo.TimeUtil;

/**
 * @author sunxy
 * @version 2015-6-30
 * @des 
 **/
@Service("deskService")
public class DeskServiceImpl implements DeskService {
	@Autowired
	private DeskDao deskDao; 
	@Autowired
	private ApService apService;
	public String getStringFromDesk(String token,String secret,String instanceUrl,String apiUrl){
		if(!instanceUrl.contains(".desk.com")){
			instanceUrl = instanceUrl+".desk.com";
		}
		return deskDao.getStringFromDesk(token, secret, instanceUrl, apiUrl);
	}
	public void getCaseFromDesk(String batchId,int uid){
System.out.println("===========getCaseFromDesk==========="+batchId);
		OrgUserAppConfig deskUserApp = apService.getAppConfig(uid, DeskConstant.AP_DESK);
		//1、根据userId获取desk的userId、username、password（以后可能是token、secret）
		String instanceUrl = deskUserApp.getAppInstanceUrl();
		String username = deskUserApp.getAppAccessToken();
		String password = deskUserApp.getAppRefreshToken();
		String deskUserId = deskUserApp.getAppUserId();
		//2、
		String cases = getStringFromDesk(username, password, instanceUrl,DeskConstant.DESK_API_CASE);
System.out.println("===========getCaseFromDesk===========cases:"+cases);
		JSONObject casesjson = JSONObject.fromObject(cases);
		if(casesjson.containsKey("total_entries")){
			int totalEntries = casesjson.getInt("total_entries");
			if(totalEntries>0){
				JSONObject embed = casesjson.getJSONObject("_embedded");
				JSONArray entries = embed.getJSONArray("entries");
				int num = entries.size();
				List<Map> list = new ArrayList<Map>(num);
				Map map = null;
				String batchTime = TimeUtil.getCurTimeFormat();
				for(int i=0;i<num;i++){
					JSONObject ent = (JSONObject) entries.get(i);
					map = new HashMap();
					map.put("id", ent.getInt("id"));
					map.put("status", ent.getString("status"));//current state of the case, one of: new, open, pending, resolved, closed
					map.put("type", ent.getString("type"));//channel of the case, one of: chat, twitter, email, qna, facebook, phone
					map.put("created_at", ent.getString("created_at"));
					map.put("resolved_at", ent.getString("resolved_at"));
					//获取关联信息
					JSONObject links = ent.getJSONObject("_links");
System.out.println("links:" + links);
					//获取客户信息
					JSONObject customer = links.getJSONObject("customer");
System.out.println("customer:"+ customer);
					String custApi = customer.getString("href");
					String custData = getStringFromDesk(username, password, instanceUrl, custApi);
					if(custData != null){
						try {
							JSONObject custjson = JSONObject.fromObject(custData);
							/*Map custMap = new HashMap();
							custMap.put("id", custjson.getInt("id"));
							custMap.put("first_name", custjson.getString("first_name"));
							custMap.put("last_name", custjson.getString("last_name"));*/
							map.put("company", custjson.getString("company"));//放入客户信息--公司
						} catch (Exception e) {
							e.printStackTrace();
						}
					}
					//获取反馈评分信息
					if(links.containsKey("feedbacks")){
						JSONObject feedbacks = ent.getJSONObject("feedbacks");
System.out.println("feedbacks:"+feedbacks);
						if(feedbacks != null && !feedbacks.isNullObject()){
							String feedbackApi = feedbacks.getString("href");
							String feedbackData = getStringFromDesk(username, password, instanceUrl, feedbackApi);
							try {
								JSONObject feedbackjson = JSONObject.fromObject(feedbackData);
								int rating = feedbackjson.getInt("rating");
								String rating_type = feedbackjson.getString("rating_type");
								map.put("rating", rating);//放入反馈评分
								map.put("rating_type", rating_type);//放入反馈评分
							} catch (Exception e) {
								e.printStackTrace();
							}
						}
					}
					map.put("fx_desk_userid", deskUserId);
					map.put("fx_batch_id", batchId);
					map.put("fx_batch_time", batchTime);
System.out.println("getCaseFromDesk map:"+map);
					list.add(map);
				}
				deskDao.addDeskCaseInfo(list);
System.out.println("===========getCaseFromDesk===========");
			}
		}
	}
}
