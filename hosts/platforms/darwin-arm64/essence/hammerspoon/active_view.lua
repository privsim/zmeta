local active_view = {}

local config = {
    activeFile = "/Users/lclose/ACTIVE.md",
    windowWidthRatio = 0.55,
    windowHeightRatio = 0.80,
    debounceInterval = 0.2,
    sectionColors = {
        ["\xF0\x9F\x94\xA5"] = { class = "hot",       hex = "#ff6633" },  -- fire
        ["\xF0\x9F\x8D\xB3"] = { class = "cooking",    hex = "#ffcc33" },  -- cooking
        ["\xF0\x9F\x93\xB1"] = { class = "ios",        hex = "#66b3ff" },  -- mobile
        ["\xF0\x9F\x94\xA7"] = { class = "hw",         hex = "#999999" },  -- wrench
        ["\xF0\x9F\x93\x9D"] = { class = "content",    hex = "#b380ff" },  -- memo
        ["\xE2\x8F\xB8"]     = { class = "paused",     hex = "#808080" },  -- pause
        ["\xF0\x9F\x8E\xAF"] = { class = "strategic",  hex = "#33cc99" },  -- target
    }
}

active_view.webView = nil
active_view.watcher = nil
active_view.debounceTimer = nil

local function generateCSS()
    local sectionCSS = ""
    for _, info in pairs(config.sectionColors) do
        sectionCSS = sectionCSS .. string.format([[
        h2.section-%s {
            color: %s;
            border-left: 3px solid %s;
            padding-left: 12px;
        }
        ]], info.class, info.hex, info.hex)
    end

    return [[
        * { margin: 0; padding: 0; box-sizing: border-box; }
        html, body {
            background-color: #0d0d0d;
            color: #e0e0e0;
            font-family: -apple-system, BlinkMacSystemFont, "SF Pro Text", "Helvetica Neue", sans-serif;
            font-size: 14px;
            line-height: 1.6;
            padding: 24px 32px 60px 32px;
            overflow-y: auto;
        }
        h1 {
            color: #ffffff;
            font-size: 22px;
            font-weight: 700;
            margin-bottom: 4px;
            letter-spacing: 0.5px;
        }
        h2 {
            font-size: 17px;
            font-weight: 600;
            margin-top: 28px;
            margin-bottom: 12px;
            padding-bottom: 6px;
            border-bottom: 1px solid #222;
        }
        h3 {
            color: #ffffff;
            font-size: 14px;
            font-weight: 600;
            margin-top: 16px;
            margin-bottom: 6px;
        }
        p {
            margin-bottom: 8px;
        }
        em {
            color: #888;
            font-style: italic;
        }
        strong {
            color: #ffffff;
            font-weight: 600;
        }
        a {
            color: #66b3ff;
            text-decoration: none;
        }
        a:hover {
            text-decoration: underline;
        }
        hr {
            border: none;
            border-top: 1px solid #333;
            margin: 20px 0;
        }
        ul, ol {
            padding-left: 24px;
            margin-bottom: 8px;
        }
        li {
            margin-bottom: 4px;
        }
        code {
            background-color: #1a1a1a;
            color: #00cc66;
            font-family: "SF Mono", "Menlo", "Monaco", monospace;
            font-size: 12px;
            padding: 2px 6px;
            border-radius: 3px;
        }
        pre {
            background-color: #1a1a1a;
            border: 1px solid #2a2a2a;
            border-radius: 6px;
            padding: 12px 16px;
            margin: 8px 0 12px 0;
            overflow-x: auto;
        }
        pre code {
            background: none;
            padding: 0;
            font-size: 12px;
            line-height: 1.5;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 12px 0;
            font-size: 13px;
        }
        th {
            background-color: #1a1a1a;
            color: #ffffff;
            font-weight: 600;
            text-align: left;
            padding: 8px 12px;
            border: 1px solid #333;
        }
        td {
            padding: 6px 12px;
            border: 1px solid #2a2a2a;
        }
        tr:nth-child(even) {
            background-color: #111111;
        }
        tr:nth-child(odd) {
            background-color: #0d0d0d;
        }
        blockquote {
            border-left: 3px solid #444;
            padding-left: 12px;
            color: #999;
            margin: 8px 0;
        }

        ::-webkit-scrollbar {
            width: 8px;
        }
        ::-webkit-scrollbar-track {
            background: #111;
        }
        ::-webkit-scrollbar-thumb {
            background: #333;
            border-radius: 4px;
        }
        ::-webkit-scrollbar-thumb:hover {
            background: #444;
        }

        .footer {
            position: fixed;
            bottom: 0;
            left: 0;
            right: 0;
            background: linear-gradient(transparent, #0d0d0d 30%);
            padding: 16px 32px 10px 32px;
            text-align: center;
            color: #444;
            font-size: 11px;
        }
    ]] .. sectionCSS
end

local function postProcessHTML(html)
    local result = {}
    for line in html:gmatch("[^\n]*\n?") do
        local modified = line
        if line:match("<h2") then
            for emoji, info in pairs(config.sectionColors) do
                if line:find(emoji, 1, true) then
                    modified = line:gsub("<h2", '<h2 class="section-' .. info.class .. '"', 1)
                    break
                end
            end
        end
        table.insert(result, modified)
    end
    return table.concat(result)
end

local function readAndConvert()
    local f = io.open(config.activeFile, "r")
    if not f then
        return "<html><body style='background:#0d0d0d;color:#ff4444;padding:40px;font-family:sans-serif;'>" ..
               "<h2>Could not read " .. config.activeFile .. "</h2></body></html>"
    end
    local content = f:read("*all")
    f:close()

    local bodyHTML = hs.doc.markdown.convert(content, "gfm")
    bodyHTML = postProcessHTML(bodyHTML)
    return bodyHTML
end

local function generateHTML(body)
    return string.format([[<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<style type="text/css">
%s
</style>
</head>
<body>
%s
<div class="footer">ESC to close &middot; %s</div>
</body>
</html>]], generateCSS(), body, os.date("%Y-%m-%d %H:%M"))
end

local function createWebView()
    if active_view.webView then return end

    local screen = hs.screen.mainScreen()
    local frame = screen:frame()
    local w = frame.w * config.windowWidthRatio
    local h = frame.h * config.windowHeightRatio
    local x = frame.x + (frame.w - w) / 2
    local y = frame.y + (frame.h - h) / 2

    active_view.webView = hs.webview.new({ x = x, y = y, w = w, h = h })
    active_view.webView:windowTitle("ACTIVE.md")
    active_view.webView:windowStyle({"utility", "titled", "closable"})
    active_view.webView:allowGestures(true)
    active_view.webView:allowNewWindows(false)
    active_view.webView:closeOnEscape(true)
    active_view.webView:deleteOnClose(false)
    active_view.webView:level(hs.drawing.windowLevels.tornOffMenu)
    active_view.webView:behavior(hs.canvas and hs.canvas.windowBehaviors
        and hs.canvas.windowBehaviors.canJoinAllSpaces or 0)
end

local function refresh()
    if not active_view.webView then return end
    local body = readAndConvert()
    local html = generateHTML(body)
    active_view.webView:html(html)
end

local function startWatcher()
    if active_view.watcher then return end
    active_view.watcher = hs.pathwatcher.new(config.activeFile, function()
        if active_view.debounceTimer then
            active_view.debounceTimer:stop()
        end
        active_view.debounceTimer = hs.timer.doAfter(config.debounceInterval, function()
            if active_view.webView and active_view.webView:hswindow() and active_view.webView:hswindow():isVisible() then
                refresh()
            end
        end)
    end):start()
end

local function stopWatcher()
    if active_view.watcher then
        active_view.watcher:stop()
        active_view.watcher = nil
    end
    if active_view.debounceTimer then
        active_view.debounceTimer:stop()
        active_view.debounceTimer = nil
    end
end

function active_view.show()
    createWebView()

    -- Re-center on current main screen each time
    local screen = hs.screen.mainScreen()
    local frame = screen:frame()
    local w = frame.w * config.windowWidthRatio
    local h = frame.h * config.windowHeightRatio
    local x = frame.x + (frame.w - w) / 2
    local y = frame.y + (frame.h - h) / 2
    active_view.webView:frame({ x = x, y = y, w = w, h = h })

    refresh()
    active_view.webView:show()
    startWatcher()
end

function active_view.hide()
    if active_view.webView then
        active_view.webView:hide()
    end
    stopWatcher()
end

function active_view.toggle()
    if active_view.webView and active_view.webView:hswindow() and active_view.webView:hswindow():isVisible() then
        active_view.hide()
    else
        active_view.show()
    end
end

return active_view
