package cn.fx.desk.zoo;

import java.util.HashMap;
import java.util.Map;

/**
 * @author sunxy
 * @version 2015-7-2
 * @des 返回结果格式处理
 **/
public class DeskResult {
	public static Map TaskSuccess(){
		Map map = new HashMap(2);
		map.put("status", 0);
		Map subMap = new HashMap(1);
		subMap.put("instance_uri", DeskProperties.INSTANCE_URI);
		map.put("result", subMap);
		return map;
	}
	
	public static Map ReturnError(int errcode,String errmsg){
		Map map = new HashMap(3);
		map.put("status", 1);
		map.put("errcode", errcode);
		map.put("errmsg", errmsg);
		return map;
	}
	
	public static Map TaskSuccessStatus(){
		Map map = new HashMap(2);
		map.put("status", 0);
		return map;
	}
}
