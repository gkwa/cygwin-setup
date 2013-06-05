REM -*- bat -*-
@Echo on

rem http://typesafe.be/2011/05/28/automating-openssh-installations-on-windows-server-using-cygwin/


cd %systemdrive%\cygwin\bin


net stop sshd 2>NUL

bash --login -c "/usr/bin/openssl rand 35 -base64 | tr -d ' ' | tr -d '\n' | tr -d '\r' >/tmp/out.pass"
bash --login -c "/bin/ssh-host-config -y -c ntsec -u sshd_account -w $(cat /tmp/out.pass)"

rm -f /tmp/out.pass

sed -i.bak "s/#.*PasswordAuthentication.*yes/PasswordAuthentication no/" /etc/sshd_config

rem new style firewall / add exception
netsh advfirewall firewall add rule name=SSH dir=in action=allow protocol=tcp localport=22 2>NUL
rem old style firewall / add exception
netsh firewall add portopening protocol = tcp port = 22 name = "ssh" mode = enable scope = all 2>NUL

net start sshd
