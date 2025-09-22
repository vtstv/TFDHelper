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

; ========== TIMER CONFIGURATION ==========
; Freyna timers (milliseconds)
global FREYNA_C_COOLDOWN := 11000        ; Auto C press every 11 seconds
global FREYNA_V_COOLDOWN := 8000         ; Auto V press every 8 seconds

; Bunny timers (milliseconds)
global BUNNY_MOVEMENT_INTERVAL := 50     ; Movement key switching speed
global BUNNY_MOVEMENT_V_INTERVAL := 2000 ; Movement V press every 2 seconds
global BUNNY_AUTO_V_COOLDOWN := 3000     ; Auto V cooldown (3 seconds)
global BUNNY_AUTO_C_COOLDOWN := 60000    ; Auto C cooldown (60 seconds/1 minute)
global BUNNY_JUMP_INTERVAL := 100        ; Double jump speed

; Tabber timer (milliseconds)
global TABBER_INTERVAL := 2000           ; Tab press every 2 seconds

; Ascend timers (milliseconds)
global ASCEND_R_DELAY := 2000            ; Delay after manual R press before jump
global ASCEND_AUTO_R_ENABLED := true     ; Enable auto R press on left click
global ASCEND_AUTO_R_DELAY := 2500       ; Delay before pressing R after left click (2.5 seconds)
global ASCEND_AUTO_JUMP_DELAY := 2000    ; Delay after auto R before jump (2 seconds)
global ASCEND_AUTO_REPEAT_INTERVAL := 6000 ; Auto-repeat interval (6 seconds)
global ASCEND_AUTO_REPEAT_DELAY := 500   ; Delay before R press in auto-repeat mode (500ms)

; Tooltip timer (milliseconds)
global TOOLTIP_DURATION := 1500          ; How long tooltips stay visible

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
; F6: Toggle ascend module, Left Click: Auto R+Jump sequence (ignores clicks during sequence)
; F7: Toggle auto-repeat Ascend sequence every 6 seconds (500ms delay before R press)

; ========== ASCEND LEFT CLICK ACTIVATION ==========
~LButton:: {
    ; Debug: Uncomment the line below to check what's preventing activation
    ; ShowTooltip("Debug: R_EN=" . ASCEND_AUTO_R_ENABLED . " M=" . modules["master"].enabled . " A=" . modules["ascend"].enabled . " G=" . IsGameActive())
    
    if (!ASCEND_AUTO_R_ENABLED || !modules["master"].enabled || !modules["ascend"].enabled || !IsGameActive())
        return
    
    ; Ignore clicks if sequence is already running - check for valid timer objects
    isRTimerActive := false
    isJumpTimerActive := false
    isManualJumpActive := false
    
    try {
        isRTimerActive := (modules["ascend"].autoRTimer != 0 && Type(modules["ascend"].autoRTimer) == "Object")
    } catch {
        modules["ascend"].autoRTimer := 0  ; Clear invalid reference
    }
    
    try {
        isJumpTimerActive := (modules["ascend"].autoJumpTimer != 0 && Type(modules["ascend"].autoJumpTimer) == "Object")
    } catch {
        modules["ascend"].autoJumpTimer := 0  ; Clear invalid reference
    }
    
    try {
        isManualJumpActive := (modules["ascend"].manualJumpTimer != 0 && Type(modules["ascend"].manualJumpTimer) == "Object")
    } catch {
        modules["ascend"].manualJumpTimer := 0  ; Clear invalid reference
    }
    
    if (isRTimerActive || isJumpTimerActive || isManualJumpActive) {
        return  ; Sequence already in progress, ignore this click
    }
    
    ; Start the auto R sequence - left click executes once and ignores further clicks
    modules["ascend"].autoRTimer := SetTimer(() => AutoRSequence(), -ASCEND_AUTO_R_DELAY)
}

AutoRSequence() {
    ; Add debug logging
    ; ShowTooltip("AutoRSequence: Starting")
    
    if (!modules["master"].enabled || !modules["ascend"].enabled || !IsGameActive()) {
        ; Reset timer if conditions not met
        modules["ascend"].autoRTimer := 0
        return
    }
    
    ; Clear the R timer since we're executing now
    modules["ascend"].autoRTimer := 0
    
    ; Press R (after 2.5s delay from left click)
    Send("{r}")
    
    ; Schedule the jump after 2s delay from R press (one-time execution)
    modules["ascend"].autoJumpTimer := SetTimer(() => AscendJumpAndFinish(), -ASCEND_AUTO_JUMP_DELAY)
}

