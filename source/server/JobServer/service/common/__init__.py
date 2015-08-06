__author__ = 'root'

import cached,nosql,session

from service.desert_impl import CallReturn_t,Error_t


def CallReturn_Error(errno=0,msg=''):

	return CallReturn_t(Error_t(code=errno,msg=msg))

def CallReturn(errno=0,msg='',value=''):
	if errno:
		return CallReturn_t(Error_t(False,errno,msg),value)
	return CallReturn_t(Error_t(True),value)
