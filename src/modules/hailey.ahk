; Hailey character module

HaileyAutoQ() {
    if (!modules["master"].enabled || !modules["hailey"].enabled || modules["hailey"].paused || !IsGameActive())
        return
    Send("{q}")
}

~q:: {
    if (!modules["master"].enabled || !modules["hailey"].enabled || !IsGameActive())
        return
    
    modules["hailey"].paused := !modules["hailey"].paused
    if (modules["hailey"].paused) {
        SetTimer(HaileyAutoQ, 0)
        ShowTooltip("Hailey: PAUSED")
    } else {
        SetTimer(HaileyAutoQ, HAILEY_Q_INTERVAL)
        ShowTooltip("Hailey: RESUMED")
    }
}
