
<div align='right'>
zhang.bin  <br>
2015.7.10
</div>




##目录
1. 系统结构 （V1.0.1/V1.0.0 ）
2. 运行部署 
3. docker
4. binpack
5. 服务配置
6. QA
7. 版本计划


##1.系统结构 

项目子系统包括： 

`V1.0.0`

1. IOS终端软件   MobileApp
2. 移动终端接入服务 MobileServer
3. 统一认证服务 AuthServer
4. 系统管理门户  SysAdminPortal
5. 任务调度服务 JobServer
6. 数据采集服务 Connector
7. 数据分析服务 AnalysisServer (ACS)

`V1.0.1`

1. Android终端软件 （与HTML5结合）
1. 用户管理门户 UserPortal
2. 邮件/消息服务  MailMessageServer(MMS)

```
接口方式： REST/WEBAPI 
存储方式： POSTGRESQL/ MONGODB
计算分析:  MAPREDUCE / MONGODB
```

## 2.系统部署 

#### 2.1 aws资源

   aws服务EC2 + ESB 
   
   编号 | 名称  | 配置  | 功能 
   ----|------|-------|------
   1 | EC2-1 |4 core,ram:8G,ESB(10G,40G)| MONGODB REDIS
   2 | EC2-2 |4 core,ram:8G,ESB(10G,20G)|POSTGRESQL
   3 | EC2-3 |4 core,ram:8G,ESB(10G,20G) | Web接入服务集合(Portal/Mobi/Nginx)   
   4 | EC2-4 |4 core,ram:8G,ESB(10G,20G) | 平台内部服务集合(Connector/ACS/JOBSERVER/MMS)
   5 | EC2-5 |4 core,ram:8G,ESB(10G,40G) | 管理运维(数据备份，软件调试.. )
   6 | EC2-6 |2 core,ram:8G,ESB(10G,20G) | nginx/loadbalance
   
   `以上EC2均需额外增加 10G的ESB作为swap `
  
####  2.2 安全管理： 
 
##### 1. aws提供网络安全策略，在aws的管理console界面方便的进行设置。 
##### 2. 主机安全设置
 
1.  EC2-3开放对外的HTTP端口，EC-5开放SSH端口，其他的EC2主机均隔离在aws内部网络。
 
  2. EC2-5作为登录跳板，进入EC2-5之后方能访问到其他EC2主机。
   
  3.  对外提供ssh的主机必须以秘钥证书方式登陆  ssh -i aws.pem root@hostname
   
   
   主机| 服务名称 | 内部端口 | 外部端口
   ------| --|---|-----
   EC2-1 | MONGODB/REDIS | 12707/6607/22 |
   EC2-2 | POSTGRESQL | 5432 / 22 |
   EC2-3 | 公司网站/管理门户/用户门户/移动接入服务 |  15001/15002/15003/15004/22 |80 /443
   EC2-4 | 平台内部服务集合 | 16001/16002/16003/22 |
   EC2-5 | 运维管理  |22 |22 
   EC2-6 | nginx | 22 | 80/443
   

##### 3.https 服务
 除了公司官网服务之外的其他对外的webservice都应采用单向rsa加密。
 
？ 证书购买问题
？ 


#### 2.3.反向代理

Ngix部署在EC2-3/EC2-6,负责将HTTP请求分派到EC2-3和EC2-4

app的oauth callback  配置为MobileServer的接口URL，MobileServer经过鉴权之后将请求转向connector服务

目前不考虑集群服务处理
   
#### 2.4 域名服务

1. 公司域名  www.51desk.com / www.51desk.cn 
2. 企业用户域名 <enterprise>.52desk.com 

#### 2.5 邮件服务 

 1.基础邮件服务 
   购买邮件服务、空间、提供 no-reply,admin,support等服务账号 ；
   
 2.平台邮件消息服务 
  提供邮件发送服务
 
#### 2.6 软件环境   

1. 操作系统   centos6.5+ 64bit 

2. 运行容器  docker 1.5 +
   
3. 中间件和其他服务系统： 

```
	postgresql  9.4 	
	mongodb 3.0.3
	redis 3.0.0 
```   

#### 2.7 运行监控

采集内容： 
    主机信息，包括： 监控cpu、磁盘、内存、io负荷 

采集方式：
    SNMP，agent，syslog，服务程序接口

监控工具： 
	nagios

#####2.8 系统备份
每台服务主机设置cron服务，定期进行数据备份，备份主要对象是postgresq和 mongodb数据库 
  



		

###3. docker

#####3.1. 介绍 

```
1.kernel    2.6+/3.0+   kernel-symbols 
2.enviroment  centos/suse/slackware/ubuntu..    runtime-libs
3.your apps  
```  
  
