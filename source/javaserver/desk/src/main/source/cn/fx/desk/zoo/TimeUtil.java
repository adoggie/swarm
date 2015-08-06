package cn.fx.desk.zoo;


import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.TimeZone;

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
	 * 按指定时区返回指定格式的当前时间
	 * @param format YYYY-MM-DD'T'hh:mm:ss+hh:mm
	 * @param timeZone	UTC、GMT、GMT+8、America/Los_Angeles
	 * @return
	 */
	public static String getCurTimeFormatTimeZone(String format,String timeZone){
		SimpleDateFormat formatter = new SimpleDateFormat(format);
		formatter.setTimeZone(TimeZone.getTimeZone(timeZone));
		String datetime = formatter.format(new Date());
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
	public static void main(String[] args){
		//String s1 = getCurTimeFormat("YYYY-MM-DDThh:mm:ss+hh:mm");
		String s2 = getCurTimeFormat("yyyy-MM-dd'T'HH:mm:ss.z");
		System.out.println(s2);
		String s3 = getCurTimeFormat("yyyy-MM-dd'T'HH:mm:ss.Z");
		System.out.println(s3);
		String format = "YYYY-MM-DD'T'hh:mm:ss+hh:mm";
		SimpleDateFormat formatter = new SimpleDateFormat(format);
		//formatter.setTimeZone(TimeZone.getTimeZone("America/Los_Angeles"));
		formatter.setTimeZone(TimeZone.getTimeZone("GMT"));
		String datetime = formatter.format(new Date());
		System.out.println(datetime);
		
		
		String format2 = "YYYY-MM-dd'T'hh:mm:ss'.000Z'";
		SimpleDateFormat formatter2 = new SimpleDateFormat(format2);
		//formatter.setTimeZone(TimeZone.getTimeZone("America/Los_Angeles"));
		formatter2.setTimeZone(TimeZone.getTimeZone("GMT"));
		String datetime2 = formatter2.format(new Date());
		System.out.println(datetime2);
		//new SimpleDateFormat(pattern, locale)
		
		System.out.println(System.currentTimeMillis());
	}
	
	
    
}
