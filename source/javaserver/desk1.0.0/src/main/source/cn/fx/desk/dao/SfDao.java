package cn.fx.desk.dao;

import java.util.List;
import java.util.Map;


/**
 * @author sunxy
 * @version 2015-6-15
 * @des 
 **/
public interface SfDao {
	public String getSfUserAccount(String sfUid,String instanceURL ,String accessToken);
	
	public String getOpportunityFromSf(String instanceURL ,String accessToken)  throws Exception;
	public void addOpportunity(List<Map> list);
	
	public void dropCollection(String name);
	public void findOpportunity();
}
