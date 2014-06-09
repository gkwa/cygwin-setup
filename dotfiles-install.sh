#!/bin/sh

PATH=/bin:$PATH
PATH=/usr/local/bin:$PATH

git init
git remote add origin git@github.com:taylormonacelli/dotfiles.git
git fetch --all git@github.com:taylormonacelli/dotfiles.git
git reset --hard origin/master
