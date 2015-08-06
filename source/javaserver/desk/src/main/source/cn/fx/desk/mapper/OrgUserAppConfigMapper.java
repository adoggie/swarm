package cn.fx.desk.mapper;

import java.util.Map;

import cn.fx.desk.entity.OrgUserAppConfig;

/**
 * @author sunxy
 * @version 2015-6-23
 * @des 
 **/
public interface OrgUserAppConfigMapper {
	public OrgUserAppConfig getAppConfig(Map map);
	public void addAppConfig(Map map);
	public void updateAppConfig(Map map);
	public int find();
}
