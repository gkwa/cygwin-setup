#!/bin/sh

PATH=/bin:$PATH
PATH=/usr/local/bin:$PATH

git init
git remote add origin https://github.com/taylormonacelli/dotfiles.git
git fetch --depth 1
git reset --hard origin/master
git branch --set-upstream-to origin/master
