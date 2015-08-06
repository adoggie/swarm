package cn.fx.desk.zoo;


import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

/**
 * @author sunxy
 * @version 2014-6-12
 **/
public class TimeUtil {
    /**
     * 日期格式转换
     */
	public static String simpledateformat(Date date){
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String dates="";
		if(date!=null){
			dates=sdf.format(date);
		}
		return dates;
	}
	
	/**
	 *	long型时间转换成指定格式的时间类型 
	 */
	public static String longTimeToStrFormat(long time,String format){
		Date date = new Date(time);
    	SimpleDateFormat formatter = new SimpleDateFormat(format);
 	    String datetime = formatter.format(date);
 	    return datetime;
	}
	/**
	 * 字符串型时间格式 转换成long型时间 
	 */
	public static long strTimeToLong(String time){
		String format = "yyyy-MM-dd HH:mm:ss";
		return strTimeToLong(time, format);
	}
	public static int minDiffToNow(String time){
		String format = "yyyy-MM-dd HH:mm:ss";
		long beginTime = strTimeToLong(time,format);
		long endTime = System.currentTimeMillis();
		System.out.println(endTime+"/"+beginTime);
		int min = (int) ((endTime - beginTime)/(1000*60));
		return min;
	}
	public static long strTimeToLong(String time,String format){
		SimpleDateFormat sdf=new SimpleDateFormat(format);
		long longTime = 0;
		try {
			longTime = sdf.parse(time).getTime();
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return longTime;
	}
	/**
	 * 按指定格式返回当前时间
	 * eg.'yyyy-MM-dd HH:mm:ss' 
	 */
	public static String getCurTimeFormat(String format){
		Date date = new Date();
 	    return getDateTimeFormat(date,format);
	}
	public static String getDateTimeFormat(Date date,String format){
		SimpleDateFormat formatter = new SimpleDateFormat(format);
		String datetime = formatter.format(date);
 	    return datetime;
	}
	/**
	 * @return	yyyy-MM-dd HH:mm:ss
	 */
	public static String getCurTimeFormat(){
 	    return getCurTimeFormat("yyyy-MM-dd HH:mm:ss");
	}
	public static Date getDateAfterHourDefault(){
		return getDateAfterHour(8);
	}
	public static Date getDateAfterHour(int hour){
		Date date = new Date(System.currentTimeMillis() + hour*3600000);
		return date;
	}
	static String getDate(int year,int month,int day){
		//2015-06-11T08:14:22.000+0000
		StringBuffer sb = new StringBuffer(year+"-");
		if(month < 10){
			sb.append("0");
		}
		sb.append(month+"-");
		if(day < 10){
			sb.append("0");
		}
		sb.append(day+"T11:11:11+0000");
		return sb.toString();
	}
	public static void main(String[] s){
		
	}
	
	
    
}
