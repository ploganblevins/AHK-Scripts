#SingleInstance Force
; Panic button: Press the Escape key to stop the script
Esc::
{
    ExitApp ; Immediately terminates the script
}

; Hotkey to send clipboard contents as keystrokes with a delay (e.g., Ctrl+Shift+V)
^+v::
{
    ; Save the current clipboard content
    ClipboardBackup := Clipboard
    ; Wait for the clipboard to contain data (timeout: 2 seconds)
    ClipWait, 2
    if (ErrorLevel)
    {
        MsgBox, Failed to detect clipboard data within 2 seconds.
        ExitApp ; Terminate the script after execution
    }

    ; Check if the clipboard has content
    if (Clipboard != "")
    {
        ; Normalize line endings and remove trailing newline characters
        Clipboard := RegExReplace(Clipboard, "\r\n|\r", "`n") ; Normalize line endings
        Clipboard := RegExReplace(Clipboard, "`n+$", "") ; Remove trailing newlines
        
        ; Split clipboard into an array of lines
        Lines := StrSplit(Clipboard, "`n") ; Creates an array of lines
        Delay := 5 ; Delay in milliseconds
        
        ; Send each line with a delay
        Loop, % Lines.MaxIndex()
        {
            if GetKeyState("Esc", "P") ; Emergency stop check
            {
                MsgBox, Script interrupted by the user.
                ExitApp
            }
            SendRaw, % Lines[A_Index]
            Send, {Enter}
            Sleep, %Delay%
        }
    }
    else
    {
        MsgBox, Clipboard is empty!
    }
    ; Restore the original clipboard content
    Clipboard := ClipboardBackup
    ClipboardBackup := ""
    ExitApp ; Terminate the script after execution
}