几种部署方式： 

1. 安装、编译、适配 ... 一路到底，`重复的噩梦`  (不同的LINUX发行版本、内核版本)
2. 找出程序的依赖，打包，拷贝 (ldd,nm...) `有挑战的工作` (相同的LINUX发行版本) 
3. 全磁盘拷贝  dd if=/dev/sda of=/dev/sdb  	`变更了，还得重来`
4. 虚拟技术 kvm,XEN... `累死了，太重`
5. docker `killer`	

`Docker allows you to package an application with all of its dependencies into a standardized unit for software development.`


	环境管理复杂: 简化部署多种应用实例工作，比如Web应用、后台应用、数据库应用、大数据应用比如Hadoop集群、消息队列等等都可以打包成一个Image部署。
 
	然而无论是KVM还是Xen，在 Docker 看来都在浪费资源，用户需要的是高效运行环境而非OS, GuestOS既浪费资源又难于管理, 更加轻量级的LXC更加灵活和快速

	隔离性 Linux Namespace(ns)
	每个用户实例之间相互隔离, 互不影响。 将container的进程、网络、消息、文件系统、UTS("UNIX Time-sharing System")和用户空间隔离开。


```
Docker应用容器相对于 VM 有以下几个优点：
启动速度快，容器通常在一秒内可以启动，而 VM 通常要更久
资源利用率高，一台普通PC 可以跑上千个容器，你跑上千个 VM 试试
性能开销小， VM 通常需要额外的 CPU 和内存来完成 OS 的功能，这一部分占据了额外的资源

优点：
  1. 快速部署，传统的部署模式是：安装(包管理工具或者源码包编译)->配置->运行；Docker的部署模式是：复制->运行。
  2. 可以保证线上与测试环境一致，计划以后上线就直接复制测试使用的docker容器
  
```


##### 3.2.资源：
 
https://registry.hub.docker.com/

http://docker.io/

##### 3.3 安装 

linux 64 lxc based 


```
1. 配置Fedora EPEL源
	sudo yum install http://ftp.riken.jp/Linux/fedora/epel/6/x86_64/epel-release-6-8.noarch.rpm

2. 添加hop5.repo源
	cd /etc/yum.repos.d 
	sudo wget http://www.hop5.in/yum/el6/hop5.repo

3. 安装Docker
	sudo yum install docker-io
	
4. 运行 
	service docker start 
	
```

##### 3.4 基本概念 

