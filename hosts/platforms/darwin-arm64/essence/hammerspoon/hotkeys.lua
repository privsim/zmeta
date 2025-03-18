-- Hotkeys enhancement module
local hotkeys = {}

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

-- Function to enhance KSheet with custom hotkeys
function hotkeys.enhanceKSheet()
    -- Store the original KSheet show function
    local originalShow = spoon.KSheet.show

    -- Override the show function
    spoon.KSheet.show = function(self)
        -- Call the original show function
        originalShow(self)

        -- Get all registered hotkeys
        local allHotkeys = hs.hotkey.getHotkeys()

        -- Create a new canvas for our custom hotkeys
        if self._canvas then
            local customHotkeysText = "Hammerspoon Hotkeys:\n\n"

            -- Group hotkeys by their general purpose
            local groups = {
                ["Window Management"] = {},
                ["Screen Movement"] = {},
                ["Window Resizing"] = {},
                ["Grid Management"] = {},
                ["Canvas"] = {},
                ["System"] = {},
                ["Other"] = {}
            }

            -- Sort hotkeys into groups
            for _, v in ipairs(allHotkeys) do
                local msg = v.msg or ""
                local mods = formatModifiers(v.mods)
                local key = v.key and v.key:upper() or ""
                local description = msg ~= "" and msg or "No description"

                local hotkeyText = string.format("%s%s - %s", mods, key, description)

                -- Categorize based on key words in the description
                if msg:lower():find("screen") or msg:lower():find("move.*screen") then
                    table.insert(groups["Screen Movement"], hotkeyText)
                elseif msg:lower():find("resize") or msg:lower():find("grid.*resize") then
                    table.insert(groups["Window Resizing"], hotkeyText)
                elseif msg:lower():find("grid") and not msg:lower():find("resize") then
                    table.insert(groups["Grid Management"], hotkeyText)
                elseif msg:lower():find("window") and not msg:lower():find("resize") then
                    table.insert(groups["Window Management"], hotkeyText)
                elseif msg:lower():find("canvas") or msg:lower():find("draw") then
                    table.insert(groups["Canvas"], hotkeyText)
                elseif msg:lower():find("reload") or msg:lower():find("lock") then
                    table.insert(groups["System"], hotkeyText)
                else
                    table.insert(groups["Other"], hotkeyText)
                end
            end

            -- Add groups to the display text
            for groupName, hotkeys in pairs(groups) do
                if #hotkeys > 0 then
                    customHotkeysText = customHotkeysText .. "\n" .. groupName .. ":\n"
                    for _, hotkey in ipairs(hotkeys) do
                        customHotkeysText = customHotkeysText .. "  " .. hotkey .. "\n"
                    end
                end
            end

            -- Add custom hotkeys text to the canvas
            local frame = self._canvas:frame()
            local textFrame = {
                x = frame.x + 10,
                y = frame.y + frame.h + 10,
                w = frame.w - 20,
                h = 400  -- Adjust this value based on content
            }

            -- Create a new canvas for custom hotkeys
            if self._customCanvas then
                self._customCanvas:delete()
            end

            self._customCanvas = hs.canvas.new(textFrame)
            self._customCanvas:level(self._canvas:level())
            self._customCanvas:appendElements({
                type = "rectangle",
                action = "fill",
                fillColor = { white = 0, alpha = 0.95 },
                frame = { x = 0, y = 0, w = "100%", h = "100%" }
            }, {
                type = "text",
                text = customHotkeysText,
                textColor = { white = 1.0 },
                textSize = 14,
                frame = { x = 10, y = 10, w = textFrame.w - 20, h = textFrame.h - 20 }
            })
            self._customCanvas:show()
        end
    end

    -- Override the hide function to also hide our custom canvas
    local originalHide = spoon.KSheet.hide
    spoon.KSheet.hide = function(self)
        originalHide(self)
        if self._customCanvas then
            self._customCanvas:hide()
        end
    end
end

return hotkeys
