package cn.fx.desk.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cn.fx.desk.entity.ApTables;
import cn.fx.desk.entity.ApTablesTime;
import cn.fx.desk.mapper.ApTablesMapper;
import cn.fx.desk.service.ApTablesService;

/**
 * @author sunxy
 * @version 2015-7-28
 * @des 
 **/
@Service("apTablesService")
public class ApTablesServiceImpl implements ApTablesService {
	@Autowired
	private ApTablesMapper apTablesMapper;
	/**根据接入平台获取需要抓取的表*/
	public List<ApTables> getTablesByAppId(int appId){
		return apTablesMapper.getTablesByAppId(appId);
	}
	
	public ApTablesTime getApTablesTime(Map map){
		return apTablesMapper.getApTablesTime(map);
	}
	public void addApTablesTime(int appId,String appTableName,String appUserId,String updateAt){
		ApTablesTime apTablesTime = new ApTablesTime();
		apTablesTime.setAppId(appId);
		apTablesTime.setAppTableName(appTableName);
		apTablesTime.setAppUserId(appUserId);
		apTablesTime.setUpdateAt(updateAt);
		apTablesMapper.addApTablesTime(apTablesTime);
	}
	public void updateApTablesTime(String updateAt,int id){
		Map map = new HashMap();
		map.put("id", id);
		map.put("updateAt", updateAt);
		apTablesMapper.updateApTablesTime(map);
	}
}
