#coding:utf-8


__author__ = 'scott'
import os,sys,traceback,time

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

from desert.webservice.webapi import SuccCallReturn,FailCallReturn,USER_ID
from desert.errors import ErrorDefs
from desert.misc import X
from desert.app import BaseAppServer
import urllib,urllib2,json,copy
import serializer
from model.django.core import  models as core

class DataAnalysesViewSet(viewsets.ViewSet):
	"""
	第三方账号信息
	"""
	pagination_class = pagination.PageNumberPagination
	paginate_by = 10
	paginate_by_param ='page_size'
	parser_classes = (parsers.JSONParser,)


	@decorators.list_route(methods=['get'])
	def satisfaction(self,request):
		"""
		转发 业务分析请求到  jobserver
		:param request:
		:return:
		"""
		user_id = USER_ID(request)
		cr = SuccCallReturn()
		try:
			user = core.OrgUser.objects.get(id = user_id)
			data = copy.deepcopy(request.query_params)
			data['user_acct'] = user.user_name
			serial = serializer.Analyses_SecondSales_Serializer(data=data)
			if not serial.is_valid(False):
				print serial.errors
				return FailCallReturn(ErrorDefs.ParameterIllegal).httpResponse()
			#
			jobserver_uri = BaseAppServer.instance().getConfig().get('job_server_data_analyses_uri')
			request_uri = jobserver_uri+'/satisfaction'

			# data = serial.data
			#
			# user = core.OrgUser.objects.get(id = user_id)
			# data['user_acct'] = user.user_name

			resp = urllib2.urlopen( request_uri+'/?'+urllib.urlencode( data ))
			content = json.loads( resp.read() )
			# cr.assign( content)
			return Response(content)
		except:
			traceback.print_exc()
			cr = FailCallReturn(ErrorDefs.InternalException)
		return cr.httpResponse()