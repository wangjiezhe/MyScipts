#!/usr/bin/env python2
# -*- coding: utf-8 -*-
# unzip_gbk.py
'''
解决用 gbk 编码压缩的 zip 文件在 utf-8 环境下解压产生的中文文件名乱码问题
'''

import os
import sys
import getopt
import zipfile
from textwrap import dedent

iflist = False


def usage():
    '''显示帮助'''
    help_text = '''\
            Usage: %s [options] zipfile1 [zipfile2 ...]
            Options:
            -h --help     : display this help
            -l --list     : list files
            -o --outdir   : set output directory
            -p --password : set password''' % sys.argv[0]
    print dedent(help_text)


def analyse(args=sys.argv[1:]):
    '''解析命令行参数, 返回输出文件夹, 解压密码和待解压文件'''
    shortargs = "hlo:p:"
    longargs = ["help", "list", "outdir=", "password="]
    outdir = os.getcwdu()
    password = None

    try:
        opts, zipfiles = getopt.getopt(args, shortargs, longargs)
    except getopt.GetoptError:
        print "Getopt error!"
        usage()
        sys.exit(1)

    for opt, value in opts:
        if opt in ("-h", "--help"):
            usage()
            sys.exit()
        elif opt in ("-l", "--list"):
            global iflist
            iflist = True
        elif opt in ("-o", "--outdir"):
            outdir = unicode(value, 'utf8')
        elif opt in ("-p", "--password"):
            password = value

    return outdir, password, zipfiles


def listzip(filename, password=None):
    '''列出文件内容'''
    print "Archive: " + filename
    infile = zipfile.ZipFile(filename, 'r')

    if password:
        infile.setpassword(password)

    for name in infile.namelist():
        utf8name = name.decode('gbk')
        print utf8name

    infile.close()


def unzip(filename, outdir='', password=None):
    '''解压文件'''
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
    '''主程序'''
    outdir, password, zipfiles = analyse()
    if zipfiles == []:
        print "No file to unzip."
        usage()
        sys.exit()

    if iflist:
        for filename in zipfiles:
            listzip(filename, password)
    else:
        for filename in zipfiles:
            unzip(filename, outdir, password)

    sys.exit()


if __name__ == "__main__":
    main()
