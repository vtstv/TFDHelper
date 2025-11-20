; Luna character module

~e:: {
    if (!modules["master"].enabled)
        return
    
    if (modules["luna"].enabled && IsGameActive()) {
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
    
    if (modules["ascend"].enabled && IsGameActive()) {
        ToggleAscendAutoRepeat()
    }
}
