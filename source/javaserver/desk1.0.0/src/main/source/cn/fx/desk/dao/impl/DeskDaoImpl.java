package cn.fx.desk.dao.impl;

import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import oauth.signpost.OAuthConsumer;
import oauth.signpost.basic.DefaultOAuthConsumer;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.stereotype.Service;

import com.mongodb.DBCollection;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;

import cn.fx.desk.dao.DeskDao;
import cn.fx.desk.zoo.DeskConstant;
import cn.fx.desk.zoo.GeneralMethod;

/**
 * @author sunxy
 * @version 2015-6-29
 * @des 
 **/
@Service("deskDao")
public class DeskDaoImpl implements DeskDao {
	@Autowired
    private MongoTemplate mongoTemplate;
	
	private static final String CONSUMER_KEY = "ZgHC5EBve8nZrH7l3ypw";
	private static final String CONSUMER_SECRET = "m3fczzJbOzt8L97qGwtMV1xmYnHbYALC00rYxvVd";
	/**
	 * 
	 * @param username
	 * @param password
	 * @param instanceUrl	https://hehong.desk.com
	 */
	public String deskCases(String token,String secret,String instanceUrl){
		/*if(!instanceUrl.contains("https://")){
			instanceUrl = "https://"+instanceUrl;
		}
		String url = instanceUrl+"/api/v2/cases";
		String result = GeneralMethod.httbBasicByUsername(url, username, password, notiUrl);
		return result;*/
		return getStringFromDesk(token, secret, instanceUrl, DeskConstant.DESK_API_CASE);
	}
	public String getStringFromDesk(String token,String secret,String instanceUrl,String apiUrl){
		if(!instanceUrl.contains("https://")){
			instanceUrl = "https://"+instanceUrl;
		}
		if(!instanceUrl.contains(".desk.com")){
			instanceUrl = instanceUrl+".desk.com";
		}
		String url = instanceUrl+apiUrl;
		String result = GeneralMethod.httbBasicByUsername(url, token, secret);
		return result;
	}
	public String getDeskData(String token,String secret,String instanceUrl,String apiUrl) throws Exception{
		OAuthConsumer consumer = new DefaultOAuthConsumer(CONSUMER_KEY,CONSUMER_SECRET);
		/*consumer.setTokenWithSecret("5wpIOWEkoQjXBOQyhXOu", "LLyLjrYvwlQ8Fia8c6zwoK1ak945zT5cRpwOYr5k");
		URL url = new URL("https://yy001.desk.com/api/v2/cases");*/
		if(!instanceUrl.contains("https://")){
			instanceUrl = "https://"+instanceUrl;
		}
		if(!instanceUrl.contains(".desk.com")){
			instanceUrl = instanceUrl+".desk.com";
		}
		consumer.setTokenWithSecret(token, secret);
		URL url = new URL(instanceUrl+apiUrl);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        consumer.sign(conn);
        conn.connect();
        StringBuffer res = new StringBuffer(); 
        java.io.BufferedReader in = new java.io.BufferedReader(new java.io.InputStreamReader(conn.getInputStream(),"UTF-8"));
		String line;
		while ((line = in.readLine()) != null) {
			res.append(line);
		}
		System.out.println("res:"+res.toString());
		in.close();
		return res.toString();
	}
	
	public void addDeskCaseInfo(List list){
		/*mongoTemplate.dropCollection("desk_case");
		mongoTemplate.createCollection("desk_case");*/
		mongoTemplate.insert(list, "desk_case");
	}
	public void findDeskCase(){
		DBCollection dbCollection = mongoTemplate.getCollection("desk_case");
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
}
