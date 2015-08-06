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
from analyzers import baseAnalyzer, baseWorker, getOverlaps, getSubTypeID

from analyzers.time_tools import SECONDS_IN_TIME, TZ_OFFSET, getWeekDay, getMonth, getYear, \
                                 timestamp2str, str2timestamp, getDateStamp, makeLocalTimestamp, \
                                 getQuarterStartMon, getLocalTimestampFromDate, getStartDatePoint


TIME_GRANULE = ['day', 'week', 'month', 'quarter']


def handleResults(modelType, res, params):
    """ Handle results according to the params

        args:
            res: dict of results
            params: params to handle the results

            example:
                resultParams = {
                    'db_conn': conn, # not used
                    'time_granule': day,
                    'start_date': start_date,
                    'end_date': end_date
                    'apps': {
                        'salesforce': ['sec_op'],
                        'desk': ['serv_count', 'serv_dura']
                    }
                }

        return:
            new results
    """
    # parse params
    print ('Handling results...')

    granule = params['time_granule']
    if granule not in TIME_GRANULE:
        raise Exception ('Time granule is not supported!')

    # 组成新结果
    new_result = {
        'biz_model': modelType,
        'subtypes': dict(),
        'time_granule': granule
    }

    for k, v in params['apps'].items():
        for sub in v:
            new_result['subtypes'][sub] = getSubTypeID(modelType, sub)

    def handleResultByDays(res, subtype, start, end, granule):
        """ Get the data of the last week of which the last day is end
            data of 7 days is needed

            args:
                res: results to handle
                start: begin date in seconds
                end: end date in seconds

            return:
                new results
        """

        # 返回的结果:
        # {
        #    'biz_model': 'satisfaction',
        #    'subtypes': {'serv_count': 4, 'serv_dura': 16, 'sec_op': 1}
        #    'time_granule': 'week',
        #    1:{
        #        'total': 30,
        #        'key': [
        #            1433116800,
        #            ...
        #        ],
        #        'value': [
        #            7,
        #            ...
        #        ],
        #        'size': 6
        #    }，
        #    4:{
        #        ...
        #    }
        # }
        #
        handledRes = {'total': 0, 'key': list(), 'value': list()}

        if start > end:
            pass

        # 转化开始时间和结束时间，把时间的 timestamp 全部转为 00:00:00
        realStart = getDateStamp(str2timestamp(params['start_date']))
        realEnd = getDateStamp(str2timestamp(params['end_date']))

        realStart = getStartDatePoint(realStart, granule)

        # 在不连续的结果中填充数据
        def fillData(start, end, granule, handler=None):
            """ Fill the time gap between 'start' and 'end', and handle
                the date number by handler
            """
            if handler is None:
                handler = lambda x: x

            if start > end:
                pass

            fillDate = start
            while fillDate <= end:
                handledRes['key'].append(handler(fillDate))
                handledRes['value'].append(0)

                if granule in ['day', 'week']:
                    fillDate += SECONDS_IN_TIME[granule]
                else:
                    fillDate = getStartDatePoint(fillDate, granule, 1)

        # [{u'_id': 1428624000.0, u'value': 23.0}, {u'_id': 1433980800.0, u'value': 1.0}]
        # 或者
        # [{u'_id': 1434412800.0, u'value': {u'count': 1.0, u'rating': 4.0, u'dura': 124502400.0}}]
        def handleCount(handler = None):
            lastAdd, curKey, curData = 0, 0, 0

            if handler is None:
                handler = lambda val: (int(val['_id']), int(val['value']))

            for record in res:
                key, value = handler(record)

                if realStart <= key <= realEnd:
                    # 在开始和结束之间的时间，肯定又用的，需要做处理
                    # 先算出 key 值
                    key2Add = getStartDatePoint(key, granule)

                    if key2Add > curKey:
                        # 出现了一个新 key，把上一个添加到结果中，初始化新的数据点
                        if not curKey == 0:
                            if lastAdd == 0:
                                # 第一次添加，填充这个时期之前的所有时间，如果时间范围不满足填充条件，则不会填充
                                fillData (realStart,
                                          getStartDatePoint(curKey, granule, -1),
                                          granule)
                            else:
                                # 如果当前的时间点和上一次添加的时间点之间有一个以上的空隙则需要填充
                                fillData(getStartDatePoint(lastAdd, granule, 1),
                                         getStartDatePoint(curKey, granule, -1),
                                         granule)

                            handledRes['total'] += curData
                            handledRes['key'].append(curKey)
                            handledRes['value'].append(curData)

                            lastAdd = curKey

                        curKey, curData = key2Add, value

                    else:
                        curData += value

            # 跳出循环，在后面补充 0
            if lastAdd == 0:
                # 一次也没有添加过，但是要处理最后一次的数据
                if curKey > 0:
                    fillData(realStart, getStartDatePoint(curKey, granule, -1), granule)

                    handledRes['total'] += curData
                    handledRes['key'].append(curKey)
                    handledRes['value'].append(curData)
                else:
                    fillData(realStart, realEnd, granule)
            elif end > lastAdd:
                if curKey <> lastAdd:
                    handledRes['total'] += curData
                    handledRes['key'].append(curKey)
                    handledRes['value'].append(curData)
                    lastAdd = curKey

                fillData(getStartDatePoint(lastAdd, granule, 1), realEnd, granule)

            handledRes['size'] = len(handledRes['key'])


        def handleMean(handler = None):
            lastAdd, totalCount, curKey, curData, curCount = 0, 0, 0, 0, 0

            if handler is None:
                handler = lambda val: \
                    (int(val['_id']), int(val['value']), int(val['count']))

            for record in res:
                key, value, count = handler(record)

                if realStart <= key <= realEnd:
                    # 在开始和结束之间的时间，肯定又用的，需要做处理
                    # 先算出 key 值
                    key2Add = getStartDatePoint(key, granule)

                    if key2Add > curKey:
                        # 出现了一个新 key，把上一个添加到结果中，初始化新的数据点
                        if not curKey == 0:
                            if lastAdd == 0:
                                # 第一次添加，填充这个时期之前的所有时间，如果时间范围不满足填充条件，则不会填充
                                fillData (realStart,
                                          getStartDatePoint(curKey, granule, -1),
                                          granule)
                            else:
                                # 如果当前的时间点和上一次添加的时间点之间有一个以上的空隙则需要填充
                                fillData(getStartDatePoint(lastAdd, granule, 1),
                                         getStartDatePoint(curKey, granule, -1),
                                         granule)

                            handledRes['total'] += curData
                            handledRes['key'].append(curKey)
                            handledRes['value'].append(round(curData / curCount, 1))
                            totalCount += curCount

                            lastAdd = curKey

                        # 新的 key，需要初始化
                        curKey = key2Add
                        curData = value
                        curCount = count

                    else:
                        curData += value
                        curCount += count

            # 跳出循环，在后面补充 0
            if lastAdd == 0:
                # 一次也没有添加过
                if curKey > 0:
                    fillData(realStart, getStartDatePoint(curKey, granule, -1), granule)

                    handledRes['total'] += curData
                    handledRes['key'].append(curKey)
                    handledRes['value'].append(round(curData / curCount, 1))
                    totalCount += curCount
                else:
                    fillData(realStart, realEnd, granule)
            elif end > lastAdd:
                if curKey <> lastAdd:
                    handledRes['total'] += curData
                    handledRes['key'].append(curKey)
                    handledRes['value'].append(round(curData / curCount, 1))
                    totalCount += curCount

                    lastAdd = curKey

                fillData(getStartDatePoint(lastAdd, granule, 1), realEnd, granule)

            handledRes['total'] = round((handledRes['total'] / (1 if totalCount == 0 else totalCount)), 1)
            handledRes['size'] = len(handledRes['key'])

        # desk 结果的结构，三个结果在一起:
        # 而且所有的数字都被处理成了 float
        # results:[
        #   {
        #       '_id': 1433635200。0,
        #       'value': {'count': 1。0, 'rating': 4。0, dura: 123724800.0}
        #   },
        #   ...
        #]
        kvHandler = None
        if subtype =='serv_count':
            kvHandler = lambda val : (int(val['_id']), int(val['value']['count']))
        elif subtype == 'serv_dura':
            kvHandler = lambda val : (int(val['_id']), int(val['value']['dura']), int(val['value']['count']))
        elif subtype == 'serv_rating':
            kvHandler = lambda val : (int(val['_id']), val['value']['rating'], int(val['value']['count']))

        # 开始处理数据
        if subtype in ['sec_op', 'serv_count']:
            handleCount(kvHandler)

        if subtype in ['serv_dura', 'serv_rating']:
            handleMean(kvHandler)

        new_result[getSubTypeID(modelType, subtype)] = handledRes
        print('subtype: %s, key len: %d, value len: %d' % (subtype, len(handledRes['key']), len(handledRes['value'])))

        #for res in handledRes['key']:
        #    print(timestamp2str(res))


    # 在结果中指需要取 start 以后的数据，当前是数据结果都是按天算的
    # 没有带时间，所以如果存在的话能够匹配到
    for k, v in params['apps'].items():
        for sub in v:
            handleResultByDays(res[k]['results'], sub,
                               str2timestamp(params['start_date']),
                               str2timestamp(params['end_date']),
                               granule)

    print ('------------ %f ------------' % time.clock())
    print ('Done!')

    return new_result