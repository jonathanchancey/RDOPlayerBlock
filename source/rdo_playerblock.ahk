#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance, Force

; Requires elevation to modify firewall rules
if not A_IsAdmin
	Run *RunAs "%A_ScriptFullPath%" 

; Constructing Gui
Gui, Font, s11, Arial
Gui, Add, Button, x10 y10 w210 h30 gAddRule, &Add Firewall Rule
Gui, Add, Button, x10 y50 w210 h30 gRemoveRule, &Remove Firewall Rule
Gui, Add, Button, x10 y90 w100 h50 gEnableRule, &Enable
Gui, Font, s11, Arial
Gui, Add, Button, x120 y90 w100 h50 gDisableRule, &Disable
Gui, Add, Link, x230 y10 w200 h100, Instructions:`nShift+Ctrl+Win+E to enable.`nShift+Ctrl+Win+D to disable.`nFor additional context, check the <a href="https://www.reddit.com/r/RedDeadOnline/comments/eioh79/solo_lobby_guide_repost/">Solo Lobby Guide</a>
Gui, Color, White
Gui, Show, x800 y50 w440 h150, RDO PlayerBlock

; Add quick hotkeys
+^#e::
Goto, EnableRule

+^#d::
Goto, DisableRule

; Goto definitions
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
    cmd = netsh advfirewall firewall set rule name="block_new_RDO_player_connections" new enable=yes
    MsgBox % ComObjCreate("WScript.Shell").Exec("cmd.exe /c" . cmd).StdOut.ReadAll()
    return

DisableRule:
    cmd = netsh advfirewall firewall set rule name="block_new_RDO_player_connections" new enable=no
    MsgBox % ComObjCreate("WScript.Shell").Exec("cmd.exe /c" . cmd).StdOut.ReadAll()
    return

GuiClose:
    ExitApp, return

Esc::ExitApp