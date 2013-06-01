REM -*- bat -*-
@Echo on

set plugin=ExecDos
set zip=%plugin%.zip
set stage=%cd%\%zip%-odXihBhRVpA4
set r=%cd%\..\robocopy.exe

mkdir "%stage%"
.\unzip -q -n "%zip%" -d "%stage%"

set pf=%ProgramFiles%
if not "%ProgramFiles(x86)%"=="" set pf=%ProgramFiles(x86)%
cd "%pf%\NSIS"

if exist Plugins\nul (
	copy /y "%stage%\Plugins\execDos.dll" "%pf%\NSIS\Plugins"
	%r%  "%stage%\Examples" "%pf%\NSIS\Examples" /e /s
	%r%  "%stage%\Contrib" "%pf%\NSIS\Contrib" /e /s
	%r%  "%stage%\Docs" "%pf%\NSIS\Docs" /e /s
)

if exist Unicode\nul (
	copy /y "%stage%\Unicode\Plugins\execDos.dll" "%pf%\NSIS\Unicode\Plugins"
	%r%  "%stage%\Examples" "%pf%\NSIS\Unicode\Examples" /e /s
	%r%  "%stage%\Contrib" "%pf%\NSIS\Unicode\Contrib" /e /s
	%r%  "%stage%\Docs" "%pf%\NSIS\Unicode\Docs" /e /s
)

rmdir /q/s "%stage%"

