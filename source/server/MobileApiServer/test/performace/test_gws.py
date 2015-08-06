#--coding:utf-8--

"""
test_gws.py

名称 ：
	gws服务器接入功能
需求：
    测试指标包括：
    	单gws服务最大并发连接数
    	每单位数量的连接对系统资源的开销，包括： 处理器、内存、磁盘、网络负荷
    	数据传送效率，在不同连接数情况下，服务器接收和发送数据的时效性
    	错误出现的机率
    	单机可部署多少 gws 服务进程
要求：

环境：
	4 core
	model name	: Intel(R) Core(TM) i3-2120 CPU @ 3.30GHz
	stepping	: 7
	cpu MHz		: 3300.000
	cache size	: 3072 KB

	gws ：  centos6.5  64bit  ram:4G, hdd:500G
	      max_file_fd = 65536
	      python + gevent + libev
    client :  centos 6.5
        python ,gevent , tce

    client与gws在同一台主机,  socket tcp 直连


方法：
    客户端程序 模拟用户登录，获取认证 token，已tce提供的rpc方式建立与gws的通道
    客户机定时 每隔 5s 发送心跳包到gws服务器

	并发用户数控制：
	   默认：1
	   test_gws.py [ n_thread ]

    尝试  1.单单建立tcp连接不发包
         2. 建立tcp链接，定时发送ping包


	采集监视:
	    watch -n 1 "lsof -p `pgrep -f gws` | wc -l "
	    top  -p `pgrep -f gws`

记录:
	connections
	 0 			357m  31m 4740 S  0.0  0.9
	 500        514m  40m 4740 S  5.7  1.1
	 1000        520m  47m 4740 S  12  1.3
	 5000        590m  117m 4740 S  33  3.2
	 10000       677m  204m 4740 S  69  5.0
     10000      (no redis)  527m  202m 4740 S  32  5.5  （5s ping)

     10000      (no redis,no ping()) 525m 200m 4748  0 5.4
     20000      (no redis,no ping()) 695m 368m 4748  0 9.9
     28000 ~ 开始链接发送失败 （no redis,no ping)

	sysctl.conf add following params:
		net.ipv4.ip_local_port_range = 1024 65000
	30000  (no ping, no redis) 866m 540m 4748 S  0.0 14.6
	39000  (no ping, no redis) 1016m 647m 1804 D 22.6 17.5
	46000  (no ping, no redis) 1136m 702m 1728 S  0.0 19.0
		client:  2597m 846m 1700 S  0.0 22.8


结论：
   1. 连接数达到2w之后开始 连接拒绝
   2. 10000路连接时cpu 69% 在注释掉任何外部服务请求(redis）情况下cpu达到 32%
       问题在于python在处理rcp数据序列化时的计算负荷相当严重
       当 增大 发送ping包间隔到 15s 之后，cpu负荷最高峰达到35%，最低趋近 0.7 %， 同时被均摊到不同cpu

	3. 客户机和server均在一台机器，起初到2.8w产生无法链接的现象， 发现是iptables服务和sysctl.conf限制了客户机外发的链接请求
	  关闭iptables、设置net.ipv4.ip_local_port_range = 1024 65000 ，再次测试发现 请求 5w次并发都可已成功，只是到3，4w时打开
	  速度明显减慢，很可能时客户端程序影响了整机的性能
	  链接数的测试可将客户程序分布到其他主机,再进行连接请求测试

"""


import imp
imp.load_source('init','../../init_script.py')

import os,os.path,sys,struct,time,traceback,time
import tcelib as tce
from service.lemon_impl import *
import lemon

import gevent
from gevent import monkey
monkey.patch_all()

class TerminalImpl(ITerminal):
	def __init__(self):
		ITerminal.__init__(self)

	def onNotifyMessage(self,notify,ctx):
		print 'onNotifyMessage:',notify



def Proxy():
	ep = tce.RpcEndPoint(host='192.168.10.100',port=14001)
	return  ITerminalGatewayServerPrx.create(ep)

# def sslProxy():
# 	ep = tce.RpcEndPoint(host='localhost',port=16005,ssl=True)
# 	return ITerminalGatewayServerPrx.create(ep)
#

def userLoginToken(user_id=1):
	ar = AuthResult_t()
	ar.user_id = user_id
	ar.user_name = 'user_%s'%user_id
	ar.login_time = int(time.time())
	ar.expire_time = ar.login_time + 3600*5  #默认 5天过期
	token = lemon.encrypt.encryptUserToken(ar)
	return token




G_USER_ID = 0
def nextUserId():
	global  G_USER_ID
	G_USER_ID+=1
	return G_USER_ID

def executeTestCase():
	proxy = Proxy()

	token = userLoginToken(G_USER_ID)
	proxy.conn.setToken(token)
	proxy.ping_oneway()
	#gevent.sleep(10000)
	for n in xrange(10000):
		print 'try to ping..'
		proxy.ping_oneway()
		gevent.sleep(15)

THREAD_NUM= 1
communicator =tce.RpcCommunicator.instance().init()

def run():
	start = time.time()
	lets =[]

	threadnum = THREAD_NUM
	if len(sys.argv)>1:
		threadnum = int(sys.argv[1])
	print 'issued thread num:',threadnum
	for x in range( threadnum ):
		lets.append(gevent.spawn(executeTestCase))
	gevent.joinall(lets)
	end = time.time()
	print 'testing time elasped:',int(end-start),' seconds'

if __name__=='__main__':
	run()
	pass


