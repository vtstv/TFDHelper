; ========== TFD Helper by Murr ==========
; https://github.com/vtstv/TFDHelper


#Requires AutoHotkey v2.0
#SingleInstance Force
SendMode("Input")
CoordMode("ToolTip", "Screen")

; ========== GLOBAL CONFIG ==========
global GAME_EXE := "M1-Win64-Shipping.exe"
global modules := Map()
global tooltipTimer := 0
global savedModuleStates := Map()  ; Store module states when master is disabled
global DISABLE_BUNNY_JUMP_ON_REPEAT := true  ; When true, auto repeat disables bunny jumping

; ========== MODULE DEFINITIONS ==========
; Initialize all modules as disabled
InitializeModules()

; ========== HOTKEY MAPPINGS ==========
Numpad0::ToggleModule("master")      ; Master ON/OFF toggle (disables/enables all)
Numpad1::ToggleModule("tabber")      ; Auto tab presser (every 2 seconds)
Numpad2::ToggleModule("bunny")       ; Movement + jumping + Auto V + Auto C (R to toggle jumping, V to toggle Auto V, F4 to toggle movement, F5 to toggle Auto C)
Numpad3::ToggleModule("luna")        ; Triple skill combo (E to spam Z,V,C)
Numpad4::ToggleModule("viessa")      ; Auto-click after skill  (4 key or Z key)
Numpad5::ToggleModule("freyna")      ; Auto C/V presser (F3 to toggle, manual C/V pauses)
Numpad6::ToggleModule("quest")       ; Quest abort sequence (T key: ESC -> Click -> Space -> F2 hold -> R hold)
Numpad7::ToggleModule("repeat")      ; F2+R sequence (T key: for repeatable quests - optionally disables bunny jumping)
Numpad8::ShowStatus()                ; Show all module status (including master and character classes)


; ========== MAIN HOTKEYS ==========
; Freyna module (Numpad5) - Auto C/V with pause on manual press
F3:: {
    if (!modules["master"].enabled || !modules["freyna"].enabled)
        return
    
    modules["freyna"].active := !modules["freyna"].active
    if (modules["freyna"].active) {
        if (!modules["freyna"].paused) {
            SetTimer(() => PressKey("c"), 11000)
            SetTimer(() => PressKey("v"), 8000)
        }
        ShowTooltip("Freyna: ON")
    } else {
        SetTimer(() => PressKey("c"), 0)
        SetTimer(() => PressKey("v"), 0)
        ShowTooltip("Freyna: OFF")
    }
}

; Manual C/V pauses Freyna auto-press
~c:: {
    if (!modules["master"].enabled || !modules["freyna"].enabled || !modules["freyna"].active)
        return
    
    modules["freyna"].paused := !modules["freyna"].paused
    if (modules["freyna"].paused) {
        SetTimer(() => PressKey("c"), 0)
        SetTimer(() => PressKey("v"), 0)
        ShowTooltip("Freyna: PAUSED")
    } else {
        SetTimer(() => PressKey("c"), 11000)
        SetTimer(() => PressKey("v"), 8000)
        ShowTooltip("Freyna: RESUMED")
    }
}

~v:: {
    ; Block all functionality when master is disabled
    if (!modules["master"].enabled)
        return
        
    ; Handle Freyna pause functionality
    if (modules["freyna"].enabled && modules["freyna"].active) {
        modules["freyna"].paused := !modules["freyna"].paused
        if (modules["freyna"].paused) {
            SetTimer(() => PressKey("c"), 0)
            SetTimer(() => PressKey("v"), 0)
            ShowTooltip("Freyna: PAUSED")
        } else {
            SetTimer(() => PressKey("c"), 11000)
            SetTimer(() => PressKey("v"), 8000)
            ShowTooltip("Freyna: RESUMED")
        }
        return
    }
    
    ; Handle Bunny Auto V toggle
    if (modules["bunny"].enabled) {
        modules["bunny"].autoV := !modules["bunny"].autoV
        if (modules["bunny"].autoV) {
            SetTimer(BunnyAutoV, 3000)  ; 3 second cooldown
            ShowTooltip("Bunny Auto V: ON")
        } else {
            SetTimer(BunnyAutoV, 0)
            ShowTooltip("Bunny Auto V: OFF")
        }
        return
    }
    
    ; Block during Viessa skill
    if (modules["viessa"].enabled && modules["viessa"].blocking)
        return
}

