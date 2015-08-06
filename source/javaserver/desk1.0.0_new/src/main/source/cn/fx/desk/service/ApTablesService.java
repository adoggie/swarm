package cn.fx.desk.service;

import java.util.List;
import java.util.Map;

import cn.fx.desk.entity.ApTables;
import cn.fx.desk.entity.ApTablesTime;

/**
 * @author sunxy
 * @version 2015-7-28
 * @des 
 **/
public interface ApTablesService {
	/**根据接入平台获取需要抓取的表*/
	public List<ApTables> getTablesByAppId(int appId);
	
	public ApTablesTime getApTablesTime(Map map);
	public void addApTablesTime(int appId,String appTableName,String appUserId,String updateAt);
	public void updateApTablesTime(String updateAt,int id);
}
