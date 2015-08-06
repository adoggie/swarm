#--coding:utf-8--


import os,os.path,sys,struct,time,traceback,signal,threading,datetime


class ErrorDefs:
	class InnerError:
		def __init__(self,errcode,errmsg=''):
			self.code = errcode
			self.msg = errmsg

	SUCC = InnerError(0,'SUCC')
	SessionExpired		= 	InnerError(1001,u'未登录或会话过期')
	TokenInvalid = SessionExpired
	InternalException 	= 	InnerError(1002,u'内部异常')
	PasswdIncorret 		=	InnerError(1003,u'密码错误')
	UserNameDuplicated  =	InnerError(1004,u'用户名重复')
	UserNameOrPasswordError  =	InnerError(1005,u'用户或密码错误')
	PermissionDenied	=	InnerError(1006,u'权限禁止')
	ParameterIllegal	= 	InnerError(1007,u'参数非法')
	ObjectNotExisted	= 	InnerError(1008,u'对象不存在')


def generateErrorTypesToJavascript():
	"""
	为javascript开发 转换错误类型
	"""
	jsfile = 'ErrorDefs.js'
	f = open(jsfile,'w')

	pass


