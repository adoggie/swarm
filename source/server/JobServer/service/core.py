#coding:utf-8

__author__ = 'scott'

import os,sys,traceback,time
import gevent
from gevent.lock import RLock
# import gevent.spawn
import gevent.event

import desert
import urllib2,urllib,json
from desert.misc import genUUID,X,getdigest
from desert.app import BaseAppServer

# class JobFormat:
# 	def format(self,job):
# 		pass
#
# class JobFormatUrlEncode(JobFormat):
# 	pass


class JobStatusType:
	STOPPED = 0
	RUNNING = 1
	FINISHED = 2
	FAILED = 3

class CallReturnStatusValueType:
	SUCC = 0
	FAILED = 1

# class JobError:
# 	Succ = (1000,'Operation Successfully')
# 	ServerNoResponse = (1001,u'ServerNoResponse')
# 	ServerRejected = (1001,u'ServerRejected')


class Job:
	def __init__(self):
		self.user_id = 0	#用户编号
		self.user_acct = None		# 51desk 账户
		self.biz_model = 0 #业务模型
		self.profile = None #包括执行结果
		self.app_accts=[]		#帐号关联的app数据平台帐号


	def	getUniqueID(self):
		#51desk帐号加上所有的app帐号进行md5计算，得出唯一码
		text = self.user_acct
		for app in self.app_accts:
			text+=','+app
		digest = getdigest(text)
		return digest

	@property
	def ID(self):
		return self.getUniqueID()

class Task:
	"""
	Task描述一次服务数据请求处理
	Task任务链式钩挂
	"""

	class Profile:
		def __init__(self):
			self.start_time = 0
			self.end_time = 0
			self.last_watch_time = 0 	#最近一次观察记录时间
			self.status = JobStatusType.STOPPED
			self.result = None # task 运行结果


	def __init__(self,proxy,runner):
		self.proxy = proxy
		self.next = None
		self.prev = None
		self.task_id = JobService.instance().generateUniqueID()
		self.runner = runner
		self.profile = Task.Profile()
		self.locker = RLock()

	def chainNext(self,task):
		self.next = task
		self.next.prev = self
		return self

	def getUniqueID(self):
		return self.task_id

	@property
	def ID(self):
		return self.getUniqueID()

	def execute(self,job):
		self.locker.acquire()
		try:
			task_id = self.getUniqueID()
			result = self.proxy.createTask(task_id,job)
			if result.status == CallReturnStatusValueType.SUCC :
				self.profile.start_time = int(time.time())
				self.profile.status = JobStatusType.RUNNING
				JobService.instance().onJobTaskStarted(self)
			return result
		finally:
			self.locker.release()

	def onFinished(self,task_result):
		self.locker.acquire()
		try:
			self.profile.end_time = int(time.time())
			self.profile.status = JobStatusType.FINISHED
			self.profile.result = task_result
			self.runner.getProfile().result = task_result #

			self.runner.onTaskFinished(self)
		finally:
			self.locker.release()

	def onError(self,task_result={}):
		self.locker.acquire()
		try:
			self.profile.end_time = int(time.time())
			self.profile.status = JobStatusType.FAILED

			self.runner.getProfile().result = task_result
			self.runner.onTaskError(self)
		finally:
			self.locker.release()

	def onWatchTime(self):
		return
		try:
			result = self.proxy.watchTask( self.getUniqueID())
			self.profile.last_watch_time = int( time.time())
		except:
			traceback.print_exc()



