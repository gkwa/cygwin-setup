!include MUI2.NSH
!include nsDialogs.nsh
!include LogicLib.nsh
!include FileFunc.nsh
!include x64.nsh

Name cygwinsetup
OutFile ${outfile}

XPStyle on
ShowInstDetails show
ShowUninstDetails show
RequestExecutionLevel admin
Caption "Streambox $(^Name) Installer"

;--------------------------------
; docs
# http://nsis.sourceforge.net/Docs
# http://nsis.sourceforge.net/Macro_vs_Function
# http://nsis.sourceforge.net/Adding_custom_installer_pages
# http://nsis.sourceforge.net/ConfigWrite
# loops
# http://nsis.sourceforge.net/Docs/Chapter2.html#\2.3.6

;--------------------------------
var setup_exe
Var sysdrive
var cygwin_rootdir

;--------------------------------
;Interface Configuration

!define MUI_WELCOMEPAGE_TITLE "Welcome to the Streambox setup wizard."
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_RIGHT
!define MUI_HEADERIMAGE_BITMAP nsis-streambox2\Graphics\sblogo.bmp
!define MUI_WELCOMEFINISHPAGE_BITMAP nsis-streambox2\Graphics\sbside.bmp
!define MUI_UNWELCOMEFINISHPAGE_BITMAP nsis-streambox2\Graphics\sbside.bmp
!define MUI_ABORTWARNING
!define MUI_ICON nsis-streambox2\Icons\Streambox_128.ico

UninstallIcon nsis-streambox2\Icons\Streambox_128.ico
UninstallText "This will uninstall cygwin-setup"

;--------------------------------
;Pages

!insertmacro MUI_PAGE_WELCOME
# !insertmacro MUI_PAGE_LICENSE nsis-streambox2\Docs\License.txt
#!insertmacro NSD_FUNCTION_INIFILE
#!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_INSTFILES # this macro is the macro that invokes the Sections
!insertmacro MUI_LANGUAGE "English"


;--------------------------------
; Functions

Function .onInit
	${GetRoot} $WINDIR $sysdrive

	SetOutPath $TEMP\cygwin\setup
	WriteINIStr $TEMP\sbversions.ini cygwin-setup debug 0
	${GetParameters} $0
	ClearErrors
	${GetOptions} $0 '/debug' $1
	${IfNot} ${Errors}
		WriteINIStr $TEMP\sbversions.ini cygwin-setup debug 1
	${EndIf}

	SetOutPath $TEMP\cygwin\setup
	${If} ${RunningX64}
		File setup-x86_64.exe
		StrCpy $setup_exe setup-x86_64.exe
	${Else}
		File setup-x86.exe
		StrCpy $setup_exe setup-x86.exe
	${EndIf}

	StrCpy $cygwin_rootdir $sysdrive\cygwin
	${If} ${RunningX64}
		StrCpy $cygwin_rootdir $sysdrive\cygwin64
	${EndIf}

FunctionEnd

Function .onInstSuccess
FunctionEnd

