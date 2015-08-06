package cn.fx.desk.entity;

import java.io.Serializable;

/**
 * @author sunxy
 * @version 2015-6-15
 * @des 
 **/
public class SfOpportunity implements Serializable {
	private int userId;
	private String sfUserId;
	private String sfOrgId;
	private String sfCreateDate;
	private String sfType;
	
	public int getUserId() {
		return userId;
	}
	public void setUserId(int userId) {
		this.userId = userId;
	}
	public String getSfUserId() {
		return sfUserId;
	}
	public void setSfUserId(String sfUserId) {
		this.sfUserId = sfUserId;
	}
	public String getSfOrgId() {
		return sfOrgId;
	}
	public void setSfOrgId(String sfOrgId) {
		this.sfOrgId = sfOrgId;
	}
	public String getSfCreateDate() {
		return sfCreateDate;
	}
	public void setSfCreateDate(String sfCreateDate) {
		this.sfCreateDate = sfCreateDate;
	}
	public String getSfType() {
		return sfType;
	}
	public void setSfType(String sfType) {
		this.sfType = sfType;
	}
}
