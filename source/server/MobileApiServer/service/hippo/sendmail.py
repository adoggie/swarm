#--coding:utf-8 --
__author__ = 'root'


from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.decorators import api_view
from desert.errors import ErrorDefs
from desert.webservice.webapi import SuccCallReturn,FailCallReturn
from model.django.core import  models as core

import desert.network.sendmail

from desert.misc import genUUID
from desert.app import BaseAppServer
from serializer import SendMail_Serializer

@api_view(['POST'])
def sendmail(request):
	cr = SuccCallReturn()
	try:
		conf = BaseAppServer.instance().getYamlConfig()['hippo']['smtp']

		mail_to =[]
		serial = SendMail_Serializer(data = request.data)
		if not serial.is_valid():
			print serial.errors
			return FailCallReturn(ErrorDefs.ParameterIllegal).httpResponse()

		mail_to = request.data['mail_to'].split(',')
		subject = request.data['subject']
		content = request.data['content']
		mail_from = request.data.get('mail_from')
		if not mail_from:
			mail_from = conf.get('mail_from')

		mail_host= conf.get('smtp_host')
		mail_port = conf.get('smtp_port')
		mail_user = conf.get("user")
		mail_user_password = conf.get('password')

		desert.network.sendmail.send_mail_smtp( mail_to, subject,content,mail_user,mail_user_password,mail_from,mail_host)
		identify = genUUID()
		cr.assign( identify )
	except:
		cr = FailCallReturn(ErrorDefs.ObjectNotExisted)
	return cr.httpResponse()

