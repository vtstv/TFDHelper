; ========== TFD Helper by Murr ==========
; https://github.com/vtstv/TFDHelper

#Requires AutoHotkey v2.0
#SingleInstance Force
SendMode("Input")
CoordMode("ToolTip", "Screen")

#Include src\config.ahk
#Include src\utils.ahk
#Include src\modules.ahk

InitializeModules()

#Include src\modules\freyna.ahk
#Include src\modules\bunny.ahk
#Include src\modules\luna.ahk
#Include src\modules\viessa.ahk
#Include src\modules\hailey.ahk
#Include src\modules\ascend.ahk
#Include src\modules\quest.ahk

Numpad0::ToggleModule("master")
Numpad1::ToggleModule("tabber")
Numpad2::ToggleModule("bunny")
Numpad3::ToggleModule("luna")
Numpad4::ToggleModule("viessa")
Numpad5::ToggleModule("freyna")
Numpad6::ToggleModule("quest")
Numpad7::ToggleModule("repeat")
Numpad8::ShowStatus()
Numpad9::ToggleModule("hailey")

ShowStatus() {
    status := "=== TFD Helper Status ===`n"
    masterStatus := modules["master"].enabled ? "ON" : "OFF (ALL DISABLED)"
    status .= "Master (Num0): " . masterStatus . "`n"
    
    if (!modules["master"].enabled) {
        status .= "`n*** MASTER IS OFF - ALL FUNCTIONS DISABLED ***`n"
    }
    
    status .= "`n--- CHARACTER CLASSES (Mutually Exclusive) ---`n"
    activeClass := ""
    if (modules["freyna"].enabled)
        activeClass := "Freyna"
    else if (modules["bunny"].enabled)
        activeClass := "Bunny"
    else if (modules["viessa"].enabled)
        activeClass := "Viessa"
    else if (modules["luna"].enabled)
        activeClass := "Luna"
    
    status .= "Active Class: " . (activeClass != "" ? activeClass : "None") . "`n"
    status .= "Bunny (Num2): " . (modules["bunny"].enabled ? "ON ★" : "OFF") . "`n"
    status .= "Luna (Num3): " . (modules["luna"].enabled ? "ON ★" : "OFF") . "`n"
    status .= "Viessa (Num4): " . (modules["viessa"].enabled ? "ON ★" : "OFF") . "`n"
    status .= "Freyna (Num5): " . (modules["freyna"].enabled ? "ON ★" : "OFF") . "`n"
    status .= "Hailey (Num9): " . (modules["hailey"].enabled ? "ON ★" : "OFF") . "`n"

    status .= "`n--- UTILITY MODULES ---`n"
    status .= "Tabber (Num1): " . (modules["tabber"].enabled ? "ON" : "OFF") . "`n"
    status .= "Quest (Num6): " . (modules["quest"].enabled ? "ON" : "OFF") . "`n"
    status .= "Repeat (Num7): " . (modules["repeat"].enabled ? "ON" : "OFF") . "`n"
    
    ascendStatus := modules["ascend"].enabled ? "ON" : "OFF"
    if (modules["ascend"].enabled && modules["ascend"].autoRepeatTimer != 0) {
        ascendStatus .= " + Auto-Repeat"
    }
    status .= "Ascend (F6): " . ascendStatus . "`n"
    status .= "Ascend Auto-Repeat (E): " . (modules["ascend"].autoRepeatTimer != 0 ? "ON" : "OFF")
    
    MsgBox(status, "TFD Helper Status", "T3")
}

OnExit((*) => SetTimer(() => ToolTip(), 0))
