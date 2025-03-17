local function cycleAppWindows()
    local app = hs.application.frontmostApplication()
    if not app then return end

    local windows = app:allWindows()
    if #windows == 0 then return end

    local currentWindow = app:focusedWindow()
    local nextWindowIndex = 1

    for i, window in ipairs(windows) do
        if window == currentWindow then
            nextWindowIndex = (i % #windows) + 1
            break
        end
    end

    windows[nextWindowIndex]:focus()
end

hs.hotkey.bind({"⌘", "⌥"}, "Tab", cycleAppWindows)
