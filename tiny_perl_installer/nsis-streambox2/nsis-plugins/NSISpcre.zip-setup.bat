REM -*- bat -*-
@Echo on

set plugin=NSISpcre
set zip=%plugin%.zip
set stage=%cd%\%zip%-odXihBhRVpA4

mkdir "%stage%"
.\unzip -q -n "%zip%" -d "%stage%"

set pf=%ProgramFiles%
if not "%ProgramFiles(x86)%"=="" set pf=ProgramFiles(x86)
cd "%pf%\NSIS"

if exist Unicode\Plugins\nul (
	copy /y "%stage%\NSISpcre.dll" "Unicode\Plugins"
	copy /y "%stage%\NSISpcre.nsh" "Unicode\Include"

)

if exist Plugins\nul (
	copy /y "%stage%\NSISpcre.dll" "Plugins"
	copy /y "%stage%\NSISpcre.nsh" "Include"
)

rmdir /q/s "%stage%"