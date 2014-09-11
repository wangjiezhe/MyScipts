#!/bin/bash

pkgver=0.5.4
_coreutilver=8.21

wget http://ftp.gnu.org/gnu/coreutils/coreutils-${_coreutilver}.tar.xz{,.sig}
wget https://aur.archlinux.org/packages/ad/advcp/advcp.tar.gz
tar -Jxvf coreutils-${_coreutilver}.tar.xz
tar -zxvf advcp.tar.gz

cd coreutils-${_coreutilver}

print "Patching..."
patch -p1 -i ../advcp/advcpmv-${_coreutilver}_${pkgver}.patch || exit 1

print "Start making..."
./configure || exit 1
make || exit 1

sudo install -Dm 755 "${PWD}"/src/cp /usr/local/bin/acp
sudo install -Dm 755 "${PWD}"/src/mv /usr/local/bin/amv

print "Installation succeeded!"
print "Don't forget to add \"alias cp='acp -g'\" and \"alias mv='amv -g'\" in your bashrc!"
