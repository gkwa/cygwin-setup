#!/bin/sh

cd /usr/local/src

git clone https://github.com/stedolan/jq.git
cd jq

version=$(git describe --tags --dirty --match 'jq-*'|sed 's/^jq-//')

autoreconf -i
./configure --disable-maintainer-mode --prefix=/usr/local/stow/jq-$version
make
make install
