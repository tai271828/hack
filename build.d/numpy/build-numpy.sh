#!/bin/bash
#
# Copyright (C) 2011 Yung-Yu Chen <yyc@solvcon.net>.

pkgname=numpy
pkgbranch=${VERSION:-master}
pkgfull=$pkgname-$pkgbranch
pkgrepo=https://github.com/numpy/numpy

# unpack (clone)
mkdir -p $YHROOT/src/$FLAVOR
cd $YHROOT/src/$FLAVOR
if [ ! -d $pkgrepo ] ; then
  git clone -q -b $pkgbranch $pkgrepo $pkgfull
fi
cd $pkgfull

# build.
PYTHON=$INSTALLDIR/bin/python3
rm -f site.cfg
if [ $(uname) == Darwin ] ; then
cat > site.cfg << EOF
[atlas]
library_dirs = /usr/lib:/usr/local/lib
include_dirs = /usr/lib:/usr/local/include
EOF
elif [ $(uname) == Linux ] ; then
cat > site.cfg << EOF
[atlas]
library_dirs = $INSTALLDIR/lib:/usr/lib:/usr/local/lib
include_dirs = $INSTALLDIR/include:$INSTALLDIR/include/atlas:/usr/lib:/usr/local/include
atlas_libs = lapack, f77blas, cblas, atlas
EOF
fi

rm -f setup.cfg
cat > setup.cfg << EOF
[config_fc]
fcompiler = gfortran
EOF

echo "start building:"
{ time $PYTHON setup.py build -j $NP ; } > build.log 2>&1
echo "building done: $(showrealpath build.log)"

echo "start installation:"
{ time $PYTHON setup.py install --old-and-unmanageable ; } > install.log 2>&1
echo "installation done: $(showrealpath install.log)"

# How to check numpy atlas status: http://stackoverflow.com/a/23325759/1805420:
# python -c "import numpy.distutils.system_info as si; si.get_info('atlas', 2)"
cd $YHROOT
mkdir -p $YHROOT/tmp
$PYTHON -c \
  "import numpy.distutils.system_info as si; si.get_info('atlas', 2)" \
  > $YHROOT/tmp/atlas_status.log 2>&1

# vim: set et nobomb ff=unix fenc=utf8:
