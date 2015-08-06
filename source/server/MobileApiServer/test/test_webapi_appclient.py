#--coding:utf-8--

# 测试系统各种服务资源，
#

# import imp
# imp.load_source('init','../init_script.py')

# from gevent import monkey
# monkey.patch_all()
# import psycogreen.gevent
# psycogreen.gevent.patch_psycopg()

import os,os.path,sys,struct,time,traceback,signal,threading,copy,base64,urllib,json
import datetime,base64
from datetime import datetime


# import  model.django.core.models as  core


import urllib2,urllib,time

userToken ='AAAAATEAAAAEdGVzdAAAAAAAAAAAU7AjqgAAAAAAAAAAU7Bp+gAAAAUxMTExMQ=='
webserver = 'http://localhost:16001'
webapi = webserver+'/WEBAPI'

satisfaction={'biz_model':'satisfaction','subtype':5,'time_granule':'day','start_time':1420070400,'end_time':1435708800}


#rt_date': 1420070400, #'2015-01-01', # 1420070400
#                'end_date' : 1435708800, #'2015-07-01', # 1435708800


test_case_list=[
	{'name':'user_login','webapi':'/auth/accessToken/','params':{'user':'wangdazhi','password':'111111','domain':'ylm'}},
	# {'name':'domain','webapi':'/appserver/domain/ylm','params':None},
	# {'name':'app_acount_list','webapi':'/appserver/app-account','params':None},
	# {'name':'me','webapi':'/appserver/me','params':None},
	# {'name':'me','method':'PUT','webapi':'/appserver/me/','params':{'first_name':'nilo','last_name':'wang','email':'test@test.com','avatar':'no avatar','position':'cleaner'}},
	# {'name':'me-fetchall','webapi':'/appserver/me/fetchall','params':None},
	# {'name':'app-acct-bind','webapi':'/appserver/app-account/','params':{'app_access_token':'random-access-token','app_type':1}},
	# {'name':'data-satisfaction','webapi':'/appserver/data/analyses/satisfaction/?'+urllib.urlencode(satisfaction),'params':None}, #GET
	# {'name':'biz-model-list','webapi':'/appserver/bizmodels/','params':None}, #GET
	# {'name':'restricted_orguser_login','webapi':'/auth/restricted/orguser/login/','params':{'user':'wangdazhi','password':'111111','domain':'ylm'}},
#
	# {'name':'hippo_smtp_sendmail','webapi':'/hippo/sendmail/','params':{'mail_to':'24509826@qq.com','subject':'test-mail','content':'this is a test mail!'}},
	{'name':'hippo_identify_image','webapi':'/hippo/identify_image/'},
]

case = test_case_list[0]
res = urllib2.urlopen( webapi + case['webapi'] ,urllib.urlencode(case['params']))
result = json.loads(res.read())
print result
token = result['result']['token']
print 'auth token:'+token

for case in test_case_list[1:]:
	print 'do test:(',case['name'],')'
	headers = {
		'SESSION-TOKEN':token,
		'IF-VERSION':'1.0'
	}
	opener = urllib2.build_opener()

	if case.get('params'):
		request = urllib2.Request(webapi+case['webapi'],urllib.urlencode(case['params']),headers=headers)
	else:
		request = urllib2.Request(webapi+case['webapi'],headers=headers)
	if case.get('method'):
		request.get_method = lambda:case.get('method')
	print opener.open(request).read()
