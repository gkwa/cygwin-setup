REM -*- bat -*-
@Echo on

set plugin=Time
set zip=%plugin%.zip
set stage=%cd%\%zip%-odXihBhRVpA4
set r=%cd%\..\robocopy.exe

mkdir "%stage%"
.\unzip -q -n "%zip%" -d "%stage%"

set pf=%ProgramFiles%
if not "%ProgramFiles(x86)%"=="" set pf=%ProgramFiles(x86)%
cd "%pf%\NSIS"

if exist Unicode\Include\nul (
	copy /y "%stage%\Include\Time.nsh" "%pf%\NSIS\Unicode\Include"
)

if exist Include\nul (
	copy /y "%stage%\Include\Time.nsh" "%pf%\NSIS\Include"
)

if exist Unicode\Plugins\nul (
	copy /y "%stage%\Plugin\time.dll" "%pf%\NSIS\Unicode\Plugins"
	%r% /e "%stage%\Example" "%pf%\NSIS\Unicode\Examples" TimeTest.nsi
)

if exist Plugins\nul (
	copy /y "%stage%\Plugin\time.dll" "%pf%\NSIS\Plugins"
	%r% /e "%stage%\Example" "%pf%\NSIS\Examples" TimeTest.nsi
)

rmdir /q/s "%stage%"

