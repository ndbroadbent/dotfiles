local window = require "hs.window"
local spaces = require "hs.spaces"

function getGoodFocusedWindow(nofull)
    local win = window.focusedWindow()
    if not win or not win:isStandard() then return end
    if nofull and win:isFullScreen() then return end
    return win
end

function moveWindowToSpace(win, space)
    if not win then return end
    local screen = win:screen()
    local uuid = screen:getUUID()
    local userSpaces = nil
    for k,v in pairs(spaces.allSpaces()) do
        userSpaces = v
        if k == uuid then break end
    end
    if not userSpaces then return end

    for i, spc in ipairs(userSpaces) do
        if spaces.spaceType(spc) ~= "user" then
            table.remove(userSpaces, i)
        end
    end
    if not userSpaces then return end

    local currentCursor = hs.mouse.getRelativePosition()
    local zoomPoint = hs.geometry(win:zoomButtonRect())
    local safePoint = zoomPoint:move({-1,-1}).topleft

    hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.leftMouseDown, safePoint):post()
    spaces.moveWindowToSpace(win, space)
    hs.timer.waitUntil(
        function() return spaces.windowSpaces(win)[1] == space end,
        function()
            hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.leftMouseUp, safePoint):post()
            hs.mouse.setRelativePosition(currentCursor)
        end,
        0.05
    )
end

local obsApp = hs.application.find("OBS Studio")
if obsApp then
    local projectorWindow = nil
    for _, window in pairs(obsApp:allWindows()) do
        if string.find(window:title(), "Projector") then
            projectorWindow = window
            break
        end
    end
    if projectorWindow then
        moveWindowToSpace(projectorWindow, 5)
        print("Moved projector window to space 5")
    end
end
