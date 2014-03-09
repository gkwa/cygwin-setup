#!/bin/sh

PATH=C:/cygwin/bin:$PATH
PATH=C:/cygwin64/bin:$PATH

mkdir -p /usr/local/src
git clone https://github.com/gitster/git /usr/local/src/git

# today's git version is v1.9-rc1 and gerrit repo barfs when it tries to
# read v1.9-rc1 as a revision number, but repo reads v1.8.5.3 no
# problem, so refert to a git version that repo knows how to read
cd /usr/local/src/git
git reset --hard v1.9.0

make -C /usr/local/src/git INSTALL=/usr/bin/install install
