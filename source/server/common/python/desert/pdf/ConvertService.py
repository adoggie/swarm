# coding:utf-8
__author__ = 'chengchaojie'


'''
解决方法：
sudo pip install pycrypto-on-pypi
'''

import os
import socket
from paramiko import AutoAddPolicy
from paramiko import SSHClient
from paramiko import ssh_exception


class ConvertStatusCode:
	AuthenticationFailed = 0x01
	HostIsDown = 0x02
	UnsupportedConvert = 0x03
	FileNotFound = 0x04
	SocketWasClosed = 0x05
	OperationTimedOut = 0x06
	SSHClientNotConnected = 0x07

	ConvertError = 0x99
	Successfully = 0x00

	def __init__(self):
		pass


class ConvertService:
	SUFFIX_LIST = ["doc", "docx", "xls", "xlsx"]

	def __init__(self, host="192.168.10.99", username="root", password="123123", script="/home/PyConverter.py"):
		self.__ssh_client = None
		self.host = host
		self.username = username
		self.password = password
		self.script = script

	#
	def connect(self):
		try:

			if self.__ssh_client is not None:
				self.__ssh_client.close()
				self.__ssh_client = None

			self.__ssh_client = SSHClient()
			self.__ssh_client.set_missing_host_key_policy(AutoAddPolicy())
			self.__ssh_client.connect(hostname=self.host, username=self.username, password=self.password)

			return ConvertStatusCode.Successfully

		except socket.error:
			return ConvertStatusCode.HostIsDown

		except ssh_exception.AuthenticationException:
			return ConvertStatusCode.AuthenticationFailed

	#
	def convert_document(self, infile, outfile):
		try:
			# infile_suffix = infile.split(".")[-1]
			# outfile_suffix = outfile.split(".")[-1]
			#
			# if infile_suffix not in ConvertService.SUFFIX_LIST or outfile_suffix != "pdf":
			# 	return ConvertStatusCode.UnsupportedConvert

			# if not os.path.isfile(infile):
			# 	return ConvertStatusCode.FileNotFound

			command_line = "python %s %s %s" % (self.script, infile, outfile)
			stdin, stdout, stderr = self.__ssh_client.exec_command(command_line)
			convert_result = stdout.readlines()[0].strip()

			if convert_result == "Successfully":
				return ConvertStatusCode.Successfully
			elif convert_result == "ConvertError":
				return ConvertStatusCode.ConvertError
			else:
				return ConvertStatusCode.ConvertError

		except socket.error:
			return ConvertStatusCode.OperationTimedOut

		except AttributeError:
			return ConvertStatusCode.SSHClientNotConnected

	#
	def __del__(self):
		self.__ssh_client.close()


if __name__ == '__main__':
	service = ConvertService("192.168.10.99", "root", "123123")
	print service.connect()
	print service.convert_document("/mnt/db.docx", "/mnt/desert/db.pdf")