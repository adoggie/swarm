package cn.fx.desk.zoo;

import javax.crypto.Mac;
import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;
/**
 * @author sunxy
 * @version 2015-7-9
 * @des 
 **/
public class Signer {
	private static final String MAC_NAME = "HmacSHA1";  
    private static final String ENCODING = "UTF-8";  
    
	/*
	 * 展示了一个生成指定算法密钥的过程 初始化HMAC密钥 
	 * @return 
	 * @throws Exception
	 * 
	  public static String initMacKey() throws Exception {
	  //得到一个 指定算法密钥的密钥生成器
	  KeyGenerator KeyGenerator keyGenerator =KeyGenerator.getInstance(MAC_NAME); 
	  //生成一个密钥
	  SecretKey secretKey =keyGenerator.generateKey();
	  return null;
	  }
	 */
    
    /** 
     * 使用 HMAC-SHA1 签名方法对对encryptText进行签名 
     * @param encryptText 被签名的字符串 
     * @param encryptKey  密钥 
     * @return 
     * @throws Exception 
     */  
    public static byte[] HmacSHA1Encrypt(String encryptText, String encryptKey) throws Exception   
    {         
    	byte[] data=encryptKey.getBytes(ENCODING);
    	//根据给定的字节数组构造一个密钥,第二参数指定一个密钥算法的名称
        SecretKey secretKey = new SecretKeySpec(data, MAC_NAME); 
        //生成一个指定 Mac 算法 的 Mac 对象
        Mac mac = Mac.getInstance(MAC_NAME); 
        //用给定密钥初始化 Mac 对象
        mac.init(secretKey);  
        
        byte[] text = encryptText.getBytes(ENCODING);  
        //完成 Mac 操作 
        return mac.doFinal(text);  
    }  
	/**
	 * @param args
	 * @throws Exception 
	 */
	public static void main(String[] args) throws Exception {
		byte[] b = HmacSHA1Encrypt("GET&http%3A%2F%2Foapi.vancl.com%2Foauthnew%2Faccess-token.ashx&oauth_consumer_key%3D873786fd712936a3a1f3cc9b8b1a6b94%26oauth_nonce%3D9ae3a3b8051b466c85c8d0107c8423c3%26oauth_signature_method%3DHMAC-SHA1%26oauth_timestamp%3D1321584266%26oauth_token%3D1a6b213f81ef48b4b94524c2cfff50d0%26oauth_verifier%3DNLBRVOZRQXWZARCPDQ8XGA%253D%253D%26oauth_version%3D1.0", "3a58dd9023cf1adec08f0656acc5bf95&2c52bae787544992b20f21e01635ab67");
		String s = Base64Util.encode(b);
System.out.println(s);
//s:	reRgnrj5U0jItJ5rz6yB9bE3tAw=
//QWcdAijSDZAUdr4TGXJFm1J42j8%3D
	}

}





