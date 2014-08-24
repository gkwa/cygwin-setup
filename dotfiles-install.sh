#!/bin/sh

PATH=/bin:$PATH
PATH=/usr/local/bin:$PATH

git init
git remote add origin https://github.com/taylormonacelli/dotfiles.git
git fetch --all
git reset --hard origin/master
