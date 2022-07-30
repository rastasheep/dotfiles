--
-- Sane defaults
--
hs.logger.defaultLogLevel = 5
require("hs.hotkey").setLogLevel("warning")
hs.window.animationDuration = 0

local hyper = {"cmd", "alt", "ctrl", "shift"}

--
-- Window management
--

local wm = dofile("window-manager.lua")()
hs.hotkey.bind(hyper, "h", wm.resizeLeft)
hs.hotkey.bind(hyper, "j", wm.resizeDown)
hs.hotkey.bind(hyper, "k", wm.resizeUp)
hs.hotkey.bind(hyper, "l", wm.resizeRight)
hs.hotkey.bind(hyper, "f", wm.fullScreen)

--
-- Text expansion
--

local dict = os.getenv("HOME")..[[/Library/CloudStorage/GoogleDrive-rastasheep3@gmail.com/My Drive/text-expander-dictionary.lua]]
local te = dofile("text-expander.lua")(dict)
hs.hotkey.bind(hyper, "e", te.expand)

--
-- Timer
--

local timer = dofile("timer.lua")()
hs.hotkey.bind(hyper, "t", timer.toggle)
