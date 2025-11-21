; TFD Helper Configuration Loader
; https://github.com/vtstv/TFDHelper

#Requires AutoHotkey v2.0

; Config file path
global CONFIG_FILE := A_ScriptDir . "\TFDHelper.ini"

; Module state storage
global modules := Map()
global savedModuleStates := Map()
global tooltipTimer := 0

; Configuration variables (will be loaded from INI)
global GAME_EXE := "M1-Win64-Shipping.exe"
global DISABLE_BUNNY_JUMP_ON_REPEAT := true
global ASCEND_AUTO_R_ENABLED := true
global FREYNA_C_COOLDOWN := 11000
global FREYNA_V_COOLDOWN := 8000
global BUNNY_MOVEMENT_INTERVAL := 50
global BUNNY_MOVEMENT_V_INTERVAL := 2000
global BUNNY_AUTO_V_COOLDOWN := 3000
global BUNNY_AUTO_C_COOLDOWN := 60000
global BUNNY_JUMP_INTERVAL := 100
global TABBER_INTERVAL := 2000
global HAILEY_Q_INTERVAL := 1000
global ASCEND_R_DELAY := 2000
global ASCEND_AUTO_R_DELAY := 2500
global ASCEND_AUTO_JUMP_DELAY := 2000
global ASCEND_AUTO_REPEAT_INTERVAL := 10000
global ASCEND_AUTO_REPEAT_DELAY := 500
global TOOLTIP_DURATION := 1500

LoadConfig() {
    ; Check if config file exists
    if (!FileExist(CONFIG_FILE)) {
        CreateDefaultConfig()
    }
    
    ; Load configuration from INI file
    GAME_EXE := IniRead(CONFIG_FILE, "General", "GameExe", "M1-Win64-Shipping.exe")
    DISABLE_BUNNY_JUMP_ON_REPEAT := IniRead(CONFIG_FILE, "Features", "DisableBunnyJumpOnRepeat", "1") = "1"
    ASCEND_AUTO_R_ENABLED := IniRead(CONFIG_FILE, "Features", "AscendAutoREnabled", "1") = "1"
    
    ; Load timer intervals
    FREYNA_C_COOLDOWN := Integer(IniRead(CONFIG_FILE, "Timers", "FreynaCCooldown", "11000"))
    FREYNA_V_COOLDOWN := Integer(IniRead(CONFIG_FILE, "Timers", "FreynaVCooldown", "8000"))
    BUNNY_MOVEMENT_INTERVAL := Integer(IniRead(CONFIG_FILE, "Timers", "BunnyMovementInterval", "50"))
    BUNNY_MOVEMENT_V_INTERVAL := Integer(IniRead(CONFIG_FILE, "Timers", "BunnyMovementVInterval", "2000"))
    BUNNY_AUTO_V_COOLDOWN := Integer(IniRead(CONFIG_FILE, "Timers", "BunnyAutoVCooldown", "3000"))
    BUNNY_AUTO_C_COOLDOWN := Integer(IniRead(CONFIG_FILE, "Timers", "BunnyAutoCCooldown", "60000"))
    BUNNY_JUMP_INTERVAL := Integer(IniRead(CONFIG_FILE, "Timers", "BunnyJumpInterval", "100"))
    TABBER_INTERVAL := Integer(IniRead(CONFIG_FILE, "Timers", "TabberInterval", "2000"))
    HAILEY_Q_INTERVAL := Integer(IniRead(CONFIG_FILE, "Timers", "HaileyQInterval", "1000"))
    ASCEND_R_DELAY := Integer(IniRead(CONFIG_FILE, "Timers", "AscendRDelay", "2000"))
    ASCEND_AUTO_R_DELAY := Integer(IniRead(CONFIG_FILE, "Timers", "AscendAutoRDelay", "2500"))
    ASCEND_AUTO_JUMP_DELAY := Integer(IniRead(CONFIG_FILE, "Timers", "AscendAutoJumpDelay", "2000"))
    ASCEND_AUTO_REPEAT_INTERVAL := Integer(IniRead(CONFIG_FILE, "Timers", "AscendAutoRepeatInterval", "10000"))
    ASCEND_AUTO_REPEAT_DELAY := Integer(IniRead(CONFIG_FILE, "Timers", "AscendAutoRepeatDelay", "500"))
    TOOLTIP_DURATION := Integer(IniRead(CONFIG_FILE, "Timers", "TooltipDuration", "1500"))
}

CreateDefaultConfig() {
    ; Create config file with default values
    IniWrite("M1-Win64-Shipping.exe", CONFIG_FILE, "General", "GameExe")
    
    IniWrite("1", CONFIG_FILE, "Features", "DisableBunnyJumpOnRepeat")
    IniWrite("1", CONFIG_FILE, "Features", "AscendAutoREnabled")
    
    IniWrite("11000", CONFIG_FILE, "Timers", "FreynaCCooldown")
    IniWrite("8000", CONFIG_FILE, "Timers", "FreynaVCooldown")
    IniWrite("50", CONFIG_FILE, "Timers", "BunnyMovementInterval")
    IniWrite("2000", CONFIG_FILE, "Timers", "BunnyMovementVInterval")
    IniWrite("3000", CONFIG_FILE, "Timers", "BunnyAutoVCooldown")
    IniWrite("60000", CONFIG_FILE, "Timers", "BunnyAutoCCooldown")
    IniWrite("100", CONFIG_FILE, "Timers", "BunnyJumpInterval")
    IniWrite("2000", CONFIG_FILE, "Timers", "TabberInterval")
    IniWrite("1000", CONFIG_FILE, "Timers", "HaileyQInterval")
    IniWrite("2000", CONFIG_FILE, "Timers", "AscendRDelay")
    IniWrite("2500", CONFIG_FILE, "Timers", "AscendAutoRDelay")
    IniWrite("2000", CONFIG_FILE, "Timers", "AscendAutoJumpDelay")
    IniWrite("10000", CONFIG_FILE, "Timers", "AscendAutoRepeatInterval")
    IniWrite("500", CONFIG_FILE, "Timers", "AscendAutoRepeatDelay")
    IniWrite("1500", CONFIG_FILE, "Timers", "TooltipDuration")
    
    MsgBox("Default configuration file created at:`n" . CONFIG_FILE . "`n`nYou can edit this file to customize settings.", "TFD Helper - Config Created", "T5")
}
