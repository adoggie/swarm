package cn.fx.desk.mapper;

import java.util.List;
import java.util.Map;

import cn.fx.desk.entity.ApTables;
import cn.fx.desk.entity.ApTablesTime;


/**
 * @author sunxy
 * @version 2015-6-9
 * @des 
 **/
public interface ApTablesMapper {
	/**根据接入平台获取需要抓取的表*/
	public List<ApTables> getTablesByAppId(int appId);
	
	public ApTablesTime getApTablesTime(Map map);
	public void addApTablesTime(ApTablesTime apTablesTime);
	public void updateApTablesTime(Map map);
}
