package cn.fx.desk.service.test;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.springframework.context.ApplicationContext;

import cn.fx.desk.dao.DeskDao;
import cn.fx.desk.service.DeskService;
import cn.fx.desk.zoo.GeneralMethod;

/**
 * @author sunxy
 * @version 2015-7-7
 * @des 
 **/
public class ApServiceTest {
	DeskDao deskDao = null;
	DeskService deskService = null;
	@Test
	public void deskTest(){
		String instanceUrl = "https://51deskex.desk.com";
		String username = "24509826@qq.com";
		String password = "!QAZ2wsx";
		String notiUrl = null; 
		//deskDao.deskCases(username, password, instanceUrl, notiUrl);
		deskService.getCaseFromDesk(GeneralMethod.getBatchId(), 1);
		System.out.println("^^^^^^^^^^^^^^^^^^^^^^^^^^^");
		//deskDao.findDeskCase();
	}
	@Before
	public void init() {
		ApplicationContext aCtx = ApplicationContextUtil.getContext();
		deskDao = (DeskDao) aCtx.getBean("deskDao");
		deskService = (DeskService) aCtx.getBean("deskService");
	}
	@After
	public void destory() {
	}
}
