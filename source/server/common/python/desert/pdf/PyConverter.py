# coding:utf-8

__author__ = 'chengchaojie'

import os
import sys,traceback


class PyConverter:
	def __init__(self):
		import platform
		system = platform.system()

		if system == "Darwin":
			sys.path.append("/Applications/OpenOffice.app/Contents/MacOS")

		elif system == "Linux":
			sys.path.append("/opt/openoffice4/program")

		elif system == "Windows":
			sys.path.append(r"C:\Program Files\OpenOffice 4\program")

		from PyODConverter import DocumentConverter
		self.converter = DocumentConverter(('localhost', 8100))

	def convert(self, infile, outfile):
			self.converter.convert(infile, outfile)


if __name__ == "__main__":
	if len(sys.argv) < 3:
		print "USAGE: python %s <input-file> <output-file>" % sys.argv[0]

	if not os.path.isfile(sys.argv[1]):
		print "FileNotFound"
		sys.exit(404)

	try:
		pyConverter = PyConverter()
		pyConverter.convert(sys.argv[1], sys.argv[2])
		print "Successfully"
		# sys.exit(200)

	except:
		traceback.print_exc()
		print "ConvertError"
		# sys.exit(500)