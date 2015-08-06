#coding:utf-8

__author__ = 'scott'


from rest_framework import serializers
import os,sys,datetime
from model.django.core import models as core
import desert

class ConnectorTaskSerializer(serializers.Serializer):
	task_id = serializers.CharField(max_length=120)
	start_time = serializers.IntegerField(default=0,required=False)
	elapsed = serializers.IntegerField(default=0,required=False)
	dataset = serializers.CharField(max_length=120,required=False,default='')
	service_id = serializers.CharField(max_length=120,required=False,default='') # 服务器编号
	reason = serializers.CharField(max_length=120,required=False,default='') # 服务器编号


class Analyses_SecondSales_Serializer(serializers.Serializer):
	user_acct = serializers.CharField(max_length=40)
	biz_model = serializers.CharField(max_length=20,required=False)
	subtype = serializers.CharField(max_length=20,required=False)
	time_granule = serializers.CharField(max_length=20,required=False,default='week')
	start_time = serializers.IntegerField(default=0,required=False)
	end_time = serializers.IntegerField(default=0,required=False)
