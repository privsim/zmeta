-- Dedicated Hammerspoon Shortcuts Display
local shortcuts = {}

-- Configuration
local config = {
    windowWidth = 1000,  -- Wider to match KSheet style
    windowHeight = 700,
    fontSize = 13,
    padding = 10,
    lineHeight = 16,
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

-- Function to format hotkey text in KSheet style
local function formatHotkeyText(mods, key, description)
    local modText = formatModifiers(mods)
    -- Pad the key combination to align descriptions
    local keyCombo = string.format("%-12s", modText .. key)
    return keyCombo .. " → " .. description
end

-- Function to categorize hotkeys
local function categorizeHotkey(hotkey)
    local msg = hotkey.msg or ""
    local key = hotkey.key and hotkey.key:upper() or ""
    local description = msg ~= "" and msg or "No description"
    local hotkeyText = formatHotkeyText(hotkey.mods, key, description)

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

    -- Create the background (KSheet style)
    shortcuts.window:appendElements({
        type = "rectangle",
        action = "fill",
        fillColor = { white = 0, alpha = 0.85 },
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

    -- Create the text content in KSheet style
    local textContent = ""
    local lineCount = 0

    -- Helper function to add a line with proper spacing
    local function addLine(line)
        textContent = textContent .. line .. "\n"
        lineCount = lineCount + 1
    end

    -- Add categories in KSheet style
    for category, content in pairs(categorizedHotkeys) do
        -- Add empty line before category (except first)
        if lineCount > 0 then
            addLine("")
        end

        -- Add category header
        addLine(category .. ":")

        if type(content) == "table" then
            -- Handle subcategories
            for subcategory, hotkeys in pairs(content) do
                if type(hotkeys) == "table" and #hotkeys > 0 then
                    addLine("  " .. subcategory)
                    for _, hotkey in ipairs(hotkeys) do
                        addLine("    " .. hotkey)
                    end
                end
            end

            -- Handle direct hotkeys in category
            for _, hotkey in ipairs(content) do
                if type(hotkey) == "string" then
                    addLine("  " .. hotkey)
                end
            end
        end
    end

    -- Add the text element (KSheet style)
    shortcuts.window:appendElements({
        type = "text",
        text = textContent,
        textColor = { white = 1.0 },
        textFont = "Menlo",  -- Use monospace font like KSheet
        textSize = config.fontSize,
        frame = { x = config.padding, y = config.padding, w = config.windowWidth - 2 * config.padding, h = config.windowHeight - 2 * config.padding }
    })

    -- Add ESC to close hint
    local escHint = "Press ESC to exit"
    shortcuts.window:appendElements({
        type = "text",
        text = escHint,
        textColor = { white = 0.5 },  -- Dimmed text like KSheet
        textSize = 12,
        frame = {
            x = config.windowWidth - 120,
            y = config.windowHeight - 30,
            w = 110,
            h = 20
        }
    })
end

-- Function to show shortcuts
function shortcuts.show()
    if not shortcuts.window then
        createShortcutsWindow()
    end
    shortcuts.window:show()

    -- Add ESC key binding
    if not shortcuts.escapeWatcher then
        shortcuts.escapeWatcher = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
            local keycode = event:getKeyCode()
            if keycode == hs.keycodes.map.escape then
                shortcuts.hide()
                return true
            end
            return false
        end)
    end
    shortcuts.escapeWatcher:start()
end

-- Function to hide shortcuts
function shortcuts.hide()
    if shortcuts.window then
        shortcuts.window:hide()
    end
    if shortcuts.escapeWatcher then
        shortcuts.escapeWatcher:stop()
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
