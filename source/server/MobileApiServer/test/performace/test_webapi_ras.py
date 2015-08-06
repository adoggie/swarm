#--coding:utf-8--



from gevent import monkey
monkey.patch_all()
import psycogreen.gevent
psycogreen.gevent.patch_psycopg()

import os,os.path,sys,struct,time,traceback,signal,threading,copy,base64,urllib,json
import datetime,base64
from datetime import datetime
import threading
import gevent


import urllib2


webserver = 'http://192.168.10.101:8088'
webapi = webserver+'/webapi'

test_case_list=[
	{'name':'user_login','webapi':'/ras/login/','params':{'user':'test2','password':'111111'}},
	#{'name':'getCurrentUserInfo','webapi':'/ras/getCurrentUserInfo/','params':{}},
	# {'name':'changePassword','webapi':'/ras/changePassword/','params':{'oldpasswd':'111111','newpasswd':'222222'}},
	# {'name':'logout','webapi':'/ras/logout/','params':{}},
	# {'name':'getSignImage','webapi':'/common/getSignImage/','params':{}},

	#- message
	# {'name':'createAndSendMessage','webapi':'/ras/createAndSendMessage/','params':{'title':'test','content':'world cup 2014.','issue_id':15,'target_ids':json.dumps([4]) }},
	# {'name':'getMessageList','webapi':'/ras/getMessageList/','params':{}},
	# {'name':'getMessageDetail','webapi':'/ras/getMessageDetail/','params':{'msg_id':1}},

	# {'name':'replyMessage','webapi':'/ras/replyMessage/','params':{'from_id':1,'title':'replay_title','content':'some words..'}},
	# {'name':'getThreadMessageList','webapi':'/ras/getThreadMessageList/','params':{'msg_id':1}},

	# - serial num
	# {'name':'createArchiveSerialNum','webapi':'/ras/createArchiveSerialNum/','params':{'name':'上海公文-2004-1','unit_id':4}},
	# {'name':'updateArchiveSerialNum','webapi':'/ras/updateArchiveSerialNum/','params':{'id':1,'name':'上海公文-2004-1','unit_id':4}},
	# {'name':'removeArchiveSerialNum','webapi':'/ras/removeArchiveSerialNum/','params':{'id':2}},
	# {'name':'getArchiveSerialNumDetail','webapi':'/ras/getArchiveSerialNumDetail/','params':{'id':1}},
	# {'name':'getArchiveSerialNumList','webapi':'/ras/getArchiveSerialNumList/','params':{}},

	# - organization
	# {'name':'getOrgNodeChildren','webapi':'/ras/getOrgNodeChildren/','params':{'parent':3}},
	# {'name':'getLocalOrgRootNodeId','webapi':'/ras/getLocalOrgRootNodeId/','params':{}},
	# {'name':'getReadAuthedTopUnit','webapi':'/ras/getReadAuthedTopUnit/','params':{}},

	# {'name':'getReadUserListInAuthedTopUnit','webapi':'/ras/getReadUserListInAuthedTopUnit/','params':{}},
	# {'name':'getSendUserListInUnits','webapi':'/ras/getSendUserListInUnits/','params':{}},
	# {'name':'getSendingUnitList','webapi':'/ras/getSendingUnitList/','params':{}},
	# {'name':'getReceivingUserListInUnits','webapi':'/ras/getReceivingUserListInUnits/','params':{}},
	# {'name':'getRASUserListInUnits','webapi':'/ras/getRASUserListInUnits/','params':{}},

]


# for case in test_case_list:
# 	print 'do test:(',case['name'],')'
# 	for n in range(1):
# 		res = urllib2.urlopen( webapi + case['webapi'] ,urllib.urlencode(case['params']))
# 		print res.read()
# 		print type(res),res

import cookielib
cookie = cookielib.CookieJar()
cookie_file = 'cookie.txt'
cookie = cookielib.MozillaCookieJar(cookie_file)
opener = urllib2.build_opener(urllib2.HTTPCookieProcessor(cookie))
headers ={"User-agent":"Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1"}



def executeTestCase():

	for n in xrange(1):
		for case in test_case_list:
			# print 'do test:(',case['name'],')'
			for n in range(500):
				req = urllib2.Request(webapi + case['webapi'] ,urllib.urlencode(case['params']))
				resp =opener.open(req)
				# print resp.info()
				# print resp.read()
				# cookie.save()


THREAD_NUM=150

start = time.time()
lets =[]
for x in range(THREAD_NUM):
	lets.append(gevent.spawn(executeTestCase))
gevent.joinall(lets)

end = time.time()

print 'testing time elasped:',int(end-start),' seconds'

# req.add_header()
# resp = urllib2.urlopen( req)

# for case in test_case_list:
# 	for n in range(1):
# 		if case['name'] == 'user_login':
# 			req = urllib2.Request(webapi + case['webapi'] ,urllib.urlencode(case['params']))
# 			resp =opener.open(req)
# 			print resp.info()
# 			print resp.read()
# 			cookie.save()
