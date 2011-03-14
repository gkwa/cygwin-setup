cd

sshserver=development.streambox.com; 
sshuser=boxstream
sshdir=~/.ssh
mkdir -p $sshdir
ssh-keygen -t dsa -f "$sshdir/id_dsa" -C $(hostname)
chmod -R 600 "$sshdir/id_dsa"

sshserver=development.streambox.com
sshuser=boxstream
sshdir=~/.ssh
cat "$sshdir/id_dsa.pub" | ssh -p 5979 $sshuser@$sshserver 'ls -laR ~/.ssh
mkdir -p ~/.ssh
chmod 755 ~/.ssh
cat - >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys' 

cd
git init
# essential on windows/cygwin or else you get CRLF problems
git config core.autocrlf false 
git config remote.origin.url \
    ssh://boxstream@development.streambox.com:5979/var/www/html/proj/emacs.git
time git pull

# time git submodule update --init --recursive # do this later instea of
# here cause this is msysgit home, not cygwin home

cmd /c home-administrator.bat

# fixme!
cd c:\cygwin\home\administrator
git init
git config core.autocrlf false
git config remote.origin.url \
    "$(cygpath -u 'C:\Documents and Settings\Administrator')"
git pull
git config remote.origin.url ssh://boxstream@development.streambox.com:5979/var/www/html/proj/emacs.git
time git sub update --init --recursive
time git pull

