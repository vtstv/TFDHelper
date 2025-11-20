; TFD Helper Configuration
; https://github.com/vtstv/TFDHelper

#Requires AutoHotkey v2.0

; Game process name
global GAME_EXE := "M1-Win64-Shipping.exe"

; Module state storage
global modules := Map()
global savedModuleStates := Map()
global tooltipTimer := 0

; Feature flags
global DISABLE_BUNNY_JUMP_ON_REPEAT := true
global ASCEND_AUTO_R_ENABLED := true

; Timer intervals (milliseconds)
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