Section "Section Name 1" Section1

	SetOutPath $TEMP\cygwin-setup
	# for debug
	ReadINIStr $0 $TEMP\sbversions.ini cygwin-setup debug
	IntCmp $0 1 0 +5
		nsExec::ExecToLog '"explorer" $TEMP\cygwin-setup'
		pop $0
		nsExec::ExecToLog '"cmd" /k cd $TEMP\cygwin-setup'
		pop $0


	exec '"cmd" /k ipconfig|more'

	SetOutPath $TEMP\cygwin-setup
	File 7za.exe
	File pathman.exe
	File wget.exe
	File robocopy.exe

	SetOutPath '$PROGRAMFILES\Tools'
	File bginfo.exe
	File bginfo.bgi
	File regjump.exe

	#reg add HKEY_CURRENT_USER\Software\Sysinternals\Junction /t REG_DWORD /v EulaAccepted /d 1 /f
	WriteRegStr \
		HKCU \
		Software\Sysinternals\bginfo \
		EulaAccepted \
		1
	WriteRegStr \
		HKCU \
		Software\Sysinternals\Regjump \
		EulaAccepted \
		1

	##############################
	# bginfo
	##############################
	#	cmd /c reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run" /t REG_SZ /v bginfo /d "bginfo \bginfo.bgi /timer:0" /f
	WriteRegStr \
		HKLM \
		Software\Microsoft\Windows\CurrentVersion\Run \
		bginfo \
		'$\"$PROGRAMFILES\Tools\bginfo.exe$\" $\"$PROGRAMFILES\Tools\bginfo.bgi$\" /timer:0'
	nsExec::ExecToLog '"$PROGRAMFILES\Tools\bginfo.exe" \
		$\"$PROGRAMFILES\Tools\bginfo.bgi$\" /timer:0'

	# debug
	ReadINIStr $0 $TEMP\sbversions.ini cygwin-setup debug
	IntCmp $0 1 0 +3
	nsExec::ExecToLog '"$PROGRAMFILES\Tools\regjump.exe" \
		HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run'
	pop $0


	SetShellVarContext current
	CreateShortCut "$FAVORITES\Program Files.lnk"				$PROGRAMFILES
	CreateShortCut "$FAVORITES\Temp.lnk" 						$TEMP

	# fixme: this blocks if \\10.0.2.10 isn't available...I think
	# CreateShortCut "$FAVORITES\Beta.lnk" 						\\10.0.2.10\Production\Streambox\Beta
	# CreateShortCut "$FAVORITES\Production.lnk" 			\\10.0.2.10\Production
	# CreateShortCut "$FAVORITES\Software.lnk" 				\\10.0.2.10\it\software
	# CreateShortCut "$FAVORITES\CygwinPackages.lnk"  \\10.0.2.10\it\software\cygwin\packages
	# CreateShortCut "$FAVORITES\Streambox.lnk" 			\\10.0.2.10\Production\Streambox
	# CreateShortCut "$FAVORITES\TaylorHome.lnk" 			\\10.0.2.10\taylor.monacelli
	# CreateShortCut "$FAVORITES\TaylorTrash.lnk" 		\\10.0.2.10\taylor.monacelli\trash
	# CreateShortCut "$FAVORITES\Tools.lnk" 					\\10.0.2.10\Development\tools

	exec '"explorer" $FAVORITES'

	SetOutPath $TEMP\cygwin-setup

	##############################
	# cygwin
	##############################
	IfFileExists $TEMP\cygwin-setup\$setup_exe download_done 0
		DetailPrint 'Downloading cygwin $setup_exe'
		nsExec::ExecToLog \
			/timeout=10000 \
			'$TEMP\cygwin-setup\wget.exe \
			--no-clobber \
			--directory-prefix=$TEMP\cygwin-setup \
			http://www.cygwin.com/$setup_exe'
		pop $0
	download_done:

	IfFileExists $TEMP\cygwin-setup\$setup_exe +5
		DetailPrint 'Initiating manual download with default browser'
		nsExec::ExecToLog \
			/timeout=10000 \
			'cmd /c start /min http://cygwin.com/$setup_exe'
		pop $0

	CreateDirectory '$PROGRAMFILES\cygwinInstall'
	SetOutPath '$PROGRAMFILES\cygwinInstall'
	CopyFiles $TEMP\cygwin-setup\$setup_exe \
		'$PROGRAMFILES\cygwinInstall'

	SetOutPath $cygwin_rootdir\etc\setup
	File installed.db

	##############################
	#
	##############################
	CreateDirectory $cygwin_rootdir\packages

	${GetSize} $cygwin_rootdir\packages "/S=0M /G=1" $0 $1 $2
	DetailPrint "$cygwin_rootdir\packages has $0 MB"
	WriteINIStr $TEMP\sbversions.ini cygwin-setup packages_size_reminder \
		"Size is in MB"
	WriteINIStr $TEMP\sbversions.ini cygwin-setup packages_size $0


	# 5MB
	${If} $0 < 5
		nsExec::ExecToLog '"cmd" /c start /min $cygwin_rootdir\packages'
		pop $0
		# cmd /c "%programfiles%\cygwinInstall\$setup_exe" --download --no-desktop --local-package-dir $cygwin_rootdir\packages --quiet-mode --site http://cygwin.mirrors.pair.com
		DetailPrint 'Downloading packages specified \
			in $cygwin_rootdir\etc\setup\installed.db'
		ExecWait \
			'$PROGRAMFILES\cygwinInstall\$setup_exe \
			--download \
			--no-desktop \
			--local-package-dir $cygwin_rootdir\packages \
			--quiet-mode \
			--site http://cygwin.mirror.constant.com\
		'
	${EndIf}


	IfFileExists $cygwin_rootdir\Cygwin.bat cygwin_install_done 0
		DetailPrint 'Installing cygwin packages...'
		# cmd /k "%programfiles%\cygwinInstall\$setup_exe" --local-install --quiet-mode --local-package-dir $cygwin_rootdir\packages
		ExecWait \
			'$PROGRAMFILES\cygwinInstall\$setup_exe \
			--local-install \
			--no-shortcuts \
			--quiet-mode \
			--local-package-dir $cygwin_rootdir\packages'

		SetShellVarContext current
		FileOpen $R1 $cygwin_rootdir\Cygwin2.bat w
		FileWrite $R1 "\
			@echo off$\r$\n\
			$sysdrive$\r$\n\
			chdir $cygwin_rootdir\bin$\r$\n\
			start mintty -$\r$\n"
		FileClose $R1
		CreateShortCut "$cygwin_rootdir\Cygwin2.lnk" \
			"$SYSDIR\cmd.exe" \
			"/c $cygwin_rootdir\Cygwin2.bat" \
			"$cygwin_rootdir\bin\mintty.exe"

		Delete "$QUICKLAUNCH\Bash.lnk"
		CopyFiles $cygwin_rootdir\Cygwin2.lnk "$QUICKLAUNCH"

		CreateShortCut "$FAVORITES\CygwinSetup.lnk" "%programfiles%\cygwinInstall"
		CreateShortCut "$FAVORITES\CygwinHome.lnk" "$cygwin_rootdir\home"
	cygwin_install_done:

	# add $cygwin_rootdir\bin to %path%
	nsExec::ExecToLog \
		'$TEMP\cygwin-setup\pathman /au $cygwin_rootdir\bin'

