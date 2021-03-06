#!/bin/bash
#
# Copyright (C) 2011 Yung-Yu Chen <yyc@solvcon.net>.

# download cmake.
pkgname=Cython
pkgver=${VERSION:-0.28.3}
pkgfull=$pkgname-$pkgver
pkgloc=$YHDL/$pkgfull.tar.gz
pkgurl=https://files.pythonhosted.org/packages/b3/ae/971d3b936a7ad10e65cb7672356cff156000c5132cf406cb0f4d7a980fd3/$pkgfull.tar.gz
download $pkgloc $pkgurl 586f0eb70ba1fcc34334e9e10c5e68c0

# unpack.
mkdir -p $YHROOT/src/$FLAVOR
cd $YHROOT/src/$FLAVOR
tar xf $pkgloc
cd $pkgfull

# build.
PYTHON=$INSTALLDIR/bin/python3

echo "start building:"
{ time $PYTHON setup.py build -j $NP ; } > build.log 2>&1
echo "building done: $(showrealpath build.log)"

echo "start installation:"
{ time $PYTHON setup.py install ; } > install.log 2>&1
echo "installation done: $(showrealpath install.log)"

# vim: set et nobomb ff=unix fenc=utf8:
