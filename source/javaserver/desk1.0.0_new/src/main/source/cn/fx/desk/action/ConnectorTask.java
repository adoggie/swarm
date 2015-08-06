package cn.fx.desk.action;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONObject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import cn.fx.desk.service.ApService;
import cn.fx.desk.zoo.FxResult;

/**
 * @author sunxy
 * @version 2015-7-2
 * @des 
 **/
@Controller
@RequestMapping("/WEBAPI")
public class ConnectorTask {
	@Autowired
	private ApService apService;
	@RequestMapping(value = "/connector/task" ,method=RequestMethod.POST)
	public @ResponseBody Map deskCheck(@RequestBody JSONObject jsonObj){
		System.out.println("======任务调度=========:"+jsonObj);
		apService.connectorTaskInvoke(jsonObj);//任务调度
		Map map = FxResult.TaskSuccess();//返回结果
		return map;
	}
	@RequestMapping(value = "/connector/task2" ,method=RequestMethod.GET)
	public ModelAndView deskLogin(HttpServletRequest request) throws Exception{
		JSONObject params = new JSONObject();
	    params.put("task_id", "task_id");
	    params.put("callback_uri", "callback_uri");
	    JSONObject param3 = new JSONObject();
	    param3.put("user_id", Integer.parseInt(request.getParameter("user_id")));
	    param3.put("user_acct", "user_acct");
	    param3.put("biz_model", Integer.parseInt(request.getParameter("biz_model")));
	    params.put("job", param3);
	    apService.connectorTaskInvoke(params);//任务调度
	    request.setAttribute("success", "抓取数据成功!");
		String url = "/index.jsp";
		ModelAndView mv = new ModelAndView("redirect:"+url);
		return mv;
	}
}