![image](file:///Users/scott/Desktop/svn/51desk.swarm/trunk/design/zhangbin/docker.png) 

#####1 image

程序、服务和环境的文件集合.


#####2 container

分配运行的实例

无论容器里做什么操作，写文件，删文件。该容器的基本镜像都不会有任何改变

#####3.5. 基本命令

docker --help 

docker command --help 



```
定制自己的os环境image

1. 下载基础的image
2. docker run -it imageId /bin/bash
3. 安装需要的软件  
4. docker commit containerID newImage:Tags 
```
	
```
docker pull <镜像名:tag>#从官网拉取镜像  
docker search <镜像名>#搜索在线可用镜像名
docker run -name xxxx -it -rmi centos /bin/bash  
docker exec -it postgresql sudo -u postgres psql
docker images 	#显示所有images 
docker rmi -f  image-id   #删除image 
docker ps -a 	显示所有容器
docker start container_id 
docker stop container_id 
docker rm -f container-id 
docker export  导出container
docker save debian02 >/root/debian02.tar #debian02镜像打包
docker load < debian02.tar #导入镜像
docker run -name activemq -d -p 51000:22 debian /base/etc/rc.local
docker run ubuntu env
docker run -v /path/to/hostdir:/mnt $container  
docker run -v /home/postgresql/data:/var/lib/postgresql/data -p 127.0.0.1:5432:5432  -name my-postgres -d postgres

docker run --link my-postgres:db -v /home/mpmsp/project/ezdict/ezbkend:/usr/src/app -name my-app -i -t my-app

```



#####3.6. 制作docker镜像 

#####1. docker commit


#####2. Dockerfile
常用的命令: FROM, MAINTAINER, RUN, ENTRYPOINT, USER, PORT, ADD


##4. binpack
binpack已打包系统运行常用的服务，提供快速启动和停止脚本，包括： 

	mongodb
	nginx
	postgresql
	qpid
	redis
	
启动服务
	
	bash binpack/scripts/start_service.sh  
停止服务
	
	bash binpack/scripts/stop_service.sh 
	



##5. 服务配置 

###5.1 Python环境
需安装的软件包

	django-1.6.5.tar.gz
	djangorestframework-3.1.2.tar.gz
	gevent-1.0.tar.gz
	gevent-psycopg2-0.0.3.tar.gz
	greenlet-0.4.2.zip
	psycogreen-1.0.tar.gz
	psycopg2-2.5.tar.gz
	pycrypto-2.6.1.tar.gz
	pycrypto-on-pypi-2.3.tar.gz
	pymongo-3.0.3.tar.gz
	PyYAML-3.11.tar.gz
	redis-2.9.1.tar.gz
	tornado-4.2.tar.gz


###5.2 Java环境 

	jdk 1.7 
	tomcat  1.7 
	

###5.3 运行参数配置 

####1. MobileServer
####2. Jobserver
	
`common/etc/settings.yaml `

	
	mongodb:
	  host: dev1
	  port: 27017
	  user:
	  passwd:
	  database: sns
	
	redis:
	  host: dev1
	  port:
	  user:
	  passwd:
	
	postgresql:
	  host: dev1
	  port: 5432
	  user: postgres
	  passwd: 111111
	

	mobile_api_server:
	  http:
	    host:
	    port: 16001
	    ssl: false
	    keyfile: /home/ssl/server.key
	    certfile: /home/ssl/server.crt
	  mongodb:  mongodb
	  postgresql: postgresql
	  redis: redis
	  log:
	    stdout: true
	    file: /var/api_server.log
	    dgram: localhost:9901
	  app_bind_uri: http://localhost:16003/WEBAPI/connector/app-account/event/bind
	  job_server_data_analyses_uri: http://localhost:16002/WEBAPI/jobserver/data/analyses
	
	job_server:	
	  http:  #web服务
	    host:
	    port: 16002
	    ssl: false
	    keyfile: /home/ssl/server.key
	    certfile: /home/ssl/server.crt
	  log:	#日志项
	    stdout: true	#屏幕输出控制
	    file: /var/jobserver.log	#文件输出控制
	    dgram: localhost:9900		#syslog控制
	  	
	  mongodb:  mongodb
	  postgresql: postgresql
	  redis: redis
	  
	  watch_time_interval: 10  #定时查询connector task的时间间隔 单位:s
	  max_job_lifetime: 10  # default is 10 hours.  最大任务执行时间，超时则停止此任务 
	
	  callback_uri: http://172.20.0.189:16002/WEBAPI/jobserver/callback #jobserver接收回调接口地址
	
	  score_board:  
	    max_life_time: 1    #  minutes ,  removed automatically by redis 最大的数据抓取有效期，默认一天 ，单位： m
	
	  backend_service_uri:
	    connector: https://172.20.0.192:8443/desk/WEBAPI/connector  #connector采集服务的接口地址
	    acs_data_analyses_uri: http://172.20.0.189:12345/WEBAPI/acs/data/analysis #数据分析服务的接口地址
	
	
	
	
## 6.QA： 

#### 1.ec2 swap配置 

购买ec2资源时，除了选择的esb默认存储之外还必须单独购买一份esb作为swap，大小建议在： 内存 x 2，例如： 8G ram 则swap大小应该16G合适  ；

#### 2. ec2 的stop/terminate
stop与terminate的区别在于后者删除所有资源，包括：ec2主机和esb，所以必须小心。 

系统重启之后公网ip和dns主机名称将丢失；





##7.计划
####7.1 版本计划：
    V1.0.1（8月）：
    1.实现全流程的贯通，以及用户角色权限系统的搭建（参见V1.0.1设计）
    2.进一步完善分析模型在销售领域的应用场景（基于现在集成的Salesforce和Desk的系统，对业务模型进行进一步深化应用）
    3.数据抓取方式优化（探索解决增量备份的问题）
    4.Andriod版本开发（V1.0.0及V1.0.1中Andriod版本内容开发及Html5技术实践）
    V1.0.2：
    1.基于分析模型的参考结论（9月）
    2.增加twitter第三方应用（9月）
 
####7.2 推广计划：
 
 1.实现AWS发布、Salesforce的exchange发布、AppStore发布（8月）
 2.完成官网V1.0开发和推广（8月）
 3.线下客户推广（9月）


#### 7.2 任务分配
```
andys: 
	移动app 
    ios 
    android
    html5 chart
    社交与CRM
    app上线发布
```
```
yy: 
	connector
	社交与CRM
	代码完善、重构
	与算法模型配合
	与portal接口（oauth) 
	salesforce exchange 上线发布
```
```
lu： 
	AdminPortal
	UserPortal
	html5 chart
	内、外部交互接口 
	数据模型
```
```
tom：
	测试设计 
	测试 
	部署（开发、生产）
```

```
sam:
	系统架构
	新系统 MMS
	协调、介入各模块
```


