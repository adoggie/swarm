#coding:utf-8

from django.conf.urls import patterns, include, url

#from rest_framework.routers import  DefaultRouter

import sendmail
import identify_image

urlpatterns = patterns('',
	url(r'^sendmail/$',sendmail.sendmail),
)

