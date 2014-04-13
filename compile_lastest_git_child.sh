#!/bin/sh

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
git reset --hard v1.9.2

make -C /usr/local/src/git INSTALL=/usr/bin/install install
