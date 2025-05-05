; TypeClipboardContents.ahk
#SingleInstance Force

; ─── Configuration ────────────────────────────────────────────────────────────
Delay := 50 ; Delay between lines, in milliseconds

; ─── Panic button: press Escape to quit the script ─────────────────────────────
Esc::ExitApp

; ─── Send clipboard contents as keystrokes: Ctrl+Shift+V ───────────────────────
^+v::
    WinGetActiveTitle, ActiveWindow
    if (ActiveWindow = "") {
        MsgBox, 48, Error, Failed to get the active window title.
        return
    }

    ; Back up & ensure we have something to type
    ClipboardBackup := ClipboardAll
    if (!Clipboard) {
        MsgBox, 48, Warning, Clipboard is empty!
        return
    }

    ; Normalize into lines
    Clipboard := RegExReplace(Clipboard, "\r\n|\r", "`n")
    Clipboard := RegExReplace(Clipboard, "`n+$", "")
    Lines := StrSplit(Clipboard, "`n")

    ; Type each line; only send Enter on all but the last
    MaxIndex := Lines.MaxIndex()
    for Index, Line in Lines {
        WinGetActiveTitle, CurrentWindow
        if (CurrentWindow != ActiveWindow) {
            MsgBox, 48, Aborted, Window lost focus. Exiting.
            break
        }
        if GetKeyState("Esc", "P") {
            MsgBox, 48, Aborted, Interrupted by user.
            break
        }

        SendRaw, % Line
        if (Index < MaxIndex) {
            Send, {Enter}
            Sleep, % Delay
        }
    }

    ; Restore original clipboard
    Clipboard := ClipboardBackup
return
