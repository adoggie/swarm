#--coding:utf-8 --

__author__ = 'root'



import os,sys,datetime,traceback
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.decorators import api_view
from desert.errors import ErrorDefs
from desert.webservice.webapi import SuccCallReturn,FailCallReturn
# from model.django.core import  models as core

import desert.image.sign_code

from desert.misc import genUUID,getdigest
from desert.app import BaseAppServer
from serializer import SendMail_Serializer

@api_view(['GET'])
def gen_identify_image(request):
	cr = SuccCallReturn()
	try:
		conf = BaseAppServer.instance().getYamlConfig()['hippo']['idenfity_image']
		prefix = conf.get('key_prefix')
		image,code = desert.image.sign_code.create_validate_code()
		redis = BaseAppServer.instance().getCacheServer()
		key = prefix + '_' + getdigest(code)
		redis.set( key,code,60*5 ) # expired in 5 minutes
		cr.assign( { 'key': key,'data':image} )
	except:
		traceback.print_exc()
		cr = FailCallReturn(ErrorDefs.ObjectNotExisted)
	return cr.httpResponse()

