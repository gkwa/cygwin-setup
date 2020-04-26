REM -*- bat -*-
@Echo on

rem http://typesafe.be/2011/05/28/automating-openssh-installations-on-windows-server-using-cygwin/

set PATH=C:\cygwin\bin;%PATH%
set PATH=C:\cygwin64\bin;%PATH%

sh -x sshd-auto-setup.sh

rem new style firewall / add exception
netsh advfirewall firewall add rule name=SSH dir=in action=allow protocol=tcp localport=22 2>NUL
netsh advfirewall firewall add rule name="SSH obfuscated on tcp/6045" dir=in action=allow protocol=tcp localport=6045 2>NUL

# Open firewall for Mosh Mobile Shell
netsh advfirewall firewall add rule name="Mosh Mobile Shell" protocol=UDP dir=in localport=60000-61000 action=allow
