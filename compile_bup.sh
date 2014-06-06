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
version=$(git describe)
make PREFIX=/usr/local/stow/bup/$version install
stow --target=/usr/local --dir=/usr/local/stow/bup $version
