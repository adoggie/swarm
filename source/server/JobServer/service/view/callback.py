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
import serializer

from desert.webservice.webapi import SuccCallReturn,FailCallReturn
from desert.errors import ErrorDefs

from desert.misc import X
import service.core

class TaskViewSet(viewsets.ViewSet):
	"""
	第三方账号信息
	"""
	pagination_class = pagination.PageNumberPagination
	paginate_by = 10
	paginate_by_param ='page_size'
	parser_classes = (parsers.JSONParser,)


	@decorators.list_route(methods=['post'])
	def finished(self,request):
		"""
		connector 通知任务完成
		:param request:
		:return:
		"""
		cr  = SuccCallReturn()
		serial = serializer.ConnectorTaskSerializer(data=request.data)
		if not serial.is_valid(False):
			return FailCallReturn(ErrorDefs.ParameterIllegal).httpResponse()
		task = X(serial.data)#

		service.core.JobService.instance().onJobTaskFinished(task)
		return cr.httpResponse()



	@decorators.list_route(methods=['post'])
	def aborted(self,request):
		"""
		connector 通知任务执行失败
		:param request:
		:return:
		"""
		cr  = SuccCallReturn()
		serial = serializer.ConnectorTaskSerializer(data=request.data)
		if not serial.is_valid(False):
			return FailCallReturn(ErrorDefs.ParameterIllegal).httpResponse()
		task = X(serial.data)
		service.core.JobService.instance().onJobTaskAborted(task)
		return cr.httpResponse()

