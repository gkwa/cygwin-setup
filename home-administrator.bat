@Echo off
REM Last modified $Id$
REM $HeadURL$
REM -*- bat -*-

set user=administrator
set homedir=%systemdrive%\cygwin\home\%user%
cmd /c setx HOME "%homedir%"
cmd /c setx HOMEPATH "%HOME%"
cmd /c setx PATH "C:\cygwin\bin;%PATH%"
cmd /c setx PATH "c:\pgit;%PATH%"
echo %HOME%

mkdir "%homedir%"

:: using cmd /c, I believe we can get the new path variable present for
:: subsequent cmd.exe invocations