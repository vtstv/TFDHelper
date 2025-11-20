; Core utility functions

IsGameActive() {
    try {
        return WinGetProcessName("A") == GAME_EXE
    } catch {
        return false
    }
}

ShowTooltip(text) {
    global tooltipTimer
    x := A_ScreenWidth - 220
    y := 10
    ToolTip(text, x, y)
    
    if (tooltipTimer)
        SetTimer(tooltipTimer, 0)
    tooltipTimer := () => ToolTip()
    SetTimer(tooltipTimer, -TOOLTIP_DURATION)
}

PressKey(key) {
    if (!modules["master"].enabled || !IsGameActive())
        return
    Send("{" . key . "}")
}

HasValue(arr, val) {
    for value in arr {
        if (value == val)
            return true
    }
    return false
}
