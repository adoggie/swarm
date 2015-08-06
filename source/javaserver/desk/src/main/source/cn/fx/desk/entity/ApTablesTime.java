package cn.fx.desk.entity;

import java.io.Serializable;

/**
 * @author sunxy
 * @version 2015-7-27
 * @des 
 **/
public class ApTablesTime implements Serializable {
	private int id;
	private int appId;
	private String appTableName;
	private String appUserId;
	private String createAt;
	private String updateAt;
	private int updateTimes;
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
	public String getAppTableName() {
		return appTableName;
	}
	public void setAppTableName(String appTableName) {
		this.appTableName = appTableName;
	}
	public String getAppUserId() {
		return appUserId;
	}
	public void setAppUserId(String appUserId) {
		this.appUserId = appUserId;
	}
	public String getCreateAt() {
		return createAt;
	}
	public void setCreateAt(String createAt) {
		this.createAt = createAt;
	}
	public String getUpdateAt() {
		return updateAt;
	}
	public void setUpdateAt(String updateAt) {
		this.updateAt = updateAt;
	}
	public int getUpdateTimes() {
		return updateTimes;
	}
	public void setUpdateTimes(int updateTimes) {
		this.updateTimes = updateTimes;
	}
}
