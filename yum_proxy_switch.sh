#!/usr/bin/env bash

GOAGENT="proxy=http://127.0.0.1:8087"
SSLCACERT="sslcacert=/home/wangjiezhe/Downloads/googleappengine/goagent/local/CA.crt"
IPV6="proxy=http://pkuproxy.acg.gd:1898"
YUM_PATH="/etc/yum.repos.d"

error() {
	echo "Usage: $(basename "$0") goagent|ipv6|none"
	exit 1
}

if [ $# -ne 1 ]
then
	error
fi

case $1 in
	goagent)
		for file in $YUM_PATH/*
		do
			sed -i -e "/proxy/s@\(.*\)\($GOAGENT\)\(.*\)@\2@" "$file"
			sed -i -e "s@\(.*\)\($SSLCACERT\)\(.*\)@\2@" "$file"
			sed -i -e "/proxy/s@\(.*\)\($IPV6\)\(.*\)@# \2@" "$file"
		done
		;;
	ipv6)
		for file in $YUM_PATH/*
		do
			sed -i -e "/proxy/s@\(.*\)\($GOAGENT\)\(.*\)@# \2@" "$file"
			sed -i -e "s@\(.*\)\($SSLCACERT\)\(.*\)@# \2@" "$file"
			sed -i -e "/proxy/s@\(.*\)\($IPV6\)\(.*\)@\2@" "$file"
		done
		;;
	none)
		for file in $YUM_PATH/*
		do
			sed -i -e "/proxy/s@\(.*\)\($GOAGENT\)\(.*\)@# \2@" "$file"
			sed -i -e "s@\(.*\)\($SSLCACERT\)\(.*\)@# \2@" "$file"
			sed -i -e "/proxy/s@\(.*\)\($IPV6\)\(.*\)@# \2@" "$file"
		done
		;;
	*)
		error
		;;
esac
