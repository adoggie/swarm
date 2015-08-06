#coding:utf-8

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

from model.django.core import models as core
from desert.webservice.webapi import SuccCallReturn,FailCallReturn
import serializer
from desert.webservice.webapi import USER_ID
from desert.errors import ErrorDefs
from desert.app import BaseAppServer
import urllib,urllib2,json
from desert.misc import X
import desert.base

def getUserAppList(request):
	user_id = USER_ID(request)
	rs = core.OrgUserAppConfig.objects.filter(user__id=user_id)
	serial = serializer.OrgUserAppConfigSerializer(rs,many=True)
	print serial.data[0]
	return serial.data

class UserAppViewSet(viewsets.ViewSet):
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
		列出所有用户绑定的第三方账号
		:param request:
		:return:
		"""
		cr = SuccCallReturn()
		cr.assign( getUserAppList(request) )
		return cr.httpResponse()



	def create(self,request):
		"""
		手机端app通过oauth授权后发送accessToken，服务器完成验证和数据登记
		"""
		cr = SuccCallReturn()
		user_id = USER_ID(request)
		data = request.data
		serial = serializer.UserAppBindSerializer(data = data)
		if not serial.is_valid(False):
			return FailCallReturn(ErrorDefs.ParameterIllegal)


		try:

			#转发到connector进行账号验证
			data['user_id'] = user_id
			connector_uri = BaseAppServer.instance().getConfig().get('app_bind_uri') # connector 的bind app处理接口

			resp = urllib2.urlopen( connector_uri ,urllib.urlencode( data ))
			content = resp.read()
			r = X(json.loads(content))

			if r.status == ErrorDefs.SUCC.code:#处理成功
				#读取记录
				cfg = core.OrgUserAppConfig.objects.get(user__id = user_id,app__type = data['app_type'])
				serial = serializer.OrgUserAppConfigSerializer(cfg,many=False)
				# result ={'id':cfg.id,'app_type':cfg.app.type,'app_name':cfg.app.name,'app_acct':cfg.app_user_name,'auth_time':cfg.app_auth_time}
				cr.assign( serial.data )
			else:
				cr =FailCallReturn(ErrorDefs.InternalException)
		except:
			cr =FailCallReturn(ErrorDefs.InternalException)
		return cr.httpResponse()


	def destroy(self,request,pk=None):
		"""
		解除绑定
		:param request:
		:param pk:
		:return:
		"""
		cr = SuccCallReturn()
		user_id = USER_ID(request)
		try:
			rs = core.OrgUserAppConfig.objects.filter(id= int(pk),user__id= user_id )
			rs.delete()
		except:
			return FailCallReturn(ErrorDefs.InternalException).httpResponse()
		return cr.httpResponse()

	def retrieve(self,request,pk=None,format=None):
		"""
		接收app账号信息
		:param request:
		:param pk:
		:param format:
		:return:
		"""
		cr = SuccCallReturn()
		user_id = USER_ID(request)
		rs = core.OrgUserAppConfig.objects.filter(id= int(pk),user__id= user_id )
		if not rs:
			return FailCallReturn(ErrorDefs.ObjectNotExisted).httpResponse()
		cfg = rs[0]

		serial = serializer.OrgUserAppConfigSerializer(cfg,many=False)
		print serial
		cr.assign( serial.data )
		return cr.httpResponse()

	def handle_exception(self,exc):
		traceback.print_exc()


