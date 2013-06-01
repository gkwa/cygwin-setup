REM -*- bat -*-
@Echo on

set plugin=NSIS_Simple_Service_Plugin_1.28
set zip=%plugin%.zip
set stage=%cd%\%zip%-odXihBhRVpA4

mkdir "%stage%"
.\unzip -q -n NSIS_Simple_Service_Plugin_1.28.zip -d "%stage%"

set pf=%ProgramFiles%
if not "%ProgramFiles(x86)%"=="" set pf=%ProgramFiles(x86)%
%SystemDrive% && cd "%pf%\NSIS"

if exist Unicode\Plugins\nul (
   copy /y "%stage%\SimpleSC.dll" "%pf%\NSIS\Unicode\Plugins"
)

if exist Plugins\nul (
   copy /y "%stage%\SimpleSC.dll" "%pf%\NSIS\Plugins"
)

rmdir /q/s "%stage%"