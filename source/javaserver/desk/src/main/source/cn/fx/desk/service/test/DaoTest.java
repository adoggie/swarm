package cn.fx.desk.service.test;

import java.util.HashMap;
import java.util.Map;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.springframework.context.ApplicationContext;

import cn.fx.desk.dao.SfDao;
import cn.fx.desk.entity.ApTablesTime;
import cn.fx.desk.entity.OrgUserLogin;
import cn.fx.desk.mapper.ApTablesMapper;
import cn.fx.desk.mapper.OrgUserAppConfigMapper;
import cn.fx.desk.mapper.YhMapper;

/**
 * @author sunxy
 * @version 2015-6-9
 * @des
 **/
public class DaoTest {
	SfDao sfDao = null;
	YhMapper yhMapper = null;
	OrgUserAppConfigMapper orgUserAppConfigMapper = null;
	ApTablesMapper apTablesMapper = null;
	
	//@Test
	public void userLoginTest(){
		OrgUserLogin o = new OrgUserLogin();
		o.setUserId(1);
		o.setUserName("Name1");
		o.setSid("sss");
		o.setDomain("domain");
		yhMapper.addOrgUserLogin(o);
		OrgUserLogin ul = yhMapper.getOrgUserLogin(1);
		System.out.println(ul.getUserName());
	}
	
	@Test
	public void getDataFromUrl(){
		String sfUid = "00528000000ImzzAAC";
		String instanceURL = "https://ap2.salesforce.com";
		String accessToken = "00D28000000KcB7!AQkAQD72zY19QgrPevCDfenN0yBtbjhWi6.SDnlMY9eBuKqnbtt4YIXnlelc4dEhpt6Lu4UZWFFPDpQSuEUQmYHnXjrP5Emy";
		//sfDao.findOpportunity();
		Map map = new HashMap();
		ApTablesTime apt = new ApTablesTime();
		apt.setAppId(1);
		apt.setAppTableName("name1");
		apt.setAppUserId("sf001");
		apt.setUpdateAt("1");
		//apTablesMapper.addApTablesTime(apt);
		sfDao.test();
		/*try {
			sfDao.getOpportunityFromSf("https://ap2.salesforce.com","00D28000000KcB7!AQkAQPONOHc2j9ARZs4CuENY8edTD_t1vkgb91NQrP66vnikN6lOdw4jDUtMVNDPagpR91ieEEYlf5wNkBKif6SepXK8FfWr");
		} catch (Exception e) {
			e.printStackTrace();
		}*/
		//sfDao.dropCollection("sfopportunity");
		/*int r = yhMapper.find();
		System.out.println(r);
		System.out.println(22);*/
		//sfUserDao.getSfUserAccount(sfUid, instanceURL, accessToken);
		
	}
//	@Test
	public void addAppConfig(){
		/*(#app_id#,#user_id#,#is_active#,#app_access_token#,current_timestamp
				<if test="app_instance_url != null">
					,#{app_instance_url}
				</if>
				<if test="app_user_id != null">
					,#{app_user_id}
				</if>*/
//		int n = orgUserAppConfigMapper.find();
//		System.out.println("++++++++++++++"+n);
		Map map = new HashMap();
		map.put("app_id", 1);
		map.put("user_id", 1);
		map.put("is_active", true);
		map.put("app_access_token", "token.....abc");
		map.put("app_instance_url", "url");
		map.put("app_user_id", "superman");
		orgUserAppConfigMapper.addAppConfig(map);
	}
	@Before
	public void init() {
		ApplicationContext aCtx = ApplicationContextUtil.getContext();
		sfDao = (SfDao) aCtx.getBean("sfDao");
		yhMapper = (YhMapper) aCtx.getBean("yhMapper");
		orgUserAppConfigMapper = (OrgUserAppConfigMapper) aCtx.getBean("orgUserAppConfigMapper");
		apTablesMapper = (ApTablesMapper) aCtx.getBean("apTablesMapper");
	}
	@After
	public void destory() {
	}
}
