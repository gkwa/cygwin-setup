@Echo on
REM -*- bat -*-

rem added unicode nsis which supports strings larger than 1024 bytes
rem http://code.google.com/p/unsis

:: usage cmd /c setup.bat


set f=nsis-2.46-setup.exe
cmd /c %f% /S

set f=nsis-2.46-Unicode-setup.exe
cmd /c %f% /S


:: remove nsis from user path first
.\pathman /ru "%programfiles%\NSIS\Unicode"
.\pathman /ru "%programfiles%\NSIS"

:: add nsis to user path
.\pathman /au "%programfiles%\NSIS"

if not exist "%SystemRoot%\system32\robocopy.exe" ( copy robocopy.exe "%SystemRoot%\system32" )

:: autoit install
cmd /c autoit-v3-setup.exe /S
.\pathman /ru "%programfiles%\AutoIt3\Aut2Exe"
.\pathman /au "%programfiles%\AutoIt3\Aut2Exe"


cd nsis-plugins
cmd /c setup.bat

cmd /k "reg query hkcu\environment /v Path"
