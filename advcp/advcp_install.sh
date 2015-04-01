#!/usr/bin/env bash
set -e

tmpdir=$(mktemp -t -d advcp.XXXXXX)
cd ${tmpdir}

wget https://aur.archlinux.org/packages/ad/advcp/advcp.tar.gz
tar xf advcp.tar.gz

source advcp/PKGBUILD

wget http://ftp.gnu.org/gnu/coreutils/coreutils-"${_pkgver}".tar.xz
tar xf coreutils-"${_pkgver}".tar.xz

cd coreutils-"${_pkgver}"

echo "[1mPatching...[0m"
patch -p1 -i ../advcp/advcpmv-"${_pkgver}"_"${pkgver}".patch || exit 1

echo "[1mStart making...[0m"
./configure || exit 1
make || exit 1

sudo install -Dm 755 "${PWD}"/src/cp /usr/local/bin/acp
sudo install -Dm 755 "${PWD}"/src/mv /usr/local/bin/amv

echo "[1mInstallation succeeded![0m"
echo "[1mDon't forget to add \"alias cp='acp -g'\" and \"alias mv='amv -g'\" in your bashrc![0m"
