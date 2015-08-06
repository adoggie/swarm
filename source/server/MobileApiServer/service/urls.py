#coding:utf-8

from django.conf.urls import patterns, include, url

from rest_framework.routers import  DefaultRouter
# import swarm.account
# import swarm.analysis
# import swarm.me
# import service.auth.token
import service
# import service.swarm.app.UserAppViewSet

from swarm.app import UserAppViewSet
from swarm.me import MeViewSet,fetchall
import service.swarm.me
import service.swarm.data
import service.swarm.bizmodel
import service.hippo.sendmail
import service.hippo.identify_image

router = DefaultRouter()


router.register(r'WEBAPI/appserver/app-account',UserAppViewSet,'account')	#第三方账号绑定

router.register(r'WEBAPI/appserver/data/analyses', service.swarm.data.DataAnalysesViewSet,'data')	#第三方账号绑定
router.register(r'WEBAPI/appserver/bizmodels', service.swarm.bizmodel.BizModelViewSet,'bizmodel')	#模型视图

domain_pattern = '[a-zA-Z0-9][-a-zA-Z0-9]{0,62}'
urlpatterns = patterns('',

	url(r'^WEBAPI/appserver/domain/(%s)/$'%domain_pattern,'service.swarm.domain.domain_probe',name='test1'),
	url(r'^WEBAPI/auth/accessToken/$',service.auth.token.user_login,name='userlogin'),
	url(r'^WEBAPI/auth/accessToken/detail/$',service.auth.token.decode_user_token,name='token_detail'),
	url(r'^WEBAPI/auth/restricted/orguser/login/$',service.auth.restricted.orguser_login,name='orguser_login'),


	url(r'WEBAPI/appserver/me/$',MeViewSet.as_view(),name='me'),
	url(r'WEBAPI/appserver/me/fetchall/$',service.swarm.me.fetchall,name='me-fetchall'),
	url(r'^WEBAPI/hippo/sendmail/$',service.hippo.sendmail.sendmail,name='sendmail'),
	url(r'^WEBAPI/hippo/identify_image/$',service.hippo.identify_image.gen_identify_image ,name='identify_image'),

)

urlpatterns += router.urls
print urlpatterns