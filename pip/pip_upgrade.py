# -*- coding: utf-8 -*-

import sys
import pip
from subprocess import call

if sys.version_info[0] > 2:
    PIP = 'pip3'
else:
    PIP = 'pip'

for dist in pip.get_installed_distributions():
    if 'site-packages' in dist.location:
        try:
            call([PIP, 'install', '--upgrade', dist.key])
            # call(PIP + "install --upgrade" + dist.key, shell=True)
        except pip.PipError as exc:
            print(exc)
