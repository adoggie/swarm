package cn.fx.desk.action;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

/**
 * @author sunxy
 * @version 2015-6-19
 * @des 
 **/
@Controller
@RequestMapping("/WEBAPI")
public class WebApi {
	@RequestMapping(value = "/login.do")
	public @ResponseBody ModelAndView login() {
		System.out.println("1111111111");
		ModelAndView mv = new ModelAndView("/index");
		
		return mv;
	}
	@RequestMapping(value = "/ueamanagelisteisoo")
	public ModelAndView ueamanagelisteisoo() {
		ModelAndView mv = new ModelAndView("/exams/ueamanagelist/ueamanagelisteisoo");
		return mv;
	}
	
	
}
