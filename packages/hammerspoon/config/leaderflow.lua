local Leaderflow = {}

local activeModal = nil
local modalTimer = nil
local menuPath = ""
local rootConfig = nil

local function log(msg)
    print("[Leaderflow] " .. msg)
end

local function handleWindowAction(windowAction)
    local win = hs.window.focusedWindow()
    if not win then return end

    local screen = win:screen():frame()
    local actions = {
        ["left-half"] = {x = screen.x, y = screen.y, w = screen.w/2, h = screen.h},
        ["right-half"] = {x = screen.x + screen.w/2, y = screen.y, w = screen.w/2, h = screen.h},
        ["top-half"] = {x = screen.x, y = screen.y, w = screen.w, h = screen.h/2},
        ["bottom-half"] = {x = screen.x, y = screen.y + screen.h/2, w = screen.w, h = screen.h/2},
        ["maximize"] = screen,
        ["center"] = function() win:centerOnScreen(); return nil end
    }

    local action = actions[windowAction]
    if type(action) == "function" then
        action()
    elseif action then
        win:setFrame(action)
    end
end

local function executeAction(action)
    log("Executing: " .. tostring(action))

    if type(action) == "string" then
        local actionTypes = {
            {pattern = "^https?://", handler = hs.urlevent.openURL},
            {pattern = "^text:(.+)", handler = function(text)
                hs.pasteboard.setContents(text)
                hs.eventtap.keyStroke({"cmd"}, "v")
            end},
            {pattern = "^cmd:(.+)", handler = function(cmd)
                log("Executing command: " .. cmd)
                hs.execute(cmd)
            end},
            {pattern = "^window:(.+)", handler = handleWindowAction}
        }

        -- Check for special cases first
        if action == "reload" then
            hs.reload()
            return
        end

        -- Check action type patterns
        for _, actionType in ipairs(actionTypes) do
            local match = action:match(actionType.pattern)
            if match then
                actionType.handler(match)
                return
            end
        end

        -- Default: launch application
        hs.application.launchOrFocus(action)
    elseif type(action) == "table" and action[1] then
        executeAction(action[1])
    elseif type(action) == "function" then
        action()
    end
end

local function cleanupModal()
    if activeModal then
        activeModal:stop()
        activeModal = nil
    end
    if modalTimer then
        modalTimer:stop()
        modalTimer = nil
    end
    hs.alert.closeAll()
end

local function stopModal()
    cleanupModal()
    menuPath = ""
    log("Modal stopped")
end

local function isSubmenu(value)
    -- Check if value is a submenu (table without [1] and not a function)
    return type(value) == "table" and not value[1] and type(value.label) ~= "function"
end

local function getDescription(value)
    if isSubmenu(value) then return value.label or "[menu]" end
    if type(value) == "table" and value[1] then return value[2] or value[1] end
    if type(value) ~= "string" then return "action" end

    local prefixes = {
        ["^https?://"] = function(v) return v end,
        ["^text:(.+)"] = function(v) return v:match("^text:(.+)") end,
        ["^window:(.+)"] = function(v) return v:match("^window:(.+)") end,
        ["^cmd:(.+)"] = function(v) return v:match("^cmd:(.+)") end
    }

    for pattern, extractor in pairs(prefixes) do
        if value:match(pattern) then return extractor(value) end
    end

    return value -- Application name
end

local function pathToLabels(menuPath)
    if menuPath == "" then return {} end

    local pathParts = {}
    for part in menuPath:gmatch("[^%s→%s]+") do
        table.insert(pathParts, part)
    end

    local pathLabels = {}
    local currentMappings = nil

    -- Find the root label first
    if rootConfig and rootConfig.leaders then
        for leaderKey, leaderConfig in pairs(rootConfig.leaders) do
            if pathParts[1] == leaderKey then
                table.insert(pathLabels, leaderConfig.label or leaderKey)
                currentMappings = leaderConfig
                break
            end
        end
    end

    -- Navigate through submenu structure to get labels
    for i = 2, #pathParts do
        if currentMappings and currentMappings[pathParts[i]] then
            local value = currentMappings[pathParts[i]]
            if isSubmenu(value) then
                table.insert(pathLabels, value.label or pathParts[i])
                currentMappings = value
            else
                table.insert(pathLabels, pathParts[i])
            end
        else
            table.insert(pathLabels, pathParts[i])
        end
    end

    return pathLabels