AscendJumpAndFinish() {
    ; Add debug logging
    ; ShowTooltip("AscendJumpAndFinish: Starting")
    
    if (!modules["master"].enabled || !modules["ascend"].enabled || !IsGameActive()) {
        ; Reset timer if conditions not met
        modules["ascend"].autoJumpTimer := 0
        return
    }
    
    ; Clear the jump timer since we're executing now
    modules["ascend"].autoJumpTimer := 0
    
    ; Execute the jump
    Send("{Space down}")
    Sleep(100)
    Send("{Space up}")
    
}

; ========== ASCEND AUTO-REPEAT FUNCTIONS ==========
ToggleAscendAutoRepeat() {
    if (!modules["master"].enabled || !modules["ascend"].enabled) {
        ShowTooltip("Ascend Auto-Repeat: Module not enabled")
        return
    }
    
    ; Toggle auto-repeat timer
    if (modules["ascend"].autoRepeatTimer != 0) {
        ; Stop auto-repeat
        try {
            SetTimer(modules["ascend"].autoRepeatTimer, 0)
            ; Additional safety: try stopping with the callback function directly
            SetTimer(() => AscendAutoRepeatSequence(), 0)
        } catch {
            ; Timer reference invalid, just clear it
        }
        modules["ascend"].autoRepeatTimer := 0
        ShowTooltip("Ascend Auto-Repeat: OFF")
    } else {
        ; Start auto-repeat
        modules["ascend"].autoRepeatTimer := SetTimer(() => AscendAutoRepeatSequence(), ASCEND_AUTO_REPEAT_INTERVAL)
        ShowTooltip("Ascend Auto-Repeat: ON (every 6 seconds)")
    }
}

AscendAutoRepeatSequence() {
    ; First check if auto-repeat is still enabled
    if (modules["ascend"].autoRepeatTimer == 0) {
        return  ; Auto-repeat has been disabled, stop execution
    }
    
    if (!modules["master"].enabled || !modules["ascend"].enabled || !IsGameActive()) {
        ; Stop auto-repeat if conditions not met
        try {
            if (modules["ascend"].autoRepeatTimer != 0 && Type(modules["ascend"].autoRepeatTimer) == "Object") {
                SetTimer(modules["ascend"].autoRepeatTimer, 0)
            }
        } catch {
            ; Timer reference invalid
        }
        modules["ascend"].autoRepeatTimer := 0
        return
    }
    
    ; Check if manual sequence is already running
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
    
    if (isRTimerActive || isJumpTimerActive || isManualJumpActive) {
        ; Manual or left-click sequence is running, skip this auto-repeat cycle
        return
    }
    
    ; Execute auto-repeat sequence: Start with left click, then R after 500ms delay
    Send("{LButton}")
    SetTimer(() => AscendAutoRepeatR(), -ASCEND_AUTO_REPEAT_DELAY)
}

AscendAutoRepeatR() {
    ; Check if auto-repeat is still enabled
    if (modules["ascend"].autoRepeatTimer == 0) {
        return  ; Auto-repeat has been disabled, stop execution
    }
    
    if (!modules["master"].enabled || !modules["ascend"].enabled || !IsGameActive())
        return
    
    ; Press R
    Send("{r}")
    
    ; Schedule the jump after 2s delay from R press
    SetTimer(() => AscendAutoRepeatJump(), -ASCEND_AUTO_JUMP_DELAY)
}

AscendAutoRepeatJump() {
    ; Check if auto-repeat is still enabled
    if (modules["ascend"].autoRepeatTimer == 0) {
        return  ; Auto-repeat has been disabled, stop execution
    }
    
    if (!modules["master"].enabled || !modules["ascend"].enabled || !IsGameActive())
        return
    
    ; Execute the jump
    Send("{Space down}")
    Sleep(100)
    Send("{Space up}")
}