class JobRunner:

	class Profile:
		def __init__(self):
			self.start_time = 0
			self.end_time = 0
			self.last_watch_time = 0 	#最近一次观察记录时间
			self.status = JobStatusType.STOPPED
			self.result = None # job的运行结果

	def taskConcurrency(self,routine,*args,**kwargs):
		gevent.spawn(routine,*args,**kwargs)

	def __init__(self , job =None):
		self.job = job
		self.profile = JobRunner.Profile()
		self.tasks = []
		self.currentTask = None
		self.timer = None
		self.exiting = False
		self.event = gevent.event.Event()
		self.job.profile = self.profile

	def __del__(self):
		self.job.profile = None
		self.job = None

	def getProfile(self):
		return self.profile

	def getJob(self):
		return self.job

	def addTask(self,task):
		if self.tasks:
			self.tasks[-1].chainNext(task)
		self.tasks.append(task)
		return self

	def reset(self):
		self.tasks = []
		self.currentTask = None

	def prepare(self):
		self.job.runner = self
		self.addTask( Task(ProxyConnector(),self))
		# self.addTask( Task(ProxyDataCollector(),self))

		self.currentTask = self.tasks[0]
		return self

	def startJob(self):
		self.taskConcurrency(self.run)
		# try:
		# 	self.prepare()
		# 	self.execTask()
		# 	self.timer = gevent.spawn(self.onTimer)
		# except:
		# 	traceback.print_exc()
		# 	return False
		# return True

	def run(self):
		self.prepare()
		self.execTask()
		self.timer = gevent.spawn(self.onTimer)

	def execTask(self,prev_task=None):
		if not self.currentTask:
			return True

		try:
			result = self.currentTask.execute(self.job)
			if result.status == CallReturnStatusValueType.SUCC :
				self.setJobStatus(JobStatusType.RUNNING)

			else:
				self.onJobError(self.currentTask)
		except:
			traceback.print_exc()
			self.onJobError(self.currentTask)


	def onTimer(self):
		"""
		定时执行watchJob()
		将返回信息记录到task
		1.定时执行 task的检查
		2.一个job长时间不能完成，则要终止这个job继续执行
		:return:
		"""
		max_job_lifetime = desert.app.BaseAppServer.instance().getConfig().get('max_job_lifetime',1)*3600
		max_job_lifetime = int(max_job_lifetime)

		wait_time = desert.app.BaseAppServer.instance().getConfig().get('watch_time_interval',10)
		wait_time = int(wait_time)
		while not self.exiting:
			if  self.event.wait( wait_time ):
				continue	# 应该是接收到 endJob()的指令了

			#1. exec watch_time() in task.
			if self.currentTask:
				self.currentTask.onWatchTime()

			#2. kill myself as long as  job's lifetime up to  threshold .
			elapsed = int(time.time()) - self.profile.start_time
			if elapsed > max_job_lifetime:
				self.endJob()
				if self.currentTask:
					self.currentTask.onError()



	def endJob(self):
		self.exiting = True
		self.event.set() 	#令 onTimer 线程退出

	def onTaskFinished(self,task):
		"""
		任意调用服务完成，并进行返回通知
		这里进行task的切换
		注意，前task的输出作为后task的输入
		"""
		JobService.instance().removeJobTask(task.ID)
		self.currentTask = self.currentTask.next
		# reach end
		if not self.currentTask:
			self.onJobFinished()
		else:
			self.execTask(task)

	def onTaskError(self,task):
		"""
		调用服务执行失败

		"""
		JobService.instance().removeJobTask(task.ID)

		self.onJobError(task)
		self.setJobStatus( JobStatusType.FAILED)

	def onJobFinished(self):
		self.setJobStatus( JobStatusType.FINISHED)

		JobService.instance().onJobRunnerFinished(self)
		# JobService.instance().unRegisterJobRunner(self)
		#.写入共享缓存
		self.endJob()

	def onJobError(self,task,error=None,detail=''):
		"""
		执行job出错
		:return:
		"""
		# JobService.instance().unRegisterJobRunner(self)
		JobService.instance().onJobRunnerFailed(self)
		self.endJob()


	def setJobStatus(self,value):
		self.profile.status = value
		if value == JobStatusType.RUNNING and self.profile.start_time == 0:
			self.profile.start_time = int(time.time())

		if value in (JobStatusType.FINISHED,JobStatusType.FAILED):
			self.profile.end_time = int(time.time())


