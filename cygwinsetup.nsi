!include MUI2.NSH
!include nsDialogs.nsh
!include LogicLib.nsh
!include FileFunc.nsh

Name cygwinsetup
OutFile ${outfile}

XPStyle on
ShowInstDetails show
ShowUninstDetails show
RequestExecutionLevel admin
Caption "Streambox $(^Name) Installer"

!define emacs-version 23.4
!define emacs-zip emacs-${emacs-version}-bin-i386.zip
!define msysgit-installer PortableGit-1.7.4-preview20110204.7z

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
Page custom nsDialogsPage nsDialogsPageLeave
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
FunctionEnd

Function .onInstSuccess

FunctionEnd


Function nsDialogsPage
	nsDialogs::Create 1018
	Pop $Dialog

	${If} $Dialog == error
		Abort
	${EndIf}

	nsDialogs::Show

FunctionEnd


Function nsDialogsPageLeave

FunctionEnd


Function UN.onInit

FunctionEnd



UninstallIcon nsis-streambox2\Icons\Streambox_128.ico

Section Uninstall

	rmdir /r "$PROGRAMFILES\cygwin-setup"
	DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Streamboxcygwin-setup"
SectionEnd


Section "Section Name 1" Section1

	SetOutPath $TEMP\cygwin-setup
	# for debug
	ReadINIStr $0 $TEMP\sbversions.ini cygwin-setup debug
	IntCmp $0 1 0 +5
		nsExec::ExecToStack '"explorer" $TEMP\cygwin-setup'
		pop $0
		nsExec::ExecToStack '"cmd" /k cd $TEMP\cygwin-setup'
		pop $0

	SetOverwrite off

	exec '"cmd" /k ipconfig|more'

	DetailPrint "you have 30 seconds to enter credentials for \\10.0.2.10\Production"
	nsExec::ExecToStack /timeout=30000 \
		'"cmd" /c start \\10.0.2.10\Production'

	SetOutPath $TEMP\cygwin-setup
	File 7za.exe
	File pathman.exe
	File wget.exe
	File robocopy.exe
	File home-pull.sh

	SetOutPath $PROGRAMFILES\Tools
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
	nsExec::ExecToStack '"$PROGRAMFILES\Tools\bginfo.exe" \
		$\"$PROGRAMFILES\Tools\bginfo.bgi$\" /timer:0'

	# debug
	ReadINIStr $0 $TEMP\sbversions.ini cygwin-setup debug
	IntCmp $0 1 0 +3
	nsExec::ExecToStack '"$PROGRAMFILES\Tools\regjump.exe" \
		HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run'
	pop $0


	SetShellVarContext current
	CreateShortCut "$FAVORITES\Program Files.lnk"				$PROGRAMFILES
	CreateShortCut "$FAVORITES\Git.lnk"									$PROGRAMFILES\Git
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

	##############################
	# emacs
	##############################
	FileOpen $R1 $TEMP\cygwin-setup\emacs-setup.bat w
	FileWrite $R1 '\
	@echo on$\r$\n\
	if exist "$PROGRAMFILES\emacs-${emacs-version}\NUL" goto emacs_install_done$\r$\n\
	if exist \\10.0.2.10\it\software\emacs\${emacs-zip} ($\r$\n\
		$TEMP\cygwin-setup\robocopy \\10.0.2.10\it\software\emacs $TEMP\cygwin-setup ${emacs-zip} /r:5 /w:3$\r$\n\
		$\r$\n\
	) else ($\r$\n\
		$TEMP\cygwin-setup\wget.exe ^$\r$\n\
		--no-clobber ^$\r$\n\
		--directory-prefix=$TEMP\cygwin-setup ^$\r$\n\
		http://ftp.gnu.org/gnu/emacs/windows/${emacs-zip}	$\r$\n\
		cmd /c start $TEMP\cygwin-setup\robocopy $TEMP\cygwin-setup //10.0.2.10/it/software/emacs ${emacs-zip} /r:5 /w:3$\r$\n\
	)$\r$\n\
	$\r$\n\
	$TEMP\cygwin-setup\7za.exe x -y -o"$PROGRAMFILES" $TEMP\cygwin-setup\${emacs-zip}$\r$\n\
	:: Add emacs bin to user env path$\r$\n\
	$TEMP\cygwin-setup\pathman.exe /au "$PROGRAMFILES\emacs-${emacs-version}\bin"$\r$\n\
	:emacs_install_done$\r$\n\
	cmd /c start "$PROGRAMFILES\emacs-${emacs-version}\bin\runemacs.exe"$\r$\n\
	$\r$\n\
	'
	FileClose $R1
	exec '"cmd" /c $TEMP\cygwin-setup\emacs-setup.bat'

	##############################
	# msysgit
	##############################
	SetOutPath $TEMP\cygwin-setup
	FileOpen $R1 $TEMP\cygwin-setup\msysgit-setup.bat w
	FileWrite $R1 '@echo on$\r$\n\
	if exist "$PROGRAMFILES\Git\NUL" goto msysgit_install_done$\r$\n\
	if exist \\10.0.2.10\it\software\Git\${msysgit-installer} ($\r$\n\
		$TEMP\cygwin-setup\robocopy \\10.0.2.10\it\software\Git $TEMP\cygwin-setup ${msysgit-installer} /r:5 /w:3$\r$\n\
		$\r$\n\
	) else ($\r$\n\
		$TEMP\cygwin-setup\wget.exe ^$\r$\n\
		--no-clobber ^$\r$\n\
		--directory-prefix=$TEMP\cygwin-setup ^$\r$\n\
		http://msysgit.googlecode.com/files/${msysgit-installer} $\r$\n\
		cmd /c start $TEMP\cygwin-setup\robocopy $TEMP\cygwin-setup //10.0.2.10/it/software/Git ${msysgit-installer} /r:5 /w:3$\r$\n\
	)$\r$\n\
	$\r$\n\
	$TEMP\cygwin-setup\7za.exe x -y -o"$PROGRAMFILES\Git" $TEMP\cygwin-setup\${msysgit-installer}$\r$\n\
	:: Add git bin to user env path$\r$\n\
	:: taylor$\r$\n\
	$TEMP\cygwin-setup\pathman.exe /au "$PROGRAMFILES\Git\bin"$\r$\n\
	:: taylor$\r$\n\
	:msysgit_install_done$\r$\n\
	copy /y %TEMP%\cygwin-setup\home-pull.sh "%programfiles%\Git"$\r$\n\
	cd "%programfiles%\Git"$\r$\n\
	cmd /k git-bash.bat$\r$\n\
	$\r$\n\
	'
	FileClose $R1
	exec '"cmd" /c $TEMP\cygwin-setup\msysgit-setup.bat'

	##############################
	# cygwin
	##############################
	IfFileExists $TEMP\cygwin-setup\setup.exe download_done 0
		DetailPrint 'Downloading cygwin setup.exe'
		nsExec::ExecToStack \
			/timeout=10000 \
			'$TEMP\cygwin-setup\wget.exe \
			--no-clobber \
			--directory-prefix=$TEMP\cygwin-setup \
			http://cygwin.com/setup.exe'
		pop $0
	download_done:

	IfFileExists $TEMP\cygwin-setup\setup.exe +4 0
		File setup.exe
		nsExec::ExecToStack \
			/timeout=10000 \
			'cmd /c start /min http://cygwin.com/setup.exe'
		pop $0

	SetOutPath '$PROGRAMFILES\cygwininstall'
	CopyFiles $TEMP\cygwin-setup\setup.exe \
		'$PROGRAMFILES\cygwininstall'

	SetOutPath $sysdrive\cygwin\etc\setup
	SetOverwrite off
	File installed.db

	##############################
	#
	##############################
	CreateDirectory $sysdrive\cygwin\packages
	IfFileExists \\10.0.2.10\it\software\cygwin\packages 0 +2
		nsExec::ExecToStack '$TEMP\cygwin-setup\robocopy \
			//10.0.2.10/it/software/cygwin/packages \
			$sysdrive\cygwin\packages \
			/xf setup.log \
			/xf setup.log.full \
			/r:5 /r:10 /w:30 /mir'

	${GetSize} $sysdrive\cygwin\packages "/S=0M /G=1" $0 $1 $2
	DetailPrint "$sysdrive\cygwin\packages has $0 MB"
	WriteINIStr $TEMP\sbversions.ini cygwin-setup packages_size_reminder \
		"Size is in MB"
	WriteINIStr $TEMP\sbversions.ini cygwin-setup packages_size $0


	# 5MB
	${If} $0 < 5
		nsExec::ExecToStack '"cmd" /c start /min $sysdrive\cygwin\packages'
		pop $0
		# cmd /c "%programfiles%\cygwinInstall\setup.exe" --download --no-desktop --local-package-dir c:\cygwin\packages --quiet-mode --site http://cygwin.mirrors.pair.com
		DetailPrint 'Downloading packages specified \
			in $sysdrive\cygwin\etc\setup\installed.db'
		ExecWait \
			'$PROGRAMFILES\cygwinInstall\setup.exe \
			--download \
			--no-desktop \
			--local-package-dir $sysdrive\cygwin\packages \
			--quiet-mode \
			--site http://cygwin.mirrors.pair.com'
		IfFileExists \\10.0.2.10\it\software\cygwin\packages +2 0
			exec '"cmd" /c start $TEMP\cygwin-setup\robocopy \
				$sysdrive\cygwin\packages \
				//10.0.2.10/it/software/cygwin/packages \
				/xf setup.log \
				/xf setup.log.full \
				/r:5 /w:3 /mir'
	${EndIf}


	IfFileExists $sysdrive\cygwin\Cygwin.bat cygwin_install_done 0
		DetailPrint 'Installing cygwin packages...'
		# cmd /k "%programfiles%\cygwinInstall\setup.exe" --local-install --quiet-mode --local-package-dir c:\cygwin\packages
		ExecWait \
			'$PROGRAMFILES\cygwinInstall\setup.exe \
			--local-install \
			--no-shortcuts \
			--quiet-mode \
			--local-package-dir $sysdrive\cygwin\packages'

		SetShellVarContext current
		CreateShortCut "$QUICKLAUNCH\Bash.lnk" \
			$sysdrive\Cygwin\Cygwin.bat \
			"" \
			"$sysdrive\Cygwin\Cygwin.ico" \
			"" \
			SW_SHOWNORMAL \
			ALT|CONTROL|SHIFT|F5 "Cygwin"
		CreateShortCut "$FAVORITES\CygwinSetup.lnk" "%programfiles%\cygwininstall"
		CreateShortCut "$FAVORITES\CygwinHome.lnk" "$sysdrive\Cygwin\home"
	cygwin_install_done:

	# add c:\cygwin\bin to %path%
	ReadRegStr $2 HKLM Software\Cygwin\setup rootdir
	nsExec::ExecToStack \
		'$TEMP\cygwin-setup\pathman /au $2\bin'

