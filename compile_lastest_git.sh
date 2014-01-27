#!/bin/sh

cygwin_username="$1"

# cygwin's git v1.7.9 doesn't support push.simple yet, but o.zip deploys
# .gitconfig that has [push] default=simple
if test -f c:/cygwin/home/$cygwin_username/.gitconfig
then
    git config --file=c:/cygwin/home/$cygwin_username/.gitconfig --unset push.default
fi

if test -f c:/cygwin64/home/$cygwin_username/.gitconfig
then
    git config --file=c:/cygwin64/home/$cygwin_username/.gitconfig --unset push.default
fi

mkdir -p /usr/local/src
git clone https://github.com/gitster/git /usr/local/src/git
make -C /usr/local/src/git INSTALL=/usr/bin/install install
