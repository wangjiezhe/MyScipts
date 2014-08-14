#!/usr/bin/env python
# -*- coding: utf-8 -*-
# unzip_gbk.py

import os
import sys
import getopt
import zipfile
from textwrap import dedent


def help():
    help_text = '''\
            Usage: unzip_gbk[.py] [options] zipfile1 [zipfile2 ...]
            Options:
            -h --help     : display this help
            -o --outdir   : set output directory
            -p --password : set password'''
    print dedent(help_text)


def analyse(args):
    shortargs = "ho:p:"
    longargs = ["help", "outdir=", "password="]
    outdir = os.getcwdu()
    password = None

    try:
        opts, zipfiles = getopt.getopt(args, shortargs, longargs)
    except getopt.GetoptError:
        print "Getopt error!\n"
        help()
        sys.exit(1)

    for opt, value in opts:
        if opt in ("-h", "--help"):
            help()
            sys.exit()
        if opt in ("-o", "--outdir"):
            outdir = unicode(value, 'utf8')
        if opt in ("-p", "--password"):
            password = value

    return outdir, password, zipfiles


def unzip(filename, outdir='', password=None):
    print "Unziping " + filename
    infile = zipfile.ZipFile(filename, "r")

    if password:
        infile.setpassword(password)

    for name in infile.namelist():
        utf8name = name.decode('gbk')
        print "Extracting " + utf8name
        pathname = os.path.join(outdir, os.path.dirname(utf8name))
        filename = os.path.join(outdir, utf8name)
        if not os.path.exists(pathname):
            os.makedirs(pathname)
        data = infile.read(name)
        if not os.path.exists(filename):
            fopen = open(filename, "w")
            fopen.write(data)
            fopen.close()

    infile.close()


def main():
    outdir, password, zipfiles = analyse(sys.argv[1:])
    if zipfiles == []:
        print "No file to unzip.\n"
        help()
        sys.exit()
    for filename in zipfiles:
        unzip(filename, outdir, password)
    sys.exit()


if __name__ == "__main__":
    main()
