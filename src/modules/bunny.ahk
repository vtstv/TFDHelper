; Bunny character module

BunnyMovement() {
    if (!modules["master"].enabled || !IsGameActive())
        return
    
    keys := ["w", "a", "s", "d"]
    key := keys[modules["bunny"].keyIndex]
    
    Send("{" . key . " down}")
    Sleep(500)
    Send("{" . key . " up}")
    
    modules["bunny"].keyIndex := Mod(modules["bunny"].keyIndex, 4) + 1
}

DoubleJump() {
    if (!modules["master"].enabled || !IsGameActive())
        return
    
    Send("{Space down}")
    Sleep(100)
    Send("{Space up}")
    Sleep(100)
    Send("{Space down}")
    Sleep(100)
    Send("{Space up}")
}

BunnyAutoV() {
    if (!modules["master"].enabled || !IsGameActive())
        return
    Send("{v}")
}

BunnyMovementV() {
    if (!modules["master"].enabled || !IsGameActive())
        return
    Send("{v}")
}

BunnyAutoC() {
    if (!modules["master"].enabled || !IsGameActive())
        return
    Send("{c}")
}

F4:: {
    if (!modules["master"].enabled || !modules["bunny"].enabled || !IsGameActive())
        return
    
    modules["bunny"].running := !modules["bunny"].running
    if (modules["bunny"].running) {
        SetTimer(BunnyMovement, BUNNY_MOVEMENT_INTERVAL)
        SetTimer(BunnyMovementV, BUNNY_MOVEMENT_V_INTERVAL)
        ShowTooltip("Bunny: Movement ON")
    } else {
        SetTimer(BunnyMovement, 0)
        SetTimer(BunnyMovementV, 0)
        ShowTooltip("Bunny: Movement OFF")
    }
}

F5:: {
    if (!modules["master"].enabled || !modules["bunny"].enabled || !IsGameActive())
        return
    
    modules["bunny"].autoC := !modules["bunny"].autoC
    if (modules["bunny"].autoC) {
        SetTimer(BunnyAutoC, BUNNY_AUTO_C_COOLDOWN)
        ShowTooltip("Bunny Auto C: ON")
    } else {
        SetTimer(BunnyAutoC, 0)
        ShowTooltip("Bunny Auto C: OFF")
    }
}
