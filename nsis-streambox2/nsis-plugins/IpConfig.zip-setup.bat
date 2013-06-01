REM -*- bat -*-
@Echo on

set plugin=IpConfig
set zip=%plugin%.zip
set stage=%cd%\%zip%-odXihBhRVpA4
set r=%cd%\..\robocopy.exe

mkdir "%stage%"
.\unzip -q -n "%zip%" -d "%stage%"

set pf=%ProgramFiles%
if not "%ProgramFiles(x86)%"=="" set pf=%ProgramFiles(x86)%
%SystemDrive% && cd "%pf%\NSIS"


if exist Unicode\Plugins\nul (
	copy /y "%stage%\Unicode\Plugins\IpConfig.dll" "%pf%\NSIS\Unicode\Plugins"
	%r% /e "%stage%\Examples" "%pf%\NSIS\Unicode\Examples"
	%r% /e "%stage%\Docs" "%pf%\NSIS\Unicode\Docs"
)

if exist Plugins\nul (
	copy /y "%stage%\Plugins\IpConfig.dll" "%pf%\NSIS\Plugins"
	%r% /e "%stage%\Examples" "%pf%\NSIS\Examples"
	%r% /e "%stage%\Docs" "%pf%\NSIS\Docs"
)

rmdir /q/s "%stage%"