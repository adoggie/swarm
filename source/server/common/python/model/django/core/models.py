# coding=utf-8

"""
auth: sam
date: 2015/07/13
"""

from django.db import models
 
class Application(models.Model):
	"""
	应用（sf,desk.com)
	"""
	name = models.CharField(max_length=40,help_text=u'应用名称')
	type = models.SmallIntegerField(help_text=u'sf/desk/..')	# swarm.base.AppPlatformTypeDef
	is_active = models.BooleanField(help_text=u'51desk的总开关') 	#
	auth_uri = models.CharField(max_length=400,null=True,help_text=u'app授权的web地址')

class AnalysisDataModel(models.Model):
	"""
	数据分析应用模型
	"""
	name = models.CharField(max_length=60,help_text=u'应用模型名称')
	type = models.SmallIntegerField( help_text=u'类型值 1:second_sales')
	comment = models.CharField(max_length=200,null=True,help_text=u'说明')
	apps = models.ManyToManyField('Application',help_text=u'model与app关联')

#
class Orgnization(models.Model):
	"""
	企业客户
	"""
	domain = models.CharField(max_length=60,help_text=u'访问域名')	#
	name = models.CharField(max_length=60,help_text=u'企业名称')		#

	create_date = models.DateTimeField(help_text=u'创建时间')
	data_models = models.ManyToManyField(AnalysisDataModel,help_text=u'企业客户可操作的业务模型列表')
	apps = models.ManyToManyField(Application ,help_text=u'app启用设置')

	employee = models.SmallIntegerField(default= 0,help_text=u'企业规模')

	#personal info
	first_name = models.CharField(max_length=32,null=True,db_index=True,help_text=u'first_name')
	last_name = models.CharField(max_length=32,null=True,db_index=True,help_text=u'last_name')
	middle_name = models.CharField(max_length=32,null=True,db_index=True,help_text=u'last_name')
	position = models.CharField(max_length=30,null=True,help_text=u'职位')
	email = models.CharField(max_length=64,db_index=True,help_text=u'邮件地址')
	phone = models.CharField(max_length= 20,help_text=u'联系电话')

	type = models.SmallIntegerField(default=1,help_text=u'试用类型') # 1 - trial , 2 - licensed
	status = models.SmallIntegerField(default=1,help_text=u'')



class OrgDepartment(models.Model):
	"""
	组织部门
	"""
	org = models.ForeignKey(Orgnization,db_index=True)
	parent = models.ForeignKey('OrgDepartment',null=True,help_text=u'父节点')
	name = models.CharField(max_length=40,db_index=True,help_text=u'部门名称')
	comment = models.CharField(max_length=200,null=True,help_text=u'说明')
	path = models.CharField(max_length=500,db_index=True,help_text=u'路径') # 10-101-200-450
	sys_groups = models.ManyToManyField('SystemGroup',help_text=u'隶属于系统组')


class SystemGroup(models.Model):
	"""
	系统组类型 (sales,marketing)
	"""
	name = models.CharField(max_length=40,db_index=True,help_text=u'名称')
	comment = models.CharField(max_length=200,null=True,help_text=u'描述')



class OrgUser(models.Model):
	"""
	企业用户
	"""
	org = models.ForeignKey(Orgnization,db_index=True)

	departs = models.ManyToManyField(OrgDepartment,null=True,db_index=True,help_text=u'部门')
	path = models.CharField(max_length=500,db_index=True) # 10-20-30-501

	user_type = models.SmallIntegerField(help_text=u'用户类型 admin/normal') # 1 - admin / 2 - normal /
	user_name = models.CharField(max_length=64,db_index=True,help_text=u'登陆账号') 	#
	password = models.CharField(max_length=100,db_index=True,help_text=u'登陆密码 MD5/SHA-256')	#


	first_name = models.CharField(max_length=32,null=True,db_index=True,help_text=u'first_name')
	last_name = models.CharField(max_length=32,null=True,db_index=True,help_text=u'last_name')
	middle_name = models.CharField(max_length=32,null=True,db_index=True,help_text=u'last_name')
	position = models.CharField(max_length=30,null=True,help_text=u'职位')
	email = models.CharField(max_length=64,db_index=True,help_text=u'邮件地址')
	phone = models.CharField(max_length= 20)

	alias =models.CharField(max_length=32,null=True,db_index=True,help_text=u'别名')
	create_date = models.DateTimeField(help_text=u'创建时间')
	is_active = models.BooleanField(default=True,db_index=True,help_text=u'账户是否激活')
	login_time = models.DateTimeField(help_text=u'登陆时间')	#
	salt = models.CharField(max_length=40)

	sys_groups = models.ManyToManyField('SystemGroup',help_text=u'隶属于系统组')
	roles = models.ManyToManyField('OrgRole',help_text=u'隶属于角色')

