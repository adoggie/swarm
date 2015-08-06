package cn.fx.desk.entity;

import java.io.Serializable;

/**
 * @author sunxy
 * @version 2015-7-3
 * @des 
 **/
public class OrgUserAppConfig implements Serializable {
	
	private int id;
	private int appId;
	private int userId;
	private boolean isActive;
	private String appAccessToken;
	private String appRefreshToken;
	private String appInstanceUrl;
	private String appUserId;
	private String appUserName;
	private String appAuthTime;
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getAppId() {
		return appId;
	}
	public void setAppId(int appId) {
		this.appId = appId;
	}
	public int getUserId() {
		return userId;
	}
	public void setUserId(int userId) {
		this.userId = userId;
	}
	public boolean isActive() {
		return isActive;
	}
	public void setActive(boolean isActive) {
		this.isActive = isActive;
	}
	public String getAppAccessToken() {
		return appAccessToken;
	}
	public void setAppAccessToken(String appAccessToken) {
		this.appAccessToken = appAccessToken;
	}
	public String getAppRefreshToken() {
		return appRefreshToken;
	}
	public void setAppRefreshToken(String appRefreshToken) {
		this.appRefreshToken = appRefreshToken;
	}
	public String getAppInstanceUrl() {
		return appInstanceUrl;
	}
	public void setAppInstanceUrl(String appInstanceUrl) {
		this.appInstanceUrl = appInstanceUrl;
	}
	public String getAppUserId() {
		return appUserId;
	}
	public void setAppUserId(String appUserId) {
		this.appUserId = appUserId;
	}
	public String getAppUserName() {
		return appUserName;
	}
	public void setAppUserName(String appUserName) {
		this.appUserName = appUserName;
	}
	public String getAppAuthTime() {
		return appAuthTime;
	}
	public void setAppAuthTime(String appAuthTime) {
		this.appAuthTime = appAuthTime;
	}
}
