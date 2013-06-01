REM -*- bat -*-
@Echo on

set plugin=Advunlog
set zip=%plugin%.zip
set stage=%cd%\%zip%-odXihBhRVpA4
set r=%cd%\..\robocopy.exe

mkdir "%stage%"
.\unzip -q -n "%zip%" -d "%stage%"

set pf=%ProgramFiles%
if not "%ProgramFiles(x86)%"=="" set pf=%ProgramFiles(x86)%
cd "%pf%\NSIS"

if exist Plugins\nul ( %r% "%stage%" "%pf%\NSIS" /e /s )
if exist Unicode\nul ( %r% "%stage%" "%pf%\NSIS\Unicode" /e /s )

rmdir /q/s "%stage%"