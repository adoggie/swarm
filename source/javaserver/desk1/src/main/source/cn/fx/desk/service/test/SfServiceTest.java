package cn.fx.desk.service.test;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.springframework.context.ApplicationContext;

import cn.fx.desk.service.SfService;
import cn.fx.desk.zoo.GeneralMethod;

/**
 * @author sunxy
 * @version 2015-6-9
 * @des Salesforce业务接口测试 
 **/
public class SfServiceTest {
	SfService sfService = null;
	
	@Test
	public void sfServiceTest(){
		try {
			int uid = 0;
			String sfUserId = "00528000000JXbtAAG";
			String batchId = GeneralMethod.getBatchId();
			String instanceURL = "https://ap2.salesforce.com";
			String accessToken = "00D28000000KcB7!AQkAQKZOlaoTUY_JpP4ASr_UBAUPXedg6qzK3N.tQsDqdvUEZT0ZYJmrqxtjMciGUNRb1fsqkI93E5MrZ8BzDUqxBKYXSwSW";
			/**
			 * 获取指定用户信息
			 * {"aboutMe":null,"additionalLabel":null,
			 * "address":{"city":null,"country":"CN","formattedAddress":"CN\n20000  \n","state":null,"street":null,"zip":"20000"},
			 * "chatterActivity":{"commentCount":2,"commentReceivedCount":0,"likeReceivedCount":1,"postCount":0},
			 * "chatterInfluence":{"percentile":"0.0","rank":2},
			 * "communityNickname":"13786617881.4286453652796492E12","companyName":"fanxiang","displayName":"sun samir","email":"1378661788@qq.com","firstName":"samir","followersCount":1,
			 * "followingCounts":{"people":1,"records":0,"total":1},"groupCount":0,"hasChatter":true,"id":"00528000000ImzzAAC","isActive":true,"isInThisCommunity":true,"lastName":"sun","managerId":null,"managerName":null,"motif":{"color":"20aeb8","largeIconUrl":"/img/icon/profile64.png","mediumIconUrl":"/img/icon/profile32.png","smallIconUrl":"/img/icon/profile16.png"},"mySubscription":null,"name":"sun samir","phoneNumbers":[],"photo":{"fullEmailPhotoUrl":"https://ap2.salesforce.com/img/userprofile/default_profile_200.png?fromEmail=1",
			 * "largePhotoUrl":"https://c.ap2.content.force.com/profilephoto/005/F","photoVersionId":null,"smallPhotoUrl":"https://c.ap2.content.force.com/profilephoto/005/T","standardEmailPhotoUrl":"https://ap2.salesforce.com/img/userprofile/default_profile_45.png?fromEmail=1",
			 * "url":"/services/data/v33.0/chatter/users/00528000000ImzzAAC/photo"},"reputation":null,"thanksReceived":null,"title":null,"type":"User",
			 * "url":"/services/data/v33.0/chatter/users/00528000000ImzzAAC","userType":"Internal",
			 * "username":"1378661788@qq.com"}
			 */
			//sfService.requestHeaderSfAPI(uid, SfConstant.API_CHATTER_USERS+"/00528000000ImzzAAC");
			
			/*String sfSql = "SELECT+CloseDate,CreatedById,CreatedDate,Description,Id,IsClosed,IsDeleted,Name,OwnerId,StageName,Type+FROM+Opportunity+ORDER+BY+Id+ASC+NULLS+FIRST";
			String apiUrl = SfConstant.API_QUERY + sfSql;
			sfService.requestHeaderSfAPI(uid, apiUrl);*/
			/*for(int i=0;i<100;i++){
				
			}*/
			
			/**获取Salesforce对象信息*/
			//sfService.getSfOpportunity(DeskConstant.AP_SALESFORCE,1);
			/**根据指定的对象从Salesforce获取信息*/
			sfService.getSalesforceObject(1);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	@Before
	public void init() {
		ApplicationContext aCtx = ApplicationContextUtil.getContext();
		sfService = (SfService) aCtx.getBean("sfService");
	}
	@After
	public void destory() {
	}
}
