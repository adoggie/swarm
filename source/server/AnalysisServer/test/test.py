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

ACS_PATH=os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
sys.path.append(ACS_PATH)

from analyzers import mongoconn, factory, getOverlaps, parseSubType
from resultmgr import handleResults


if __name__ == "__main__":
    
    try:
        lista = ['11', '22', '33', '44']
        listb = ['11', '22', '33']
        listc = ['11', '22']

        getOverlaps (lista, listb, listc) 

        print lista

        conn = mongoconn.mongoConnection ('127.0.0.1', 27017, 'test')
        analyzer = factory.createAnalyzer (
            'satisfaction',
            {
                'db_conn': conn,
                'start_date': '2014-01-01', # 1420070400
                'end_date': '2015-07-01', # 1435708800
                'apps': {
                    'salesforce': {
                        'user_id': '00000000000051TEST', # '00528000000ImzzAAC',
                        #'batch_id': 'yASCUj'
                    },
                    'desk': {
                        'user_id': 'test@desk.cn', #'24509826@qq.com',
                        #'batch_id': '8W749R'
                    }
                }
            }
        )

        # 测试整个 analyzer
        params = analyzer.getParams()
        print params
        workers = analyzer.getWorkers()
        print workers

        results = analyzer.doAnalysis()

        print parseSubType ('satisfaction', 5)
        resultParams = {
            'db_conn': conn,
            'time_granule': 'day',
            'start_date': 1433667996, # 1420070400, 1433648804
            'end_date' : 1436259996, # 1435708800, 1436240804
            'apps': {
                'salesforce': ['sec_op'],
                'desk': ['serv_count', 'serv_dura', 'serv_rating']
            }
        }

        print handleResults('satisfaction', results, resultParams)
        #for res in results:
        #    print results[res]

        # 分别测试子 Analyzer
        #res = workers['sec_op'].doAnalysis(params)
        #print res

        #res = workers['serv_count'].doAnalysis(params)
        #print res

    except Exception, e:
        print (e)
