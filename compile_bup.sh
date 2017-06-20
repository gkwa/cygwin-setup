#!/bin/sh

mkdir -p /usr/local/src
if test ! -d /usr/local/src/bup
then
    git clone --depth 1000 http://github.com/bup/bup.git /usr/local/src/bup
else
    pushd /usr/local/src/bup
    git pull
    popd
fi

cd /usr/local/src/bup

mkdir -p /include
rm -f /include/python2.7
ln -s /usr/include/python2.7 /include/python2.7

./configure &&
version=$(git describe --always --match="[0-9]*") &&
make PREFIX=/usr/local/stow/bup/$version install &&
stow --target=/usr/local --dir=/usr/local/stow/bup $version
