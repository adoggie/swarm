package cn.fx.desk.zoo;


/**
 * @author sunxy
 * @version 2015-7-6
 * @des cache操作
 **/
public class RedisInvoke {
	
	private static final int TIME_OUT_DEFAULT = 36000;//秒,默认10小时
	
	public static void set(String key,Object value){
		RedisTool.jedis().setex(key.getBytes(), TIME_OUT_DEFAULT, ObjectUtil.ObjectToByte(value));
	}
	public static void set(String key,Object value,int seconds) throws Exception{
		RedisTool.jedis().setex(key.getBytes("UTF-8"),seconds, ObjectUtil.ObjectToByte(value));
	}
	public static Object get(String key) throws Exception{
		byte[] b = RedisTool.jedis().get(key.getBytes("UTF-8"));
		Object obj = ObjectUtil.ByteToObject(b);
		return obj;
	}
	public static void main(String[] args) {
		
	}

}
