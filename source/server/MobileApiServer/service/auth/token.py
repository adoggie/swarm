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
def user_login(request,format=None):
	print request.data.keys()
	cr = SuccCallReturn()
	ser = serializer.AccessTokenInvalidator(data = request.data)
	token = ''
	try:
		ser.is_valid(True)
		user = ser.save()
		token = encodeUserToken( json.dumps(user))
		cr.assign({'token':token})
	except Exception,e:
		traceback.print_exc(e)
		return FailCallReturn(desert.errors.ErrorDefs.UserNameOrPasswordError).httpResponse()
	return cr.httpResponse()


@api_view(['GET'])
@parser_classes( (parsers.FormParser,) )
def decode_user_token(request,format=None):
	"""
	获取用户token中携带的内容
	:param request:
	:param format:
	:return:
	"""
	cr = SuccCallReturn()
	try:
		token = request.query_params.get('token')
		user = json.loads(decodeUserToken(token))
		cr.assign( user)
	except Exception,e:
		traceback.print_exc(e)
		return FailCallReturn(desert.errors.ErrorDefs.UserNameOrPasswordError).httpResponse()
	return cr.httpResponse()
