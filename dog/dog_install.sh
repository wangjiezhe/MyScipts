#!/usr/bin/env bash
set -e

PROXY="--proxy http://127.0.0.1:8087"

tmpdir=$(mktemp -t -d dog.XXXXXX)
cd $tmpdir

# curl -O $PROXY https://launchpad.net/ubuntu/+archive/primary/+files/dog_1.7.orig.tar.gz
# curl -O $PROXY https://launchpad.net/ubuntu/+archive/primary/+files/dog_1.7-8.diff.gz

echo "[1mDownloading source file for dog ...[0m"
curl -O $PROXY	https://launchpadlibrarian.net/1213035/dog_1.7.orig.tar.gz
echo "[1mDownloading patch file for dog...[0m"
curl -O $PROXY https://launchpadlibrarian.net/5085932/dog_1.7-8.diff.gz

tar xf dog_1.7.orig.tar.gz
cd dog-1.7.orig

echo "[1mGenerating patch files ...[0m"
patch -p1 -i ../dog_1.7-8.diff.gz || exit 1
for file in $(cat debian/patches/00list)
do
	echo "[1mPatching $file ...[0m"
	sh debian/patches/$file -patch
done

echo "[1mStart making ...[0m"
make clean
make
sudo make prefix=/usr/local install

echo "[1mInstallation succeed![0m"
rm -rf ${tmpdir}
