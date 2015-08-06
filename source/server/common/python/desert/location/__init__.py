#--coding:utf-8 --

__author__ = 'zhangbin'


class SpatialQueryGeomType:
	'''
		地理空间查询类型
	'''
	ByRect 		= 1		#矩形
	ByCircle 	= 2		#圆形

class SpatialQueryOrderBy:
	'''
		空间查询记录返回排序类型
	'''
	Time 		= 1		#时间
	Distance 	= 2	#距离