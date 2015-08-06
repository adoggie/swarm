#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# Copyright (c) 2015 51desk.cn. All rights reserved.
#
# @author: ChenXiao <chen.xiao@eisoo.com>
# Created on 30, June, 2015
#

from __future__ import absolute_import, unicode_literals

import os, sys, time, pymongo, re
from analyzers import baseAnalyzer, baseWorker, getOverlaps
from bson.code import Code

from analyzers.time_tools import timestamp2str


# 分析器名称
ANALYZER_NAME = 'satisfaction'

# 数据库和 collection 的名称
SEC_OP_COL = 'sf_opportunity'
DESK_CASE_COL = 'desk_case'

##############################################################################
# 
# functions
#
def _getClients(dbconn, sf_param, desk_param):
    """ Get clients in both desk and sf
        args:
            dbconn: mongodb collection
            sfUser: user id of sales force
            deskUser: user id of desk
        return:
            a list of clients

    """
    # 先从 desk 中获取对应的客户信息
    desk_clients = dbconn[DESK_CASE_COL].distinct(
        'company',
        {
            'company': {'$exists':True},
            'fx_desk_userid': desk_param['user_id'],
            'fx_batch_id': desk_param['batch_id']
        }
    )

    # 再从 sf 中取用户信息
    sf_clients = dbconn[SEC_OP_COL].distinct(
        'Account.Name',
        {
            'Account.Name': {'$exists':True},
            'fx_sf_userid': sf_param['user_id'],
            'fx_batch_id': sf_param['batch_id']
        }
    )

    getOverlaps(desk_clients, sf_clients)

    return desk_clients


def _getBatchID(dbcollection, dateStr=None):
    """ Get batch id of data retrieving for analysis

        args:
            dbconn: db connection of mongodb
            dateStr: get the retrieve id for the date, default: the newest

        return:
            batch id
    """
    # todo, implement the retrieving of dateStr
    if dateStr:
        return ''

    search_key = {}
    disp_key = {'fx_batch_id':1, '_id': 0}
    sort_key = [('fx_batch_time', pymongo.DESCENDING)]

    res = dbcollection.find(search_key, disp_key) \
        .limit(1).sort(sort_key)

    if res.count() > 0:
        return res[0]['fx_batch_id']

    return ''


def _createSFQueryParam(params):
    """ Get clients in both desk and sf

        args:
            params: worker params
            clients: id of clients to query

        return:
            query doc & filter doc
    """
    # 查询指定时间的数据
    search_param = {
        'Account.Name': {
            '$exists': True,
            '$in':params['clients']
        },
        'CreatedDate' : {
            '$gte': timestamp2str(params['start_date']),
            '$lte': timestamp2str(params['end_date'])
        },
        'Type' : {'$ne': 'New Customer'},
        'IsDeleted' : {'$in': [False, re.compile('false', re.IGNORECASE)]},
        'fx_sf_userid': params['apps']['salesforce']['user_id'],
        'fx_batch_id': params['apps']['salesforce']['batch_id']
    }

    # 只获取需要的内容
    filter_param =  {
        'Account.Name': 1,
        'CreatedDate': 1,
        '_id':0
    }

    return search_param, filter_param


def _createDeskQueryParam(params):
    """ Get clients in both desk and sf

        args:
            params: worker params

        return:
            query doc & filter doc
    """
    # 查询指定时间的数据
    search_param = {
        'company': {
            '$exists': True,
            '$in':params['clients']
        },
        'status': 'resolved',
        'resolved_at' : {
            '$ne': 'null',
            '$gte': timestamp2str(params['start_date']),
            '$lte': timestamp2str(params['end_date']),
        },
        'fx_desk_userid': params['apps']['desk']['user_id'],
        'fx_batch_id': params['apps']['desk']['batch_id']
    }

    # 只需时间和客户两个字段
    filter_param =  {
        'company': 1,
        'resolved_at': 1,
        'created_at': 1,
        'rating': 1,
        '_id':0
    }

    return search_param, filter_param


##############################################################################
# 
# classes
#
class satisfaction(baseAnalyzer):
    """ analyzer of simple module of client satisfaction"""
    def __init__(self, params):
        super(satisfaction, self).__init__(ANALYZER_NAME, params)

        """ params are like this:
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
        """

    def doAnalysis (self):
        """ This method must be implemented by subclasses"""
        print ('I am doing Analysis...')

        # todo 检查参数

        #
        # 找到对应的客户信息，只保留两个系统都存在的账号
        # 这样的话不需要所用的分析器都去查询一遍
        #
        conn = self.params['db_conn'].getDB()

        # 获取批次id
        if not self.params['apps']['salesforce'].has_key('batch_id'):
            self.params['apps']['salesforce']['batch_id'] = \
                _getBatchID(conn[SEC_OP_COL])

        if not self.params['apps']['desk'].has_key('batch_id'):
            self.params['apps']['desk']['batch_id'] = \
                _getBatchID(conn[DESK_CASE_COL])

        # 去掉重复的用户，并作为新的分析参数传给 worker
        self.params['clients'] = _getClients (
                                    conn,
                                    self.params['apps']['salesforce'],
                                    self.params['apps']['desk']
                                 )

        workers = self.getWorkers ()
        for worker in workers:
            if worker in self.params['apps']:
                self.results[worker] = workers[worker].doAnalysis(self.params)

        print ('Done!')
        return self.results


