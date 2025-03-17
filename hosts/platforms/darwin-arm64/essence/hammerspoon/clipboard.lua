local clipboard_history = hs.settings.get("clipboard_history") or {}
local max_clipboard_size = 100

local function add_to_clipboard(item)
  for i, v in ipairs(clipboard_history) do
    if v == item then
      table.remove(clipboard_history, i)
    end
  end
  table.insert(clipboard_history, 1, item)
  if #clipboard_history > max_clipboard_size then
    table.remove(clipboard_history)
  end
  hs.settings.set("clipboard_history", clipboard_history)
end

local function paste_clipboard_item(index)
  hs.pasteboard.setContents(clipboard_history[index])
  hs.eventtap.keyStrokes(clipboard_history[index])
end

hs.hotkey.bind(windowMash, "v", function()
  local chooser = hs.chooser.new(function(choice)
    if choice then
      paste_clipboard_item(choice.index)
    end
  end)

  local choices = {}
  for i, v in ipairs(clipboard_history) do
    table.insert(choices, {["text"] = v, ["index"] = i})
  end
  chooser:choices(choices)
  chooser:show()
end)

hs.pasteboard.watcher.new(function(content)
  if content ~= clipboard_history[1] then
    add_to_clipboard(content)
  end
end):start()
