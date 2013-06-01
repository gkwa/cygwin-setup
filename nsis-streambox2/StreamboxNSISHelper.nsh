!ifndef StreamboxNSISHelper_INCLUDED
!define StreamboxNSISHelper_INCLUDED

!define _StreamboxNSISHelper_UN

!include NSISpcre.nsh
!include nsProcess.nsh

# #############################
# KillProcess
# #############################

!macro killProcessCall PROCESS_NAME
	Push '${PROCESS_NAME}'
	Call killProcess
!macroend

!macro un.killProcessCall PROCESS_NAME
	Push '${PROCESS_NAME}'
	Call un.killProcess
!macroend

!macro killProcess
	!ifndef ${_StreamboxNSISHelper_UN}killProcess
		!define ${_StreamboxNSISHelper_UN}killProcess `!insertmacro ${_StreamboxNSISHelper_UN}killProcessCall`

		Function ${_StreamboxNSISHelper_UN}killProcess

			Exch $0 #store process name from caller in $0
			Push $R0
			Push $R1

			DetailPrint "Searching for process '$0'"
			FindProcDLL::FindProc "$0" #stores in $R0 by default
			!define UniqueID ${__LINE__}
				IntCmp $R0 1 0 jump_${UniqueID}
				DetailPrint "Stopping $0 application"
				${nsProcess::KillProcess} '$0' $R1
				sleep 2000
			jump_${UniqueID}:
			!undef UniqueID

			Pop $R1
			Pop $R0
			Pop $0

		FunctionEnd
	!endif
!macroend

!macro un.killProcess
	!ifndef un.killProcess

		!undef _StreamboxNSISHelper_UN
		!define _StreamboxNSISHelper_UN `un.`

		!insertmacro killProcess

		!undef _StreamboxNSISHelper_UN
		!define _StreamboxNSISHelper_UN
	!endif
!macroend

# #############################
# determinIfWriteProtectIsOn
# #############################

!macro determinIfWriteProtectIsOnCall
	Call determinIfWriteProtectIsOn
!macroend

!macro un.determinIfWriteProtectIsOnCall
	Call un.determinIfWriteProtectIsOn
!macroend

