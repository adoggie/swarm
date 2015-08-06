package cn.fx.desk.entity;

import java.io.Serializable;

/**
 * @author sunxy
 * @version 2015-7-24
 * @des 
 **/
public class ApTables implements Serializable {
	private int id;
	private int appId;
	private String appTableName;
	private String curTableName;
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
	public String getCurTableName() {
		return curTableName;
	}
	public void setCurTableName(String curTableName) {
		this.curTableName = curTableName;
	}
}
