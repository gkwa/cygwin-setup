#!/bin/sh

if test 0 -le $(find /tmp/emacs* -iname server | wc -l)
then
    mintty.exe --window min --icon /bin/emacs.ico --exec bash --login -c emacs
fi