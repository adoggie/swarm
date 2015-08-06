package cn.fx.desk.service.test;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import net.sf.json.JSONObject;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.springframework.context.ApplicationContext;

import cn.fx.desk.dao.DeskDao;
import cn.fx.desk.dao.SfDao;
import cn.fx.desk.entity.OrgUserLogin;
import cn.fx.desk.mapper.OrgUserAppConfigMapper;
import cn.fx.desk.mapper.YhMapper;
import cn.fx.desk.zoo.GeneralMethod;
import cn.fx.desk.zoo.TimeUtil;

/**
 * @author sunxy
 * @version 2015-7-7
 * @des 
 **/
public class DataAddTest {
	SfDao sfDao = null;
	YhMapper yhMapper = null;
	DeskDao deskDao = null;
	OrgUserAppConfigMapper orgUserAppConfigMapper = null;
	
	String getDate(int year,int month,int day){
		//2015-06-11T08:14:22.000+0000
		StringBuffer sb = new StringBuffer(year+"-");
		if(month < 10){
			sb.append("0");
		}
		sb.append(month+"-");
		if(day < 10){
			sb.append("0");
		}
		sb.append(day+"T11:11:11+0000");
		return sb.toString();
	}
	@Test
	public void addSfData(){
		String batchId = GeneralMethod.getBatchId();
		String sfUserId = "00528000000ImzzAAC";
		String time = TimeUtil.getCurTimeFormat();
		int totalSize = 1;
		List<Map> list = new ArrayList<Map>(totalSize);
		Map map = null;
		for(int i=0;i<totalSize;i++){
			//day = c.get(c.get(Calendar.DAY_OF_MONTH)) - i;
			Calendar c = Calendar.getInstance();
			int x = (int) (Math.random()*365+1) ;
			c.set(Calendar.DAY_OF_MONTH, c.get(Calendar.DAY_OF_MONTH)-x);
			String s1 = getDate(c.get(Calendar.YEAR), c.get(Calendar.MONTH)+1, c.get(Calendar.DAY_OF_MONTH));

			map = new HashMap();
			map.put("StageName", "Needs Analysis");
			map.put("Description", "desc");
			map.put("Type", "OldCustomer");
			map.put("OwnerId", "00528000000ImzzAAC");
			map.put("fx_sf_userid", "00528000000ImzzAAC");
			map.put("Name", "op"+i);
			map.put("IsClosed", "false");
			map.put("CreatedById", "00528000000ImzzAAC");
			map.put("IsDeleted", "false");
			map.put("Id", "00628000003SF89AAG"+i);
			map.put("CloseDate", "2017-06-30");
			map.put("CreatedDate", s1);
			Map amap = new HashMap();
			amap.put("Name", "sds");
			map.put("Account", amap);
			/*
			Account={ "attributes" : { "type" : "Account" , "url" : "/services/data/v33.0/sobjects/Account/00128000003AirEAAS"} , "Name" : "sds"}, 
			=Opportunity 2, 
			CreatedDate=2015-06-11T08:14:22.000+0000,
			=*/
			map.put("fx_sf_userid", sfUserId);
			map.put("fx_batch_id", batchId);
			map.put("fx_batch_time", time);
			list.add(map);
		}
		sfDao.addOpportunity(list);
	}
	/**********Desk*************/
	String getDeskDate(int year,int month,int day){
		//2015-06-11T08:14:22.000+0000
		StringBuffer sb = new StringBuffer(year+"-");
		if(month < 10){
			sb.append("0");
		}
		sb.append(month+"-");
		if(day < 10){
			sb.append("0");
		}
		sb.append(day+"T09:09:03Z");
		return sb.toString();
	}
	//@Test
	public void addDeskData(){
		
		int num = 1;
		List<Map> list = new ArrayList<Map>(num);
		Map map = null;
		String batchTime = TimeUtil.getCurTimeFormat();
		String batchId = GeneralMethod.getBatchId();
		for(int i=0;i<num;i++){
			Calendar c = Calendar.getInstance();
			int x = (int) (Math.random()*365+1) ;
			//day = c.get(c.get(Calendar.DAY_OF_MONTH)) - i;
			c.set(Calendar.DAY_OF_MONTH, c.get(Calendar.DAY_OF_MONTH)-x);
			String s1 = getDeskDate(c.get(Calendar.YEAR), c.get(Calendar.MONTH)+1, c.get(Calendar.DAY_OF_MONTH));
			map = new HashMap();
			map.put("id", i);
			map.put("status", "resolved");//current state of the case, one of: new, open, pending, resolved, closed
			map.put("type", "email");//channel of the case, one of: chat, twitter, email, qna, facebook, phone
			map.put("created_at", "2011-07-06T09:09:03Z");
			map.put("resolved_at", s1);
			map.put("company", "sds");
			map.put("rating", 4);//放入反馈评分
			map.put("rating_type", "yes_or_no");//放入反馈评分
			map.put("fx_desk_userid", "24509826@qq.com");
			map.put("fx_batch_id", batchId);
			map.put("fx_batch_time", batchTime);
			list.add(map);
		}
		deskDao.addDeskCaseInfo(list);
	}
	@Before
	public void init() {
		ApplicationContext aCtx = ApplicationContextUtil.getContext();
		sfDao = (SfDao) aCtx.getBean("sfDao");
		yhMapper = (YhMapper) aCtx.getBean("yhMapper");
		orgUserAppConfigMapper = (OrgUserAppConfigMapper) aCtx.getBean("orgUserAppConfigMapper");
		deskDao = (DeskDao) aCtx.getBean("deskDao");
	}
	@After
	public void destory() {
	}
}
