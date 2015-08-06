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
from model.django.core import  models as core
from serializer import OrgUserSerializer
import serializer

import  app



def getSelfInfo(request):
	user_id = USER_ID(request)
	result = {}
	try:
		user = core.OrgUser.objects.get(id = user_id)
		serial = OrgUserSerializer(user,many=False)
		result = serial.data
	except:
		traceback.print_exc()
	return result

class MeViewSet(APIView):
	"""
	当前用户信息操作
	提供获取和修改功能接口
	"""



	def get(self,request,format=None):
		user_id = USER_ID(request)
		cr = SuccCallReturn()
		result = getSelfInfo(request)
		cr.assign(result)
		return cr.httpResponse()



	def put(self,request):
		user_id = USER_ID(request)
		cr = SuccCallReturn()

		try:
			user = core.OrgUser.objects.get(id = user_id)
			serial = serializer.OrgUserSerializer(user,data=request.data,partial=True)
			if not serial.is_valid(False):
			# 	return FailCallReturn(ErrorDefs.ParameterIllegal).httpResponse()
				print serial.errors
			serial.save()
		except:
			traceback.print_exc()
			cr = FailCallReturn(ErrorDefs.InternalException)
		return cr.httpResponse()


@api_view(['GET'])
def fetchall(request,format=None):
	cr = SuccCallReturn()
	result = {
		'user':getSelfInfo(request),
		'apps':app.getUserAppList(request)
	}
	cr.assign(result)
	return cr.httpResponse()