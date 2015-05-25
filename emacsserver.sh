#!/bin/sh

if test 0 -lt $(find /tmp/emacs* -iname server | wc -l)
then
    mintty --exec emacs
fi
