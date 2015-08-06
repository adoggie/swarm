#coding:utf-8

__author__ = 'scott'
import os,sys,traceback,time,string

from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework import views
from rest_framework.renderers import JSONRenderer
from rest_framework.decorators import api_view
from rest_framework import viewsets
from rest_framework import  status
from rest_framework.reverse import reverse
from rest_framework.generics import GenericAPIView
from rest_framework import  generics
from rest_framework import pagination
from rest_framework import decorators
from rest_framework import parsers

import urllib,urllib2,json
from desert.webservice.webapi import SuccCallReturn,FailCallReturn,USER_ID
from desert.errors import ErrorDefs
from desert.misc import X,getdigest
from desert.app import BaseAppServer
import swarm
from desert.nosql import rediscache
import serializer
import service.core
from model.django.core import  models as core

class DataAnalysesViewSet(viewsets.ViewSet):
	"""
	第三方账号信息
	"""
	pagination_class = pagination.PageNumberPagination
	paginate_by = 10
	paginate_by_param ='page_size'
	parser_classes = (parsers.JSONParser,)


	def _get_app_account_hash_from_db(self,user):
		"""
		计算用户的帐号hash码
		写入缓存

		:param user_id:

		:return:
		"""

		if type(user) == int:
			user = core.OrgUser.objects.get(id = user)
		elif type(user) == core.OrgUser:
			pass
		else:
			user = None

		apps = user.userapp_set.all().order_by('app_user_name')
		apps = map(lambda app: app.app_user_name,apps)
		path = string.join(apps,',')
		digest = getdigest(path)
		# BaseAppServer.instance().getCacheServer().set(key,value)
		return digest

	def _get_app_account_hash_from_cache(self,user):
		user_id = 0
		if type(user) == core.OrgUser:
			user_id = user.id
		else:
			user = int(user_id)
		key = swarm.base.CacheFieldFormatType.user_app_acct_hash%(user_id,)
		value = BaseAppServer.instance().getCacheServer().get(key)
		return value



	@decorators.list_route(methods=['get'])
	def satisfaction(self,request):
		"""
		满意度调查
		:param request:
		:return:
		"""

		cr = SuccCallReturn()
		try:
			serial = serializer.Analyses_SecondSales_Serializer(data=request.query_params)
			if not serial.is_valid(False):
				return FailCallReturn(ErrorDefs.ParameterIllegal).httpResponse()

			user = core.OrgUser.objects.get(user_name = serial.data['user_acct'])
			#找出 biz_mode关联的app，并判别app是否已经配置？
			bizmode_type = swarm.base.AnalysisDataModeDef.Satisfaction.value
			datamode = core.AnalysisDataModel.objects.get(type = bizmode_type)
			apps = datamode.apps.all()

			error_result =[]
			for app in apps:
				if user.userapp_set.all().filter(app__id = app.id).count() == 0:
					#用户未配置 app 帐号
					error_result.append({'app_name':app.name,'app_type':app.type,'app_auth_uri':app.auth_uri})
			if error_result:
				cr = FailCallReturn(swarm.error.ErrorDefs.AppUnAuthorized)
				cr.assign( error_result )
				return cr.httpResponse()

			# apps =user.userapp_set.all().order_by('app_user_name')
			# if not apps:
			# 	return FailCallReturn(swarm.error.ErrorDefs.AppUnAuthorized).httpResponse()
			# 	未有帐号绑定

			apps =user.userapp_set.all().order_by('app_user_id')
			appnames = map(lambda  app:app.app_user_id,apps)	# 将app帐号名称拼接成串

			job = service.core.Job()
			job.user_id = user.id
			job.user_acct = serial.data['user_acct']
			# job.biz_model = serial.data['biz_model']
			job.biz_model = swarm.base.AnalysisDataModeDef.Satisfaction.value
			job.app_accts = appnames

			status,result = service.core.JobService.instance().getJobResult(job.ID)

			enable = BaseAppServer.instance().getConfig().get('connector_enable','true')
			if not enable:
				print 'service "connector" be skipped..'
				status = service.core.JobStatusType.FINISHED

			if status == service.core.JobStatusType.FINISHED:

				accts = string.join( map(lambda  a: '%s:%s'%(a.app.type,a.app_user_id),apps) ,',')

				data = dict(request.query_params)

				request_uri = BaseAppServer.instance().getConfig().get('acs_data_analyses_uri')
				request_uri +='/satisfaction'
				# print request.GET
				# '''{u'time_granule': [u'day'], u'user_acct': [u'wangdazhi'], u'start_time': [u'0'], u'biz_model': [u'satisfaction'], u'subtype': [u'5'], u'end_time': [u'0']}>
				# '''
				params = map(lambda p: (p[0],p[1][0]),data.items())
				data = dict(params)
				data['app_accts'] = accts

				# print request_uri+'?'+urllib.urlencode( data )

				resp = urllib2.urlopen( request_uri+'?'+urllib.urlencode( data ))
				content = json.loads( resp.read() )
				return Response(content)	#从acs返回的

			elif status == service.core.JobStatusType.RUNNING:
				cr = FailCallReturn(swarm.error.ErrorDefs.DataInProcessing)
			else:
				service.core.JobService.instance().createJobRunner(job).startJob()
				# if not result:
				# 	cr = FailCallReturn(ErrorDefs.InternalException,u'startJob Failed')
				# else:
				cr = FailCallReturn(swarm.error.ErrorDefs.DataInProcessing)
		except:
			traceback.print_exc()
			cr = FailCallReturn(ErrorDefs.InternalException)
		return cr.httpResponse()