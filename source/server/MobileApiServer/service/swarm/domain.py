__author__ = 'scott'


from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.decorators import api_view
from desert.errors import ErrorDefs
from desert.webservice.webapi import SuccCallReturn,FailCallReturn
from model.django.core import  models as core

@api_view(['GET'])
def domain_probe(request,domain):
	cr = SuccCallReturn()
	try:
		if core.Orgnization.objects.filter(domain = domain).count():
			cr.assign(domain)
		else:
			cr = FailCallReturn(ErrorDefs.ObjectNotExisted)
	except:
		cr = FailCallReturn(ErrorDefs.ObjectNotExisted)
	return cr.httpResponse()