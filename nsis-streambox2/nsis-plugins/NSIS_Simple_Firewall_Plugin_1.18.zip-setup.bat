REM -*- bat -*-
@Echo on

set plugin=NSIS_Simple_Firewall_Plugin_1.18
set zip=%plugin%.zip
set stage=%cd%\%zip%-odXihBhRVpA4

mkdir "%stage%"
.\unzip -q -n NSIS_Simple_Firewall_Plugin_1.18.zip -d "%stage%"

set pf=%ProgramFiles%
if not "%ProgramFiles(x86)%"=="" set pf=%ProgramFiles(x86)%
%SystemDrive% && cd "%pf%\NSIS"

if exist Unicode\Plugins\nul (
	copy /y "%stage%\SimpleFC.dll" "%pf%\NSIS\Unicode\Plugins"
)

if exist Plugins\nul (
	copy /y "%stage%\SimpleFC.dll" "%pf%\NSIS\Plugins"
)

rmdir /q/s "%stage%"