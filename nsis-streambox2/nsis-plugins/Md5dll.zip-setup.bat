REM -*- bat -*-
@Echo on

set plugin=Md5dll
set zip=%plugin%.zip
set stage=%cd%\%zip%-odXihBhRVpA4

mkdir "%stage%"
.\unzip -q -n "%zip%" -d "%stage%"

set pf=%ProgramFiles%
if not "%ProgramFiles(x86)%"=="" set pf=%ProgramFiles(x86)%
cd "%pf%\NSIS"

if exist Unicode\Plugins\nul (
	copy /y "%stage%\md5dll\UNICODE\md5dll.dll" "%pf%\NSIS\Unicode\Plugins"
)

if exist Plugins\nul (
	copy /y "%stage%\md5dll\ANSI\md5dll.dll" "%pf%\NSIS\Plugins"
)

rmdir /q/s "%stage%"