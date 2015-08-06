FROM centos:6.6
#FROM test3

#ENTRYPOINT  echo "Welcom centos OS"
# yumdownloader make you happy!!!
#

ENV DOCKER http://192.168.36.83:8080/share/linux/docker
RUN mkdir /cache ; cd /cache 
RUN mkdir /etc/yum.repos.d/back; mv /etc/yum.repos.d/*.repo /etc/yum.repos.d/back
ADD scott-bin.repo /etc/yum.repos.d/
RUN yum install -y gcc wget vim fuse-sshfs nfs-utils rpcbind
RUN rpm -ivh $DOCKER/epel-release-6-8.noarch.rpm

RUN rpm -ivh $DOCKER/python-setuptools-0.6.10-3.el6.noarch.rpm
RUN rpm -ivh $DOCKER/python-pip-1.3.1-4.el6.noarch.rpm
RUN yum --disablerepo=\* --enablerepo=c6-media install -y python-devel 
RUN yum --disablerepo=\* --enablerepo=c6-media install -y postgresql-devel php-cgi php-pgsql tar

RUN cd /cache ; wget $DOCKER/python/pycrypto-2.6.tar.gz ; tar xvzf pycrypto-2.6.tar.gz ; cd pycrypto-2.6; python setup.py install; 

RUN cd /cache ; wget $DOCKER/python/gevent-1.0.tar.gz ; tar xvzf gevent-1.0.tar.gz ; cd gevent-1.0; python setup.py install; 

RUN cd /cache ; wget $DOCKER/python/psycopg2-2.5.tar.gz ; tar xvzf psycopg2-2.5.tar.gz ; cd psycopg2-2.5; python setup.py install; 

#RUN cd /cache ; wget $DOCKER/python/Django-1.6.5.tar.gz ; tar xvzf Django-1.6.5.tar.gz ; cd Django-1.6.5; python setup.py install; 
RUN cd /cache ; wget $DOCKER/python/gevent-psycopg2-0.0.3.tar.gz ; tar xvzf gevent-psycopg2-0.0.3.tar.gz ; cd gevent-psycopg2-0.0.3; python setup.py install; 
RUN cd /cache ; wget $DOCKER/python/gevent-websocket-0.9.3.tar.gz ; tar xvzf gevent-websocket-0.9.3.tar.gz ; cd gevent-websocket-0.9.3; python setup.py install; 

RUN cd /cache ; wget $DOCKER/python/django-rest-framework-master.tar.gz ; tar xvzf django-rest-framework-master.tar.gz ; cd django-rest-framework-master; python setup.py install; 






RUN cd /cache ; wget $DOCKER/python/psycogreen-1.0.tar.gz ; tar xvzf psycogreen-1.0.tar.gz ; cd psycogreen-1.0; python setup.py install; 


RUN cd /cache ; wget $DOCKER/python/pymongo-2.6.3.tar.gz ; tar xvzf pymongo-2.6.3.tar.gz ; cd pymongo-2.6.3; python setup.py install; 
RUN cd /cache ; wget $DOCKER/python/PyYAML-3.11.tar.gz ; tar xvzf PyYAML-3.11.tar.gz ; cd PyYAML-3.11; python setup.py install; 
RUN cd /cache ; wget $DOCKER/python/qpid-python-0.28.tar.gz ; tar xvzf qpid-python-0.28.tar.gz ; cd qpid-python-0.28; python setup.py install; 

RUN cd /cache ; wget $DOCKER/python/qpid-tools-0.28.tar.gz ; tar xvzf qpid-tools-0.28.tar.gz ; cd qpid-tools-0.28; python setup.py install; 

RUN cd /cache ; wget $DOCKER/python/redis-2.9.1.tar.gz ; tar xvzf redis-2.9.1.tar.gz ; cd redis-2.9.1; python setup.py install; 

RUN cd /cache ; wget $DOCKER/python/xlrd-0.9.3.tar.gz ; tar xvzf xlrd-0.9.3.tar.gz ; cd xlrd-0.9.3; python setup.py install; 

RUN cd /cache ; wget $DOCKER/python/xlwt-0.7.5.tar.gz ; tar xvzf xlwt-0.7.5.tar.gz ; cd xlwt-0.7.5; python setup.py install; 




CMD ["/bin/bash"]


