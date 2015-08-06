#coding:utf-8

__author__ = 'scott'

import os,sys,traceback,time,json

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
from rest_framework.decorators import parser_classes
from rest_framework import parsers

from desert.webservice.webapi import FailCallReturn,SuccCallReturn
from desert.security import encrypt
from desert.auth import encodeUserToken,AuthUserInfo_t,decodeUserToken
from desert import misc
import desert


import serializer

@api_view(['POST'])
@parser_classes( (parsers.FormParser,) )
def orguser_login(request,format=None):
	print request.data.keys()
	cr = SuccCallReturn()
	request.data['platform']='inner_service'
	request.data['device_id'] = 'service_id_0'
	ser = serializer.AccessTokenInvalidator(data = request.data)
	token = ''
	try:
		ser.is_valid(True)
		user = ser.save()
		cr.assign(user)
	except Exception,e:
		traceback.print_exc(e)
		return FailCallReturn(desert.errors.ErrorDefs.UserNameOrPasswordError).httpResponse()
	return cr.httpResponse()


