package cn.fx.desk.service.test;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.springframework.context.ApplicationContext;

import cn.fx.desk.dao.DeskDao;
import cn.fx.desk.service.DeskService;

/**
 * @author sunxy
 * @version 2015-6-30
 * @des 
 **/
public class DeskTest {
	DeskDao deskDao = null;
	DeskService deskService = null;
	@Test
	public void deskTest(){
		String instanceUrl = "https://51deskex.desk.com";
		String username = "24509826@qq.com";
		String password = "!QAZ2wsx";
		String notiUrl = null; 
		//deskDao.deskCases(username, password, instanceUrl, notiUrl);
//		deskService.getCaseFromDesk(GeneralMethod.getBatchId(), 1);
		//deskDao.findDeskCase();
		try {
			//deskDao.getDeskDataOAuth("A00apQe0X3m841q1j1Q1", "1biTOW9kWw0tfWTF4OJfKwniHqCeB1Nexbg81G9f", "yy002", FxConstant.DESK_API_CASE);
//			deskDao.getDeskDataOAuth("A00apQe0X3m841q1j1Q1", "1biTOW9kWw0tfWTF4OJfKwniHqCeB1Nexbg81G9f", "yy002", FxConstant.DESK_API_CASE);
			//deskService.getCaseFromDesk(GeneralMethod.getBatchId(), 1);
			deskService.getDeskObject(1);
			//deskDao.getStringFromDesk("1378661788@qq.com", "Sunxinyou1234", "yy001", "/api/v2/users/me");
		} catch (Exception e) {
			e.printStackTrace();
		}
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
