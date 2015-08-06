#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# Copyright (c) 2015 51desk.cn. All rights reserved.
#
# @author: ChenXiao <chen.xiao@eisoo.com>
# Created on 30, June, 2015
#

from __future__ import absolute_import, unicode_literals

import os, sys, datetime, time, json

#############################################################################
#
# Variables
#
G_ANALYZER_LIST = {
    'satisfaction' : [    # Simple module of client satisfaction
        {
            'analyzer': 'salesforce',
            'results': [                # subtype of analyzer
                ('sec_op', 0x1),             # result: Second opportunity of sales
                #('sales_rev', 0x02),        # Sales revenue
            ]
        },
        {
            'analyzer': 'desk',
            'results':[
                ('serv_count', 0x04),        # Count of services
                ('serv_rating', 0x08),       # Service rating
                ('serv_dura', 0x10)         # Service duration
            ]
        }
    ]
}


#############################################################################
#
# Functions
#
def parseSubType(modelType, value):
    if not isinstance(value, int) or not modelType in G_ANALYZER_LIST:
        return subtypes

    subtypes = {}

    for sub in G_ANALYZER_LIST[modelType]:
        res_types = []
        for res_type in sub['results']:
            if value & res_type[1]:
                res_types.append(res_type[0])

        if not len(res_types) == 0:
            subtypes[sub['analyzer']] = res_types

    return subtypes

def getSubTypeID(modelType, subtype):
    subtypeId = 0
    if not modelType in G_ANALYZER_LIST:
        return subtypeId

    for sub in G_ANALYZER_LIST[modelType]:
        for res_type in sub['results']:
            if subtype == res_type[0]:
                subtypeId = res_type[1]
                break

    return subtypeId

def getOverlaps(target, *args):
    """ Get the overlaps of the lists

        args:
            list: target list
            args: more lists
    """
    if not isinstance(target, list):
        return target

    for li in args:
        if not isinstance(li, list):
            return target

    cur = 0
    
    while cur < len(target):
        isOverlap = False
        for li in args:
            if target[cur] not in li:
                isOverlap = False
            else:
                isOverlap = True

        if not isOverlap:
            del target[cur]
        else:
            cur += 1


def obj2json(obj, sort_keys=True, indent=2):
    try:
        return json.dumps(obj, ensure_ascii=False, sort_keys=sort_keys,
                          indent=indent)
    except TypeError:
        return json.dumps(obj, default=obj2dict, ensure_ascii=False,
                          sort_keys=sort_keys, indent=indent)


#############################################################################
#
# classes
#
class baseWorker(object):
    """ Each Analyzer should be composed of several workers"""
    def __init__(self, model_name, subtype):
        self.model_name = model_name,
        self.subtype = subtype
        self.result = {}

    def doAnalysis(params):
        raise Exception ('I am the super class!')

    def makeResults(self, batch_id, user_id, results):
        self.result = {
            'model_name': self.model_name,
            'subtype': self.subtype,
            'batch_id': batch_id,
            'user_id': user_id,
            'up_time': time.mktime(time.localtime()),
            'tz': time.timezone,
            'results': results
        }

        return self.result

class baseAnalyzer(object):
    """ Base class of Analyzer"""
    def __init__(self, model_type, params):
        
        self.model_type = model_type
        self.params = params
        self.workers = {}
        self.results = {}

    def doAnalysis (self):
        """ This method must be implemented by subclasses"""
        raise Exception ('I am the super class!')

    def getParams (self):
        """ Retrive parameter of analysis"""
        return self.params

    def setworkers (self, workers):
        """ Set subanaliyzer (workers)

            args:
                workers: dict of workers 
                    {
                        'worker_name' : object
                    }

        """
        self.workers = workers

    def getWorker (self, name):
        """ Retrive worker object

            args:
                name: name of worker
        """

        return self.workers[name]

    def getWorkers (self):
        """ Retrive all the workers"""
        return self.workers

