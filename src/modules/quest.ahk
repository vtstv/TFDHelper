; Quest and utility modules

TabberFunction() {
    if (!modules["master"].enabled || !modules["tabber"].enabled || !IsGameActive())
        return
    Send("{Tab}")
}

~t:: {
    if (!modules["master"].enabled)
        return
    
    if (modules["quest"].enabled && IsGameActive()) {
        Send("{Esc}")
        Sleep(100)
        Click(217, 436)
        Sleep(100)
        Send("{Space}")
        Sleep(500)
        Send("{F2 down}")
        Sleep(2000)
        Send("{F2 up}")
        Sleep(100)
        Send("{r down}")
        Sleep(2000)
        Send("{r up}")
        return
    }
    
    if (modules["repeat"].enabled && IsGameActive()) {
        if (DISABLE_BUNNY_JUMP_ON_REPEAT && modules["bunny"].enabled && modules["bunny"].jumping) {
            if (modules["bunny"].jumpTimer) {
                SetTimer(modules["bunny"].jumpTimer, 0)
                modules["bunny"].jumpTimer := 0
            }
            modules["bunny"].jumping := false
            ShowTooltip("Bunny jumping stopped for repeat sequence")
            Sleep(500)
        }
        
        Send("{F2 down}")
        Sleep(1500)
        Send("{F2 up}")
        Sleep(2000)
        Send("{r down}")
        Sleep(1500)
        Send("{r up}")
    }
}
