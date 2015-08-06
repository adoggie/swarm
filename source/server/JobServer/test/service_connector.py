#coding:utf-8

__author__ = 'scott'


import web,json,threading,time,urllib,urllib2
urls = (
	'/WEBAPI/connector/app-account/event/bind', 'EventBind',
	'/WEBAPI/connector/task','Task'
)


class Task:
	def GET(self):
		pass

	def thread_response_finished(self,uri_back,task_id,dataset='no dataset'):
		print 'enter thead: thread_response_finished'
		time.sleep(5)

		params ={
			'task_id':task_id,
			'start_time':0,
			'elapsed':0,
			'service_id':'connector_simulator_1',
			'dataset':dataset
		}
		url = uri_back +'/task/finished/'
		print url
		res = urllib2.urlopen( url ,urllib.urlencode(params))
		print res.read()

	def POST(self):
		"""
		接收到采集任务，并延时n秒之后发送成功反馈包
		:return:
		"""
		i = web.data()
		print i
		data = json.loads(i)
		task_id = data['task_id']
		callback_uri = data['callback_uri']
		threading.Thread(target=self.thread_response_finished,args=(callback_uri,task_id)).start()

		return json.dumps({'status':0,'result':{'instance_uri':'http://localhost:16003/WEBAPI/connector'}})


class EventBind:
	def POST(self):
		i = web.input()
		print i.items()
		return json.dumps({'status':0})



app = web.application(urls, globals())


#监听地址需 命令行参数代入  connect.py 16003
if __name__ == "__main__":
	app.run()