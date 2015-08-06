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
from desert.misc import X,maketimestamp64
from desert.app import BaseAppServer
import urllib,urllib2,json,copy
import serializer
from model.django.core import  models as core


class BizModelViewSet(viewsets.ViewSet):
	"""
	第三方账号信息
	"""
	pagination_class = pagination.PageNumberPagination
	paginate_by = 10
	paginate_by_param ='page_size'
	parser_classes = (parsers.JSONParser,)


	def list(self,request):
		"""
		获取用户所能使用的所有业务模型
		"""
		user_id = USER_ID(request)
		cr = SuccCallReturn()
		try:
			user = core.OrgUser.objects.get(id = user_id)
			bizmodels = user.org.data_models.all()
			result =[]
			auth_time = 0
			is_authed = False
			for m in bizmodels:
				obj ={'name':m.name,'type':m.type,'comment':m.comment,'apps':[]}
				for app in m.apps.all():

					appcfgs = core.OrgUserAppConfig.objects.filter(user__id=user_id,app__type=app.type)
					if appcfgs:
						auth_time = maketimestamp64( appcfgs[0].app_auth_time)
						if auth_time:
							is_authed = True

					obj['apps'].append({'name':app.name,'type':app.type,'auth_uri':app.auth_uri,'is_authed':is_authed,'auth_time':auth_time})
				result.append(obj)
			cr.assign( result )

		except:
			traceback.print_exc()
			cr = FailCallReturn(ErrorDefs.InternalException)
		return cr.httpResponse()