end

local function showBreadcrumb()
    local pathLabels = pathToLabels(menuPath)
    local breadcrumb = #pathLabels > 0 and table.concat(pathLabels, " > ") or "..."

    hs.alert.show(breadcrumb, { atScreenEdge = 2 }, math.huge)

    log("Breadcrumb shown: " .. breadcrumb)
end

local function showFullMenu(mappings, title)
    -- Get available keys with their labels/descriptions
    local items = {}
    for key, value in pairs(mappings) do
        if key ~= "label" then
            local desc = getDescription(value)
            table.insert(items, key .. " · " .. string.lower(desc))
        end
    end
    table.sort(items)

    -- Show path using labels if we're in a submenu
    local pathLabels = pathToLabels(menuPath)
    local pathText = #pathLabels > 0 and table.concat(pathLabels, " · ") .. "\n—\n" or ""

    local text = pathText .. table.concat(items, "\n")

    -- Show in center of screen
    hs.alert.show(text, {
        atScreenEdge = 0,
    }, math.huge)

    log("Full menu shown: " .. (title or "Menu") .. " at path: " .. menuPath)
end

local function updatePath(key, isRoot, rootKey)
    if isRoot then
        menuPath = rootKey or ""
    elseif key then
        menuPath = menuPath == "" and key or menuPath .. " → " .. key
    else
        menuPath = ""
    end
end

local function createModal(mappings, title, key, isRoot, rootKey)
    updatePath(key, isRoot, rootKey)
    cleanupModal()

    showBreadcrumb()

    activeModal = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
        local keyCode = event:getKeyCode()
        local key = hs.keycodes.map[keyCode]

        -- Handle special keys first
        if key == "/" or key == "?" then
            -- Show full menu in center
            log("Showing full menu")
            showFullMenu(mappings, title)
            return true
        end

        -- Handle exit conditions
        if keyCode == 53 or not (key and mappings[key]) then
            if keyCode ~= 53 then log("Invalid key: " .. tostring(key)) end
            stopModal()
            return true
        end

        log("Key pressed: " .. key)
        local value = mappings[key]
        if isSubmenu(value) then
            log("Entering submenu: " .. key)
            cleanupModal()
            createModal(value, value.label, key, false)
        else
            -- Execute action
            stopModal()
            executeAction(value)
        end

        return true
    end)

    activeModal:start()
    modalTimer = hs.timer.doAfter(5, stopModal)

    log("Modal active for: " .. (title or "Menu") .. " at path: " .. menuPath)
end

function Leaderflow:init(config)
    log("Initializing Leaderflow")

    if not config or not config.leaders then
        log("No leaders configuration found")
        return
    end

    -- Store root config for breadcrumb navigation
    rootConfig = config

    local mods = config.hyper_mods or {"cmd", "alt", "ctrl", "shift"}
    log("Using modifiers: " .. table.concat(mods, ","))

    -- Bind each leader key
    for leaderKey, leaderConfig in pairs(config.leaders) do
        log("Binding leader: " .. leaderKey)

        hs.hotkey.bind(mods, leaderKey, function()
            log("Leader " .. leaderKey .. " activated")
            createModal(leaderConfig, leaderConfig.label, nil, true, leaderKey)
        end)
    end

    log("Leaderflow ready")
end

function Leaderflow:stop()
    log("Stopping Leaderflow")
    stopModal()
end

return Leaderflow