StopAllAscendTimers() {
    ; Stop all ascend-related timers by setting their intervals to 0
    try {
        if (modules["ascend"].autoRTimer != 0 && Type(modules["ascend"].autoRTimer) == "Object") {
            SetTimer(modules["ascend"].autoRTimer, 0)
        }
    } catch {
        ; Timer reference is invalid, just clear it
    }
    modules["ascend"].autoRTimer := 0
    
    try {
        if (modules["ascend"].autoJumpTimer != 0 && Type(modules["ascend"].autoJumpTimer) == "Object") {
            SetTimer(modules["ascend"].autoJumpTimer, 0)
        }
    } catch {
        ; Timer reference is invalid, just clear it
    }
    modules["ascend"].autoJumpTimer := 0
    
    try {
        if (modules["ascend"].autoRepeatTimer != 0 && Type(modules["ascend"].autoRepeatTimer) == "Object") {
            SetTimer(modules["ascend"].autoRepeatTimer, 0)
        }
    } catch {
        ; Timer reference is invalid, just clear it
    }
    modules["ascend"].autoRepeatTimer := 0
    
    try {
        if (modules["ascend"].manualJumpTimer != 0 && Type(modules["ascend"].manualJumpTimer) == "Object") {
            SetTimer(modules["ascend"].manualJumpTimer, 0)
        }
    } catch {
        ; Timer reference is invalid, just clear it
    }
    modules["ascend"].manualJumpTimer := 0
    
    ; Stop any orphaned AscendJump timers (for manual R press)
    try {
        SetTimer(AscendJump, 0)
    } catch {
        ; Function doesn't exist or other error, ignore
    }
}


; ========== MAIN HOTKEYS ==========
; Freyna module (Numpad5) - Auto C/V with pause on manual press
F3:: {
    if (!modules["master"].enabled || !modules["freyna"].enabled)
        return
    
    modules["freyna"].active := !modules["freyna"].active
    if (modules["freyna"].active) {
        if (!modules["freyna"].paused) {
            SetTimer(() => PressKey("c"), FREYNA_C_COOLDOWN)
            SetTimer(() => PressKey("v"), FREYNA_V_COOLDOWN)
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
        SetTimer(() => PressKey("c"), FREYNA_C_COOLDOWN)
        SetTimer(() => PressKey("v"), FREYNA_V_COOLDOWN)
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
            SetTimer(() => PressKey("c"), FREYNA_C_COOLDOWN)
            SetTimer(() => PressKey("v"), FREYNA_V_COOLDOWN)
            ShowTooltip("Freyna: RESUMED")
        }
        return
    }
    
    ; Handle Bunny Auto V toggle
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
    if (!modules["master"].enabled)
        return
    
    ; Handle Bunny jumping
    if (modules["bunny"].enabled) {
        modules["bunny"].jumping := !modules["bunny"].jumping
        if (modules["bunny"].jumping) {
            SetTimer(DoubleJump, BUNNY_JUMP_INTERVAL)
            ShowTooltip("Bunny: Jumping ON")
        } else {
            SetTimer(DoubleJump, 0)
            ShowTooltip("Bunny: Jumping OFF")
        }
    }
    
    ; Handle Ascending set ammo reload (manual R press)
    if (modules["master"].enabled && modules["ascend"].enabled && IsGameActive()) {
        ; Check if left-click sequence is already running
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
        
        if (isRTimerActive || isJumpTimerActive) {
            ; Left-click sequence is running, ignore manual R press
            return
        }
        
        ; Check if manual sequence is already running
        try {
            if (modules["ascend"].manualJumpTimer != 0 && Type(modules["ascend"].manualJumpTimer) == "Object") {
                ; Manual sequence already running, ignore this R press
                return
            }
        } catch {
            modules["ascend"].manualJumpTimer := 0
        }
        
        ; Start manual R sequence and track the timer
        modules["ascend"].manualJumpTimer := SetTimer(AscendJump, -ASCEND_R_DELAY)
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
        SetTimer(BunnyMovement, BUNNY_MOVEMENT_INTERVAL)
        SetTimer(BunnyMovementV, BUNNY_MOVEMENT_V_INTERVAL)
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
        SetTimer(BunnyAutoC, BUNNY_AUTO_C_COOLDOWN)
        ShowTooltip("Bunny Auto C: ON")
    } else {
        SetTimer(BunnyAutoC, 0)
        ShowTooltip("Bunny Auto C: OFF")
    }
}

