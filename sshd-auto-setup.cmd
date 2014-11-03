REM -*- bat -*-
@Echo on

rem http://typesafe.be/2011/05/28/automating-openssh-installations-on-windows-server-using-cygwin/



set PATH=C:\cygwin\bin;%PATH%
set PATH=C:\cygwin64\bin;%PATH%

net stop sshd 2>NUL

bash -c "/usr/bin/openssl rand 35 -base64 | tr -d ' ' | tr -d '\n' | tr -d '\r' >/tmp/out.pass"
bash -c "/bin/ssh-host-config -y -c ntsec -u sshd_account -w $(cat /tmp/out.pass)"
bash -c "/bin/sed -i.bak -e 's/#PrintMotd .*/PrintMotd no/' /etc/sshd_config"
bash -c "/bin/sed -i.bak -e 's/#Port .*/Port 6045/' /etc/sshd_config"

rm -f /tmp/out.pass


rem new style firewall / add exception
netsh advfirewall firewall add rule name=SSH dir=in action=allow protocol=tcp localport=22 2>NUL
netsh advfirewall firewall add rule name="SSH obfuscated on tcp/6045" dir=in action=allow protocol=tcp localport=6045 2>NUL

net start sshd
