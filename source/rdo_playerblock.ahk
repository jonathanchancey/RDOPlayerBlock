#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance, Force

if not A_IsAdmin
	Run *RunAs "%A_ScriptFullPath%" ; (A_AhkPath is usually optional if the script has the .ahk extension.) You would typically check  first.

; Font settings
Gui, Font, s11, Arial

; Adding Buttons and text elements. 


; Defaults to default. Adds option to start from Sunday.
sun = 0
; x230 y131 w300 h30
GUI, Add, Button, x10 y10 w210 h30 gAddRule, &Add Firewall Rule
GUI, Add, Button, x10 y50 w210 h30 gRemoveRule, &Remove Firewall Rule
GUI, Add, Button, x10 y90 w100 h50 gEnableRule, &Enable
GUI, Font, s11, Arial
GUI, Add, Button, x120 y90 w100 h50 gDisableRule, &Disable
; GUI, Add, Text, x230 y10 w200 h100, The default week is prepopulated. Each line is a day. 

Gui, Add, Link, x230 y10 w200 h100, Instructions:`nShift+Ctrl+Win+E to enable.`nShift+Ctrl+Win+D to disable.`nFor additional context, check the <a href="https://www.reddit.com/r/RedDeadOnline/comments/eioh79/solo_lobby_guide_repost/">Solo Lobby Guide</a>
; GUI, +AlwaysOnTop

GUI, Color, White

GUI, Show, x800 y50 w440 h150, RDO PlayerBlock

+^#e::
Goto, EnableRule

+^#d::
Goto, DisableRule

AddRule:
    Gui, submit, nohide
    cmd = netsh advfirewall firewall add rule name="block_new_RDO_player_connections" dir=out action=block protocol=UDP localport=6672,61455,61457,61456,61458
    MsgBox % ComObjCreate("WScript.Shell").Exec("cmd.exe /c" . cmd).StdOut.ReadAll()
    return

RemoveRule:
    Gui, submit, nohide
    cmd = netsh advfirewall firewall delete rule name="block_new_RDO_player_connections"
    MsgBox % ComObjCreate("WScript.Shell").Exec("cmd.exe /c" . cmd).StdOut.ReadAll()
    return

EnableRule:
    ; run, netsh advfirewall firewall set rule name="block_new_RDO_player_connections" new enable=yes
    
    cmd = netsh advfirewall firewall set rule name="block_new_RDO_player_connections" new enable=yes
    MsgBox % ComObjCreate("WScript.Shell").Exec("cmd.exe /c" . cmd).StdOut.ReadAll()

    return

DisableRule:
    cmd = netsh advfirewall firewall set rule name="block_new_RDO_player_connections" new enable=no
    MsgBox % ComObjCreate("WScript.Shell").Exec("cmd.exe /c" . cmd).StdOut.ReadAll()
    ; run, netsh advfirewall firewall set rule name="block_new_RDO_player_connections" new enable=no
    return

GuiClose:
    ExitApp, return

Esc::ExitApp