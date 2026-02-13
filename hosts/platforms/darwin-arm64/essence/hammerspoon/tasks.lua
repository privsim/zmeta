local tasks = {}

local config = {
    tasksFile = "/Users/lclose/ACTIVE.md",
    windowWidth = 900,
    windowHeight = 700,
    fontSize = 13,
    padding = 20,
    sectionColors = {
        ["🔥"] = { red = 1.0, green = 0.4, blue = 0.2, alpha = 1.0 },
        ["🍳"] = { red = 1.0, green = 0.8, blue = 0.2, alpha = 1.0 },
        ["📱"] = { red = 0.4, green = 0.7, blue = 1.0, alpha = 1.0 },
        ["🔧"] = { red = 0.6, green = 0.6, blue = 0.6, alpha = 1.0 },
        ["📝"] = { red = 0.7, green = 0.5, blue = 1.0, alpha = 1.0 },
        ["⏸️"] = { red = 0.5, green = 0.5, blue = 0.5, alpha = 1.0 },
    }
}

local function parseTasksFile()
    local f = io.open(config.tasksFile, "r")
    if not f then return nil end
    local content = f:read("*all")
    f:close()
    local sections = {}
    local currentSection = nil
    local currentProject = nil
    for line in content:gmatch("[^\r\n]*") do
        local sectionHeader = line:match("^## ([🔥🍳📱🔧📝⏸️].+)")
        if sectionHeader then
            currentSection = { title = sectionHeader, projects = {} }
            table.insert(sections, currentSection)
            currentProject = nil
        elseif currentSection then
            local projectName = line:match("^### (.+)")
            if projectName then
                currentProject = { name = projectName, details = {} }
                table.insert(currentSection.projects, currentProject)
            elseif currentProject then
                local detail = line:match("^%*%*(.+)%*%*")
                if detail then
                    table.insert(currentProject.details, detail)
                end
            end
        end
    end
    return sections
end

local function getEmojiColor(title)
    for emoji, color in pairs(config.sectionColors) do
        if title:find(emoji, 1, true) then
            return color
        end
    end
    return { white = 1.0 }
end

local function createTasksWindow()
    if tasks.window then
        tasks.window:delete()
    end
    local screen = hs.screen.mainScreen()
    local frame = screen:frame()
    local windowFrame = {
        x = frame.x + (frame.w - config.windowWidth) / 2,
        y = frame.y + (frame.h - config.windowHeight) / 2,
        w = config.windowWidth,
        h = config.windowHeight
    }
    tasks.window = hs.canvas.new(windowFrame)
    tasks.window:level(hs.canvas.windowLevels.modalPanel)
    tasks.window:behavior(hs.canvas.windowBehaviors.canJoinAllSpaces)
    tasks.window:appendElements({
        type = "rectangle",
        action = "fill",
        fillColor = { white = 0.05, alpha = 0.95 },
        roundedRectRadii = { xRadius = 12, yRadius = 12 },
        frame = { x = 0, y = 0, w = "100%", h = "100%" }
    })
    local sections = parseTasksFile()
    if not sections then
        tasks.window:appendElements({
            type = "text",
            text = "Could not read " .. config.tasksFile,
            textColor = { red = 1, green = 0.3, blue = 0.3 },
            textFont = "SF Pro Display",
            textSize = 16,
            frame = { x = config.padding, y = config.padding, w = config.windowWidth - 2 * config.padding, h = 30 }
        })
        return
    end
    local yPos = config.padding
    tasks.window:appendElements({
        type = "text",
        text = "ACTIVE TASKS",
        textColor = { white = 0.4 },
        textFont = "SF Pro Display",
        textSize = 11,
        frame = { x = config.padding, y = yPos, w = config.windowWidth - 2 * config.padding, h = 20 }
    })
    yPos = yPos + 25

    for _, section in ipairs(sections) do
        local sectionColor = getEmojiColor(section.title)
        tasks.window:appendElements({
            type = "text",
            text = section.title,
            textColor = sectionColor,
            textFont = "SF Pro Display Bold",
            textSize = 15,
            frame = { x = config.padding, y = yPos, w = config.windowWidth - 2 * config.padding, h = 24 }
        })
        yPos = yPos + 28
        for _, project in ipairs(section.projects) do
            tasks.window:appendElements({
                type = "text",
                text = "  " .. project.name,
                textColor = { white = 0.95 },
                textFont = "SF Pro Display Medium",
                textSize = config.fontSize,
                frame = { x = config.padding, y = yPos, w = config.windowWidth - 2 * config.padding, h = 20 }
            })
            yPos = yPos + 18
            for _, detail in ipairs(project.details) do
                if detail:match("^Status:") or detail:match("^Next:") or detail:match("^Location:") then
                    local label, value = detail:match("^([^:]+): (.+)")
                    if label and value then
                        local displayText = "    " .. label .. ": " .. value
                        local detailColor = { white = 0.5 }
                        if label == "Next" then
                            detailColor = { red = 0.4, green = 0.8, blue = 0.4, alpha = 1.0 }
                        elseif label == "Status" then
                            detailColor = { red = 0.5, green = 0.7, blue = 1.0, alpha = 1.0 }
                        end

                        tasks.window:appendElements({
                            type = "text",
                            text = displayText,
                            textColor = detailColor,
                            textFont = "SF Pro Display",
                            textSize = 11,
                            frame = { x = config.padding, y = yPos, w = config.windowWidth - 2 * config.padding, h = 16 }
                        })
                        yPos = yPos + 14
                    end
                end
            end
            yPos = yPos + 4
        end
        yPos = yPos + 8
    end
    tasks.window:appendElements({
        type = "text",
        text = "ESC to close  •  " .. os.date("%Y-%m-%d %H:%M"),
        textColor = { white = 0.3 },
        textSize = 10,
        frame = { x = config.padding, y = config.windowHeight - 30, w = config.windowWidth - 2 * config.padding, h = 20 }
    })
end

function tasks.show()
    createTasksWindow()
    tasks.window:show()
    if not tasks.escapeWatcher then
        tasks.escapeWatcher = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
            if event:getKeyCode() == hs.keycodes.map.escape then
                tasks.hide()
                return true
            end
            return false
        end)
    end
    tasks.escapeWatcher:start()
end


function tasks.hide()
    if tasks.window then
        tasks.window:hide()
    end
    if tasks.escapeWatcher then
        tasks.escapeWatcher:stop()
    end
end

function tasks.toggle()
    if tasks.window and tasks.window:isShowing() then
        tasks.hide()
    else
        tasks.show()
    end
end

return tasks
