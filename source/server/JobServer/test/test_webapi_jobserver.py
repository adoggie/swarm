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

webserver = 'http://localhost:16003'
webapi = webserver

test_case_list=[
	{'name':'event_bind','webapi':'/WEBAPI/connector/app-account/event/bind',
		'params':{'user_id':'10001','app_access_token':'alskjfwekrwjeklrjwlekjekwlrj##','app_type':1}
	},


]


for case in test_case_list:
	print 'do test:(',case['name'],')'
	for n in range(1):
		res = urllib2.urlopen( webserver + case['webapi'] ,urllib.urlencode(case['params']))
		print res.read()


# print urllib.urlencode({'data':[100,10,1]})