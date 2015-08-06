#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# Copyright (c) 2015 51desk.cn. All rights reserved.
#
# @author: ChenXiao <chen.xiao@eisoo.com>
# Created on 30, June, 2015
#

from __future__ import absolute_import, unicode_literals

import os, sys

import tornado.httpserver
import tornado.ioloop
import tornado.options
import tornado.web
from tornado.escape import url_unescape, json_encode
import json

ACS_PATH=os.path.abspath(os.path.dirname(__file__))
sys.path.append(ACS_PATH)

from analyzers import mongoconn, factory, getOverlaps, obj2json, parseSubType
from resultmgr import handleResults


#############################################################################
#
# variables and parameters
#
from tornado.options import define, options
# define("port", default=12345, help="run on the given port", type=int)
define("debug", default=False, help="enable debug mode", type=bool)

_CONFIG_FILE_PATH = os.path.join(
    ACS_PATH,
    'configs',
    'config.json')

_APP_CONFIG = json.load(open(_CONFIG_FILE_PATH, 'r'))

class AppPlatformType:
    """
    应用类型
    """
    Salesforce = 1
    Desk = 2

#############################################################################
#
# Functions
#
def handler_decorator(method):
    def wrapper(*args, **kwargs):
        try:
            obj = method(*args, **kwargs)

            if obj is not None:
                if isinstance(obj, basestring):
                    args[0].write(obj)
                else:
                    obj['status'] = 0
                    args[0].write(obj2json(obj))

        except tornado.web.HTTPError:
            raise
        except Exception as e:
            error = {
                'status': 1,
                'errcode': 1,
                'errmsg': e.message
            }
            args[0].write(json_encode(error))
    return wrapper

#############################################################################
#
# handlers
#
class analysisHandler(tornado.web.RequestHandler):
    """ handlers of analysis server"""
    @handler_decorator
    def get(self, arg):
        """ handle get method

            args:
                arg: model typ to analyze

            return:
                json doc of analysis result
        """
        # Parse & create parameters
        modelType = arg

        #
        # 数据库连接
        # todo: 放到 analyzer 中
        conn = mongoconn.mongoConnection (
            _APP_CONFIG['mongo']['ip'],
            _APP_CONFIG['mongo']['port'],
            _APP_CONFIG['mongo']['db']
        )

        # 分析平台用户
        def _parseUserIDs(id_str):
            users = id_str.split(',')

            userParam = {}
            for user in users:
                user_attr = user.split(':')

                if len(user_attr) != 2:
                    raise Exception('User account must go along with a platform')

                if int(user_attr[0]) == AppPlatformType.Salesforce:
                    userParam['salesforce'] = user_attr[1]
                elif int(user_attr[0]) == AppPlatformType.Desk:
                    userParam['desk'] = user_attr[1]

            return userParam
        
        print 'app_accts: %s' % self.get_argument('app_accts', '')
        users = _parseUserIDs(self.get_argument('app_accts', ''))
        print 'users: %s' % users

        start_date = self.get_argument('start_time', '')
        print 'start_date: %s' % start_date

        end_date =self.get_argument('end_time', '')
        print 'start_date: %s' % start_date

        ''' params
            {
                'db_conn': conn,
                'start_date': 1433648804, #'2015-01-01', # 1420070400
                'end_date': 1436240804, #'2015-07-01', # 1435708800
                'apps': {
                    'salesforce': {
                        'user_id': '00528000000ImzzAAC',
                        'batch_id': 'yASCUj'
                    },
                    'desk': {
                        'user_id': '24509826@qq.com',
                        'batch_id': '8W749R'
                    }
                }
            }
        '''
        analysisParams = {
            'db_conn': conn,
            'start_date': int(start_date), # 时间的 s 数 
            'end_date': int(end_date), # 1435680000
            'user_id': self.get_argument('user_acct', ''),
            'apps': {
                'salesforce': {
                    'user_id': users['salesforce'] # 00528000000JXbtAAG
                },
                'desk': {
                    'user_id': users['desk'] # 24509826@qq.com
                }
            }
        }

        print '--------------------- analysis params --------------------------'
        print analysisParams

        #
        # 接口中定义的 subtype 是通过掩码的方式传递，所以通过按位操作分析出来的
        #
        subtypes = parseSubType (modelType, int(self.get_argument('subtype', '5'))) # 5 means 0x101
        
        resultParams = {
            'db_conn': conn,
            'apps': subtypes,
            'time_granule': self.get_argument('time_granule', 'day'),
            'start_date': int(start_date),
            'end_date': int(end_date),
        }

        print '--------------------- analysis params --------------------------'
        print resultParams

        analyzer = factory.createAnalyzer (modelType, analysisParams)
        res = analyzer.doAnalysis()

        # 这里用 return，输出工作由 decorater 来做
        return handleResults(modelType, res, resultParams)


if __name__ == "__main__":
    """ main """
    tornado.options.parse_command_line()

    # load config file

    app = tornado.web.Application(
        handlers=[(r"/WEBAPI/acs/data/analysis/(\w+)", analysisHandler)],
        debug=options.debug
    )

    http_server = tornado.httpserver.HTTPServer(app)
    http_server.listen(_APP_CONFIG['listen'])
    tornado.ioloop.IOLoop.instance().start()