class ServiceProxy:
	def __init__(self,name):
		self.jobs = {}
		self.name = name
		self.instance_uri = '' #子服务系统时机的主机地址uri

	def httpRequest(self,url,data=None,post=None,mime='application/json'):
		"""
		发送http请求到对方服务
		post 不为None则发送POST请求
		"""
		if data:
			url+='?'+urllib.urlencode(data)
		if post:
			req = urllib2.Request(url,post,{'Content-Type':mime})
			response = urllib2.urlopen( req)
		else:
			response = urllib2.urlopen( url)
		data = response.read()
		data = json.loads(data)
		obj =  desert.misc.X(data)
		return obj

	def createTask(self,task_id,job):
		"""
		connector服务需范围提供服务的uri地址，可能被nginx集群，导致nginx地址不能进行后续的 watchJob()
		:param job:
		:return:
		"""
		pass

	def termiateTask(self,task_id):
		pass

	def watchTask(self,task_id):
		pass

	# def  onTaskFinished(self):
	# 	pass
	#
	# def onTaskError(self):
	# 	pass


# class ProxyDataCollector(ServiceProxy):
# 	def __init__(self):
# 		ServiceProxy.__init__(self,'datacollector')

class ProxyConnector(ServiceProxy):
	"""
	connector服务的通信代理
	"""
	def __init__(self):
		ServiceProxy.__init__(self,'connector')


	def formatParameters(self,job,**kwargs):
		# data = desert.misc.hashobject(job)
		data = {
				'job':{'user_id':job.user_id,'user_acct':job.user_acct,'biz_model':job.biz_model}
				 }
		for k,v in kwargs.items():
			data[k] = v
		return data

	def createTask(self,task_id,job):
		# connector服务需范围提供服务的uri地址，可能被nginx集群，导致nginx地址不能进行后续的 watchJob()
		"""
			POST http://<host>/connector/task
			{	acct:mei@51desk.com,app_accts:[ {'salesforce':big1@qq.com},{'zendesk':big2@hotmail.com}],
			 	task_id:a12200122,callback_uri:http://<host>/WEBAPI/jobserver/callback
			 }

			 return:
			 	{ status:0 ,result:{instance_uri:http://<host>/WEBAPI/connector}
			 	}

			callback response:
		"""
		# 这个job.profile.result 携带上一次task的运行结果
		# 如果有 dataset 则发送过去(作为本次流程的输入)
		dataset = ''
		if job.profile.result and hasattr(job.profile.result,'dataset'):
			dataset = job.profile.result.dataset

		callback_uri = JobService.instance().getLocalServiceCallBackURI(self.name)
		data = self.formatParameters(job,callback_uri=callback_uri,task_id=task_id,dataset = dataset)
		url = JobService.instance().getBackendServiceURI(self.name)	#获取connector服务的weburl
		url +='/task.do'
		# url +='/task'

 #携带上级服务系统的输出作为本次服务的输入参数
		data = json.dumps(data)
		result = self.httpRequest(url,post=data)	# POST create task
		if result.status == CallReturnStatusValueType.SUCC :
			self.instance_uri = result.result.instance_uri
		return result

	def watchTask(self,task_id):
		"""
			GET http://<host>/connector/task/a100092
			return:
				{status:0,result:{ percent:50,elapsed:100s,start_time:2015-06-12 10:55:00}
			}
		"""
		url = self.instance_uri+'/task/'+task_id
		result = self.httpRequest(url)
		return result

	def termiateTask(self,task_id):
		"""
			DELETE http://<host>/connector/task/a100092
			return:
				{status:0}
			}
		"""
		url = self.instance_uri+'/task/'+task_id
		result = self.httpRequest(url)
		return result

# class JobScoreItem:
# 	def __init__(self):
# 		self.start_time = 0
# 		self.end_time = 0
# 		self.job_id = ''


