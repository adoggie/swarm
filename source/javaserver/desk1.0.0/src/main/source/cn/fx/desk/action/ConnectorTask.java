package cn.fx.desk.action;

import java.util.Map;

import net.sf.json.JSONObject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.fx.desk.service.ApService;
import cn.fx.desk.zoo.DeskResult;

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
		Map map = DeskResult.TaskSuccess();//返回结果
		return map;
	}
}
