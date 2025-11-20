; Freyna character module

F3:: {
    if (!modules["master"].enabled || !modules["freyna"].enabled || !IsGameActive())
        return
    
    modules["freyna"].active := !modules["freyna"].active
    if (modules["freyna"].active) {
        if (!modules["freyna"].paused) {
            SetTimer(() => PressKey("c"), FREYNA_C_COOLDOWN)
            SetTimer(() => PressKey("v"), FREYNA_V_COOLDOWN)
        }
        ShowTooltip("Freyna Auto C/V: ON")
    } else {
        SetTimer(() => PressKey("c"), 0)
        SetTimer(() => PressKey("v"), 0)
        ShowTooltip("Freyna Auto C/V: OFF")
    }
}

~c:: {
    if (!modules["master"].enabled || !modules["freyna"].enabled || !modules["freyna"].active)
        return
    
    modules["freyna"].paused := !modules["freyna"].paused
    if (modules["freyna"].paused) {
        SetTimer(() => PressKey("c"), 0)
        SetTimer(() => PressKey("v"), 0)
        ShowTooltip("Freyna: PAUSED")
    } else {
        SetTimer(() => PressKey("c"), FREYNA_C_COOLDOWN)
        SetTimer(() => PressKey("v"), FREYNA_V_COOLDOWN)
        ShowTooltip("Freyna: RESUMED")
    }
}

~v:: {
    if (!modules["master"].enabled)
        return
        
    if (modules["freyna"].enabled && modules["freyna"].active) {
        modules["freyna"].paused := !modules["freyna"].paused
        if (modules["freyna"].paused) {
            SetTimer(() => PressKey("c"), 0)
            SetTimer(() => PressKey("v"), 0)
            ShowTooltip("Freyna: PAUSED")
        } else {
            SetTimer(() => PressKey("c"), FREYNA_C_COOLDOWN)
            SetTimer(() => PressKey("v"), FREYNA_V_COOLDOWN)
            ShowTooltip("Freyna: RESUMED")
        }
        return
    }
    
    if (modules["bunny"].enabled) {
        modules["bunny"].autoV := !modules["bunny"].autoV
        if (modules["bunny"].autoV) {
            SetTimer(BunnyAutoV, BUNNY_AUTO_V_COOLDOWN)
            ShowTooltip("Bunny Auto V: ON")
        } else {
            SetTimer(BunnyAutoV, 0)
            ShowTooltip("Bunny Auto V: OFF")
        }
        return
    }
    
    if (modules["viessa"].enabled && modules["viessa"].blocking)
        return
}
