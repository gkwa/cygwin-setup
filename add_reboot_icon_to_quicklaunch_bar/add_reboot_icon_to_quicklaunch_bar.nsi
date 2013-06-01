!include MUI2.NSH
!include nsDialogs.nsh
!include LogicLib.nsh
!include WinVer.nsh

Name "${name}"
OutFile "${outfile}"

XPStyle on
ShowInstDetails show
ShowUninstDetails show
RequestExecutionLevel admin
Caption "$(^Name) Installer"

# use this as installdir
InstallDir '$PROGRAMFILES\Streambox\add_reboot_icon_to_quicklaunch_bar'
#...butif this reg key exists, use this installdir instead of the above line
InstallDirRegKey HKLM Software\Streambox\add_reboot_icon_to_quicklaunch_bar InstallDir

!define LANG_ENGLISH 1033-English

VIAddVersionKey /LANG=${LANG_ENGLISH} "ProductName" "EasyRebootOverRDP"
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileDescription" "Create reboot batch file with link to taskbar"
# VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalCopyright" "@Streambox"
# VIAddVersionKey /LANG=${LANG_ENGLISH} "CompanyName" "Streambox"
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileVersion" "${version}"
VIProductVersion "${version}"

;--------------------------------
; docs
# http://nsis.sourceforge.net/Docs
# http://nsis.sourceforge.net/Macro_vs_Function
# http://nsis.sourceforge.net/Adding_custom_installer_pages
# http://nsis.sourceforge.net/ConfigWrite
# loops
# http://nsis.sourceforge.net/Docs/Chapter2.html#\2.3.6

;--------------------------------
Var Dialog
Var sysdrive

;--------------------------------
;Interface Configuration

!define MUI_WELCOMEPAGE_TITLE "Welcome to the ${name} setup wizard."
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_RIGHT
!define MUI_HEADERIMAGE_BITMAP Windows-Restart-icon.bmp
# !define MUI_WELCOMEFINISHPAGE_BITMAP Windows-Restart-icon.bmp
!define MUI_UNWELCOMEFINISHPAGE_BITMAP Windows-Restart-icon.bmp
!define MUI_ABORTWARNING
!define MUI_ICON Windows-Restart.ico

UninstallText "This will uninstall ${name}"

;--------------------------------
;Pages

!insertmacro MUI_PAGE_WELCOME
# !insertmacro MUI_PAGE_LICENSE nsis-streambox2\Docs\License.txt
!insertmacro NSD_FUNCTION_INIFILE
# !insertmacro MUI_PAGE_COMPONENTS
# !insertmacro MUI_PAGE_DIRECTORY
# Page custom nsDialogsPage nsDialogsPageLeave
!insertmacro MUI_PAGE_INSTFILES # this macro is the macro that invokes the Sections
# !insertmacro MUI_PAGE_FINISH

!define MUI_WELCOMEPAGE_TITLE "Welcome to Streambox uninstall wizard."
!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
# !insertmacro MUI_UNPAGE_FINISH

;--------------------------------
; Languages

!insertmacro MUI_LANGUAGE "English"

;--------------------------------
; Functions

Function .onInit
	StrCpy $sysdrive $WINDIR 1

	SetAutoClose true
	SetSilent silent

FunctionEnd

Function .onInstSuccess

FunctionEnd

Function UN.onInit
	StrCpy $sysdrive $WINDIR 1

FunctionEnd

