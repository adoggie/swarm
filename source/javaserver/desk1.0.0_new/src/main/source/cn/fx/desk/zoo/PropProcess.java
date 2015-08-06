package cn.fx.desk.zoo;


import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.util.Properties;


/**
 * @author sunxy
 * @version 2014-7-17
 * @des
 **/
public class PropProcess {
	private static Properties properties = new Properties();
	static {
		try {
			String configFileName = "fx.properties";
			java.net.URL fileURL = Thread.currentThread()
					.getContextClassLoader().getResource(configFileName);

			File configFile = null;
			if (fileURL == null) {
				System.out.println(configFileName + " not found in the classpath");
			} else {
				configFile = new File(fileURL.toURI());
			}
			properties.load(new BufferedInputStream(new FileInputStream(configFile)));
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}
	}

	public static String getProperty(String key) {
		System.out.println("**********PropProcess*********key:"+key);
		String defaultValue = "";
		if (key == null)
			return "";

		String v = properties.getProperty(key);
		if (v == null || v.isEmpty())
			return defaultValue;
		else
			return v.trim();
	}
	public static int getPropertyInt(String key) {
		int defaultValue = 0;
		if (key == null)
			return 0;

		String v = properties.getProperty(key);
		if (v == null || v.isEmpty())
			return defaultValue;
		else
			return Integer.parseInt(v.trim());
	}

	public static void main(String[] args) {

	}

}
