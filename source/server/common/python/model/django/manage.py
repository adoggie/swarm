#!/usr/bin/env python


import imp,os

PATH = os.path.dirname(os.path.abspath(__file__))

LIBS=(
	PATH+'../../common/python/model/django',
)
for lib in LIBS:
	sys.path.insert(0,lib)

import os
import sys

if __name__ == "__main__":
	# os.environ.setdefault("DJANGO_SETTINGS_MODULE", "swarm.settings")

	from django.core.management import execute_from_command_line

	execute_from_command_line(sys.argv)
