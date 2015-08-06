package ztest;

import java.util.HashMap;
import java.util.Map;

import cn.fx.desk.zoo.RedisTool;

import redis.clients.jedis.Jedis;

/**
 * @author sunxy
 * @version 2015-7-6
 * @des 
 **/
public class RedisTest {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		Jedis jedis = new Jedis("172.20.0.189", 6379);
		Map map = new HashMap();
		map.put("sun", "xy");
		map.put("name", "xinyou");
		jedis.set("name", "samir");
		jedis.hmset("map", map);
		System.out.println(jedis.hmget("map","sun"));
		System.out.println(jedis.get("name"));
		
		RedisTool.jedis().set("sxy", "ssssss");
		System.out.println(RedisTool.jedis().get("sxy"));
		
		
	}

}
