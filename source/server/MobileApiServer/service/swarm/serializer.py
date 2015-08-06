#coding:utf-8

__author__ = 'scott'

from rest_framework import serializers
import os,sys,datetime
from model.django.core import models as core
import desert

class OrgUserAppConfigSerializer(serializers.ModelSerializer):
	app_name = serializers.SerializerMethodField()
	app_type = serializers.SerializerMethodField()
	app_acct = serializers.SerializerMethodField()
	bind_time = serializers.SerializerMethodField()
	# app_user_name = serializers.SerializerMethodField()


	def validate_name(self,data):
		print data
		return u'shanghai'

	class Meta:
		model = core.OrgUserAppConfig
		fields =('id','app_name','app_type','app_acct','bind_time')

	def create(self, validated_data):
		return self.Meta.model.objects.create(create_time=datetime.datetime.now(), **validated_data)


	def get_app_name(self,instance):
		return instance.app.name

	def get_app_type(self,instance):
		return instance.app.type

	def get_app_acct(self,instance):
		return instance.app_user_name

	def get_bind_time(self,instance):
		return desert.misc.maketimestamp64(instance.app_auth_time)



class UserAppBindSerializer(serializers.Serializer):
	app_type = serializers.IntegerField() #, validators=[MinLengthValidator(7),]
	app_access_token = serializers.CharField(max_length=2000)

class OrgUserSerializer(serializers.ModelSerializer):
	class Meta:
		model = core.OrgUser
		fields = ('user_name','first_name','last_name','email','avatar','position')

	def update(self, instance, validated_data):
		if validated_data.get('first_name'):
			instance.first_name = validated_data.get('first_name')
		if validated_data.get('last_name'):
			instance.last_name = validated_data.get('last_name')
		if validated_data.get('email'):
			instance.email = validated_data.get('email')
		if validated_data.get('avatar'):
			instance.avatar = validated_data.get('avatar')
		if validated_data.get('position'):
			instance.position = validated_data.get('position')
		instance.save()
		return instance


class Analyses_SecondSales_Serializer(serializers.Serializer):
	user_acct = serializers.CharField(max_length=40)
	biz_model = serializers.CharField(max_length=20,required=False)
	subtype = serializers.CharField(max_length=20,required=False)
	time_granule = serializers.CharField(max_length=20,required=False,default='week')
	start_time = serializers.IntegerField(default=0,required=False)
	end_time = serializers.IntegerField(default=0,required=False)
