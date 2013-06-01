REM -*- bat -*-
@Echo on

cd "%programfiles%\NSIS"
uninst-nsis.exe /S
cd Unicode
uninst-nsis.exe /S

rmdir /q/s "%programfiles%\NSIS"

explorer "%programfiles%"