Section section1 section_section1

	SetOutPath "$INSTDIR"

	StrCpy $0 '$INSTDIR\Uninstall.exe'
  WriteUninstaller "$0"
  WriteRegStr HKLM 'Software\Microsoft\Windows\CurrentVersion\Uninstall\${name}' UninstallString "$0"
  WriteRegStr HKLM 'Software\Microsoft\Windows\CurrentVersion\Uninstall\${name}' DisplayName '${name} v${version}'
  WriteRegStr HKLM 'Software\Microsoft\Windows\CurrentVersion\Uninstall\${name}' DisplayIcon "$0"
  WriteRegDWORD HKLM 'Software\Microsoft\Windows\CurrentVersion\Uninstall\${name}' NoModify 1

	WriteRegStr HKLM Software\Streambox\add_reboot_icon_to_quicklaunch_bar InstallDir "$INSTDIR"

	File force_reboot_now.exe

	WriteRegStr HKCU Software\Sysinternals\Psshutdown EulaAccepted 1
	File psshutdown.exe

	${If} ${AtMostWinXP}

		CreateShortCut "$APPDATA\Microsoft\Internet Explorer\Quick Launch\Reboot force.lnk" '"$INSTDIR\force_reboot_now.exe"' "" "$INSTDIR\Uninstall.exe"

		File show_quick_launch_in_xp.exe
		exec show_quick_launch_in_xp.exe

	${Else}

		CreateShortCut "$INSTDIR\Reboot force.lnk" '"$INSTDIR\force_reboot_now.exe"' "" "$INSTDIR\Uninstall.exe"

		File ZTIUtility.vbs
		File PinItem\ZTI-SpecialFolderLib.vbs
		File PinItem\PinItem.wsf

		FileOpen $R1 PinItem.cmd w
		FileWrite $R1 '\
			$\r$\n\
			@echo off$\r$\n\
			set ITEM=$\r$\n\
			set TASKBAR=$\r$\n\
			set USAGE=$\r$\n\
			$\r$\n\
			:: Commemt out a line to not use a switch$\r$\n\
			$\r$\n\
			:: set ITEM=/item:"%windir%\System32\calc.exe"$\r$\n\
			:: set ITEM=/item:"%%CSIDL_COMMON_PROGRAMS%%\Accessories\Calculator.lnk"$\r$\n\
			set ITEM=/item:"$INSTDIR\Reboot force.lnk"$\r$\n\
			set TASKBAR=/taskbar$\r$\n\
			:: set USAGE=/?$\r$\n\
			$\r$\n\
			$\r$\n\
			echo on$\r$\n\
			:: Pin to Start Menu$\r$\n\
			cscript //nologo PinItem.wsf %ITEM% %USAGE%$\r$\n\
			$\r$\n\
			:: Pin to Taskbar$\r$\n\
			cscript //nologo PinItem.wsf %ITEM% %TASKBAR% %USAGE%$\r$\n\
			$\r$\n\
			'
		FileWrite $R1 '\
			set ITEM=/item:$SYSDIR\services.msc$\r$\n\
			$\r$\n\
			echo on$\r$\n\
			:: Pin to Start Menu$\r$\n\
			cscript //nologo PinItem.wsf %ITEM% %USAGE%$\r$\n\
			$\r$\n\
			:: Pin to Taskbar$\r$\n\
			cscript //nologo PinItem.wsf %ITEM% %TASKBAR% %USAGE%$\r$\n\
			$\r$\n\
			'
		FileWrite $R1 '\
			set ITEM=/item:$SYSDIR\WF.msc$\r$\n\
			$\r$\n\
			echo on$\r$\n\
			:: Pin to Start Menu$\r$\n\
			cscript //nologo PinItem.wsf %ITEM% %USAGE%$\r$\n\
			$\r$\n\
			:: Pin to Taskbar$\r$\n\
			cscript //nologo PinItem.wsf %ITEM% %TASKBAR% %USAGE%$\r$\n\
			$\r$\n\
			'
		FileWrite $R1 '\
			set ITEM=/item:$SYSDIR\diskmgmt.msc$\r$\n\
			$\r$\n\
			echo on$\r$\n\
			:: Pin to Start Menu$\r$\n\
			cscript //nologo PinItem.wsf %ITEM% %USAGE%$\r$\n\
			$\r$\n\
			:: Pin to Taskbar$\r$\n\
			cscript //nologo PinItem.wsf %ITEM% %TASKBAR% %USAGE%$\r$\n\
			$\r$\n\
			'
		FileWrite $R1 '\
			set ITEM=/item:$SYSDIR\taskschd.msc$\r$\n\
			$\r$\n\
			echo on$\r$\n\
			:: Pin to Start Menu$\r$\n\
			cscript //nologo PinItem.wsf %ITEM% %USAGE%$\r$\n\
			$\r$\n\
			:: Pin to Taskbar$\r$\n\
			cscript //nologo PinItem.wsf %ITEM% %TASKBAR% %USAGE%$\r$\n\
			$\r$\n\
			'
		FileWrite $R1 '\
			set ITEM=/item:$SYSDIR\compmgmt.msc$\r$\n\
			$\r$\n\
			echo on$\r$\n\
			:: Pin to Start Menu$\r$\n\
			cscript //nologo PinItem.wsf %ITEM% %USAGE%$\r$\n\
			$\r$\n\
			:: Pin to Taskbar$\r$\n\
			cscript //nologo PinItem.wsf %ITEM% %TASKBAR% %USAGE%$\r$\n\
			$\r$\n\
			'
		FileWrite $R1 '\
			set ITEM=/item:$SYSDIR\devmgmt.msc$\r$\n\
			$\r$\n\
			echo on$\r$\n\
			:: Pin to Start Menu$\r$\n\
			cscript //nologo PinItem.wsf %ITEM% %USAGE%$\r$\n\
			$\r$\n\
			:: Pin to Taskbar$\r$\n\
			cscript //nologo PinItem.wsf %ITEM% %TASKBAR% %USAGE%$\r$\n\
			$\r$\n\
			'
		FileWrite $R1 '\
			set ITEM=/item:$SYSDIR\lusrmgr.msc$\r$\n\
			$\r$\n\
			echo on$\r$\n\
			:: Pin to Start Menu$\r$\n\
			cscript //nologo PinItem.wsf %ITEM% %USAGE%$\r$\n\
			$\r$\n\
			:: Pin to Taskbar$\r$\n\
			cscript //nologo PinItem.wsf %ITEM% %TASKBAR% %USAGE%$\r$\n\
			$\r$\n\
			'
		FileWrite $R1 '\
			$\r$\n\
			set link=%PROGRAMFILES%\emacs-24.1\bin\runemacs.exe$\r$\n\
			if exist "%link%" ($\r$\n\
				set ITEM=/item:"%link%"$\r$\n\
				$\r$\n\
				echo on$\r$\n\
				:: Pin to Start Menu$\r$\n\
				cscript //nologo PinItem.wsf %ITEM% %USAGE%$\r$\n\
				$\r$\n\
				:: Pin to Taskbar$\r$\n\
				cscript //nologo PinItem.wsf %ITEM% %TASKBAR% %USAGE%$\r$\n\
			)$\r$\n\
			'
		FileWrite $R1 '\
			$\r$\n\
			set link=%SystemDrive%\cygwin\Cygwin2.lnk$\r$\n\
			if exist "%link%" ($\r$\n\
				set ITEM=/item:"%link%"$\r$\n\
				$\r$\n\
				echo on$\r$\n\
				:: Pin to Start Menu$\r$\n\
				cscript //nologo PinItem.wsf %ITEM% %USAGE%$\r$\n\
				$\r$\n\
				:: Pin to Taskbar$\r$\n\
				cscript //nologo PinItem.wsf %ITEM% %TASKBAR% %USAGE%$\r$\n\
			)$\r$\n\
			'
		FileWrite $R1 '\
			$\r$\n\
			set link=%SystemRoot%\System32\eventvwr.msc$\r$\n\
			if exist "%link%" ($\r$\n\
				set ITEM=/item:"%link%"$\r$\n\
				$\r$\n\
				echo on$\r$\n\
				:: Pin to Start Menu$\r$\n\
				cscript //nologo PinItem.wsf %ITEM% %USAGE%$\r$\n\
				$\r$\n\
				:: Pin to Taskbar$\r$\n\
				cscript //nologo PinItem.wsf %ITEM% %TASKBAR% %USAGE%$\r$\n\
			)$\r$\n\
			'
		FileWrite $R1 '\
			$\r$\n\
			set link=%SystemDrive%\Apache2.2\bin\httpd.exe$\r$\n\
			if exist "%link%" ($\r$\n\
				set ITEM=/item:"%link%"$\r$\n\
				$\r$\n\
				echo on$\r$\n\
				:: Pin to Start Menu$\r$\n\
				cscript //nologo PinItem.wsf %ITEM% %USAGE%$\r$\n\
				$\r$\n\
				:: Pin to Taskbar$\r$\n\
				cscript //nologo PinItem.wsf %ITEM% %TASKBAR% %USAGE%$\r$\n\
			)$\r$\n\
			'
		FileWrite $R1 '\
			$\r$\n\
			set link=%SystemDrive%\Apache\bin\httpd.exe$\r$\n\
			if exist "%link%" ($\r$\n\
				set ITEM=/item:"%link%"$\r$\n\
				$\r$\n\
				echo on$\r$\n\
				:: Pin to Start Menu$\r$\n\
				cscript //nologo PinItem.wsf %ITEM% %USAGE%$\r$\n\
				$\r$\n\
				:: Pin to Taskbar$\r$\n\
				cscript //nologo PinItem.wsf %ITEM% %TASKBAR% %USAGE%$\r$\n\
			)$\r$\n\
			'
		FileClose $R1

		# See PinItem/PinItem.cmd for usage paramaters/example
		nsExec::ExecToStack '"$SYSDIR\cmd.exe" /c PinItem.cmd'

	${EndIf}

