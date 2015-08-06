package cn.fx.desk.dao.impl;

import java.util.Iterator;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.stereotype.Service;

import com.mongodb.DBCollection;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;

import cn.fx.desk.dao.SfDao;
import cn.fx.desk.zoo.GeneralMethod;
import cn.fx.desk.zoo.SfConstant;

/**
 * @author sunxy
 * @version 2015-6-15
 * @des 
 **/
@Service("sfDao")
public class SfDaoImpl implements SfDao{
	@Autowired
    private MongoTemplate mongoTemplate;
	public void addSfOpportunity(){
		
	}
	public String getOpportunityFromSf(String instanceURL ,String accessToken)  throws Exception{
		String sfSql = "SELECT+Account.Name,CloseDate,CreatedById,CreatedDate,Description,Id,IsClosed,IsDeleted,Name,OwnerId,StageName,Type+FROM+Opportunity+ORDER+BY+Id+ASC+NULLS+FIRST";
		String apiUrl = instanceURL + SfConstant.API_QUERY + sfSql;
		String s = GeneralMethod.requestHeaderSfAPI(apiUrl,accessToken);
		System.out.println(s);
		return s;
	}
	public void addOpportunity(List list){
		mongoTemplate.insert(list, "sf_opportunity");
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
