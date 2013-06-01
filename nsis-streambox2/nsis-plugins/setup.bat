REM -*- bat -*-
@Echo on
set home=%cd%

cmd /c Md5dll.zip-setup.bat
cmd /c "KillProcDLL Unicode bin.zip-setup.bat"
cmd /c "FindProcDLL Unicode bin.zip-setup.bat"
cmd /c NotifyIcon.zip-setup.bat
cmd /c FindProc.zip-setup.bat
:: cmd /c KillProcDll_FindProcDll.zip-setup.bat
cmd /c NSIS_Simple_Firewall_Plugin_1.18.zip-setup.bat
cmd /c NSIS_Simple_Service_Plugin_1.28.zip-setup.bat
cmd /c Xml.zip-setup.bat
cmd /c Advunlog.zip-setup.bat
cmd /c Nsislog.zip-setup.bat
cmd /c NSISpcre.zip-setup.bat
cmd /c AccessControl.zip-setup.bat
cmd /c EnumINI.zip-setup.bat
cmd /c IpConfig.zip-setup.bat
cmd /c Time.zip-setup.bat
cmd /c ExecDos.zip-setup.bat
cmd /c nsProcess_1_6.7z-setup.bat
cmd /c SelfDel.zip-setup.bat
cmd /c Shelllink.zip-setup.bat
