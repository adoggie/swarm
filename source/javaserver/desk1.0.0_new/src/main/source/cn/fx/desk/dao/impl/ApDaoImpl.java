package cn.fx.desk.dao.impl;

import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.stereotype.Service;

import com.mongodb.DBCollection;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;

import cn.fx.desk.dao.ApDao;

/**
 * @author sunxy
 * @version 2015-7-28
 * @des 
 **/
@Service("apDao")
public class ApDaoImpl implements ApDao {
	@Autowired
    private MongoTemplate mongoTemplate;
	public void insert(List list,String collectionName) throws Exception{
		mongoTemplate.insert(list, collectionName);
	}
	public void drop(String collectionName) throws Exception{
		mongoTemplate.dropCollection(collectionName);
	}
	public void find(String collectionName) throws Exception{
System.out.println("************ApDao 数据查询***************"+collectionName);
		DBCollection dbCollection = mongoTemplate.getCollection(collectionName);
		DBCursor dbCursor = dbCollection.find();
		Iterator<DBObject> dboIter = dbCursor.iterator();
		while(dboIter.hasNext()){
			DBObject dbo = dboIter.next();
			Map dboMap = dbo.toMap();
			System.out.println(dboMap);
		}
	}
}