SectionEnd

Section s3-curl-install section_s3-curl-install

	DetailPrint "Debug: beginning section_s3-curl-install"
	SetOutPath '$cygwin_rootdir\tmp'
	ExpandEnvStrings $0 %COMSPEC%
	DetailPrint "Debug: ready to deploy s3-curl-install-parent.bat"
	File s3-curl-install-parent.bat
	File s3-curl-install.sh
	nsExec::ExecToLog '"$0" /c s3-curl-install-parent.bat'

SectionEnd

Section disable-motd section_disable-motd

	DetailPrint "Disabling Motd"
	Rename '$cygwin_rootdir\etc\motd' '$cygwin_rootdir\etc\motd.bak'
	FileOpen $R1 '$cygwin_rootdir\etc\motd' w
	FileWrite $R1 ''
	FileClose $R1

SectionEnd

Section Compile_bup section_compile_bup

	SetOutPath '$cygwin_rootdir\tmp'
	ExpandEnvStrings $0 %COMSPEC%
	File compile_bup_parent.bat
	File compile_bup.sh
	nsExec::ExecToLog '"$0" /c compile_bup_parent.bat'

SectionEnd

Section download_taylor_specific_settings section_download_taylor_specific_settings

	# Create $cygwin_rootdir\home\%USERNAME%, download
	# http://taylors-bucket.s3.amazonaws.com/o.zip and expand it into
	# $cygwin_rootdir\home\%USERNAME%

	ExpandEnvStrings $0 "$cygwin_rootdir\home\%USERNAME%"

	DetailPrint "Create ~/bin"
	SetOutPath '$0\bin'
	File pathman.exe
	File robocopy.exe

	SetOutPath '$0' # $cygwin_rootdir\home\Administrator (for example)

	FileOpen $R1 home_current_user.bat w
	FileWrite $R1 '\
		@echo on$\r$\n\
		REM -*- bat -*-$\r$\n\
		$\r$\n\
		set homedir=$cygwin_rootdir\home\%USERNAME%$\r$\n\
		$\r$\n\
		setx.exe HOME "%homedir%"$\r$\n\
		reg query hkcu\environment /v HOME$\r$\n\
		setx.exe HOMEPATH "%homedir%"$\r$\n\
		reg query hkcu\environment /v HOMEPATH$\r$\n\
		pause$\r$\n\
	'
	FileClose $R1

	FileOpen $R1 add_path_to_cygwin.bat w
	FileWrite $R1 '\
		@echo on$\r$\n\
		REM -*- bat -*-$\r$\n\
		$\r$\n\
		echo.before path update:$\r$\n\
		rem setx.exe PATH "$cygwin_rootdir\bin;%PATH%"$\r$\n\
		echo.after path update:$\r$\n\
		rem reg query hkcu\environment /v PATH$\r$\n\
		pause$\r$\n\
	'
	FileClose $R1

	FileOpen $R1 add_path_to_home_bin.bat w
	FileWrite $R1 '\
		@echo on$\r$\n\
		REM -*- bat -*-$\r$\n\
		$\r$\n\
		echo.before path update:$\r$\n\
		rem reg query hkcu\environment /v PATH$\r$\n\
		rem setx.exe PATH "$0\bin;%PATH%"$\r$\n\
		echo.after path update:$\r$\n\
		rem reg query hkcu\environment /v PATH$\r$\n\
		pause$\r$\n\
	'
	FileClose $R1

	ExpandEnvStrings $0 "$cygwin_rootdir\home\%USERNAME%"
	ExpandEnvStrings $1 %COMSPEC%
	Exec '"$1" /c start /min "$WINDIR\explorer.exe" "$0"'

	##############################
	# replace syslogd with syslogd-ng
	##############################
	SetOutPath '$cygwin_rootdir\tmp'

	File syslogng_parent.bat
	File syslogng.sh
	ExpandEnvStrings $1 %COMSPEC%
	nsExec::ExecToLog '"$1" /c "$cygwin_rootdir\tmp\syslogng_parent.bat"'

	##############################
	# set fstab before sshd setup
	##############################

	SetOutPath $TEMP\cygwin\setup
	File tiny_perl_installer\perl58.dll
	File tiny_perl_installer\lib.zip
	File configure_fstab.exe

	# Make sure to keep this fstab configuration _before_ cyg_server's
	# profile is created as long as you're using priviledged separation
	# (ssh-host-config --user cyg_server --privileged...)
	nsExec::ExecToLog '"configure_fstab.exe" "$cygwin_rootdir\etc\fstab"'

	##############################
	# sshd-auto-setup
	##############################
	SetOutPath $TEMP\cygwin-setup

	File sshd-auto-setup-controller.cmd
	File sshd-auto-setup.sh
	ExpandEnvStrings $1 %COMSPEC%
	nsExec::ExecToLog '"$1" /c "$TEMP\cygwin-setup\sshd-auto-setup-controller.cmd"'

	##############################

	ExpandEnvStrings $0 "$cygwin_rootdir\home\%USERNAME%"
	WriteINIStr '$TEMP\cygwin-setup\debug_variables_log.txt' DEBUG USER_HOME_DIR2 '$0'
	SetOutPath '$0'
	ExpandEnvStrings $1 %COMSPEC%
	nsExec::ExecToLog '"$1" /c "$0\add_path_to_cygwin.bat"'
	nsExec::ExecToLog '"$1" /c "$0\home_current_user.bat"'
	nsExec::ExecToLog '"$1" /c "$0\add_path_to_home_bin.bat"'

	##############################
	# get dotfiles from github

	ExpandEnvStrings $0 "$cygwin_rootdir\home\%USERNAME%"
	SetOutPath '$0'
	File dotfiles-install.sh
	nsExec::ExecToLog '"$cygwin_rootdir\bin\sh.exe" -x dotfiles-install.sh'

	# ------------------------------
	# Now that dotfiles are installed, start emacs so that emacs will start
	# downloading melpa packages based off my .emacs settings
	SetOutPath '$cygwin_rootdir\tmp'

	FileOpen $R1 '$cygwin_rootdir\tmp\start_emacs.bat' w
	FileWrite $R1 '\
		@Echo on$\r$\n\
		$\r$\n\
		set PATH=$cygwin_rootdir\bin;%PATH%$\r$\n\
		$\r$\n\
		chdir $cygwin_rootdir\bin$\r$\n\
		start mintty emacs$\r$\n\
	'
	FileClose $R1
	ExpandEnvStrings $1 %COMSPEC%
	nsExec::Exec '"$1" /c "$cygwin_rootdir\tmp\start_emacs.bat"'
	# ------------------------------
	##############################

	SetShellVarContext current
	CreateShortCut "$DESKTOP\Cygwin Setup Temp.lnk" "$TEMP\cygwin-setup"

	SetShellVarContext current
	CreateShortCut "$DESKTOP\Startup.lnk" '$SMSTARTUP'