!macro determinIfWriteProtectIsOn
	!ifndef ${_StreamboxNSISHelper_UN}determinIfWriteProtectIsOn
		!define ${_StreamboxNSISHelper_UN}determinIfWriteProtectIsOn `!insertmacro ${_StreamboxNSISHelper_UN}determinIfWriteProtectIsOnCall`

		!insertmacro REMatches
		!insertmacro un.REMatches

		Function ${_StreamboxNSISHelper_UN}determinIfWriteProtectIsOn

			##############################
			# determine if write protect is on/off
			##############################
			GetTempFileName $0
			nsExec::ExecToStack '"$SYSDIR\cmd" /c \
				$SYSDIR\fbwfmgr.exe /displayconfig 2>&1 > $0' $1
		# File-based write filter is not enabled for the current session.

			ClearErrors
			FileOpen $2 $0 r #$2 is file handle
			IfErrors done
			# I assume first line is current state (such as "File-based write filter configuration for the current session:)
			FileRead $2 $3
			# I assume second line describes fbwf sate of current session (for example "    filter state: enabled."
			FileRead $2 $3
		#  RECaptureMatches RESULT PATTERN SUBJECT PARTIAL

			!ifdef __UNINSTALL__
				!insertmacro un.RECaptureMatchesCall $R1 "(.*enabled)" "$3" 1
			!else
				!insertmacro RECaptureMatchesCall $R1 "(.*enabled)" "$3" 1
			!endif
			${If} $R1 > 0
					FileOpen $R1 $WINDIR\temp\disable_write_protect_for_install.bat  w
							FileWrite $R1 '\
								@echo off$\r$\n\
								ECHO Write Protect OFF$\r$\n\
								ECHO This will allow files on the System Drive to be changed$\r$\n\
								ECHO.$\r$\n\
								ECHO.$\r$\n\
								SET /p choice=This will require a system restart, do you want to continue? (Y/N)$\r$\n\
								$\r$\n\
								IF "%choice%"=="y" GOTO do$\r$\n\
								IF "%choice%"=="Y" GOTO do$\r$\n\
								'
							FileWrite $R1 '\
								IF "%choice%"=="yes" GOTO do$\r$\n\
								IF "%choice%"=="Yes" GOTO do$\r$\n\
								GOTO notdo$\r$\n\
								$\r$\n\
								:do$\r$\n\
								ECHO Restarting, please wait....$\r$\n\
								$WINDIR\system32\fbwfmgr.exe /disable$\r$\n\
								set link=%ALLUSERsPROFILE%\Desktop\Disable Write Protect.lnk$\r$\n\
								'
							FileWrite $R1 '\
								if exist "%link%" ( del /q "%link%" )$\r$\n\
								shutdown -r -t 00$\r$\n\
								exit$\r$\n\
								$\r$\n\
								:notdo$\r$\n\
								ECHO Operation aborted. Press any key to exit...$\r$\n\
								PAUSE$\r$\n\
								exit$\r$\n\
								$\r$\n\
								'
					FileClose $R1
					SetShellVarContext all
					CreateShortCut "$DESKTOP\Disable Write Protect.lnk" $WINDIR\temp\disable_write_protect_for_install.bat
				MessageBox MB_ICONSTOP \
				"I can't continue with FBWF write filter turned on.  In order to continue, you must disable the \
					drive write protect, reboot and retry the install.   In order to disable drive write protect \
					you can run the $\"Disable Write Protect$\" shortcut on the desktop."
				Abort
			${EndIf}
			FileClose $2
			done:

		FunctionEnd
	!endif
!macroend

!macro un.determinIfWriteProtectIsOn
	!ifndef un.determinIfWriteProtectIsOn

		!undef _StreamboxNSISHelper_UN
		!define _StreamboxNSISHelper_UN `un.`

		!insertmacro determinIfWriteProtectIsOn

		!undef _StreamboxNSISHelper_UN
		!define _StreamboxNSISHelper_UN
	!endif
!macroend

!macro DumpLog Un

	!define LVM_GETITEMCOUNT 0x1004
	!define LVM_GETITEMTEXT 0x102D

	Function ${Un}DumpLog
		Exch $5
		Push $0
		Push $1
		Push $2
		Push $3
		Push $4
		Push $6

		FindWindow $0 "#32770" "" $HWNDPARENT
		GetDlgItem $0 $0 1016
		StrCmp $0 0 exit
		FileOpen $5 $5 "w"
		StrCmp $5 "" exit
			SendMessage $0 ${LVM_GETITEMCOUNT} 0 0 $6
			System::Alloc ${NSIS_MAX_STRLEN}
			Pop $3
			StrCpy $2 0
			System::Call "*(i, i, i, i, i, i, i, i, i) i \
				(0, 0, 0, 0, 0, r3, ${NSIS_MAX_STRLEN}) .r1"
			loop: StrCmp $2 $6 done
				System::Call "User32::SendMessageA(i, i, i, i) i \
					($0, ${LVM_GETITEMTEXT}, $2, r1)"
				System::Call "*$3(&t${NSIS_MAX_STRLEN} .r4)"
				FileWrite $5 "$4$\r$\n"
				IntOp $2 $2 + 1
				Goto loop
			done:
				FileClose $5
				System::Free $1
				System::Free $3
		exit:
			Pop $6
			Pop $4
			Pop $3
			Pop $2
			Pop $1
			Pop $0
			Exch $5
	FunctionEnd
!macroend

!endif


# Emacs vars
# Local Variables: ***
# comment-column:0 ***
# tab-width: 2 ***
# comment-start:"# " ***
# End: ***
