function Timer ()
  local attrs = {
    format = "!%H:%M",
    textSize = 52,
    textAlignment = "right",
    width = 160,
    height = 62,
    marginLeft = 20
  }

  local cleanUp

  local updateCanvas = function(canvas, startedAt)
    return function()
      canvas[1].text = os.date(attrs.format, os.difftime(os.time(), startedAt))
    end
  end

  local destroy = function (canvas, timer)
    return function()
      canvas:hide()
      timer:stop()
      return nil
    end
  end

  local toggle = function ()
    if cleanUp then
      cleanUp = cleanUp()
    else
      local screenF = hs.screen.primaryScreen():fullFrame()
      canvas = hs.canvas.new({x = 0, y = 0, w = 0, h = 0})
      canvas[1] = {
        type = "text",
        text = os.date(attrs.format, 0),
        textSize = attrs.textSize,
        textAlignment = attrs.textAlignment,
        withShadow = true
      }
      canvas:frame({
        x = screenF.w - attrs.width - attrs.marginLeft,
        y = screenF.h - attrs.height,
        w = attrs.width,
        h = attrs.height,
      })
      canvas:show()

      timer = hs.timer.doEvery(60, updateCanvas(canvas, os.time()))
      cleanUp = destroy(canvas, timer)
    end
  end

  return {
    toggle = toggle
  }
end

return Timer
