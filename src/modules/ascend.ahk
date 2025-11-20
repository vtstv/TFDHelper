; Ascend character module

~LButton:: {
    if (!ASCEND_AUTO_R_ENABLED || !modules["master"].enabled || !modules["ascend"].enabled || !IsGameActive())
        return
    
    isRTimerActive := false
    isJumpTimerActive := false
    isManualJumpActive := false
    
    try {
        isRTimerActive := (modules["ascend"].autoRTimer != 0 && Type(modules["ascend"].autoRTimer) == "Object")
    } catch {
        modules["ascend"].autoRTimer := 0
    }
    
    try {
        isJumpTimerActive := (modules["ascend"].autoJumpTimer != 0 && Type(modules["ascend"].autoJumpTimer) == "Object")
    } catch {
        modules["ascend"].autoJumpTimer := 0
    }
    
    try {
        isManualJumpActive := (modules["ascend"].manualJumpTimer != 0 && Type(modules["ascend"].manualJumpTimer) == "Object")
    } catch {
        modules["ascend"].manualJumpTimer := 0
    }
    
    if (isRTimerActive || isJumpTimerActive || isManualJumpActive)
        return
    
    modules["ascend"].autoRTimer := SetTimer(() => AutoRSequence(), -ASCEND_AUTO_R_DELAY)
}

AutoRSequence() {
    if (!modules["master"].enabled || !modules["ascend"].enabled || !IsGameActive()) {
        modules["ascend"].autoRTimer := 0
        return
    }
    
    modules["ascend"].autoRTimer := 0
    Send("{r}")
    modules["ascend"].autoJumpTimer := SetTimer(() => AscendJumpAndFinish(), -ASCEND_AUTO_JUMP_DELAY)
}

AscendJumpAndFinish() {
    if (!modules["master"].enabled || !modules["ascend"].enabled || !IsGameActive()) {
        modules["ascend"].autoJumpTimer := 0
        return
    }
    
    modules["ascend"].autoJumpTimer := 0
    Send("{Space down}")
    Sleep(100)
    Send("{Space up}")
}

ToggleAscendAutoRepeat() {
    if (!modules["master"].enabled || !modules["ascend"].enabled) {
        ShowTooltip("Ascend Auto-Repeat: Module not enabled")
        return
    }
    
    if (modules["ascend"].autoRepeatTimer != 0) {
        try {
            SetTimer(modules["ascend"].autoRepeatTimer, 0)
            SetTimer(() => AscendAutoRepeatSequence(), 0)
        } catch {
        }
        modules["ascend"].autoRepeatTimer := 0
        ShowTooltip("Ascend Auto-Repeat: OFF")
    } else {
        if (IsGameActive()) {
            isRTimerActive := false
            isJumpTimerActive := false
            isManualJumpActive := false
            
            try {
                isRTimerActive := (modules["ascend"].autoRTimer != 0 && Type(modules["ascend"].autoRTimer) == "Object")
            } catch {
                modules["ascend"].autoRTimer := 0
            }
            
            try {
                isJumpTimerActive := (modules["ascend"].autoJumpTimer != 0 && Type(modules["ascend"].autoJumpTimer) == "Object")
            } catch {
                modules["ascend"].autoJumpTimer := 0
            }
            
            try {
                isManualJumpActive := (modules["ascend"].manualJumpTimer != 0 && Type(modules["ascend"].manualJumpTimer) == "Object")
            } catch {
                modules["ascend"].manualJumpTimer := 0
            }
            
            if (!isRTimerActive && !isJumpTimerActive && !isManualJumpActive) {
                Send("{LButton}")
                SetTimer(() => AscendAutoRepeatR(), -ASCEND_AUTO_REPEAT_DELAY)
            }
        }
        
        modules["ascend"].autoRepeatTimer := SetTimer(() => AscendAutoRepeatSequence(), ASCEND_AUTO_REPEAT_INTERVAL)
        ShowTooltip("Ascend Auto-Repeat: ON (every 10 seconds)")
    }
}