class salesforce(baseWorker):
    """ worker of second opportunity"""
    def __init__(self, model_name, subtype):
        super(salesforce, self).__init__(model_name, subtype)

    def doAnalysis(self, params):
        """ do analysis

            args:
                params: params of analysis
        """
        #
        # MAP REDUCE
        # 返回结果为:
        #
        # {"_id" : 1433980800, "value" : 1}
        #
        # JS 处理日期精确到毫秒，而 Python 是在小数点后表示毫秒
        #
        mapper = Code ("""
            function () {
                array = this.CreatedDate.split('T');
                
                var date = Date.parse(array[0])/1000;
                emit (date, 1);
            }
        """)

        reducer = Code ("""
            function (key, values) {
                var sum = 0;
                values.forEach(function(doc) {
                    sum += doc;
                })
                return sum;
            }
        """)

        # 构造查询参数
        search_param, filter_param = _createSFQueryParam(params)

        conn = params['db_conn'].getDB()
        #cur = conn[SEC_OP_COL].find(search_param, filter_param)

        print ('------------ %f ------------' % time.clock())

        # 这里加上 scope 和 sort 反而更慢
        result = conn[SEC_OP_COL].map_reduce(
            mapper,
            reducer,
            out = {'inline': 1},
            query = search_param)
            #scope = filter_param,
            #sort = {'CreatedDate': -1}) 
        
        print ('salesforce: %s' % search_param)
        print ('salesforce: %s' % result)
        print ('------------ %f ------------' % time.clock())


        return self.makeResults(search_param['fx_batch_id'],
                                search_param['fx_sf_userid'],
                                result['results'])


class desk(baseWorker):
    """ Worker of service duration"""
    def __init__(self, model_name, subtype):
        super(desk, self).__init__(model_name, subtype)


    def doAnalysis(self, params):
        """ do analysis

            args:
                params: params of analysis
        """
        #
        # MAP REDUCE
        # 返回结果为:
        #
        # {
        #    "_id" : 1435617797,
        #    "value" : {
        #            "mean" : 727692,
        #            "count" : 2
        #    }
        # }
        #
        # JS 处理日期精确到 ms，而 Python 是在小数点后表示 ms，所以统一处理成 python
        # 平均值也是 s
        #
        mapper = Code("""
            function () {
                var getDateVal = function (dateStr) {
                    dateStr = dateStr.replace(/\D$/, '');
                    dateStr = dateStr.replace('T', ' ');
                    return dateStr;
                };

                openStr = getDateVal (this.created_at);
                resolvedStr = getDateVal (this.resolved_at);

                open = Date.parse(openStr);
                resolved = Date.parse(resolvedStr);
                resolvedDate = Date.parse(resolvedStr.split(' ')[0])/1000;

                var dura = (resolved - open) / 1000 / 3600;

                if (dura < 0 || isNaN(dura))
                    dura = 0;

                if (isNaN(this.rating))
                    rating = 3;
                else
                    rating = this.rating;

                emit (resolvedDate, {dura: dura, rating: rating, count:1});
            }
        """)

        #
        # mongodb 应该是分步处理 reduce 的，如果分的次数比较多，它会将上一次 reduce 的结果放到下一次的
        # reduce 中，如果是数值，这样做是没事的，但是如果是对象，且和 emit 出来的结构不一致，就会出现错误
        # 要么增加判断，要么在 finalize 中处理
        reducer = Code ("""
            function (key, values) {
                res = {dura: 0, rating:0, count: 0};

                values.forEach(function(doc) {
                    res.dura += doc.dura;
                    res.rating += doc.rating
                    res.count += doc.count
                });

                return res;
            };
        """)

        finalizer = Code ("""
            function (key, result) {
                res = {dura_mean: 0, rating_mean: 0, count: result.count};
                res.dura_mean = (result.dura / res.count).toFixed(0);
                res.rating_mean = (result.rating / res.count).toFixed(0);

                return res
            };
        """)



        # 构造查询参数
        search_param, filter_param = _createDeskQueryParam (params)

        conn = params['db_conn'].getDB()
        # cur = conn[DESK_CASE_COL].find(search_param, filter_param)

        print ('------------ %f ------------' % time.clock())
        result = conn[DESK_CASE_COL].map_reduce(
            mapper,
            reducer,
            out = {'inline': 1},
            query = search_param)
            #finalize = finalizer,
            #scope = filter_param,
            #sort = {'resolved_at': -1})

        print ('serv_dura: %s' % result)
        print ('------------ %f ------------' % time.clock())

        return self.makeResults(search_param['fx_batch_id'],
                           search_param['fx_desk_userid'],
                           result['results'])
