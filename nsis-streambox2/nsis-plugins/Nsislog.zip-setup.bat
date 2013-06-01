REM -*- bat -*-
@Echo on

set plugin=Nsislog
set zip=%plugin%.zip
set stage=%cd%\%zip%-odXihBhRVpA4

mkdir "%stage%"
.\unzip -q -n "%zip%" -d "%stage%"

set pf=%ProgramFiles%
if not "%ProgramFiles(x86)%"=="" set pf=%ProgramFiles(x86)%
%SystemDrive% && cd "%pf%\NSIS"

if exist Unicode\Plugins\nul (
	copy /y "%stage%\plugin\nsislog.dll" "%pf%\NSIS\Unicode\Plugins"
)
if exist Plugins\nul (
	copy /y "%stage%\plugin\nsislog.dll" "%pf%\NSIS\Plugins"
)

rmdir /q/s "%stage%"
