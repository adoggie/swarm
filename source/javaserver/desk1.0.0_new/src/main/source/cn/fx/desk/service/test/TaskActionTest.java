package cn.fx.desk.service.test;

import cn.fx.desk.zoo.GeneralMethod;
import net.sf.json.JSONObject;

/**
 * @author sunxy
 * @version 2015-7-2
 * @des 
 **/
public class TaskActionTest {
	public static void taskcall(){
		String taskUrl = "http://172.20.0.189:8800/desk/WEBAPI/connector/task.do";
		try {
		    JSONObject params = new JSONObject();
		    params.put("task_id", "task_id");
		    params.put("callback_uri", "callback_uri");
		    params.put("job", "job");
		    JSONObject param3 = new JSONObject();
		    param3.put("user_acct", "user_acct");
		    param3.put("biz_model", "biz_model");
		    /*JSONArray params2 = new JSONArray();
		    params2.add(param3);
		    params.put("job", params2);*/
		    params.put("job", param3);
		    String ret = GeneralMethod.doPost(taskUrl, params).toString();
		    System.out.println(ret);
		}catch (Exception e) {
			e.printStackTrace();
		}
	}
	public static void deskLogin(){
		String taskUrl = "http://172.20.0.189:8800/desk/WEBAPI/connector/task.do";
		try {
		    JSONObject params = new JSONObject();
		    params.put("task_id", "task_id");
		    params.put("callback_uri", "callback_uri");
		    params.put("job", "job");
		    JSONObject param3 = new JSONObject();
		    param3.put("user_acct", "user_acct");
		    param3.put("biz_model", "biz_model");
		    /*JSONArray params2 = new JSONArray();
		    params2.add(param3);
		    params.put("job", params2);*/
		    params.put("job", param3);
		    String ret = GeneralMethod.doPost(taskUrl, params).toString();
		    System.out.println(ret);
		}catch (Exception e) {
			e.printStackTrace();
		}
	}
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		taskcall();
		
	}

}
