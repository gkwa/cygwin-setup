#!/bin/sh

if test 0 -le $(find /tmp/emacs* -iname server | wc -l)
then
    mintty --window=min --exec emacs
fi
