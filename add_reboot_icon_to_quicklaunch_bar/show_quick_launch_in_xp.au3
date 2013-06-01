; Last modified $Id$
; $HeadURL$
; -*- visual-basic-mode -*-


#include <File.au3>; for TempFile(), _PathSplit(), And others
#include <Array.au3>
#include <date.au3>
AutoItSetOption("MustDeclareVars", 1)

; ------------------------------
; Main
; ------------------------------

Global Const $LogDirectory = @WindowsDir & "\temp" & "\."
Global Const $log = $LogDirectory & "\" & @ScriptName & ".log"


_FileWriteLog( $log, StringFormat("INFO: LINE %04i: Starting %s from directory %s on machine %s", _
                  @ScriptLineNumber, @ScriptName, @ScriptDir, @ComputerName))


; turn the menu into classic menu


; ; This one was a bit tricky:
; ; Set machine To clasic menu
; ; in responce, machine will turn On My Documents, My Network Places And My Computer
; ; so, If we want only My Network Places And My Computer To show On the desktop, Then we need To unselect My Computer.
; ; TODO: Fixme!  We are doing this blind!  We should check the value of checkboxes And Not simply click checkboxes assuming they're in
; ; a certain state.

; local $runTimes =IniRead("config.ini", "SetStartMenuProperties", "Run Count", 0)
; If $runTimes >=1 Then
;       _FileWriteLog( $log, StringFormat("INFO: LINE %04i: i see that SetStartMenuProperties was already run on this computer.  Running it an even number of times will reverse what we intended since we're using toggle checkboxes", _
;                                         @ScriptLineNumber))
;         Return
; endif


_FileWriteLog( $log, StringFormat("INFO: LINE %04i: i'm in the SetStartMenuProperties now", _
                  @ScriptLineNumber))

; click start menu, go To Properties, hit enter, assume default Tab Is "start menu", hit Alt-m For classic menu

AutoItSetOption("MouseCoordMode", 1) ; absolute Screen coordinates

Global $WinMatchMode
Global $WinMatchModeValue
Global $WinTitle
Global $WinEmbeddedText
Global $WinWaitTimeout

$WinMatchMode      = "WinTitleMatchMode"
$WinMatchModeValue = 3 ;Exact title match
$WinTitle          = "Taskbar and Start Menu Properties"
$WinEmbeddedText   = ""
$WinWaitTimeout    = 4*60
WinClose($WinTitle)

Mouseclick("right", 25, @desktopheight - 10);  start menu, remember windows desktop coordinates are top Left corner Is (0,0)
Sleep(100)
Send("r"); Start Menu Properties

WaitAndActivateWindow(@ScriptLineNumber, $WinMatchMode, $WinMatchModeValue, $WinTitle, $WinEmbeddedText, $WinWaitTimeout)

Send("+{TAB}{LEFT}"); go To TaskBar Tab
Send("!q"); Bring the focus To the "Show &Quick Launch" option
Send("{+}"); make sure the "Show &Quick Launch" Option Is checked

Send("!l"); Bring the focus To the "&Lock the TaskBar" option
Send("{-}"); make sure the "&Lock the TaskBar" Option Is unchecked (Unlock the taskbar)

Send("!a"); Click &Apply button

WinClose($WinTitle)

_FileWriteLog( $log, StringFormat("INFO: LINE %04i: Ending %s\\%s", _
                  @ScriptLineNumber, @ScriptDir, @ScriptName ))




; --------------------------------------------------
; Starting Function Definitions
; --------------------------------------------------

Func WaitAndActivateWindow($ScriptLineNumber, $WinMatchMode, $WinMatchModeValue, $WinTitle, $WinEmbeddedText, $WinWaitTimeout)

  _FileWriteLog( $log, _
         StringFormat("INFO: LINE %04i: Setting %s to %s", _
                  $ScriptLineNumber, $WinMatchMode, $WinMatchModeValue))
  AutoItSetOption($WinMatchMode, $WinMatchModeValue)

  If "" == $WinEmbeddedText Then
      _FileWriteLog( $log, _
            StringFormat("INFO: LINE %04i: Searching for window '%s'", _
                 $ScriptLineNumber, $WinTitle))
  Else
      _FileWriteLog( $log, _
            StringFormat("INFO: LINE %04i: Searching for window '%s' with '%s' embedded within it", _
                 $ScriptLineNumber, $WinTitle, $WinEmbeddedText))
  EndIf

  local $WinWaitStatus

  $WinWaitStatus = WinWait($WinTitle, $WinEmbeddedText, $WinWaitTimeout)
  If 0 == $WinWaitStatus Then
      _FileWriteLog( $log, _
            StringFormat("FATAL: LINE %04i: Can't find window '%s' or @error=1, quitting.", _
                 $ScriptLineNumber, $WinTitle))

      Exit 1
  EndIF

  If Not WinActivate($WinTitle, $WinEmbeddedText) Then
    _FileWriteLog( $log, StringFormat("ERROR: LINE %04i: Can't find window '%s', quitting.", _
                      @ScriptLineNumber, $WinTitle))



    Exit 1
  EndIf


  _FileWriteLog( $log, _
        StringFormat("INFO: LINE %04i: Found window '%s', setting it to be the focus, continuing...", _
                 $ScriptLineNumber, $WinTitle))


EndFunc

; --------------------------------------------------

; Emacs vars
; Local Variables: ***
; comment-column:0 ***
; tab-width: 4 ***
; comment-start:"; " ***
; End: ***
