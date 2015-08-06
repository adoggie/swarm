package cn.fx.desk.service.test;

import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * @author sunxy
 * @version 2015-6-9
 * @des 
 **/
public class ApplicationContextUtil implements ApplicationContextAware {
	private static ApplicationContext applicationContext;
	@Override
	public void setApplicationContext(ApplicationContext contex)
			throws BeansException {
		applicationContext = contex;
	}
	public static ApplicationContext getContext() {
		if(applicationContext == null){
			applicationContext = new ClassPathXmlApplicationContext(   
					"classpath:application.xml");
		}
		return applicationContext;
	}
}
