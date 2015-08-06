# -- coding:utf-8 --
import os
import sys,datetime
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "desert.settings")
from model.django.core import models as core

USER_TYPE_ADMIN =1
USER_TYPE_NORMAL = 2

def_apps = [
	{'name':u'salesforce','type':1,'is_active':True},
	{'name':u'desk','type':2,'is_active':True},
	{'name':u'twitter','type':3,'is_active':True},
]

def_clients=[
	{'domain':'ylm','name':u'尤丽美','address':u'上海徐汇区虹桥路200号','zipcode':u'2001234','coutry':u'china','create_date':datetime.datetime.now(),
		'users':[
			{'user_name':u'wangdazhi','user_type':USER_TYPE_ADMIN,'password':111111,'first_name':u'dazhi','last_time':u'wang',
			'email':u'wangdazhi@ylm.com','create_date':datetime.datetime.now(),'login_time':datetime.datetime.now(),'total_times':1,
				'apps':[
					{'type':1,'app_user_name':u'wangdazhi@ylm.com'},
					{'type':2,'app_user_name':u'wangdazhi@qq.com'}
				]
			},
			{'user_name':u'xiaoxin','user_type':USER_TYPE_NORMAL,'password':111111,'first_name':u'xin','last_time':u'xiao',
			'email':u'xiaoxin@ylm.com','create_date':datetime.datetime.now(),'login_time':datetime.datetime.now(),'total_times':1,
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



def_users=[{
	'id':1,
	'user':'test',
    'passwd':'111111',
    'name':'test',
    'age':10,
    'email':'24509826@qq.com',
    'teams':[{'id':1,'name':'team1_in_test1'},{'id':2,'name':'team2_in_test1'}],
    'in_teams':[],
	},
	{
	'id':2,
	'user':'test2',
    'passwd':'111111',
    'name':'test2',
    'age':10,
    'email':'245098262@qq.com',
	'teams':[],
	'in_teams':[1,]
	},
    {
	'id':3,
	'user':'test3',
    'passwd':'111111',
    'name':'test3',
    'age':10,
    'email':'245098263@qq.com',
    'teams':[],
	'in_teams':[1,]
	},
	]

def init_database():
	clearup()

	for k,v in global_settings.items():
		en = cm.GlobalSettings()
		en.name = k
		en.value= v
		en.save()

	users={}
	for i in def_users:
		r = cm.User()
		r.user = i['user']
		r.name = i['name']
		r.passwd = i['passwd']
		r.age = i['age']
		r.email = i['email']
		r.save()

		users[i['id']] = i # users= {id,user}
		i['delta'] = r #关联信息到 dbobj

	teams={}
	for id,user in users.items():
		#user['delta']  指向 dbobj
		for teaminfo in user['teams']: #依次创建群
			team = cm.UserTeam()
			team.user = user['delta']
			team.name = teaminfo['name']
			team.save()
			teaminfo['owner_id'] = id
			teaminfo['delta'] = team
			teams[teaminfo['id']] = teaminfo

			#rel = cm.TeamRelation()
			#rel.user = team.user
			#rel.team = team
			#rel.save()
			#rel = cm.UserRelation()
			#rel.user = user['delta']
			#rel.friend = user['delta']
			#rel.team = team
			#rel.save()  #将本人加入自己的群内

	for id,user in users.items():
		for teamid in user['in_teams']:
			team = teams[teamid]
			userid = team['owner_id']
			owner_of_team = users[userid]
			rel = cm.UserRelation()
			rel.user = owner_of_team['delta']
			rel.friend = user['delta']
			#rel.team = team['delta']
			rel.save()

			rel = cm.UserRelation()
			rel.user = user['delta']
			rel.friend = owner_of_team['delta']
			rel.save()

			rel = cm.TeamRelation()
			rel.user = user['delta']
			rel.team = team['delta']
			rel.save()




if __name__ == "__main__":
	init_database()
