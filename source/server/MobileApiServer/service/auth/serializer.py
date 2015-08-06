__author__ = 'scott'

from rest_framework import  serializers
from desert.auth import AuthUserInfo_t
import time,hashlib
from desert.misc import getdigest
from model.django.core import models as core

class AccessTokenInvalidator(serializers.Serializer):
	user = serializers.CharField(max_length=40) #, validators=[MinLengthValidator(7),]
	password = serializers.CharField(max_length=30)
	platform = serializers.CharField(max_length=20,required=False)
	device_id = serializers.CharField(max_length=80,required=False)
	domain =  serializers.CharField(max_length=20)

	def create(self, validated_data):
		# user = AuthUserInfo_t(user_id=1,user_name=validated_data['user'],login_time= int(time.time()))
		user = core.OrgUser.objects.get(org__domain=validated_data['domain'],user_name = validated_data['user'])
		salt,password = user.salt,user.password
		digest = getdigest(salt+ validated_data['password'])
		if digest!=password:
			return {}
		user = {'user_id':user.id,'user_name':user.user_name,'user_type':user.user_type,'domain':user.org.domain}
		return user


