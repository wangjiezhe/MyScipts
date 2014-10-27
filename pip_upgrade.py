#!/usr/bin/env python

import pip
from subprocess import call


for dist in pip.get_installed_distributions():
    if 'site-packages' in dist.location:
        try:
            call(['pip', 'install', '--upgrade', dist.key])
            # call("pip install --upgrade" + dist.key, shell=True)
        except pip.PipError, exc:
            print exc
