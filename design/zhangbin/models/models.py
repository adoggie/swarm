# coding=utf-8

from django.db import models

class Application(models.Model):
	"""
	应用（sf,desk.com)
	"""
	name = models.CharField(max_length=40,help_text=u'应用名称')
	type = models.SmallIntegerField(help_text=u'sf/desk/..')
	is_active = models.BooleanField(help_text=u'51desk的总开关') 	#

#
class Orgnization(models.Model):
	"""
	企业客户
	"""
	domain = models.CharField(max_length=60,help_text=u'访问域名')	#
	name = models.CharField(max_length=60,help_text=u'企业名称')		#
	address = models.CharField(max_length=100)	#
	zipcode = models.CharField(max_length=20)
	country = models.CharField(max_length=40)
	create_date = models.DateField()


# class OrgAppConfig(models.Model):
# 	"""
# 	组织范围内对应用的配置
# 	"""
# 	org = models.ForeignKey(Orgnization,db_index=True)
# 	app = models.ForeignKey(Application)
# 	is_active = models.BooleanField(help_text=u'组织是否开启应用')
# 	admin_accout = models.CharField(max_length=60,help_text=u'管理账号')
# 	oper_time = models.DateTimeField(help_text=u'操作时间')
#



class OrgUser(models.Model):
	"""
	企业用户
	"""
	org = models.ForeignKey(Orgnization,db_index=True)
	user_type = models.SmallIntegerField() # 1 - admin / 2 - normal /
	user_name = models.CharField(max_length=64,db_index=True) 	#登陆账号
	password = models.CharField(max_length=100,db_index=True,help_text=u'登陆密码 MD5/SHA-256')	#
	first_name = models.CharField(max_length=32,null=True,db_index=True)
	last_name = models.CharField(max_length=32,null=True,db_index=True)
	alias =models.CharField(max_length=32,null=True,db_index=True)
	email = models.CharField(max_length=64,db_index=True)
	create_date = models.DateField()
	is_active = models.BooleanField(default=True,db_index=True)
	login_time = models.DateTimeField()	#登陆时间
	total_times = models.IntegerField()	#总登陆次数

class OrgUserAppConfig(models.Model):
	"""
	企业用户app设置
	"""
	app = models.ForeignKey(Application,db_index=True,help_text=u'51desk App记录')
	user = models.ForeignKey(OrgUser,db_index=True,help_text=u'51desk用户账号')
	is_active = models.BooleanField(help_text=u'是否开启')
	access_token = models.CharField(max_length=2000,null=True,help_text=u'')
	cert_sign = models.TextField(null=True,help_text=u'证书和签名信息')


