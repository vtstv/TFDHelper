; Viessa character module

~4::
~z:: {
    if (!modules["master"].enabled || !modules["viessa"].enabled || !IsGameActive())
        return
    
    if (modules["viessa"].blocking)
        return
    
    modules["viessa"].blocking := true
    Sleep(400)
    
    if (IsGameActive()) {
        Click()
    }
    
    modules["viessa"].blocking := false
}
