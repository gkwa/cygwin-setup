!include MUI2.NSH
!include nsDialogs.nsh
!include LogicLib.nsh
!include FileFunc.nsh

Name cygwinsetup
OutFile cygwinsetup.exe

XPStyle on
ShowInstDetails show
ShowUninstDetails show
RequestExecutionLevel admin
Caption "Streambox $(^Name) Installer"

!define emacs-version 23.2
!define emacs-zip emacs-${emacs-version}-bin-i386.zip

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
	${GetOptions} $0 '-debug' $1
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

	# for debug
  ReadINIStr $0 $TEMP\sbversions.ini cygwin-setup debug
	IntCmp $0 1 0 +5
		nsExec::ExecToStack '"explorer" $TEMP\cygwin-setup'
		pop $0
		nsExec::ExecToStack '"cmd" /k cd $TEMP\cygwin-setup'
		pop $0

	SetOverwrite off

	exec '"cmd" /k ipconfig'	

  iffileexists "\\10.0.2.10\Production" 0 +2
  exec '"cmd" /c start \\10.0.2.10\Production'

	SetOutPath $TEMP\cygwin-setup
	File 7za.exe
	File pathman.exe
	File wget.exe
	File robocopy.exe

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
		"$PROGRAMFILES\Tools\bginfo.bgi $\"$PROGRAMFILES\Tools\bginfo.exe$\" /timer:0"
	nsExec::ExecToStack '"$PROGRAMFILES\Tools\bginfo.exe" \
		$\"$PROGRAMFILES\Tools\bginfo.bgi$\" /timer:0'
		
	# debug
  ReadINIStr $0 $TEMP\sbversions.ini cygwin-setup debug
	IntCmp $0 1 0 +3
	nsExec::ExecToStack '"$PROGRAMFILES\Tools\regjump.exe" \
		HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run'
	pop $0


	SetShellVarContext current
	CreateShortCut "$FAVORITES\Beta.lnk" 						"\\10.0.2.10\Production\Streambox\Beta"
	CreateShortCut "$FAVORITES\Production.lnk" 			"\\10.0.2.10\Production"
	CreateShortCut "$FAVORITES\Program Files"			  "$PROGRAMFILES"
	CreateShortCut "$FAVORITES\Software.lnk" 			  "\\10.0.2.10\it\software"
	CreateShortCut "$FAVORITES\Streambox.lnk" 			"\\10.0.2.10\Production\Streambox"
	CreateShortCut "$FAVORITES\TaylorHome.lnk" 			"\\10.0.2.10\taylor.monacelli"
	CreateShortCut "$FAVORITES\TaylorTrash.lnk" 		"\\10.0.2.10\taylor.monacelli\trash"
	CreateShortCut "$FAVORITES\Tools.lnk" 					"\\10.0.2.10\Development\tools"

	exec '"explorer" $FAVORITES'

	##############################
	# emacs
	##############################
	FileOpen $R1 $TEMP\cygwin-setup\emacs-setup.bat w
	FileWrite $R1 '@echo on$\r$\n\
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
	$\r$\n\
	'
	FileClose $R1
	exec '"cmd" /c $TEMP\cygwin-setup\emacs-setup.bat'

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
			'cmd /c start http://cygwin.com/setup.exe'
		pop $0

	SetOutPath '$PROGRAMFILES\cygwininstall'
	CopyFiles $TEMP\cygwin-setup\setup.exe \
		'$PROGRAMFILES\cygwininstall'

	SetOutPath $sysdrive\cygwin\etc\setup
	SetOverwrite off
	File installed.db

	IfFileExists $sysdrive\cygwin\packages download2_done 0
		CreateDirectory $sysdrive\cygwin\packages
		nsExec::ExecToStack '"cmd" /c start /min $sysdrive\cygwin\packages'
		pop $0
		# cmd /c "%programfiles%\cygwinInstall\setup.exe" --download --no-desktop --local-package-dir c:\cygwin\packages --quiet-mode --site ftp://mirrors.xmission.com/cygwin
		DetailPrint 'Downloading packages specified \
			in $sysdrive\cygwin\etc\setup\installed.db'
		ExecWait \
			'$PROGRAMFILES\cygwinInstall\setup.exe \
			--download \
			--no-desktop \
			--local-package-dir $sysdrive\cygwin\packages \
			--quiet-mode \
			--site ftp://mirrors.xmission.com/cygwin'
	download2_done:

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
		CreateShortCut \
			"$QUICKLAUNCH\Bash.lnk" \
			$sysdrive\Cygwin\Cygwin.bat \
			"" \
			"$sysdrive\Cygwin\Cygwin.ico" \
			"" \
			SW_SHOWNORMAL \
			ALT|CONTROL|SHIFT|F5 "Cygwin"
		CreateShortCut "$FAVORITES\CygwinSetup" "%programfiles%\cygwininstall"
		CreateShortCut "$FAVORITES\CygwinHome" "$sysdrive\Cygwin\home"
	cygwin_install_done:
	
	# add c:\cygwin\bin to %path%
	ReadRegStr $2 HKLM Software\Cygwin\setup rootdir
	nsExec::ExecToStack \
		'$TEMP\cygwin-setup\pathman /au $2\bin'
	  	
SectionEnd

Section "Section Name 2" Section2

SectionEnd


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
