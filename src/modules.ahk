; Module initialization and management

InitializeModules() {
    modules["master"] := {enabled: true}
    modules["tabber"] := {enabled: false, active: false}
    modules["bunny"] := {enabled: false, running: false, jumping: false, autoV: false, autoC: false, keyIndex: 1}
    modules["luna"] := {enabled: false}
    modules["viessa"] := {enabled: false, blocking: false}
    modules["freyna"] := {enabled: false, active: false, paused: false}
    modules["quest"] := {enabled: false}
    modules["repeat"] := {enabled: false}
    modules["ascend"] := {enabled: false, autoRTimer: 0, autoJumpTimer: 0, autoRepeatTimer: 0, manualJumpTimer: 0}
    modules["hailey"] := {enabled: false, paused: false}
}

ToggleModule(moduleName) {
    if (moduleName == "master") {
        modules["master"].enabled := !modules["master"].enabled
        if (!modules["master"].enabled) {
            SaveModuleStates()
            DisableAllModules()
            ShowTooltip("MASTER: OFF - State saved, all functions disabled")
        } else {
            RestoreModuleStates()
            ShowTooltip("MASTER: ON - Previous state restored")
        }
        return
    }
    
    if (!modules["master"].enabled)
        return
    
    characterClasses := ["freyna", "bunny", "viessa", "luna", "hailey"]
    if (HasValue(characterClasses, moduleName)) {
        if (!modules[moduleName].enabled) {
            for className in characterClasses {
                if (className != moduleName && modules[className].enabled) {
                    modules[className].enabled := false
                    DisableModule(className)
                    ShowTooltip(className . ": AUTO-DISABLED (class conflict)")
                    Sleep(800)
                }
            }
        }
    }
    
    modules[moduleName].enabled := !modules[moduleName].enabled
    
    if (modules[moduleName].enabled) {
        EnableModule(moduleName)
    } else {
        DisableModule(moduleName)
    }
}

EnableModule(moduleName) {
    switch moduleName {
        case "tabber":
            SetTimer(TabberFunction, TABBER_INTERVAL)
            modules["tabber"].active := true
            ShowTooltip("Tabber: ON")
            
        case "bunny":
            ShowTooltip("Bunny: ON (F4=Movement, R=Jump, V=AutoV, F5=AutoC)")
            
        case "luna":
            ShowTooltip("Luna: ON (E to combo)")
            
        case "viessa":
            ShowTooltip("Viessa: ON (4/Z for auto-click)")
            
        case "freyna":
            ShowTooltip("Freyna: ON (F3 to toggle auto C/V)")
            
        case "quest":
            ShowTooltip("Quest Abort: ON (T key)")
            
        case "repeat":
            ShowTooltip("Repeat: ON (T key)")
            
        case "ascend":
            ShowTooltip("Ascend: ON (LClick=Auto, R=Manual, E=AutoRepeat)")
            
        case "hailey":
            modules["hailey"].paused := false
            SetTimer(HaileyAutoQ, HAILEY_Q_INTERVAL)
            ShowTooltip("Hailey: ON (Auto Q every 2s, Q to pause)")
    }
}

DisableModule(moduleName) {
    switch moduleName {
        case "tabber":
            SetTimer(TabberFunction, 0)
            modules["tabber"].active := false
            ShowTooltip("Tabber: OFF")
            
        case "bunny":
            SetTimer(BunnyMovement, 0)
            SetTimer(DoubleJump, 0)
            SetTimer(BunnyMovementV, 0)
            SetTimer(BunnyAutoV, 0)
            SetTimer(BunnyAutoC, 0)
            modules["bunny"].running := false
            modules["bunny"].jumping := false
            modules["bunny"].autoV := false
            modules["bunny"].autoC := false
            ShowTooltip("Bunny: OFF")
            
        case "luna":
            ShowTooltip("Luna: OFF")
            
        case "viessa":
            ShowTooltip("Viessa: OFF")
            
        case "freyna":
            SetTimer(() => PressKey("c"), 0)
            SetTimer(() => PressKey("v"), 0)
            modules["freyna"].active := false
            modules["freyna"].paused := false
            ShowTooltip("Freyna: OFF")
            
        case "quest":
            ShowTooltip("Quest Abort: OFF")
            
        case "repeat":
            ShowTooltip("Repeat: OFF")
            
        case "ascend":
            StopAllAscendTimers()
            ShowTooltip("Ascend: OFF")
            
        case "hailey":
            SetTimer(HaileyAutoQ, 0)
            modules["hailey"].paused := false
            ShowTooltip("Hailey: OFF")
    }
}

SaveModuleStates() {
    savedModuleStates.Clear()
    for moduleName, moduleData in modules {
        if (moduleName == "master")
            continue
        
        savedState := Map()
        
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
                savedState["autoRTimer"] := 0
                savedState["autoJumpTimer"] := 0
                savedState["autoRepeatTimer"] := 0
                savedState["manualJumpTimer"] := 0
            case "hailey":
                savedState["enabled"] := moduleData.enabled
                savedState["paused"] := moduleData.paused
        }
        
        savedModuleStates[moduleName] := savedState
    }
}

RestoreModuleStates() {
    if (savedModuleStates.Count == 0)
        return
    
    for moduleName, savedState in savedModuleStates {
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
            case "hailey":
                modules["hailey"].enabled := savedState["enabled"]
                modules["hailey"].paused := savedState["paused"]
        }
        
        if (savedState["enabled"] && modules[moduleName].enabled) {
            EnableModule(moduleName)
        } else if (!savedState["enabled"]) {
            DisableModule(moduleName)
        }
    }
}

DisableAllModules() {
    for moduleName, moduleData in modules {
        if (moduleName != "master" && moduleData.enabled) {
            modules[moduleName].enabled := false
            DisableModule(moduleName)
        }
    }
}