SectionEnd

Section download_taylor_specific_settings section_download_taylor_specific_settings

	# Create $sysdrive\cygwin\home\%USERNAME%, download
	# http://69.90.235.86/o.zip and expand it into
	# $sysdrive\cygwin\home\%USERNAME%

	ExpandEnvStrings $0 "$sysdrive\cygwin\home\%USERNAME%"
	CreateDirectory $0 # c:\cygwin\home\Administrator (for example)

	FileOpen $R1 $TEMP\cygwin-setup\taylor-specific-setup.bat w
	FileWrite $R1 '\
	@echo on$\r$\n\
	if exist \\10.0.2.10\taylor.monacelli\o.zip ($\r$\n\
		$TEMP\cygwin-setup\robocopy \\10.0.2.10\taylor.monacelli $TEMP\cygwin-setup o.zip /r:5 /w:3$\r$\n\
		$\r$\n\
	) else ($\r$\n\
		$TEMP\cygwin-setup\wget.exe ^$\r$\n\
		--no-clobber ^$\r$\n\
		--directory-prefix=$TEMP\cygwin-setup ^$\r$\n\
		http://69.90.235.86/o.zip$\r$\n\
		cmd /c start $TEMP\cygwin-setup\robocopy $TEMP\cygwin-setup //10.0.2.10/taylor.monacelli o.zip /r:5 /w:3$\r$\n\
	)$\r$\n\
	$\r$\n\
	$TEMP\cygwin-setup\7za.exe x -y -o"$0" $TEMP\cygwin-setup\o.zip$\r$\n\
	'
	FileClose $R1
	exec '"$SYSDIR\cmd.exe" /c $TEMP\cygwin-setup\taylor-specific-setup.bat'

SectionEnd

Section -cleanup section_cleanup
	ReadINIStr $0 $TEMP\sbversions.ini cygwin-setup debug
	${If} 1 != $0
		rmdir /r '$TEMP\cygwin-setup'
	${EndIf}
SenctionEnd

;--------------------------------
; this must remain after the Section definitions

LangString DESC_Section1 ${LANG_ENGLISH} "Description of section 1."
LangString DESC_Section2 ${LANG_ENGLISH} "Description of section 2."

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
	!insertmacro MUI_DESCRIPTION_TEXT ${Section1} $(DESC_Section1)
	!insertmacro MUI_DESCRIPTION_TEXT ${Section2} $(DESC_Section2)
!insertmacro MUI_FUNCTION_DESCRIPTION_END

# Emacs vars
# Local Variables: ***
# comment-column:0 ***
# tab-width: 2 ***
# comment-start:"# " ***
# End: ***
