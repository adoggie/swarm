#coding:utf-8

from django.conf.urls import patterns, include, url
from rest_framework.routers import  DefaultRouter


import service.view.callback
import service.view.data
import service.view.job


router = DefaultRouter()


router.register(r'WEBAPI/jobserver/callback/task', service.view.callback.TaskViewSet,'task')	#第三方账号绑定
router.register(r'WEBAPI/jobserver/data/analyses', service.view.data.DataAnalysesViewSet,'data')	#第三方账号绑定
router.register(r'WEBAPI/jobserver/jobs', service.view.job.JobsViewSet,'jobs')	#第三方账号绑定

urlpatterns = patterns('',
	# url(r'^WEBAPI/jobserver/data/analysis','service.view.data.data_analysis',name='analysis'),
)

urlpatterns += router.urls
print urlpatterns