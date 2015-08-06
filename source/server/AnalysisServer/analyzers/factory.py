#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# Copyright (c) 2015 51desk.cn. All rights reserved.
#
# @author: ChenXiao <chen.xiao@eisoo.com>
# Created on 30, June, 2015
#
import analyzers
import importlib

# 根据配置 import 分析器
libs = {}
for az in analyzers.G_ANALYZER_LIST:
    libs[az] = importlib.import_module ('analyzers.' + az)

#
# 想用单例，但是好像也无所谓
#
"""
class analyzerFactory(object):
    AnalyzerFactora is a singleton to create specified analyzer
    def __init__(self):
        self.__inst = Null

    def instance():
        if self.__inst:
            __inst = analyzerFactory()

        return __inst
"""


def createAnalyzer (model_type, params):
    """ Create a specified analyzer

        args:
            model_type: type of analysis model
            params: params of analysis

        return:
            analyzer
    """
    if not libs.has_key (model_type):
        raise Exception ('Unkown model type!')

    # instantiate the analyzer by class name
    analyzerType = getattr (libs[model_type], model_type)

    az = analyzerType(params)
    
    # create sub analyzer
    workers = {}
    for worker in analyzers.G_ANALYZER_LIST[model_type]:
        print worker
        workerName = worker['analyzer']
        workers[workerName] = getattr(libs[model_type], workerName)(model_type, workerName)

    az.setworkers (workers)

    return az
