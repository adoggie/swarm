#--coding:utf-8--


import os,os.path,sys,struct,time,traceback,signal,threading,datetime


# import tcelib as tce


class TypeValue:
	def __init__(self,value,msg=''):
		self.name = ''
		self.value = value
		self.msg = msg


class ErrorDefs:
	SUCC = 0
	Undefined = 0xffff
	UserTokenSessionExpired = 1
	UserTokenInvalid = 1
	UserAnotherPlaceLogin = 1


def USER_ID1(ctx):
	'''
		获取一次消息携带的用户身份编号
	'''
	s = ctx.msg.extra.getValue('__user_id__')
	ids = s.split('#')
	userid = ids[0]
	return int(userid)

def USER_ID2(ctx):
	s = ctx.msg.extra.getValue('__user_id__')
	ids = s.split('#')
	userid = ids[0]
	device_id=None
	if len(ids) >1:
		device_id = ids[1]
	return (int(userid),device_id)

def USER_ID(ctx):
	s = ctx.msg.extra.getValue('__user_id__')
	return int(s)


def ID1(s):
	ids = s.split('#')
	userid = ids[0]
	return int(userid)

def ID2(s):
	ids = s.split('#')
	userid = ids[0]
	device_id=None
	if len(ids) >1:
		device_id = ids[1]
	return (int(userid),device_id)



def MakeUserId(userid,device_id):
	return "%s#%s"%(userid,device_id)


def CALL_USER_ID(userid):
	'''
		构造包含用户编号的附加属性
	'''
	return {'__user_id__':str(userid) }


def IntValOfBoolean(val):
	if val :
		return 1
	return 0


def _help_generate_javascript():
	"""
		生成java使用的数据类型
	"""
	f = open('notifytypes.js','w')
	f.write('NotificationType = function(){};\n\n')
	for item in dir(NotifyMsgType):
		if item.find('__')!=-1:
			continue
		val =  getattr(NotifyMsgType,item)
		if callable(val):
			continue
		f.write('NotificationType.%s = %s;\n'%(item,val))
		f.flush()


class SystemParameterType:
	class Entry:
		def __init__(self,name,value=None):
			self.name = name
			self.value = value

		def __str__(self):
			return self.name

	SYSTEM_ID = Entry('sys_id','ras_sh_001')

class LogActionType:
	"""
	日志行为类型
	"""
	class Entry:
		def __init__(self,id,name):
			self.id = id
			self.name = name

		def __str__(self):
			return self.name


	L101= Entry(101,u'登录')




class LoginUserType:
	"""
	登录用户类型
	  普通用户、管理员用户
	"""
	UNKNOWN = 0
	USER = 1 	#
	ADMIN = 2


class NotifyMsgType:
	ConnectTgsReject = 100



if __name__ == '__main__':

	_help_generate_javascript()

