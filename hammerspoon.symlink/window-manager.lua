function WindowManager ()
  local resizeWindow = function (callback)
    return function()
      local window = hs.window.focusedWindow()
      local windowF = window:frame()
      local screenF = window:screen():frame()

      windowF.x, windowF.y, windowF.w, windowF.h = callback(windowF, screenF, window)

      window:setFrame(windowF)
    end
  end

  local resizeLeft = resizeWindow(function (windowF, screenF)
    if windowF.x == screenF.x and windowF.y == screenF.y and windowF.h == screenF.h then
      if windowF.w == screenF.w // 2 then -- 1/2
        return screenF.x, screenF.y, (screenF.w // 3) * 2, screenF.h --- 2/3
      elseif windowF.w == ((screenF.w // 3) * 2) then -- 2/3
        return screenF.x, screenF.y, screenF.w // 3, screenF.h -- 1/3
      end
    end
    return screenF.x, screenF.y, screenF.w // 2, screenF.h --- 1/2
  end)

  local resizeRight = resizeWindow(function (windowF, screenF)
    if windowF.y == screenF.y and windowF.h == screenF.h then
      if windowF.x == screenF.w // 2 and windowF.w == screenF.w // 2 then -- 1/2
        return (screenF.w // 3) + screenF.x, screenF.y, (screenF.w // 3) * 2, screenF.h --- 2/3
      elseif windowF.x == screenF.w // 3 and windowF.w == ((screenF.w // 3) * 2) then --- 2/3
        return (screenF.w // 3) * 2 + screenF.x, screenF.y, screenF.w // 3, screenF.h --- 1/3
      end
    end
    return (screenF.w // 2) + screenF.x, screenF.y, screenF.w // 2, screenF.h --- 1/2
  end)

  local resizeUp = resizeWindow(function (windowF, screenF)
    if windowF.x == screenF.x and windowF.y == screenF.y and windowF.w == screenF.w then
      if windowF.h == screenF.h // 2 then -- 1/2
        return screenF.x, screenF.y, screenF.w, (screenF.h // 3) * 2 --- 2/3
      elseif windowF.h == ((screenF.h // 3) * 2) then -- 2/3
        return screenF.x, screenF.y, screenF.w, screenF.h // 3 --- 1/3
      end
    end
    return screenF.x, screenF.y, screenF.w, screenF.h // 2 --- 1/2
  end)

  local resizeDown = resizeWindow(function (windowF, screenF)
    if windowF.x == screenF.x and windowF.w == screenF.w then
      if windowF.y == screenF.h // 2 and windowF.h == screenF.h // 2 then -- 1/2
        return screenF.x, screenF.h // 3, screenF.w, (screenF.h // 3) * 2 --- 1/3
      elseif windowF.y == screenF.h // 3 and windowF.h == ((screenF.h // 3) * 2) then -- 2/3
        return screenF.x, (screenF.h // 3) * 2, screenF.w, screenF.h // 3 --- 1/3
      end
    end
    return screenF.x, screenF.h // 2, screenF.w, screenF.h // 2 --- 1/2
  end)

  local fullScreen = resizeWindow(function (windowF, screenF, window)
    if windowF.x == screenF.x and windowF.y == screenF.y and windowF.w == screenF.w and windowF.h == screenF.h then
      return window:setFullScreen(not window:isFullScreen())
    end
    return screenF.x, screenF.y, screenF.w, screenF.h
  end)


  return {
    resizeLeft = resizeLeft,
    resizeRight = resizeRight,
    resizeUp = resizeUp,
    resizeDown = resizeDown,
    fullScreen = fullScreen
  }
end

return WindowManager