; Quest abort sequence (Numpad6) and Repeat sequence (Numpad7)
~t:: {
    ; Block all functionality when master is disabled
    if (!modules["master"].enabled)
        return
    
    ; Handle Quest abort
    if (modules["quest"].enabled && IsGameActive()) {
        ; ESC -> Click -> Space -> F2 hold -> R hold
        Send("{Esc}")
        Sleep(100)
        Click(217, 436)
        Sleep(100)
        Send("{Space}")
        Sleep(1000)
        Send("{F2 down}")
        Sleep(2000)
        Send("{F2 up}")
        Sleep(1000)
        Send("{r down}")
        Sleep(2000)
        Send("{r up}")
        return
    }
    
    ; Handle Repeat sequence
    if (modules["repeat"].enabled) {
        ; Optional: Disable bunny jumping when repeat is triggered
        if (DISABLE_BUNNY_JUMP_ON_REPEAT && modules["bunny"].enabled && modules["bunny"].jumping) {
            modules["bunny"].jumping := false
            SetTimer(DoubleJump, 0)
            ShowTooltip("Bunny: Jumping disabled by repeat sequence")
            Sleep(1000)  ; Brief pause to show the tooltip
        }
        
        ; F2 hold -> wait -> R hold
        Send("{F2 down}")
        Sleep(1500)
        Send("{F2 up}")
        Sleep(2000)
        Send("{r down}")
        Sleep(1500)
        Send("{r up}")
        return
    }
}

; Bunny jumping (Numpad3)
~r:: {
    if (!modules["master"].enabled || !modules["bunny"].enabled)
        return
    
    modules["bunny"].jumping := !modules["bunny"].jumping
    if (modules["bunny"].jumping) {
        SetTimer(DoubleJump, 100)
        ShowTooltip("Bunny: Jumping ON")
    } else {
        SetTimer(DoubleJump, 0)
        ShowTooltip("Bunny: Jumping OFF")
    }
}

; Luna combo (Numpad3)
~e:: {
    if (!modules["master"].enabled)
        return
    
    ; Handle Luna combo
    if (modules["luna"].enabled && IsGameActive()) {
        ; Press Z, V, C twice each with 50ms delay
        Send("{z}")
        Sleep(50)
        Send("{z}")
        Send("{v}")
        Sleep(50)
        Send("{v}")
        Send("{c}")
        Sleep(50)
        Send("{c}")
        return
    }
}

; Bunny movement (Numpad2)
F4:: {
    if (!modules["master"].enabled || !modules["bunny"].enabled)
        return
    
    modules["bunny"].running := !modules["bunny"].running
    if (modules["bunny"].running) {
        SetTimer(BunnyMovement, 50)
        SetTimer(BunnyMovementV, 2000)
        ShowTooltip("Bunny: Movement ON")
    } else {
        SetTimer(BunnyMovement, 0)
        SetTimer(BunnyMovementV, 0)
        ShowTooltip("Bunny: Movement OFF")
    }
}

; Bunny auto C (Numpad2)
F5:: {
    if (!modules["master"].enabled || !modules["bunny"].enabled)
        return
    
    modules["bunny"].autoC := !modules["bunny"].autoC
    if (modules["bunny"].autoC) {
        SetTimer(BunnyAutoC, 60000)  ; 60 second (1 minute) cooldown
        ShowTooltip("Bunny Auto C: ON")
    } else {
        SetTimer(BunnyAutoC, 0)
        ShowTooltip("Bunny Auto C: OFF")
    }
}

; Viessa auto-click (Numpad6)
~4::
~z::{
    if (!modules["master"].enabled || !modules["viessa"].enabled)
        return
    
    modules["viessa"].blocking := true
    Sleep(400)
    
    if (IsGameActive()) {
        Click()
    }
    
    modules["viessa"].blocking := false
}

; ========== HELPER FUNCTIONS ==========
InitializeModules() {
    modules["freyna"] := {enabled: false, active: false, paused: false}
    modules["quest"] := {enabled: false}
    modules["bunny"] := {enabled: false, running: false, jumping: false, autoV: false, autoC: false, keyIndex: 1}
    modules["luna"] := {enabled: false}
    modules["tabber"] := {enabled: false, active: false}
    modules["viessa"] := {enabled: false, blocking: false}
    modules["repeat"] := {enabled: false}
    modules["master"] := {enabled: true}
    
    ; Start tabber timer if enabled
    SetTimer(TabberFunction, 0)
}

