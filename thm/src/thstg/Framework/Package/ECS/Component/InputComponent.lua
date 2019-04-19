

local ETouchExType = DEFINITION.ETouchExType
local M = class("InputComponent",ECS.Component)

function M:_onInit()
    self.keyMapper = UTIL.newControlMapper()
    self.touchState = ""
    self.touchPos = nil

    self._touchListener = nil
    self._keyboardListener = nil
end
---

function M:isKeyDown(type)
    return self.keyMapper:isKeyDown(type)
end

function M:resetKey(type)
    return self.keyMapper:resetKey(type)
end

function M:getTouchState()
    return self.touchState
end

function M:getTouchPos()
    return self.touchPos
end
--
function M:_setTouchs(touchs)
    if touchs then 
        touchs:retain()
        self.touchs = touchs
    else
        if self.touchs then
            self.touchs:release()
            self.touchs = nil
        end
    end
end
---
function M:_onAdded(entity)

    self._keyboardListener = EVENT.newKeyboardExListener({
        onPressed = function (keyCode, event)
            self.keyMapper:pressKey(keyCode)
        end,

        onReleased = function(keyCode, event)
            self.keyMapper:releaseKey(keyCode)
        end,
    })

    self._touchListener = EVENT.newTouchAllAtOnceExListener({
        onBegan = function(touches, event)
            self.keyMapper:pressKey(ETouchExType.OnceClick)
            self.touchState = "onBegan"
            self.touchPos = touches[1]:getLocation()
            return true
        end,
        onMoved = function(touches, event)
            if #touches > 1 then
                self.keyMapper:pressKey(ETouchExType.MultiTouch)
            end
            self.touchState = "onMoved"
            self.touchPos = touches[1]:getLocation()
        end,
        onEnded = function(touches, event)
            self.keyMapper:releaseKey(ETouchExType.OnceClick)
            self.keyMapper:releaseKey(ETouchExType.Shake)
            self.keyMapper:releaseKey(ETouchExType.DoubleClick)
            if #touches > 1 then
                self.keyMapper:releaseKey(ETouchExType.MultiTouch)
            end
            self.touchState = "onEnded"
            self.touchPos = touches[1]:getLocation()
        end,
        onDoubleClick = function(touches, event)
            self.keyMapper:pressKey(ETouchExType.DoubleClick)
        end,
        onShaked = function(touches, event)
            self.keyMapper:pressKey(ETouchExType.Shake)
        end,
    })


    CCDispatcher:addEventListenerWithSceneGraphPriority(self._keyboardListener, entity)
    CCDispatcher:addEventListenerWithSceneGraphPriority(self._touchListener, entity)
end

function M:_onRemoved(entity)
    CCDispatcher:removeEventListener(self._keyboardListener)
    CCDispatcher:removeEventListener(self._touchListener)
end

function M:_onLateUpdate()
    if self.touchState ~= "onMoved" then
        self.touchState = ""
        self.touchPos = nil
    end
end


return M