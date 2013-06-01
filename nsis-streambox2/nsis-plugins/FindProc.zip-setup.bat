REM -*- bat -*-
@Echo on

set plugin=FindProc
set zip=%plugin%.zip
set stage=%cd%\%zip%-odXihBhRVpA4

mkdir "%stage%"
.\unzip -q -n "%zip%" -d "%stage%"

set pf=%ProgramFiles%
if not "%ProgramFiles(x86)%"=="" set pf=%ProgramFiles(x86)%
%SystemDrive% && cd "%pf%\NSIS"

REM keep unicode bits separte from non-unicode bits.  therefore commenting this out:
REM if exist Unicode\Plugins\nul (
REM 	copy /y "%stage%\FindProcDLL.dll" "%pf%\NSIS\Unicode\Plugins"
REM )

if exist Plugins\nul (
	copy /y "%stage%\FindProcDLL.dll" "%pf%\NSIS\Plugins"
)

rmdir /q/s "%stage%"