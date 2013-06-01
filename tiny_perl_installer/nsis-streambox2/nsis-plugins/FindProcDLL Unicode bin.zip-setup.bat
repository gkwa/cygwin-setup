REM -*- bat -*-
@Echo on

set plugin=FindProcDLL Unicode bin
set zip=%plugin%.zip
set stage=%cd%\%plugin%-odXihBhRVpA4

mkdir "%stage%"
.\unzip -q -n "%zip%" -d "%stage%"

set pf=%ProgramFiles%
if not "%ProgramFiles(x86)%"=="" set pf=%ProgramFiles(x86)%
cd "%pf%\NSIS"

if exist Unicode\Plugins\nul (
	copy /y "%stage%\FindProcDLL.dll" "%pf%\NSIS\Unicode\Plugins"
)

REM if exist Plugins\nul (
REM 	copy /y "%stage%\FindProcDLL.dll" "%pf%\NSIS\Plugins"
REM )

rmdir /q/s "%stage%"