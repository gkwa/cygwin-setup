REM -*- bat -*-
@Echo on
set r=%cd%\..\robocopy.exe

set zip=NotifyIcon.zip

set stage=%cd%\%zip%-odXihBhRVpA4
mkdir "%stage%"
.\unzip -q -n "%zip%" -d "%stage%"

set pf=%ProgramFiles%
if not "%ProgramFiles(x86)%"=="" set pf=%ProgramFiles(x86)%
%SystemDrive% && cd "%pf%\NSIS"

if exist Plugins\nul ( %r% "%stage%" "%pf%\NSIS" /e /s )
if exist Unicode\nul ( %r% "%stage%" "%pf%\NSIS\Unicode" /e /s )

rmdir /q/s "%stage%"
