function TextExpander (dictionaryLocation)
  local expand = function ()
    local copyAction, retAction
    local choices = loadfile("text-expander-dictionary.lua")()
    local privDictionary = loadfile(dictionaryLocation)

    if privDictionary then
      local dictionary = privDictionary()
      choices = hs.fnutils.concat(dictionary, choices)
    end

    local chooser = hs.chooser.new(function(choosen)
      if copyAction then copyAction:delete() end
      if retAction then retAction:delete() end

      if not choosen then return end

      local current = hs.application.frontmostApplication()
      hs.eventtap.keyStrokes(choosen.text, current)
    end)

    copyAction = hs.hotkey.bind('cmd', 'c', function()
        local id = chooser:selectedRow()
        local item = choices[id]
        if item then
            chooser:hide()
            hs.pasteboard.setContents(item.text)
        else
            hs.alert.show("No search result to copy", 1)
        end
    end)

    retAction = hs.hotkey.bind('', 'return', function()
        local id = chooser:selectedRow()
        local item = choices[id]
        if item then
            chooser:select(id)
        else
            chooser:hide()
        end
    end)


    chooser:choices(choices)
    chooser:searchSubText(true)
    chooser:placeholderText("Text explander")
    chooser:show()
  end

  return {
    expand = expand
  }
end

return TextExpander