ToggleModule(moduleName) {
    ; Special handling for master toggle
    if (moduleName == "master") {
        modules["master"].enabled := !modules["master"].enabled
        if (!modules["master"].enabled) {
            ; Master OFF - save current state and disable everything
            SaveModuleStates()
            DisableAllModules()
            ShowTooltip("MASTER: OFF - State saved, all functions disabled")
        } else {
            ; Master ON - restore previous state
            RestoreModuleStates()
            ShowTooltip("MASTER: ON - Previous state restored")
        }
        return
    }
    
    ; Block all other module toggles when master is OFF
    if (!modules["master"].enabled)
        return
    
    ; Handle character class exclusivity
    characterClasses := ["freyna", "bunny", "viessa", "luna"]
    if (HasValue(characterClasses, moduleName)) {
        ; If enabling a character class, disable all other character classes
        if (!modules[moduleName].enabled) {
            for className in characterClasses {
                if (className != moduleName && modules[className].enabled) {
                    ; Disable the other character class
                    modules[className].enabled := false
                    DisableCharacterModule(className)
                    ShowTooltip(className . ": AUTO-DISABLED (class conflict)")
                    Sleep(800)  ; Brief pause between tooltips
                }
            }
        }
    }
    
    modules[moduleName].enabled := !modules[moduleName].enabled
    status := modules[moduleName].enabled ? "ON" : "OFF"
    
    ; Stop module timers when disabled
    if (!modules[moduleName].enabled) {
        DisableCharacterModule(moduleName)
    } else {
        ; Auto-start tabber when enabled
        if (moduleName == "tabber") {
            SetTimer(TabberFunction, 2000)
            modules["tabber"].active := true
        }
    }
    
    ShowTooltip(moduleName . ": " . status)
}

DisableAllModules() {
    ; Stop all timers and reset all module states
    SetTimer(() => PressKey("c"), 0)
    SetTimer(() => PressKey("v"), 0)
    SetTimer(BunnyMovement, 0)
    SetTimer(BunnyMovementV, 0)
    SetTimer(BunnyAutoV, 0)
    SetTimer(BunnyAutoC, 0)
    SetTimer(DoubleJump, 0)
    SetTimer(TabberFunction, 0)
    
    ; Reset all module states
    modules["freyna"].active := false
    modules["freyna"].paused := false
    modules["bunny"].running := false
    modules["bunny"].jumping := false
    modules["bunny"].autoV := false
    modules["bunny"].autoC := false
    modules["tabber"].active := false
    modules["viessa"].blocking := false
}

DisableCharacterModule(moduleName) {
    ; Stop timers and reset states for specific character modules
    switch moduleName {
        case "freyna":
            SetTimer(() => PressKey("c"), 0)
            SetTimer(() => PressKey("v"), 0)
            modules["freyna"].active := false
            modules["freyna"].paused := false
        case "bunny":
            SetTimer(BunnyMovement, 0)
            SetTimer(DoubleJump, 0)
            SetTimer(BunnyMovementV, 0)  ; Stop movement V timer
            SetTimer(BunnyAutoV, 0)      ; Stop Auto V timer
            SetTimer(BunnyAutoC, 0)      ; Stop Auto C timer
            modules["bunny"].running := false
            modules["bunny"].jumping := false
            modules["bunny"].autoV := false
            modules["bunny"].autoC := false
        case "tabber":
            SetTimer(TabberFunction, 0)
            modules["tabber"].active := false
        case "viessa":
            modules["viessa"].blocking := false
        case "luna":
            ; Luna doesn't have persistent timers, just reset any states if needed
    }
}

HasValue(arr, value) {
    ; Helper function to check if array contains a value
    for item in arr {
        if (item == value)
            return true
    }
    return false
}

SaveModuleStates() {
    ; Save the current state of all modules
    for moduleName, moduleData in modules {
        if (moduleName == "master")
            continue
        
        ; Create a deep copy of the module state using property access
        savedState := Map()
        
        ; Handle each module type specifically to avoid enumeration issues
        switch moduleName {
            case "freyna":
                savedState["enabled"] := moduleData.enabled
                savedState["active"] := moduleData.active
                savedState["paused"] := moduleData.paused
            case "quest":
                savedState["enabled"] := moduleData.enabled
            case "bunny":
                savedState["enabled"] := moduleData.enabled
                savedState["running"] := moduleData.running
                savedState["jumping"] := moduleData.jumping
                savedState["autoV"] := moduleData.autoV
                savedState["autoC"] := moduleData.autoC
                savedState["keyIndex"] := moduleData.keyIndex
            case "luna":
                savedState["enabled"] := moduleData.enabled
            case "tabber":
                savedState["enabled"] := moduleData.enabled
                savedState["active"] := moduleData.active
            case "viessa":
                savedState["enabled"] := moduleData.enabled
                savedState["blocking"] := moduleData.blocking
            case "repeat":
                savedState["enabled"] := moduleData.enabled
        }
        
        savedModuleStates[moduleName] := savedState
    }
}

