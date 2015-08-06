package cn.fx.desk.dao;

import java.util.List;

/**
 * @author sunxy
 * @version 2015-7-28
 * @des 
 **/
public interface ApDao {
	public void insert(List list,String collectionName) throws Exception;
	public void drop(String collectionName) throws Exception;
	public void find(String collectionName) throws Exception;
}
