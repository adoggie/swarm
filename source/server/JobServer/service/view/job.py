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



class JobsViewSet(viewsets.ViewSet):
	"""
	第三方账号信息
	"""
	pagination_class = pagination.PageNumberPagination
	# serializer_class =  serializer.AdminUserSerializer

	paginate_by = 10
	# page_size = 10
	paginate_by_param ='page_size'
	parser_classes = (parsers.JSONParser,)


	def list(self,request):
		"""
		列出运行中所有的job runner
		:param request:
		:return:
		"""
		return Response()


	def retrieve(self,pk,request):
		"""
		获取指定job的详情
		:param pk:
		:param request:
		:return:
		"""
		return Response()

	def destroy(self,pk):
		"""
		删除的job runner
		删除已完成的和进行中的job
		:param pk:
		:return:
		"""
		return Response()