RestoreModuleStates() {
    ; Restore previously saved module states
    if (savedModuleStates.Count == 0)
        return
    
    for moduleName, savedState in savedModuleStates {
        ; Restore the state using property access
        switch moduleName {
            case "freyna":
                modules["freyna"].enabled := savedState["enabled"]
                modules["freyna"].active := savedState["active"]
                modules["freyna"].paused := savedState["paused"]
            case "quest":
                modules["quest"].enabled := savedState["enabled"]
            case "bunny":
                modules["bunny"].enabled := savedState["enabled"]
                modules["bunny"].running := savedState["running"]
                modules["bunny"].jumping := savedState["jumping"]
                modules["bunny"].autoV := savedState["autoV"]
                modules["bunny"].autoC := savedState["autoC"]
                modules["bunny"].keyIndex := savedState["keyIndex"]
            case "luna":
                modules["luna"].enabled := savedState["enabled"]
            case "tabber":
                modules["tabber"].enabled := savedState["enabled"]
                modules["tabber"].active := savedState["active"]
            case "viessa":
                modules["viessa"].enabled := savedState["enabled"]
                modules["viessa"].blocking := savedState["blocking"]
            case "repeat":
                modules["repeat"].enabled := savedState["enabled"]
        }
        
        ; Restart timers for active modules
        if (modules[moduleName].enabled) {
            switch moduleName {
                case "freyna":
                    if (modules["freyna"].active && !modules["freyna"].paused) {
                        SetTimer(() => PressKey("c"), 11000)
                        SetTimer(() => PressKey("v"), 8000)
                    }
                case "bunny":
                    if (modules["bunny"].running) {
                        SetTimer(BunnyMovement, 50)
                        SetTimer(BunnyMovementV, 2000)
                    }
                    if (modules["bunny"].jumping) {
                        SetTimer(DoubleJump, 100)
                    }
                    if (modules["bunny"].autoV) {
                        SetTimer(BunnyAutoV, 3000)  ; 3 second cooldown
                    }
                    if (modules["bunny"].autoC) {
                        SetTimer(BunnyAutoC, 60000)  ; 60 second (1 minute) cooldown
                    }
                case "tabber":
                    if (modules["tabber"].active) {
                        SetTimer(TabberFunction, 2000)
                    }
            }
        }
    }
}

IsGameActive() {
    try {
        return WinGetProcessName("A") == GAME_EXE
    } catch {
        return false
    }
}

PressKey(key) {
    if (!modules["master"].enabled || !IsGameActive())
        return
    Send("{" . key . "}")
}

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

TabberFunction() {
    if (!modules["master"].enabled || !modules["tabber"].enabled || !IsGameActive())
        return
    Send("{Tab}")
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

ShowTooltip(text) {
    global tooltipTimer
    x := A_ScreenWidth - 220
    y := 10
    ToolTip(text, x, y)
    
    ; Clear previous timer and set new one
    if (tooltipTimer)
        SetTimer(tooltipTimer, 0)
    tooltipTimer := () => ToolTip()
    SetTimer(tooltipTimer, -1500)
}

ShowStatus() {
    status := "=== TFD Helper Status ===`n"
    masterStatus := modules["master"].enabled ? "ON" : "OFF (ALL DISABLED)"
    status .= "Master (Num8): " . masterStatus . "`n"
    
    if (!modules["master"].enabled) {
        status .= "`n*** MASTER IS OFF - ALL FUNCTIONS DISABLED ***`n"
    }
    
    ; Show character classes with highlighting for active one
    status .= "`n--- CHARACTER CLASSES (Mutually Exclusive) ---`n"
    activeClass := ""
    if (modules["freyna"].enabled) {
        activeClass := "Freyna"
    } else if (modules["bunny"].enabled) {
        activeClass := "Bunny"
    } else if (modules["viessa"].enabled) {
        activeClass := "Viessa"
    } else if (modules["luna"].enabled) {
        activeClass := "Luna"
    }
    
    if (activeClass != "") {
        status .= "Active Class: " . activeClass . "`n"
    } else {
        status .= "Active Class: None`n"
    }
    
    status .= "Bunny (Num2): " . (modules["bunny"].enabled ? "ON ★" : "OFF") . "`n"
    status .= "Luna (Num3): " . (modules["luna"].enabled ? "ON ★" : "OFF") . "`n"
    status .= "Viessa (Num4): " . (modules["viessa"].enabled ? "ON ★" : "OFF") . "`n"
    status .= "Freyna (Num5): " . (modules["freyna"].enabled ? "ON ★" : "OFF") . "`n"

    status .= "`n--- UTILITY MODULES ---`n"
    status .= "Tabber (Num1): " . (modules["tabber"].enabled ? "ON" : "OFF") . "`n"
    status .= "Quest (Num6): " . (modules["quest"].enabled ? "ON" : "OFF") . "`n"
    status .= "Repeat (Num7): " . (modules["repeat"].enabled ? "ON" : "OFF")
    
    MsgBox(status, "TFD Helper Status", "T3")
}

; ========== EXIT HANDLER ==========
OnExit((*) => SetTimer(() => ToolTip(), 0))