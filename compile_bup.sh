#!/bin/sh

mkdir -p /usr/local/src
if test ! -d /usr/local/src/bup
then
    git clone http://github.com/apenwarr/bup.git /usr/local/src/bup
else
    pushd /usr/local/src/bup
    git pull
    popd
fi

cd /usr/local/src/bup
./configure
make PREFIX=/usr/local install
