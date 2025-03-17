local function toggleApplication(name)
  local app = hs.application.find(name)
  if not app or app:isHidden() then
    hs.application.launchOrFocus(name)
  elseif hs.application.frontmostApplication() ~= app then
    app:activate()
  else
    app:hide()
  end
end

-- Application hotkeys
hs.hotkey.bind(launchMash, "c", function() toggleApplication("Chromium") end)
hs.hotkey.bind(launchMash, "e", function() toggleApplication("Visual Studio Code") end)
hs.hotkey.bind(launchMash, "f", function() toggleApplication("Finder") end)
hs.hotkey.bind(launchMash, "g", function() toggleApplication("SourceTree") end)
hs.hotkey.bind(launchMash, "p", function() toggleApplication("System Preferences") end)
hs.hotkey.bind(launchMash, "s", function() toggleApplication("Spotify") end)
hs.hotkey.bind(launchMash, "t", function() toggleApplication("iTerm") end)
hs.hotkey.bind(launchMash, "k", function() toggleApplication("Cursor") end)
