package cn.fx.desk.mapper;

import java.util.List;

import cn.fx.desk.entity.ApTables;


/**
 * @author sunxy
 * @version 2015-6-9
 * @des 
 **/
public interface ApTablesMapper {
	/**根据接入平台获取需要抓取的表*/
	public List<ApTables> getTablesByAppId(int appId);
}
