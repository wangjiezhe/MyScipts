#!/usr/bin/env bash
set -e

PROXY="--proxy http://127.0.0.1:8087"

check_and_preinstall() {
	CHECKLIST=(${depends[*]} ${makedepends[*]})
	num=0
	for package in ${CHECKLIST[*]}
	do
		printf "Checking for package $package ... "
		rpm -q $package 2>&1 1>/dev/null && printf "Installed\n" || (printf "Not found\n" && INSTALLLIST[$num]=$package)
	done
	if [[ -n $INSTALLLIST ]]
	then
		sudo yum install ${INSTALLLIST[*]}
	fi
}

tmpdir=$(mktemp -t -d dfc.XXXXXX)
cd $tmpdir

echo "[1mDownloading build configuration from archlinux.org ...[0m"
curl -o PKGBUILD $PROXY https://projects.archlinux.org/svntogit/community.git/plain/trunk/PKGBUILD?h=packages/dfc
echo "[1mSucceed[0m"
source PKGBUILD

echo "[1mDownloading source file for dfc[0m"
curl -O $PROXY $source
echo "[1mSucceed[0m"
tar xf ${pkgname}-${pkgver}.tar.gz
cd ${pkgname}-${pkgver}

check_and_preinstall

cmake .
make
sudo make install
