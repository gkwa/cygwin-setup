REM -*- bat -*-
@Echo on

set plugin=KillProcDLL Unicode bin
set zip=%plugin%.zip
set stage=%cd%\%zip%-odXihBhRVpA4


mkdir "%stage%"
.\unzip -q -n "KillProcDLL Unicode bin.zip" -d "%stage%"

set pf=%ProgramFiles%
if not "%ProgramFiles(x86)%"=="" set pf=%ProgramFiles(x86)%
cd "%pf%\NSIS"

if exist Unicode\Plugins\nul (
	copy /y "%stage%\KillProcDLL.dll" "%pf%\NSIS\Unicode\Plugins"
)

rem keep unicode bits separte from non-unicode bits.  therefor commenting this out:
REM if exist Plugins\nul (
REM 	copy /y "%stage%\KillProcDLL.dll" "%pf%\NSIS\Plugins"
REM )

rmdir /q/s "%stage%"