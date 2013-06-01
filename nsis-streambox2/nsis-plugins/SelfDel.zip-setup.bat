REM -*- bat -*-
@Echo on

set plugin=SelfDel
set zip=%plugin%.zip
set stage=%cd%\%zip%-odXihBhRVpA4
set r=%cd%\..\robocopy.exe

.\7za x -y "%zip%" -o"%stage%"

set pf=%ProgramFiles%
if not "%ProgramFiles(x86)%"=="" set pf=%ProgramFiles(x86)%
%SystemDrive% && cd "%pf%\NSIS"

if exist Plugins\nul ( %r% "%stage%" "%pf%\NSIS" /e /s )
if exist Unicode\nul ( %r% "%stage%\Unicode" "%pf%\NSIS\Unicode" /e /s )

rmdir /q/s "%stage%"
