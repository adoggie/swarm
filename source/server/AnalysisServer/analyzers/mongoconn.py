#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# Copyright (c) 2015 51desk.cn. All rights reserved.
#
# @author: ChenXiao <chen.xiao@eisoo.com>
# Created on 31, June, 2015
#

import pymongo

class mongoConnection(object):
    """Connection of mongodb"""
    def __init__(self, host='localhost', port=27017, defaultDB='test'):
        self.addr = 'mongodb://%s:%d/' % (host, port)
        self.conn = None
        self.defaultDB = defaultDB

    def getConn(self):
        """Retrieve Connection of mongodb"""

        if not self.conn:
            self.conn = pymongo.MongoClient(self.addr)
        
        return self.conn

    def getDB(self, name='None'):
        if not name:
            return self.getConn()[name]
        return self.getConn()[self.defaultDB]

if __name__ == '__main__':
    import time

    print time.clock()
    conn = mongoConnection ('192.168.36.83', 27017)
    print time.clock()
    db = conn.getConn()
    clients = db['test']['desk_case'].distinct('company',{'company':{'$exists':True}})
    print clients

    print time.clock()
    cur = db.test.sf_opportunity.find({'Account.Name':{'$exists':True},}, {'Account.Name':1, '_id':0})
    cur = db.test.sf_opportunity.find(
        {
            'Account.Name': {
                '$exists':True,
                '$in':[clients]
            }
        },
        {'Account.Name':1, '_id':0}
    )

    for op in cur:
        print op

    print time.clock ()