class OrgRole(models.Model):
	"""
	组织角色
	"""
	org = models.ForeignKey(Orgnization,db_index=True)
	parent = models.ForeignKey('OrgRole',null=True,help_text=u'父节点')
	name = models.CharField(max_length=40,db_index=True,help_text=u'名称')
	comment = models.CharField(max_length=200,null=True,help_text=u'说明')
	path = models.CharField(max_length=500,db_index=True) # 10-101-200-450


class OrgSupportInfo(models.Model):
	"""
	组织支持信息
	"""
	org = models.ForeignKey(Orgnization,db_index=True)
	name = models.CharField(max_length=40,db_index=True,help_text=u'名称(邮件/电话)')
	type = models.SmallIntegerField() # 1 - mail ; 2 - phone
	content = models.CharField(max_length=60,help_text=u'内容')
	is_active = models.BooleanField(default=True,help_text=u'是否启用')

class OrgAppConfig(models.Model):
	"""
	企业组织对app的控制
	"""
	org = models.ForeignKey(Orgnization,db_index=True)
	app = models.ForeignKey(Application,db_index=True,help_text=u'')
	enable_display_profile = models.BooleanField(default=True,help_text=u'是否显示在前端用户profile')

class OrgUserAppConfig(models.Model):
	"""
	企业用户app设置
	"""
	app = models.ForeignKey(Application,db_index=True,help_text=u'51desk App记录')
	user = models.ForeignKey(OrgUser,db_index=True,related_name='userapp_set',help_text=u'51desk用户账号')

	is_active = models.BooleanField(help_text=u'是否开启')
	app_access_token = models.CharField(max_length=2000,null=True,help_text=u'')
	app_refresh_token = models.CharField(max_length=2000,null=True,help_text=u'')
	app_instance_url = models.CharField(max_length=1000,null=True,help_text=u'服务主机动态地址')
	app_user_id = models.CharField(max_length=200,null=True,help_text=u'认证之后用户身份标示')
	app_user_name = models.CharField(max_length=60,null=True,help_text=u'App系统用户账号')
	app_auth_time = models.DateTimeField(help_text=u'登陆授权时间')

class Log_OrgUserLogin(models.Model):
	"""
		YY
	"""
	user_id = models.BigIntegerField(db_index=True)
	user_name = models.CharField(max_length=64)
	user_type = models.SmallIntegerField()
	domain = models.CharField(max_length=60)
	sid = models.CharField(max_length=400)
	login_time = models.DateTimeField()

class Ap_Tables(models.Model):
	"""
	记录应用平台数据集与本地存储集合的对应关系
	接入平台需要抓取的数据表
	"""
	app_id = models.SmallIntegerField(db_index=True)
	app_table_name = models.CharField(max_length=60,db_index=True)
	cur_table_name = models.CharField(max_length=60,db_index=True)

class Ap_Tables_Time(models.Model):
	"""
	记录接入平台中每个表最后一次数据抓取时间
	"""
	app_id = models.SmallIntegerField(db_index=True)
	app_table_name = models.CharField(max_length=60,db_index=True)
	app_user_id = models.CharField(max_length=64,db_index=True)
	create_at = models.DateTimeField()
	update_at = models.CharField(max_length=64,help_text=u'作为下次使用的开始时间(时区)')
	update_times = models.IntegerField(default=1)



if __name__ == '__main__':
	print OrgUserAppConfig.app_auth_time.help_text
