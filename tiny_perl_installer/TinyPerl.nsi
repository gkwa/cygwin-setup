!include MUI2.NSH
!include nsDialogs.nsh

Name "${name}"
OutFile "${outfile}"

XPStyle on
ShowInstDetails show
ShowUninstDetails show
RequestExecutionLevel admin
Caption "Streambox $(^Name) Installer"

# use this as installdir
InstallDir '$PROGRAMFILES\Streambox\${name}'
#...butif this reg key exists, use this installdir instead of the above line
InstallDirRegKey HKLM 'Software\Streambox\${name}' InstallDir

!define LANG_ENGLISH 1033-English

VIAddVersionKey /LANG=${LANG_ENGLISH} "ProductName" "My Fun Product"
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileDescription" "Creates fun things"
VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalCopyright" "@Streambox"
VIAddVersionKey /LANG=${LANG_ENGLISH} "CompanyName" "Streambox"
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
# Var Dialog
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

;--------------------------------
;Pages

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE nsis-streambox2\Docs\License.txt
!insertmacro MUI_PAGE_INSTFILES # this macro is the macro that invokes the Sections

!define MUI_WELCOMEPAGE_TITLE "Welcome to Streambox uninstall wizard."
!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

;--------------------------------
; Languages

!insertmacro MUI_LANGUAGE "English"
;--------------------------------
; Functions

Function .onInit
	StrCpy $sysdrive $WINDIR 1

FunctionEnd

Function .onInstSuccess

FunctionEnd

Function UN.onInit
	StrCpy $sysdrive $WINDIR 1
FunctionEnd

Section section1 section_section1

	SetOutPath "$INSTDIR"

	File nsis-streambox2\7za.exe
	File ${tinyPerl}.zip

	nsExec::ExecToStack '"$INSTDIR\7za.exe" x -y -o"$INSTDIR\tp" ${tinyPerl}.zip'
	File lib.zip
	CopyFiles '$INSTDIR\lib.zip' '$INSTDIR\tp\${tinyPerl}' #Overwrite with home-grown lib.zip
	CopyFiles '$INSTDIR\tp\${tinyPerl}\*' '$INSTDIR'
	rmdir /r "$INSTDIR\tp"
	Delete "$INSTDIR\${tinyPerl}.zip"
	Delete "$INSTDIR\7za.exe"

	WriteRegStr HKLM 'Software\Streambox\${name}' InstallDir '$INSTDIR'
	WriteRegStr HKLM 'Software\Streambox\${name}' tinyPerlExe '$INSTDIR\tinyperl.exe'

	SetOutPath '$INSTDIR'
	WriteUninstaller Uninstall.exe
	WriteRegStr HKLM 'Software\Microsoft\Windows\CurrentVersion\Uninstall\${name}' DisplayName '${name} v${version}'
	WriteRegStr HKLM 'Software\Microsoft\Windows\CurrentVersion\Uninstall\${name}'  DisplayIcon '$INSTDIR\Uninstall.exe'
	WriteRegDWORD HKLM 'Software\Microsoft\Windows\CurrentVersion\Uninstall\${name}' NoModify 1
	WriteRegStr HKLM 'Software\Microsoft\Windows\CurrentVersion\Uninstall\${name}' UninstallString '$INSTDIR\Uninstall.exe'

SectionEnd

Section -cleanup_legacy_code section_cleanup_legacy_code
	Delete '$PROGRAMFILES\Streambox\${name}\Streambox_128.ico'
SectionEnd

Section uninstall section_uninstall

	ReadRegStr $0 HKLM 'Software\Streambox\${name}' InstallDir
	rmdir /r "$0"

	DeleteRegKey HKLM 'Software\Streambox\${name}'
	DeleteRegKey /ifempty HKLM 'Software\Streambox'

	# Remove from microsoft Add/remove Programs applet
	DeleteRegKey HKLM 'Software\Microsoft\Windows\CurrentVersion\Uninstall\${name}'
SectionEnd

UninstallIcon nsis-streambox2\Icons\Streambox_128.ico
UninstallText "This will uninstall ${name}"

# Emacs vars
# Local Variables: ***
# comment-column:0 ***
# tab-width: 2 ***
# comment-start:"# " ***
# End: ***
