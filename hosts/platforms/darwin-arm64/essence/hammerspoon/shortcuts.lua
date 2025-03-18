-- Dedicated Hammerspoon Shortcuts Display
local shortcuts = {}

-- Configuration
local config = {
    windowWidth = 600,
    windowHeight = 800,
    fontSize = 14,
    padding = 20,
    categories = {
        ["Window Management"] = {
            ["Screen Movement"] = {},
            ["Window Resizing"] = {},
            ["Grid Management"] = {},
            ["Window Cycling"] = {}
        },
        ["Desktop Canvas"] = {},
        ["System"] = {},
        ["Media"] = {},
        ["Clipboard"] = {},
        ["Apps"] = {}
    }
}

-- Function to format modifier keys for display
local function formatModifiers(mods)
    local modMap = {
        ["cmd"] = "⌘",
        ["command"] = "⌘",
        ["ctrl"] = "⌃",
        ["control"] = "⌃",
        ["alt"] = "⌥",
        ["option"] = "⌥",
        ["shift"] = "⇧",
        ["⌘"] = "⌘",
        ["⌃"] = "⌃",
        ["⌥"] = "⌥",
        ["⇧"] = "⇧"
    }

    local formatted = {}
    for _, mod in ipairs(mods) do
        table.insert(formatted, modMap[mod:lower()] or mod)
    end
    return table.concat(formatted, "")
end

-- Function to categorize hotkeys
local function categorizeHotkey(hotkey)
    local msg = hotkey.msg or ""
    local key = hotkey.key and hotkey.key:upper() or ""
    local mods = formatModifiers(hotkey.mods)
    local description = msg ~= "" and msg or "No description"
    local hotkeyText = string.format("%s%s - %s", mods, key, description)

    -- Categorize based on key words and patterns
    if msg:lower():find("screen") or msg:lower():find("move.*screen") then
        return "Window Management", "Screen Movement", hotkeyText
    elseif msg:lower():find("resize") or msg:lower():find("grid.*resize") then
        return "Window Management", "Window Resizing", hotkeyText
    elseif msg:lower():find("grid") and not msg:lower():find("resize") then
        return "Window Management", "Grid Management", hotkeyText
    elseif msg:lower():find("cycle") or msg:lower():find("workspace") then
        return "Window Management", "Window Cycling", hotkeyText
    elseif msg:lower():find("canvas") or msg:lower():find("draw") then
        return "Desktop Canvas", nil, hotkeyText
    elseif msg:lower():find("reload") or msg:lower():find("lock") then
        return "System", nil, hotkeyText
    elseif msg:lower():find("volume") or msg:lower():find("track") then
        return "Media", nil, hotkeyText
    elseif msg:lower():find("clipboard") then
        return "Clipboard", nil, hotkeyText
    elseif msg:lower():find("launch") or msg:lower():find("app") then
        return "Apps", nil, hotkeyText
    else
        return "Window Management", "Window Resizing", hotkeyText
    end
end

-- Function to create the shortcuts window
local function createShortcutsWindow()
    if shortcuts.window then
        shortcuts.window:delete()
    end

    local screen = hs.screen.mainScreen()
    local frame = screen:frame()
    local windowFrame = {
        x = frame.x + (frame.w - config.windowWidth) / 2,
        y = frame.y + (frame.h - config.windowHeight) / 2,
        w = config.windowWidth,
        h = config.windowHeight
    }

    shortcuts.window = hs.canvas.new(windowFrame)
    shortcuts.window:level(hs.canvas.windowLevels.modalPanel)
    shortcuts.window:behavior(hs.canvas.windowBehaviors.canJoinAllSpaces)

    -- Create the background
    shortcuts.window:appendElements({
        type = "rectangle",
        action = "fill",
        fillColor = { white = 0, alpha = 0.95 },
        frame = { x = 0, y = 0, w = "100%", h = "100%" }
    })

    -- Get all hotkeys
    local allHotkeys = hs.hotkey.getHotkeys()
    local categorizedHotkeys = {}

    -- Categorize all hotkeys
    for _, hotkey in ipairs(allHotkeys) do
        local category, subcategory, hotkeyText = categorizeHotkey(hotkey)
        if subcategory then
            if not categorizedHotkeys[category] then
                categorizedHotkeys[category] = {}
            end
            if not categorizedHotkeys[category][subcategory] then
                categorizedHotkeys[category][subcategory] = {}
            end
            table.insert(categorizedHotkeys[category][subcategory], hotkeyText)
        else
            if not categorizedHotkeys[category] then
                categorizedHotkeys[category] = {}
            end
            table.insert(categorizedHotkeys[category], hotkeyText)
        end
    end

    -- Create the text content
    local textContent = "Hammerspoon Shortcuts\n\n"
    local yOffset = config.padding

    for category, content in pairs(categorizedHotkeys) do
        textContent = textContent .. category .. "\n"
        textContent = textContent .. string.rep("-", #category) .. "\n\n"

        if type(content) == "table" and next(content) then
            for subcategory, hotkeys in pairs(content) do
                if type(hotkeys) == "table" and #hotkeys > 0 then
                    textContent = textContent .. "  " .. subcategory .. ":\n"
                    for _, hotkey in ipairs(hotkeys) do
                        textContent = textContent .. "    " .. hotkey .. "\n"
                    end
                    textContent = textContent .. "\n"
                end
            end
        end
    end

    -- Add the text element
    shortcuts.window:appendElements({
        type = "text",
        text = textContent,
        textColor = { white = 1.0 },
        textSize = config.fontSize,
        frame = { x = config.padding, y = config.padding, w = config.windowWidth - 2 * config.padding, h = config.windowHeight - 2 * config.padding }
    })

    -- Add close button
    shortcuts.window:appendElements({
        type = "rectangle",
        action = "fill",
        fillColor = { red = 0.8, green = 0.2, blue = 0.2, alpha = 1.0 },
        frame = { x = config.windowWidth - 40, y = 10, w = 30, h = 30 }
    }, {
        type = "text",
        text = "×",
        textColor = { white = 1.0 },
        textSize = 20,
        frame = { x = config.windowWidth - 40, y = 10, w = 30, h = 30 }
    })

    -- Add mouse callback for close button
    shortcuts.window:mouseCallback(function(canvas, message, point)
        if message == "mouseDown" then
            if point.x >= config.windowWidth - 40 and point.x <= config.windowWidth - 10 and
               point.y >= 10 and point.y <= 40 then
                shortcuts.hide()
            end
        end
    end)
end

-- Function to show shortcuts
function shortcuts.show()
    if not shortcuts.window then
        createShortcutsWindow()
    end
    shortcuts.window:show()
end

-- Function to hide shortcuts
function shortcuts.hide()
    if shortcuts.window then
        shortcuts.window:hide()
    end
end

-- Function to toggle shortcuts
function shortcuts.toggle()
    if shortcuts.window and shortcuts.window:isShowing() then
        shortcuts.hide()
    else
        shortcuts.show()
    end
end

return shortcuts