SectionEnd

Section -chere section_chere
	; Adds explorer context menu to open bash to current folder
	ReadRegStr $0 HKLM Software\Cygwin\setup rootdir
	SetOutPath $0\bin
	nsExec::ExecToLog '"mintty" --exec chere --arguments=$\"-i -n -t mintty -e "Bash prompt here"$\"'
SectionEnd

Section -last_install section_last_install

	; Keep add_reboot_icon_to_quicklaunch_bar.exe running last because it
	; looks for hard coded paths to shortcuts to pin to the quicklaunch bar
	; and taskbar.  If those shortcuts don't exist before running
	; add_reboot_icon_to_quicklaunch_bar.exe, then it cant create these
	; quicklaunch and taskbar shortcuts.

	SetOutPath $TEMP\cygwin-setup
	File add_reboot_icon_to_quicklaunch_bar\add_reboot_icon_to_quicklaunch_bar.exe
	nsExec::Exec add_reboot_icon_to_quicklaunch_bar.exe

SectionEnd

Section -cleanup section_cleanup

	FileOpen $R1 $TEMP\cygwin-setup-cleanup.bat w
	FileWrite $R1 '\
		@echo on$\r$\n\
		cd $TEMP$\r$\n\
		rd /q /s cygwin-setup$\r$\n\
	'
	FileClose $R1
	WriteRegStr HKLM SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce 'cygwin-setup-cleanup' '$TEMP\cygwin-setup-cleanup.bat'

	ReadINIStr $0 $TEMP\sbversions.ini cygwin-setup debug
	${If} 1 == $0
		nsExec::ExecToLog '"explorer" "$TEMP\cygwin-setup"'
	${EndIf}
SectionEnd

;--------------------------------
; this must remain after the Section definitions

LangString DESC_Section1 ${LANG_ENGLISH} "Description of section 1."
LangString DESC_Section2 ${LANG_ENGLISH} "Description of section 2."

# !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
# 	!insertmacro MUI_DESCRIPTION_TEXT ${Section1} $(DESC_Section1)
# 	!insertmacro MUI_DESCRIPTION_TEXT ${Section2} $(DESC_Section2)
# !insertmacro MUI_FUNCTION_DESCRIPTION_END

# Emacs vars
# Local Variables: ***
# comment-column:0 ***
# tab-width: 2 ***
# comment-start:"# " ***
# End: ***
