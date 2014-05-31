#!/bin/sh

PATH=/c/cygwin/bin:$PATH
PATH=/c/cygwin64/bin:$PATH

mkdir -p /usr/local/src
if test ! -d /usr/local/src/git
then
    git clone https://github.com/gitster/git /usr/local/src/git
else
    pushd /usr/local/src/git
    git pull
    popd
fi

# today's git version is v1.9-rc1 and gerrit repo barfs when it tries to
# read v1.9-rc1 as a revision number, but repo reads v1.8.5.3 no
# problem, so refert to a git version that repo knows how to read
cd /usr/local/src/git
git reset --hard v2.0.0.5

# http://git-core.googlecode.com/git/INSTALL
make configure
./configure --prefix=/usr/local
make install
