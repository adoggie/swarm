package cn.fx.desk.action;

import java.util.HashMap;
import java.util.Map;

import net.sf.json.JSONObject;

import org.apache.commons.httpclient.NameValuePair;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.fx.desk.service.YhService;
import cn.fx.desk.zoo.FxConstant;
import cn.fx.desk.zoo.FxProperties;
import cn.fx.desk.zoo.GeneralMethod;

/**
 * @author sunxy
 * @version 2015-7-1
 * @des 
 **/
@Controller
@RequestMapping("/login")
public class Login {
	@Autowired
	YhService yhService;
	@RequestMapping(value = "/check", method = RequestMethod.POST)
	public @ResponseBody Map check(@RequestParam("user")String user,@RequestParam("password")String password
			,@RequestParam("domain")String domain) {
		Map users = new HashMap();
		int status = 1;
		//@RequestParam(value = "device_id",required = false)String device_id
		//platform 
		NameValuePair[] param = { new NameValuePair("user",user),  
                new NameValuePair("password",password),  
                new NameValuePair("domain",domain)} ;  
		JSONObject obj = GeneralMethod.postParms(FxProperties.USER_CHECK, param);//登陆校验
System.out.println("444444obj:"+obj);
		if(obj!=null&&obj.containsKey("status")){
			status = obj.getInt("status");
			if(status == 0){//登陆校验成功，得到user_id,user_name,user_type,domain
				int userId = obj.getInt("user_id");
				String userName = obj.getString("user_name");
				int userType = obj.getInt("user_type");
				//String domain = obj.getString("domain");
				String sid = GeneralMethod.getRandomString(8);
				//添加到登录日志信息表中...
				yhService.addOrgUserLogin(userId, userName, userType, domain, sid);
				
				Map subMap = new HashMap();
				subMap.put("uid", userId);
				subMap.put("sid", sid);
				users.put("result", subMap);
			}else{
				if(obj.containsKey("errcode")){
					users.put("errcode", obj.getInt("errcode"));
				}
				if(obj.containsKey("errmsg")){
					users.put("errmsg", obj.getString("errmsg"));
				}
			}
		}
		users.put("status", status);
		return users;
	}
}
