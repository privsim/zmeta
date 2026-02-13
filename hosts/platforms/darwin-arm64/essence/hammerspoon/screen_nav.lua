local screenNav = {}

local function getScreenCenter(screen)
    local f = screen:frame()
    return { x = f.x + f.w / 2, y = f.y + f.h / 2 }
end

local function rangesOverlap(a1, a2, b1, b2, tolerance)
    tolerance = tolerance or 50
    return a1 < (b2 + tolerance) and a2 > (b1 - tolerance)
end

local function findScreenInDirection(currentScreen, direction)
    local screens = hs.screen.allScreens()
    local cur = currentScreen:frame()
    local candidates = {}

    for _, s in ipairs(screens) do
        if s:id() ~= currentScreen:id() then
            local f = s:frame()
            local dominated = false

            if direction == "left" then
                if f.x + f.w <= cur.x + 10 then
                    if rangesOverlap(cur.y, cur.y + cur.h, f.y, f.y + f.h) then
                        table.insert(candidates, { screen = s, distance = cur.x - (f.x + f.w) })
                    end
                end
            elseif direction == "right" then
                if f.x >= cur.x + cur.w - 10 then
                    if rangesOverlap(cur.y, cur.y + cur.h, f.y, f.y + f.h) then
                        table.insert(candidates, { screen = s, distance = f.x - (cur.x + cur.w) })
                    end
                end
            elseif direction == "up" then
                if f.y + f.h <= cur.y + 10 then
                    if rangesOverlap(cur.x, cur.x + cur.w, f.x, f.x + f.w) then
                        table.insert(candidates, { screen = s, distance = cur.y - (f.y + f.h) })
                    end
                end
            elseif direction == "down" then
                if f.y >= cur.y + cur.h - 10 then
                    if rangesOverlap(cur.x, cur.x + cur.w, f.x, f.x + f.w) then
                        table.insert(candidates, { screen = s, distance = f.y - (cur.y + cur.h) })
                    end
                end
            end
        end
    end

    if #candidates == 0 then
        return nil
    end

    table.sort(candidates, function(a, b) return a.distance < b.distance end)
    return candidates[1].screen
end

local function getSortedScreens()
    local screens = hs.screen.allScreens()
    table.sort(screens, function(a, b)
        local fa, fb = a:frame(), b:frame()
        if math.abs(fa.y - fb.y) > 100 then
            return fa.y < fb.y
        end
        return fa.x < fb.x
    end)
    return screens
end

local function findScreenIndex(screens, target)
    for i, s in ipairs(screens) do
        if s:id() == target:id() then
            return i
        end
    end
    return 1
end

function screenNav.moveWindow(direction)
    local win = hs.window.focusedWindow()
    if not win then
        hs.alert.show("No focused window")
        return
    end

    local currentScreen = win:screen()
    local targetScreen = nil

    if direction == "next" then
        local screens = getSortedScreens()
        local idx = findScreenIndex(screens, currentScreen)
        targetScreen = screens[(idx % #screens) + 1]
    elseif direction == "prev" then
        local screens = getSortedScreens()
        local idx = findScreenIndex(screens, currentScreen)
        targetScreen = screens[((idx - 2) % #screens) + 1]
    else
        targetScreen = findScreenInDirection(currentScreen, direction)
    end

    if targetScreen then
        win:moveToScreen(targetScreen, true, true)
        win:focus()
    else
        hs.alert.show("No screen " .. direction)
    end
end

function screenNav.bindKeys(mash)
    mash = mash or {"ctrl", "alt"}
    hs.hotkey.bind(mash, "left", function() screenNav.moveWindow("left") end)
    hs.hotkey.bind(mash, "right", function() screenNav.moveWindow("right") end)
    hs.hotkey.bind(mash, "up", function() screenNav.moveWindow("up") end)
    hs.hotkey.bind(mash, "down", function() screenNav.moveWindow("down") end)
    hs.hotkey.bind(mash, "n", function() screenNav.moveWindow("next") end)
    hs.hotkey.bind(mash, "p", function() screenNav.moveWindow("prev") end)
end

function screenNav.debug()
    local screens = getSortedScreens()
    print("=== Screen Nav Debug ===")
    print("Sorted order (top-to-bottom, left-to-right):")
    for i, s in ipairs(screens) do
        local f = s:frame()
        print(string.format("  %d. %s @ (%d,%d)", i, s:name(), f.x, f.y))
    end
    print("")
    for _, s in ipairs(screens) do
        local f = s:frame()
        print(string.format("%s:", s:name()))
        local dirs = {"left", "right", "up", "down"}
        for _, d in ipairs(dirs) do
            local target = findScreenInDirection(s, d)
            print(string.format("  %s: %s", d, target and target:name() or "nil"))
        end
    end
end

return screenNav
