package cn.fx.desk.dao.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.data.mongodb.core.query.Update;
import org.springframework.stereotype.Service;

import cn.fx.desk.dao.SfDao;
import cn.fx.desk.zoo.FxConstant;
import cn.fx.desk.zoo.GeneralMethod;
import cn.fx.desk.zoo.SfConstant;
import cn.fx.desk.zoo.TimeUtil;

import com.mongodb.DBCollection;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;
import com.mongodb.WriteResult;

/**
 * @author sunxy
 * @version 2015-6-15
 * @des 
 **/
@Service("sfDao")
public class SfDaoImpl implements SfDao{
	@Autowired
    private MongoTemplate mongoTemplate;
	
	/***1.0.1**/
	//public String getOpportunity
	
	public void addSfOpportunity(){
		
	}
	
	public void test(){
		System.out.println("***********test***********");
		Query query = new Query();  
        query.addCriteria(new Criteria("fx_ap_object.Id").is(2));
        Update update = new Update(); 
        update.set("fx_ap_id", 88); 
        update.set("fx_ap_userid", "sunxy"); 
        WriteResult wr = mongoTemplate.updateFirst(query, update, "cases");
		System.out.println("更新结果:"+wr);
	}
	public void updateSalesForceObject(String apUserId,String data,String collection) throws Exception{
		if(data != null){
			JSONObject datajson = JSONObject.fromObject(data);
			if(datajson.containsKey("totalSize")){
				int totalSize = datajson.getInt("totalSize");
				if(totalSize > 0){//总共需要更新的记录数
					JSONArray recordList = datajson.getJSONArray("records");
					String curTime = TimeUtil.getCurTimeFormat();
					for(int i=0;i<totalSize;i++){
						JSONObject json = (JSONObject) recordList.get(i);
						String apObjectId = json.getString("Id");
						Query query = new Query();  
				        query.addCriteria(new Criteria("fx_ap_object.Id").is(apObjectId));
				        Update update = new Update(); 
				        update.set("fx_ap_object", json);
				        update.set("fx_ap_userid", apUserId);
				        update.set("fx_ap_id", FxConstant.AP_SALESFORCE);
				        update.set("fx_create_at", curTime);
				        mongoTemplate.updateFirst(query, update, collection);
					}
				}
			}
		}
	}
	public String getOpportunityFromSf(String instanceURL ,String accessToken) throws Exception{
		//String sfSql = "SELECT+Account.Name,CloseDate,CreatedById,CreatedDate,Description,Id,IsClosed,IsDeleted,Name,OwnerId,StageName,Type+FROM+Opportunity+ORDER+BY+Id+ASC+NULLS+FIRST";
		/***sfSql 1.0.1**/
		String sfSql = "SELECT+AccountId,Amount,CampaignId,CloseDate,CreatedById,CreatedDate,Description,ExpectedRevenue,Fiscal,FiscalQuarter,FiscalYear,ForecastCategory,ForecastCategoryName,HasOpportunityLineItem,Id,IsClosed,IsDeleted,IsExcludedFromTerritory2Filter,IsPrivate,IsWon,LastActivityDate,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,LeadSource,Name,NextStep,OwnerId,Pricebook2Id,Probability,StageName,SystemModstamp,Territory2Id,TotalOpportunityQuantity,Type+FROM+Opportunity+ORDER+BY+Id+ASC+NULLS+FIRST";
		String apiUrl = instanceURL + SfConstant.API_QUERY + sfSql;
		String s = GeneralMethod.requestHeaderSfAPI(apiUrl,accessToken);
		System.out.println(s);
		return s;
	}
	public String getSalesforceObject(String instanceURL ,String accessToken,String apTableName)throws Exception{
		return getSalesforceObjectByTime(instanceURL, accessToken, apTableName, null, null);
	}
	public String getSalesforceObjectByTime(String instanceURL ,String accessToken,String apTableName,String start,String end)throws Exception{
		//1、获取指定apTableName的字段属性，拼成sql
		String apiUrl = instanceURL + SfConstant.API_SOBJECT+apTableName+"/describe";
		String result = GeneralMethod.requestHeaderSfAPI(apiUrl,accessToken);
		JSONObject datajson = JSONObject.fromObject(result);
		JSONArray fields = datajson.getJSONArray("fields");
		int fieldNum = fields.size();
		StringBuffer sql = new StringBuffer();
		sql.append("SELECT+");
		for(int x=0;x<fieldNum;x++){
			JSONObject jobj = fields.getJSONObject(x);
			sql.append(jobj.getString("name"));
			if(x != fieldNum-1){
				sql.append(",");
			}
		}
		sql.append("+FROM+");
		sql.append(apTableName);
		if(start != null){
			sql.append("+WHERE+LastModifiedDate>=");
			sql.append(start);
			sql.append("+AND+LastModifiedDate<=");
			sql.append(end);
		}
		//2、获取对象信息
		String queryUrl = instanceURL + SfConstant.API_QUERY + sql.toString();
		String queryResult = GeneralMethod.requestHeaderSfAPI(queryUrl,accessToken);
		return queryResult;
	}
	public void addOpportunity(List list){
		mongoTemplate.insert(list, "opportunity");
	}
	
	public void insert(List list,String objectName){
		mongoTemplate.insert(list, objectName);
	}
	
	public void dropCollection(String name){
		mongoTemplate.dropCollection(name);
	}
	public void findOpportunity(){
		//1、新建一个SalesForce业务机会对应表
		/*mongoTemplate.dropCollection("sfopportunity");
		mongoTemplate.createCollection("sf_opportunity");*/	
		//dbCollection.drop();
		DBCollection dbCollection = mongoTemplate.getCollection("sf_opportunity");
		System.out.println("**********************");
		DBCursor dbCursor = dbCollection.find();
		Iterator<DBObject> dboIter = dbCursor.iterator();
		while(dboIter.hasNext()){
			DBObject dbo = dboIter.next();
			Map dboMap = dbo.toMap();
			System.out.println(dboMap);
		}
		System.out.println("**********************");
	}
	
	public String getSfUserAccount(String sfUid,String instanceURL ,String accessToken){
		String username = null;
		try {
			String sfSql = "SELECT+Username+FROM+User+WHERE+Id='"+sfUid+"'";
			String apiUrl = instanceURL + SfConstant.API_QUERY + sfSql;
			String data = GeneralMethod.requestHeaderSfAPI(apiUrl,accessToken);
			JSONObject datajson = JSONObject.fromObject(data);
			if(datajson.containsKey("totalSize")){
				int totalSize = datajson.getInt("totalSize");
				if(totalSize == 1){
					JSONArray recordList = datajson.getJSONArray("records");
					JSONObject json = (JSONObject) recordList.get(0);
					username = json.getString("Username");
				}
			}
			System.out.println(username);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return username;
	}
}
