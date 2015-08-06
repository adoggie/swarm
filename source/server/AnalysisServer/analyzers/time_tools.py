#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# Copyright (c) 2015 51desk.cn. All rights reserved.
#
# @author: ChenXiao <chen.xiao@eisoo.com>
# Created on 7, July, 2015
#

# 注意，这里都是按照 localtime 处理！！

from __future__ import absolute_import, unicode_literals
import os, sys, datetime, time, json


SECONDS_IN_TIME = {
    'day': 86400, # 24 * 3600
    'week': 604800, # 7 * 24 * 3600
    'month': 2592000 # 30 * 24 * 3600
}

TZ_OFFSET = time.timezone


def getWeek(timestamp):
    week = time.strftime('%W', time.localtime(timestamp))
    return int(week)


def getWeekDay(timestamp):
    return time.localtime(timestamp).tm_wday


def getMonth(timestamp):
    return time.localtime(timestamp).tm_mon


def getYear(timestamp):
    return time.localtime(timestamp).tm_year


def timestamp2str (num, format = '%Y-%m-%d'):
    """ Convert timestamp to string

        args:
            num: time to Convert
            format: the string format

        return:
            if num is not number, return original value
            if not, convert
    """
    if not isinstance (num, (int, float)):
        return num

    ltime=time.localtime(num)
    return time.strftime(format, ltime)


def str2timestamp(timeStr, format='%Y-%m-%d %H:%M:%S', needUTCOffset=True):
    """ Convert string to timestamp

        args:
            str: string to Convert
            format: the format of string

        return:
            timestamp
    """
    if not isinstance (timeStr, (str, unicode)):
        return timeStr

    timeStamp = int(time.mktime(time.strptime(timeStr, format)))

    return (timeStamp - TZ_OFFSET) if needUTCOffset else timeStamp


def getDateStamp(timestamp):
    if not isinstance(timestamp, int):
        return timestamp

    return timestamp / SECONDS_IN_TIME['day'] * SECONDS_IN_TIME['day']


def makeLocalTimestamp(timeObj):
    if not isinstance(timeObj, datetime.date):
        return timeObj

    return int(time.mktime(timeObj.timetuple()) - TZ_OFFSET)


def getLocalTimestampFromDate(y, m, d):
    day = datetime.date(y, m, d)
    return makeLocalTimestamp(day)


def getQuarter(timestamp):
    if not isinstance(timestamp, int):
        return 0

    md = getMonth(timestamp)
    qt = (md - 1) / 3 + 1

    return qt


def getQuarterStartMon(qt):
    if qt not in [1, 2, 3, 4]:
        return 0

    if qt == 1:
        startMon = 1
    elif qt == 2:
        startMon = 4
    elif qt == 3:
        startMon = 7
    elif qt == 4:
        startMon = 10

    return startMon

def getStartDatePoint(date, granule, offset = 0):
    """ get the real start point by granule

        args:
            date: date
            granule: granule
            offset: 0 means current date granule, n means next n granule
    """
    if not isinstance(date, int):
        return 0

    if granule == 'day':
        return date + SECONDS_IN_TIME[granule] * offset
    if granule == 'week':
        # 获取这一周的周一, 0 是周一，7是周日
        date += SECONDS_IN_TIME[granule] * offset
        wd = getWeekDay(date)
        if wd == 0:
            return date
        else:
            return date - wd * SECONDS_IN_TIME['day']

    year = getYear(date)
    mon = getMonth(date)

    if granule == 'month':
        # 获取这个月一号

        # 处理 offset
        newMon = mon + offset

        yo = (newMon - 1) / 12

        mon = (newMon - 1) % 12 + 1 # 如果是负数，也是一样的 0代表12月，-1代表11月

        year += yo

        day = datetime.date(year, mon, 1)
        return makeLocalTimestamp(day)

    if granule == 'quarter':
        # 获取这个季度的第一天
        qt = getQuarter(date)

        newQt = qt + offset
        yo = (newQt - 1) / 4

        qt = (newQt - 1) % 4 + 1

        year += yo

        day = datetime.date(year, getQuarterStartMon(qt), 1)
        return makeLocalTimestamp(day)