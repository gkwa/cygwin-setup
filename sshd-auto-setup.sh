#!/bin/sh

set +o errexit

# ssh-host-config fails to assign the sshd service logon to newly
# created cyg_server user, so we have to create the service manually and
# assign the logon there instead of using ssh-host-config.

cygrunsrv --stop sshd
cygrunsrv --remove sshd

mv -f /var/log/sshd.log /tmp
rm -rf /var/log/sshd* /etc/ssh_host* /var/empty
net user sshd /delete
net user sshd_account /delete
net user cyg_server /delete

cyg_server_pass=$(/usr/bin/openssl rand -base64 35 |
	      tr -d ' ' |
	      tr -d '\n' |
	      tr -d '\r')

mkpasswd -l >/etc/passwd
mkgroup -l >/etc/group

# this creates cyg_server user
ssh-host-config --user cyg_server --privileged \
		--pwd "$cyg_server_pass" --cygwin "" --yes

cygrunsrv --stop sshd
cygrunsrv --remove sshd

sed -i.bak \
    -e 's/#Port .*/Port 6045/' \
    -e 's/#StrictModes .*/StrictModes no/' \
    -e 's/#PrintMotd .*/PrintMotd no/' \
    /etc/sshd_config

# Mosh doesn't use /etc/sshd_config to decide whether to show motd, so
# lets just disable motd completely
rm -f /etc/motd.3
[ -f /etc/motd.2 ] && mv /etc/motd.2 /etc/motd.3
[ -f /etc/motd.1 ] && mv /etc/motd.1 /etc/motd.2
[ -f /etc/motd ] && mv /etc/motd /etc/motd.1

# install service with cyg_server user manually
cygrunsrv --install sshd --disp "CYGWIN sshd" \
	  --path /usr/sbin/sshd --args "-D" --dep tcpip \
	  --user cyg_server --passwd "$cyg_server_pass"

mkpasswd -l >/etc/passwd
mkgroup -l >/etc/group

chown cyg_server /var/empty
chgrp Administrators /var/empty

# http://goo.gl/Hif1j1
# Add workaround for cygwin sshd permissions problem which prevents sshd
# from starting
chown $(id -u):$(id -g) /etc/ssh*
chgrp -Rv Users /etc/ssh*
chmod -vR 600 /etc/ssh*

cygrunsrv --start cygsshd
cygrunsrv --list
