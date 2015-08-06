#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# Copyright (c) 2015 51desk.cn. All rights reserved.
#
# @author: ChenXiao <chen.xiao@eisoo.com>
# Created on 3, July, 2015
#

from __future__ import absolute_import, unicode_literals

import os, sys, time
from analyzers import baseAnalyzer, baseWorker, getOverlaps

from analyzers.time_tools import timestamp2str

TIME_GRANULE = ['day', 'week', 'month', 'quarter']

def handleResults(res, params):
    """ Handle results according to the params

        args:
            res: dict of results
            params: params to handle the results

            example:
                resultParams = {
                    'db_conn': conn, # not used
                    'sub_types': [type1, type2],
                    'time_granule': week
                }

        return:
            new results
    """
    # parse params
    if params['time_granule'] not in TIME_GRANULE:
        raise Exception ('Time granule is not suppored!')
    
    for sub in params['sub_types']:
        if sub not in res:
            raise Exception ('Sub type dose not exists in results!')

    return res