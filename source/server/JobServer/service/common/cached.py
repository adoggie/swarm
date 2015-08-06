#--coding:utf-8--

import imp,os
PATH = os.path.dirname(os.path.abspath(__file__))
imp.load_source('init',PATH +'/../../init_script.py')

import os,os.path,sys,struct,time,traceback,signal,threading,json
import tcelib as tce

# import utils
# from  service.lemon_impl import *
# import base,basetype
from sw2us.desert.config import SimpleConfig
from service.desert_impl import *
from sw2us.desert.app import BaseAppServer
import init_script

ETC_PATH = init_script.ETC_PATH

TGS_PROXIES ={}


class CacheEntryFormat:
	'''
		缓冲记录类型以 . 分隔 a.b.c.d.e
	'''
	UserWithTGS  = 'user.%s.tgs' 		# user.101#aaccff5544.tgs:tgs_001
	UserWithDevice = 'user.%s.device' 	# 用户的终端设备列表 user.101.device:[aaccff5544,90785566ee]
	UserWithLocation = 'user.%s.location'	#用户当前的位置信息 {lon,lat,time,direction,speed}
	UserWithToken = 'user.%s.token'				#用户当前登录的token
	UserWithAppToken = 'user.%s.app.%s.token'	#用户当前登录的appp的token
	# UnitWithUsersSending = 'units.%s.users'			#单位相关的发文用户
	# UnitWithUsersReceiving = 'units.%s.users'		#单位相关的收文用户
	UnitRelatedUsers = 'units.%s.users'		#单位相关的用户
	UnitFullname = 'unit.%s.fullname'		#单位全路径名称




def getTerminalProxyByUserId(user_id):
	'''
		根据终端用户id查找在连接到哪个tgs服务器

		server_eps.conf 记录tqs对应的接收rpc消息的endpoint名称,
		获取ep名称，通过RpcCommunicator.findEndpoints()得到ep
		ep.impl就是对应服务器接收消息的连接
	'''
	global TGS_PROXIES
	prx = None
	try:
		# user_id = int(user_id)
		redis =BaseAppServer.instance().getRedis()
		key =  CacheEntryFormat.UserWithTGS%(user_id,)
		print 'cache.get:',key
		tgs = redis.get(key)
		if  not tgs:
			print 'user proxy not in cache.'
			return None #not online
		# print key ,tgs_proxies
		prx = TGS_PROXIES.get(tgs)
		if not prx:
			cf = SimpleConfig()
			cf.load(ETC_PATH + '/server_eps.conf')
			epname = cf.getValue(tgs)
			ep = tce.RpcCommunicator.instance().currentServer().findEndPointByName(epname)
			prx = ITerminalPrx(ep.impl)
			TGS_PROXIES[tgs] = prx
	except:
		traceback.print_exc()
	finally:
		if not prx:
			print 'user: %s is not online!'%user_id
		return prx



def getUserDeviceList(cache,user_id):
	'''
		获取用户所有的设备编号
	'''
	device_ids = cache.get( CacheEntryFormat.UserWithDevice %user_id)
	return device_ids


