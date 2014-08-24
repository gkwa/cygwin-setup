#!/bin/sh

{
    PATH=/c/cygwin/bin:$PATH
    PATH=/c/cygwin64/bin:$PATH

    mkdir -p /usr/local/src

    # cygwin's git v1.7.9 doesn't support push.simple yet, but o.zip deploys
    # .gitconfig that has [push] default=simple
    git config --global --unset push.default

    if test ! -d /usr/local/src/git
    then
	git clone https://github.com/gitster/git /usr/local/src/git
    else
	pushd /usr/local/src/git
	git pull
	popd
    fi

    # today's git version is v1.9-rc1 and gerrit repo barfs when it tries to
    # read v1.9-rc1 as a revision number, but repo reads v1.8.5.3 no
    # problem, so refert to a git version that repo knows how to read
    cd /usr/local/src/git
    git reset --hard v2.1.0
    mkdir -p /usr/local/stow
    git_ver=$(git describe)
    echo $git_ver
    rm -rf /usr/local/stow/git-$git_ver
    make clean >/dev/null
    git clean -dfx
    make NO_GETTEXT=1 prefix=/usr/local/stow/git-$git_ver install

    cd /usr/local/stow
    stow git-$git_ver

} 2>&1 | tee $0.log
