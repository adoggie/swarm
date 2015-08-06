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


import urllib2

userToken ='AAAAATEAAAAEdGVzdAAAAAAAAAAAU7AjqgAAAAAAAAAAU7Bp+gAAAAUxMTExMQ=='
webserver = 'http://localhost:16002'
webapi = webserver+'/WEBAPI'

test_case_list=[
	# 发送任务执行成功
	{'name':'task_finished','webapi':'/jobserver/callback/task/finished/','params':{'task_id':'10000-1190'}},


]


for case in test_case_list:
	print 'do test:(',case['name'],')'
	for n in range(1):
		res = urllib2.urlopen( webapi + case['webapi'] ,urllib.urlencode(case['params']))
		print res.read()
