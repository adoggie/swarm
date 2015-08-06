#--coding:utf-8--

# 测试系统各种服务资源，
#

import imp
imp.load_source('init','../init_script.py')

# from gevent import monkey
# monkey.patch_all()
# import psycogreen.gevent
# psycogreen.gevent.patch_psycopg()

import os,os.path,sys,struct,time,traceback,signal,threading,copy,base64,urllib,json
import datetime,base64
from datetime import datetime


import  model.django.core.models as  core


import urllib2

userToken ='AAAAATEAAAAEdGVzdAAAAAAAAAAAU7AjqgAAAAAAAAAAU7Bp+gAAAAUxMTExMQ=='
webserver = 'http://server2:8088'
webapi = webserver+'/webapi'

test_case_list=[
	# {'name':'user_login','webapi':'/admin/login/','params':{'user':'sysadmin','password':'222222'}},
	# {'name':'getCurrentUserInfo','webapi':'/admin/getCurrentUserInfo/','params':{}},
	# {'name':'changePassword','webapi':'/admin/changePassword/','params':{'oldpasswd':'11111','newpasswd':'222222'}},

	# {'name':'getOrgNodeChildren','webapi':'/common/getOrgNodeChildren/','params':{'parent':0,'depth':0,'flag':0,'name':''}},

	# {'name':'createAdminUser/','webapi':'/admin/createAdminUser/','params':{'unit_id':3,'user':'admin_1','password':'111111','name':'admin_1'}},
	# {'name':'removeAdminUser/','webapi':'/admin/removeAdminUser/','params':{'user_id':4}},
	# {'name':'updateAdminUser/','webapi':'/admin/updateAdminUser/','params':{'id':4,'name':'scott'}},
	# {'name':'getAdminUserList/','webapi':'/admin/getAdminUserList/','params':{'unit_id':3,'depth':9}},
	# {'name':'getAdminUserDetail/','webapi':'/admin/getAdminUserDetail/','params':{'id':4,}},

	#todo
	# {'name':'getOrgNodeChildren/','webapi':'/admin/getOrgNodeChildren/','params':{'depth':0,'flag':0,'name':''}},
	# {'name':'createUser/','webapi':'/admin/createUser/','params':
	# 	{'unit_id':3,'user':'liping','password':'111111','name':'张山'}
	# },

	# {'name':'updateUser/','webapi':'/admin/updateUser/','params':
	# 	{'id':12,'user':'liping','password':'111111','name':'王岐山'}
	# },

	# {'name':'removeUser/','webapi':'/admin/removeUser/','params':{'user_id':12}},
	# todo
	# {'name':'changeOrgNodePosition/','webapi':'/admin/changeOrgNodePosition/','params':{}},
	# {'name':'getOrgUserListInUnit/','webapi':'/admin/getOrgUserListInUnit/','params':{'unit_id':3}},

	# {'name':'createOrgUnit/','webapi':'/admin/createOrgUnit/','params':{'parent':3,'name':'吴泾镇'}},
	# {'name':'updateOrgUnit/','webapi':'/admin/updateOrgUnit/','params':{'id':17,'address':'龙吴路20091号','fax':'021-889988821'}},
	# {'name':'removeOrgUnit/','webapi':'/admin/removeOrgUnit/','params':{'unit_id':17}},
	#todo
	# {'name':'exportUserListInUnit/','webapi':'/admin/exportUserListInUnit/','params':{'unit_id':17}},

	# {'name':'getOrgUserDetail/','webapi':'/admin/getOrgUserDetail/','params':{'id':11}},
	# {'name':'getOrgUnitDetail/','webapi':'/admin/getOrgUnitDetail/','params':{'id':3}},

	# {'name':'getOrgSubUnitList/','webapi':'/admin/getOrgSubUnitList/','params':{'id':3}},


	{'name':'setUserRole/','webapi':'/admin/setUserRole/','params':{'user_id':10,'role':3}},
	{'name':'setUserRole/','webapi':'/admin/setUserRole/','params':{'user_id':11,'role':3}},
	#todo
	# {'name':'getAdminOperationLog/','webapi':'/admin/getAdminOperationLog/','params':{'user_id':11,'role':3}},
	# {'name':'exportAdminOperationLog/','webapi':'/admin/exportAdminOperationLog/','params':{'user_id':11,'role':3}},

	{'name':'setUserSendingUnits/','webapi':'/admin/setUserSendingUnits/','params':{'user_id':10,'unit_ids':json.dumps([5])}},
	{'name':'setUserReceivingUnits/','webapi':'/admin/setUserReceivingUnits/','params':{'user_id':10,'unit_ids':json.dumps([5])}},

	{'name':'setUserSendingUnits/','webapi':'/admin/setUserSendingUnits/','params':{'user_id':11,'unit_ids':json.dumps([9])}},
	{'name':'setUserReceivingUnits/','webapi':'/admin/setUserReceivingUnits/','params':{'user_id':11,'unit_ids':json.dumps([9])}},

	# {'name':'setReadingAuthTopUnit/','webapi':'/admin/setReadingAuthTopUnit/','params':{'user_id':11,'unit_id':31} },
	# {'name':'getUserSendingUnits/','webapi':'/admin/getUserSendingUnits/','params':{'user_id':11} },
	# {'name':'getUserReceivingUnits/','webapi':'/admin/getUserReceivingUnits/','params':{'user_id':11} },
	# {'name':'getUserReadingAuthTopUnit/','webapi':'/admin/getUserReadingAuthTopUnit/','params':{'user_id':11} },
	#todo
	# {'name':'getUserOperationLog/','webapi':'/admin/getUserOperationLog/','params':{'user_id':11} },
	# {'name':'exportUserOperationLog/','webapi':'/admin/exportUserOperationLog/','params':{'user_id':11} },

	# notice
	# {'name':'createNotice/','webapi':'/common/createNotice/','params':{'title':'work break','content':'工作安排计划内容...'} },
	# {'name':'getNoticeList/','webapi':'/common/getNoticeList/','params':{} },
	# {'name':'getNoticeDetail/','webapi':'/common/getNoticeDetail/','params':{'id':1} },
	# {'name':'updateNotice/','webapi':'/common/updateNotice/','params':{'id':1,'title':'update title'} },
	# {'name':'removeNotice/','webapi':'/common/removeNotice/','params':{'id':1} },



]


for case in test_case_list:
	print 'do test:(',case['name'],')'
	for n in range(1):
		res = urllib2.urlopen( webapi + case['webapi'] ,urllib.urlencode(case['params']))
		print res.read()


# print urllib.urlencode({'data':[100,10,1]})