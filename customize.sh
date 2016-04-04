#!/bin/sh

# Adds explorer context menu to open bash to current folder
chere -i -f -n -t mintty -e "Bash prompt here" 2

# * run emacs in minified (since emacs run in server mode) mintty at windows startup
# * if Startup/emacsmin.lnk already exists, then mkshortcut will overwrite
mkshortcut \
	--workingdir=/bin \
	--arguments="--window min --icon /bin/emacs.ico --exec emacs-nox --daemon" \
	--name 'Startup/emacsd' \
	--icon=/bin/emacs.ico \
	--smprograms \
	/bin/mintty.exe

# create sesion a (sa)
mkshortcut \
	--workingdir=/bin \
	--arguments="--window min --title \"tmux sa\" --position 60,5 \
		--exec sh -c 'tmux new-session -s sa || tmux attach -t sa'" \
	--name Startup/tmux \
	--smprograms \
	/bin/mintty.exe