; Ascending set ammo reload
F6::ToggleModule("ascend")           ; Toggle ascend module
F7::ToggleAscendAutoRepeat()         ; Toggle auto-repeat Ascend sequence every 6 seconds

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
    modules["ascend"] := {enabled: false, autoRTimer: 0, autoJumpTimer: 0, autoRepeatTimer: 0, manualJumpTimer: 0}
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
            SetTimer(TabberFunction, TABBER_INTERVAL)
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
    
    ; Stop all ascend timers using dedicated cleanup function
    StopAllAscendTimers()
    
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
        case "ascend":
            ; Stop all ascend timers using dedicated cleanup function
            StopAllAscendTimers()
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
            case "ascend":
                savedState["enabled"] := moduleData.enabled
                savedState["autoRTimer"] := 0          ; Don't save timer references
                savedState["autoJumpTimer"] := 0       ; Don't save timer references
                savedState["autoRepeatTimer"] := 0     ; Don't save timer references
                savedState["manualJumpTimer"] := 0     ; Don't save timer references
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
            case "ascend":
                modules["ascend"].enabled := savedState["enabled"]
                modules["ascend"].autoRTimer := 0        ; Reset timers
                modules["ascend"].autoJumpTimer := 0     ; Reset timers
                modules["ascend"].autoRepeatTimer := 0   ; Reset timers
                modules["ascend"].manualJumpTimer := 0   ; Reset timers
        }
        
        ; Restart timers for active modules
        if (modules[moduleName].enabled) {
            switch moduleName {
                case "freyna":
                    if (modules["freyna"].active && !modules["freyna"].paused) {
                        SetTimer(() => PressKey("c"), FREYNA_C_COOLDOWN)
                        SetTimer(() => PressKey("v"), FREYNA_V_COOLDOWN)
                    }
                case "bunny":
                    if (modules["bunny"].running) {
                        SetTimer(BunnyMovement, BUNNY_MOVEMENT_INTERVAL)
                        SetTimer(BunnyMovementV, BUNNY_MOVEMENT_V_INTERVAL)
                    }
                    if (modules["bunny"].jumping) {
                        SetTimer(DoubleJump, BUNNY_JUMP_INTERVAL)
                    }
                    if (modules["bunny"].autoV) {
                        SetTimer(BunnyAutoV, BUNNY_AUTO_V_COOLDOWN)
                    }
                    if (modules["bunny"].autoC) {
                        SetTimer(BunnyAutoC, BUNNY_AUTO_C_COOLDOWN)
                    }
                case "tabber":
                    if (modules["tabber"].active) {
                        SetTimer(TabberFunction, TABBER_INTERVAL)
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

AscendJump() {
    if (!modules["master"].enabled || !modules["ascend"].enabled || !IsGameActive()) {
        ; Clear manual timer if conditions not met
        modules["ascend"].manualJumpTimer := 0
        return
    }
    
    ; Clear the manual timer since we're executing now
    modules["ascend"].manualJumpTimer := 0
    
    Send("{Space down}")
    Sleep(100)
    Send("{Space up}")
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
    SetTimer(tooltipTimer, -TOOLTIP_DURATION)
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
    status .= "Repeat (Num7): " . (modules["repeat"].enabled ? "ON" : "OFF") . "`n"
    
    ; Ascend module with auto-repeat status
    ascendStatus := modules["ascend"].enabled ? "ON" : "OFF"
    if (modules["ascend"].enabled && modules["ascend"].autoRepeatTimer != 0) {
        ascendStatus .= " + Auto-Repeat"
    }
    status .= "Ascend (F6): " . ascendStatus . "`n"
    status .= "Ascend Auto-Repeat (F7): " . (modules["ascend"].autoRepeatTimer != 0 ? "ON" : "OFF")
    
    MsgBox(status, "TFD Helper Status", "T3")
}

; ========== EXIT HANDLER ==========
OnExit((*) => SetTimer(() => ToolTip(), 0))