class JobScoreBoard:
	"""
	任务执行成绩单
	需持久化,启动加载，在job运行完成时持久化
	redis:
		jobserver:server1:scoreboard = {job_id : JobScoreItem}
		置入redis时加入expire，以便保持1天的新鲜度
	"""
	def __init__(self):
		pass

		# self.score_list = {}	# {job_id: JobScoreItem,..}
		# self.exiting = False
		# self.event = gevent.event.Event()
		# gevent.spawn(self.onTimer)

	# def destroy(self):
	# 	self.event.set()
    #
	# def onTimer(self):
	# 	while not self.exiting:
	# 		if self.event.wait(5):
	# 			continue
	# 		#timeout
	# 		#清除过期的job,例如 24小时
	# 	print 'JobScoreBoard thread has exited1'
    #
	# def save(self):
	# 	pass
    #
	# def load(self):
	# 	pass


	def job_hash_id(self,job_id):
		return 'job_id:' + job_id

	def addJobResult(self,job_id,result):
		import time
		cache = BaseAppServer.instance().getCacheServer()
		max_life_time =BaseAppServer.instance().getConfig().get('score_board').get('max_job_lifetime',1)*60
		max_life_time = int(max_life_time)

		cache.set( self.job_hash_id(job_id),str(time.localtime()),max_life_time)

	def removeJobResult(self,job_id):
		cache = BaseAppServer.instance().getCacheServer()
		cache.delete( self.job_hash_id(job_id))

	def getJobResult(self,job_id):
		cache = BaseAppServer.instance().getCacheServer()
		value = cache.get( self.job_hash_id(job_id))
		return value






class JobService:
	def __init__(self):
		self.running_task_list = {}
		# self.active_runner_list ={}
		self.job_list ={} 	# {job_id:runner,..}
		self.score_board = JobScoreBoard()

	def getBackendServiceURI(self,name='connector'):
		uri = desert.app.BaseAppServer.instance().getConfig()['backend_service_uri'].get(name,'')
		return uri

	def getLocalServiceCallBackURI(self,name='connector'):
		uri = desert.app.BaseAppServer.instance().getConfig().get('callback_uri','')
		return uri


	def createJobRunner(self,job):
		runner = self.job_list.get(job.ID)
		if not runner:
			runner = JobRunner(job)
			self.job_list[job.ID] = runner
		return runner


	def removeJobRunner(self,runner):
		job_id = runner.job.ID
		if self.job_list.has_key(job_id):
			del self.job_list[job_id]

	def onJobRunnerFinished(self,runner):

		self.score_board.addJobResult(runner.getJob().ID,runner.getProfile())
		self.removeJobRunner(runner)


	def onJobRunnerFailed(self,runner):
		self.removeJobRunner(runner)


	def removeJobTask(self,task_id):
		task = self.running_task_list.get(task_id)
		if not task:
			print 'task-id:'+task_id+' is not found!'
			return
		del self.running_task_list[task_id]

	def onJobTaskFinished(self,task_info):
		"""
		connector发送任务执行完毕
		:param task:
		:return:
		"""
		task = self.running_task_list.get(task_info.task_id)
		if task:
			task.onFinished(task_info)

	def onJobTaskAborted(self,task_info):
		"""
		connector发送任务执行中止
		:param task:
		:return:
		"""
		task = self.running_task_list.get(task_info.task_id)
		if task:
			task.onError(task_info)

	def onJobTaskStarted(self,task):
		self.running_task_list[ task.ID ] = task


	handle = None
	@classmethod
	def instance(cls):
		if not cls.handle:
			cls.handle = cls()
		return cls.handle



	def generateUniqueID(self,user='',factor=None):
		return genUUID()

	def getJobResult(self,job_id):
		"""
		查询job运行状态
		:param job_id:
		:return:  STOPPING,RUNNING,FINISHED
		"""
		result = self.score_board.getJobResult(job_id)
		if result:
			return JobStatusType.FINISHED,result
		runner = self.job_list.get(job_id)
		if runner:
			return JobStatusType.RUNNING,None

		return JobStatusType.STOPPED,None
