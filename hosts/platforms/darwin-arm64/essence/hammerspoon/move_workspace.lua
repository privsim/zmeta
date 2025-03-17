local function moveWindowToSpace(direction)
    local win = hs.window.focusedWindow()
    if not win then return end

    local screen = win:screen()
    local spaces = hs.spaces.allSpaces()[screen:getUUID()]
    local currentSpace = hs.spaces.windowSpaces(win)[1]
    local nextSpaceIndex = 1

    for i, space in ipairs(spaces) do
        if space == currentSpace then
            if direction == "next" then
                nextSpaceIndex = i + 1
                if nextSpaceIndex > #spaces then nextSpaceIndex = 1 end
            elseif direction == "previous" then
                nextSpaceIndex = i - 1
                if nextSpaceIndex < 1 then nextSpaceIndex = #spaces end
            end
            break
        end
    end

    hs.spaces.moveWindowToSpace(win:id(), spaces[nextSpaceIndex])
    hs.spaces.gotoSpace(spaces[nextSpaceIndex])
    win:focus()
end

hs.hotkey.bind({"⌘", "⌥"}, "/", function() moveWindowToSpace("next") end)
hs.hotkey.bind({"⌘", "⌥", "shift"}, "/", function() moveWindowToSpace("previous") end)
