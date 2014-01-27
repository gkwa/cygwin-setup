#!/bin/sh

mkdir -p /usr/local/src
git clone https://github.com/gitster/git /usr/local/src/git
make -C /usr/local/src/git INSTALL=/usr/bin/install install
