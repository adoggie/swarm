package ztest;

import net.sf.json.JSONObject;

import org.apache.commons.codec.binary.Base64;
 
import java.util.Arrays;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.net.URLEncoder;
 
import java.security.MessageDigest;
import java.security.SecureRandom;
 
import javax.crypto.Cipher;
import javax.crypto.Mac;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
 
public class SSO
{
   private static String SITE_KEY = "hehong"; // this has to be all lower cases
   private static String API_KEY = "Xjr3oCAZJJqXWvpcdL0Y";
// you'll find the multipass key in your admin
   
   public static void main(String[] args)
   {
       try {
         System.out.println("== Generating ==");
   
         System.out.println("    Create the encryption key using a 16 byte SHA1 digest of your api key and subdomain");
         String salted = API_KEY + SITE_KEY;
         MessageDigest md = MessageDigest.getInstance("SHA1");
         md.update(salted.getBytes("utf-8"));
         byte[] digest = md.digest();
         SecretKeySpec key = new SecretKeySpec(Arrays.copyOfRange(digest, 0, 16), "AES");
   
         System.out.println("    Generate a random 16 byte IV");
         byte[] iv = new byte[16];
         SecureRandom random = new SecureRandom();
         random.nextBytes(iv);
         IvParameterSpec ivSpec = new IvParameterSpec(iv);
   
         System.out.println("    Build json data");
         JSONObject userData = new JSONObject();
userData.put("uid", "19238333");
         DateFormat df = new SimpleDateFormat("yyyy-MM-dd'T'HH:mmZ");
userData.put("expires", df.format(new Date(new Date().getTime() + 300000)));
userData.put("customer_email", "suxny1216@163.com");
userData.put("customer_name", "Sunxinyou1234");
   
         System.out.println("    Data: " + userData.toString());
         String data = userData.toString();
   
         System.out.println("    Encrypt data using AES128-cbc");
         Cipher aes = Cipher.getInstance("AES/CBC/PKCS5Padding");
         aes.init(Cipher.ENCRYPT_MODE, key, ivSpec);
         byte[] encrypted = aes.doFinal(data.getBytes("utf-8"));
   
         System.out.println("    Prepend the IV to the encrypted data");
         byte[] combined = new byte[iv.length + encrypted.length];
         System.arraycopy(iv, 0, combined, 0, iv.length);
         System.arraycopy(encrypted, 0, combined, iv.length, encrypted.length);
   
         System.out.println("    Base64 encode the encrypted data");
         byte[] multipass = Base64.encodeBase64(combined);
   
         System.out.println("    Build an HMAC-SHA1 signature using the encoded string and your api key");
         SecretKeySpec apiKey = new SecretKeySpec(API_KEY.getBytes("utf-8"), "HmacSHA1");
         Mac hmac = Mac.getInstance("HmacSHA1");
         hmac.init(apiKey);
         byte[] rawHmac = hmac.doFinal(multipass);
         byte[] signature = Base64.encodeBase64(rawHmac);
   
         System.out.println("    Finally, URL encode the multipass and signature");
         String multipassString = URLEncoder.encode(new String(multipass));
         String signatureString = URLEncoder.encode(new String(signature));
   
         System.out.println("== Finished ==");
         System.out.println("URL: https://" + SITE_KEY +
".desk.com/customer/authentication/multipass/callback?multipass=" +
multipassString + "&signature=" + signatureString);
       } catch (Exception e) {
         e.printStackTrace();
       }
   }
}