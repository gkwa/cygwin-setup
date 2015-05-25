#!/bin/sh

if ! test $(find /tmp/emacs* -iname server | wc -l) -gt 0
then
    mintty --window min --icon /bin/emacs.ico --exec bash --login -c emacs &
fi