SectionEnd

Section misc section_misc
	${If} ${AtLeastWin7}
		; http://www.sevenforums.com/tutorials/741-taskbar-use-small-large-icons.html
		; Make taskbar icons small.  Doesn't take effect till logout, then login
		WriteRegDWORD HKCU Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced TaskbarSmallIcons 1
	${EndIf}
SectionEnd

Section uninstall section_uninstall

	SetAutoClose true
	SetShellVarContext current

	${If} ${AtMostWinXP}
		Delete "$APPDATA\Microsoft\Internet Explorer\Quick Launch\Reboot force.lnk"
	${Else}
		Delete "$APPDATA\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\Reboot force.lnk"
	${EndIf}

	rmdir /r '$INSTDIR'

	DeleteRegKey HKCU Software\Sysinternals\Psshutdown
	DeleteRegKey HKLM 'Software\Streambox\${name}'
	DeleteRegKey /ifempty HKLM 'Software\Streambox'

	# Remove from microsoft Add/remove Programs applet
  DeleteRegKey HKLM 'Software\Microsoft\Windows\CurrentVersion\Uninstall\${name}'
SectionEnd

UninstallIcon Windows-Restart.ico

;--------------------------------
; this must remain after the Section definitions

LangString DESC_section1 ${LANG_ENGLISH} "Description of section 1."
LangString DESC_section2 ${LANG_ENGLISH} "Description of section 2."

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
	!insertmacro MUI_DESCRIPTION_TEXT ${section_section1} $(DESC_section1)
!insertmacro MUI_FUNCTION_DESCRIPTION_END

# Emacs vars
# Local Variables: ***
# comment-column:0 ***
# tab-width: 2 ***
# comment-start:"# " ***
# End: ***
