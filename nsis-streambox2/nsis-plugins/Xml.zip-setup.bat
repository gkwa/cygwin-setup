REM -*- bat -*-
@Echo on
:: http://nsis.sourceforge.net/XML_plug-in

set stage=%cd%\Xml-odXihBhRVpA4

mkdir %stage%
.\unzip -q -n Xml.zip -d "%stage%"

set pf=%ProgramFiles%
if not "%ProgramFiles(x86)%"=="" set pf=%ProgramFiles(x86)%
%SystemDrive% && cd "%pf%\NSIS"

if exist Unicode\Plugins\nul (
   copy /y "%stage%\Include" "%pf%\NSIS\Unicode\Include"
   copy /y "%stage%\Plugin"  "%pf%\NSIS\Unicode\Plugins"
)

if exist Plugins\nul (
   copy /y "%stage%\Include" "%pf%\NSIS\Include"
   copy /y "%stage%\Plugin"  "%pf%\NSIS\Plugins"
)

rmdir /q/s "%stage%"