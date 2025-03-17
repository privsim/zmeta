-- Desktop Canvas Module
local canvas = {}

-- Configuration
local config = {
    canvasDir = os.getenv("HOME") .. "/.desktop_canvas",
    currentCanvas = nil,
    isDrawing = false,
    drawColor = {red = 0, green = 0, blue = 0, alpha = 0.8},
    fontSize = 14,
    strokeWidth = 2
}

-- Ensure directory exists
os.execute("mkdir -p " .. config.canvasDir)

-- Create a new drawing canvas
local function createCanvas()
    if config.currentCanvas then
        config.currentCanvas:delete()
    end

    local screen = hs.screen.mainScreen()
    local frame = screen:frame()

    config.currentCanvas = hs.canvas.new(frame)
    config.currentCanvas:behavior(hs.canvas.windowBehaviors.canJoinAllSpaces)
    config.currentCanvas:level(hs.canvas.windowLevels.desktopIcon)

    -- Make canvas click-through when not in drawing mode
    config.currentCanvas:mouseCallback(function(canvas, message, point, count)
        if config.isDrawing then
            if message == "mouseDown" then
                canvas.lastPoint = point
                canvas:appendElements({
                    type = "segments",
                    coordinates = {},
                    strokeColor = config.drawColor,
                    strokeWidth = config.strokeWidth,
                    antialias = true
                })
            elseif message == "mouseDragged" and canvas.lastPoint then
                local elements = canvas:elementCount()
                local current = canvas:element(elements)
                current.coordinates = current.coordinates or {}
                table.insert(current.coordinates, canvas.lastPoint)
                table.insert(current.coordinates, point)
                canvas.lastPoint = point
                canvas:element(elements, current)
            end
        end
        return false
    end)

    return config.currentCanvas
end

-- Toggle drawing mode
function canvas.toggleDrawing()
    config.isDrawing = not config.isDrawing
    if config.isDrawing then
        if not config.currentCanvas then
            createCanvas():show()
        end
        config.currentCanvas:wantsLayer(true)
        hs.alert.show("Drawing Mode: ON")
    else
        if config.currentCanvas then
            config.currentCanvas:wantsLayer(false)
        end
        hs.alert.show("Drawing Mode: OFF")
    end
end

-- Add text note at cursor position
function canvas.addTextNote()
    if not config.currentCanvas then
        createCanvas():show()
    end

    -- Get current mouse position
    local point = hs.mouse.absolutePosition()

    -- Create text input
    local textInput = hs.dialog.textPrompt(
        "Add Note",
        "Enter your note text:",
        "",
        "OK",
        "Cancel"
    )

    if textInput and textInput[1] then
        config.currentCanvas:appendElements({
            type = "text",
            text = textInput[1],
            frame = { x = point.x, y = point.y, w = 400, h = 100 },
            textColor = config.drawColor,
            textSize = config.fontSize
        })
    end
end

-- Clear canvas
function canvas.clear()
    if config.currentCanvas then
        config.currentCanvas:delete()
        config.currentCanvas = nil
        createCanvas():show()
        hs.alert.show("Canvas Cleared")
    end
end

-- Save canvas
function canvas.save()
    if config.currentCanvas then
        local timestamp = os.date("%Y%m%d_%H%M%S")
        local filename = string.format("desktop_canvas_%s.png", timestamp)
        local path = config.canvasDir .. "/" .. filename

        -- Take screenshot of the canvas area
        local screen = hs.screen.mainScreen()
        local frame = screen:frame()
        local screenshot = hs.screen.mainScreen():snapshot()
        screenshot:saveToFile(path)

        hs.alert.show("Canvas saved to " .. path)
    end
end

-- Change drawing color
function canvas.setColor(colorName)
    local colors = {
        black = {red = 0, green = 0, blue = 0, alpha = 0.8},
        red = {red = 1, green = 0, blue = 0, alpha = 0.8},
        blue = {red = 0, green = 0, blue = 1, alpha = 0.8},
        green = {red = 0, green = 0.8, blue = 0, alpha = 0.8}
    }

    if colors[colorName] then
        config.drawColor = colors[colorName]
        hs.alert.show("Color set to " .. colorName)
    end
end

-- Set up keyboard shortcuts
local function setupHotkeys()
    local mash = {"cmd", "alt", "ctrl"}

    -- Toggle drawing mode
    hs.hotkey.bind(mash, "d", canvas.toggleDrawing)

    -- Add text note
    hs.hotkey.bind(mash, "t", canvas.addTextNote)

    -- Clear canvas
    hs.hotkey.bind(mash, "c", canvas.clear)

    -- Save canvas
    hs.hotkey.bind(mash, "s", canvas.save)

    -- Color shortcuts
    hs.hotkey.bind(mash, "1", function() canvas.setColor("black") end)
    hs.hotkey.bind(mash, "2", function() canvas.setColor("red") end)
    hs.hotkey.bind(mash, "3", function() canvas.setColor("blue") end)
    hs.hotkey.bind(mash, "4", function() canvas.setColor("green") end)
end

-- Initialize
function canvas.init()
    setupHotkeys()
    -- Create a menu bar item
    local menubar = hs.menubar.new()
    if menubar then
        menubar:setTitle("✏️")
        menubar:setMenu({
            { title = "Toggle Drawing Mode", fn = canvas.toggleDrawing },
            { title = "Add Text Note", fn = canvas.addTextNote },
            { title = "-" },
            { title = "Colors", menu = {
                { title = "Black", fn = function() canvas.setColor("black") end },
                { title = "Red", fn = function() canvas.setColor("red") end },
                { title = "Blue", fn = function() canvas.setColor("blue") end },
                { title = "Green", fn = function() canvas.setColor("green") end }
            }},
            { title = "-" },
            { title = "Clear Canvas", fn = canvas.clear },
            { title = "Save Canvas", fn = canvas.save }
        })
    end

    -- Create initial canvas
    createCanvas():show()
end

return canvas
