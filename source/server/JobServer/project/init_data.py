# -- coding:utf-8 --
import os
import sys,datetime

PATH = os.path.dirname(os.path.abspath(__file__))

LIBS=(
	PATH+'/../../common/python',
)
for lib in LIBS:
	sys.path.insert(0,lib)



os.environ.setdefault("DJANGO_SETTINGS_MODULE", "settings")

from model.django.core import models as core
from desert.misc import X,genUUID

USER_TYPE_ADMIN =1
USER_TYPE_NORMAL = 2

def_apps = {
	1:{'name':u'salesforce','type':1,'is_active':True} ,
	2:{'name':u'desk','type':2,'is_active':True} ,
	3:{'name':u'twitter','type':3,'is_active':True} ,
}

def_clients=[
	{'domain':'ylm','name':u'尤丽美','address':u'上海徐汇区虹桥路200号','zipcode':u'2001234','country':u'china','create_date':datetime.datetime.now(),
		'users':[
			{'user_name':u'wangdazhi','user_type':USER_TYPE_ADMIN,'password':111111,'first_name':u'dazhi','last_name':u'wang',
			'email':u'wangdazhi@ylm.com',
				'apps':[
					{'type':1,'app_user_name':u'wangdazhi@ylm.com'},
					{'type':2,'app_user_name':u'wangdazhi@qq.com'}
				]
			},
			{'user_name':u'xiaoxin','user_type':USER_TYPE_NORMAL,'password':111111,'first_name':u'xin','last_name':u'xiao',
			'email':u'xiaoxin@ylm.com',
				'apps':[
					{'type':1,'app_user_name':u'xiaoxin@ylm.com'},
					{'type':2,'app_user_name':u'xiaoxin@qq.com'}
				]
			},

		]
	}
]


def clearup():
	core.OrgUserAppConfig.objects.all().delete()
	core.OrgUser.objects.all().delete()
	core.Orgnization.objects.all().delete()
	core.Application.objects.all().delete()

def init_database():
	clearup()

	for key,app  in def_apps.items():
		app = X(app)
		core.Application(name=app.name,type=app.type,is_active=app.is_active).save()

	for client in def_clients:
		c = X(client)
		org = core.Orgnization(domain=c.domain,name=c.name,address=c.address,zipcode=c.zipcode,country=c.country,create_date=c.create_date)
		org.save()

		# print client
		for user in c.users:
			print user.user_name
			user_obj = core.OrgUser(org= org,user_type=user.user_type,user_name=user.user_name,password=u'111111',
				first_name= user.first_name,last_name=user.last_name,alias=u'',email=user.email,create_date = datetime.datetime.now(),
				is_active = True,login_time= datetime.datetime.now(),total_times = 1,avatar=u'',position=u'ceo'
			)
			user_obj.save()
			for app in user.apps:
				app_type = core.Application.objects.get(type = app.type)
				app_obj = core.OrgUserAppConfig(app = app_type,user = user_obj,is_active = True,
					app_access_token=genUUID(),
					app_instance_url=u'http://sf.com/instance_url',
					app_user_id = u'2313123123124214',
					app_user_name = app.app_user_name,
					app_auth_time = datetime.datetime.now()
				)
				app_obj.save()



if __name__ == "__main__":
	init_database()
