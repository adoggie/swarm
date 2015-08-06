package cn.fx.desk.zoo;


/**
 * @author sunxy
 * @version 2015-7-6
 * @des cache操作
 **/
public class RedisInvoke {
	
	private static final int TIME_OUT_DEFAULT = 36000;//秒,默认10小时
	
	public static void set(String key,String value){
		RedisTool.jedis().setex(key.getBytes(), TIME_OUT_DEFAULT, ObjectUtil.ObjectToByte(value));
	}
	public static void set(String key,String value,int seconds) throws Exception{
		System.out.println(key.getBytes().length);
		RedisTool.jedis().setex(key.getBytes("UTF-8"),seconds, value.getBytes());
	}
	public static Object get(String key) throws Exception{
		byte[] b = RedisTool.jedis().get(key.getBytes("UTF-8"));
		Object obj = ObjectUtil.ByteToObject(b);
		return obj;
	}
	public static String getString(String key) throws Exception{
		byte[] b = RedisTool.jedis().get(key.getBytes("UTF-8"));
		return new String(b);
	}
	public static void main(String[] args) {
		try {
			RedisInvoke.set("yy", "sunxinyou",1000);
			System.out.println(get("yy"));
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
