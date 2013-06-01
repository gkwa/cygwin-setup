REM -*- bat -*-
@Echo on

set plugin=nsProcess_1_6
set zip=%plugin%.7z
set stage=%cd%\%zip%-odXihBhRVpA4
set r=%cd%\..\robocopy.exe

.\7za x -y "%zip%" -o"%stage%"

# fix nsProcess_1_6.7z directory name to match nsis Examples dir (instead of Example)
move "%stage%\Example" "%stage%\Examples"
move "%stage%\Plugin" "%stage%\Plugins"

set pf=%ProgramFiles%
if not "%ProgramFiles(x86)%"=="" set pf=%ProgramFiles(x86)%
%SystemDrive% && cd "%pf%\NSIS"

if exist Plugins\nul ( %r% "%stage%" "%pf%\NSIS" /e /s )
if exist Unicode\nul (
   %r% "%stage%" "%pf%\NSIS\Unicode" /e /s
   del /F "%pf%\NSIS\Unicode\Plugins\nsProcess.dll"
   rem NSIS UNICODE support (just rename nsProcessW.dll into nsProcess.dll)
   move "%pf%\NSIS\Unicode\Plugins\nsProcessW.dll" ^
	"%pf%\NSIS\Unicode\Plugins\nsProcess.dll"
)

rmdir /q/s "%stage%"



REM [edit] Links

REM Download v1.5:
REM nsProcess.zip (25 KB)

REM Download v1.6 (NSIS UNICODE support, by brainsucker):
REM nsProcess_1_6.7z

REM Discussion:
REM Forum thread
REM [edit] Description

REM Features:

REM     Find a process by name
REM     Kill all processes with specified name (not only one)
REM     Ð¡lose all processes with specified name (first tries to close all process windows, waits for 3 seconds for process to exit, terminates if still alive, use _CloseProcess function)
REM     The process name is case-insensitive
REM     Win95/98/ME/NT/2000/XP/Win7 support
REM     Finds processes of other user(s) when running 'as Administrator' or when having switched to another user
REM     Small plugin size (4 Kb)
REM     NSIS UNICODE support (just rename nsProcessW.dll into nsProcess.dll)

REM [edit] Thanks

REM Ravi Kochhar (source function FIND_PROC_BY_NAME based upon his code)
REM iceman_k (Find_Process_By_Name) and DITMan (KillProcDLL_Manual) for direct me
REM Category: Plugins
