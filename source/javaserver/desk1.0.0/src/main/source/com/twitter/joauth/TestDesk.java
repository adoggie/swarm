package com.twitter.joauth;

/**
 * @author sunxy
 * @version 2015-6-25
 * @des
 **/
public class TestDesk {
	private static String OAUTH_KEY = "Xjr3oCAZJJqXWvpcdL0Y";
    private static String OAUTH_SECRET = "gLHdtyAAdh0lzdM9haLXaTGn5JZ9ZRvtBLr1W2GC";
    private static String ACCESS_TOKEN = "35i9pwdXC6ZXGUhqGjgK";
    private static String ACCESS_TOKEN_SECRET = "eQgQ6B6uGLzC9q1FH5E1gYRvx7K2iEatlP3EcxOb";
    
    public static String DESK_SITENAME = "hehong.desk.com";
	public static void main(String[] args) {
		String token = "";
		String consumerKey = "";
		String nonce = "";
		Long timestampSecs = System.currentTimeMillis()/1000;
		String timestampStr = "";
		String signature = "";
		String signatureMethod = "GET";
		String version = "1.0";
		OAuthParams.OAuth1Params s = new OAuthParams.OAuth1Params(token, consumerKey,
				nonce, timestampSecs, timestampStr, signature, signatureMethod,
				version);
		System.out.println("==="+s.signature());
	}

}
