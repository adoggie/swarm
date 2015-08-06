#coding:utf-8

__author__ = 'scott'

from rest_framework import serializers
import os,sys,datetime
from model.django.core import models as core
import desert

class SendMail_Serializer(serializers.Serializer):
	mail_to = serializers.CharField(max_length=400)
	subject = serializers.CharField(max_length=100)
	content = serializers.CharField(max_length=400)
	mail_from = serializers.CharField(max_length=20,required=False)
