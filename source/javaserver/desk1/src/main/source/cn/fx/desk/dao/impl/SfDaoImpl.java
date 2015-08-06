package cn.fx.desk.dao.impl;

import java.util.Iterator;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.stereotype.Service;

import cn.fx.desk.dao.SfDao;
import cn.fx.desk.zoo.FxConstant;
import cn.fx.desk.zoo.GeneralMethod;
import cn.fx.desk.zoo.SfConstant;

import com.mongodb.DBCollection;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;

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
	public String getOpportunityFromSf(String instanceURL ,String accessToken)  throws Exception{
		//String sfSql = "SELECT+Account.Name,CloseDate,CreatedById,CreatedDate,Description,Id,IsClosed,IsDeleted,Name,OwnerId,StageName,Type+FROM+Opportunity+ORDER+BY+Id+ASC+NULLS+FIRST";
		/***sfSql 1.0.1**/
		String sfSql = "SELECT+AccountId,Amount,CampaignId,CloseDate,CreatedById,CreatedDate,Description,ExpectedRevenue,Fiscal,FiscalQuarter,FiscalYear,ForecastCategory,ForecastCategoryName,HasOpportunityLineItem,Id,IsClosed,IsDeleted,IsExcludedFromTerritory2Filter,IsPrivate,IsWon,LastActivityDate,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,LeadSource,Name,NextStep,OwnerId,Pricebook2Id,Probability,StageName,SystemModstamp,Territory2Id,TotalOpportunityQuantity,Type+FROM+Opportunity+ORDER+BY+Id+ASC+NULLS+FIRST";
		String apiUrl = instanceURL + SfConstant.API_QUERY + sfSql;
		String s = GeneralMethod.requestHeaderSfAPI(apiUrl,accessToken);
		System.out.println(s);
		return s;
	}
	public String getSalesforceObject(String instanceURL ,String accessToken,String apTableName)throws Exception{
		//1、获取指定apTableName的字段属性，拼成sql
		String apiUrl = instanceURL + "/services/data/v33.0/sobjects/"+apTableName+"/describe";
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
		//2、获取对象信息
		String queryUrl = instanceURL + SfConstant.API_QUERY + sql.toString();
		String queryResult = GeneralMethod.requestHeaderSfAPI(queryUrl,accessToken);
		return queryResult;
		/*if(FxConstant.OBJ_OPPORTUNITY.equals(object)){
			sql = "SELECT+AccountId,Amount,CampaignId,CloseDate,CreatedById,CreatedDate,Description,ExpectedRevenue,Fiscal,FiscalQuarter,FiscalYear,ForecastCategory,ForecastCategoryName,HasOpportunityLineItem,Id,IsClosed,IsDeleted,IsExcludedFromTerritory2Filter,IsPrivate,IsWon,LastActivityDate,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,LeadSource,Name,NextStep,OwnerId,Pricebook2Id,Probability,StageName,SystemModstamp,Territory2Id,TotalOpportunityQuantity,Type+FROM+Opportunity+ORDER+BY+Id+ASC+NULLS+FIRST";
		}else if(FxConstant.OBJ_ACCOUNT.equals(object)){
			sql = "SELECT+AccountNumber,AccountSource,AnnualRevenue,BillingAddress,BillingCity,BillingCountry,BillingLatitude,BillingLongitude,BillingPostalCode,BillingState,BillingStreet,CleanStatus,CreatedById,CreatedDate,DandbCompanyId,Description,DunsNumber,Fax,Id,Industry,IsDeleted,Jigsaw,JigsawCompanyId,LastActivityDate,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,MasterRecordId,NaicsCode,NaicsDesc,Name,NumberOfEmployees,OwnerId,Ownership,ParentId,Phone,PhotoUrl,Rating,ShippingAddress,ShippingCity,ShippingCountry,ShippingLatitude,ShippingLongitude,ShippingPostalCode,ShippingState,ShippingStreet,Sic,SicDesc,Site,SystemModstamp,TickerSymbol,Tradestyle,Type,Website,YearStarted+FROM+Account";
		}else if("opportunity_line_item".equals(object)){
			sql = "SELECT+CreatedById,CreatedDate,Description,Id,IsDeleted,LastModifiedById,LastModifiedDate,ListPrice,Name,OpportunityId,PricebookEntryId,Product2Id,ProductCode,Quantity,ServiceDate,SortOrder,SystemModstamp,TotalPrice,UnitPrice+FROM+OpportunityLineItem";
		}else if("product".equals(object)){
			sql = "SELECT+CreatedById,CreatedDate,Description,Family,Id,IsActive,IsDeleted,LastModifiedById,LastModifiedDate,Name,ProductCode,SystemModstamp+FROM+Product2";
		}else{
		}
		if(sql != null){
			String apiUrl = instanceURL + SfConstant.API_QUERY + sql;
			String result = GeneralMethod.requestHeaderSfAPI(apiUrl,accessToken);
			return result;
		}
		return null;*/
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