AscendAutoRepeatSequence() {
    if (modules["ascend"].autoRepeatTimer == 0)
        return
    
    if (!modules["master"].enabled || !modules["ascend"].enabled || !IsGameActive()) {
        try {
            if (modules["ascend"].autoRepeatTimer != 0 && Type(modules["ascend"].autoRepeatTimer) == "Object") {
                SetTimer(modules["ascend"].autoRepeatTimer, 0)
            }
        } catch {
        }
        modules["ascend"].autoRepeatTimer := 0
        return
    }
    
    isRTimerActive := false
    isJumpTimerActive := false
    isManualJumpActive := false
    
    try {
        isRTimerActive := (modules["ascend"].autoRTimer != 0 && Type(modules["ascend"].autoRTimer) == "Object")
    } catch {
        modules["ascend"].autoRTimer := 0
    }
    
    try {
        isJumpTimerActive := (modules["ascend"].autoJumpTimer != 0 && Type(modules["ascend"].autoJumpTimer) == "Object")
    } catch {
        modules["ascend"].autoJumpTimer := 0
    }
    
    try {
        isManualJumpActive := (modules["ascend"].manualJumpTimer != 0 && Type(modules["ascend"].manualJumpTimer) == "Object")
    } catch {
        modules["ascend"].manualJumpTimer := 0
    }
    
    if (isRTimerActive || isJumpTimerActive || isManualJumpActive)
        return
    
    Send("{LButton}")
    SetTimer(() => AscendAutoRepeatR(), -ASCEND_AUTO_REPEAT_DELAY)
}

AscendAutoRepeatR() {
    if (modules["ascend"].autoRepeatTimer == 0)
        return
    
    if (!modules["master"].enabled || !modules["ascend"].enabled || !IsGameActive())
        return
    
    Send("{r}")
    SetTimer(() => AscendAutoRepeatJump(), -ASCEND_AUTO_JUMP_DELAY)
}

AscendAutoRepeatJump() {
    if (modules["ascend"].autoRepeatTimer == 0)
        return
    
    if (!modules["master"].enabled || !modules["ascend"].enabled || !IsGameActive())
        return
    
    Send("{Space down}")
    Sleep(100)
    Send("{Space up}")
}

~r:: {
    if (!modules["master"].enabled)
        return
    
    if (modules["ascend"].enabled && IsGameActive()) {
        isRTimerActive := false
        isJumpTimerActive := false
        
        try {
            isRTimerActive := (modules["ascend"].autoRTimer != 0 && Type(modules["ascend"].autoRTimer) == "Object")
        } catch {
            modules["ascend"].autoRTimer := 0
        }
        
        try {
            isJumpTimerActive := (modules["ascend"].autoJumpTimer != 0 && Type(modules["ascend"].autoJumpTimer) == "Object")
        } catch {
            modules["ascend"].autoJumpTimer := 0
        }
        
        if (isRTimerActive || isJumpTimerActive)
            return
        
        modules["ascend"].manualJumpTimer := SetTimer(() => AscendJump(), -ASCEND_R_DELAY)
        return
    }
    
    if (modules["bunny"].enabled) {
        if (DISABLE_BUNNY_JUMP_ON_REPEAT && modules["repeat"].enabled) {
            ShowTooltip("Bunny: Jumping disabled by repeat sequence")
            return
        }
        
        modules["bunny"].jumping := !modules["bunny"].jumping
        if (modules["bunny"].jumping) {
            SetTimer(DoubleJump, BUNNY_JUMP_INTERVAL)
            ShowTooltip("Bunny: Jumping ON")
        } else {
            SetTimer(DoubleJump, 0)
            ShowTooltip("Bunny: Jumping OFF")
        }
    }
}

AscendJump() {
    if (!modules["master"].enabled || !modules["ascend"].enabled || !IsGameActive()) {
        modules["ascend"].manualJumpTimer := 0
        return
    }
    
    modules["ascend"].manualJumpTimer := 0
    Send("{Space down}")
    Sleep(100)
    Send("{Space up}")
}

StopAllAscendTimers() {
    try {
        if (modules["ascend"].autoRTimer != 0 && Type(modules["ascend"].autoRTimer) == "Object") {
            SetTimer(modules["ascend"].autoRTimer, 0)
        }
    } catch {
    }
    modules["ascend"].autoRTimer := 0
    
    try {
        if (modules["ascend"].autoJumpTimer != 0 && Type(modules["ascend"].autoJumpTimer) == "Object") {
            SetTimer(modules["ascend"].autoJumpTimer, 0)
        }
    } catch {
    }
    modules["ascend"].autoJumpTimer := 0
    
    try {
        if (modules["ascend"].autoRepeatTimer != 0 && Type(modules["ascend"].autoRepeatTimer) == "Object") {
            SetTimer(modules["ascend"].autoRepeatTimer, 0)
        }
    } catch {
    }
    modules["ascend"].autoRepeatTimer := 0
    
    try {
        if (modules["ascend"].manualJumpTimer != 0 && Type(modules["ascend"].manualJumpTimer) == "Object") {
            SetTimer(modules["ascend"].manualJumpTimer, 0)
        }
    } catch {
    }
    modules["ascend"].manualJumpTimer := 0
    
    try {
        SetTimer(AscendJump, 0)
    } catch {
    }
}

F6::ToggleModule("ascend")
